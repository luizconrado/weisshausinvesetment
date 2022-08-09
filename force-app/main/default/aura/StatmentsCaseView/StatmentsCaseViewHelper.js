({
    callApex:function(component,actionName,callback,params){
        let action = component.get("c."+actionName);
        if(params)
            action.setParams(params);
        action.setCallback(this,callback);
        $A.enqueueAction(action);
    },
    generateStatement:function(component){
        let _helper = this; 
        let isRange=component.get('v.isRange');
        let Statement__c = component.get('v.selectedStatementInfo');
        let bankAccountDetails=component.get('v.bankAccountDetails')
        
        component.set('v.loading',true);
        _helper.callApex(component,'fetchBankStatement',function(response){
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS"){
                console.log('data',data)
                let stamentantIdAndList = data.split('________');
                let statementLog = JSON.parse(stamentantIdAndList[1]);
                Statement__c=JSON.parse(JSON.stringify(Statement__c));
                Statement__c.Id = stamentantIdAndList[0];
                
                let bookingsList = statementLog.map(function(book, index) {
                    book.index = index;
                    book.price = _helper.formatCurrency(book.amount.value/100);
                    book.bookingDate = _helper.formatDateTime(book.booking_date);
                    book.price_cents = book.amount.value;
                    return book;
                });
                component.set('v.selectedStatementInfo',Statement__c);
                
                component.set('v.orignalDataList',bookingsList);
                _helper.setPage(component,bookingsList);
            }
            else if (state === "ERROR"){
                let errors = response.getError();
                console.log(errors);
            }
            component.set('v.loading',false);
        },{
            recordId:component.get('v.caseRecordId'),
            bankAccountDetails:bankAccountDetails,
            filterdByRange:isRange,
            solarisBankAccountId:bankAccountDetails.Solarisbank_Id__c,
            statement:Statement__c
        });
    },
    setPage:function(component,orignalList) {
        let pageCount = Math.ceil(orignalList.length / 10);
        component.set('v.pageCount',pageCount);
        component.set('v.currentPage',1);
        component.set('v.displayList',orignalList.slice(0, 10));
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
                    //workspaceAPI.closeTab({tabId:focusedTabId});
                    //workspaceAPI.setTabLabel({tabId:subTabId, label:'Bank Account Details'})
                    //workspaceAPI.setTabIcon({tabId:subTabId, icon:'standard:delegated_account', iconAlt:'Bank Account'})
                });
            })
            .catch(function(error) {
                console.error('openConsoleSubTab',error);
            }); 
        })
    },
    showToast:function(title,message,type){
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type":type
        });
        toastEvent.fire();
    }
})