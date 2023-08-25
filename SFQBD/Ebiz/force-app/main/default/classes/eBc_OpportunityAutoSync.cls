public with sharing class eBc_OpportunityAutoSync {
    public static string ClassName = 'eBc_OpportunityAutoSync';
    public static string MethodName = Configuration.EMPTYSTRING;
    public static ebizchargeServicemodelSoap.eBizService ebiz = new ebizchargeServicemodelSoap.eBizService();
    @InvocableMethod
    public static void invoke_updateOpportunity(list < Opportunity > opportunities) {
        EBC_Logger ebcLogger = new EBC_Logger();
        MethodName = 'invoke_updateOpportunity';
        try {
            ebcLogger.debug(ClassName, MethodName, 'call invoke_UpdateOpportunityFuture----');
            for (Opportunity opportunity: opportunities) {
                invoke_UpdateOpportunityFuture(opportunity.id);
            }
            ebcLogger.debug(ClassName, MethodName, 'call invoke_UpdateOpportunityFuture finish----');
            ebcLogger.saveLogs();
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
    }
    @Future(callout = true)
    public static void invoke_UpdateOpportunityFuture(string opportunityId) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        try {
            MethodName = 'invoke_UpdateOpportunityFuture';
            boolean isUpdated = false;
            ebizchargeServicemodelSoap.ArrayOfSearchFilter filters = new ebizchargeServicemodelSoap.ArrayOfSearchFilter();
            ebizchargeServicemodelSoap.SearchFilter filter = new ebizchargeServicemodelSoap.SearchFilter();
            list < ebizchargeServicemodelSoap.SearchFilter > searchFilters = new list < ebizchargeServicemodelSoap.SearchFilter > ();
            ebizchargeServicemodelSoap.ArrayOfSalesOrder salesorderToUpdate = new ebizchargeServicemodelSoap.ArrayOfSalesOrder();
            list < ebizchargeServicemodelSoap.CustomSalesOrder > salesOrders = new list < ebizchargeServicemodelSoap.CustomSalesOrder > ();
            ebizchargeServicemodelSoap.ArrayOfSalesOrder searchSalesOrderResponse = new ebizchargeServicemodelSoap.ArrayOfSalesOrder();
            ebizchargeServicemodelSoap.CustomSalesOrder customSalesOrder;
            ebizchargeServicemodelSoap.SalesOrder salesOrder = new ebizchargeServicemodelSoap.SalesOrder();
            List < OpportunityLineItem > opportunityLineItems = new List < OpportunityLineItem > ();
            map < string, opportunityLineItem > mapOpportunityLineItems = new map < string, opportunityLineItem > ();
            map < string, object > mapOpportunityGWLineItems = new map < string, object > ();
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
            query_from = ' FROM ' + 'Opportunity';
            query_where = ' WHERE Id = \'' + opportunityId + '\'';
            query_select += ',AccountId,Ebiz_C__Custom_Amount__c,Account.Name, Amount, Ebiz_C__EBizCharge_Opportunity_Status__c,EBizCharge_Opportunity_Balance__c,EBizCharge_Amount__c,EBizCharge_Internal_ID__c,EBizCharge_Reference_Number__c,LastModifiedDate,Pricebook2Id ';
            Opportunity OpportunityDetail = (Opportunity) dml.selectSingleRecord(query_select, query_from, query_where, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
            String accountId = OpportunityDetail.AccountId;
            String orderNumber = OpportunityDetail.id;
            if (OpportunityDetail.Pricebook2Id != null) {
                standardPriceBookId = OpportunityDetail.Pricebook2Id;
            } else {
                OpportunityDetail.Pricebook2Id = standardPriceBookId;
                dml.updateRecord(OpportunityDetail);
            }
            filter.FieldName = string.valueOf(Enums.FIELDNAMES.SalesOrderInternalId);
            filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.eq);
            filter.FieldValue = OpportunityDetail.EBizCharge_Internal_ID__c;
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
                Schema.DescribeSObjectResult r = OpportunityLineItem.sObjectType.getDescribe();
                String keyPrefix = r.getKeyPrefix();
                EbizCustomFieldData.FieldValue = keyPrefix + 'F00001GLIrjQAH' + 0;
                List < ebizchargeServicemodelSoap.EbizCustomField > EbizCustomField = new List < ebizchargeServicemodelSoap.EbizCustomField > ();
                EbizCustomField.add(EbizCustomFieldData);
                ebizchargeServicemodelSoap.ArrayOfEbizCustomField ItemCustomFields = new ebizchargeServicemodelSoap.ArrayOfEbizCustomField();
                ItemCustomFields.EbizCustomField = EbizCustomField;
                if (opportunityId.substring(opportunityId.length() - 1) == '0') {
                    CustomItem.ItemCustomFields = ItemCustomFields;
                } else if (opportunityId.substring(opportunityId.length() - 1) == '1') {
                    CustomItem.ItemCustomFields = null;
                }
                List < ebizchargeServicemodelSoap.CustomItem > CustomItemList = new List < ebizchargeServicemodelSoap.CustomItem > ();
                CustomItemList.add(CustomItem);
                ebizchargeServicemodelSoap.ArrayOfCustomItem Items = new ebizchargeServicemodelSoap.ArrayOfCustomItem();
                Items.Item = CustomItemList;
                salesOrder.items = Items;
            }
            ebcLogger.debug(ClassName, MethodName, 'call LineItems.getOpportunityLineItemsDetail----');
            opportunityLineItems = LineItems.getOpportunityLineItemsDetail(dml, opportunityId, ebcLogger);
            ebcLogger.debug(ClassName, MethodName, 'call LineItems.getOpportunityLineItemsDetail finish----');
            list < opportunityLineItem > opportunitiesToUpdate = new list < opportunityLineItem > ();
            list < opportunityLineItem > opportunitiesToInsert = new list < opportunityLineItem > ();
            list < opportunityLineItem > opportunitiesToDelete = new list < opportunityLineItem > ();
            for (opportunityLineItem opportunityLineItem: opportunityLineItems) {
                mapOpportunityLineItems.put(opportunityLineItem.id, opportunityLineItem);
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
                    mapUpdateOrders.put(opportunityId, salesOrders[0].SalesOrderInternalId);
                    customSalesOrder = salesOrders[0];
                    if (customSalesOrder.DateUpdated != null) {
                        if (!test.isRunningTest()) {
                            if (OpportunityDetail.LastModifiedDate < DateTime.valueof(customSalesOrder.DateUpdated)) {
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
            OpportunityDetail.Is_Updated_From_Gateway__c = true;
            dml.updateRecord(OpportunityDetail);
            if (salesOrder != null && salesOrder.items != null && salesOrder.items.Item != null && salesOrder.items.Item.size() > 0) {
                for (ebizchargeServicemodelSoap.CustomItem salesOrderLineItem: salesOrder.items.Item) {
                    String GWLineItemSFId = null;
                    String itemdId = salesOrderLineItem.ItemId.trim();
                    if (salesOrderLineItem.ItemCustomFields != null && salesOrderLineItem.ItemCustomFields.EbizCustomField != null && salesOrderLineItem.ItemCustomFields.EbizCustomField.size() > 0) {
                        GWLineItemSFId = salesOrderLineItem.ItemCustomFields.EbizCustomField[0].FieldValue.Trim();
                    }
                    if (GWLineItemSFId != null) {
                        mapOpportunityGWLineItems.put(GWLineItemSFId, salesOrderLineItem);
                        opportunityLineItem opportunityLineItem = mapOpportunityLineItems.get(GWLineItemSFId);
                        opportunityLineItem.Description = salesOrderLineItem.Description;
                        opportunityLineItem.Quantity = salesOrderLineItem.Qty;
                        opportunityLineItem.UnitPrice = salesOrderLineItem.UnitPrice;
                        opportunitiesToUpdate.add(opportunityLineItem);
                    } else {
                        if (mapProductsWithCode.containsKey(itemdId)) {
                            opportunityLineItem opportunityLineItem = new opportunityLineItem();
                            Opportunity opportunity = new Opportunity();
                            opportunityLineItem.Description = salesOrderLineItem.Description;
                            opportunityLineItem.Quantity = salesOrderLineItem.Qty;
                            opportunityLineItem.UnitPrice = salesOrderLineItem.UnitPrice;
                            opportunityLineItem.OpportunityId = salesOrder.SalesOrderNumber;
                            opportunityLineItem.Product2Id = mapProductsWithCode.get(itemdId);
                            PricebookEntry pricebookEntriesMap = mapPricebook.get(opportunityLineItem.Product2Id);
                            opportunityLineItem.PricebookEntryId = pricebookEntriesMap.id;
                            opportunitiesToInsert.add(opportunityLineItem);
                        } else if (mapProductsWithId.containsKey(itemdId)) {
                            Opportunity opportunity = new Opportunity();
                            opportunityLineItem opportunityLineItem = new opportunityLineItem();
                            opportunityLineItem.Description = salesOrderLineItem.Description;
                            opportunityLineItem.Quantity = salesOrderLineItem.Qty;
                            opportunityLineItem.UnitPrice = salesOrderLineItem.UnitPrice;
                            opportunityLineItem.OpportunityId = salesOrder.SalesOrderNumber;
                            opportunityLineItem.Product2Id = mapProductsWithId.get(itemdId);
                            PricebookEntry pricebookEntriesMap = mapPricebook.get(opportunityLineItem.Product2Id);
                            opportunityLineItem.PricebookEntryId = pricebookEntriesMap.id;
                            opportunitiesToInsert.add(opportunityLineItem);
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
                            opportunityLineItem opportunityLineItem = new opportunityLineItem();
                            opportunityLineItem.Description = salesOrderLineItem.Description;
                            opportunityLineItem.Quantity = salesOrderLineItem.Qty;
                            opportunityLineItem.UnitPrice = salesOrderLineItem.UnitPrice;
                            opportunityLineItem.OpportunityId = salesOrder.SalesOrderNumber;
                            opportunityLineItem.Product2Id = product.id;
                            opportunityLineItem.PricebookEntryId = pricebookEntry.id;
                            dml.insertRecord(opportunityLineItem);
                        }
                    }
                }
            }
            for (opportunityLineItem opportunityLineItem: opportunityLineItems) {
                if (!mapOpportunityGWLineItems.containsKey(opportunityLineItem.id)) {
                    opportunitiesToDelete.add(opportunityLineItem);
                }
            }
            if (isUpdated) {
                if (opportunitiesToUpdate.size() > 0) {
                    dml.updateRecord(opportunitiesToUpdate);
                }
                if (opportunitiesToInsert.size() > 0) {
                    dml.insertRecord(opportunitiesToInsert);
                }
                if (opportunitiesToDelete.size() > 0) {
                    dml.deleteRecord(opportunitiesToDelete);
                }
            }
            if (mapUpdateOrders != null) {
                List < Opportunity > updateOpportunities = new List < Opportunity > ();
                for (String key: mapUpdateOrders.keySet()) {
                    Opportunity opportunity = new Opportunity();
                    opportunity.Id = key;
                    opportunity.EBizCharge_Internal_ID__c = mapUpdateOrders.get(key);
                    opportunity.EBizCharge_Last_Sync_Date__c = system.now();
                    updateOpportunities.add(opportunity);
                }
                dml.updateRecord(updateOpportunities);
            }
            opportunity updateOpportunity = new opportunity();
            updateOpportunity.id = OpportunityDetail.id;
            updateOpportunity.Is_Updated_From_Gateway__c = false;
            dml.updateRecord(updateOpportunity);
            ebcLogger.saveLogs();
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
    }
}