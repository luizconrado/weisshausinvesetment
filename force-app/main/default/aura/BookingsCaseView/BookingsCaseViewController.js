({
    onInit: function(component, event, helper) {
        let start = new Date();
        let end = new Date();
        end.setMonth(end.getMonth() - 4);
        let dateFilterStart = end.getFullYear() + '-' + (end.getMonth() + 1) + '-' + end.getDate();
        let dateFilterEnd = start.getFullYear() + '-' + (start.getMonth() + 1) + '-' + start.getDate();
        component.set('v.dateFilterStart',dateFilterStart);
        component.set('v.dateFilterEnd',dateFilterEnd);
        helper.callApex(component,'checkIsCompactLayout',function(response){
            let data = response.getReturnValue();
            component.set('v.isCompactLayout',data);
        })
        let bankAccountDetails=component.get('v.bankAccountDetails');
        helper.fetchBookings(component,bankAccountDetails.Id,new Date(dateFilterStart),new Date(dateFilterEnd),null);
    },
    inputChangeHandler : function(component, event, helper) {
        let value = event.getSource().get("v.value");
        let field = event.getSource().get("v.name");
        switch(field){
            case 'BookingDateStart':
                component.set('v.dateFilterStart',value);
                break
                case 'BookingDateEnd':
                component.set('v.dateFilterEnd',value);
                break
                case 'Recipient_iban':
                component.set('v.ibanFilter',value);
                break
        }
        
    },
    getBookings: function(component, event, helper) {
        let bankAccountDetails=component.get('v.bankAccountDetails');
        let dateFilterStart=component.get('v.dateFilterStart');
        let dateFilterEnd=component.get('v.dateFilterEnd');
        let ibanFilter=component.get('v.ibanFilter');
        
        helper.fetchBookings(component,bankAccountDetails.Id,new Date(dateFilterStart),new Date(dateFilterEnd),ibanFilter||null);
    },
    getTransactionMoreDetails: function(component, event, helper) {
        let transactionId=event.currentTarget.name;
        let bankAccountDetails=component.get('v.bankAccountDetails');
        console.log(component.get('v.caseRecordId'),bankAccountDetails)
        helper.callApex(component,'requestTransactionDetails',function(response){
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                let result = JSON.parse(data);
                if (result.errors) {
                    if (result.errors.length > 0) {
                        let erroMessge = result.errors[0];
                        helper.showToast(erroMessge.title, erroMessge.detail, 'error');
                    }
                    component.set('v.loading',false);
                    return;
                }
                
                
                result.price = helper.formatCurrency(result.amount.value/100);
                result.created_at = helper.formatDateTime(result.created_at);
                component.set('v.tempTransaction',result);
                component.set('v.popup',true);
                component.set('v.loading',false);
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                
                helper.showToast('Error','Please Contact system admin.If probelem Continues','Error');
                console.error(JSON.stringify(errors));
            }
        },{
            recordId:component.get('v.caseRecordId'),
            bankAccountDetails:bankAccountDetails,
            transactionId:transactionId
        })
    },
    showBookingDetails: function(component, event, helper) {
        let bookingRecordId=event.currentTarget.name; 
        helper.openRecordSubTab(component,bookingRecordId,'Booking__c');
     },
    bookingselect:function(component, event, helper) {
        let text = event.getSource().get("v.name");
        let checked = event.getSource().get("v.checked");
        let orignalDataList=component.get('v.orignalDataList');
        let selectedBookings=component.get('v.selectedBookings');
        orignalDataList.forEach(function(data){
            if(data.Id===text){
                data.selected=checked;
            }
        });
        component.set('v.selectedBookings',orignalDataList.filter(data=>data.selected));
        component.set('v.orignalDataList',orignalDataList);
    },
    searchTable: function(component, event, helper) {
        let searchText = event.getSource().get("v.value");
        let orignalDataList=component.get('v.orignalDataList');
        if(searchText.length>2){
            searchText=searchText.toLowerCase();
            let filterdList = [];
            for (let i = 0; i < orignalDataList.length; i++) {
                let booking=orignalDataList[i];
                if( booking.Description__c && booking.Description__c.toLowerCase().includes(searchText)) filterdList.push(booking) ;
                else if(booking.Recipient_IBAN__c && booking.Recipient_IBAN__c.toLowerCase().includes(searchText)) filterdList.push(booking);
                    else if(booking.Recipient_Name__c && booking.Recipient_Name__c.toLowerCase().includes(searchText)) filterdList.push(booking);
                        else if(booking.Sender_IBAN__c && booking.Sender_IBAN__c.toLowerCase().includes(searchText)) filterdList.push(booking);
                            else if(booking.Sender_Name__c && booking.Sender_Name__c.toLowerCase().includes(searchText)) filterdList.push(booking);
                                else if(booking.Amount__c && booking.Amount__c.toString().includes(searchText)) filterdList.push(booking);
            }
         
            component.set('v.filterdList',filterdList);
            helper.setPage(component,filterdList);
        }
        else{
            component.set('v.filterdList',[]);
            helper.setPage(component,orignalDataList);
        }
    },
    sortChangeHandler: function(component, event, helper) {
        let fieldName=event.currentTarget.name;
        let sortingList=component.get('v.orignalDataList');
        let sortOrder=component.get('v.sortOrder');
        sortOrder = (sortOrder==='desc')?'asc':'desc';
        let sortAsc=(sortOrder==='desc')?false:true;
        sortingList = sortingList.sort(function(a, b)  {
            if (a[fieldName] < b[fieldName]) {
                return sortAsc ? -1 : 1;
            }
            else if (a[fieldName] > b[fieldName]) {
                return sortAsc ? 1 : -1;
            }
                else {
                    return 0;
                }
        });
        component.set('v.sortBy',fieldName);
        component.set('v.sortOrder',sortOrder);
        component.set('v.orignalDataList',sortingList);
        helper.setPage(component,sortingList);
    },
    nextpage:function(component){
        let currentPage=component.get('v.currentPage');
        let pageCount=component.get('v.pageCount');
        let viewList=component.get('v.displayList');
        let filterdList=component.get('v.filterdList');
        let orignalList=component.get('v.orignalDataList');
        if (currentPage !== pageCount) {
            if(filterdList.lenght>0){
                viewList = filterdList.slice(currentPage * 10, (currentPage * 10) + 10);
            }
            else{
                viewList = orignalList.slice(currentPage * 10, (currentPage * 10) + 10);
            }
            
            currentPage = currentPage + 1;
            component.set('v.currentPage',currentPage);
            component.set('v.displayList',viewList);
        }
    },
    prevpage:function(component){
        let currentPage=component.get('v.currentPage');
        let viewList=component.get('v.displayList');
        let filterdList=component.get('v.filterdList');
        let orignalList=component.get('v.orignalDataList');
        if (currentPage > 1) {
            if(filterdList.lenght>0){
                viewList = filterdList.slice((currentPage * 10) - 20, (currentPage * 10) - 10);
            }
            else{
                viewList = orignalList.slice((currentPage * 10) - 20, (currentPage * 10) - 10);
            }
            
            currentPage = currentPage - 1;
            component.set('v.currentPage',currentPage);
            component.set('v.displayList',viewList);
        }
    },
    closepopup:function(component){
        component.set('v.popup',false)
        component.set('v.tempTransaction');
    }
})