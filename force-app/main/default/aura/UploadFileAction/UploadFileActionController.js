({
    onInit : function(component, event, helper) {
        const pageReference = component.get("v.pageReference");
        if(pageReference && pageReference.state){
            if(pageReference.state.c__recordId){
                let caseId=pageReference.state.c__recordId;
                let objectName=pageReference.state.c__objectName;
                component.set('v.isSubTab',true);
                component.set('v.recordId',caseId);
                component.set('v.sObjectName',objectName);
            }
        }
        
		helper.getOptions(component);
	},
	onCancle : function(component, event, helper) {
        let isSubTab=component.get('v.isSubTab');
        let isPopup=component.get('v.isPopup');
        let recordId=component.get('v.recordId')
        if(isSubTab){
            let workspaceAPI = component.find("workspace");
            workspaceAPI.isConsoleNavigation().then(function(isConsole){
                if(isConsole){
                    workspaceAPI.getFocusedTabInfo().then(function(response) {
                        let focusedTabId = response.tabId;
                        workspaceAPI.closeTab({tabId:focusedTabId});
                    });    
                }
                else{
                    let navService = component.find("navService");
                    let pageReference={
                        type: 'standard__recordPage',
                        attributes: {
                            objectApiName: 'Case',
                            actionName: 'view',
                            recordId:recordId
                        }
                    }
                    navService.navigate(pageReference);
                }
                
            })
        }
        else if(isPopup){
            component.set('v.isPopup',false)
        }
        else{
                $A.get("e.force:closeQuickAction").fire();
         }
        
        
	},
    onAddMore: function(component, event, helper){
        let showOption2=component.get('v.showOption2');
        let showOption3=component.get('v.showOption3');
        let showOption4=component.get('v.showOption4');
        if(showOption2==false){
            component.set('v.showOption2',true);
        }
        else if(showOption3==false){
            component.set('v.showOption3',true);
        }
            else if(showOption4==false){
                component.set('v.showOption4',true);
                component.set('v.disableAddMoreButton',true);
            }
      
    },
    onTypeSelect: function(component, event, helper) {
        let name=event.getSource().get("v.name");
        if(name=='option1'){
            let contentDocumentOption1=component.get('v.contentDocumentOption1');
            let contentDocumentOtherOption1=component.get('v.contentDocumentOtherOption1');
            if(!contentDocumentOption1){
                helper.showToast('Select option','Please select option','warning')        
                return;
            }
            if(contentDocumentOption1=='Other' && !contentDocumentOtherOption1){
                //helper.showToast('Enter option','Please enter option','warning')        
                return;
            }
            else if(contentDocumentOption1=='Other'&& !contentDocumentOtherOption1 && !contentDocumentOtherOption1.trim()){
                //helper.showToast('Enter option','Please enter option','warning')        
                return;
            }
            let tag = (contentDocumentOption1!='Other') ? contentDocumentOption1  : contentDocumentOtherOption1;
            console.log('tag',tag);
            helper.checkFileVersion(component,tag,'option1');
		}
        else if(name=='option2'){
            let contentDocumentOption2=component.get('v.contentDocumentOption2');
            let contentDocumentOtherOption2=component.get('v.contentDocumentOtherOption2');
            if(!contentDocumentOption2){
                helper.showToast('Select option','Please select option','warning')        
                return;
            }
            if(contentDocumentOption2=='Other' && !contentDocumentOtherOption2){
                //helper.showToast('Enter option','Please enter option','warning')        
                return;
            }
            else if(contentDocumentOption2=='Other' && !contentDocumentOtherOption2.trim()){
                //helper.showToast('Enter option','Please enter option','warning')        
                return;
            }
            let tag = (contentDocumentOption2!='Other') ? contentDocumentOption2  : contentDocumentOtherOption2;
            console.log('tag',tag);
            helper.checkFileVersion(component,tag,'option2');
		}
        else if(name=='option3'){
            let contentDocumentOption3=component.get('v.contentDocumentOption3');
            let contentDocumentOtherOption3=component.get('v.contentDocumentOtherOption3');
            if(!contentDocumentOption3){
                helper.showToast('Select option','Please select option','warning')        
                return;
            }
            if(contentDocumentOption3=='Other' && !contentDocumentOtherOption3){
                //helper.showToast('Enter option','Please enter option','warning')        
                return;
            }
            else if(contentDocumentOption3=='Other' && !contentDocumentOtherOption3.trim()){
                //helper.showToast('Enter option','Please enter option','warning')        
                return;
            }
            let tag = (contentDocumentOption3!='Other') ? contentDocumentOption3  : contentDocumentOtherOption3;
            console.log('tag',tag);
            helper.checkFileVersion(component,tag,'option3');
		}
        else if(name=='option4'){
            let contentDocumentOption4=component.get('v.contentDocumentOption4');
            let contentDocumentOtherOption4=component.get('v.contentDocumentOtherOption4');
            if(!contentDocumentOption4){
                helper.showToast('Select option','Please select option','warning')        
                return;
            }
            if(contentDocumentOption4=='Other' && !contentDocumentOtherOption4){
                //helper.showToast('Enter option','Please enter option','warning')        
                return;
            }
            else if(contentDocumentOption4=='Other' && !contentDocumentOtherOption4.trim()){
                //helper.showToast('Enter option','Please enter option','warning')        
                return;
            }
            let tag = (contentDocumentOption4!='Other') ? contentDocumentOption4  : contentDocumentOtherOption4;
            console.log('tag',tag);
            helper.checkFileVersion(component,tag,'option4');
		}
	},
    onFileOptionsSelect:function(component, event, helper) {
        
        let selectedMenuItemValue = event.getParam("value");
        let prop=selectedMenuItemValue.split('_');
        let fileVersions=[];
        
        if(prop[2]=='option1')  fileVersions=component.get('v.fileVersionOption1');
        else if(prop[2]=='option2')  fileVersions=component.get('v.fileVersionOption2');
        else if(prop[2]=='option3')  fileVersions=component.get('v.fileVersionOption3');
        else if(prop[2]=='option4')  fileVersions=component.get('v.fileVersionOption4');
        if(prop[1]=='expand'){
            fileVersions.forEach(function(file){
                if(file.ContentDocumentId==prop[0]){
                    file.expaned=!file.expaned;
                }
            })
            if(prop[2]=='option1')   component.set('v.fileVersionOption1',fileVersions);
            else if(prop[2]=='option2')   component.set('v.fileVersionOption2',fileVersions);
            else if(prop[2]=='option3')   component.set('v.fileVersionOption3',fileVersions);
             else if(prop[2]=='option4')   component.set('v.fileVersionOption4',fileVersions);
        }
        else if(prop[1]=='upload'){
            $A.get('e.lightning:openFiles').fire({
                recordIds: [prop[0]]
            });
        }        
    },
    handleUploadOption1 : function(component, event, helper) {
        // Get the list of uploaded files
        let uploadedFiles = event.getParam("files");
        let documentIds=[];
        let contentDocumentOption1=component.get('v.contentDocumentOption1');
        let contentDocumentOtherOption1=component.get('v.contentDocumentOtherOption1');
        let tag = (contentDocumentOption1!='Other') ? contentDocumentOption1  : contentDocumentOtherOption1;
		uploadedFiles.forEach(function(file){
            documentIds.push(file.documentId);
        });
        if(documentIds.length==0) return;
        component.set('v.contentDocumentUploaded1',true);
        helper.updateFileTag(component,tag,documentIds)
	},
    handleUploadOption2 : function(component, event, helper) {
        // Get the list of uploaded files
        let uploadedFiles = event.getParam("files");
        let documentIds=[];
        let contentDocumentOption2=component.get('v.contentDocumentOption2');
        let contentDocumentOtherOption2=component.get('v.contentDocumentOtherOption2');
        let tag = (contentDocumentOption2!='Other') ? contentDocumentOption2  : contentDocumentOtherOption2;
		uploadedFiles.forEach(function(file){
            documentIds.push(file.documentId);
        });
        if(documentIds.length==0) return;
        component.set('v.contentDocumentUploaded2',true);
        helper.updateFileTag(component,tag,documentIds)
	},
    handleUploadOption3 : function(component, event, helper) {
        // Get the list of uploaded files
        let uploadedFiles = event.getParam("files");
        let documentIds=[];
        let contentDocumentOption3=component.get('v.contentDocumentOption3');
        let contentDocumentOtherOption3=component.get('v.contentDocumentOtherOption3');
        let tag = (contentDocumentOption3!='Other') ? contentDocumentOption3  : contentDocumentOtherOption3;
		uploadedFiles.forEach(function(file){
            documentIds.push(file.documentId);
        });
        if(documentIds.length==0) return;
        component.set('v.contentDocumentUploaded3',true);
        helper.updateFileTag(component,tag,documentIds)
	},
    handleUploadOption4 : function(component, event, helper) {
        // Get the list of uploaded files
        let uploadedFiles = event.getParam("files");
        let documentIds=[];
        let contentDocumentOption4=component.get('v.contentDocumentOption4');
        let contentDocumentOtherOption4=component.get('v.contentDocumentOtherOption4');
        let tag = (contentDocumentOption4!='Other') ? contentDocumentOption4  : contentDocumentOtherOption4;
		uploadedFiles.forEach(function(file){
            documentIds.push(file.documentId);
        });
        if(documentIds.length==0) return;
        component.set('v.contentDocumentUploaded4',true);
        helper.updateFileTag(component,tag,documentIds)
	},
})