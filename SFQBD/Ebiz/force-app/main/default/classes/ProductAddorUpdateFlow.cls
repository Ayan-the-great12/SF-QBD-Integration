public with sharing class ProductAddorUpdateFlow {
    public static string ClassName = 'ProductAddorUpdateFlow';
    public static string MethodName = Configuration.EMPTYSTRING;
    public static ebizchargeServicemodelSoap.eBizService ebiz = new ebizchargeServicemodelSoap.eBizService();
    @InvocableMethod
    public static void invoke_updateProduct(List < product2 > products) {
        MethodName = 'invoke_updateProduct';
        EBC_Logger ebcLogger = new EBC_Logger();
        ebcLogger.debug(ClassName, MethodName, 'oppList is ' + products);
        Dml dml = new Dml();
        try {
            EBizcharge_Setting__c settings = new EBizcharge_Setting__c();
            settings = eBc_SettingController.getSettingsApxc(dml, ebcLogger);
            if (settings.Ebiz_C__Auto_Upload_Product__c) {
                for (product2 product: products) {
                    if (product.EBizCharge_Internal_ID__c != null) {
                        invoke_updateProduct(dml, product);
                    } else {
                        invoke_AddProduct(dml, product);
                    }
                }
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
    }
    @Future(callout = true)
    public static void invoke_AddProductFuture(string prodString, String divisionId, String priceBookEntryUnitPrice) {
        MethodName = 'invoke_updateProduct';
        EBC_Logger ebcLogger = new EBC_Logger();
        ebcLogger.debug(ClassName, MethodName, '>>invoke_AddProductFuture check');
        DML dml = new DML();
        try {
            Map < String, Object > prodMap = (Map < String, Object > ) JSON.deserializeUntyped(prodString);
            ebizchargeServicemodelSoap.itemDetails itmDetail = new ebizchargeServicemodelSoap.itemDetails();
            String prodId = (String) prodMap.get(string.valueOf(Enums.ENTITYFIELDSMAPSTRINGS.Id));
            itmDetail.ItemId = prodId;
            itmDetail.Name = (String) prodMap.get(string.valueOf(Enums.ENTITYFIELDSMAPSTRINGS.Name));
            itmDetail.Description = (String) prodMap.get(string.valueOf(Enums.PRODUCTFIELDS.Description));
            itmDetail.SKU = (String) prodMap.get(string.valueOf(Enums.PRODUCTFIELDS.ProductCode));
            itmDetail.UnitPrice = Decimal.ValueOf(priceBookEntryUnitPrice);
            itmDetail.UnitCost = Decimal.ValueOf(priceBookEntryUnitPrice);
            ebcLogger.debug(ClassName, MethodName, 'itmDetail.UnitPrice' + itmDetail.UnitPrice);
            itmDetail.divisionId = divisionId;
            itmDetail.ItemUniqueId = divisionId;
            itmDetail.Taxable = false;
            itmDetail.TaxRate = 0;
            itmDetail.Active = (Boolean) prodMap.get(string.valueOf(Enums.PRODUCTFIELDS.IsActive));
            itmDetail.SoftwareId = string.valueOf(Enums.FIELDVALUES.SalesforceApp);
            ebizchargeServicemodelSoap.ItemDetailsResponse response = new ebizchargeServicemodelSoap.ItemDetailsResponse();
            response = ebiz.AddItem(EBC_CompMethods.getSecurityToken(dml, ebcLogger), itmDetail);
            ebcLogger.debug(ClassName, MethodName, 'additem response is' + response);
            String internalID = response.ItemInternalId;
            ebcLogger.debug(ClassName, MethodName, 'internalID is');
            ebcLogger.debug(ClassName, MethodName, internalID);
            string query_select = 'SELECT id,EBizCharge_Internal_ID__c';
            string query_from = 'from Product2 ';
            string query_where = 'where Id = \'' + prodId + '\' ';
            Product2 updateProd = (Product2) dml.selectSingleRecord(query_select, query_from, query_where, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
            updateProd.EBizCharge_Internal_ID__c = internalID;
            dml.updateRecord(updateProd);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
    }
    @Future(callout = true)
    public static void invoke_updateProductFuture(string prodstring, String divisionId, string priceBookEntryUnitPrice) {
        MethodName = 'invoke_updateProductFuture';
        EBC_Logger ebcLogger = new EBC_Logger();
        DML dml = new DML();
        try {
            Map < String, Object > prodMap = (Map < String, Object > ) JSON.deserializeUntyped(prodstring);
            ebizchargeServicemodelSoap.itemDetails itmDetail = new ebizchargeServicemodelSoap.itemDetails();
            String prodId = (String) prodMap.get(string.valueOf(Enums.ENTITYFIELDSMAPSTRINGS.Id));
            itmDetail.ItemId = prodId;
            itmDetail.Name = (String) prodMap.get(string.valueOf(Enums.ENTITYFIELDSMAPSTRINGS.Name));
            itmDetail.Description = (String) prodMap.get(string.valueOf(Enums.PRODUCTFIELDS.Description));
            itmDetail.SKU = (String) prodMap.get(string.valueOf(Enums.PRODUCTFIELDS.ProductCode));
            itmDetail.UnitPrice = Decimal.ValueOf(priceBookEntryUnitPrice);
            itmDetail.UnitCost = Decimal.ValueOf(priceBookEntryUnitPrice);
            itmDetail.divisionId = divisionId;
            itmDetail.ItemUniqueId = divisionId;
            itmDetail.Taxable = false;
            itmDetail.TaxRate = 0;
            itmDetail.Active = (Boolean) prodMap.get(string.valueOf(Enums.PRODUCTFIELDS.IsActive));
            itmDetail.SoftwareId = string.valueOf(Enums.FIELDVALUES.SalesforceApp);
            itmDetail.SoftwareId = string.valueOf(Enums.FIELDVALUES.SalesforceApp);
            String internalId = (string) prodMap.get(Configuration.INTERNALIDSTRINGWITHNAMESPACE);
            ebizchargeServicemodelSoap.ItemDetailsResponse response = new ebizchargeServicemodelSoap.ItemDetailsResponse();
            try {
                ebcLogger.debug(ClassName, MethodName, '>>invoke_updateOpportunityFuture check');
                response = ebiz.UpdateItem(EBC_CompMethods.getSecurityToken(dml, ebcLogger), itmDetail, internalId, prodId);
            } catch (Exception e) {
                ebcLogger.debug(ClassName, MethodName, '>>Error has been occured in AddSalesOrder');
                ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
    }
    public static void invoke_AddProduct(DML dml, Product2 product) {
        EBC_Logger ebcLogger = new EBC_Logger();
        MethodName = 'invoke_AddProduct';
        try {
            string prodstring = JSON.serializePretty(product);
            String divisionId = Configuration.EMPTYSTRING;
            EBizcharge_Setting__c ebizchargeSettings = eBc_UtilityController.getSettings(dml, ebcLogger);
            if (test.isRunningTest()) {
                ebizchargeSettings.Division_ID__c = '999999';
            }
            if (ebizchargeSettings.Division_ID__c != null) {
                divisionId = ebizchargeSettings.Division_ID__c;
            }
            List < PricebookEntry > priceBookEntries = new List < PricebookEntry > ();
            string query_select = 'SELECT Product2.Id,UnitPrice';
            string query_from = 'from PriceBookEntry ';
            string query_where = 'where Product2.Id = \'' + product.id + '\' AND Pricebook2Id IN (SELECT Id FROM PriceBook2 WHERE IsStandard = true)';
            priceBookEntries = dml.selectRecords(query_select, query_from, query_where, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
            ebcLogger.debug(ClassName, MethodName, 'priceBookEntries is' + priceBookEntries);
            String priceBookEntryUnitPrice;
            if (priceBookEntries != null && priceBookEntries.size() > 0) {
                priceBookEntryUnitPrice = string.valueOf(priceBookEntries[0].UnitPrice);
                ebcLogger.debug(ClassName, MethodName, 'priceBookEntryUnitPrice');
                ebcLogger.debug(ClassName, MethodName, priceBookEntryUnitPrice);
            } else {
                priceBookEntryUnitPrice = '0';
                ebcLogger.debug(ClassName, MethodName, 'priceBookEntryUnitPrice');
                ebcLogger.debug(ClassName, MethodName, priceBookEntryUnitPrice);
            }
            invoke_AddProductFuture(prodstring, divisionId, priceBookEntryUnitPrice);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
    }
    public static void invoke_updateProduct(DML dml, Product2 product) {
        MethodName = 'invoke_updateProduct';
        EBC_Logger ebcLogger = new EBC_Logger();
        try {
            string prodstring = JSON.serializePretty(product);
            String divisionId = Configuration.EMPTYSTRING;
            EBizcharge_Setting__c ebizchargeSettings = eBc_UtilityController.getSettings(dml, ebcLogger);
            if (ebizchargeSettings.Division_ID__c != null) {
                divisionId = ebizchargeSettings.Division_ID__c;
            }
            List < PricebookEntry > priceBookEntries = new List < PricebookEntry > ();
            string query_select = 'SELECT Product2.Id,UnitPrice';
            string query_from = 'from PriceBookEntry ';
            string query_where = 'where Product2.Id = \'' + product.id + '\' AND Pricebook2Id IN (SELECT Id FROM PriceBook2 WHERE IsStandard = true)';
            priceBookEntries = dml.selectRecords(query_select, query_from, query_where, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
            ebcLogger.debug(ClassName, MethodName, 'priceBookEntries is' + priceBookEntries);
            String priceBookEntryUnitPrice;
            if (priceBookEntries != null && priceBookEntries.size() > 0) {
                priceBookEntryUnitPrice = string.valueOf(priceBookEntries[0].UnitPrice);
                ebcLogger.debug(ClassName, MethodName, 'priceBookEntryUnitPrice');
                ebcLogger.debug(ClassName, MethodName, priceBookEntryUnitPrice);
            } else {
                priceBookEntryUnitPrice = Configuration.ZERODECIMALSTRING;
            }
            invoke_updateProductFuture(prodstring, divisionId, priceBookEntryUnitPrice);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
    }
}