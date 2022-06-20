public class AccountTriggerHelper {
    
    public static String calucateAgeBracker(Date birthDate){
        Date todaysDate=Date.today();
        Integer currentYear=todaysDate.year();
        Integer birthYear=birthDate.year();
        Integer age=currentYear-birthYear-1;
        
        if(age<11) return '01-10';
        else if(age<21) return '11-20';
        else if(age<31) return '21-30';
        else if(age<41) return '31-40';
        else if(age<51) return '41-50';
        else if(age<61) return '51-60';
        else if(age<71) return '61-70';
        else if(age<81) return '71-80';
        else if(age<91) return '81-90';
        
        return '91-99';
        
        
    }
    
    public static void unsubscribeAllSubscriptions(List<String> accountIds){
        
        List<Subscription__c> subscriptionList=[SELECT Id, Account__c, Reason_For_Unsubscribing__c, Subscription_Status__c, Unsubscribed_Date__c 
                                                FROM Subscription__c 
                                                WHERE Account__c IN:accountIds AND  Subscription_Status__c!='Unsubscribed'];
        for(Subscription__c subscription:subscriptionList){
            subscription.Reason_For_Unsubscribing__c='Sonstige Gründe';
            subscription.Unsubscribed_Date__c=Date.today();
            subscription.Subscription_Status__c='Unsubscribed';
        }
        
        if(subscriptionList.size()>0) update subscriptionList;
        
    }

}