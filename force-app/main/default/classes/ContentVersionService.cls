/***************
* @group Service Class
* @description all Content Version related logic is here
*/
public class ContentVersionService {
    

    
    /***************
    * @description sends investment file details to EV and make fields visible to all
    * @param cvIdList list of content version ids
    */
    @future(callout=true)
    public static void sendDocumentInfoToEV(List<String> cvIdList){
        //add integeration user as share record
        List<ContentDocumentLink> toUpdatecdl=new List<ContentDocumentLink>();
        
        //get file details
        List<String> contentDocumnetIdList=new List<String>();
        Map<String,ContentVersion> contentDocumentIdAndVersionMap=new Map<String,ContentVersion>();
        List<ContentVersion> contentVersionsList=[SELECT Id,FileExtension, FileType , ContentDocumentId,ContentDocument.ParentId, Type__c, VersionNumber, ContentUrl, Title 
                                                  FROM ContentVersion 
                                                  WHERE 
                                                  Id IN:cvIdList];
        
        for(ContentVersion cv:contentVersionsList){
            contentDocumnetIdList.add(cv.ContentDocumentId);
            contentDocumentIdAndVersionMap.put(cv.ContentDocumentId, cv);
        }
        
        //get relation details
        List<String> oppIdList=new List<String>();
        Map<String,ContentDocumentLink> entityIdAndLinkMap=new Map<String,ContentDocumentLink>();
        List<ContentDocumentLink> documentLinkList=[SELECT Id, LinkedEntityId,ShareType,LinkedEntity.Name,LinkedEntity.Type, ContentDocumentId 
                                                    FROM ContentDocumentLink 
                                                    WHERE 
                                                    ContentDocumentId IN:contentDocumnetIdList
                                                   ];
        
        
        for(ContentDocumentLink cdl:documentLinkList){
            if(cdl.LinkedEntity.Type=='Opportunity'){
                oppIdList.add(cdl.LinkedEntityId);
                entityIdAndLinkMap.put(cdl.LinkedEntityId,cdl);
            }
        }
        if(oppIdList.size()>0){
            //getRecord
            List<Opportunity> oppRecordsList=[SELECT id,Account.EVSM_Auth0_Id__c,External_Id__c,Account.Solarisbank_Tenent__c,CreatedDate FROM Opportunity WHERE id IN:oppIdList AND RecordTypeId=:Constant.OPPORTUNITY_INVESMENT_RECORDTYPEID];
            
            
            
            
            for(Opportunity o:oppRecordsList){
                try{
                    LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(o.Id,'Opportunity',o.Account.Solarisbank_Tenent__c);
                    ContentDocumentLink linkRecord=entityIdAndLinkMap.get(o.Id);
                    ContentVersion versionRecord=contentDocumentIdAndVersionMap.get(linkRecord.ContentDocumentId);
                    if(linkRecord.ShareType=='V' && linkRecord.LinkedEntity.Type=='Opportunity'){
                        linkRecord.ShareType='I';
                        toUpdatecdl.add(linkRecord);
                    }
                    String fileName=versionRecord.Title.split('\\|').get(0);
                    
                    Map<String,Object> body=new Map<String,Object>();
                    body.put('object', 'Opportunity');
                    body.put('opportunityRecordId', o.Id);
                    body.put('documentId', versionRecord.ContentDocumentId);
                    body.put('name', fileName+'.'+versionRecord.FileExtension);
                    body.put('documentUrl',Salesforce.baseUrl+'/services/data/v53.0/sobjects/ContentVersion/'+versionRecord.id+'/VersionData');
                    body.put('fileType',versionRecord.FileType);
                    body.put('customerId',o.Account.EVSM_Auth0_Id__c);
                    body.put('investmentId',o.External_Id__c);
                    body.put('createdDate',o.CreatedDate); 
                    body.put('title',fileName);
                    body.put('fileTag',versionRecord.Type__c);
                    EVExternalService.sendInvestmentDocumentInformation(o.External_Id__c, JSON.serialize(body), apiCallDetails);     	
                }
                Catch(Exception e){
                    logError(e,o.Id,'sendDocumentInfoToEV','ContentVersionTrigger','Send Document To BE');
                }
                
            }
            try{
                if(toUpdatecdl.size()>0) update toUpdatecdl;
            }
            catch(Exception e){
                logError(e,null,'sendDocumentInfoToEV','ContentVersionTrigger','Link Integeration User');
            }
        }
        
        
    }
    
    @future(callout=true)
    public static void sendCaseArchiveZipToEv(List<String> cvIdList){
        
    }
    
    @testVisible
    private static void logError(Exception e,String recordId,String methodName,String componentName,String action){
        LogService.LogMetadata errorDetails=new LogService.LogMetadata();
        errorDetails.addError(e);
        errorDetails.addMetadataInfo(userinfo.getUserId(), 'ContentVersionService', methodName, componentName,action);
        errorDetails.addRecordInfo('Opportunity',recordId);
        LogService.logError(errorDetails);
    }
    
    
}