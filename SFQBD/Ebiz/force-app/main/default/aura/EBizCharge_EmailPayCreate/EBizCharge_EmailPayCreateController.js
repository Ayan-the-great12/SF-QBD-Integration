({
    handleCompEvent: function(component, event, helper) {
        try {
            var actionName = event.getParam("actionName");
            var AccountID = component.get('v.selectedLookUpAccRecord.Id');
            var OrderId = component.get('v.selectedLookUpOrdRecord.Id');
            if (actionName != 'showGrid') {
                if ($A.util.isEmpty(AccountID) && $A.util.isEmpty(OrderId)) {
                    component.set('v.Orders', null);
                } else {
                    component.set('v.Spinner', true);
                    helper.getOrders(component, event);
                }
            }
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    getOrders: function(component, event, helper) {
        try {
            var AccountID = component.get('v.selectedLookUpAccRecord.Id');
            var OrderId = component.get('v.selectedLookUpOrdRecord.Id');
            if ($A.util.isEmpty(AccountID) && $A.util.isEmpty(OrderId)) {
                helper.showToast('Please select account or order!', 'Error');
            } else {
                component.set('v.Spinner', true);
                helper.getOrders(component, event);
            }
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
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
                component.set('v.disableEmailForm', false);
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
                component.set('v.disableEmailForm', true);
                component.set('v.NoOfPayRequests', NoOfPayRequests);
            }
            var a = component.get('c.SelectSingleOrder');
            $A.enqueueAction(a);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    SelectSingleOrder: function(component, event, helper) {
        try {
            var Settings = component.get('v.Settings');
            var TaxAction = Settings.Ebiz_C__Tax_Action__c;
            var AccountID = component.get('v.selectedLookUpAccRecord.Id');
            var orderList = component.get('v.Orders');
            var accountName = '';
            var selectedOrders = [];
            var OrderNos = [];
            var OrderTotal = 0.0;
            var toEmail = '';
            var k = 0;
            for (var i = 0; i < orderList.length; i++) {
                var s = orderList[i];
                if (s.isSelected) {
                    var ordTax = 0.0;
                    if (TaxAction == 'Tax Included') {
                        var TaxDefaultPercent = Settings.Ebiz_C__Tax_Default_Percent__c / 100;
                        ordTax = parseFloat(0.0);
                    } else {
                        var TaxCalculatedBy = Settings.Ebiz_C__Tax_Calculate_By__c;
                        if (TaxCalculatedBy == 'Auto') {
                            var TaxDefaultPercent = Settings.Ebiz_C__Tax_Default_Percent__c / 100;
                            ordTax = (s.AmountDue * TaxDefaultPercent).toFixed(2);
                        } else {
                            var TaxManualType = Settings.Ebiz_C__Tax_Manual_Type__c;
                            ordTax = parseFloat(0.0);
                        }
                    }
                    s.OrderTax = ordTax;
                    OrderTotal = parseFloat(OrderTotal) + parseFloat(s.AmountDue);
                    selectedOrders[k] = s;
                    OrderNos[k] = s.OrderNumber;
                    toEmail = s.accEmail;
                    accountName = s.accName;
                    k++;
                }
            }
            component.set('v.NoOfPayRequests', k);
            var es = {};
            if (selectedOrders.length > 0) {
                es.Orders = selectedOrders;
                es.OrderNos = OrderNos;
                es.Amount = OrderTotal;
                es.accountId = AccountID;
                es.accountName = accountName;
                es.toEmail = toEmail;
                component.set('v.disableEmailForm', false);
            } else {
                component.set('v.disableEmailForm', true);
                es.Orders = '';
                es.OrderNos = '';
                es.Amount = '';
                es.accountId = '';
            }
            component.set('v.ES', es);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
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
    sortByAmountDue: function(cmp, event, helper) {
        helper.sortBy(cmp, "AmountDue");
    },
})