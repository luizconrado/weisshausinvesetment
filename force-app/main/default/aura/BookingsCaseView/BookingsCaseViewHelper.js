({
    callApex:function(component,actionName,callback,params){
        let action = component.get("c."+actionName);
        if(params)
            action.setParams(params);
        action.setCallback(this,callback);
        $A.enqueueAction(action);
    },
    fetchBookings:function(component,sfBankId,bookingStartDate,bookingEndDate,recipentIBAN){
        let _helper=this;
        let selectedBookings=component.get('v.selectedBookings');
        let selectedBookingsId=selectedBookings.map(data=>data.Id);
        component.set('v.loading',true);
        _helper.callApex(component,'retriveBookings',function(response){
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                let records=data.map(function(rec){
                    rec.selected=(selectedBookingsId.includes(rec.Id))?true:false;
                    rec.price=_helper.formatCurrency(rec.Amount__c);
                    rec.BookingDate=_helper.formatDateTime(rec.Booking_Date__c);
                    rec.isSepta=(rec.Sepa_Return_Reason_Definition__c)?true:false;
                    return rec;
                });
                
                component.set('v.orignalDataList',records);
                _helper.setPage(component,records);
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                console.log(errors);
            }
            component.set('v.loading',false);
        },{
            sfBankId:sfBankId,
            bookingStartDate:bookingStartDate,
            bookingEndDate:bookingEndDate,
            recipentIBAN:recipentIBAN
        })
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
        console.log('value',value)
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