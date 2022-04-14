({
    onInit : function(component, event, helper) {
        helper.callApex(component,'getAllRealEstateImageLinks',function(response){
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
              
                component.set('v.assetLinks',data);
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                console.error(errors);
            }
        },{
            recordId:component.get('v.recordId')
        })
    }
})