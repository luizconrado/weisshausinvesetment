({
     checkFileVersion:function(component,tag,option){
        let _helper=this;
         component.set('v.loading',true);
        _helper.callApex(component,'retriveTagedVersions',function(response){
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                console.log(data)
                if(data && data.length>0){
                    let group = data.reduce(function (r, a) {
                        r[a.ContentDocumentId] = [...r[a.ContentDocumentId] || [],a];
                        return r;
                    }, Object.create(null));
                    let filesList=[];
                    
                    Object.keys(group).forEach(function(documentId){
                        let files=group[documentId];
                        let parentFile={};
                        let versions=[];
                        files.forEach(function(file,index){
                            file.ContentModifiedDate=_helper.formatDateTime(file.ContentModifiedDate);
                            file.expaned=false;
                            if(index==0){
                                parentFile=file;
                            }
                            else{
                                versions.push(file);
                            }
                        });
                        parentFile.versions=versions;
                        filesList.push(parentFile);
                        
                    })
                     
                    if(option=='option1') component.set('v.fileVersionOption1',filesList);
                    if(option=='option2') component.set('v.fileVersionOption2',filesList);
                    if(option=='option3') component.set('v.fileVersionOption3',filesList);
                    if(option=='option4') component.set('v.fileVersionOption4',filesList);
                 }
                else{
                    if(option=='option1')  component.set('v.fileVersionOption1',[]);
                    if(option=='option2')  component.set('v.fileVersionOption2',[]);
                    if(option=='option3')  component.set('v.fileVersionOption3',[]);
                    if(option=='option4')  component.set('v.fileVersionOption4',[]);
                }
                 
                 
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                console.errors(JSON.stringify(JSON.parse(errors)));
            }
            if(option=='option1') component.set('v.contentDocumentChecked1',true);
            if(option=='option2') component.set('v.contentDocumentChecked2',true);
            if(option=='option3') component.set('v.contentDocumentChecked3',true);
            if(option=='option4') component.set('v.contentDocumentChecked4',true);
            component.set('v.loading',false);
        },{
            objectName: component.get('v.sObjectName'),
            recordId: component.get('v.recordId'),
            tag:tag
        })
    },
    updateFileTag:function(component,tag,documnetIds){
        let _helper=this;
        console.log('documnetIds',documnetIds)
        component.set('v.loading',true);
        _helper.callApex(component,'tagVersionFiles',function(response){
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                let list=component.get('v.uploadedIds');
                list.push(...documnetIds);
                component.set('v.uploadedIds',list);
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                console.errors(JSON.stringify(JSON.parse(errors)));
            }
            
            component.set('v.loading',false);
        },{
            objectName: component.get('v.sObjectName'),
            recordId: component.get('v.recordId'),
            tag:tag,
            documnetIds:documnetIds
        });
    },
   
    getOptions:function(component){
        let _helper=this;
        component.set('v.loading',true);
        _helper.callApex(component,'getOptions',function(response){
            let state = response.getState();
            let data = response.getReturnValue();
            if (state === "SUCCESS") {
                console.log('data',data)
                let options=data.map(function(option){
                    return {
                        label:option,
                        value:option,
                        selected:false
                    }});
                options.unshift({
                    label:'',
                    value:'',
                    selected:false
                })
                component.set('v.fileTypes',options);
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                console.errors(JSON.stringify(JSON.parse(errors)));
            }
            component.set('v.loading',false);
        },{
            objectName:component.get('v.sObjectName'),
            recordId:component.get('v.recordId')
        })
        
    },
    callApex: function (component, actionName, callback, params) {
        let action = component.get("c." + actionName);
        if (params)
            action.setParams(params);
        action.setCallback(this, callback);
        $A.enqueueAction(action);
    },
    closepopup: function (component) {
        $A.get("e.force:closeQuickAction").fire();
        
    },
    formatDateTime: function (value) {
        if (!value) return '';
        let locale = $A.get('$Locale');
        if (value.includes('T')) {
            $A.localizationService.UTCToWallTime(new Date(value), $A.get('$Locale.timezone'), function (offSetDateTime) {
                value = offSetDateTime;
            });
            return $A.localizationService.formatDateTimeUTC(
                value, (locale.dateFormat, ' ', locale.timeFormat));
        }
        return $A.localizationService.formatDate(value, locale.dateFormat);
    },
    showToast: function (title, message, type) {
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire();
    },
})