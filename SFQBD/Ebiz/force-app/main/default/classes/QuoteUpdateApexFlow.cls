public with sharing class QuoteUpdateApexFlow {
    public static string ClassName = 'QuoteUpdateApexFlow';
    public static string MethodName = Configuration.EMPTYSTRING;
    public static ebizchargeServicemodelSoap.eBizService ebiz = new ebizchargeServicemodelSoap.eBizService();
    @InvocableMethod
    public static void invoke_updateQuote(List < Quote > quoteList) {
        EBC_Logger ebcLogger = new EBC_Logger();
        MethodName = 'invoke_updateQuote';
        ebcLogger.debug(ClassName, MethodName, 'quotelist is ' + quoteList);
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        try {
            EBizcharge_Setting__c settings = new EBizcharge_Setting__c();
            settings = eBc_SettingController.getSettingsApxc(dml, ebcLogger);
            if (settings.Auto_Upload_Quote__c) {
                for (Quote quote: quoteList) {
                    if (quote.EBizCharge_Internal_ID__c != null) {
                        invoke_updateQuote(dml, quote);
                    } else {
                        invoke_AddQuoteFuture(quote.Id);
                    }
                }
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
    }
    @Future(callout = true)
    public static void invoke_AddQuoteFuture(string quotId) {
        EBC_Logger ebcLogger = new EBC_Logger();
        MethodName = 'invoke_AddQuoteFuture';
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        try {
            EBC_ComponentController.getDetailApxc(dml, quotId, string.valueOf(Enums.SALESFORCEOBJECTNAMES.Quote), ebcLogger);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
    }
    @Future(callout = true)
    public static void invoke_updateQuoteFuture(string quoteString, String divisionId) {
        EBC_Logger ebcLogger = new EBC_Logger();
        MethodName = 'invoke_updateQuoteFuture';
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        Map < String, Object > quoteMap = (Map < String, Object > ) JSON.deserializeUntyped(quoteString);
        ebcLogger.debug(ClassName, MethodName, 'deserializeString is ' + quoteMap);
        ebizchargeServicemodelSoap.SalesOrder salesOrder = new ebizchargeServicemodelSoap.SalesOrder();
        String quotId = (String) quoteMap.get(string.valueOf(Enums.ENTITYFIELDSMAPSTRINGS.Id));
        String querySelect = 'select id,QBD_Customer_ID__c';
        String queryFrom = 'from Account';
        String queryWhere =  'where id=\''+ (String) quoteMap.get(string.valueOf(Enums.ENTITYFIELDSMAPSTRINGS.AccountId))+'\'';
        Account account = (Account)dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING,Configuration.EMPTYSTRING);
        //salesOrder.CustomerId = (String) quoteMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.AccountId));
        salesOrder.CustomerId = (string)account.get('QBD_Customer_ID__c');
        salesOrder.SalesOrderNumber = (String) quoteMap.get(string.valueOf(Enums.ENTITYFIELDSMAPSTRINGS.QuoteNumber));
        salesOrder.Amount = (Decimal) quoteMap.get(Configuration.QUOTEEBIZAMMOUNT);
        salesOrder.PoNum = (String) quoteMap.get(Configuration.QUOTEPONUMSTRING);
        salesOrder.Software = string.valueOf(Enums.FIELDVALUES.SalesforceApp);
        salesOrder.TypeId = string.valueOf(Enums.SALESFORCEOBJECTNAMES.Quote);
        salesOrder.divisionId = divisionId;
        String internalId = (string) quoteMap.get(Configuration.INTERNALIDSTRINGWITHNAMESPACE);
        ebizchargeServicemodelSoap.SalesOrderResponse quoteResponse = new ebizchargeServicemodelSoap.SalesOrderResponse();
        try {
            ebcLogger.debug(ClassName, MethodName, '>>invoke_updateQuoteFuture check');
            List < QuoteLineItem > quotLineItem = LineItems.getQuoteLineItemsDetail(dml, quotId, ebcLogger);
            if (quotLineItem != null) {
                ebcLogger.debug(ClassName, MethodName, 'quoteItem.Product2Id is');
                ebizchargeServicemodelSoap.ArrayOfCustomItem arrItems = new ebizchargeServicemodelSoap.ArrayOfCustomItem();
                ebizchargeServicemodelSoap.CustomItem[] ItemsArr = new List < ebizchargeServicemodelSoap.CustomItem > ();
                ebcLogger.debug(ClassName, MethodName, 'quoteItem.Product2Id is');
                for (QuoteLineItem quotItem: quotLineItem) {
                    ebcLogger.debug(ClassName, MethodName, quotItem.Product2Id);
                    ebizchargeServicemodelSoap.CustomItem itm = new ebizchargeServicemodelSoap.CustomItem();
                    String quoteLineItemEBizId = quotItem.Product2Id;
                    ebcLogger.debug(ClassName, MethodName, 'quoteLineItemEBizId is ' + quoteLineItemEBizId);
                    if (test.isRunningTest()) {
                        quoteLineItemEBizId = '1134234111';
                    }
                    if (quoteLineItemEBizId != null) {
                        ebcLogger.debug(ClassName, MethodName, 'quoteItem.Product2Id is');
                        itm.ItemInternalId = quotItem.Product2Id;
                        itm.ItemId = quotItem.Product2Id;
                        itm.Name = quotItem.product2.Name;
                        itm.UnitPrice = quotItem.UnitPrice;
                        itm.Qty = quotItem.Quantity;
                        itm.Taxable = false;
                        ebcLogger.debug(ClassName, MethodName, 'quoteItem.Product2Id is');
                        itm.Description = ((quotItem.product2.Description != null) ? quotItem.product2.Description : Configuration.EMPTYSTRING);
                        ebizchargeServicemodelSoap.ArrayOfEbizCustomField arrCustomFields = new ebizchargeServicemodelSoap.ArrayOfEbizCustomField();
                        list < ebizchargeServicemodelSoap.EbizCustomField > listCustomFields = new list < ebizchargeServicemodelSoap.EbizCustomField > ();
                        ebizchargeServicemodelSoap.EbizCustomField itemIdField = new ebizchargeServicemodelSoap.EbizCustomField();
                        itemIdField.FieldName = string.valueOf(Enums.ENTITYFIELDSMAPSTRINGS.Id);
                        itemIdField.FieldValue = quotItem.Id;
                        listCustomFields.add(itemIdField);
                        arrCustomFields.EbizCustomField = listCustomFields;
                        itm.ItemCustomFields = arrCustomFields;
                        ItemsArr.add(itm);
                    }
                }
                arrItems.Item = ItemsArr;
                ebcLogger.debug(ClassName, MethodName, 'quoteItem items list is' + ItemsArr);
                ebcLogger.debug(ClassName, MethodName, 'quoteItem items list is');
                salesOrder.Items = arrItems;
                ebcLogger.debug(ClassName, MethodName, 'quoteItem items list is');
            }
            quoteResponse = ebiz.UpdateSalesOrder(eBc_UtilityController.getSecurityToken(dml, ebcLogger), salesOrder, salesOrder.CustomerId, Configuration.EMPTYSTRING, salesOrder.SalesOrderNumber, internalId);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
    }
    public static void invoke_updateQuote(DML dml, Quote quote) {
        EBC_Logger ebcLogger = new EBC_Logger();
        MethodName = 'invoke_updateQuote';
        try {
            string quoteString = JSON.serializePretty(quote);
            String divisionId = Configuration.EMPTYSTRING;
            EBizcharge_Setting__c ebizchargeSettings = eBc_UtilityController.getSettings(dml, ebcLogger);
            if (ebizchargeSettings.Division_ID__c != null) {
                divisionId = ebizchargeSettings.Division_ID__c;
            }
            invoke_updateQuoteFuture(quoteString, divisionId);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
    }
}