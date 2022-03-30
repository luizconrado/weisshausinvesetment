({
    onInit:function(component,event,helper){
        helper.callApex(component,'checkIsCompactLayout',function(response){
            let data = response.getReturnValue();
            component.set('v.isCompactLayout',data);
        });
        component.set('v.sessionToken',helper.generateRandomString(10));
        if(component.get('v.source')=='Account')
            helper.callApex(component,'getKYCPicklistValues',function(response){
                let data = response.getReturnValue();
                
console.log('getKYCPicklistValues',data)                
                component.set('v.maritalStatusValues',Object.keys(data.Marital_Status__c).map(function(value){
                    return {value:value,label:data.Marital_Status__c[value]};
                }));
                
            });
        if(component.get('v.source')=='Bank Account')
            helper.callApex(component,'getBankAccountPicklistValues',function(response){
                let data = response.getReturnValue();
                component.set('v.closeReasonValues',Object.keys(data.Closure_Reasons__c).map(function(value){
                    return {value:value,label:data.Closure_Reasons__c[value]};
                }));
            });
       helper.retriveRecordDetails(component);
    },
    refreshRecordDetails:function(component,event,helper){
               helper.retriveRecordDetails(component);

    },
    handleSelect : function(component, event, helper) {
        let selectedMenuItemValue = event.getParam("value");
        console.log("Menu item selected with value: " + selectedMenuItemValue);
        if(selectedMenuItemValue=='Update_Person_Details'){
            component.set('v.isOpen',true);
            component.set('v.isAccountUpdate',true);
        }
        else if(selectedMenuItemValue=='New_Person_Identification'){
            component.set('v.isOpen',true);
            component.set('v.isNewIdentification',true);
        }
            else if(selectedMenuItemValue=='Create_New_Card'){
                component.set('v.isOpen',true);
                component.set('v.isNewCard',true);
            }
                else if(selectedMenuItemValue=='Change_Card_Status'){
                    component.set('v.isOpen',true);
                    component.set('v.isChangeStatus',true);
                }
                    else if(selectedMenuItemValue=='Cancel_Time_Order'){
                        component.set('v.isOpen',true);
                        component.set('v.isCancleOrder',true);
                        
                    }
                        else if(selectedMenuItemValue=='Close_Bank_Account'){
                             component.set('v.isOpen',true);
                        component.set('v.isCloseBankAccount',true);
                        }
    },
    handleClose:function(component,event,helper){
        helper.close(component);
    },
    handleSave:function(component,event,helper){
        let isAccountUpdate=component.get('v.isAccountUpdate');
        let isNewIdentification=component.get('v.isNewIdentification');
        let isNewCard=component.get('v.isNewCard');
        let isChangeStatus=component.get('v.isChangeStatus');
        let isCancleOrder=component.get('v.isCancleOrder');
        let isCloseBankAccount=component.get('v.isCloseBankAccount');
        
        if(isNewIdentification){
            helper.createNewIdnow(component);
        }
        else if(isNewCard){
            helper.createNewCard(component);
        }
            else if(isChangeStatus){
                helper.changeCardStatus(component);
            }
                else if(isAccountUpdate){
                    helper.updateAccount(component);
                }
                    else if(isCloseBankAccount){
                        helper.closeBankAccount(component);
                    }
    },
    searchGoogleAddress:function(component,event,helper){
        let isEnterKey = event.keyCode === 13;
        
        if (!isEnterKey)  return;
        let searchText =  component.find('addressChange').get('v.value');
        let sessionToken= component.get('v.sessionToken');
        if(searchText.length<4){
            component.set('v.predictions',[]);
            return;
        } 
        helper.callApex(component,'callGoogleMapSearchApi',function(response){
            let data = response.getReturnValue();
            data = JSON.parse(data);
            console.log('searchText',data);
            component.set('v.predictions',data.predictions);
        },{
            searchText:searchText,
            sessionToken:sessionToken
        });
        
    },
    toggleLine2:function(component){
        component.set('v.isAdditionalAddress',!component.get('v.isAdditionalAddress'));
    },
    searchWithDetailsApi:function(component,event,helper){
        
        let accountDetails=component.get('v.recordData') 
        let placeId=event.currentTarget.id;
        component.set('v.loading',true);
        helper.callApex(component,'callGoogleMapsDetailsApi',function(response){
            let data = response.getReturnValue();
            data=JSON.parse(data);
            console.log('searchText',data)
            let address=data.result.address_components;
            console.log('address',address)
            accountDetails.BillingCountry ='';
            
            accountDetails.BillingCity='';
            accountDetails.BillingStreet='';
            accountDetails.BillingPostalCode='';
            let streetList=[];
            address.forEach(function(add){
                if( add.types.includes('premise') || add.types.includes('neighborhood')  || add.types.includes('street_number') ||add.types.includes('street_address') || add.types.includes('route') ) {
                    streetList.push(add.long_name);
                    
                }
                else if(add.types.includes('locality')){
                    accountDetails.BillingCity=add.long_name;
                }
                    else if(add.types.includes('postal_code')){
                        accountDetails.BillingPostalCode=add.long_name;
                    }
                        else if(add.types.includes('country')){
                            accountDetails.BillingCountry=add.short_name;
                        }
                
                
                
                
                
            });
            if(streetList)  accountDetails.BillingStreet=streetList.reverse().join(' ');
            component.set('v.predictions',[]);
            component.set('v.recordData',accountDetails);
            component.set('v.loading',false);
            
        },{
            placeId:placeId,
            sessionToken:component.get('v.sessionToken')
        });
    },
    requestTan:function(component,event,helper){
        let isAccountUpdate=component.get('v.isAccountUpdate');
        let isTanInput=component.get('v.isTanInput');
        
        if(isAccountUpdate){
            let isAddressChange=component.get('v.isAddressChange');
            if(!isAddressChange) helper._findChangeAndPrepareAccountChangeJson(component);
            let accountDetailsChanged=component.get('v.accountDetailsChanged');
            if(accountDetailsChanged.address){
                if(accountDetailsChanged.address.line_1 && accountDetailsChanged.address.line_1.length>=35){
                    helper.showToast('Warrning','Street 1 cannot be more then 35 char','warning');
                    return;
                }
                if(accountDetailsChanged.address.line_2 && accountDetailsChanged.address.line_2.length>=35){
                    helper.showToast('Warrning','Street 2 cannot be more then 35 char','warning');
                    return;
                }
            }
            if(accountDetailsChanged.title!=undefined ||
               accountDetailsChanged.salutation ||
               accountDetailsChanged.address ||
               accountDetailsChanged.tax_information
              ){
            	if(!isTanInput) component.set('v.isTanInput',true);    
                component.set('v.loading',true);
                helper.callApex(component,'intitatePersonDetailsChangeTanRequest',
                                function(response){ 
                    let state = response.getState();
                    let data = response.getReturnValue();
                    if (state === "SUCCESS") {
                        console.log('result',data)
                        if(data.errors){
                            helper.showToast('Error',JSON.stringify(data.errors[0].detail),'error');
                            helper.close(component);
                            return;
                        }
                        component.set('v.requestTan',false);
                        component.set('v.loading',false);
                        component.set('v.tanRequestResponse',data);
                    }
                    else if (state === "ERROR") {
                        let errors = response.getError();
                        let errMsg='Please Contact system admin.If probelem Continues'; 
                        if(errors[0] && errors[0].message)  errMsg=errors[0].message;
                        helper.showToast('Error',errMsg,'Error');
                        console.error(JSON.stringify(errors));
                        helper.close(component);
                        
                    }
                },{
                    recordId:component.get('v.recordId'),
                    requestChangebody:JSON.stringify(accountDetailsChanged)
                });
            }
            else{
                helper.showToast('No Changes','No Changes to request TAN','warning');
            }
            
            
            
        }
    },
    
})