({
    onRecordEvent : function(component, event, helper) {
        let eventParams = event.getParams();
        if(eventParams.changeType=='LOADED'){
            let data=component.get('v.accountRecordRecord');
            helper.callServer(component,'getLastEmailToAccountInfo',function(response){
                let state = response.getState();
                let data = response.getReturnValue();
                if (state === "SUCCESS") {
                    data.forEach(function(track){
                        track.User__c=track.User__r.Name;
                    })
                    let productEmailDates={};
                    let groupByProduct=data.reduce(function(total,current){
                        total[current.New_Value__c]=[...total[current.New_Value__c] || [], current];
                        return total;
                    },{});
                    console.log('groupByProduct',groupByProduct)
                    for(let product in groupByProduct){
                         let latestDate=groupByProduct[product].sort(function(a, b) {
                            a = new Date(a.CreatedDate);
                            b = new Date(b.CreatedDate);
                            return a>b ? -1 : a<b ? 1 : 0;
                        })[0]['CreatedDate'];
                        productEmailDates[product.replace(/ /g,'_')]=helper.getLocalDate(latestDate);
                    }
                    component.set('v.emailSendInfo',productEmailDates);
                }
                else if (state === "ERROR") {
                    let errors = response.getError();
                    console.error(errors);
                }
                component.set('v.loader',false);
            },{
                accountId:component.get('v.recordId'),
            })
        }
    },
    close:function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
    sendEmail:function(component, event, helper) {
        let data=component.get('v.accountRecordRecord');
        let sendNewsletterEmail=component.get('v.sendNewsletterEmail');
        let sendProductAEmail=component.get('v.sendProductAEmail');
        let sendProductBEmail=component.get('v.sendProductBEmail');
        let sendProductCEmail=component.get('v.sendProductCEmail');
        let sendProductDEmail=component.get('v.sendProductDEmail');
        let sendEmailTo={
            newsletter:false,
            productA:false,
            productB:false,
            productC:false,
            productD:false
        };
       if(sendNewsletterEmail=='true' && (data.Newsletter__pc===helper.AWAITING || data.Newsletter__pc===helper.RESEND)){
            sendEmailTo.newsletter=true;
        }
        if(sendProductAEmail=='true' && (data.Product_A__pc===helper.AWAITING || data.Product_A__pc===helper.RESEND)){
            sendEmailTo.productA=true;
        }
        if(sendProductBEmail=='true'  && (data.Product_B__pc===helper.AWAITING || data.Product_B__pc===helper.RESEND)){
            sendEmailTo.productB=true;
        }
        if(sendProductCEmail=='true' && (data.Product_C__pc===helper.AWAITING || data.Product_C__pc===helper.RESEND)){
            sendEmailTo.productC=true;       
        }
        if(sendProductDEmail=='true' && (data.Product_D__pc===helper.AWAITING || data.Product_D__pc===helper.RESEND)){
            sendEmailTo.productD=true;
        }
      
        component.set('v.loader',true);
        helper.callServer(component,'sendEmailToAccount',function(response){
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                console.log(data);
                $A.get('e.force:refreshView').fire();
                $A.get("e.force:closeQuickAction").fire();
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                console.error(errors);
                $A.get("e.force:closeQuickAction").fire();
            }
            component.set('v.loader',false);
        },{
            accountId:data.Id,
            emailToProducts:JSON.stringify(sendEmailTo)
        })
        
    }
})