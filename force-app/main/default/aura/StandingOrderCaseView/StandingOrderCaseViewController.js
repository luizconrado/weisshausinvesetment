({
	onInit : function(component, event, helper) {
        let start = new Date();
        let end = new Date();
        end.setMonth(end.getMonth() - 4);
        let dateFilterStart = end.getFullYear() + '-' + (end.getMonth() + 1) + '-' + end.getDate();
        let dateFilterEnd = (start.getFullYear() + 1) + '-' + (start.getMonth() + 1) + '-' + start.getDate();
        component.set('v.dateFilterStart',dateFilterStart);
        component.set('v.dateFilterEnd',dateFilterEnd);
        helper.callApex(component,'checkIsCompactLayout',function(response){
            let data = response.getReturnValue();
            component.set('v.isCompactLayout',data);
        })
        let bankAccountDetails=component.get('v.bankAccountDetails');
        if(!bankAccountDetails) return;
        helper.fetchAllRecords(component,bankAccountDetails.Id,new Date(dateFilterStart),new Date(dateFilterEnd),null);
    },
    getRecords:function(component, event, helper) {
        let bankAccountDetails=component.get('v.bankAccountDetails');
        let dateFilterStart=component.get('v.dateFilterStart');
        let dateFilterEnd=component.get('v.dateFilterEnd');
        let refFilter=component.get('v.refFilter');
        
        helper.fetchAllRecords(component,bankAccountDetails.Id,new Date(dateFilterStart),new Date(dateFilterEnd),refFilter||null);
        
	},
    inputChangeHandler: function(component, event, helper) {
        let value = event.getSource().get("v.value");
        let field = event.getSource().get("v.name");
        switch(field){
            case 'ExpiresDateStart':
                component.set('v.dateFilterStart',value);
                break
                case 'ExpiresDateEnd':
                component.set('v.dateFilterEnd',value);
                break
                case 'ref_Filter':
                component.set('v.refFilter',value);
                break
        }
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
                else if(booking.ExecuteAt && booking.ExecuteAt.toLowerCase().includes(searchText)) filterdList.push(booking);
                    else if(booking.Recipient_IBAN__c && booking.Recipient_IBAN__c.toLowerCase().includes(searchText)) filterdList.push(booking);
                        else if(booking.Recipient_Name__c && booking.Recipient_Name__c.toLowerCase().includes(searchText)) filterdList.push(booking);
                            else if(booking.Reference__c && booking.Reference__c.toLowerCase().includes(searchText)) filterdList.push(booking);
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
    showRecordDetails: function(component, event, helper){
        let recordID=event.currentTarget.name; 
        helper.openRecordSubTab(component,recordID,'Scheduled_Order__c');
    },
    onrecordSelect: function(component, event, helper) {
        let text = event.getSource().get("v.name");
        let checked = event.getSource().get("v.checked");
        let orignalDataList=component.get('v.orignalDataList');
        let selectedBookings=component.get('v.selectedStandingOrders');
        orignalDataList.forEach(function(data){
            if(data.Id===text){
                data.selected=checked;
            }
        });
        component.set('v.selectedStandingOrders',orignalDataList.filter(data=>data.selected));
        component.set('v.orignalDataList',orignalDataList);
	},
    prevpage: function(component, event, helper) {
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
    nextpage: function(component, event, helper) {
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
})