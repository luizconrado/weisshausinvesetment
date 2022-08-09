({
    handleSelect : function(component, event, helper) {
        let selectedMenuItemValue = event.getParam("value");
      
        if(selectedMenuItemValue=='Toggle_Term_Deposit'){
            component.set('v.isOpen',true);
            component.set('v.isDepositToggle',true);
            helper.getCurrentDepostiStatus(component);
        }
        
    },
    handleClose:function(component,event,helper){
        helper.close(component);
    },
    changeTermStatus:function(component,event,helper){
        let status=component.get('v.termDepositStatus');
        component.set('v.loading',true);
        let reasonForChange=component.get('v.termDepositReason');
         
        helper.callApex(component,'toggleTermDepostForUser',function(response){
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                if(data){
                    helper.showToast('Success','Status Changed Successfully','success'); 
                }
                else{
                    helper.showToast('Error','Error during status change. Please contact your system administartor','error'); 
                    
                }
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                console.error(errors);
                helper.showToast('Error','Error during status change. Please contact your system administartor','error'); 
                
            }
            $A.get('e.force:refreshView').fire();
            component.set('v.loading',false);
            helper.close(component);
        },{
            recordId:component.get('v.recordId'),
            status:( status  === 'true'),
            termDepositReason:reasonForChange
        });
    },
})