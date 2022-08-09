/***************
* @group Test Class
* @description test class for CommunityArticleService
*/
@isTest
public class CommunityArticleServiceTest {

    @isTest
    static void getTopArticlestest(){
        CommunityArticleService.getTopArticles('en_US');
    }
}