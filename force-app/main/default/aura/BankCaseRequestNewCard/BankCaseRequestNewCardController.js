({
    onInit:function(component, event, helper) {
        component.set('v.loader',true);
        helper.callApex(component,'getBankCaseDetails',function(response){
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                
                helper.callApex(component,'getSuccessKYCIdentificationRecord',function(response){
                    let stateKYC = response.getState();
                    let dataKYC = response.getReturnValue();
                    console.log('data',dataKYC,stateKYC)
                    if (stateKYC === "SUCCESS") {
                        
                        component.set('v.bankCaseDetails',data);
                        if(data.Bank_Account__r.Person_Account__r){
                            component.set('v.fName',(data.Bank_Account__r.Person_Account__r)?data.Bank_Account__r.Person_Account__r.FirstName:'');
                            component.set('v.lName',(data.Bank_Account__r.Person_Account__r)?data.Bank_Account__r.Person_Account__r.LastName:'');
                        }
                        //if user is not freelanser and sef employed all cards are visa debit
                        if(dataKYC.length>0 && dataKYC[0].Employment_Status__c.toUpperCase()=='FREELANCER' || dataKYC[0].Employment_Status__c.toUpperCase()=='SELF_EMPLOYED'){
                            component.set('v.typeSelected','VISA_BUSINESS_DEBIT');
                        }
                        else{
                            component.set('v.typeSelected','VISA_DEBIT');
                        }
                    }
                    component.set('v.loader',false);
                },{ 
                    "accountId":data.Bank_Account__r.Person_Account__c
                });
                
                
            }
            else if (state === "ERROR") {
            }
          
        },{
            recordId:component.get('v.recordId')
        });
     
    },
    close:function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
    save:function(component, event, helper) {
        let typeSelected = component.get('v.typeSelected');
        let fName = component.get('v.fName');
        let lName = component.get('v.lName');
        let  sName= component.get('v.sName');
        
         if( !fName.trim()){
            helper.showToast('Warrning','Please Enter First Name','warning');
            return;
        } 
        else if(!lName.trim()){
            helper.showToast('Warrning','Please Enter First Name','warning');
            return;
        } 
         
        else if( fName && lName ){
                let txt=fName+lName ;
                if(txt.length>20){
                    helper.showToast('Warrning','Please make sure first,last and surname name combined is less then 20 characters','warning');
                    return;
                }  
            }
        let randomString=helper.generateRandomString(6);
        let body={
            type:typeSelected,
            line_1:fName+'/'+lName,
            reference:randomString
        }
        component.set('v.loader',true);
        helper.callApex(component,'requestCreateNewCard',function(response){
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                let res=JSON.parse(data);
                console.log('result',data)
                if(res.errors){
                    component.set('v.errorDetails',res.errors[0]);
                    component.set('v.isError',true);
                }
                else{
                    component.set('v.isError',false);
                    helper.showToast('Success','Request for new card submited successfully.','success');
                    $A.get('e.force:refreshView').fire();
                    $A.get("e.force:closeQuickAction").fire();
                }
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                let errMsg='Please Contact system admin.If probelem Continues';
                if(errors[0] && errors[0].message)  errMsg=errors[0].message;
                helper.showToast('Error',errMsg,'Error');
                console.error(JSON.stringify(errors));
                $A.get("e.force:closeQuickAction").fire();
            }
            component.set('v.loader',false);
        },{
            bankCaseId:component.get('v.recordId'),
            body:JSON.stringify(body)
        });
        
     },
    
})