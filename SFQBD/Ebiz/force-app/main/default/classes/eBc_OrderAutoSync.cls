public with sharing class eBc_OrderAutoSync {
    public static string ClassName = 'eBc_OrderAutoSync';
    public static string MethodName = Configuration.EMPTYSTRING;
    public static ebizchargeServicemodelSoap.eBizService ebiz = new ebizchargeServicemodelSoap.eBizService();
    @InvocableMethod
    public static void invoke_updateOrder(list < Order > orders) {
        EBC_Logger ebcLogger = new EBC_Logger();
        MethodName = 'invoke_updateOrder';
        try {
            ebcLogger.debug(ClassName, MethodName, 'call invoke_UpdateOrderFuture----');
            for (order order: orders) {
                invoke_UpdateOrderFuture(order.id);
            }
            ebcLogger.debug(ClassName, MethodName, 'call invoke_UpdateOrderFuture finish----');
            ebcLogger.saveLogs();
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
    }
    @Future(callout = true)
    public static void invoke_UpdateOrderFuture(string orderId) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        try {
            MethodName = 'invoke_UpdateOrderFuture';
            boolean isUpdated = false;
            ebizchargeServicemodelSoap.ArrayOfSearchFilter filters = new ebizchargeServicemodelSoap.ArrayOfSearchFilter();
            ebizchargeServicemodelSoap.SearchFilter filter = new ebizchargeServicemodelSoap.SearchFilter();
            list < ebizchargeServicemodelSoap.SearchFilter > searchFilters = new list < ebizchargeServicemodelSoap.SearchFilter > ();
            ebizchargeServicemodelSoap.ArrayOfSalesOrder salesorderToUpdate = new ebizchargeServicemodelSoap.ArrayOfSalesOrder();
            list < ebizchargeServicemodelSoap.CustomSalesOrder > salesOrders = new list < ebizchargeServicemodelSoap.CustomSalesOrder > ();
            ebizchargeServicemodelSoap.ArrayOfSalesOrder searchSalesOrderResponse = new ebizchargeServicemodelSoap.ArrayOfSalesOrder();
            ebizchargeServicemodelSoap.CustomSalesOrder customSalesOrder;
            ebizchargeServicemodelSoap.SalesOrder salesOrder = new ebizchargeServicemodelSoap.SalesOrder();
            List < OrderItem > orderLineItems = new List < OrderItem > ();
            map < string, OrderItem > mapOrderLineItems = new map < string, OrderItem > ();
            map < string, object > mapOrderGWLineItems = new map < string, object > ();
            map < String, String > mapUpdateOrders = new map < string, string > ();
            String standardPriceBookId = Configuration.EMPTYSTRING;
            string SFstandardPriceBookId = Configuration.EMPTYSTRING;
            String query_select = 'SELECT Id,name';
            String query_from = 'FROM Pricebook2';
            String query_where = 'where name = \'Standard Price Book\'';
            list < Pricebook2 > pricebooks = (list < Pricebook2 > ) dml.selectRecords(query_select, query_from, query_where, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
            for (Pricebook2 pricebook: pricebooks) {
                standardPriceBookId = pricebook.Id;
                SFstandardPriceBookId = pricebook.id;
                break;
            }
            query_select = 'SELECT Id,CreatedDate,Name';
            query_from = ' FROM ' + 'Order';
            query_where = ' WHERE Id = \'' + orderId + '\'';
            query_select += ',EBizCharge_Captured_Amount__c,AccountId,Account.Name,OrderNumber,PoNumber,TotalAmount,EBizCharge_Order_Status__c,EBizCharge_Order_Balance__c,EBizCharge_Amount__c,EBizCharge_Internal_ID__c,EBizCharge_Reference_Number__c, EBizCharge_Order_Tax__c,Pricebook2Id,LastModifiedDate';
            Order orderDetail = (Order) dml.selectSingleRecord(query_select, query_from, query_where, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
            String accountId = orderDetail.AccountId;
            String orderNumber = orderDetail.OrderNumber;
            if (orderDetail.Pricebook2Id != null) {
                standardPriceBookId = orderDetail.Pricebook2Id;
            } else {
                orderDetail.Pricebook2Id = standardPriceBookId;
                dml.updateRecord(orderDetail);
            }
            filter.FieldName = string.valueOf(Enums.FIELDNAMES.SalesOrderInternalId);
            filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.eq);
            filter.FieldValue = orderDetail.EBizCharge_Internal_ID__c;
            searchFilters.add(filter);
            filters.SearchFilter = searchFilters;
            if (!test.isRunningTest()) {
                salesOrder = EBC_CompMethods.invoke_SearchOrder(dml, accountId, orderNumber, ebcLogger);
            } else {
                ebizchargeServicemodelSoap.CustomItem CustomItem = new ebizchargeServicemodelSoap.CustomItem();
                CustomItem.ItemId = '1412123';
                CustomItem.Description = '1412123';
                CustomItem.Qty = 1.0;
                CustomItem.UnitPrice = 1.0;
                ebizchargeServicemodelSoap.EbizCustomField EbizCustomFieldData = new ebizchargeServicemodelSoap.EbizCustomField();
                Schema.DescribeSObjectResult r = OrderItem.sObjectType.getDescribe();
                String keyPrefix = r.getKeyPrefix();
                EbizCustomFieldData.FieldValue = keyPrefix + 'F00001GLIrjQAH' + 0;
                List < ebizchargeServicemodelSoap.EbizCustomField > EbizCustomField = new List < ebizchargeServicemodelSoap.EbizCustomField > ();
                EbizCustomField.add(EbizCustomFieldData);
                ebizchargeServicemodelSoap.ArrayOfEbizCustomField ItemCustomFields = new ebizchargeServicemodelSoap.ArrayOfEbizCustomField();
                ItemCustomFields.EbizCustomField = EbizCustomField;
                if (orderId.substring(orderId.length() - 1) == '0') {
                    CustomItem.ItemCustomFields = ItemCustomFields;
                } else if (orderId.substring(orderId.length() - 1) == '1') {
                    CustomItem.ItemCustomFields = null;
                }
                List < ebizchargeServicemodelSoap.CustomItem > CustomItemList = new List < ebizchargeServicemodelSoap.CustomItem > ();
                CustomItemList.add(CustomItem);
                ebizchargeServicemodelSoap.ArrayOfCustomItem Items = new ebizchargeServicemodelSoap.ArrayOfCustomItem();
                Items.Item = CustomItemList;
                salesOrder.items = Items;
            }
            ebcLogger.debug(ClassName, MethodName, 'call LineItems.getOrderItemsDetail----');
            orderLineItems = LineItems.getOrderItemsDetail(dml, orderId, ebcLogger);
            ebcLogger.debug(ClassName, MethodName, 'call LineItems.getOrderItemsDetail finish----');
            list < OrderItem > ordersToUpdate = new list < OrderItem > ();
            list < OrderItem > ordersToInsert = new list < OrderItem > ();
            list < OrderItem > ordersToDelete = new list < OrderItem > ();
            for (OrderItem orderLineItem: orderLineItems) {
                mapOrderLineItems.put(orderLineItem.id, orderLineItem);
            }
            if (!test.isRunningTest()) {
                searchSalesOrderResponse = ebiz.SearchSalesOrders(EBC_CompMethods.getSecurityToken(dml, ebcLogger), Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, filters, 0, 100, Configuration.EMPTYSTRING, true);
            } else {
                ebizchargeServicemodelSoap.CustomSalesOrder testSalesOrder = new ebizchargeServicemodelSoap.CustomSalesOrder();
                testSalesOrder.DateUpdated = '2021-09-07 09:31:10';
                testSalesOrder.SalesOrderInternalId = '12345';
                List < ebizchargeServicemodelSoap.CustomSalesOrder > customSalesOrders = new List < ebizchargeServicemodelSoap.CustomSalesOrder > ();
                customSalesOrders.add(testSalesOrder);
                searchSalesOrderResponse.SalesOrder = customSalesOrders;
            }
            if (searchSalesOrderResponse != null) {
                if (searchSalesOrderResponse.SalesOrder != null) {
                    salesOrders = searchSalesOrderResponse.SalesOrder;
                    mapUpdateOrders.put(orderId, salesOrders[0].SalesOrderInternalId);
                    customSalesOrder = salesOrders[0];
                    if (customSalesOrder.DateUpdated != null) {
                        if (!test.isRunningTest()) {
                            if (orderDetail.LastModifiedDate < DateTime.valueof(customSalesOrder.DateUpdated)) {
                                isUpdated = true;
                            }
                        } else {
                            isUpdated = true;
                        }
                    }
                }
            }
            query_select = 'SELECT Id,ProductCode';
            query_from = 'FROM Product2';
            query_where = Configuration.EMPTYSTRING;
            list < Product2 > products = (list < Product2 > ) dml.selectRecordsInList(null, query_select, query_from, query_where, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
            map < String, String > mapProductsWithCode = new map < string, String > ();
            map < String, String > mapProductsWithId = new map < string, String > ();
            for (product2 product: products) {
                mapProductsWithCode.put(product.ProductCode, product.id);
                mapProductsWithId.put(product.id, product.id);
            }
            map < String, PricebookEntry > mapPricebook = new map < string, PricebookEntry > ();
            query_select = 'SELECT Id,Product2Id,Pricebook2Id';
            query_from = 'FROM PricebookEntry';
            query_where = 'where Pricebook2Id=\'' + standardPriceBookId + '\' ';
            list < PricebookEntry > SFPricebookEntries = (list < PricebookEntry > ) dml.selectRecords(query_select, query_from, query_where, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
            for (PricebookEntry pricebookEntry: SFPricebookEntries) {
                mapPricebook.put(pricebookEntry.Product2Id, pricebookEntry);
            }
            orderDetail.IsUpdatedFromGateway__c = true;
            dml.updateRecord(orderDetail);
            if (salesOrder != null && salesOrder.items != null && salesOrder.items.Item != null && salesOrder.items.Item.size() > 0) {
                for (ebizchargeServicemodelSoap.CustomItem salesOrderLineItem: salesOrder.items.Item) {
                    String gatewayLineItemSFId = null;
                    String itemdId = salesOrderLineItem.ItemId.trim();
                    if (salesOrderLineItem.ItemCustomFields != null && salesOrderLineItem.ItemCustomFields.EbizCustomField != null && salesOrderLineItem.ItemCustomFields.EbizCustomField.size() > 0) {
                        gatewayLineItemSFId = salesOrderLineItem.ItemCustomFields.EbizCustomField[0].FieldValue.Trim();
                    }
                    if (gatewayLineItemSFId != null) {
                        mapOrderGWLineItems.put(gatewayLineItemSFId, salesOrderLineItem);
                        OrderItem orderItem = mapOrderLineItems.get(gatewayLineItemSFId);
                        orderItem.Description = salesOrderLineItem.Description;
                        orderItem.Quantity = salesOrderLineItem.Qty;
                        orderItem.UnitPrice = salesOrderLineItem.UnitPrice;
                        ordersToUpdate.add(orderItem);
                    } else {
                        if (mapProductsWithCode.containsKey(itemdId)) {
                            OrderItem orderItem = new OrderItem();
                            Order order = new Order();
                            orderItem.Description = salesOrderLineItem.Description;
                            orderItem.Quantity = salesOrderLineItem.Qty;
                            orderItem.UnitPrice = salesOrderLineItem.UnitPrice;
                            orderItem.OrderId = orderDetail.id;
                            orderItem.Product2Id = mapProductsWithCode.get(itemdId);
                            PricebookEntry pricebookEntriesMap = mapPricebook.get(orderItem.Product2Id);
                            orderItem.PricebookEntryId = pricebookEntriesMap.id;
                            ordersToInsert.add(orderItem);
                        } else if (mapProductsWithId.containsKey(itemdId)) {
                            Order order = new Order();
                            OrderItem orderItem = new OrderItem();
                            orderItem.Description = salesOrderLineItem.Description;
                            orderItem.Quantity = salesOrderLineItem.Qty;
                            orderItem.UnitPrice = salesOrderLineItem.UnitPrice;
                            orderItem.OrderId = orderDetail.id;
                            orderItem.Product2Id = mapProductsWithId.get(itemdId);
                            PricebookEntry pricebookEntriesMap = mapPricebook.get(orderItem.Product2Id);
                            orderItem.PricebookEntryId = pricebookEntriesMap.id;
                            ordersToInsert.add(orderItem);
                        } else {
                            Product2 product = new Product2();
                            product.ProductCode = salesOrderLineItem.ItemId;
                            product.Ebiz_C__EBizCharge_Unit_Of_Measure__c = salesOrderLineItem.UnitOfMeasure;
                            product.EBizCharge_Division_ID__c = salesOrder.DivisionId;
                            product.Ebiz_C__EBizCharge_Internal_ID__c = salesOrderLineItem.ItemInternalId;
                            product.Name = salesOrderLineItem.Name;
                            product.Ebiz_C__EBizCharge_Last_Sync_Date__c = System.now() + (10 / 24 / 60);
                            product.Description = salesOrderLineItem.Description;
                            product.Ebiz_C__EBizCharge_Source__c = salesOrder.Software;
                            dml.insertRecord(product);
                            if (standardPriceBookId != SFstandardPriceBookId) {
                                PricebookEntry pe = new PricebookEntry();
                                pe.UnitPrice = salesOrderLineItem.UnitPrice;
                                pe.product2Id = product.id;
                                pe.Pricebook2Id = SFstandardPriceBookId;
                                pe.IsActive = true;
                                pe.UseStandardPrice = false;
                                dml.insertRecord(pe);
                            }
                            PricebookEntry pe = new PricebookEntry();
                            pe.UnitPrice = salesOrderLineItem.UnitPrice;
                            pe.product2Id = product.id;
                            pe.Pricebook2Id = standardPriceBookId;
                            pe.IsActive = true;
                            pe.UseStandardPrice = false;
                            dml.insertRecord(pe);
                            OrderItem orderItem = new OrderItem();
                            orderItem.Description = salesOrderLineItem.Description;
                            orderItem.Quantity = salesOrderLineItem.Qty;
                            orderItem.UnitPrice = salesOrderLineItem.UnitPrice;
                            orderItem.OrderId = orderDetail.id;
                            orderItem.Product2Id = product.id;
                            orderItem.PricebookEntryId = pe.id;
                            dml.insertRecord(orderItem);
                        }
                    }
                }
            }
            for (orderItem orderLineItem: orderLineItems) {
                if (!mapOrderGWLineItems.containsKey(orderLineItem.id)) {
                    ordersToDelete.add(orderLineItem);
                }
            }
            if (isUpdated) {
                if (ordersToUpdate.size() > 0) {
                    dml.updateRecord(ordersToUpdate);
                }
                if (ordersToInsert.size() > 0) {
                    dml.insertRecord(ordersToInsert);
                }
                if (ordersToDelete.size() > 0) {
                    dml.deleteRecord(ordersToDelete);
                }
            }
            if (mapUpdateOrders != null) {
                List < Order > updateOrders = new List < Order > ();
                for (String key: mapUpdateOrders.keySet()) {
                    Order order = new Order();
                    order.Id = key;
                    order.EBizCharge_Internal_ID__c = mapUpdateOrders.get(key);
                    order.EBizCharge_Last_Sync_Date__c = system.now();
                    updateOrders.add(order);
                }
                dml.updateRecord(updateOrders);
            }
            Order orderUpdate = new order();
            orderUpdate.id = orderDetail.id;
            orderUpdate.IsUpdatedFromGateway__c = false;
            dml.updateRecord(orderUpdate);
            ebcLogger.saveLogs();
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
    }
}