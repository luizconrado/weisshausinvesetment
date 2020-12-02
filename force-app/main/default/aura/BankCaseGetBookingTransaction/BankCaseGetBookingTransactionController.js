({
    onInit : function(component, event, helper) {
        helper.callApex(component,'checkIsCompactLayout',function(response){
            let data = response.getReturnValue();
            component.set('v.isCompactLayout',data);
        })
        helper.callApex(component,'fetchTrasnsactionDetails',function(response){
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                let result = JSON.parse(data);
                if (result.errors) {
                    if (result.errors.length > 0) {
                        let erroMessge = result.errors[0];
                        helper.showToast(erroMessge.title, erroMessge.detail, 'error');
                    }
                    component.set('v.loading',false);
                    return;
                }
                
                
                result.price = helper.formatCurrency(result.amount.value/100);
                result.created_at = helper.formatDateTime(result.created_at);
                component.set('v.loading',false);
                component.set('v.tempTransaction',result);
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                helper.showToast('Error','Please Contact system admin.If probelem Continues','Error');
                console.error(JSON.stringify(errors));
            }
        },{
            bankcaseId:component.get('v.recordId')
        })
    },
    close:function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
})