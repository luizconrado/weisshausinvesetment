({
	onRender : function(component, event, helper) {
        if(component.get('v.isRender')) return;
        component.set('v.isRender',true);
        let value = helper.getParameterByName(component , event, 'inContextOfRef');
        if(!value){
            //fail safe redundent code if render method is called befor url is loaded
            window.setTimeout(
                $A.getCallback(function() {
                    value = helper.getParameterByName(component , event, 'inContextOfRef');
                    let context = JSON.parse(window.atob(value));
                    let caseId=context.attributes.recordId;
                    helper.callApex(component,'getBankCaseTypes',function (response) {
                        let state = response.getState();
                        let data = response.getReturnValue();
                        if (state === "SUCCESS") {
                            let caseTypes=Object.keys(data).map(function(values){
                                return {
                                    label:data[values],
                                    value:values,
                                    selected:false
                                }
                            });
                             console.log('caseTypes',caseTypes)
                            component.set('v.caseTypes',caseTypes);
                            component.set('v.typeLoaded',true);
                            helper.retriveCaseDetails(component,caseId);
                            
                        }
                        else if (state === "ERROR") {
                            let errors = response.getError();
                            console.log(errors);
                        }
                    });
                    helper.callApex(component,'getCaseIITypes',function (response){
                        let state = response.getState();
                        let data = response.getReturnValue();
                        if (state === "SUCCESS") {
                            component.set('v.caseIITypes',data);
                            component.set('v.subTypeLoaded',true);
                            helper.retriveCaseDetails(component,caseId);
                        }
                        else if (state === "ERROR") {
                            
                        }
                    });
                }), 1000
            );
        }
        else{
            let context = JSON.parse(window.atob(value));
            let caseId=context.attributes.recordId;
            helper.callApex(component,'getBankCaseTypes',function (response) {
                let state = response.getState();
                let data = response.getReturnValue();
                if (state === "SUCCESS") {
                    let caseTypes=Object.keys(data).map(function(values){
                        return {
                            label:data[values],
                            value:values,
                            selected:false
                        }
                    });
                    console.log('caseTypes',caseTypes)
                    component.set('v.caseTypes',caseTypes);
                    component.set('v.typeLoaded',true);
                    helper.retriveCaseDetails(component,caseId);
                    
                }
                else if (state === "ERROR") {
                    let errors = response.getError();
                    console.log(errors);
                }
            });
            helper.callApex(component,'getCaseIITypes',function (response){
                let state = response.getState();
                let data = response.getReturnValue();
                if (state === "SUCCESS") {
                    component.set('v.caseIITypes',data);
                    component.set('v.subTypeLoaded',true);
                    helper.retriveCaseDetails(component,caseId);
                }
                else if (state === "ERROR") {
                    
                }
            });
        }
        
        
	},
    onBankSearch: function(component, event, helper) {
        let value=event.getSource().get("v.value");
        let personBanks=component.get('v.personBanks');
        let orignalPersonBanks=component.get('v.orignalPersonBanks');
        if(value.length>2){
            component.set('v.personBanks',orignalPersonBanks.filter(bank=>bank.Name.includes(value)));
        }
        else{
            component.set('v.personBanks',orignalPersonBanks);        
        }
	}, 
    onBankSelection:function(component, event, helper) {
        let index = event.getSource().get("v.name");
        let personBanks=component.get('v.personBanks');
        let orignalPersonBanks=component.get('v.orignalPersonBanks');
        personBanks.forEach(function(bank){
            if(bank.Id!==index){
                bank.selected=false;
            }
        });
        orignalPersonBanks.forEach(function(bank){
            if(bank.Id!==index){
                bank.selected=false;
            }
        });
        
        let selectedItem=orignalPersonBanks.filter(bank=>bank.selected);
        if(selectedItem.length>0){
            component.set('v.selectedBank',selectedItem[0])
        }
        else{
            component.set('v.selectedBank')
        }
        
        //reset all selection
        component.set('v.selectedBookings',[])
        
        component.set('v.personBanks',personBanks)
        component.set('v.orignalPersonBanks',orignalPersonBanks);
	},
    onBack : function(component, event, helper) {
        let currentStep=component.get('v.currentStep');
        
        switch(currentStep) {
            case 'selectType':
                helper.closeSubTab(component);
                component.set('v.currentStep','selectType');
                break;
            case 'selectBank':
                component.set('v.isClose',true);
                component.set('v.currentStep','selectType');
                break;
            case 'selectRecord':
                component.set('v.currentStep','selectBank');
                break;
            case 'createRecord':
                 component.set('v.isSave',false);
                component.set('v.currentStep','selectRecord');
                break;
                
        }
        helper.setHeader(component);
	}, 
    onNext : function(component, event, helper) {
        let currentStep=component.get('v.currentStep');
        let stop=helper.validate(component);
        if(stop) return ;
        switch(currentStep) {
            case 'selectType':
                component.set('v.isClose',false);
                component.set('v.currentStep','selectBank');
                break;
            case 'selectBank':
                component.set('v.currentStep','selectRecord');
                break;
            case 'selectRecord':
                component.set('v.isSave',true);
                component.set('v.currentStep','createRecord');
                break;
            case 'createRecord':
                component.set('v.currentStep','createRecord');
                helper.saveSelection(component);
                break;
                
        }
        helper.setHeader(component);
	},
    onTypeSelect: function(component, event, helper){
        helper.setDependentCaseTypes(component,component.get('v.selectedType'),'');
    }
})