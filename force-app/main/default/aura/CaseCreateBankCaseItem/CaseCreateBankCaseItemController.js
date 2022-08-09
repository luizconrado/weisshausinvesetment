({
    onInit : function(component, event, helper) {
        let pgRef= {    
            "type": "standard__component",
            "attributes": {
                "componentName": "c__BankCaseNewOverride"    
            },    
            "state": {
                "c__recordId": component.get('v.recordId')    
            }
        }
        let workspaceAPI = component.find("workspace");
        workspaceAPI.isConsoleNavigation().then(function(){
            workspaceAPI.getFocusedTabInfo().then(function(response) {
                let focusedTabId = response.tabId;
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
    }
})