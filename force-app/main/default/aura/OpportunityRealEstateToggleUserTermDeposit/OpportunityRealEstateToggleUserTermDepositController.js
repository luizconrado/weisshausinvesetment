({
    onInit: function(component, event, helper) {
        component.set('v.loading',true);
        helper.callApex(component,'getTermDepositeStatus',function(response){
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
               component.set('v.isDisabled',data);
                component.set('v.status',data+'');
                 
               
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                console.error(errors);
            }
            component.set('v.loading',false);
        },{
            recordId:component.get('v.recordId')
        });
    },
    closeAction : function(component, event, helper) {
       helper.closePopup();
    },
	toggle : function(component, event, helper) {
		let status=component.get('v.status');
        component.set('v.loading',true);
        
        helper.callApex(component,'toggleTermDepostForUser',function(response){
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                if(data){
                    component.find('notifLib').showToast({
                        "title": "Success!",
                        "message": "Status Changed Successfully",
                        "variant":"success"
                    });
                    $A.get('e.force:refreshView').fire(); 
                }
                else{
                    component.find('notifLib').showToast({
                        "title": "Error",
                        "message": "Error during status change. Please contact your system administartor.",
                        "variant":"error"
                    });
                    $A.get('e.force:refreshView').fire(); 
                }
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                console.error(errors);
                component.find('notifLib').showToast({
                    "title": "Error",
                    "message": "Error during status change. Please contact your system administartor.",
                    "variant":"error"
                });
                $A.get('e.force:refreshView').fire(); 
            }
            
            component.set('v.loading',false);
            helper.closePopup();
        },{
            recordId:component.get('v.recordId'),
            status:( component.get('v.status')  === 'true')
        });
	}
})