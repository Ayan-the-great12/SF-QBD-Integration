@isTest
public class test_MockData {
    @isTest(OnInstall = true)
    static void testMethod1() {
        Account acc = MockData.GenrateDataAccount();
        MockData.GenrateDataOpp(acc.id);
        MockData.GenrateDataContact();
        MockData.GenrateDataOrder();
        MockData.getPickListValuesIntoList('opportunity', 'stagename');
    }
}