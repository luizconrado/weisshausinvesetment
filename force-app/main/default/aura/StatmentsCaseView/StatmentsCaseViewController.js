({
    onInit: function(component, event, helper) {
        let start = new Date();
        let end = new Date();
        end.setMonth(end.getMonth() - 4);
        let dateFilterStart = end.getFullYear() + '-' + (end.getMonth() + 1) + '-' + end.getDate();
        let dateFilterEnd = (start.getFullYear()) + '-' + (start.getMonth() + 1) + '-' + start.getDate();
        component.set('v.dateFilterStart',dateFilterStart);
        component.set('v.dateFilterEnd',dateFilterEnd);
        component.set('v.yearFilter',start.getFullYear());
        component.set('v.quaterFilter',1);
        helper.callApex(component,'checkIsCompactLayout',function(response){
            let data = response.getReturnValue();
            component.set('v.isCompactLayout',data);
        })
    },
    handleTypeSelection : function(component, event, helper) {
        let type = event.getSource().get('v.value');
        if(type==='range'){
            component.set('v.isRange',true);
        }
        else{
            component.set('v.isRange',false);
        }
    },
    getRecords:function(component, event, helper) {
        let isRange=component.get('v.isRange');
        let bankAccountDetails=component.get('v.bankAccountDetails')
        let dateFilterStart=component.get('v.dateFilterStart');
        let dateFilterEnd=component.get('v.dateFilterEnd');
        let periodFilter=component.get('v.periodFilter');
        let yearFilter=component.get('v.yearFilter');
        let quaterFilter=component.get('v.quaterFilter');
        
        if(periodFilter=='MONTHLY' && quaterFilter > 13){
            helper.showToast('Enter Valid Year','Please enter valid month','warning');
            return;
        }
        else if(periodFilter=='QUARTERLY' && quaterFilter > 5){
            helper.showToast('Enter Valid Quater','Please enter valid quater','warning');
            return;
        }
        else if(periodFilter=='ANNUALLY'){
                quaterFilter=1;
       	}
        
        let body;
        if (isRange) {
            body = {
                "start_date": dateFilterStart,
                "end_date": dateFilterEnd
            }
        }
        else {
            body = {
                "interval": periodFilter,
                "year": yearFilter,
                "period":quaterFilter
            }
        }
        component.set('v.loading',true);
        console.log(isRange,body);
        helper.callApex(component,'createStatment',function(response){
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                let result = JSON.parse(data);
                console.log('data,',data)
                if(result.errors){
                    component.set('v.apiErrors',result.errors);
                    component.set('v.loading',false);
                    return;
                }
                let Name = 'Statement';
                if(isRange){
                    Name = 'Statement - '+ bankAccountDetails.Name  + ' - ' + dateFilterStart + ' - ' + dateFilterEnd;
                }
                else{
                    if(periodFilter!='ANNUALLY'){
                        Name ='Statement - '+ bankAccountDetails.Name  + ' - ' +periodFilter + ' - ' + yearFilter + ' - ' + quaterFilter;    
                    }
                    else{
                        Name ='Statement - '+ bankAccountDetails.Name  + ' - ' +periodFilter + ' - ' + yearFilter;
                    }
                    
                }
                component.set('v.apiErrors');
                let Statement__c = {
                    Name:Name,
                    Solarisbank_Id__c: result.id,
                    Bank_Account__c:bankAccountDetails.Id,
                    Statement_Period_Start_Date__c:result.statement_period_start_date,
                    Statement_Period_End_Date__c:result.statement_period_end_date,
                    Balance_Start__c:result.account_information.balance_start.value,
                    Balance_End__c:result.account_information.balance_end.value,
                    Unit__c:result.account_information.balance_start.unit,
                    Issue_Date__c:result.issue_date,
                    Disclaimer__c:result.disclaimer,
                    
                    startDate: helper.formatDateTime(result.statement_period_start_date/100),
                    endDate: helper.formatDateTime(result.statement_period_end_date/100),
                    issueDate: result.issue_date,
                    balanceStart: helper.formatCurrency(result.account_information.balance_start.value/100),
                    balanceEnd: helper.formatCurrency(result.account_information.balance_end.value/100),
                }
                
                component.set('v.selectedStatementInfo',Statement__c);
            
                helper.generateStatement(component);
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                console.log(errors);
                 component.set('v.loading',false);
            }
           
        },{
            recordId:component.get('v.caseRecordId'),
            bankAccountDetails:bankAccountDetails,
            filterdByRange:isRange,
            sbAccountId:bankAccountDetails.Solarisbank_Id__c,
            body:JSON.stringify(body)
        })
      
        
    },
    searchTable: function(component, event, helper) {
        let searchText = event.getSource().get("v.value");
        let orignalDataList=component.get('v.orignalDataList');
        if(searchText.length>2){
            searchText=searchText.toLowerCase();
            let filterdList = [];
            for (let i = 0; i < orignalDataList.length; i++) {
                let booking=orignalDataList[i];
                if( booking.bookingDate && booking.bookingDate.toLowerCase().includes(searchText)) filterdList.push(booking) ;
                else if(booking.description && booking.description.toLowerCase().includes(searchText)) filterdList.push(booking);
                    else if(booking.price && booking.price.toLowerCase().includes(searchText)) filterdList.push(booking);
                        else if(booking.recipient_iban && booking.recipient_iban.toLowerCase().includes(searchText)) filterdList.push(booking);
                            else if(booking.sender_iban && booking.sender_iban.toLowerCase().includes(searchText)) filterdList.push(booking);
                                else if(booking.transaction_id && booking.transaction_id.toString().includes(searchText)) filterdList.push(booking);
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