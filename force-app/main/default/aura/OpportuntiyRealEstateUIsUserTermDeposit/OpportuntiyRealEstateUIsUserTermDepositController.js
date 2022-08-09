({
	onInit : function(component, event, helper) {
        helper.callApex(component,'getTermDepositeStatus',function(response){
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                component.set('v.termStatus',data);
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                console.error(errors);
            }
            component.set('v.loading',false);
        },{
            recordId:component.get('v.recordId')
        });
	}
})