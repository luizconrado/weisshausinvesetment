({
	onSave : function(component, event, helper) {
        event.preventDefault();   
        let fields = event.getParam('fields');
        fields.OwnerId=$A.get("$SObjectType.CurrentUser.Id");
        component.find('ownerRecordForm').submit(fields);
        component.set('v.loading',true)
	},
    close: function(component, event, helper) {
    $A.get("e.force:closeQuickAction").fire();
    },
    onSuccess: function(component, event, helper) {
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": 'Owner Changed',
            "message": 'Case is assigned to you successfully',
            "type": 'success'
        });
        toastEvent.fire();
        $A.get('e.force:refreshView').fire();
        $A.get("e.force:closeQuickAction").fire();
      
 }
 
})