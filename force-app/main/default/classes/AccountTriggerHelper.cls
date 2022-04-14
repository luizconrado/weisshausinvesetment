/***************
* @group Trigger Helper
* @description Responsible for business logic of account trigger handler
*/
public class AccountTriggerHelper {
    
    /***************
    * @description calcualte age based on date
    * @param birthDate date from which age needs to be calucated
    * @return age braket
    * @example
    * AccountTriggerHelper.calucateAgeBracket(dateOfPerson);
    */
    public static String calucateAgeBracket(Date birthDate){
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

}