@isTest
public class test_OrderAndQuoteLineItemApexFlow {
    @isTest(OnInstall = true)
    static void test_apexFlow() {
        DML dml = (DML) MockUtil.createMock(DML.class);
        EBC_Logger ebcLogger = new EBC_Logger();
        OrderItemInsertApexFlow.OrderLineItem ordItmWapper = new OrderItemInsertApexFlow.OrderLineItem();
        OrderItem oi = StaticMockData.getOrderItem()[0];
        ordItmWapper.OrderItemNew = oi;
        ordItmWapper.OrderItemTotalPrice = 20;
        Schema.DescribeSObjectResult r2 = Order.sObjectType.getDescribe();
        String keyPrefix2 = r2.getKeyPrefix();
        String orderId = keyPrefix2 + 'F00001GLIrjQAHK';
        QuoteLineItemInsertApexFlow.QuoteItem qtItmWapper = new QuoteLineItemInsertApexFlow.QuoteItem();
        QuoteLineItem qli = StaticMockData.getQuoteLineItem()[0];
        qtItmWapper.QuoteLineItemNew = qli;
        qtItmWapper.QuoteLineItemTotalPrice = 20;
        QuoteLineItemInsertApexFlow.QuoteLineItemInsert(dml, qtItmWapper);
        QuoteLineItemDeleteApexFlow.QuoteLineItemDelete(dml, qli);
        OrderItemInsertApexFlow.OrderItemInsert(dml, ordItmWapper);
        OrderItemDeleteApexFlow.OrderItemDelete(dml, oi);
        UpdateOrderTriggerHelper.UpdateOrderAmountOnInsert(dml, orderId, oi, 20, ebcLogger);
        UpdateOrderTriggerHelper.UpdateOrderAmountOnDelete(dml, orderId, oi, ebcLogger);
        Schema.DescribeSObjectResult r = Quote.sObjectType.getDescribe();
        String keyPrefix = r.getKeyPrefix();
        String qoutId = keyPrefix + 'F00001GLIrjQAHK';
        UpdateQuoteTriggerHelper.UpdateQuoteAmountOnInsert(dml, qoutId, qli, 20, ebcLogger);
        UpdateQuoteTriggerHelper.UpdateQuoteAmountOnDelete(dml, qoutId, qli, ebcLogger);
    }
}