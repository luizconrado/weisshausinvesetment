({
 
    //server calls
    save: function (component) {
        let _helper = this;
        component.set('v.loading', true);
        _helper.callApex(component, 'updateJiraInformation', function (response) {
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                _helper.showToast('Success', 'Jira Description update.', 'success');
                $A.get('e.force:refreshView').fire();
                $A.get("e.force:closeQuickAction").fire();
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                let message = '';
                if (errors.length > 0) {
                    message = errors[0].message;
                }
                console.error(JSON.stringify(errors));
                _helper.showToast('Error', message, 'error');
            }
           
            component.set('v.loading', false);
        }, {
            caseId: component.get('v.recordId'),
            subject: component.get('v.subject'),
            discription: component.get('v.body') 
        });
    },
    getAllProcessDetails: function (component) {
        let _helper = this;
        component.set('v.loading', true);
        let selectedType = component.get('v.selectedType');
        let selectedTypeII = component.get('v.selectedTypeII');
        let caseDetails = component.get('v.caseDetails');
        
        _helper.callApex(component, 'retriveProcessKnowlodge', function (response) {
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                if (data.length > 0) {
                    let kmData = data[0];
                    component.set('v.articleDetails', kmData)
                }
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                console.error(JSON.stringify(errors));
            }
            component.set('v.loading', false);
        }, {
            typeI: selectedType,
            typeII: selectedTypeII
        });
    },
    retriveCaseDetails: function (component, caseId) {
        let _helper = this;
        component.set('v.loading', true);
        if (!component.get('v.subTypeLoaded') && !component.get('v.typeLoaded')) {
            return;
        }
        _helper.callApex(component, 'retriveCaseDetails', function (response) {
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                if (data.length > 0) {
                    let caseDetails = data[0];
                    console.log('caseDetails',caseDetails)
                    if(caseDetails.Bank_Case_Items__r == undefined) component.set('v.isCaseItemsAttached', false);
                    
                    console.log(caseDetails);
                    component.set('v.caseDetails', caseDetails);
                    component.set('v.selectedType', caseDetails['Type']);
                    _helper.setDependentCaseTypes(component, caseDetails['Type'], caseDetails['Type_II__c']);
                    
                }
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                console.error(JSON.stringify(errors));
                _helper.showToast('Error Case Details', 'Error in fetching case details please try again.', 'error');
            }
            component.set('v.loading', false);
        }, {
            caseId: caseId
        });
    },
    checkFileVersion: function (component) {
        let _helper = this;
        component.set('v.loading', true);
        _helper.callApex(component, 'retriveContentVersionList', function (response) {
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                if(data.length>0){
                   
                     
                    let group = data.reduce(function (r, a) {
                        r[a.ContentDocumentId] = [...r[a.ContentDocumentId] || [],a];
                        return r;
                    }, Object.create(null));
                    let filesList=[];
                    
                    Object.keys(group).forEach(function(documentId){
                        let files=group[documentId];
                        let parentFile={};
                        let versions=[];
                        files.forEach(function(file,index){
                            file.ContentModifiedDate=_helper.formatDateTime(file.ContentModifiedDate);
                            file.expaned=false;
                            if(index==0){
                                parentFile=file;
                            }
                            else{
                                versions.push(file);
                            }
                        });
                        parentFile.versions=versions;
                        filesList.push(parentFile);
                     
                    })
                   
                 	component.set('v.fileVersions',filesList)
                  
                }
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                console.error(JSON.stringify(errors));
            }
            component.set('v.loading', false);
        }, {
            caseRecordId: component.get('v.recordId')
        });
    },
    setDependentCaseTypes: function (component, type, setDefault) {
        let _helper = this;
        let caseIITypes = component.get('v.caseIITypes');
        let types = [];
        
        if (caseIITypes[type]) {
            types.push(...caseIITypes[type].map(function (subtype) {
                if(subtype=='Identification Creation' || subtype=='Information Request'){}
                else if(subtype=='Card Return/Delivery' || subtype=='Partner Card Unblock' || subtype=='Partner Card Closure' || subtype=='Partner Card Block' || subtype=='Fraudulent Transaction Monitoring'){}
                    else
                        return {
                            label: subtype,
                            value: subtype,
                            selected: false
                        }
                        }).filter(type=>type));
        }
        
        types.unshift({
            label: '',
            value: '',
            selected: false
        })
        component.set('v.caseDependentTypes', types);
        if (setDefault) {
            window.setTimeout(
                $A.getCallback(function () {
                    component.set('v.selectedTypeII', setDefault)
                }), 500
            );
        }
    },
    //jira helper
    getAllJiraDetails: function (component,nextStep) {
        
        let _helper = this;
        let selectedType = component.get('v.selectedType');
        component.set('v.loading', true);
        
        if (selectedType == 'Account Management') {
            if(nextStep=='2')_helper.jiraProcessForAccountManagment(component, false);
            if(nextStep=='3')_helper.jiraProcessForAccountManagment(component,true);
         }
        else if (selectedType == 'Tech') {
            if(nextStep=='2')_helper.jiraProcessForTech(component, false);
            if(nextStep=='3')_helper.jiraProcessForTech(component,true);
        }
            else if (selectedType == 'Master Data Management') {
                if(nextStep=='2') _helper.jiraProcessForMDM(component, false);
                if(nextStep=='3')_helper.jiraProcessForMDM(component,true);
            }
                else if (selectedType == 'Identification') {
                    if(nextStep=='2')_helper.jiraProcessForIdentification(component, false);
                    if(nextStep=='3')_helper.jiraProcessForIdentification(component,true);
                }
                    else if(selectedType=='Complaints'){
                        if(nextStep=='2')_helper.jiraProcessForComplaints(component,false);
                        if(nextStep=='3')_helper.jiraProcessForComplaints(component,true);
                    }
                        else if(selectedType=='GDPR'){
                            if(nextStep=='2')_helper.jiraProcessForGDPR(component,false);
                            if(nextStep=='3')_helper.jiraProcessForGDPR(component,true);
                            
                        }
                            else if(selectedType=='Seizures'){
                                if(nextStep=='2')_helper.jiraProcessForSeizures(component,false);
                                if(nextStep=='3')_helper.jiraProcessForSeizures(component,true);
                            }
                                else if(selectedType=='Other'){
                                    if(nextStep=='2')_helper.jiraProcessForOther(component,false);
                                    if(nextStep=='3')_helper.jiraProcessForOther(component,true);
                                }
                                    else if(selectedType=='Payment'){
                                        if(nextStep=='2')_helper.jiraProcessForPayment(component,false);
                                        if(nextStep=='3')_helper.jiraProcessForPayment(component,true);
                                    }
                                        else if(selectedType=='Card Management'){
                                            if(nextStep=='2')_helper.jiraProcessForCard(component,false);
                                            if(nextStep=='3')_helper.jiraProcessForCard(component,true);
                                        }
        
        
        component.set('v.loading', false);
        
    },
    extractBankCaseItems: function (component, recordType) {
        let caseDetails = component.get('v.caseDetails');
        let data = [];
        caseDetails.Bank_Case_Items__r.forEach(function (item) {
            if (item.RecordType.Name == 'Booking' && recordType == 'Booking Details') {
                data.push(item.Booking__r);
            }
            if (item.RecordType.Name == 'Bank Account' && recordType == 'Bank Account Details') {
                data.push(item.Bank_Account__r);
            }
            if(item.RecordType.Name ==='Card' && recordType=='Card Details'){
                data.push(item.Card__r);
            }
            if (item.RecordType.Name == 'Account' && recordType == 'Account Details' ) {
                data.push(item.Account__r);
            }
        });
        
        return data;
    },
    jiraProcessForAccountManagment: function (component, processSummary) {
        let _helper = this;
        
        let selectedTypeII = component.get('v.selectedTypeII');
        if (processSummary) {
            let caseDetails = component.get('v.caseDetails');
            let selectedItemId = component.get('v.selectedItemId');
            let caseItemList = component.get('v.caseItemList');
            let selectedItem = caseItemList.filter(item => item.Id === selectedItemId);
            if (selectedItem.length > 0) {
                let item = selectedItem[0];
                let description = '';
                let summary = '';
                if (selectedTypeII === 'Account Confirmation') {
                    summary = item.Solarisbank_Id__c + ' - ' + item.Legal_Name__c + ' - Account Confirmation';
                    description = 'Summary of issue = ' + caseDetails.Internal_Description__c;
                    description += '\n';
                    description += 'language of the statement required = ';
                }
                else if (selectedTypeII == 'Closure Request') {
                    summary = item.Name + ' - ' + item.Person_Account__r.Legal_Name__c + ' - Customer Wish Closure';
                    description = 'Reason of closure wish  = ' + caseDetails.Internal_Description__c;
                    description += '\n';
                    
                }
                    else if (selectedTypeII == 'Account Statement') {
                        
                        summary = item.Name + ' - ' + item.Person_Account__r.Legal_Name__c + ' - Account Statement for closed account';
                        description = 'Reason for Statement  request = ' + caseDetails.Internal_Description__c;
                        description += '\n';
                        description += 'period of the Statement  required = ';
                        description += '\n';
                        description += 'language of the Statement  required = ';
                    }
                component.set('v.subject', summary);
                component.set('v.body', description);
                
            }
        }
        else {
             if (selectedTypeII == 'Account Confirmation') {
                let caseItemList = _helper.extractBankCaseItems(component, 'Account Details');
                component.set('v.caseItemList', caseItemList);
                component.set('v.selectedItemId', caseItemList[0].Id);
            }
            else if (selectedTypeII == 'Closure Request') {
                let caseItemList = _helper.extractBankCaseItems(component, 'Bank Account Details');
                component.set('v.caseItemList', caseItemList);
                component.set('v.selectedItemId', caseItemList[0].Id);
            }
                else if (selectedTypeII == 'Account Statement') {
                    let caseItemList = _helper.extractBankCaseItems(component, 'Bank Account Details');
                    component.set('v.caseItemList', caseItemList);
                    component.set('v.selectedItemId', caseItemList[0].Id);
                    
                }
            
            
        }
        
        
        
    },
    jiraProcessForTech: function (component, processSummary) {
        let _helper = this;
        let selectedTypeII = component.get('v.selectedTypeII');
        if (processSummary) {
            let summary = '';
            let description = '';
            let caseDetails = component.get('v.caseDetails');
            if (selectedTypeII === 'Access Request') {
                summary = '<User Name>' + ' - Access Request';
                description = 'Access Required = ';
                description += '\n';
                description += 'User Email = ';
                description += '\n';
                description += 'Agent Full Name = ';
            }
            else if (selectedTypeII === 'Access Deletion') {
                summary = '<User Name>' + ' - Access Deletion';
                description = 'Access Remove Request = ';
                description += '\n';
                description += 'User Email = ';
                description += '\n';
                description += 'Agent Full Name = ';
            }
                else {
                    let selectedItemId = component.get('v.selectedItemId');
                    let caseItemList = component.get('v.caseItemList');
                    let selectedItem = caseItemList.filter(item => item.Id === selectedItemId);
                    if (selectedItem.length > 0) {
                        let item = selectedItem[0];
                        if (selectedTypeII === 'Verification Message Issue') {
                            summary = item.Solarisbank_Id__c + ' - ' + item.Legal_Name__c + ' - TAN';
                            description = 'Reason For Issue = ' + caseDetails.Internal_Description__c;
                            description += '\n';
                            description += 'Wrong number format = ';
                            description += '\n';
                            description += 'Phone Number Registerd = ';
                            description += '\n';
                            
                            description += 'Phone Number Provided By User = ';
                            description += '\n';
                            
                            description += 'Phone Network Provider  = ';
                            
                        }
                        else if (selectedTypeII == 'General Tech Issue') {
                            summary = item.Solarisbank_Id__c + ' - ' + item.Legal_Name__c + ' - Tech Issue';
                            description = 'Summary of issue = ' + caseDetails.Internal_Description__c;
                            
                        }
                    }
                    
                    
                }
            component.set('v.subject', summary);
            component.set('v.body', description);
        }
        else {
             if (selectedTypeII === 'Verification Message Issue') {
                let caseItemList = _helper.extractBankCaseItems(component, 'Account Details');
                component.set('v.caseItemList', caseItemList);
                component.set('v.selectedItemId', caseItemList[0].Id);
            }
            else if (selectedTypeII == 'General Tech Issue') {
                 let caseItemList = _helper.extractBankCaseItems(component, 'Account Details');
                component.set('v.caseItemList', caseItemList);
                component.set('v.selectedItemId', caseItemList[0].Id);
            }
                else if (selectedTypeII == 'Access Request') {
                    component.set('v.caseItemList', []);
                }
                    else if (selectedTypeII == 'Access Deletion') {
                        component.set('v.caseItemList', []);
                    }
            
        }
    },
    jiraProcessForMDM: function (component, processSummary) {
        let _helper = this;
        let selectedTypeII = component.get('v.selectedTypeII');
        if (processSummary) {
            let caseDetails = component.get('v.caseDetails');
            let selectedItemId = component.get('v.selectedItemId');
            let caseItemList = component.get('v.caseItemList');
            let selectedItem = caseItemList.filter(item => item.Id === selectedItemId);
            let summary = '';
            let description = '';
            if (selectedItem.length > 0) {
                let item = selectedItem[0];
                if (selectedTypeII === 'Tax ID Input') {
                    summary = item.Solarisbank_Id__c + ' - ' + item.Legal_Name__c + ' - TaxID change';
                    description = 'request to unblock account (if account is blocked)'
                }
                else if (selectedTypeII == 'Nationality Change') {
                    summary = item.Solarisbank_Id__c + ' - ' + item.Legal_Name__c + ' - Nationality change';
                    description = 'Reason For Change = ' + caseDetails.Internal_Description__c;
                    
                }
                    else if (selectedTypeII == 'Name Change') {
                        summary = item.Solarisbank_Id__c + ' - ' + item.Legal_Name__c + ' - Name change';
                        description = 'Reason For Change = ' + caseDetails.Internal_Description__c;
                        description+='\n';
                        description += 'Attachment: scan / picture of a valid document that proves a new name';
                    }
                        else if (selectedTypeII == 'Birthdate Change') {
                            summary = item.Solarisbank_Id__c + ' - ' + item.Legal_Name__c + ' - Birthdate change';
                            description = 'Reason For Change = ' + caseDetails.Internal_Description__c;
                        }
                            else if (selectedTypeII == 'Birth City Change') {
                                summary = item.Solarisbank_Id__c + ' - ' + item.Legal_Name__c + ' - Birth city change';
                                description = 'Reason For Change = ' + caseDetails.Internal_Description__c;
                            }
                
                                else if (selectedTypeII == 'Phone Change (Without access)') {
                                    summary = item.Solarisbank_Id__c + ' - ' + item.Legal_Name__c + ' - Phone change';
                                    description = 'Reason For Change = ' + caseDetails.Internal_Description__c;
                                    
                                }
            }
            component.set('v.subject', summary);
            component.set('v.body', description);
        }
        else {
             if (selectedTypeII === 'Tax ID Input') {
                let caseItemList = _helper.extractBankCaseItems(component, 'Account Details');
                component.set('v.caseItemList', caseItemList);
                component.set('v.selectedItemId', caseItemList[0].Id);
            }
            else if (selectedTypeII == 'Nationality Change') {
                let caseItemList = _helper.extractBankCaseItems(component, 'Account Details');
                component.set('v.caseItemList', caseItemList);
                component.set('v.selectedItemId', caseItemList[0].Id);
            }
                else if (selectedTypeII == 'Name Change') {
                     let caseItemList = _helper.extractBankCaseItems(component, 'Account Details');
                    component.set('v.caseItemList', caseItemList);
                    component.set('v.selectedItemId', caseItemList[0].Id);
                }
                    else if (selectedTypeII == 'Birthdate Change') {
                        let caseItemList = _helper.extractBankCaseItems(component, 'Account Details');
                        component.set('v.caseItemList', caseItemList);
                        component.set('v.selectedItemId', caseItemList[0].Id);
                    }
                        else if (selectedTypeII == 'Birth City Change') {
                            let caseItemList = _helper.extractBankCaseItems(component, 'Account Details');
                            component.set('v.caseItemList', caseItemList);
                            component.set('v.selectedItemId', caseItemList[0].Id);
                        }
                            else if (selectedTypeII == 'Phone Change (Without access)') {
                                 let caseItemList = _helper.extractBankCaseItems(component, 'Account Details');
                                component.set('v.caseItemList', caseItemList);
                                component.set('v.selectedItemId', caseItemList[0].Id);
                            }
            
        }
    },
    jiraProcessForIdentification: function (component, processSummary) {
        let _helper = this;
        let selectedTypeII = component.get('v.selectedTypeII');
        if (processSummary) {
            let caseDetails = component.get('v.caseDetails');
            let selectedItemId = component.get('v.selectedItemId');
            let caseItemList = component.get('v.caseItemList');
            let selectedItem = caseItemList.filter(item => item.Id === selectedItemId);
            let summary = '';
            let description = '';
            if (selectedItem.length > 0) {
                let item = selectedItem[0];
                if (selectedTypeII === 'Identification Issues') {
                    summary = item.Solarisbank_Id__c + ' - ' + item.Legal_Name__c + ' - Identification Issues';
                    description = 'Description of the problem = ' + caseDetails.Internal_Description__c;
                    description += '\n';
                    description += 'Identification ID or Reference =';
                    
                }
                else if (selectedTypeII == 'Identification Complaints') {
                    summary = item.Solarisbank_Id__c + ' - ' + item.Legal_Name__c + ' - Identification Complaints';
                    description = 'Description of the problem = ' + caseDetails.Internal_Description__c;
                    description += '\n';
                    description += 'Identification ID or Reference =';
                    
                } 
                
            }
            component.set('v.subject', summary);
            component.set('v.body', description);
        }
        else {
             if (selectedTypeII === 'Identification Issues') {
                let caseItemList = _helper.extractBankCaseItems(component, 'Account Details');
                component.set('v.caseItemList', caseItemList);
                component.set('v.selectedItemId', caseItemList[0].Id);
            }
            else if (selectedTypeII == 'Identification Complaints') {
                let caseItemList = _helper.extractBankCaseItems(component, 'Account Details');
                component.set('v.caseItemList', caseItemList);
                component.set('v.selectedItemId', caseItemList[0].Id);
            }
            
            
        }
    },
    jiraProcessForComplaints:function (component, processSummary){
        let _helper = this;
        let selectedTypeII = component.get('v.selectedTypeII');
        if (processSummary) {
            let caseDetails = component.get('v.caseDetails');
            let selectedItemId = component.get('v.selectedItemId');
            let caseItemList = component.get('v.caseItemList');
            let selectedItem = caseItemList.filter(item => item.Id === selectedItemId);
            let summary = '';
            let description = '';
            if (selectedItem.length > 0) {
                let item = selectedItem[0];
                if (selectedTypeII === 'User Complaint') {
                    summary = item.Solarisbank_Id__c + ' - ' + item.Legal_Name__c + ' - User Complaints';
                    description = 'Description of the problem = ' + caseDetails.Internal_Description__c;
                    description += '\n';
                    description += 'Details about when and how it was created =';
                } 
                
            }
            component.set('v.subject', summary);
            component.set('v.body', description);
        }
        else{
             if (selectedTypeII === 'User Complaint') {
                 let caseItemList = _helper.extractBankCaseItems(component, 'Account Details');
                component.set('v.caseItemList', caseItemList);
                component.set('v.selectedItemId', caseItemList[0].Id);
            }
            
        }
    },
    jiraProcessForGDPR:function (component, processSummary){
        let _helper = this;
        let selectedTypeII = component.get('v.selectedTypeII');
        if (processSummary) {
            let caseDetails = component.get('v.caseDetails');
            let selectedItemId = component.get('v.selectedItemId');
            let caseItemList = component.get('v.caseItemList');
            let selectedItem = caseItemList.filter(item => item.Id === selectedItemId);
            let summary = '';
            let description = '';
            if (selectedItem.length > 0) {
                let item = selectedItem[0];
                if (selectedTypeII === 'Bank Data Deletion') {
                    summary = item.Solarisbank_Id__c + ' - ' + item.Legal_Name__c + ' - GDPR Deletion';
                    description = 'Details of the request = ' + caseDetails.Internal_Description__c;
                    description += '\n';
                } 
                if (selectedTypeII === 'Bank Data Request') {
                    summary = item.Solarisbank_Id__c + ' - ' + item.Legal_Name__c + ' - GDPR Data Request';
                    description = ' User Email address = ';
                    description += '\n';
                } 
                
            }
            component.set('v.subject', summary);
            component.set('v.body', description);
        }
        else{
             if (selectedTypeII === 'Bank Data Deletion') {
                let caseItemList = _helper.extractBankCaseItems(component, 'Account Details');
                component.set('v.caseItemList', caseItemList);
                component.set('v.selectedItemId', caseItemList[0].Id);
            }
            else if (selectedTypeII === 'Bank Data Request') {
                let caseItemList = _helper.extractBankCaseItems(component, 'Account Details');
                component.set('v.caseItemList', caseItemList);
                component.set('v.selectedItemId', caseItemList[0].Id);
            }
            _helper.jiraProcessForGDPR(component,true);
        }
    },
    jiraProcessForSeizures:function (component, processSummary){
        let _helper = this;
        let selectedTypeII = component.get('v.selectedTypeII');
        if (processSummary) {
            let caseDetails = component.get('v.caseDetails');
            let selectedItemId = component.get('v.selectedItemId');
            let caseItemList = component.get('v.caseItemList');
            let selectedItem = caseItemList.filter(item => item.Id === selectedItemId);
            let summary = '';
            let description = '';
            if (selectedItem.length > 0) {
                let item = selectedItem[0];
                if (selectedTypeII === 'Seizure Information Request') {
                    summary = item.Name + ' - ' + item.Person_Account__r.Legal_Name__c + ' - Seizure Details';
                    description = 'Details of the request = ' + caseDetails.Internal_Description__c;
                    description += '\n';
                } 
                else if (selectedTypeII === 'Seizures Payout') {
                    
                    summary = item.Solarisbank_Id__c + ' - ' + item.Person_Account__r.Legal_Name__c + ' - Seizure Payout';
                    description = 'Details of the request = ' + caseDetails.Internal_Description__c;
                    description += '\n';
                } 
                    else if (selectedTypeII === 'P-Konto') {
                        summary = item.Solarisbank_Id__c + ' - ' + item.Person_Account__r.Legal_Name__c + ' - P-Konto';
                        description = 'Attach P-Konto request form = ';
                    }
                
            }
            component.set('v.subject', summary);
            component.set('v.body', description);
        }
        else{
             if (selectedTypeII === 'Seizure Information Request') {
                let caseItemList = _helper.extractBankCaseItems(component, 'Bank Account Details');
                component.set('v.caseItemList', caseItemList);
                component.set('v.selectedItemId', caseItemList[0].Id);
            }
            else if (selectedTypeII === 'Seizures Payout') {
                 let caseItemList = _helper.extractBankCaseItems(component, 'Bank Account Details');
                component.set('v.caseItemList', caseItemList);
                component.set('v.selectedItemId', caseItemList[0].Id);
            }
                else if (selectedTypeII === 'P-Konto') {
                     let caseItemList = _helper.extractBankCaseItems(component, 'Bank Account Details');
                    component.set('v.caseItemList', caseItemList);
                    component.set('v.selectedItemId', caseItemList[0].Id);
                }
            
        }
    },
    jiraProcessForOther:function (component, processSummary){
        let _helper = this;
        let selectedTypeII = component.get('v.selectedTypeII');
        if (processSummary) {
            let caseDetails = component.get('v.caseDetails');
            let selectedItemId = component.get('v.selectedItemId');
            let caseItemList = component.get('v.caseItemList');
            let selectedItem = caseItemList.filter(item => item.Id === selectedItemId);
            let summary = '';
            let description = '';
            if (selectedItem.length > 0) {
                let item = selectedItem[0];
                if (selectedTypeII === 'Other Requests') {
                    summary = item.Solarisbank_Id__c + ' - ' + item.Legal_Name__c + ' - Other';
                    description = 'Description of the problem = ' + caseDetails.Internal_Description__c;
                    description += '\n';
                } 
                
            }
            component.set('v.subject', summary);
            component.set('v.body', description);
        }
        else{
             if (selectedTypeII === 'Other Requests') {
                let caseItemList = _helper.extractBankCaseItems(component, 'Account Details');
                component.set('v.caseItemList', caseItemList);
                component.set('v.selectedItemId', caseItemList[0].Id);
            }
            
        }
    },
    jiraProcessForPayment: function (component, processSummary) {
        let _helper = this;
        let selectedTypeII = component.get('v.selectedTypeII');
        if(processSummary){
            let caseDetails = component.get('v.caseDetails');
            let selectedItemId = component.get('v.selectedItemId');
            let caseItemList = component.get('v.caseItemList');
            let selectedItem = caseItemList.filter(item => item.Id === selectedItemId);
            if (selectedItem.length > 0) {
                let item = selectedItem[0];
                let description = '';
                let summary = '';
                
                if (selectedTypeII === 'Direct Debit Return') {
                    summary = item.Booking_Date__c + ' - ' + item.Bank_Account__r.Name + ' - ' + item.Bank_Account__r.Person_Account__r.Legal_Name__c + ' - DDR';
                    description = 'Reason For Return = ' + caseDetails.Internal_Description__c;
                    description += '\n';
                    description += 'Booking ID = ' + item.Solarisbank_Id__c;
                    description += '\n';
                    description += 'Time = ' + item.Booking_Date__c;
                    description += '\n';
                    description += 'Amount(cents) = ' + item.Amount__c;
                    description += '\n';
                    description += 'Recipient IBAN = ' + item.Recipient_IBAN__c;
                    description += '\n';
                    description += 'Recipient Name = ' + item.Recipient_Name__c;
                }
                else if (selectedTypeII === 'Payment Request') {
                    summary = item.Name + ' - ' + item.Person_Account__r.Legal_Name__c + ' - Payment request';
                    description = 'Reason of manual payment = ' + caseDetails.Internal_Description__c;
                }
                    else if (selectedTypeII == 'Incoming Payment investigation') {
                        summary = item.Bank_Account__r.Name + ' - ' + item.Bank_Account__r.Person_Account__r.Legal_Name__c + ' - ' + item.Booking_Date__c + '- Incoming transaction investigation';
                        description = 'Reason For Investigation = ' + caseDetails.Internal_Description__c;
                        description += '\n';
                        description += 'Booking ID = ' + item.Solarisbank_Id__c;
                        description += '\n';
                        description += 'Time = ' + item.Booking_Date__c;
                        description += '\n';
                        description += 'Amount(cents) = ' + item.Amount__c;
                        description += '\n';
                        description += 'Recipient IBAN = ' + item.Recipient_IBAN__c;
                        description += '\n';
                        description += 'Recipient Name = ' + item.Recipient_Name__c;
                    }
                        else if (selectedTypeII == 'Outgoing Payment investigation') {
                            summary = item.Bank_Account__r.Name + ' - ' + item.Bank_Account__r.Person_Account__r.Legal_Name__c + ' - ' + item.Booking_Date__c + '- Outgoing transaction investigation';
                            description = 'Reason For Investigation = ' + caseDetails.Internal_Description__c;
                            description += '\n';
                            description += 'Booking ID = ' + item.Solarisbank_Id__c;
                            description += '\n';
                            description += 'Time = ' + item.Booking_Date__c;
                            description += '\n';
                            description += 'Amount(cents) = ' + item.Amount__c;
                            description += '\n';
                            description += 'Recipient IBAN = ' + item.Recipient_IBAN__c;
                            description += '\n';
                            description += 'Recipient Name = ' + item.Recipient_Name__c;
                        }
                            else if (selectedTypeII == 'Payment Recall') {
                                summary = item.Bank_Account__r.Name + ' - ' + item.Bank_Account__r.Person_Account__r.Legal_Name__c + ' - ' + item.Booking_Date__c + '- SCT Recall';
                                description = 'Reason For Recall = ' + caseDetails.Internal_Description__c;
                                description += '\n';
                                description += 'Booking ID = ' + item.Solarisbank_Id__c;
                                description += '\n';
                                description += 'Time = ' + item.Booking_Date__c;
                                description += '\n';
                                description += 'Amount(cents) = ' + item.Amount__c;
                                description += '\n';
                                description += 'Recipient IBAN = ' + item.Recipient_IBAN__c;
                                description += '\n';
                                description += 'Recipient Name = ' + item.Recipient_Name__c;
                                description += '\n';
                                description += 'User Accepted "Solarisbank AG does not guarantee successful results because it depends on recipient bank"';
                                description += '\n';
                                description += 'User Accepted "agrees to be charged 10 EUR for payment recall attempt"';
                            }
                component.set('v.subject', summary);
                component.set('v.body', description);
            }
        }
        else{
             if (selectedTypeII === 'Payment Request') {
                 let caseItemList = _helper.extractBankCaseItems(component, 'Bank Account Details');
                component.set('v.caseItemList', caseItemList);
                component.set('v.selectedItemId', caseItemList[0].Id);
                
            }
            else if (selectedTypeII === 'Direct Debit Return') {
                let caseItemList = _helper.extractBankCaseItems(component, 'Booking Details');
                let BookingsItemList = [];
                caseItemList.forEach(function (item) {
                    let bookingDate = new Date(item.Booking_Date__c);
                    let _8weeksAgo = new Date();
                    _8weeksAgo.setDate(_8weeksAgo.getDate() - 56);
                    let result = {
                        selected: false,
                        valid: _8weeksAgo < bookingDate,
                        amount: _helper.formatCurrency(item.Amount__c ),
                        title: (_8weeksAgo < bookingDate) ? '' : 'Booking Date is older than 8 weeks.',
                        id: item.Id,
                        recipent_iban: item.Recipient_IBAN__c,
                        recipent_name: item.Recipient_Name__c,
                        date: _helper.formatDateTime(item.Booking_Date__c),
                        description: item.Description__c
                    }
                    BookingsItemList.push(result);
                });
                if(BookingsItemList.length==1){
                    BookingsItemList[0].selected=BookingsItemList[0].valid;
                }
                component.set('v.caseItemList', caseItemList);
                component.set('v.BookingsItemList', BookingsItemList)
                
            }
                else if (selectedTypeII == 'Incoming Payment investigation') {
                     let caseItemList = _helper.extractBankCaseItems(component, 'Booking Details');
                    let BookingsItemList = [];
                    caseItemList.forEach(function (item) {
                        let bookingDate = new Date(item.Booking_Date__c);
                        let _5daysAgo = new Date();
                        _5daysAgo.setDate(_5daysAgo.getDate() - 5);
                        let result = {
                            selected: false,
                            valid: _5daysAgo > bookingDate,
                            amount: _helper.formatCurrency(item.Amount__c ),
                            title: (_5daysAgo > bookingDate) ? '' : 'Booking Date should be  older than 5 days.',
                            id: item.Id,
                            recipent_iban: item.Recipient_IBAN__c,
                            recipent_name: item.Recipient_Name__c,
                            date: _helper.formatDateTime(item.Booking_Date__c),
                            description: item.Description__c
                        }
                        BookingsItemList.push(result);
                    });
                    if(BookingsItemList.length==1){
                        BookingsItemList[0].selected=BookingsItemList[0].valid;
                    }
                    component.set('v.caseItemList', caseItemList);
                    component.set('v.BookingsItemList', BookingsItemList);
                }
                    else if (selectedTypeII == 'Outgoing Payment investigation') {
                        let caseItemList = _helper.extractBankCaseItems(component, 'Booking Details');
                        let BookingsItemList = [];
                        caseItemList.forEach(function (item) {
                            let bookingDate = new Date(item.Booking_Date__c);
                            let _5daysAgo = new Date();
                            _5daysAgo.setDate(_5daysAgo.getDate() - 5);
                            let result = {
                                selected: false,
                                valid: _5daysAgo > bookingDate,
                                amount: _helper.formatCurrency(item.Amount__c ),
                                title: (_5daysAgo > bookingDate) ? '' : 'Booking Date should be  older than 5 days.',
                                id: item.Id,
                                recipent_iban: item.Recipient_IBAN__c,
                                recipent_name: item.Recipient_Name__c,
                                date: _helper.formatDateTime(item.Booking_Date__c),
                                description: item.Description__c
                            }
                            BookingsItemList.push(result);
                        });
                        if(BookingsItemList.length==1){
                            BookingsItemList[0].selected=BookingsItemList[0].valid;
                        }
                        component.set('v.caseItemList', caseItemList);
                        component.set('v.BookingsItemList', BookingsItemList);
                    }
                        else if (selectedTypeII == 'Payment Recall') {
                            let caseItemList = _helper.extractBankCaseItems(component, 'Booking Details');
                            let BookingsItemList = [];
                            caseItemList.forEach(function (item) {
                                let bookingDate = new Date(item.Booking_Date__c);
                                let _13monthAgo = new Date();
                                _13monthAgo.setDate(_13monthAgo.getMonth() - 13);
                                let result = {
                                    selected: false,
                                    valid: _13monthAgo < bookingDate,
                                    amount: _helper.formatCurrency(item.Amount__c  ),
                                    title: (_13monthAgo < bookingDate) ? '' : 'Booking Date cannot be  older than 13 months.',
                                    id: item.Id,
                                    recipent_iban: item.Recipient_IBAN__c,
                                    recipent_name: item.Recipient_Name__c,
                                    date: _helper.formatDateTime(item.Booking_Date__c),
                                    description: item.Description__c
                                }
                                BookingsItemList.push(result);
                            });
                            if(BookingsItemList.length==1){
                                BookingsItemList[0].selected=BookingsItemList[0].valid;
                            }
                            component.set('v.caseItemList', caseItemList);
                            component.set('v.BookingsItemList', BookingsItemList);
                        }
        }
    },
    jiraProcessForCard: function (component, processSummary) {
        let _helper = this;
        let selectedTypeII = component.get('v.selectedTypeII');
        if(processSummary){
            let caseDetails = component.get('v.caseDetails');
            let selectedItemId = component.get('v.selectedItemId');
            let caseItemList = component.get('v.caseItemList');
            let selectedItem = caseItemList.filter(item => item.Id === selectedItemId);
            let caseBookingsItemList = component.get('v.BookingsItemList');
            if (selectedItem.length > 0) {
                let item = selectedItem[0];
                let summary = '';
                let description = '';
                if(selectedTypeII=='Bank Card Block'){
                    summary = item.Solarisbank_Id__c + ' - ' + item.Person_Account__r.Legal_Name__c + ' - Card Block';
                    description = 'Details of the request = ' + caseDetails.Internal_Description__c;
                    description += '\n';
                }
                else if(selectedTypeII=='Card Issue'){
                    summary = item.Solarisbank_Id__c + ' - ' + item.Person_Account__r.Legal_Name__c + ' - Card Issue';
                    description = 'Details of the request = ' + caseDetails.Internal_Description__c;
                    description += '\n';
                }
                    else if(selectedTypeII=='Card Chargeback'){
                        let selectedBookings=caseBookingsItemList.filter(book=>book.selected);
                        summary = item.Solarisbank_Id__c + ' - ' + item.Person_Account__r.Legal_Name__c + ' - Card Chargeback';
                        description = 'Details of the request = ' + caseDetails.Internal_Description__c;
                        description += '\n';
                        description += '\n';
                        selectedBookings.forEach(function(book,index){
                            description += (index+1)+' : Booking ID = ' + book.bookingSBId;
                            description += '\n';
                            description += 'Date = ' + book.rawDate;
                            description += '\n';
                            description += 'Amount = ' + book.amount;
                            description += '\n';
                            description += 'Recipient IBAN = ' + book.recipent_iban;
                            description += '\n';
                            description += 'Recipient Name = ' + book.recipent_name;
                            description += '\n';
                            description += 'Description = ' + book.description;
                            description += '\n';
                            description += '\n';
                        });
                        
                    }
                        else if(selectedTypeII=='Card Decline'){
                            console.log('caseBookingsItemList',caseBookingsItemList)
                            let selectedBookings=caseBookingsItemList.filter(book=>book.selected);
                            console.log('selectedBookings',selectedBookings)
                            summary = item.Solarisbank_Id__c + ' - ' + item.Person_Account__r.Legal_Name__c + ' - Card Decline';
                            description = 'Details of the request = ' + caseDetails.Internal_Description__c;
                            description += '\n';
                            description += '\n';
                            selectedBookings.forEach(function(book,index){
                                description += (index+1)+' : Booking ID = ' + book.bookingSBId;
                                description += '\n';
                                description += 'Date = ' + book.rawDate;
                                description += '\n';
                                description += 'Amount = ' + book.amount;
                                description += '\n';
                                description += 'Recipient IBAN = ' + book.recipent_iban;
                                description += '\n';
                                description += 'Recipient Name = ' + book.recipent_name;
                                description += '\n';
                                description += 'Description = ' + book.description;
                                description += '\n';
                                description += '\n';
                                
                            });
                        }
                component.set('v.subject', summary);
                component.set('v.body', description);
            }
        }
        else{
             if(selectedTypeII=='Card Chargeback'){
                 let caseItemList = _helper.extractBankCaseItems(component, 'Card Details');
                let bookingsItemList = _helper.extractBankCaseItems(component, 'Booking Details');
                let transactions = [];
                bookingsItemList.forEach(function (item) {
                    let result = {
                        selected: false,
                        valid: true,
                        amount: _helper.formatCurrency(item.Amount__c),
                        title:   ''  ,
                        id: item.Id,
                        recipent_iban: item.Recipient_IBAN__c,
                        recipent_name: item.Recipient_Name__c,
                        date: _helper.formatDateTime(item.Booking_Date__c),
                        rawDate:item.Booking_Date__c,
                        bookingSBId:item.Solarisbank_Id__c,
                        description: item.Description__c
                    }
                    transactions.push(result);
                });
                if(transactions.length==1){
                    transactions[0].selected=true;
                }
                component.set('v.caseItemList', caseItemList);
                component.set('v.selectedItemId', caseItemList[0].Id);
                component.set('v.BookingsItemList', transactions)
            }
            else if(selectedTypeII=='Card Decline'){
                 let caseItemList = _helper.extractBankCaseItems(component, 'Card Details');
                let bookingsItemList = _helper.extractBankCaseItems(component, 'Booking Details');
                let transactions = [];
                bookingsItemList.forEach(function (item) {
                    let result = {
                        selected: false,
                        valid: true,
                        amount: _helper.formatCurrency(item.Amount__c),
                        title:   ''  ,
                        id: item.Id,
                        recipent_iban: item.Recipient_IBAN__c,
                        recipent_name: item.Recipient_Name__c,
                        date: _helper.formatDateTime(item.Booking_Date__c),
                        rawDate:item.Booking_Date__c,
                        bookingSBId:item.Solarisbank_Id__c,
                        description: item.Description__c
                    }
                    transactions.push(result);
                });
                if(transactions.length==1){
                    transactions[0].selected=transactions[0].valid;
                }
                component.set('v.caseItemList', caseItemList);
                component.set('v.selectedItemId', caseItemList[0].Id);
                component.set('v.BookingsItemList', transactions)
            }
                else if(selectedTypeII=='Bank Card Block'){
                     let caseItemList = _helper.extractBankCaseItems(component, 'Card Details');
                    component.set('v.caseItemList', caseItemList);
                    component.set('v.selectedItemId', caseItemList[0].Id);
                }
                    else if(selectedTypeII=='Card Issue'){
                         let caseItemList = _helper.extractBankCaseItems(component, 'Card Details');
                        component.set('v.caseItemList', caseItemList);
                        component.set('v.selectedItemId', caseItemList[0].Id);
                    }
                        else if(selectedTypeII=='Card Return/Delivery'){
                            let caseItemList = _helper.extractBankCaseItems(component, 'Card Details');
                            component.set('v.caseItemList', caseItemList);
                            component.set('v.selectedItemId', caseItemList[0].Id);
                        }
        }
    },
    //Utitlity
    validate: function (component, currentStep, nextStep) {
        let _helper = this;
        let selectedType = component.get('v.selectedType');
        let selectedTypeII = component.get('v.selectedTypeII');
        let isCaseItemsAttached = component.get('v.isCaseItemsAttached');
        let articleDetails=component.get('v.articleDetails');
         
        
        if (!selectedType) {
            _helper.showToast('Type missing', 'Please Select Type I', 'warning');
            return;
        }
        else if (!selectedTypeII) {
            _helper.showToast('Type II missing', 'Please Select Type II', 'warning');
            return;
        }
        
        if(nextStep=='2' && isCaseItemsAttached==false ){
            if(selectedTypeII =='Access Deletion' || selectedTypeII=='Access Request'){ }
            else{
                _helper.showToast('Bank Case Item missing', 'Please attach bank case items.', 'warning');
                return;
            }
        }
        
        
        if(nextStep=='3'){
            let isEnd=component.find("end-reached");
            if(isEnd){
                let box=isEnd.getElement().getBoundingClientRect()
                let isVisible=box.top < window.innerHeight && box.bottom >= 0;
                if(!isVisible){
                    _helper.showToast('Please read the process', 'Please Scroll down to end of document to continue', 'warning');
                    return;
                }
            }
            
        }
        
        if(nextStep=='3' && (selectedTypeII=='Direct Debit Return' || selectedTypeII=='Outgoing Payment investigation' || selectedTypeII=='Incoming Payment investigation' || selectedTypeII=='Payment Recall')){
            let selectedItemId=component.get('v.selectedItemId' );
            console.log('selectedItemId',selectedItemId)
            if(!selectedItemId){
                _helper.showToast('Booking missing', 'Please Select Booking', 'warning');
                return;
            }
        }
        else if(nextStep=='3' && (selectedTypeII=='Card Chargeback' || selectedTypeII=='Card Decline')){
            if(!component.get('v.BookingsItemList').some(book=>book.selected)){
                _helper.showToast('Booking missing', 'Please Select Booking', 'warning');
                return;
            }
        }
        
        
        
        
        
        return true;
    },
    closepopup: function (component) {
        $A.get("e.force:closeQuickAction").fire();
         
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
    formatDateTime: function (value) {
        if (!value) return '';
        let locale = $A.get('$Locale');
        if (value.includes('T')) {
            $A.localizationService.UTCToWallTime(new Date(value), $A.get('$Locale.timezone'), function (offSetDateTime) {
                value = offSetDateTime;
            });
            return $A.localizationService.formatDateTimeUTC(
                value, (locale.dateFormat, ' ', locale.timeFormat));
        }
        return $A.localizationService.formatDate(value, locale.dateFormat);
    },
    formatCurrency: function (value) {
        if (value === 0) return '0 ' + $A.get('$Locale.currency');
        if (!value) return '';
        let locale = $A.get('$Locale');
        return value.toLocaleString(locale.userLocaleCountry) + ' ' + $A.get('$Locale.currency');
    },
    callApex: function (component, actionName, callback, params) {
        let action = component.get("c." + actionName);
        if (params)
            action.setParams(params);
        action.setCallback(this, callback);
        $A.enqueueAction(action);
    },
})