({
	onInit : function(component, event, helper) {
        helper.callApex(component,'getScheludedOrderTypes',function(response){
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                let statusTypes=Object.keys(data).map(function(values){
                    return {
                        label:data[values],
                        value:values,
                        selected:false
                    }
                });
                console.log('statusTypes',statusTypes)
                component.set('v.statusTypes',statusTypes);
                
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                console.log(errors);
            }
        });
        helper.callApex(component,'getBankCaseDetails',function(response){
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                console.log('data',data)
                component.set('v.bankCaseDetails',data);
                component.set('v.selectedType',data.Scheduled_Order__r.Status__c);
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                console.log(errors);
            }
        },{
            recordId:component.get('v.recordId')
        });
        
		
	},
    cancleStatus : function(component, event, helper) {
		let reason=component.get('v.reason');
        if(!reason){
            helper.showToast('Reason missing','Plese provide reason.','warning');
            return;
        }
        component.set('v.loading',true);
          helper.callApex(component,'requestCancleTimedOrder',function(response){
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                helper.showToast('Success','Timed Order Canceled.','success');
                $A.get("e.force:closeQuickAction").fire();
                $A.get('e.force:refreshView').fire();
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                console.log(errors);
                $A.get("e.force:closeQuickAction").fire();
            }
               component.set('v.loading',false);
          },{
              bankCaseDetails:component.get('v.bankCaseDetails'),
              reason:reason
          });
	},
    close:function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }
})