({
   
    save : function(component, event, helper) {
        component.set('v.loading',true);
       
        helper.callApex(component,'createNewIdentification',function(response){
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                
                if(data.length==36){
                    $A.get('e.force:refreshView').fire();
                    helper.showToast('Success','New Person Identification is created.','success');   
                }
                else{
                    let errors = response.getError();
                    helper.showToast('Error',data,'Error');
                }
                
                

                
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                helper.showToast('Error','Please Contact system admin.If probelem Continues','Error');
                console.error(JSON.stringify(errors));
            }
            component.set('v.loading',false);
            $A.get("e.force:closeQuickAction").fire();
        },{
            recordId:component.get('v.recordId'),
            languageCode:component.get('v.selectedType')
        })
    },
    close : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
        
    },
})