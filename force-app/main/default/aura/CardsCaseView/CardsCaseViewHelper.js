({
    callApex:function(component,actionName,callback,params){
        let action = component.get("c."+actionName);
        if(params)
            action.setParams(params);
        action.setCallback(this,callback);
        $A.enqueueAction(action);
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
})