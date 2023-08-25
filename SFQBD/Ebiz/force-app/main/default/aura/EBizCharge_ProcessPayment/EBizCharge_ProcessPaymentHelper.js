({
    getSettings: function(component, event) {
        var action = component.get("c.getSettingsApxc");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var cs = response.getReturnValue();
                if ($A.util.isEmpty(cs.Ebiz_C__Security_Token__c)) {
                    component.set('v.ShowWarn', true);
                } else {
                    component.set('v.ShowWarn', false);
                }
                component.set('v.Settings', cs);
                if (cs.Ebiz_C__Tax_Manual_Type__c == 'Use Percent') {
                    var str = 'Tax(%value)';
                    component.set('v.TaxTitle', str);
                } else {
                    var str = 'Tax($amount)';
                    component.set('v.TaxTitle', str);
                }
            }
        });
        $A.enqueueAction(action);
    },
    getOrderList: function(cmp, event, helper) {
        var accountId = cmp.get('v.selectedLookUpRecord.Id');
        var action = cmp.get("c.getListOfOrdersApxc");
        action.setParams({
            AccountID: accountId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var records = response.getReturnValue();
                cmp.set("v.originalorderList", records.accountOrders);
                cmp.set("v.accountDetail", records.accountDetail);
                var savedCard = [];
                var savedACH = [];
                var payM = records.savedPaymentMethods;
                var saveCardsExtendedList = records.savedMethods.SavedPaymentMethodslist;
                if (saveCardsExtendedList != null) {}
                for (var key in payM) {
                    var arr = [];
                    arr = key.toString().split('@');
                    if (arr[1] == 'C') {
                        savedCard.push({
                            value: payM[key],
                            key: arr[0]
                        });
                    } else {
                        savedACH.push({
                            value: payM[key],
                            key: arr[0]
                        });
                    }
                }
                cmp.set('v.saveCardsList', savedCard);
                cmp.set('v.saveCardsExtendedList', saveCardsExtendedList);
                cmp.set('v.saveACHList', savedACH);
                if (savedCard.length > 0) {
                    cmp.set('v.placeholderSC', 'Select saved cards');
                } else {
                    cmp.set('v.placeholderSC', 'No saved cards on file');
                }
                if (savedACH.length > 0) {
                    cmp.set('v.placeholderSA', 'Select saved accounts');
                } else {
                    cmp.set('v.placeholderSA', 'No saved accounts on file');
                }
                this.sortBy(cmp, "CreatedDate");
            } else {
                cmp.set("v.Spinner", false);
            }
        });
        $A.enqueueAction(action);
    },
    sortBy: function(component, field) {
        var sortAsc = component.get("v.sortAsc"),
            sortField = component.get("v.sortField"),
            records = component.get("v.originalorderList");
        sortAsc = sortField != field || !sortAsc;
        records.sort(function(a, b) {
            var t1 = a[field] == b[field],
                t2 = (!a[field] && b[field]) || (a[field] < b[field]);
            return t1 ? 0 : (sortAsc ? -1 : 1) * (t2 ? 1 : -1);
        });
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", field);
        component.set("v.originalorderList", records);
        component.set("v.Spinner", false);
    },
    clearAll: function(cmp, event, helper) {
        cmp.set("v.isSelectAll", false);
        cmp.set("v.disabledPayBy", true);
        cmp.set("v.disableSubmitBtn", true);
        cmp.set("v.disableScheduleRR", true);
        cmp.set("v.originalorderList", null);
        cmp.set("v.Spinner", false);
        cmp.set("v.disabledPayBy", true);
        cmp.set("v.disableSubmitBtn", true);
        cmp.set("v.disableScheduleRR", true);
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
    showToastMsg: function(msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            duration: ' 5000',
            mode: 'dismissible',
            message: msg,
            type: type,
            title: type + "!",
        });
        toastEvent.fire();
    },
})