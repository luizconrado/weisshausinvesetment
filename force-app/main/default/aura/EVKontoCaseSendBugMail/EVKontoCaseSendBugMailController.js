({
    closeAction : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
    processInfo: function (component) {
        component.set('v.loading',true);
        let action = component.get("c.prepareBugInfoBody");
        action.setParams({ caseId: component.get('v.recordId') });
        
        action.setCallback(this, function (response) {
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                component.set('v.loading',false);
                component.find('notifLib').showToast({
                    "title": "Success!",
                    "message": "Body processed successfully",
                    "variant":"success"
                });
                 $A.get('e.force:refreshView').fire(); 
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                console.error(errors);
                component.find('notifLib').showToast({
                    "title": "Error!",
                    "message": "processig failed please try again",
                    "variant":"error"
                });
                component.set('v.loading',false);
            }
            $A.get("e.force:closeQuickAction").fire();
        });
        $A.enqueueAction(action);
    }
})