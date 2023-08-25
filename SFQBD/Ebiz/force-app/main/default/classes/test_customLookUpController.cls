@isTest
public class test_customLookUpController {
	@isTest(OnInstall=true)
    static void test_fetchLookUpValues(){
        List < sObject > obj = customLookUpController.fetchLookUpValues('','');
    }
}