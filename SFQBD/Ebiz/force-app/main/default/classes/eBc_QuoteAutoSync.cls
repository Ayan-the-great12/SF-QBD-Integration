public with sharing class eBc_QuoteAutoSync {
    public static string ClassName = 'eBc_QuoteAutoSync';
    public static string MethodName = Configuration.EMPTYSTRING;
    public static ebizchargeServicemodelSoap.eBizService ebiz = new ebizchargeServicemodelSoap.eBizService();
    @InvocableMethod
    public static void invoke_updateQuote(list < Quote > quotes) {
        EBC_Logger ebcLogger = new EBC_Logger();
        MethodName = 'invoke_updateQuote';
        try {
            ebcLogger.debug(ClassName, MethodName, 'call invoke_UpdateQuoteFuture----');
            for (Quote quote: quotes) {
                invoke_UpdateQuoteFuture(quote.id);
            }
            ebcLogger.debug(ClassName, MethodName, 'call invoke_UpdateQuoteFuture finish----');
            ebcLogger.saveLogs();
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
    }
    @Future(callout = true)
    public static void invoke_UpdateQuoteFuture(string quoteId) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        MethodName = 'invoke_UpdateQuoteFuture';
        try {
            boolean isUpdated = false;
            ebizchargeServicemodelSoap.ArrayOfSearchFilter filters = new ebizchargeServicemodelSoap.ArrayOfSearchFilter();
            ebizchargeServicemodelSoap.SearchFilter filter = new ebizchargeServicemodelSoap.SearchFilter();
            list < ebizchargeServicemodelSoap.SearchFilter > searchFilters = new list < ebizchargeServicemodelSoap.SearchFilter > ();
            ebizchargeServicemodelSoap.ArrayOfSalesOrder salesorderToUpdate = new ebizchargeServicemodelSoap.ArrayOfSalesOrder();
            list < ebizchargeServicemodelSoap.CustomSalesOrder > salesOrders = new list < ebizchargeServicemodelSoap.CustomSalesOrder > ();
            ebizchargeServicemodelSoap.ArrayOfSalesOrder searchSalesOrderResponse = new ebizchargeServicemodelSoap.ArrayOfSalesOrder();
            ebizchargeServicemodelSoap.CustomSalesOrder customSalesOrder = new ebizchargeServicemodelSoap.CustomSalesOrder();
            ebizchargeServicemodelSoap.SalesOrder salesOrder = new ebizchargeServicemodelSoap.SalesOrder();
            List < QuoteLineItem > quoteLineItems = new List < QuoteLineItem > ();
            map < string, QuoteLineItem > mapQuoteLineItems = new map < string, QuoteLineItem > ();
            map < string, object > mapQuoteGWLineItems = new map < string, object > ();
            map < String, String > mapUpdateQuotes = new map < string, string > ();
            String standardPriceBookId = Configuration.EMPTYSTRING;
            string SFstandardPriceBookId = Configuration.EMPTYSTRING;
            String query_select = 'SELECT Id,name';
            String query_from = 'FROM Pricebook2';
            String query_where = 'where name = \'Standard Price Book\'';
            list < Pricebook2 > pricebooklist = (list < Pricebook2 > ) dml.selectRecords(query_select, query_from, query_where, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
            if (!pricebooklist.isEmpty()) {
                for (Pricebook2 prBook: pricebooklist) {
                    standardPriceBookId = prBook.Id;
                    SFstandardPriceBookId = prBook.id;
                    break;
                }
            }
            query_select = 'SELECT Id,CreatedDate,Name';
            query_from = ' FROM ' + 'Quote';
            query_where = ' WHERE Id = \'' + quoteId + '\'';
            query_select += ',EBizCharge_Captured_Amount__c, AccountId, Account.Name, QuoteNumber, GrandTotal, EBizCharge_Quote_Status__c, EBizCharge_Quote_Balance__c, EBizCharge_Amount__c,EBizCharge_Internal_ID__c,EBizCharge_Reference_Number__c, EBizCharge_Quote_Tax_c__c,Pricebook2Id,LastModifiedDate';
            Quote quoteDetail = (Quote) dml.selectSingleRecord(query_select, query_from, query_where, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
            String accountId = quoteDetail.AccountId;
            String quoteNumber = quoteDetail.QuoteNumber;
            if (quoteDetail.Pricebook2Id != null) {
                standardPriceBookId = quoteDetail.Pricebook2Id;
            } else {
                quoteDetail.Pricebook2Id = standardPriceBookId;
                dml.updateRecord(quoteDetail);
            }
            filter.FieldName = string.valueOf(Enums.FIELDNAMES.SalesOrderInternalId);
            filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.eq);
            filter.FieldValue = quoteDetail.EBizCharge_Internal_ID__c;
            searchFilters.add(filter);
            filters.SearchFilter = searchFilters;
            if (!test.isRunningTest()) {
                salesOrder = EBC_CompMethods.invoke_SearchOrder(dml, accountId, quoteNumber, ebcLogger);
            } else {
                ebizchargeServicemodelSoap.CustomItem CustomItem = new ebizchargeServicemodelSoap.CustomItem();
                CustomItem.ItemId = '1412123';
                CustomItem.Description = '1412123';
                CustomItem.Qty = 1.0;
                CustomItem.UnitPrice = 1.0;
                ebizchargeServicemodelSoap.EbizCustomField EbizCustomFieldData = new ebizchargeServicemodelSoap.EbizCustomField();
                Schema.DescribeSObjectResult r = QuoteLineItem.sObjectType.getDescribe();
                String keyPrefix = r.getKeyPrefix();
                EbizCustomFieldData.FieldValue = keyPrefix + 'F00001GLIrjQAH' + 0;
                List < ebizchargeServicemodelSoap.EbizCustomField > EbizCustomField = new List < ebizchargeServicemodelSoap.EbizCustomField > ();
                EbizCustomField.add(EbizCustomFieldData);
                ebizchargeServicemodelSoap.ArrayOfEbizCustomField ItemCustomFields = new ebizchargeServicemodelSoap.ArrayOfEbizCustomField();
                ItemCustomFields.EbizCustomField = EbizCustomField;
                if (quoteId.substring(quoteId.length() - 1) == '0') {
                    CustomItem.ItemCustomFields = ItemCustomFields;
                } else if (quoteId.substring(quoteId.length() - 1) == '1') {
                    CustomItem.ItemCustomFields = null;
                }
                List < ebizchargeServicemodelSoap.CustomItem > CustomItemList = new List < ebizchargeServicemodelSoap.CustomItem > ();
                CustomItemList.add(CustomItem);
                ebizchargeServicemodelSoap.ArrayOfCustomItem Items = new ebizchargeServicemodelSoap.ArrayOfCustomItem();
                Items.Item = CustomItemList;
                salesOrder.items = Items;
            }
            ebcLogger.debug(ClassName, MethodName, 'call LineItems.getQuoteLineItemsDetail----');
            quoteLineItems = LineItems.getQuoteLineItemsDetail(dml, quoteId, ebcLogger);
            ebcLogger.debug(ClassName, MethodName, 'call LineItems.getQuoteLineItemsDetail finish----');
            list < QuoteLineItem > quotesToUpdate = new list < QuoteLineItem > ();
            list < QuoteLineItem > quotesToInsert = new list < QuoteLineItem > ();
            list < QuoteLineItem > quotesToDelete = new list < QuoteLineItem > ();
            for (QuoteLineItem quoteLineItem: quoteLineItems) {
                mapQuoteLineItems.put(quoteLineItem.id, quoteLineItem);
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
                    mapUpdateQuotes.put(quoteId, salesOrders[0].SalesOrderInternalId);
                    customSalesOrder = salesOrders[0];
                    if (customSalesOrder.DateUpdated != null) {
                        if (!test.isRunningTest()) {
                            if (quoteDetail.LastModifiedDate < DateTime.valueof(customSalesOrder.DateUpdated)) {
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
            list < PricebookEntry > SFPriceBookEntries = (list < PricebookEntry > ) dml.selectRecords(query_select, query_from, query_where, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
            for (PricebookEntry pricebookEntry: SFPriceBookEntries) {
                mapPricebook.put(pricebookEntry.Product2Id, pricebookEntry);
            }
            quoteDetail.Is_Updated_From_Gateway__c = true;
            dml.updateRecord(quoteDetail);
            if (salesOrder != null && salesOrder.items != null && salesOrder.items.Item != null && salesOrder.items.Item.size() > 0) {
                for (ebizchargeServicemodelSoap.CustomItem salesOrderLineItem: salesOrder.items.Item) {
                    String GWLineItemSFId = null;
                    String itemdId = salesOrderLineItem.ItemId.trim();
                    if (salesOrderLineItem.ItemCustomFields != null && salesOrderLineItem.ItemCustomFields.EbizCustomField != null && salesOrderLineItem.ItemCustomFields.EbizCustomField.size() > 0) {
                        GWLineItemSFId = salesOrderLineItem.ItemCustomFields.EbizCustomField[0].FieldValue.Trim();
                    }
                    if (GWLineItemSFId != null) {
                        mapQuoteGWLineItems.put(GWLineItemSFId, salesOrderLineItem);
                        QuoteLineItem quoteLineItem = mapQuoteLineItems.get(GWLineItemSFId);
                        quoteLineItem.Description = salesOrderLineItem.Description;
                        quoteLineItem.Quantity = salesOrderLineItem.Qty;
                        quoteLineItem.UnitPrice = salesOrderLineItem.UnitPrice;
                        quotesToUpdate.add(quoteLineItem);
                    } else {
                        if (mapProductsWithCode.containsKey(itemdId)) {
                            QuoteLineItem quoteLineItem = new QuoteLineItem();
                            Quote quote = new Quote();
                            quoteLineItem.Description = salesOrderLineItem.Description;
                            quoteLineItem.Quantity = salesOrderLineItem.Qty;
                            quoteLineItem.UnitPrice = salesOrderLineItem.UnitPrice;
                            quoteLineItem.QuoteId = quoteDetail.id;
                            quoteLineItem.Product2Id = mapProductsWithCode.get(itemdId);
                            PricebookEntry PEMap = mapPricebook.get(quoteLineItem.Product2Id);
                            quoteLineItem.PricebookEntryId = PEMap.id;
                            quotesToInsert.add(quoteLineItem);
                        } else if (mapProductsWithId.containsKey(itemdId)) {
                            Quote quote = new Quote();
                            QuoteLineItem quoteLineItem = new QuoteLineItem();
                            quoteLineItem.Description = salesOrderLineItem.Description;
                            quoteLineItem.Quantity = salesOrderLineItem.Qty;
                            quoteLineItem.UnitPrice = salesOrderLineItem.UnitPrice;
                            quoteLineItem.QuoteId = quoteDetail.id;
                            quoteLineItem.Product2Id = mapProductsWithId.get(itemdId);
                            PricebookEntry PEMap = mapPricebook.get(quoteLineItem.Product2Id);
                            quoteLineItem.PricebookEntryId = PEMap.id;
                            quotesToInsert.add(quoteLineItem);
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
                                PricebookEntry pricebookEntry = new PricebookEntry();
                                pricebookEntry.UnitPrice = salesOrderLineItem.UnitPrice;
                                pricebookEntry.product2Id = product.id;
                                pricebookEntry.Pricebook2Id = SFstandardPriceBookId;
                                pricebookEntry.IsActive = true;
                                pricebookEntry.UseStandardPrice = false;
                                dml.insertRecord(pricebookEntry);
                            }
                            PricebookEntry pricebookEntry = new PricebookEntry();
                            pricebookEntry.UnitPrice = salesOrderLineItem.UnitPrice;
                            pricebookEntry.product2Id = product.id;
                            pricebookEntry.Pricebook2Id = standardPriceBookId;
                            pricebookEntry.IsActive = true;
                            pricebookEntry.UseStandardPrice = false;
                            dml.insertRecord(pricebookEntry);
                            QuoteLineItem quoteLineItem = new QuoteLineItem();
                            quoteLineItem.Description = salesOrderLineItem.Description;
                            quoteLineItem.Quantity = salesOrderLineItem.Qty;
                            quoteLineItem.UnitPrice = salesOrderLineItem.UnitPrice;
                            quoteLineItem.QuoteId = quoteDetail.id;
                            quoteLineItem.Product2Id = product.id;
                            quoteLineItem.PricebookEntryId = pricebookEntry.id;
                            dml.insertRecord(quoteLineItem);
                        }
                    }
                }
            }
            for (QuoteLineItem quoteLineItem: quoteLineItems) {
                if (!mapQuoteGWLineItems.containsKey(quoteLineItem.id)) {
                    quotesToDelete.add(quoteLineItem);
                }
            }
            if (isUpdated) {
                if (quotesToUpdate.size() > 0) {
                    dml.updateRecord(quotesToUpdate);
                }
                if (quotesToInsert.size() > 0) {
                    dml.insertRecord(quotesToInsert);
                }
                if (quotesToDelete.size() > 0) {
                    dml.deleteRecord(quotesToDelete);
                }
            }
            if (mapUpdateQuotes != null) {
                List < Quote > updateQuotes = new List < Quote > ();
                for (String key: mapUpdateQuotes.keySet()) {
                    Quote quote = new Quote();
                    quote.Id = key;
                    quote.EBizCharge_Internal_ID__c = mapUpdateQuotes.get(key);
                    quote.EBizCharge_Last_Sync_Date__c = system.now();
                    updateQuotes.add(quote);
                }
                dml.updateRecord(updateQuotes);
            }
            quote updateQuote = new quote();
            updateQuote.id = quoteDetail.id;
            updateQuote.Is_Updated_From_Gateway__c = true;
            dml.updateRecord(updateQuote);
            ebcLogger.saveLogs();
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
    }
}