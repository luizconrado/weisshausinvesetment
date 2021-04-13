({
    onInit : function(component, event, helper) {
        component.set('v.sessionToken',helper.generateRandomString(10));
        helper.callApex(component,'checkIsCompactLayout',function(response){
            let data = response.getReturnValue();
            component.set('v.isCompactLayout',data);
        });
        helper.callApex(component,'getAccountPicklistValues',function(response){
            let data = response.getReturnValue();
            console.log('picklist',data)
            
            component.set('v.maritalStatusValues',Object.keys(data.Marital_Status__c).map(function(value){
                return {value:value,label:data.Marital_Status__c[value]};
            }));
            component.set('v.employmentStatusValues',Object.keys(data.Employment_Status__c).map(function(value){
                return {value:value,label:data.Employment_Status__c[value]};
            }));
            component.set('v.industryStatusValues',Object.keys(data.Industry).map(function(value){
                return {value:value,label:data.Industry[value]};
            }));
            component.set('v.industryKeyValues',Object.keys(data.Industry_Key__c).map(function(value){
                return {value:value,label:data.Industry_Key__c[value]};
            }));
            
            
            
            helper.retriveBankCaseDetails(component);
        });
        
    },
    close:function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
    onBack:function(component, event, helper) {
        let currentStep=component.get('v.currentStep');
        let prevStep=parseInt(currentStep)-1;
        prevStep+='';
        if(currentStep=='1'){
            helper.closepopup(component);
        }
        else if(currentStep=='2'){
            component.set('v.isClose',true);
            component.set('v.currentStep',prevStep);
        }
            else if(currentStep=='3'){
                component.set('v.currentStep',prevStep);
                component.set('v.isSave',false);
            } 
        
    },
    onNext:function(component, event, helper) {
        let currentStep=component.get('v.currentStep');
        
        let nextStep=parseInt(currentStep)+1;
        nextStep+='';
        if(!helper.validate(component,currentStep,nextStep)) return;
        
        if(currentStep=='1'){
            component.set('v.isClose',false);
            component.set('v.currentStep',nextStep);
            helper.findChangeAndPrepareJson(component);
        }
        else if(currentStep=='2'){
            component.set('v.currentStep',nextStep);
            helper.intitateCRPRequest(component);
            component.set('v.isSave',true);
        }
            else if(currentStep=='3'){
                component.set('v.currentStep',nextStep);
                helper.confrimTanRequest(component);
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
        component.set('v.isAdditional',!component.get('v.isAdditional'));
    },
    searchWithDetailsApi:function(component,event,helper){
        let accountDetails=component.get('v.accountDetails') 
        let placeId=event.currentTarget.id;
        component.set('v.loading',true);
        helper.callApex(component,'callGoogleMapsDetailsApi',function(response){
            let data = response.getReturnValue();
            data=JSON.parse(data);
            console.log('searchText',data)
            let address=data.result.address_components;
            console.log('address',address)
            accountDetails.BillingCountry='';
           
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
            component.set('v.accountDetails',accountDetails);
            component.set('v.loading',false);
            
        },{
            placeId:placeId,
            sessionToken:component.get('v.sessionToken')
        });
    },
})