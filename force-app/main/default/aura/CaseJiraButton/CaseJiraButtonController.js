({
    onInit : function(component, event, helper) {
         let caseId=component.get('v.recordId')
        helper.callApex(component,'checkIsCompactLayout',function(response){
            let data = response.getReturnValue();
            component.set('v.isCompactLayout',data);
        })
        component.set('v.loading',true);
         helper.callApex(component,'getBankCaseTypes',function (response) {
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                let caseTypes=Object.keys(data).map(function(values){
                    if(values=='AML'){}
                    else
                    return {
                        label:data[values],
                        value:values,
                        selected:false
                    }
                }).filter(type=>type);
                caseTypes.unshift({
                    label: '',
                    value: '',
                    selected: false
                })
                component.set('v.caseTypes',caseTypes);
                component.set('v.typeLoaded',true);
                if(component.get('v.subTypeLoaded') && component.get('v.typeLoaded')){
                    component.set('v.loading',false);
                    helper.retriveCaseDetails(component,caseId);
                }
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                console.errors(JSON.stringify(JSON.parse(errors)));
            }
        });
        helper.callApex(component,'getCaseIITypes',function (response){
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                component.set('v.caseIITypes',data);
                component.set('v.subTypeLoaded',true);
                
                if(component.get('v.subTypeLoaded') && component.get('v.typeLoaded')){
                    component.set('v.loading',false);
                    helper.retriveCaseDetails(component,caseId);
                }
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                console.errors(JSON.stringify(JSON.parse(errors)));
            }
        });
    },
    onTypeSelect:function(component, event, helper) {
        component.set('v.selectedTypeII')
        helper.setDependentCaseTypes(component,component.get('v.selectedType'),'');
        
    },
    onTypeIISelect:function(component, event, helper) {
        helper.getAllProcessDetails(component);
    },
    onBookingSelect:function(component, event, helper) {
        let id = event.getSource().get("v.name");
        let checked = event.getSource().get("v.checked");
        let BookingsItemList=component.get('v.BookingsItemList');
        BookingsItemList.forEach(function(item){
            item.selected=false;
            if(item.id===id){
                item.selected=checked;
                
                component.set('v.selectedItemId',(checked)?item.id:'');
            }
        })
        component.set('v.BookingsItemList',BookingsItemList);
    },
    onCaseBookingSelect:function(component, event, helper) {
        let id = event.getSource().get("v.name");
        let checked = event.getSource().get("v.checked");
        let BookingsItemList=component.get('v.BookingsItemList');
        BookingsItemList.forEach(function(item){
            if(item.id===id){
                item.selected=checked;
            }
        })
        component.set('v.BookingsItemList',BookingsItemList);
    },
    onFileOptionsSelect:function(component, event, helper) {
        
        let selectedMenuItemValue = event.getParam("value");
        let prop=selectedMenuItemValue.split('_');
        let fileVersions=component.get('v.fileVersions');
        if(prop[1]=='expand'){
            fileVersions.forEach(function(file){
                if(file.ContentDocumentId==prop[0]){
                    file.expaned=!file.expaned;
                }
            })
            component.set('v.fileVersions',fileVersions)
        }
        else if(prop[1]=='upload'){
            $A.get('e.lightning:openFiles').fire({
                recordIds: [prop[0]]
            });
        }        
    },
    handleAttachFile:function(component, event, helper){
        let pgRef= {    
            "type": "standard__component",
            "attributes": {
                "componentName": "c__UploadFileAction"    
            },    
            "state": {
                "c__recordId": component.get('v.recordId'),
                "c__objectName":'Case',
            }
        }
        let workspaceAPI = component.find("workspace");
        workspaceAPI.isConsoleNavigation().then(function(){
            workspaceAPI.getFocusedTabInfo().then(function(response) {
                let focusedTabId = response.tabId;
                helper.save(component);
                workspaceAPI.openSubtab({
                    parentTabId:focusedTabId,
                    pageReference:pgRef,
                    focus:true})
                .then(function(response) {
                    const subTabId=response;
                    // workspaceAPI.closeTab({tabId:focusedTabId});
                    workspaceAPI.setTabLabel({tabId:subTabId, label:'New Bank Case Items'})
                    workspaceAPI.setTabIcon({tabId:subTabId, icon:'standard:delegated_account', iconAlt:'Bank Account'})
                });
            })
            .catch(function(error) {
                console.error('onInit',error);
            }); 
        })
        
    },
    onBack:function(component, event, helper) {
        let currentStep=component.get('v.currentStep');
        
        let prevStep=parseInt(currentStep)-1;
        prevStep+='';
        if(currentStep=='1'){
            helper.closepopup(component);
        }
        else if(currentStep=='2'){
            component.set('v.caseItemList', []);
            component.set('v.selectedItemId');
            component.set('v.isClose',true);
            component.set('v.articleDetails');
            component.set('v.currentStep',prevStep);
        }
        else if(currentStep=='3'){
            component.set('v.currentStep',prevStep);
            component.set('v.isSave',false);
        }
        else if(currentStep=='4'){
            component.set('v.fileVersions',[]);
            component.set('v.currentStep',prevStep);
            component.set('v.isSave',false);
        }
        
    },
    onNext:function(component, event, helper) {
        let currentStep=component.get('v.currentStep');
         
        let nextStep=parseInt(currentStep)+1;
        nextStep+='';
        if(!helper.validate(component,currentStep,nextStep)) return;

        if(currentStep=='1'){
            component.set('v.isClose',false);
            component.set('v.currentStep',nextStep);
            helper.getAllProcessDetails(component);
           	helper.getAllJiraDetails(component,nextStep);
        }
        else if(currentStep=='2'){
            component.set('v.currentStep',nextStep);
            helper.getAllJiraDetails(component,nextStep);
        }
        else if(currentStep=='3'){
            component.set('v.currentStep',nextStep);
            component.set('v.isSave',true);
            helper.checkFileVersion(component);
        }
        else if(currentStep=='4'){
            helper.save(component);
        }
    },
    close:function(component, event, helper) {
        helper.closepopup(component);
    },
})