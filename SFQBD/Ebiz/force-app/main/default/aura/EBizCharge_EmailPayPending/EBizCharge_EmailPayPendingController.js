({
    doInit: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            var rowActions = helper.getRowActions.bind(this, component);
            component.set("v.DataColumns", [{
                    label: 'Order #',
                    fieldName: 'OrderHyperUrl',
                    type: 'url',
                    sortable: true,
                    iconName: 'standard:products',
                    typeAttributes: {
                        label: {
                            fieldName: 'InvoiceNumber'
                        },
                        target: '_self',
                        tooltip: 'Click to visit order'
                    }
                },
                {
                    label: 'Date Sent',
                    fieldName: 'PaymentRequestDate',
                    type: 'date',
                    typeAttributes: {
                        day: 'numeric',
                        month: 'short',
                        year: 'numeric',
                        timeZone: "UTC"
                    },
                    sortable: true,
                    cellAttributes: {
                        iconName: 'utility:event',
                        iconPosition: 'left'
                    }
                },
                {
                    label: '# of Times Sent',
                    fieldName: 'ResendCount',
                    type: 'text',
                    sortable: true,
                },
                {
                    label: 'Account / Contact Name',
                    fieldName: 'AccountHyperUrl',
                    type: 'url',
                    sortable: true,
                    iconName: 'standard:client',
                    typeAttributes: {
                        label: {
                            fieldName: 'CustomerName'
                        },
                        target: '_self',
                        tooltip: 'Click to visit account'
                    }
                },
                {
                    label: 'Email',
                    fieldName: 'CustomerEmailAddress',
                    type: 'text',
                    sortable: true,
                    cellAttributes: {
                        iconName: 'utility:email',
                        iconPosition: 'left'
                    }
                },
                {
                    label: 'Order Amount',
                    fieldName: 'AmountDue',
                    sortable: true,
                    type: 'currency',
                    typeAttributes: {
                        currencyCode: 'USD'
                    },
                    cellAttributes: {
                        iconName: {
                            fieldName: 'provenanceIconAuthAmount'
                        },
                        iconLabel: {
                            fieldName: 'provenanceIconAuthAmountLabel'
                        },
                        iconPosition: 'left'
                    }
                },
                {
                    label: 'Amount Due',
                    fieldName: 'InvoiceAmount',
                    sortable: true,
                    type: 'currency',
                    typeAttributes: {
                        currencyCode: 'USD'
                    },
                    cellAttributes: {
                        iconName: {
                            fieldName: 'provenanceIconAuthAmount'
                        },
                        iconLabel: {
                            fieldName: 'provenanceIconAuthAmountLabel'
                        },
                        iconPosition: 'left'
                    }
                },
                {
                    label: 'Source',
                    fieldName: 'PaymentSourceId',
                    type: 'text',
                    sortable: true,
                    cellAttributes: {
                        iconName: 'utility:setup_assistant_guide',
                        iconPosition: 'left'
                    }
                },
                {
                    type: 'action',
                    typeAttributes: {
                        rowActions: rowActions
                    }
                }
            ]);
            helper.searchPending(component, event);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    searchPendingPayments: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            helper.searchPending(component, event);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    searchAllPendingPayments: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            var dt = new Date();
            var rrFromDate = $A.localizationService.formatDate(new Date(dt.getFullYear() - 1, dt.getMonth(), dt.getDate()), "YYYY-MM-DD");
            var rrToDate = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
            component.set('v.FromDate', rrFromDate);
            component.set('v.ToDate', rrToDate);
            helper.searchPending(component, event);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    validateDate: function(component, event, helper) {
        try {
            var FromDate = component.get('v.FromDate');
            var ToDate = component.get('v.ToDate');
            if (!$A.util.isEmpty(FromDate) && !$A.util.isEmpty(ToDate)) {
                var fDate = new Date(FromDate);
                var tDate = new Date(ToDate);
                var timeDiffrence = tDate - fDate;
                if (timeDiffrence < 0) {
                    component.set('v.disableFindBtn', true);
                    helper.showToastMsg('From date must be less then to date!', 'Error');
                } else {
                    component.set('v.disableFindBtn', false);
                    component.set('v.disableClearBtn', false);
                }
            } else {
                component.set('v.disableFindBtn', true);
                component.set('v.disableClearBtn', true);
            }
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    SelectAllOrders: function(component, event, helper) {
        try {
            var checkvalue = event.getSource().get("v.value");
            var checkOrder = component.find("checkOrder");
            if (checkvalue == true) {
                for (var i = 0; i < checkOrder.length; i++) {
                    checkOrder[i].set("v.value", true);
                    component.set('v.disableBtns', false);
                }
            } else {
                for (var i = 0; i < checkOrder.length; i++) {
                    checkOrder[i].set("v.value", false);
                    component.set('v.disableBtns', true);
                }
            }
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    handleRowActions: function(component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
    },
    handleRowAction: function(component, event, helper) {
        try {
            component.set("v.Spinner", true);
            var action = event.getParam('action');
            var arr = event.getParam('row');
            var actionStr;
            if (action.name == 'SendEmailReminder') {
                actionStr = 'sendEmail';
            } else {
                actionStr = 'Remove';
            }
            var PayInternalId = arr.PaymentInternalId;
            var pendingList = component.get('v.pendingPayList');
            for (var i = 0; i < pendingList.length; i++) {
                var s = pendingList[i];
                if (PayInternalId == s.PaymentInternalId) {
                    s.isSelected = true;
                    break;
                }
            }
            if (actionStr == 'Remove') {
                helper.removePendingRecords(component, event);
            } else {
                helper.SendEmailsNow(component, event);
            }
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    updateSelectedText: function(cmp, event) {
        var selectedRows = event.getParam('selectedRows');
        var dataList = selectedRows.map(function(rowData) {
            rowData.isSelected = true;
            return rowData;
        });
        if (selectedRows.length > 0) {
            cmp.set('v.disableBtns', false);
            cmp.set('v.SelectedpendingPayList', selectedRows);
        } else {
            cmp.set('v.disableBtns', true);
            cmp.set('v.SelectedpendingPayList', []);
        }
        cmp.set('v.NoOfSelectedRecords', selectedRows.length);
    },
    removePendingPayment: function(component, event, helper) {
        try {
            component.set('v.showModal', true);
            component.set('v.actionStr', 'Remove')
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    handleSort: function(component, event, helper) {
        var sortBy = event.getParam("fieldName");
        var sortDirection = event.getParam("sortDirection");
        component.set("v.sortBy", sortBy);
        component.set("v.sortDirection", sortDirection);
        helper.sortData(component, sortBy, sortDirection);
    },
    SendEmailNow: function(component, event, helper) {
        try {
            component.set('v.showModal', true);
            component.set('v.actionStr', 'sendEmail');
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
})