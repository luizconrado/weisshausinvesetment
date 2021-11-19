({
    //invoked by save method from controller
    postMessage : function(component,mode,data) {
        
        let vfOrigin = "https://" + component.get("v.vfHost");
        let vfWindowComp = component.find("vfFrame");
        let uniqueId = component.get("v.uniqueId");
        let height=component.get('v.height');
        //checking if true
        if(vfWindowComp){
            let vfWindow=vfWindowComp.getElement().contentWindow;
            let transferMsg={};
            transferMsg.value=data;
            transferMsg.height=height;
            transferMsg.mode=mode;
            transferMsg.id=uniqueId;
            //sending message to iframe
            vfWindow.postMessage(transferMsg, vfOrigin);    
        }
        
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