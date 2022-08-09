({
    retriveRecordDetails:function(component){
        let helper=this;
        component.set('v.loading',true);
        helper.callApex(component,'getRecordDetails',function(result){
            let status=result.getState();
            let dataResult=result.getReturnValue();
            console.log(status)
            
            if (status === "SUCCESS") {
                let data=dataResult['Record'];
                console.log('data',data)
                if(data.length>0){ 
                    if(data[0].Banks__r && data[0].Banks__r[0].Marital_Status__c){
                        data[0].Marital_Status__c=data[0].Banks__r[0].Marital_Status__c;
                    }
                    console.log('recordData',data[0])
                    component.set('v.recordData',data[0])
                    component.set('v.recordDataOrignal',Object.freeze(JSON.parse(JSON.stringify(data[0]))))
                    
                    if(data[0].Person_Account__r){
                        component.set('v.cardfName',data[0].Person_Account__r.FirstName);
                        component.set('v.cardlName',data[0].Person_Account__r.LastName);
                    }
                    if(data[0].Preferred_Language__pc){
                        if(data[0].Preferred_Language__pc=='de'){
                            component.set('v.selectedIdNowType','DE');    
                        }
                        else if(data[0].Preferred_Language__pc=='en_US'){
                            component.set('v.selectedIdNowType','EN');    
                        }
                    }
                    if(dataResult['Employment_Status']){
                        let kycData=dataResult['Employment_Status'];
                        if(kycData[0] && kycData[0].Employment_Status__c){
                            if(kycData[0].Employment_Status__c.toUpperCase()=='FREELANCER' || kycData[0].Employment_Status__c.toUpperCase()=='SELF_EMPLOYED'){
                                component.set('v.cardtypeSelected','VISA_BUSINESS_DEBIT');
                            }
                            else{
                                component.set('v.cardtypeSelected','VISA_DEBIT');
                            }
                            
                        } 
                    }
                    
                    if(data[0].Status__c){
                        let isBlock = (data[0].Status__c === 'ACTIVE' )?true:false;
                        let isUnBlock = data[0].Status__c === 'BLOCKED'
                        let isClose = (data[0].Status__c === 'INACTIVE' || data[0].Status__c === 'ACTIVE' || data[0].Status__c === 'BLOCKED' || data[0].Status__c === 'PROCESSING') ? true : false;
                        let isJira = (data[0].Status__c === 'BLOCKED_BY_SOLARIS' ||data[0].Status__c === 'ACTIVATION_BLOCKED_BY_SOLARIS' || data[0].Status__c === 'CLOSED_BY_SOLARIS')?true:false;
                        
                        let statusTypes = [
                            { 
                                label:'',
                                value:'',
                                selected:true
                            }
                        ];
                        if(isBlock)
                            statusTypes.push({ 
                                label:'Block',
                                value:'Block',
                                selected:false
                            });
                        if(isUnBlock)
                            statusTypes.push({ 
                                label:'Unblock',
                                value:'Unblock',
                                selected:false
                            });
                        if(isClose)
                            statusTypes.push({ 
                                label:'Close',
                                value:'Close',
                                selected:false
                            });
                        if(isJira){
                            statusTypes.push({ 
                                label:'No Actions avilabel for this card',
                                value:'',
                                selected:false
                            });
                        }
                        component.set('v.cardstatusTypes',statusTypes);
                    }
                    
                }
                
            }
            component.set('v.loading',false);
        },{
            recordId:component.get('v.recordId') 
        })
    },
    updateAccount:function(component){
        let helper=this;
        let tannumber=component.get('v.tannumber');
        if(!tannumber && !tannumber.trim()){
            helper.showToast('Tan Missing','Please Enter Tan','error');
            return;
        }
        let tanUrlDetails=component.get('v.tanRequestResponse');
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
                    helper.close(component);
                }
                if(res.errors ){
                    helper.showToast('Error',JSON.stringify(res.errors[0].title),'error');
                    helper.close(component);
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
    changeCardStatus:function(component){
        let helper=this;
        let cardChangeReason=component.get('v.cardChangeReason');
        let cardstatusType=component.get('v.cardstatusType')
        if(!cardChangeReason){
            helper.showToast('Reason Missing','Please provide reason for change of status','error');
        }
        else if(!cardChangeReason.trim()){
            helper.showToast('Reason Missing','Please provide reason for change of status','error');
        }
            else if(!cardstatusType){
                helper.showToast('Status','Please select change of status','error');
            }
        component.set('v.loading',true);
        
        helper.callApex(component,'changeCardStatus',function(response){
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                if(!data){
                    $A.get('e.force:refreshView').fire();
                    helper.showToast('Success','Card Status Changed.','success');    
                }
                else{
                    let errors = response.getError();
                    helper.showToast('Error',data,'Error');
                }
                
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                helper.showToast('Error',JSON.stringify(errors),'Error');
            }
            component.set('v.loading',false);
            helper.close(component);
        },{
            recordId:component.get('v.recordId'),
            newStatus:cardstatusType,
            reason:cardstatusType
        })
    },
    createNewIdnow:function(component){
        let helper=this;
        component.set('v.loading',true);
        helper.callApex(component,'reqeustNewIdentification',function(response){
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                console.log(data);
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
                helper.showToast('Error',JSON.stringify(errors),'Error');
            }
            component.set('v.loading',false);
            helper.close(component);
        },{
            recordId:component.get('v.recordId'),
            languageCode:component.get('v.selectedIdNowType')
        })
    },
    createNewCard:function(component){
        let helper=this;
        let cardfName=component.get('v.cardfName');
        
        let cardlName=component.get('v.cardlName');
        
        let cardtypeSelected=component.get('v.cardtypeSelected');
        if( !cardfName.trim()){
            helper.showToast('Warrning','Please Enter First Name','warning');
            return;
        } 
        else if(!cardlName.trim()){
            helper.showToast('Warrning','Please Enter First Name','warning');
            return;
        } 
        cardfName=cardfName.trim();
        cardlName=cardlName.trim();
        let txt=cardfName+cardlName ;
        if(txt.length>21){
            helper.showToast('Warrning','Please make sure first,last and surname name combined is less then 20 characters','warning');
            return;
        }  
        let randomString=helper.generateRandomString(6);
        let body={
            type:cardtypeSelected,
            line_1:cardfName+'/'+cardlName,
            reference:randomString
        }
        console.log('body',body)
        component.set('v.loading',true);
        helper.callApex(component,'requestNewBankCard',function(response){
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                let res=JSON.parse(data);
                console.log('result',data)
                if(res.errors){
                    helper.showToast('Error',res.errors[0].detail,'Error')
                }
                else{
                    helper.showToast('Success','Request for new card submited successfully.','success');
                    $A.get('e.force:refreshView').fire();
                    helper.close(component);
                }
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                let errMsg='Please Contact system admin.If probelem Continues';
                if(errors[0] && errors[0].message)  errMsg=errors[0].message;
                helper.showToast('Error',errMsg,'Error');
                console.error(JSON.stringify(errors));
                helper.close(component);
            }
            component.set('v.loading',false);
        },{
            recordId:component.get('v.recordId'),
            body:JSON.stringify(body)
        });
        
    },
    closeBankAccount:function(component){
        let helper=this;
        let closeReasonSelected=component.get('v.closeReasonSelected');
        if(!closeReasonSelected){
             helper.showToast('Warrning','Please Select Reason for closure','warning');
            return;
        }
       
        component.set('v.loading',true);
        helper.callApex(component,'requestAccountCloser',function(response){
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                 console.log('result',data)
                 if(data.errors){
                      helper.showToast('Error',data.errors[0].detail,'error');
                   
                 } 
                else{
                    helper.showToast('Success','Request for close submited successfully.','success');
                      
                }
                     $A.get('e.force:refreshView').fire();
                helper.close(component)
                
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                let errMsg='Please Contact system admin.If probelem Continues';
                if(errors[0] && errors[0].message)  errMsg=errors[0].message;
                helper.showToast('Error',errMsg,'Error');
                console.error(JSON.stringify(errors));
                helper.close(component);
            }
            component.set('v.loading',false);
        },{
            recordId:component.get('v.recordId'),
            reason:closeReasonSelected
        });
        
    },
    //helper
	close : function(component) {
        component.set('v.isOpen',false);
        component.set('v.isAccountUpdate',false);
        component.set('v.isNewIdentification',false);
        component.set('v.isNewCard',false);
        component.set('v.isChangeStatus',false);
        component.set('v.isCancleOrder',false);
        component.set('v.loading',false);
        component.set('v.isAddressChange',false);
        component.set('v.isTanInput',false);
        component.set('v.isCloseBankAccount',false);
        
	},
    showToast: function (title, message, type) {
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire();
    },
    callApex: function (component, actionName, callback, params) {
        let action = component.get("c." + actionName);
        if (params)
            action.setParams(params);
        action.setCallback(this, callback);
        $A.enqueueAction(action);
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
    _findChangeAndPrepareAccountChangeJson:function(component){
        let accountDetailsOrignal=component.get('v.recordDataOrignal');
        let accountDetails=component.get('v.recordData');
        let line2=component.get('v.addressline2');
        
        let changes={};
        if(accountDetailsOrignal.PersonTitle != accountDetails.PersonTitle)changes.title=accountDetails.PersonTitle;
        if(accountDetailsOrignal.Salutation != accountDetails.Salutation)changes.salutation=accountDetails.Salutation;
        
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
        
        
        if(accountDetailsOrignal.Marital_Status__c != accountDetails.Marital_Status__c){
            changes.tax_information={};
            changes.tax_information.marital_status=accountDetails.Marital_Status__c;
        }    
        component.set('v.accountDetailsChanged',changes)
       console.log('changes',changes)
        if(changes.title!=undefined ||
           changes.salutation ||
           changes.address ||
           changes.tax_information
          ){
            
            component.set('v.isAddressChange',true)
        }
        
    },
})