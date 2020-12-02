public class CommunityArticleService {
    
    @AuraEnabled(Cacheable=true)
    public static List<Knowledge__kav> getTopArticles(){
        return [SELECT Id,Title,UrlName,ArticleTotalViewCount 
                FROM Knowledge__kav 
                WHERE PublishStatus='Online' AND IsLatestVersion=TRUE AND IsVisibleInPkb=TRUE ORDER BY ArticleTotalViewCount DESC LIMIT 5];
    }
}