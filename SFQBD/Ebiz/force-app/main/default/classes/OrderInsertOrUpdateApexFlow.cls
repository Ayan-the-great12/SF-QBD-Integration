public with sharing class OrderInsertOrUpdateApexFlow {
    public static string ClassName = 'OrderInsertOrUpdateApexFlow';
    public static string MethodName = Configuration.EMPTYSTRING;
    public static ebizchargeServicemodelSoap.eBizService ebiz = new ebizchargeServicemodelSoap.eBizService();
    @InvocableMethod
    public static void invoke_updateOrder(List < Order > orders) {
        MethodName = 'invoke_updateOrder';
        EBC_Logger ebcLogger = new EBC_Logger();
        ebcLogger.debug(ClassName, MethodName, 'flow is invoked');
        ebcLogger.debug(ClassName, MethodName, 'orders is ' + orders);
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        try {
            EBizcharge_Setting__c settings = new EBizcharge_Setting__c();
            settings = eBc_SettingController.getSettingsApxc(dml, ebcLogger);
            if (settings.Auto_Upload_Order__c) {
                for (Order orderObj: orders) {
                    if (orderObj.EBizCharge_Internal_ID__c != null) {
                        invoke_updateOrder(dml, orderObj);
                    } else {
                        invoke_AddOrderFuture(orderObj.Id);
                    }
                }
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
    }
    @Future(callout = true)
    public static void invoke_AddOrderFuture(string orderId) {
        EBC_Logger ebcLogger = new EBC_Logger();
        MethodName = 'invoke_AddOrderFuture';
        try {
            DML dml = new DML();
            if (test.isRunningTest()) {
                dml = (DML) MockUtil.createMock(DML.class);
            }
            EBC_ComponentController.getDetailApxc(dml, orderId, string.valueOf(Enums.SALESFORCEOBJECTNAMES.Order), ebcLogger);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
    }
    public static void invoke_updateOrder(DML dml, Order orderObj) {
        EBC_Logger ebcLogger = new EBC_Logger();
        MethodName = 'invoke_updateOrder';
        try {
            string orderObjstring = JSON.serializePretty(orderObj);
            String divisionId = Configuration.EMPTYSTRING;
            EBizcharge_Setting__c ebizchargeSettings = eBc_UtilityController.getSettings(dml, ebcLogger);
            if (ebizchargeSettings.Division_ID__c != null) {
                divisionId = ebizchargeSettings.Division_ID__c;
            }
            invoke_updateOrderFuture(orderObjstring, divisionId);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
    }
    @Future(callout = true)
    public static void invoke_updateOrderFuture(string orderstring, String divisionId) {
        EBC_Logger ebcLogger = new EBC_Logger();
        MethodName = 'invoke_updateOrderFuture';
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        try {
            Map < String, Object > orderMap = (Map < String, Object > ) JSON.deserializeUntyped(orderstring);
            ebizchargeServicemodelSoap.SalesOrder salesOrder = new ebizchargeServicemodelSoap.SalesOrder();
            String orderId = (String) orderMap.get(string.valueOf(Enums.ENTITYFIELDSMAPSTRINGS.Id));
            String querySelect = 'select id,QBD_Customer_ID__c';
            String queryFrom = 'from Account';
            String queryWhere =  'where id=\''+ (String) orderMap.get(string.valueOf(Enums.ENTITYFIELDSMAPSTRINGS.AccountId))+'\'';
            Account account = (Account)dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING,Configuration.EMPTYSTRING);
            //salesOrder.CustomerId = (String) orderMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.AccountId));
            salesOrder.CustomerId = (string)account.get('QBD_Customer_ID__c');
            salesOrder.SubCustomerId = null;
            salesOrder.SalesOrderNumber = (String) orderMap.get(string.valueOf(Enums.ENTITYFIELDSMAPSTRINGS.OrderNumber));
            salesOrder.Amount = (Decimal) orderMap.get(string.valueOf(Enums.ENTITYFIELDSMAPSTRINGS.TotalAmount));
            salesOrder.AmountDue = (Decimal) orderMap.get(string.valueOf(Enums.ENTITYFIELDSMAPSTRINGS.TotalAmount));
            salesOrder.DueDate = Configuration.EMPTYSTRING;
            salesOrder.TotalTaxAmount = 0;
            salesOrder.PoNum = (String) orderMap.get(string.valueOf(Enums.ENTITYFIELDSMAPSTRINGS.PoNumber));
            salesOrder.NotifyCustomer = false;
            salesOrder.IsToBeEmailed = false;
            salesOrder.IsToBePrinted = false;
            salesOrder.Software = string.valueOf(Enums.FIELDVALUES.SalesforceApp);
            salesOrder.ShipDate = null;
            salesOrder.Items = null;
            salesOrder.divisionId = divisionId;
            String internalId = (string) orderMap.get(Configuration.INTERNALIDSTRINGWITHNAMESPACE);
            ebizchargeServicemodelSoap.EbizCustomField ebizCstmField = new ebizchargeServicemodelSoap.EbizCustomField();
            ebizCstmField.FieldName = string.valueOf(Enums.FIELDNAMES.dateupdated);
            ebizCstmField.FieldValue = String.valueOfGmt(DateTime.now());
            ebizchargeServicemodelSoap.ArrayOfEbizCustomField arrCstmField = new ebizchargeServicemodelSoap.ArrayOfEbizCustomField();
            arrCstmField.EbizCustomField = new List < ebizchargeServicemodelSoap.EbizCustomField > ();
            arrCstmField.EbizCustomField.add(ebizCstmField);
            salesOrder.SalesOrderCustomFields = arrCstmField;
            List < OrderItem > orderItemList = (List < OrderItem > ) LineItems.getOrderItemsDetail(dml, orderId, ebcLogger);
            if (orderItemList != null) {
                ebizchargeServicemodelSoap.ArrayOfCustomItem arrItems = new ebizchargeServicemodelSoap.ArrayOfCustomItem();
                ebizchargeServicemodelSoap.CustomItem[] ItemsArr = new List < ebizchargeServicemodelSoap.CustomItem > ();
                for (OrderItem orderItem: orderItemList) {
                    ebizchargeServicemodelSoap.CustomItem item = new ebizchargeServicemodelSoap.CustomItem();
                    String prodEBizId = orderItem.Product2Id;
                    ebcLogger.debug(ClassName, MethodName, 'prodEBizId>>>' + prodEBizId);
                    if (test.isRunningTest()) {
                        prodEBizId = '1134234111';
                    }
                    if (prodEBizId != null) {
                        item.ItemInternalId = prodEBizId;
                        item.ItemId = orderItem.Product2Id;
                        item.Name = orderItem.product2.Name;
                        item.UnitPrice = orderItem.UnitPrice;
                        item.Qty = orderItem.Quantity;
                        item.Taxable = false;
                        item.Description = ((orderItem.product2.Description != null) ? orderItem.product2.Description : Configuration.EMPTYSTRING);
                        ebizchargeServicemodelSoap.ArrayOfEbizCustomField arrCustomFields = new ebizchargeServicemodelSoap.ArrayOfEbizCustomField();
                        list < ebizchargeServicemodelSoap.EbizCustomField > listCustomFields = new list < ebizchargeServicemodelSoap.EbizCustomField > ();
                        ebizchargeServicemodelSoap.EbizCustomField itemIdField = new ebizchargeServicemodelSoap.EbizCustomField();
                        itemIdField.FieldName = string.valueOf(Enums.ENTITYFIELDSMAPSTRINGS.Id);
                        itemIdField.FieldValue = orderItem.Id;
                        listCustomFields.add(itemIdField);
                        arrCustomFields.EbizCustomField = listCustomFields;
                        item.ItemCustomFields = arrCustomFields;
                        ItemsArr.add(item);
                    }
                } // end of for loop orderItem...
                arrItems.Item = ItemsArr;
                ebcLogger.debug(ClassName, MethodName, 'items list is' + ItemsArr);
                salesOrder.Items = arrItems;
            }
            ebizchargeServicemodelSoap.SalesOrderResponse saleorder_response = new ebizchargeServicemodelSoap.SalesOrderResponse();
            saleorder_response = ebiz.UpdateSalesOrder(eBc_UtilityController.getSecurityToken(dml, ebcLogger), salesOrder, salesOrder.CustomerId, Configuration.EMPTYSTRING, salesOrder.SalesOrderNumber, internalId);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
    }
}