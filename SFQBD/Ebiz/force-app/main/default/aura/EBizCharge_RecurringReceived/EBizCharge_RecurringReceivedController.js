({
    doInit: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            helper.getReceivedrrPayments(component, event);
            var rowActions = helper.getRowActions.bind(this, component);
            component.set("v.DataColumns", [{
                    label: 'Customer',
                    fieldName: 'rrCustNum',
                    type: 'text',
                    sortable: true,
                },
                {
                    label: 'Account / Contact Name',
                    fieldName: 'RecurringHyperUrl',
                    type: 'url',
                    sortable: true,
                    iconName: 'standard:client',
                    typeAttributes: {
                        label: {
                            fieldName: 'rrCustomerName'
                        },
                        target: '_self',
                        tooltip: 'Click to visit account'
                    }
                },
                {
                    label: 'Date Paid',
                    fieldName: 'rrDatePaid',
                    type: 'date',
                    typeAttributes: {
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
                    fieldName: 'rrTimePaid',
                    type: 'time',
                    sortable: true,
                    cellAttributes: {
                        iconName: 'utility:clock',
                        iconPosition: 'left'
                    }
                },
                {
                    label: 'Ref Number',
                    fieldName: 'rrRefNum',
                    type: 'text',
                    sortable: true,
                    cellAttributes: {
                        iconName: 'utility:event',
                        iconPosition: 'left'
                    }
                },
                {
                    label: 'Auth Code',
                    fieldName: 'rrAuthCode',
                    type: 'text',
                    sortable: true,
                    cellAttributes: {
                        iconName: 'utility:yubi_key',
                        iconPosition: 'left'
                    }
                },
                {
                    label: 'Amount',
                    fieldName: 'rrPaidAmount',
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
                    fieldName: 'rrMaskedPMValue',
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
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    handleCompEvent: function(component, event, helper) {
        try {
            var actionName = event.getParam("actionName");
            if (actionName != 'showGrid') {
                component.set('v.Spinner', true);
                component.set('v.rrFromDate', null);
                component.set('v.rrToDate', null);
                helper.getReceivedrrPayments(component, event);
            }
            var a = component.get('c.validateDate');
            $A.enqueueAction(a);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    validateDate: function(component, event, helper) {
        try {
            var rrFromDate = component.get('v.rrFromDate');
            var rrToDate = component.get('v.rrToDate');
            if (rrFromDate != '' && rrFromDate != null && rrToDate != null && rrToDate != '') {
                var rrStartDate = new Date(rrFromDate);
                var rrEndDate = new Date(rrToDate);
                var timeDiffrence = rrEndDate - rrStartDate;
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
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    showAll: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            var dt = new Date();
            var rrFromDate = $A.localizationService.formatDate(new Date(dt.getFullYear() - 1, dt.getMonth(), dt.getDate()), "YYYY-MM-DD");
            var rrToDate = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
            component.set('v.rrFromDate', rrFromDate);
            component.set('v.rrToDate', rrToDate);
            helper.getReceivedrrPayments(component, event);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    FindReceivedRRPayments: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            helper.getReceivedrrPayments(component, event);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    handleSelectAction: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            var row = event.getParam('row');
            helper.markPaymentApply(component, event, row);
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
    updateSelectedText: function(cmp, event) {
        var selectedRows = event.getParam('selectedRows');
        var data = []
        if (selectedRows.length > 0) {
            selectedRows.map(function(rowData) {
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
            var recurringPayList = component.get("v.SelectedRecords");
            if (recurringPayList == null) {
                helper.showToast('Please select atleast one Recurring Payment to Apply!', 'Error');
                return;
            }
            component.set('v.Spinner', true);
            helper.markAllPaymentsApply(component, event, recurringPayList);
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
                var recurringPayList = component.get("v.SelectedRecords");
                if (recurringPayList == null) {
                    component.set('v.isActive', false);
                    helper.showToast('Please select atleast one Email Pay to Apply!', 'Error');
                    return;
                }
                for (i = 0; i < maxcount; i++) {
                    recordlist.push(recurringPayList[i]);
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