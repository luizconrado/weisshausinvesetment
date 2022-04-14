({
    onInit:function(component,event,helper){
        helper.callApex(component,'getBankCaseDetails',function(response){
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                
                if(data.Account__r.Preferred_Language__pc=='de'){
                	component.set('v.selectedType','DE');    
                }
                else if(data.Account__r.Preferred_Language__pc=='en_US'){
                	component.set('v.selectedType','EN');    
                }
                
                
                
            }
            else if (state === "ERROR") {
            }
            component.set('v.loader',false);
        },{
            recordId:component.get('v.recordId')
        });
        
    },
    save : function(component, event, helper) {
        component.set('v.loading',true);
       
        helper.callApex(component,'createNewIdentification',function(response){
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                $A.get('e.force:refreshView').fire();
                helper.showToast('Success','New Person Identification is created.','success');

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
            recordId:component.get('v.recordId'),
            languageCode:component.get('v.selectedType')
        })
    },
    close : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
        
    },
})