({
    onInit : function(component, event, helper) {
        helper.callApex(component,'checkIsCompactLayout',function(response){
            let data = response.getReturnValue();
            component.set('v.isCompactLayout',data);
        })
          component.set('v.loading',true);
        helper.callApex(component,'retriveBalanceDetails',function(response){
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                let result = JSON.parse(data);
                result.price=helper.formatCurrency(result.balance.value/100);
                result.avil_price=helper.formatCurrency(result.available_balance.value/100);
                console.log('result',result)
                component.set('v.loading',false);
                component.set('v.tempBalance',result);
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                helper.showToast('Error','Please Contact system admin.If probelem Continues','Error');
                console.error(JSON.stringify(errors));
                $A.get("e.force:closeQuickAction").fire();
            }
        },{
            bankcaseId:component.get('v.recordId')
        })
    },
    close:function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
})