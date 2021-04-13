({
	 callApex:function(component,actionName,callback,params){
        let action = component.get("c."+actionName);
        if(params)
            action.setParams(params);
        action.setCallback(this,callback);
        $A.enqueueAction(action);
    },
    
    showToast:function(title,message,type){
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type":type
        });
        toastEvent.fire();
    },
    generateRandomString:function(length){
        const characters ='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
        let result = '';
        const charactersLength = characters.length;
        for ( let i = 0; i < length; i++ ) {
            result += characters.charAt(Math.floor(Math.random() * charactersLength));
        }
        
        return result;
    }
    

})