({
    getParameterByName: function(component, event, name) {
        let _helper = this;
        name = name.replace(/[\[\]]/g, "\\$&");
        var url = window.location.href;
        var regex = new RegExp("[?&]" + name + "(=1\.([^&#]*)|&|#|$)");
        var results = regex.exec(url);
        if (!results) {
            let alternateExtraction = _helper.getParameterByNameOverride(url,name);
            if(alternateExtraction) return decodeURIComponent(alternateExtraction.replace(/\+/g, " "));
            return null;   
        }
        if (!results[2]) return '';
        return decodeURIComponent(results[2].replace(/\+/g, " "));
    },
    getParameterByNameOverride:function(url,parameter){
        if(url.indexOf(parameter)>0){
            let parameterString = url.substring(url.indexOf(parameter)+parameter.length+1);
            let parameter = parameterString.substring(0,parameterString.indexOf('&'));
			return parameter;
        }
        return '';
    },
    callApex:function(component,actionName,callback,params){
        let action = component.get("c."+actionName);
        if(params)
            action.setParams(params);
        action.setCallback(this,callback);
        $A.enqueueAction(action);
    },
    retriveCaseDetails:function(component,caseId){
        let _helper = this;
         component.set('v.loading',true);
        if(!component.get('v.subTypeLoaded') && !component.get('v.typeLoaded')){
            return;
        }
       

        _helper.callApex(component,'getCaseDetails',function(response){
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                if(data.length>0){
                    let caseDetails=data[0];
                    component.set('v.caseDetails',caseDetails);
                    component.set('v.selectedType',caseDetails['Type']);
                    component.set('v.reasonForContact',caseDetails['Internal_Description__c']);
                    
                    _helper.setDependentCaseTypes(component,caseDetails['Type'],caseDetails['Type_II__c']);
                    
                    _helper.retriveBankDetails(component,caseDetails.AccountId);
                    
                }
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                console.error(JSON.stringify(errors));
                _helper.showToast('Error Case Details','Error in fetching case details please try again.','error');
            }
            component.set('v.loading',false);
        },{
            caseId:caseId
        });
    },
    retriveBankDetails:function(component,accountId){
        let _helper=this;
        component.set('v.loading',true);
        _helper.callApex(component,'getBankAccounts',function(response){
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                if(data.length>0){
                    let banks=data.map(function(bank){
                        bank.selected=false;
                        return bank;
                    })
                    if(banks.length==1){
                        banks[0].selected=true;
                        component.set('v.selectedBank',banks[0]);
                    }
                    component.set('v.personBanks',banks);
                    component.set('v.orignalPersonBanks',banks);
                }
                
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                console.error(JSON.stringify(errors));
                _helper.showToast('Error Bank Details','Error in fetching bank details please try again.','error');
                
            }
            component.set('v.loading',false);
        },{
            accountId:accountId
        });
    },
    setDependentCaseTypes:function(component,type,setDefault){
        let caseIITypes = component.get('v.caseIITypes');
        let types=[];
        types.push({
            label:'',
            value:'',
            selected:false
        })
        if(caseIITypes[type]){
            types.push(...caseIITypes[type].map(function(subtype){
                return {
                    label:subtype,
                    value:subtype,
                    selected:false
                }
            }));
        }
        component.set('v.caseDependentTypes',types);
        if(setDefault){
            window.setTimeout(
                $A.getCallback(function() {
                    component.set('v.selectedTypeII',setDefault)
                    //component.set('v.selectedType',type)
                }), 500
            );
        } 
      
    },
    validate:function(component){
        let _helper=this;
        let currentStep=component.get('v.currentStep');
        switch(currentStep) {
            case 'selectType':
                
                break;
            case 'selectBank':
                let personBanks=component.get('v.personBanks');
				if(personBanks.length==0 || !personBanks) return false;
                let selectedBank=component.get('v.selectedBank');
                if(!selectedBank){
                    _helper.showToast('Bank Missing','Select Bank Account','warning');
                    return true;
                }
                break;
            case 'selectRecord':
                break;
            case 'createRecord':
                let reasonForContact=component.get('v.reasonForContact');
                if(!reasonForContact){
                    _helper.showToast('Reason Missing','Please enter reason','warning');
                    return true;
                }
                break;
        }
        return false;
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
    openRecordSubTab:function(component,recordId,objectname){
        let workspaceAPI = component.find("workspace");
        workspaceAPI.isConsoleNavigation().then(function(){
            workspaceAPI.getFocusedTabInfo().then(function(response) {
                let focusedTabId = response.tabId;
                let pgRef={
                    type: 'standard__recordPage',
                    attributes: {
                        "recordId": recordId,
                        "objectApiName": objectname,
                        "actionName": "view"
                    },
                };
                workspaceAPI.openSubtab({
                    parentTabId:focusedTabId,
                    pageReference:pgRef,
                    focus:true})
                .then(function(response) {
                    const subTabId=response;
                    workspaceAPI.closeTab({tabId:focusedTabId});
                    //workspaceAPI.setTabLabel({tabId:subTabId, label:'Bank Account Details'})
                    //workspaceAPI.setTabIcon({tabId:subTabId, icon:'standard:delegated_account', iconAlt:'Bank Account'})
                });
            })
            .catch(function(error) {
                console.error('openConsoleSubTab',error);
            }); 
        })
    },
    closeSubTab:function(component){
        let workspaceAPI = component.find("workspace");
        workspaceAPI.isConsoleNavigation().then(function(){
            workspaceAPI.getFocusedTabInfo().then(function(response) {
                let focusedTabId = response.tabId;
                workspaceAPI.closeTab({tabId:focusedTabId});
            });
        })
    },
    setHeader:function(component){
        let currentStep=component.get('v.currentStep');
        switch(currentStep) {
            case 'selectType':
                component.set('v.header','Select Case Type');
                break;
            case 'selectBank':
                component.set('v.header','Select Associated Bank');
                break;
            case 'selectRecord':
                component.set('v.header','Select Records');
                break;
            case 'createRecord':
                component.set('v.header','Create Bank Case Record');
                break;
        }
    },
    saveSelection:function(component){
        let _helper = this;
        
        let caseDetails = component.get('v.caseDetails');
        let selectedTypeI = component.get('v.selectedType');
        let selectedTypeII = component.get('v.selectedTypeII');
        let reasonForContact = component.get('v.reasonForContact');
        
        let selectedBank = component.get('v.selectedBank');
        let selectedStatementInfo = component.get('v.selectedStatementInfo') || {};
        let selectedCard = component.get('v.selectedCard') || {};
        let selectedBookings = component.get('v.selectedBookings') || [];
        let selectedReservations = component.get('v.selectedReservations') || [];
        let selectedTimedOrders = component.get('v.selectedTimedOrders') || [];
        let selectedStandingOrders = component.get('v.selectedStandingOrders') || [];
        let selectedIdententifications = component.get('v.selectedIdentList') || [];
        
        
        let sfAccountId = caseDetails.AccountId || '';
        let sfBankId = selectedBank.Id || '';
        let sfCardId = selectedCard.Id || '';
        let sfBookingIds = selectedBookings.map(book=>book.Id) || [];
        let sfRervationIds = selectedReservations.map(res => res.Id) || [];
        let sfTimedOrderIds = selectedTimedOrders.map(to => to.Id) || [];
        let sfStandingOrderIds = selectedStandingOrders.map(to => to.Id) || [];
        let sfIdententificationsIds=selectedIdententifications.map(to => to.Id) || [];
        let sfCaseId = caseDetails.Id;
        let stamentId = selectedStatementInfo.Id || '';
        component.set('v.loading',true);
        _helper.callApex(component,'createBankCases',function(response){
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                let recordIds = data;
                _helper.showToast('Success','Bank Case Records Created.','success');
                _helper.closeSubTab(component);
                
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                let message='';
                if(errors.length>0){
                    message=errors[0].message;
                }
                console.error(JSON.stringify(errors));
                _helper.showToast('Error',message,'error');

            }
            component.set('v.loading',false);
        },{
            caseId:sfCaseId,
            typeI:selectedTypeI,
            typeII:selectedTypeII,
            description:reasonForContact,
            bankId:sfBankId,
            cardId:sfCardId,
            accountId:sfAccountId,
            bookingsId:sfBookingIds,
            reservationsId:sfRervationIds,
            timedOrdersId:sfTimedOrderIds,
            standingOrdersId:sfStandingOrderIds,
            statementId:stamentId,
            idententificationsIds:sfIdententificationsIds
        });
        
        
        
        
        
        
    }
})