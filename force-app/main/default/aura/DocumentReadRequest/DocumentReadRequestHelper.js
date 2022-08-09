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
    startTimer:function (component) {
        const refreshIntervalId =  setInterval(calculate, 1000);
        component.set('v.refreshIntervalId',refreshIntervalId);
        let endDate =  new Date();
        endDate=endDate.setSeconds(endDate.getSeconds()+299);
        endDate=endDate.getTime();
        //called every second
        function calculate() {
            let startDate = new Date();
            
            startDate = startDate.getTime();
            var t = endDate - startDate;
            var days = Math.floor(t / (1000 * 60 * 60 * 24)); 
            var hours = Math.floor((t%(1000 * 60 * 60 * 24))/(1000 * 60 * 60)); 
            var minutes = Math.floor((t % (1000 * 60 * 60)) / (1000 * 60)); 
            var seconds = Math.floor((t % (1000 * 60)) / 1000); 
            
            if (t >= 0) {
                component.set('v.min', (minutes>9)?minutes:'0'+minutes);
                component.set('v.sec',(seconds>9)?seconds:'0'+seconds);
            } 
            else {
                let refreshIntervalId=component.get('v.refreshIntervalId');
                clearInterval(refreshIntervalId);
                component.set('v.showPdf',false);
            }
        }
    }
})