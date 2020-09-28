({
	onRecordEvent : function(component, event, helper) {
        let eventParams = event.getParams();
        if(eventParams.changeType=='LOADED'){
            let data=component.get('v.leadRecordRecord');
        }
	},
    close:function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
    convert:function(component, event, helper) {
        let leadRecord=component.get('v.leadRecordRecord');
        let action = component.get("c.convertLeadToPersonAccount");
        action.setParams({ leadId: leadRecord.Id,leadEmail:leadRecord.Email });
        component.set('v.loader',true);
        action.setCallback(this, function (response) {
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    type:'success',
                    message: 'Lead conversion success.',
                    messageTemplate: 'Lead {0} successfully converted to {1}.',
                    messageTemplateData: [leadRecord.Name, 
                                          {
                                              url: '/lightning/r/Account/'+data+'/view',
                                              label: 'Person Account',
                                          }
                                         ]
                });
                toastEvent.fire();
                
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": data,
                     "slideDevName": "detail"
                });
                navEvt.fire();
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                console.log(errors[0].message);
            }
            component.set('v.loader',false);
               $A.get("e.force:closeQuickAction").fire();
        });
        $A.enqueueAction(action);
    }
})