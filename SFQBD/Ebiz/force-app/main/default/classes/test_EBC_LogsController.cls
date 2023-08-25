@isTest
public with sharing class test_EBC_LogsController {
    @isTest(OnInstall = true)
    public static void testMethod1() {
        list < String > filterStrLog = new list < String > ();
        List < Ebiz_C__EBizCharge_Logs__c > logsList = new List < Ebiz_C__EBizCharge_Logs__c > ();
        EBC_LogsController.fetchLogs();
        EBC_LogsController.FilterdfetchLogs(filterStrLog);
        EBC_LogsController.RemoveLogs();
    }
}