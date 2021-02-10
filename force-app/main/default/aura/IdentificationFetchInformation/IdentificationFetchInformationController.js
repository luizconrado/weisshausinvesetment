({
    Save : function(component, event, helper) {
        component.set('v.loading',true);
        helper.callApex(component,'retriveIdentificationDetailsAndUpdate',function(response){
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                $A.get('e.force:refreshView').fire();
                helper.showToast('Success','Sync Successfull.','success');
                
                component.set('v.loading',false);
                $A.get("e.force:closeQuickAction").fire();
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                helper.showToast('Error','Please Contact system admin.If probelem Continues','Error');
                console.error(JSON.stringify(errors));
                $A.get("e.force:closeQuickAction").fire();
            }
        },{
            identifiactionId:component.get('v.recordId')
        })
    },
    close : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }
})