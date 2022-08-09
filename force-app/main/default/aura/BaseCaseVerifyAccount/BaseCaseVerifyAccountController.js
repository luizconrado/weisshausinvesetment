({
	onInit : function(component, event, helper) {
        helper.callApex(component,'getCaseDetails',function(response){
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                console.log('data',data)
                component.set('v.caseDetails',data[0])
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                console.log(errors);
            }
        },{
            caseId:component.get('v.recordId')
        })
	},
    close:function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
    verifyUser:function(component, event, helper){
        let isNameVerified = component.get('v.isNameVerified');
        let isPhoneVerified = component.get('v.isPhoneVerified');
        let isBirthVerified = component.get('v.isBirthVerified');
        let isAddressVerified = component.get('v.isAddressVerified');
        let recordId = component.get('v.recordId');
        
        let Case_Verification__c = {}
        Case_Verification__c.Case__c = recordId;
        Case_Verification__c.Address_Verfied__c = isAddressVerified;
        Case_Verification__c.Birthdate_Verified__c = isBirthVerified;
        Case_Verification__c.Name_Verified__c = isNameVerified;
        Case_Verification__c.Phone_Verified__c = isPhoneVerified;
        
            helper.callApex(component,'logVarification',function(response){
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                helper.showToast('Success','User Verficiation Logged.','success');
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                console.error(JSON.stringify(errors));
                helper.showToast('Failed','User Verficiation Failed.','error');
            }
                $A.get("e.force:closeQuickAction").fire();
        },{
            cv:Case_Verification__c
        })
        
    }
})