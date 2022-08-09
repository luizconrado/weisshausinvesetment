/***************
* @group Controller Class
* @description class responsible for logic behind component to view top artiles on communities
*/
public class CommunityArticleService {
    
    @AuraEnabled(Cacheable=true)
    public static List<Knowledge__kav> getTopArticles(String url){
         return [SELECT Id,Title,UrlName,ArticleTotalViewCount 
                FROM Knowledge__kav 
                WHERE PublishStatus='Online' AND IsLatestVersion=TRUE AND IsVisibleInPkb=TRUE AND Language =:url
                ORDER BY ArticleTotalViewCount DESC LIMIT 5];
    }
}