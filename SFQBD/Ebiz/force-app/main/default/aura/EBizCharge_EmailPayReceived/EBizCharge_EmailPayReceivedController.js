({
    doInit: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            helper.getReceivedPayments(component, event);
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
                        tooltip: 'Click to visit account'
                    }
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
                    label: 'Date Paid',
                    fieldName: 'PayDate',
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
                    label: 'Time Paid',
                    fieldName: 'PayTime',
                    type: 'time',
                    sortable: true,
                    cellAttributes: {
                        iconName: 'utility:clock',
                        iconPosition: 'left'
                    }
                },
                {
                    label: 'Ref Number',
                    fieldName: 'RefNum',
                    type: 'text',
                    sortable: true,
                    cellAttributes: {
                        iconName: 'utility:price_book_entries',
                        iconPosition: 'left'
                    }
                },
                {
                    label: 'Auth Code',
                    fieldName: 'AuthCode',
                    type: 'text',
                    sortable: true,
                    cellAttributes: {
                        iconName: 'utility:yubi_key',
                        iconPosition: 'left'
                    }
                },
                {
                    label: 'Amount',
                    fieldName: 'PaidAmount',
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
                    label: 'Payment Method',
                    fieldName: 'Last4',
                    initialWidth: 170,
                    type: 'text',
                    sortable: true,
                    cellAttributes: {
                        alignment: 'center',
                        class: {
                            fieldName: 'cardClass'
                        }
                    }
                },
                {
                    type: 'action',
                    typeAttributes: {
                        rowActions: rowActions
                    }
                }
            ]);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    searchAllReceivedPayments: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            var dt = new Date();
            var rrFromDate = $A.localizationService.formatDate(new Date(dt.getFullYear() - 1, dt.getMonth(), dt.getDate()), "YYYY-MM-DD");
            var rrToDate = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
            component.set('v.fromDate', rrFromDate);
            component.set('v.toDate', rrToDate);
            helper.getReceivedPayments(component, event);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    removeReceivedPayment: function(component, event, helper) {
        component.set("v.isOpen", true);
    },
    removeReceivedRequests: function(component, event, helper) {
        try {
            component.set("v.Spinner", true);
            helper.removeReceivedRecords(component, event);
            component.set('v.isOpen', false);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    closeModel: function(component, event, helper) {
        try {
            component.set("v.isOpen", false);
            component.set('v.Spinner', false);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    handleCompEvent: function(component, event, helper) {
        try {
            var a = component.get('c.validateDate');
            $A.enqueueAction(a);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    validateDate: function(component, event, helper) {
        try {
            var fromDate = component.get('v.fromDate');
            var toDate = component.get('v.toDate');
            if (fromDate != '' && fromDate != null && toDate != null && toDate != '') {
                var fromDate = new Date(fromDate);
                var toDate = new Date(toDate);
                var timeDiffrence = toDate - fromDate;
                if (timeDiffrence <= 0) {
                    component.set('v.disableFindBtn', true);
                    helper.showToast('End date should be greater than Start date!', 'Error');
                } else {
                    component.set('v.disableFindBtn', false);
                }
            } else {
                component.set('v.disableFindBtn', true);
            }
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    findReceivedPayments: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            helper.getReceivedPayments(component, event);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    handleSelectAction: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            var arr = event.getParam('row');
            helper.markPaymentApply(component, event, arr);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    handleSort: function(component, event, helper) {
        var sortBy = event.getParam("fieldName");
        var sortDirection = event.getParam("sortDirection");
        component.set("v.sortBy", sortBy);
        component.set("v.sortDirection", sortDirection);
        helper.sortData(component, sortBy, sortDirection);
    },
    updateSelectedText: function(cmp, event) {
        var selectedRows = event.getParam('selectedRows');
        var data = []
        if (selectedRows.length > 0) {
            selectedRows.map(function(rowData) {
                rowData.isSelected = true;
                data.push(rowData);
            });
            cmp.set('v.SelectedRecords', selectedRows);
            cmp.set('v.disableApplyButton', false);
        } else {
            cmp.set('v.selectedRowsCount', 0);
            cmp.set('v.SelectedRecords', null);
            cmp.set('v.disableApplyButton', true);
        }
        cmp.set('v.selectedRowsCount', selectedRows.length);
    },
    applyPayments: function(component, event, helper) {
        try {
            var emailPayList = component.get("v.SelectedRecords");
            if (emailPayList == null) {
                helper.showToast('Please select atleast one Email Pay to Apply!', 'Error');
                return;
            }
            component.set('v.Spinner', true);
            helper.markAllPaymentsApply(component, event, emailPayList);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    handleComponentEvent: function(component, event, helper) {
        try {
            var valueFromChild = event.getParam("message");
            if (valueFromChild == "Apply Payments") {
                var maxcount = component.get("v.MaxRecords");
                var recordlist = [];
                var i = 0;
                var emailPayList = component.get("v.SelectedRecords");
                if (emailPayList == null) {
                    component.set('v.isActive', false);
                    helper.showToast('Please select atleast one Email Pay to Apply!', 'Error');
                    return;
                }
                for (i = 0; i < maxcount; i++) {
                    recordlist.push(emailPayList[i]);
                }
                component.set('v.isActive', false);
                component.set("v.Spinner", true);
                helper.markAllPaymentsApply(component, event, recordlist);
            } else {
                helper.showToast('Event message not matched!', 'Error');
            }
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    }
})