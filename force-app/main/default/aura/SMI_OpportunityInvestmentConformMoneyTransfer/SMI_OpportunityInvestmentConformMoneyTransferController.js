({
    closeAction : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
    startSync: function (component,event, helper) {
        component.set('v.loading',true);
        let action = component.get("c.sendMoneyTransferConformation");
        action.setParams({ oppId: component.get('v.recordId') });
        
        action.setCallback(this, function (response) {
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                component.set('v.loading',false);
                helper.showToast(
                     "Success!",
                     "Confirmation Successfull",
                    "success"
                );
                $A.get('e.force:refreshView').fire(); 
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                console.error(errors);
                helper.showToast(
                     "Error!",
                     errors[0].message,
                    "error"
                );
                component.set('v.loading',false);
            }
            $A.get("e.force:closeQuickAction").fire();
        });
        $A.enqueueAction(action);
    }
})