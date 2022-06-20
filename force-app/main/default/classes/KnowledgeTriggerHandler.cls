/***************
* @group Handler Class
* @description Knowledge Trigger router
*/
public class KnowledgeTriggerHandler extends TriggerHandler {
    protected override void beforeInsert() {
        List<Knowledge__kav> newRecords=Trigger.new;
        Map<String,Knowledge__kav> newDraftLocalArticles=new Map<String,Knowledge__kav>();
        
        
        for(Knowledge__kav record:newRecords){
            
            //auto poupulate url name if not defined
            if(record.UrlName==null || String.isEmpty(record.UrlName)) {
                if(record.Title!=null || !(String.isEmpty(record.Title))) {
                    record.UrlName = record.Title.toLowerCase().replaceAll('[^a-z0-9\\s]','-').replaceAll(' ','-').replaceAll('-+','-').replaceFirst('-','').removeEnd('-').replaceFirst('_','').removeEnd('_').removeEnd('-').abbreviate(255).trim(); 
                }
            } 
            
             //checking if local is created
            if(record.PublishStatus =='Draft' && record.IsMasterLanguage==false){
                newDraftLocalArticles.put(record.KnowledgeArticleId,record);
            }    
        }
        
        //copy english data to local
        if(newDraftLocalArticles.size()>0) copyMasterDataToLocal(newDraftLocalArticles);
        
    }
    
    private static String fieldsToCopy='Summary,Information__c,Question__c,Type__c,Type_II__c,Category__c';
    
    //get master language data
    private static Map<String,Knowledge__kav> getMasterLanguageData(Map<String,Knowledge__kav> draftLocalArticles){
        Map<String,Knowledge__kav> englishArticleMap=new Map<String,Knowledge__kav>();
        
        Set<String> kmArticleIds=draftLocalArticles.keySet();
        //get draft version 
        List<Knowledge__kav> englishDraftArticles=Database.query('SELECT Id,KnowledgeArticleId,'+fieldsToCopy+' FROM Knowledge__kav WHERE KnowledgeArticleId=:kmArticleIds AND PublishStatus =\'Draft\' AND IsMasterLanguage=true ');
        for(Knowledge__kav draftOnline:englishDraftArticles) englishArticleMap.put(draftOnline.KnowledgeArticleId,draftOnline);
        //get english version
        List<Knowledge__kav> englishOnlineArticles=Database.query('SELECT Id,KnowledgeArticleId,'+fieldsToCopy+' FROM Knowledge__kav WHERE KnowledgeArticleId=:kmArticleIds AND PublishStatus =\'Online\' AND IsMasterLanguage=true ');
        for(Knowledge__kav englishOnline:englishOnlineArticles) englishArticleMap.put(englishOnline.KnowledgeArticleId,englishOnline);
       
        return englishArticleMap;
        
    }
    
    //copy data from master langauage to locals
    private static void copyMasterDataToLocal(Map<String,Knowledge__kav> draftLocalArticles){
        Map<String,Knowledge__kav> englishArticleData=getMasterLanguageData(draftLocalArticles);
        for(String kmId:draftLocalArticles.keySet()){
            if(englishArticleData.containsKey(kmId)){
                Knowledge__kav localRecord=draftLocalArticles.get(kmId);
                Knowledge__kav masterRecord=englishArticleData.get(kmId);
                for(String field:fieldsToCopy.split(',')){
                    localRecord.put(field.trim(),masterRecord.get(field.trim()));
                }
            }
        }
    }

}