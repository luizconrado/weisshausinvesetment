({
    onInit:function(component, event, helper) {
        helper.callApex(component,'getCardStatusTypes',function(response){
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                let cardTypes=Object.keys(data).map(function(values){
                    return {
                        label:data[values],
                        value:values,
                        selected:false
                    }
                });
                
                component.set('v.cardTypes',cardTypes);
              
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                console.error(errors);
            }
        });
        component.set('v.loader',true);
        helper.callApex(component,'getBankCaseDetails',function(response){
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                 
                component.set('v.bankCaseDetails',data);
                
                let isBlock = (data.Card__r.Status__c === 'ACTIVE'  )?true:false;
                let isUnBlock = data.Card__r.Status__c === 'BLOCKED'
                let isClose = (data.Card__r.Status__c === 'INACTIVE' || data.Card__r.Status__c === 'ACTIVE' || data.Card__r.Status__c === 'BLOCKED'|| data[0].Status__c === 'PROCESSING') ? true : false;
                let isJira = (data.Card__r.Status__c === 'BLOCKED_BY_SOLARIS' ||data.Card__r.Status__c === 'ACTIVATION_BLOCKED_BY_SOLARIS' || data.Card__r.Status__c === 'CLOSED_BY_SOLARIS')?true:false;
                
                
                let statusTypes = [
                    { 
                        label:'',
                        value:'',
                        selected:true
                    }
                ];
                if(isBlock)
                    statusTypes.push({ 
                        label:'Block',
                        value:'Block',
                        selected:false
                    });
                if(isUnBlock)
                    statusTypes.push({ 
                        label:'Unblock',
                        value:'Unblock',
                        selected:false
                    });
                if(isClose)
                    statusTypes.push({ 
                        label:'Close',
                        value:'Close',
                        selected:false
                    });
                component.set('v.statusTypes',statusTypes);
                component.set('v.createJira',isJira);
                component.set('v.statusType','');
                window.setTimeout(
                    $A.getCallback(function() {
                        component.set('v.selectedType',data.Card__r.Status__c);
                    }), 500
                );
               
            }
            else if (state === "ERROR") {
            }
            component.set('v.loader',false);
        },{
            recordId:component.get('v.recordId')
        });
     
    },
    close:function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
    changeStatus:function(component, event, helper) {
        let createJira = component.get('v.createJira');
        let reason = component.get('v.reason');
        let bankCaseDetails = component.get('v.bankCaseDetails');
        let newStatus = component.get('v.statusType');
        if(!reason){
            helper.showToast('Reason missing.','Reason is required.','warning');
            return;
        }
        if(!newStatus){
            helper.showToast('Status missing.','Please select status.','warning');
            return;
        }
        component.set('v.loader',true);
        helper.callApex(component,'changeCardStatus',function(response){
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                $A.get("e.force:closeQuickAction").fire();
                $A.get('e.force:refreshView').fire();
                helper.showToast('Success.','Status Changed successfully.','success');
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                helper.showToast('Error','Please Contact system admin.If probelem Continues','Error');
                console.error(JSON.stringify(errors));
            }
            component.set('v.loader',false);
        },{
            bankCaseDetails:bankCaseDetails,
            newStatus:newStatus,
            reasonForChange:reason,
            isJira:createJira
        });
        
    },
    onTypeSelect:function(component, event, helper) {
         let selectedType=component.get('v.selectedType');
        
    },
})