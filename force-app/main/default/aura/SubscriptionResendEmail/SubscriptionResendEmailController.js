({
    onRecordLoad : function(component, event, helper) {
        let eventParams = event.getParams();
        if(eventParams.changeType=='LOADED'){
            let record=component.get("v.subscriptionRecord");
            console.log('record',JSON.stringify(record))
            
            helper.callServer(component,'getLastEmailSentInfo',function(response){
                let state = response.getState();
                let data = response.getReturnValue();
                if (state === "SUCCESS") {
                    data.forEach(function(track){
                        track.User__c=track.User__r.Name;
                    })
                    console.log('data',data)
                    let productEmailDates={};
                    let groupByValue=data.reduce(function(total,current){
                        total[current.New_Value__c]=[...total[current.New_Value__c] || [], current];
                        return total;
                    },{});
                    console.log('groupByValue',groupByValue)
                    for(let product in groupByValue){
                        let latestDate=groupByValue[product].sort(function(a, b) {
                            a = new Date(a.CreatedDate);
                            b = new Date(b.CreatedDate);
                            return a>b ? -1 : a<b ? 1 : 0;
                        })[0]['CreatedDate'];
                        console.log('latestDate',latestDate)
                        if(product=='true'){
                            let finalDate=helper.getLocalDate(latestDate);  
                            component.set('v.emailSendInfo',finalDate);
                        }
                        
                    }
                    
                    
                    
                    
                }
                else if (state === "ERROR") {
                    let errors = response.getError();
                    console.error(errors);
                }
                component.set('v.loader',false);
            },{
                subscriptionId:component.get('v.recordId'),
            })
            
        }
    },
    onSave:function(component, event, helper){
        let subscriptionRecord=component.get('v.subscriptionRecord');
        if(subscriptionRecord.Subscription_Status__c=='Confirmation Resent'){
            console.log('subscriptionRecord',subscriptionRecord);
            
            subscriptionRecord.Send_Mail__c=true;
            
            component.set('v.subscriptionRecord',subscriptionRecord);
            
            component.find("recordLoader").saveRecord($A.getCallback(function(saveResult) {
                helper.showToast('Success','Email sent to customer successfully.','success');
                $A.get('e.force:refreshView').fire();
                $A.get("e.force:closeQuickAction").fire();
            }));
        }
    },
    onClose:function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
})