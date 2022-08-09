({
    closeAction : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
    startSync: function (component) {
        component.set('v.loading',true);
        let action = component.get("c.startSyncWithBankAccount");
        action.setParams({ sfBankAccountId: component.get('v.recordId') });
        
        action.setCallback(this, function (response) {
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                component.set('v.loading',false);
                component.find('notifLib').showToast({
                    "title": "Success!",
                    "message": "Sync Successfull",
                    "variant":"success"
                });
                 $A.get('e.force:refreshView').fire(); 
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                console.error(errors);
                component.find('notifLib').showToast({
                    "title": "Error!",
                    "message": "Sync failed please try again",
                    "variant":"error"
                });
                component.set('v.loading',false);
            }
            $A.get("e.force:closeQuickAction").fire();
        });
        $A.enqueueAction(action);
    }
})