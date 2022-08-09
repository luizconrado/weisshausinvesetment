({
    callApex:function(component,actionName,callback,params){
        let action = component.get("c."+actionName);
        if(params)
            action.setParams(params);
        action.setCallback(this,callback);
        $A.enqueueAction(action);
    },
    closePopup:function(component) {
        $A.get("e.force:closeQuickAction").fire();
    },
    
})