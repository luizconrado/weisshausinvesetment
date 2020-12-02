({
    onInit : function(component, event, helper) {
        let selectedCard=component.get('v.selectedCard');
        let bankAccountDetails=component.get('v.bankAccountDetails');
        component.set('v.loading',true);
        helper.callApex(component,'getAllBankCards',function(response){
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                data.forEach(function(card){
                    card.selected=(selectedCard && selectedCard.Id==card.Id)?true:false;
                })
                console.log('data',data)
                component.set('v.cardsList',data);
                component.set('v.orignalCardsList',data);
                
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                console.log(errors);
            }
            component.set('v.loading',false);
        },{
            sfBankAccountId:bankAccountDetails.Id
        });
    },
    openCardHandler: function(component, event, helper) {
        let cardRecordId=event.currentTarget.name; 
        helper.openRecordSubTab(component,cardRecordId,'Card__c');
    },
    onSelection:function(component,event,helper){
        let orignalList=component.get('v.orignalCardsList');
        let selectionList=component.get('v.cardsList');
        let index=event.getSource().get("v.name");
        let status =event.getSource().get("v.checked");
        selectionList.forEach(function(slist){
            if(slist.Id!==index){
                slist.selected=false;
            }
            if(slist.Id===index){
                slist.selected=status;
            }
        });
        orignalList.forEach(function(orignal){
            if(orignal.Id!==index){
                orignal.selected=false;
            }
            if(orignal.Id===index){
                orignal.selected=status;
            }
        });
        let selectedItem = orignalList.filter(orignal=>orignal.selected);
        if(selectedItem.length>0){
            component.set('v.selectedCard',selectedItem[0])
        }
        else{
            component.set('v.selectedCard')
        }
        
        component.set('v.cardsList',selectionList)
        component.set('v.orignalCardsList',orignalList);
    },
    sortChangeHandler:function(component, event, helper){
        let fieldName=event.currentTarget.name;
        let cardsList=component.get('v.cardsList');
        let sortOrder=component.get('v.sortOrder');
        sortOrder=(sortOrder==='desc')?'asc':'desc';
        let sortAsc=(sortOrder==='desc')?false:true;
        cardsList = cardsList.sort(function(a, b)  {
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
        component.set('v.cardsList',cardsList)
    },
})