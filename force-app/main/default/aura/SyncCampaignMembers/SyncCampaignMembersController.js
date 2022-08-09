({
    sync : function(component, event, helper) {
        try{
            component.set('v.loader',true);
            helper.callApex(component,'startSync',function(response){
                let status=response.getState();
                if (status === "SUCCESS"){
                    helper.toast('success','Sync Complete','New Contacts/Leads Added Successfully.');
                    $A.get('e.force:refreshView').fire(); 
                }
                else if (status === "ERROR") {
                    helper.toast('error','Sync Error','Please try again or contact your system administrator.');
                }
                
                $A.get("e.force:closeQuickAction").fire();
                component.set('v.loader',false);
            },{
                campaignId:component.get('v.recordId')
            });
        }
        catch(e){
            console.error(e);
        }
    },
    close:function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }
})