@isTest
public class test_AccountUpdation 
{
    @isTest(OnInstall=true)
    static void test_AccountUpdationApxc() 
    {
        DML dml = (DML)MockUtil.createMock(DML.class);
        try
        {
        // EBizcharge_Setting__c  ES = eBc_ContactController.getSettingsApxc(dml);
        Account acc = new Account();
        acc.Name = 'Ayan';
       insert acc;
        acc.Name = 'Uzair';
        update acc;
        }
        catch(Exception err){
        }
    }
}