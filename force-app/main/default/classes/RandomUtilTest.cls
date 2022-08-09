/***************
* @group Test Class
* @description test class for RandomUtil 
*/
@isTest
public class RandomUtilTest {
    
    @isTest
    static void getValues(){
        RandomUtil.randomNumber(2);
        System.assert(String.isNotBlank(RandomUtil.getUUID()));
        System.assert(String.isNotBlank(RandomUtil.randomString(4)));
        

    }

}