({
    //apex call
    retriveBankCaseDetails:function(component){
        let helper=this;
        component.set('v.loading',true);
        helper.callApex(component,'getBankCaseDetails',function(response){
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                 
                //salutationValues
                component.set('v.accountDetailsOrignal',JSON.parse(JSON.stringify(data.Account__r)));
                component.set('v.accountDetails',data.Account__r);
                console.log('result',data.Account__r)

                component.set('v.loading',false);
                
                
            }
            else if (state === "ERROR") {
                 let errors = response.getError();
                let errMsg='Please Contact system admin.If probelem Continues';
                if(errors[0] && errors[0].message)  errMsg=errors[0].message;
                helper.showToast('Error',errMsg,'Error');
                console.error(JSON.stringify(errors));
                $A.get("e.force:closeQuickAction").fire();
            }
        },{
            recordId:component.get('v.recordId')
        })
    },
    intitateCRPRequest:function(component){
        let requestBody =  component.get('v.accountDetailsChanged');
        let helper=this;
        console.log('requestBody',JSON.stringify(requestBody))
        component.set('v.loading',true);
        helper.callApex(component,'intitatePersonDetailsChangeTanRequest',function(response){ 
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                
                console.log('result',data)
                if(data.errors){
                    console.log('data.errors',data.errors)
                    component.set('v.errorDetails',data.errors[0]);
                    component.set('v.isError',true);
                    component.set('v.currentStep','2');
                }
                else{
                    component.set('v.isError',false);
                }
                
                component.set('v.loading',false);
                
                
                component.set('v.tanRequestResponse',data);
                
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                let errMsg='Please Contact system admin.If probelem Continues';
                if(errors[0] && errors[0].message)  errMsg=errors[0].message;
                helper.showToast('Error',errMsg,'Error');
                console.error(JSON.stringify(errors));
                $A.get("e.force:closeQuickAction").fire();
            }
        },{
            recordId:component.get('v.recordId'),
            requestChangebody:JSON.stringify(requestBody)
        });
                        
    },
    confrimTanRequest:function(component){
        let tanUrlDetails=component.get('v.tanRequestResponse');
        let tannumber=component.get('v.tannumber');
        let helper=this;
        console.log('requestBody',tanUrlDetails,tannumber)
        if(tanUrlDetails.url.endsWith('/authorize')){
            tanUrlDetails.url=tanUrlDetails.url.replace('/authorize','/confirm')
        }
        

         
        component.set('v.loading',true);
        helper.callApex(component,'confirmPersonDetailsChangeTanRequest',function(response){ 
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                let res=JSON.parse(data);
                console.log('result',res)
                if(res.status==='COMPLETED'){
                    helper.showToast('Success','User Details Update.','success');
                    $A.get('e.force:refreshView').fire();
                    helper.closepopup();
                }
                if(res.errors ){
                    console.log('data.errors',res.errors)
                    component.set('v.errorDetails',res.errors[0]);
                    component.set('v.isError',true);
                    component.set('v.currentStep','2');
                }
                component.set('v.loading',false);
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                let errMsg='Please Contact system admin.If probelem Continues';
                if(errors[0] && errors[0].message)  errMsg=errors[0].message;
                helper.showToast('Error',errMsg,'Error');
                console.error(JSON.stringify(errors));
                $A.get("e.force:closeQuickAction").fire();
                
            }
        },{
            recordId:component.get('v.recordId'),
            tanurl:tanUrlDetails.url,
            otp:tannumber
        });
        
    },
    //process
    findChangeAndPrepareJson:function(component){
        let accountDetailsOrignal=component.get('v.accountDetailsOrignal');
        let accountDetails=component.get('v.accountDetails');
        let line2=component.get('v.line2');
        
        let changes={};
        if(accountDetailsOrignal.PersonTitle != accountDetails.PersonTitle)changes.title=accountDetails.PersonTitle;
        if(accountDetailsOrignal.Salutation != accountDetails.Salutation)changes.salutation=accountDetails.Salutation;
        if(accountDetailsOrignal.Industry != accountDetails.Industry)changes.industry=accountDetails.Industry;
        if(accountDetailsOrignal.Industry_Key__c != accountDetails.Industry_Key__c)changes.industry_key=accountDetails.Industry_Key__c;
        
        if(line2){
            if(!changes.address)changes.address={};
            changes.address.line_2=line2;  
        }
        
        if(accountDetailsOrignal.BillingStreet != accountDetails.BillingStreet) {
            if(!changes.address)changes.address={};
            
            changes.address.line_1=accountDetails.BillingStreet;
              
            
        }
        if(accountDetailsOrignal.BillingCity != accountDetails.BillingCity) {
            if(!changes.address)changes.address={};
            changes.address.city=accountDetails.BillingCity;
        }
        if(accountDetailsOrignal.BillingCountry != accountDetails.BillingCountry) {
            if(!changes.address)changes.address={};
            changes.address.country=accountDetails.BillingCountry;
        }
        if(accountDetailsOrignal.BillingState != accountDetails.BillingState) {
            if(!changes.address)changes.address={};
            changes.address.state=accountDetails.BillingState;
        }
        
        if(accountDetailsOrignal.BillingPostalCode != accountDetails.BillingPostalCode) {
            if(!changes.address)changes.address={};
            changes.address.postal_code=accountDetails.BillingPostalCode;
        }
        
        if(accountDetailsOrignal.Employment_Status__c != accountDetails.Employment_Status__c)changes.employment_status=accountDetails.Employment_Status__c;
        if(accountDetailsOrignal.Marital_Status__c != accountDetails.Marital_Status__c){
            changes.tax_information={};
            changes.tax_information.marital_status=accountDetails.Marital_Status__c;
        }    
        
        if(changes.address){
            if(changes.address.line_1 && changes.address.line_1.length>=35){
                helper.showToast('Warning','Street 1 cannot be more then 35 char','warning');
                component.set('v.isClose',true);
                component.set('v.currentStep','1');
                return;
            }
            if(changes.address.line_2 && changes.address.line_2.length>=35){
                helper.showToast('Warning','Street 2 cannot be more then 35 char','warning');
                component.set('v.isClose',true);
                component.set('v.currentStep','1');
                return;
            }
            
        }
        
        component.set('v.accountDetailsChanged',changes);
        
    },
    //helpers
    callApex:function(component,actionName,callback,params){
        let action = component.get("c."+actionName);
        if(params)
            action.setParams(params);
        action.setCallback(this,callback);
        $A.enqueueAction(action);
    }, 
    showToast:function(title,message,type){
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type":type
        });
        toastEvent.fire();
    },
    formatDateTime:function(value){
        if(!value)return '';
        let locale = $A.get('$Locale');
        if(value.includes('T')){
            $A.localizationService.UTCToWallTime(new Date(value), $A.get('$Locale.timezone'), function (offSetDateTime) {
                value = offSetDateTime;
            });
            return $A.localizationService.formatDateTimeUTC(
                value,(locale.dateFormat,' ', locale.timeFormat));
        }
        return $A.localizationService.formatDate(value,locale.dateFormat);
    },
    formatCurrency:function(value){
        if(value === 0) return '0 '+ $A.get('$Locale.currency');
        if(!value ) return '';
        let locale = $A.get('$Locale');
        return value.toLocaleString(locale.userLocaleCountry) +' '+ $A.get('$Locale.currency');
    },
    closepopup: function (component) {
        $A.get("e.force:closeQuickAction").fire();
        
         
    },
    generateRandomString:function(length){
        const characters ='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
        let result = '';
        const charactersLength = characters.length;
        for ( let i = 0; i < length; i++ ) {
            result += characters.charAt(Math.floor(Math.random() * charactersLength));
        }
        
        return result;
    },
    validate:function(component,currentStep,nextStep){
        let helper=this;
        let accountDetails=component.get('v.accountDetails');
        let isAdditional=component.get('v.isAdditional');
        let line2=component.get('v.line2');
        if(currentStep=='1'){
            if(accountDetails.BillingStreet.length>=35){
                helper.showToast('Street Too Long','Please keep street length less then 35 characters','warning');
                return false;
                
            }
            if(isAdditional  && line2.length>=35){
                 helper.showToast('Additional Street Too Long','Please keep additional street length less then 35 characters','warning');
                return false;
            }
        }
        return true;
        
    }
})