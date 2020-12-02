({
    afterRender: function (component, helper) {
        this.superAfterRender();
        let value = helper.getParameterByName(component , event, 'inContextOfRef');
        let context = JSON.parse(window.atob(value));
        let caseId=context.attributes.recordId;
        helper.callApex(component,'getBankCaseTypes',function (response) {
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                let caseTypes=Object.keys(data).map(function(values){
                    return {
                        label:data[values],
                        value:values,
                        selected:false
                    }
                });
                component.set('v.caseTypes',caseTypes);
                component.set('v.typeLoaded',true);
                helper.retriveCaseDetails(component,caseId);
                
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                console.log(errors);
            }
        });
        helper.callApex(component,'getCaseIITypes',function (response){
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                component.set('v.caseIITypes',data);
                component.set('v.subTypeLoaded',true);
                helper.retriveCaseDetails(component,caseId);
            }
            else if (state === "ERROR") {
                
            }
        });
    },
})