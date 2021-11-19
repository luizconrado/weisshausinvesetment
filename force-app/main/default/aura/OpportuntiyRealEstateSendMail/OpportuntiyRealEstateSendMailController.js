({
	onInit : function(component, event, helper) {
        component.set('v.loadingIFrame',true);
		helper.callApex(component,'getRealEstateSaleEmailPreview',function(response){
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                component.set('v.emailTemplateBody',data.BODY);
                component.set('v.emailTemplateSubject',data.SUBJECT);
                component.set('v.emailSentTo',data.EMAIL);
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                console.error(errors);
            }
            component.set('v.loadingIFrame',false);
        },{
            recordId:component.get('v.recordId')
        });
	},
    close:function(component, event, helper) {
       helper.closePopup(component);
    },
    save:function(component, event, helper) {
        let email=component.get('v.emailSentTo');
        if(!email){
            component.find('notifLib').showToast({
                "title": "Error",
                "message": "Please enter to address.",
                "variant":"error"
            });
            return;
        }
        component.set('v.loading',true);
        helper.callApex(component,'sendEmailToAgent',function(response){
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                console.log('success');
                component.find('notifLib').showToast({
                    "title": "Success",
                    "message": "Email Sent.", 
                    "variant":"success"
                });
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                console.error(errors);
                 component.find('notifLib').showToast({
                    "title": "Error",
                    "message": "Please try again error while sending email.", 
                    "variant":"Error"
                });
            }
            helper.closePopup(component);
            component.set('v.loading',false);
        },{
            body:component.get('v.emailTemplateBody'),
            subject:component.get('v.emailTemplateSubject'),
            recordId:component.get('v.recordId'),
            emailTo:email.trim()
        }); 
    },
    handleTabChange:function(component,event,helper){
        let selected = component.get("v.tabId");
        if(selected=='2'){
            window.setTimeout(
                $A.getCallback(function() { 
                    let previewContainer=component.find('previewContainer');
                    if(previewContainer)previewContainer.relodeData();  
                }), 200
            );  
        }
        
    },
})