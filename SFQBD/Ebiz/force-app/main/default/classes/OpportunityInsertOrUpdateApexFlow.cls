public with sharing class OpportunityInsertOrUpdateApexFlow {
    public static string ClassName = 'OpportunityInsertOrUpdateApexFlow';
    public static string MethodName = Configuration.EMPTYSTRING;
    public static ebizchargeServicemodelSoap.eBizService ebiz = new ebizchargeServicemodelSoap.eBizService();
    @InvocableMethod
    public static void invoke_updateOpportunity(List < opportunity > opportunities) {
        MethodName = 'invoke_updateOpportunity';
        EBC_Logger ebcLogger = new EBC_Logger();
        Dml dml = new Dml();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        try {
            EBizcharge_Setting__c settings = new EBizcharge_Setting__c();
            settings = eBc_SettingController.getSettingsApxc(dml, ebcLogger);
            if (settings.Auto_Upload_Opportunity__c) {
                for (opportunity opportunity: opportunities) {
                    if (opportunity.EBizCharge_Internal_ID__c != null) {
                        invoke_updateOpportunity(dml, opportunity);
                    } else {
                        invoke_AddOpportunityFuture(opportunity.Id);
                    }
                }
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
    }
    @Future(callout = true)
    public static void invoke_AddOpportunityFuture(string opportunityId) {
        MethodName = 'invoke_AddOpportunityFuture';
        EBC_Logger ebcLogger = new EBC_Logger();
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        try {
            EBC_ComponentController.getDetailApxc(dml, opportunityId, string.valueOf(Enums.SALESFORCEOBJECTNAMES.Opportunity), ebcLogger);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
    }
    @Future(callout = true)
    public static void invoke_updateOpportunityFuture(string opportunityString, String divisionId) {
        MethodName = 'invoke_updateOpportunityFuture';
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        try {
            Map < String, Object > opportunityMap = (Map < String, Object > ) JSON.deserializeUntyped(opportunityString);
            ebizchargeServicemodelSoap.SalesOrder salesOrder = new ebizchargeServicemodelSoap.SalesOrder();
            String opportunityId = (String) opportunityMap.get(string.valueOf(Enums.ENTITYFIELDSMAPSTRINGS.Id));
            String querySelect = 'select id,QBD_Customer_ID__c';
            String queryFrom = 'from Account';
            String queryWhere =  'where id=\''+ (String) opportunityMap.get(string.valueOf(Enums.ENTITYFIELDSMAPSTRINGS.AccountId))+'\'';
            Account account = (Account)dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING,Configuration.EMPTYSTRING);
            //salesOrder.CustomerId = (String) opportunityMap.get(string.valueOf(Enums.ENTITYFIELDSMAPSTRINGS.AccountId));
            salesOrder.CustomerId = (string)account.get('QBD_Customer_ID__c');
            salesOrder.SalesOrderNumber = opportunityId;
            salesOrder.Amount = (Decimal) opportunityMap.get(string.valueOf(Enums.FIELDNAMES.Amount));
            salesOrder.PoNum = (String) opportunityMap.get(Configuration.OPPORTUINITYPONUMSTRING);
            salesOrder.Software = string.valueOf(Enums.FIELDVALUES.SalesforceApp);
            salesOrder.TypeId = string.valueOf(Enums.SALESFORCEOBJECTNAMES.Opportunity);
            salesOrder.DivisionId = divisionId;
            String internalId = (string) opportunityMap.get(Configuration.INTERNALIDSTRINGWITHNAMESPACE);
            ebizchargeServicemodelSoap.SalesOrderResponse opportunityResponse = new ebizchargeServicemodelSoap.SalesOrderResponse();
            List < OpportunityLineItem > opportunityLineItems = LineItems.getOpportunityLineItemsDetail(dml, opportunityId, ebcLogger);
            if (opportunityLineItems != null) {
                ebizchargeServicemodelSoap.ArrayOfCustomItem arrayOfCustomItems = new ebizchargeServicemodelSoap.ArrayOfCustomItem();
                ebizchargeServicemodelSoap.CustomItem[] items = new List < ebizchargeServicemodelSoap.CustomItem > ();
                for (OpportunityLineItem opportunityLineItem: opportunityLineItems) {
                    ebizchargeServicemodelSoap.CustomItem item = new ebizchargeServicemodelSoap.CustomItem();
                    String opportunityLineItemEBizId = opportunityLineItem.Product2Id;
                    ebcLogger.debug(ClassName, MethodName, 'opportunityLineItemEBizId>>>' + opportunityLineItemEBizId);
                    if (test.isRunningTest()) {
                        opportunityLineItemEBizId = '1134234111';
                    }
                    if (opportunityLineItemEBizId != null) {
                        item.ItemInternalId = opportunityLineItem.Product2Id;
                        item.ItemId = opportunityLineItem.Product2Id;
                        item.Name = opportunityLineItem.product2.Name;
                        item.UnitPrice = opportunityLineItem.UnitPrice;
                        item.Qty = opportunityLineItem.Quantity;
                        item.Taxable = false;
                        item.Description = ((opportunityLineItem.product2.Description != null) ? opportunityLineItem.product2.Description : Configuration.EMPTYSTRING);
                        ebizchargeServicemodelSoap.ArrayOfEbizCustomField arrayOfCustomFields = new ebizchargeServicemodelSoap.ArrayOfEbizCustomField();
                        list < ebizchargeServicemodelSoap.EbizCustomField > customFields = new list < ebizchargeServicemodelSoap.EbizCustomField > ();
                        ebizchargeServicemodelSoap.EbizCustomField itemIdField = new ebizchargeServicemodelSoap.EbizCustomField();
                        itemIdField.FieldName = string.valueOf(Enums.ENTITYFIELDSMAPSTRINGS.Id);
                        itemIdField.FieldValue = opportunityLineItem.Id;
                        customFields.add(itemIdField);
                        arrayOfCustomFields.EbizCustomField = customFields;
                        item.ItemCustomFields = arrayOfCustomFields;
                        items.add(item);
                    }
                }
                arrayOfCustomItems.Item = items;
                salesOrder.Items = arrayOfCustomItems;
            }
            opportunityResponse = ebiz.UpdateSalesOrder(EBC_CompMethods.getSecurityToken(dml, ebcLogger), salesOrder, salesOrder.CustomerId, Configuration.EMPTYSTRING, salesOrder.SalesOrderNumber, internalId);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, '>>Error has been occured in AddSalesOrder');
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
    }
    public static void invoke_updateOpportunity(DML dml, Opportunity opportunity) {
        MethodName = 'invoke_updateOpportunity';
        EBC_Logger ebcLogger = new EBC_Logger();
        try {
            string opportunityString = JSON.serializePretty(opportunity);
            String divisionId = Configuration.EMPTYSTRING;
            EBizcharge_Setting__c settings = eBc_UtilityController.getSettings(dml, ebcLogger);
            if (settings.Division_ID__c != null) {
                divisionId = settings.Division_ID__c;
            }
            invoke_updateOpportunityFuture(opportunityString, divisionId);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
    }
}