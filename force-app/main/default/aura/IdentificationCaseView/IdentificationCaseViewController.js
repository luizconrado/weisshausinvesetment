({
    onInit : function(component, event, helper) {
        let selectedIdentList=component.get('v.selectedIdentList');
        let selectedIdentIds=selectedIdentList.map(data=>data.Id);

        let personAccountId=component.get('v.personAccountId');
        if(!personAccountId) return; 
        component.set('v.loading',true);
        helper.callApex(component,'getAllIdentifications',function(response){
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                data.forEach(function(card){
                    card.selected=false;
                    if(selectedIdentIds.includes(card.Id)){
                        card.selected=true;
                    }
                    if(card.Completed_At__c) card.CompletedAt=helper.formatDateTime(card.Completed_At__c);
                });
                console.log('data',data)
                component.set('v.IdentList',data);
                component.set('v.orignalIdentList',data);
                
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                console.log(errors);
            }
            component.set('v.loading',false);
        },{
            sfAccountId:personAccountId
        });
    },
    openIdentHandler: function(component, event, helper) {
        let recordId=event.currentTarget.name; 
        helper.openRecordSubTab(component,recordId,'Identification__c');
    },
    onSelection:function(component,event,helper){
        let orignalList=component.get('v.orignalIdentList');
        let selectionList=component.get('v.IdentList');
        let index = event.getSource().get("v.name");
        let status = event.getSource().get("v.checked");
        
        orignalList.forEach(function(data){
            if(data.Id===index){
                data.selected=status;
            }
        });
        selectionList.forEach(function(data){
            if(data.Id===index){
                data.selected=status;
            }
        });
        
       
        let selectedItem = orignalList.filter(orignal=>orignal.selected);
        component.set('v.selectedIdentList',selectedItem);

        component.set('v.IdentList',selectionList)
        component.set('v.orignalIdentList',orignalList);
    },
    sortChangeHandler:function(component, event, helper){
        let fieldName=event.currentTarget.name;
        let cardsList=component.get('v.IdentList');
        let sortOrder=component.get('v.sortOrder');
        sortOrder=(sortOrder==='desc')?'asc':'desc';
        let sortAsc=(sortOrder==='desc')?false:true;
        cardsList = cardsList.sort(function(a, b)  {
            if (a[fieldName] && a[fieldName] < b[fieldName]) {
                return sortAsc ? -1 : 1;
            }
            else if (a[fieldName] && a[fieldName] > b[fieldName]) {
                return sortAsc ? 1 : -1;
            }
            else if(!a[fieldName]){
                return  -1; 
            }
            else {
                return 0;
            }
        });
        component.set('v.sortBy',fieldName);
        component.set('v.sortOrder',sortOrder);
        component.set('v.IdentList',cardsList)
    },
})