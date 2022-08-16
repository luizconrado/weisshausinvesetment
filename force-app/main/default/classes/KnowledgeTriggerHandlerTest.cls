/***************
* @group Test Class
* @description test class for KnowledgeTriggerHandler
*/
@isTest
public class KnowledgeTriggerHandlerTest {

    @isTest
    static void testTranslation(){
        Knowledge__kav km=TestDataFactory.getKnowledgeFAQRecord(true);
        Knowledge__kav sbkm=TestDataFactory.getKnowledgeSBRecord(true);
        Knowledge__kav kmArtilce=[SELECT id,KnowledgeArticleId FROM Knowledge__kav WHERE id=:km.id];
        KbManagement.PublishingService.submitForTranslation(kmArtilce.KnowledgeArticleId, 'de', System.UserInfo.getUserId(), null);
    }
}