({
    handleCancle : function(component, event, helper) {
        component.set('v.showDisclaimer',false);
    },
    handlePreview:function(component, event, helper){
        component.set('v.showDisclaimer',true)
    },
    handleFetch:function(component, event, helper){
        component.set('v.loading',true);
        
        
        
        helper.callApex(component,'requestDocumentUrl',function(response){
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") { 
                let pdfFiledDetails=JSON.parse(data);
             
                if(pdfFiledDetails.pdfFile){
                	component.set('v.pdfUrlBase64',pdfFiledDetails.pdfFile+'#toolbar=0');
                }
                else if(pdfFiledDetails.url){
                    component.set('v.pdfUrlBase64',pdfFiledDetails.url+'#toolbar=0');
                }
                component.set('v.loading',false);
                component.set('v.showDisclaimer',false);
                component.set('v.showPdf',true);
                
               helper.startTimer(component);
                
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                let errorMsg='Please Contact system admin.If probelem Continues';
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        errorMsg=errors[0].message;
                    }
                }
                helper.showToast('Error',errorMsg,'Error');
                console.error(JSON.stringify(errors));
                
                //close ui
                component.set('v.loading',false);
                component.set('v.showDisclaimer',false);
                
            }},{
                documentId:component.get('v.recordId')
            })
        
    }
})