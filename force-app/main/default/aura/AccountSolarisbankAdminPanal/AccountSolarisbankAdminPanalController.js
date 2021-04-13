({
    onInit:function(component,event,helper){
        helper.callApex(component,'checkIsCompactLayout',function(response){
            let data = response.getReturnValue();
            component.set('v.isCompactLayout',data);
        });
        component.set('v.sessionToken',helper.generateRandomString(10));
        if(component.get('v.source')=='Account')
            helper.callApex(component,'getAccountPicklistValues',function(response){
                let data = response.getReturnValue();
                
                
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
        helper.callApex(component,'getRecordDetails',function(result){
            let status=result.getState();
            let data=result.getReturnValue();
            console.log(status)
            console.log(data)
            if (status === "SUCCESS") {
                if(data.length>0){
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
                    if(data[0].Person_Account__r && data[0].Person_Account__r.Employment_Status__c){
                        if(data[0].Person_Account__r.Employment_Status__c=='FREELANCER' || data[0].Person_Account__r.Employment_Status__c=='SELF_EMPLOYED'){
                            component.set('v.cardtypeSelected','VISA_BUSINESS_DEBIT');
                        }
                        else{
                            component.set('v.cardtypeSelected','VISA_DEBIT');
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
        },{
            recordId:component.get('v.recordId') 
        })
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
            if(accountDetailsChanged.title ||
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
                            helper.showToast('Error',JSON.stringify(data.errors[0]),'error');
                            return;
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