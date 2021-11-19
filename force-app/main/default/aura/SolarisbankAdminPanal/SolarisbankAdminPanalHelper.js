({
    getCurrentDepostiStatus: function(component) {
        let helper=this;
        component.set('v.loading',true);
        helper.callApex(component,'getTermDepositeStatus',function(response){
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                component.set('v.termDepositStatus',data+'');
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
    //helper
    close : function(component) {
        component.set('v.isOpen',false);
        component.set('v.isDepositToggle',false); 
        
    },
    showToast: function (title, message, type) {
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire();
    },
    callApex: function (component, actionName, callback, params) {
        let action = component.get("c." + actionName);
        if (params)
            action.setParams(params);
        action.setCallback(this, callback);
        $A.enqueueAction(action);
    },
})