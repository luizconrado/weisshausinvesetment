({
    setupData: function (component) {
        const logType=component.get('v.logType');
        
        
        let action = component.get('c.getTotalRecordCount');
        
        action.setParams({
            recordId:component.get('v.recordId'),
            logType:logType
        })
        action.setCallback(this, function (result) {
            let state = result.getState();
            let data = result.getReturnValue();
            if (state == 'SUCCESS') {
                component.set('v.totalCount','('+data+')');
            }
        });
        $A.enqueueAction(action);
        
        
        if(logType==='API'){
            component.set('v.cardTitle','Api Call Logs');
            component.set('v.tableColoums',[
                {title:"Log Number",apiName:"Log_Number__c"},
                {title:"Endpoint",apiName:"Endpoint__c"},
                {title:"Response Status Code",apiName:"Response_Status_Code__c"},
                {title:"User",apiName:"User__c"},
                {title:"Created Date",apiName:"CreatedDate"},
                {title:"Number",apiName:"Name"}
            ]);
            component.set('v.methodName','getAPILogs');
        }
        else if(logType==='ERROR'){
            component.set('v.cardTitle','Error Logs');
            component.set('v.tableColoums',[
                {title:"Log Number",apiName:"Log_Number__c"},
                {title:"Operation",apiName:"Operation__c"},
                {title:"Message",apiName:"Message__c"},
                {title:"User",apiName:"User__c"},
                {title:"Created Date",apiName:"CreatedDate"},
                {title:"Number",apiName:"Name"}
            ]);
            component.set('v.methodName','getErrorLogs');
        }
            else if(logType==='CRP'){
                component.set('v.cardTitle','CRP Logs');
                component.set('v.tableColoums',[
                    {title:"Log Number",apiName:"Name"},
                    {title:"Status",apiName:"Status__c"},
                    {title:"User",apiName:"CreatedById"},
                    {title:"Operation",apiName:"Operation__c"},
                    {title:"Created Date",apiName:"CreatedDate"},
                    
                ]);
            component.set('v.methodName','getCRPLogs');
                
            }
            else if(logType==='HISTORY'){
                component.set('v.cardTitle','Field History Logs');
                component.set('v.tableColoums',[
                    {title:"Log Number",apiName:"Name"},
                    {title:"Field",apiName:"Field_Label__c"},
                    {title:"New Value",apiName:"New_Value__c"},
                    {title:"Old Value",apiName:"Old_Value__c"},
                    {title:"User",apiName:"User__c"},
                    {title:"Operation",apiName:"Operation__c"},
                    {title:"Created Date",apiName:"CreatedDate"},
                ]);
            component.set('v.methodName','getHistoryLogs');
                
            }
           else if(logType==='VIEW'){
                component.set('v.cardTitle','User Visit Logs');
                component.set('v.tableColoums',[
                    {title:"Log Number",apiName:"Name"},
                    {title:"User",apiName:"User__c"},
                    {title:"Created Date",apiName:"CreatedDate"},
                ]);
                    component.set('v.methodName','getViewLogs');
                
                    }        
        
                  
                    
    },
    prepData:function(component,data){
         let helper=this;
        let result=[];
        let tableColoums=component.get('v.tableColoums');
        data.forEach(function(dataValue){
            let node=[];
            tableColoums.forEach(function(coloumConfig){
               
                let nodeValue={};
                nodeValue.apiName=coloumConfig.apiName;
                nodeValue.title=coloumConfig.title;
                nodeValue.logNumber=dataValue.Name;
                nodeValue.value=dataValue[coloumConfig.apiName];  
                if(nodeValue.apiName=='CreatedDate')nodeValue.value=helper.getLocalDate(nodeValue.value);
                else if(nodeValue.apiName=='Log_Number__c')nodeValue.id=dataValue.Id;
                else if(nodeValue.apiName=='User__c')nodeValue.value=dataValue.User__r.Name; 
                else if(nodeValue.apiName=='CreatedById')nodeValue.value=dataValue.CreatedBy.Name; 
                
                node.push(nodeValue);
                
            })
            result.push(node);
        })
        component.set('v.tableData', result);
    },
    fetchData:function(component,logNumber,type){
        let helper=this;
        let action = component.get('c.'+component.get('v.methodName'));
        component.set('v.loading',true);
        action.setParams({
            recordId:component.get('v.recordId'),
            lognumber:logNumber,
            searchType:type
        })
        action.setCallback(this, function (result) {
            let state = result.getState();
            let data = result.getReturnValue();
            if (state == 'SUCCESS') {
                helper.prepData(component,data);
            }
            component.set('v.loading',false);
        });
        $A.enqueueAction(action);
    },
    getLocalDate: function (nodeValue) {
        $A.localizationService.UTCToWallTime(new Date(nodeValue), $A.get('$Locale.timezone'), function (offSetDateTime) {
            nodeValue = offSetDateTime;
        });
        nodeValue = $A.localizationService.formatDateTimeUTC(nodeValue, $A.get('$Locale').dateFormat + ' ' + $A.get('$Locale').timeFormat);
        return nodeValue
    }
})