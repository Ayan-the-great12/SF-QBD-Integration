({
    doinit: function(component, event, helper) {
        helper.getSettings(component);
        var record = component.get("v.selectedLookUpRecord");
    },
    CreateNewOrder: function(component, event, helper) {
        component.set('v.showOrdModal', true);
    },
    inlineEditPayment: function(cmp, event, helper) {
        var idx = event.target.id;
        var orderList = cmp.get("v.originalorderList");
        for (var i = 0; i < orderList.length; i++) {
            var s = orderList[i];
            if (s.OrderNumber == idx) {
                s.isEdited = true;
            } else {
                s.isEdited = false;
            }
        }
        cmp.set("v.paymentEditMode", true);
        setTimeout(function() {
            cmp.find(idx).focus();
        }, 100);
    },
    handleCompEvent: function(cmp, event, helper) {
        cmp.set("v.Spinner", true);
        var actionName = event.getParam("actionName");
        if (actionName == 'showGrid') {
            helper.getOrderList(cmp, event, helper);
        } else if (actionName == 'clearFields') {
            helper.clearAll(cmp, event, helper);
        }
        var a = cmp.get('c.handleParentActiveTab');
        $A.enqueueAction(a);
    },
    RefreshHandler: function(cmp, event, helper) {
        cmp.set("v.Spinner", true);
        cmp.set('v.isSelectAll', 'false');
        cmp.set('v.OrderTotal', 0.0);
        $A.get('e.force:refreshView').fire();
        helper.getOrderList(cmp, event, helper);
    },
    SelectAllOrders: function(component, event, helper) {
        try {
            var checkvalue = event.getSource().get("v.value");
            component.set('v.isSelectAll', checkvalue);
            var checkOrder = component.find("checkOrder");
            var obj_size = Object.keys(checkOrder).length;
            var NoOfPayRequests = 0;
            if (checkvalue == true) {
                if (obj_size == 13) {
                    checkOrder.set("v.value", true);
                    NoOfPayRequests++;
                } else {
                    for (var i = 0; i < checkOrder.length; i++) {
                        checkOrder[i].set("v.value", true);
                        NoOfPayRequests++;
                    }
                }
                component.set('v.NoOfPayRequests', NoOfPayRequests);
            } else {
                if (obj_size == 13) {
                    checkOrder.set("v.value", false);
                    NoOfPayRequests++;
                } else {
                    for (var i = 0; i < checkOrder.length; i++) {
                        checkOrder[i].set("v.value", false);
                    }
                }
                component.set('v.NoOfPayRequests', NoOfPayRequests);
            }
            var a = component.get('c.SelectSingleOrder');
            $A.enqueueAction(a);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    onChangeTax: function(cmp, event, helper) {
        var Tax = cmp.get("v.Tax");
        var orderList = cmp.get("v.originalorderList");
        if (orderList.length > 0) {
            var a = cmp.get('c.SelectSingleOrder');
            $A.enqueueAction(a);
        }
    },
    SelectSingleOrder: function(cmp, event, helper) {
        var Settings = cmp.get('v.Settings');
        var TaxAction = Settings.Ebiz_C__Tax_Action__c;
        var ShowTaxField = Settings.Ebiz_C__Show_Tax_Field__c;
        var Tax = 0.0;
        var totalTax = 0.0;
        var orderList = cmp.get("v.originalorderList");
        var selectedOrders = [];
        var OrderNos = [];
        var OrderTotal = 0.0;
        var k = 0;
        for (var i = 0; i < orderList.length; i++) {
            var s = orderList[i];
            if (s.isSelected) {
                if (parseFloat(s.AmountDue) == 0) {
                    helper.showToastMsg('Orders with zero balance will not be processed', 'Warning');
                } else {
                    var ordTax = 0.0;
                    OrderTotal = parseFloat(OrderTotal) + parseFloat(s.AmountDue);
                    if (TaxAction == 'Tax Included') {
                        ordTax = parseFloat(0.0);
                    } else {
                        var TaxCalculatedBy = Settings.Ebiz_C__Tax_Calculate_By__c;
                        if (TaxCalculatedBy == 'Auto') {
                            var TaxDefaultPercent = Settings.Ebiz_C__Tax_Default_Percent__c / 100;
                            ordTax = (s.AmountDue * TaxDefaultPercent).toFixed(2);
                        } else {
                            var TaxManualType = Settings.Ebiz_C__Tax_Manual_Type__c;
                            if (TaxManualType == 'Use Percent') {
                                Tax = cmp.get('v.Tax') / 100;
                                ordTax = (s.AmountDue * Tax).toFixed(2);
                            } else {
                                ordTax = cmp.get('v.Tax');
                                totalTax = totalTax + parseFloat(ordTax);
                            }
                        }
                    }
                    s.OrderTax = ordTax;
                    selectedOrders[k] = s;
                    OrderNos[k] = s.OrderNumber;
                    k++;
                }
            }
        }
        cmp.set('v.NoOfPayRequests', k);
        if (TaxAction == 'Tax Included') {
            var TaxDefaultPercent = Settings.Ebiz_C__Tax_Default_Percent__c / 100;
            Tax = 0.0;
        } else {
            var TaxCalculatedBy = Settings.Ebiz_C__Tax_Calculate_By__c;
            if (TaxCalculatedBy == 'Auto') {
                var TaxDefaultPercent = Settings.Ebiz_C__Tax_Default_Percent__c / 100;
                Tax = (OrderTotal * TaxDefaultPercent).toFixed(2);
            } else {
                var TaxManualType = Settings.Ebiz_C__Tax_Manual_Type__c;
                if (TaxManualType == 'Use Percent') {
                    Tax = cmp.get('v.Tax') / 100;
                    Tax = (OrderTotal * Tax).toFixed(2);
                } else {
                    Tax = totalTax;
                }
            }
        }
        cmp.set("v.OrderTotal", OrderTotal);
        var accInfo = cmp.get("v.accountDetail");
        var os = {};
        if (selectedOrders.length > 0) {
            cmp.set("v.disabledPayBy", false);
            cmp.set("v.disableScheduleRR", false);            
            os.accDetail	= accInfo;
            os.accId 		= accInfo.Id;
            os.accName 		= accInfo.Name;
            os.accEmail     = accInfo.Ebiz_C__Email__c ;
            os.accExtrId 	= accInfo.Ebiz_C__EBizCharge_Internal_ID__c;
            os.NoOfOrders	= selectedOrders.length;
            os.OrderTotal	= parseFloat(OrderTotal);
            os.OrderTax		= Tax;
            os.ExcludeTax 	= cmp.get('v.ExcludeTax');
            os.OrdersNo 	= OrderNos;
            os.selectedOrders = selectedOrders; 
        }else{
            cmp.set("v.disabledPayBy", true);
            cmp.set("v.disableSubmitBtn", true);
            cmp.set("v.disableScheduleRR", true);
            os.accDetail = '';
            os.accId = '';
            os.accEmail = '';
            os.accName = '-';
            os.NoOfOrders = '-';
            os.OrderTotal = '0.0';
            os.OrderTax = '0.0';
            os.ExcludeTax = false;
            os.selectedOrders = '';
            os.OrdersNo = '';
            cmp.set('v.paymentTotal', '0.0');
            cmp.set('v.OrderTotal', '0.0');
        }
        var amount = os.OrderTotal;
        var Tax = Tax;
        var TotalAmount = 0.0;
        if (TaxAction == 'Tax Included' || ShowTaxField == false) {
            TotalAmount = parseFloat(amount);
        } else {
            TotalAmount = parseFloat(amount) + parseFloat(Tax);
        }
        os.paymentTotal = TotalAmount;
        cmp.set('v.paymentTotal', TotalAmount);
        cmp.set('v.OS', os);
    },
    handleParentActiveTab: function(cmp, event, helper) {
        var tab = event.getSource();
        tab = tab.get('v.id');
        cmp.set('v.ActiveTab', tab);
        var childComp = '';
        if (tab == 'PayByCard') {
            childComp = cmp.find('UsePayByCard');
        } else if (tab == 'PayByACH') {
            childComp = cmp.find('UsePayByACH');
        }
        childComp.clearForm();
        cmp.set('v.disableSubmitBtn', true);
        cmp.set('v.card4Degit', '-');
    },
    processPayment: function(cmp, event, helper) {
        var tab = cmp.get('v.ActiveTab');
        var childComp = '';
        if (tab == 'PayByCard') {
            childComp = cmp.find('UsePayByCard');
        } else if (tab == 'PayByACH') {
            childComp = cmp.find('UsePayByACH');
        }
        var OrderSummary = cmp.get('v.OS');
        childComp.validateAndSubmitForm(OrderSummary);
    },
    updateOrderGrid: function(cmp, event, helper) {
        helper.getOrderList(cmp, event, helper);
        cmp.set("v.disableSubmitBtn", true);
        cmp.set("v.disableScheduleRR", true);
        var os = {};
        os.accId = '';
        os.accName = '-';
        os.NoOfOrders = '-';
        os.OrderTotal = '0.0';
        os.OrderTax = '0.0';
        os.selectedOrders = '';
        os.OrdersNo = '';
        cmp.set('v.OS', os);
        cmp.set('v.card4Degit', '-');
        cmp.set('v.paymentTotal', '0.0');
        cmp.set('v.OrderTotal', '0.0');
    },
    ExcludeTaxFromTotal: function(component, event, helper) {
        var checkbox = event.getSource().get("v.value");
        component.set('v.ExcludeTax', checkbox);
        var OrderTotal = component.get('v.OS.OrderTotal');
        var OrderTax = component.get('v.OS.OrderTax');
        var paymentTotal = component.get('v.OS.paymentTotal');
        if (checkbox) {
            component.set('v.paymentTotal', OrderTotal);
            component.set('v.OS.ExcludeTax', checkbox);
        } else {
            var TotalAmount = parseFloat(OrderTotal) + parseFloat(OrderTax);
            component.set('v.paymentTotal', TotalAmount);
            component.set('v.OS.ExcludeTax', checkbox);
        }
    },
    sortByOrderNumber: function(cmp, event, helper) {
        helper.sortBy(cmp, "OrderNumber");
    },
    sortByAccountName: function(cmp, event, helper) {
        helper.sortBy(cmp, "accName");
    },
    sortByEmail: function(cmp, event, helper) {
        helper.sortBy(cmp, "accEmail");
    },
    sortByOrderDate: function(cmp, event, helper) {
        helper.sortBy(cmp, "CreatedDate");
    },
    sortByOrderAmount: function(cmp, event, helper) {
        helper.sortBy(cmp, "TotalAmount");
    },
    sortByOrderBalance: function(cmp, event, helper) {
        helper.sortBy(cmp, "OrderBalance");
    },
    sortByAmountDue: function(cmp, event, helper) {
        helper.sortBy(cmp, "AmountDue");
    },
    callParentCmpMethod: function(cmp, event, helper) {
        var paymentTotal = cmp.get('v.OS.paymentTotal');
        cmp.set('v.paymentTotal', paymentTotal);
    },
    onCheck: function(cmp, event, helper) {
        var name = event.getSource().get("v.name");
        var val = event.getSource().get("v.value");
    },
    passParam: function(cmp, event, helper) {
        var name = event.getSource().get("v.name");
        var val = event.getSource().get("v.value");
        var check = event.getSource().get('v.checked');
        var accName = '';
        if (check == true) {
            accName = 'Hello Demo Account';
        } else {
            accName = '';
        }
        var childComp = cmp.find('PPSummary');
        childComp.showOrderSummary(
            accName
        );
    },
})