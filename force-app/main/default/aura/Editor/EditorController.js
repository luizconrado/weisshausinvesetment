({
    reloadValue:function(component, event, helper) {
        helper.postMessage(component,'change',component.get('v.htmlString'));
    },
    onInit : function(component, event, helper) {
        
        component.set('v.uniqueId',helper.generateRandomString(10));
        let isEditor=component.get('v.isEditor')
        let height=component.get('v.height');
        height=parseInt(height)+120;
        component.set('v.iframeheight',height);
        let vfOrigin = "https://" + component.get("v.vfHost");
        
        
        
        window.addEventListener("message", function(event) {
            
            if (event.origin !== vfOrigin) {
                // Not the expected origin: Reject the message!
                return;
            }
            // Handle the message
            if(event.data!=undefined){
                if(event.data.event=='init'){
                    helper.postMessage(component,'init',component.get('v.htmlString'));
                }
                if(event.data.id!=undefined && event.data.id!=component.get('v.uniqueId')){
                    return;
                }
                else if(event.data.event=='change'){
                    let value=event.data.value;
                    component.set('v.htmlString',value);
                }
            }
            
            
        }, false);  
        
        
    } 
})