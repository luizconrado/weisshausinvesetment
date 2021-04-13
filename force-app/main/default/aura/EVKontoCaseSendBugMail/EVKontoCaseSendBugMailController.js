({
    onInit:function(component,event,helper){
        component.set('v.loading',true);
        helper.callApex(component,'fetchBugBody',function(response){
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                component.set('v.bugBody',data);
  
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                helper.showToast('Error','Please Contact system admin.If probelem Continues','Error');
                console.error(JSON.stringify(errors));
                $A.get("e.force:closeQuickAction").fire();
            }
            component.set('v.loading',false);
        },{
            caseId:component.get('v.recordId')
        })
    },
    closeAction : function(component, event, helper) {
        helper.close(component);
    },
    processInfo: function (component) {
        try{
        component.set('v.loading',true);
        let action = component.get("c.prepareBugInfoBody");
        action.setParams({ 
            caseId: component.get('v.recordId'),
            bugBody:component.get('v.bugBody'),
            bugSubject:component.get('v.bugSubject')
        });
        
        action.setCallback(this, function (response) {
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                if(data){
                    component.find('notifLib').showToast({
                        "title": "Success!",
                        "message": "Email sent successfully",
                        "variant":"success"
                    });   
                }
                else{
                    component.find('notifLib').showToast({
                        "title": "Error!",
                        "message": "Email failed please try again",
                        "variant":"error"
                    });
                }
                
                $A.get('e.force:refreshView').fire(); 
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                console.error(errors);
                component.find('notifLib').showToast({
                    "title": "Error!",
                    "message": "Email failed please try again",
                    "variant":"error"
                });
                
            }
            component.set('v.loading',false);
            $A.get("e.force:closeQuickAction").fire();
        });
        $A.enqueueAction(action);
        }catch(e){console.log(e)}
    }
})