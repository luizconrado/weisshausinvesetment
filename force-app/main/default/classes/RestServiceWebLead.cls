/***************
* @group Rest Api
* @description Creates Banking Customer Record and subscription to investment 
*/
@RestResource(UrlMapping='/generate/lead/*')
global without sharing  class RestServiceWebLead {

    /***************
    * @description creates/updates customer based on email address and creates new subscripiton for investment
    * @example
      {
       "fields[email][value]":"",
       "fields[websiteSource][value]":""
      }
    */
    @HttpPost
    global static void doPost() {
        RestResponse res = RestContext.response;

        RestRequest req = RestContext.request;

        Map<String, String> headersMap = req.headers;

        String userAgent =(headersMap.get('User-Agent')!=null) ? headersMap.get('User-Agent') : '';
        String productInterest = req.params.get('fields[productInterested][value]').replace('+',' ');
        String email = req.params.get('fields[email][value]');
        String company = req.params.get('fields[websiteSource][value]');
        String website = (String.isNotEmpty(userAgent) && userAgent.contains(';')) ? userAgent.split(';').get(1):'';
        String origin=company;
        if(website!=null && String.isNotEmpty(website) && website.contains('www.')) origin=website.substringBetween('://www.', '.');
        else if(website!=null && String.isNotEmpty(website) ) origin=website.substringBetween('://', '.');
        
      
        AccountService.service service=new AccountService.service();
        service.createAccountAndNewsletter(email, productInterest, origin, website,new Map<String,String>(), Constant.PERSON_ACCOUNT_RECORDTYPEID);
        
        
        res.statusCode = 200;
    }
    
    
    
  
}