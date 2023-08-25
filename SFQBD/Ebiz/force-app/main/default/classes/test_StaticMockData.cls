@isTest
public class test_StaticMockData {
    @isTest(OnInstall = true)
    static void test_MockDataMethods() {
        StaticMockData.getAccount();
        StaticMockData.getOpportunity();
        StaticMockData.getContact();
        StaticMockData.getOrder();
        StaticMockData.getOrderItem();
        StaticMockData.getQuote();
        StaticMockData.getQuoteLineItem();
        StaticMockData.getProduct2();
        StaticMockData.getPricebook2();
        StaticMockData.getPricebookEntry();
        StaticMockData.getEBiz_Object_Config();
        StaticMockData.getEBizCharge_Transaction();
        StaticMockData.getEBizCharge_Fields_Config();
        StaticMockData.getEBizCharge_Sync_Log();
        StaticMockData.getEBizcharge_Setting();
    }
}