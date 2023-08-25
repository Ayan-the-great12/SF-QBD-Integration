({
    onPrev: function(component, event, helper) {
        var AllPayments = component.get("v.AllPayments");
        var currentIndex = component.get("v.currentIndex");
        var maxGridLimit = component.get("v.maxGridLimit");
        currentIndex = currentIndex - maxGridLimit - maxGridLimit;
        var currentPageNumber = component.get("v.currentPageNumber");
        var maxLimit = currentIndex + maxGridLimit;
        var paymentsList = [];
        if (currentIndex >= 0) {
            currentPageNumber = currentPageNumber - 1;
            component.set("v.currentPageNumber", currentPageNumber);
        }
        for (var i = currentIndex; i < maxLimit; i++) {
            paymentsList.push(AllPayments[i]);
        }
        component.set("v.Payments", paymentsList);
        component.set('v.disableNextBtn', false);
        component.set("v.currentIndex", maxLimit);
    },
    onNext: function(component, event, helper) {
        var downloadNext = component.get("v.downloadNext");
        var CurrentPaymentsCount = component.get("v.CurrentPaymentsCount");
        var maxGridLimit = component.get("v.maxGridLimit");
        if (CurrentPaymentsCount >= maxGridLimit) {
            var AllPayments = component.get("v.AllPayments");
            var currentIndex = component.get("v.currentIndex");
            var currentPageNumber = component.get("v.currentPageNumber");
            var maxLimit = currentIndex + maxGridLimit;
            if (maxLimit > CurrentPaymentsCount) {
                maxLimit = AllPayments.length;
            }
            var paymentsList = [];
            if (currentIndex <= maxLimit) {
                currentPageNumber = currentPageNumber + 1;
                component.set("v.currentPageNumber", currentPageNumber);
            }
            for (var i = currentIndex; i < maxLimit; i++) {
                paymentsList.push(AllPayments[i]);
            }
            if (paymentsList.length < maxGridLimit) {
                if (downloadNext == true) {
                    component.set('v.disableNextBtn', true);
                } else {
                    var searchBy = {};
                    searchBy.fromDate = component.get('v.FromDate');
                    searchBy.toDate = component.get('v.ToDate');
                    searchBy = JSON.stringify(searchBy);
                    component.set("v.Payments", []);
                    component.set('v.Spinner', true);
                    helper.findPaymentsNext(component, event, searchBy);
                }
            }
            component.set("v.Payments", paymentsList);
            currentIndex = currentIndex + maxGridLimit;
            component.set("v.currentIndex", currentIndex);
        }
    },
    handleActiveTab: function(component, event, helper) {
        try {
            var tab = event.getSource();
            tab = tab.get('v.id');
            component.set('v.activeTab', tab);
            component.set("v.DataColumns", [{
                    label: 'Order #',
                    fieldName: 'OrderNumber',
                    type: 'text',
                    sortable: true,
                },
                {
                    label: 'Ref #',
                    fieldName: 'RefNumber',
                    type: 'text',
                    sortable: true,
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
                    label: 'Account Name',
                    fieldName: 'AccountName',
                    type: 'text',
                    sortable: true,
                },
                {
                    label: 'Date Paid',
                    fieldName: 'FormatedTransDate',
                    type: 'date',
                    typeAttributes: {
                        day: 'numeric',
                        month: 'short',
                        year: 'numeric'
                    },
                    sortable: true,
                    cellAttributes: {
                        iconName: 'utility:date_input',
                        iconPosition: 'left'
                    }
                },
                {
                    label: 'Amount Paid',
                    fieldName: 'AuthAmount',
                    sortable: false,
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
                        iconPosition: 'left',
                        class: {
                            fieldName: 'count'
                        }
                    }
                },
                {
                    label: 'Payment Method',
                    fieldName: 'card',
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
                    label: 'Source',
                    fieldName: 'Source',
                    type: 'text',
                    sortable: true,
                },
            ]);
            component.set("v.DataColumnsLogs", [{
                    label: 'Order #',
                    fieldName: 'ordNumber',
                    type: 'text',
                    sortable: true,
                },
                {
                    label: 'Ref #',
                    fieldName: 'RefNum',
                    type: 'text',
                    sortable: true,
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
                    label: 'Account Name',
                    fieldName: 'accName',
                    type: 'text',
                    sortable: true,
                },
                {
                    label: 'Date Paid',
                    fieldName: 'DatePaid',
                    type: 'date',
                    typeAttributes: {
                        day: 'numeric',
                        month: 'short',
                        year: 'numeric',
                        hour: '2-digit',
                        minute: '2-digit',
                        second: '2-digit',
                        hour12: false,
                    },
                    sortable: true,
                    cellAttributes: {
                        iconName: 'utility:date_input',
                        iconPosition: 'left'
                    }
                },
                {
                    label: 'Amount Paid',
                    fieldName: 'PaidAmount',
                    sortable: false,
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
                        iconPosition: 'left',
                        class: {
                            fieldName: 'count'
                        }
                    }
                },
                {
                    label: 'Payment Method',
                    fieldName: 'PaymentMethod',
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
                    label: 'Source',
                    fieldName: 'Source',
                    type: 'text',
                    sortable: true,
                },
                {
                    label: 'Import Status',
                    fieldName: 'status',
                    type: 'text',
                    sortable: true,
                    cellAttributes: {
                        iconName: {
                            fieldName: 'provenanceIconNameDownload'
                        },
                        iconLabel: {
                            fieldName: 'provenanceIconNameDownloads'
                        },
                        iconPosition: 'left'
                    }
                },
            ]);
            if (tab == 'log') {
                component.set('v.disableDownloadBtn', true);
                component.set('v.disableExportBtn', false);
                component.set('v.Spinner', true);
                helper.getLog(component, event);
            } else {
                if (component.get('v.disableImportBtn')) {
                    component.set('v.disableExportBtn', true);
                } else {
                    component.set('v.disableExportBtn', false);
                }
                var ReceivedPaymentsDownloaded = component.get("v.ReceivedPaymentsDownloaded");
                if (ReceivedPaymentsDownloaded == false) {
                    component.set('v.disableDownloadBtn', false);
                }
            }
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    getPayments: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            component.set('v.downloadNext', true);
            component.set("v.currentIndex", 0);
            component.set("v.CurrentPaymentsCount", 0);
            component.set("v.AllPayments", []);
            helper.getPayments(component, event);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    exportPayments: function(component, event, helper) {
        try {
            var stockData = component.get("v.selectedPayments");
            if (stockData.length > 0) {
                var csv = helper.convertPaymentsToCSV(component, stockData);
                if (csv == null) {
                    return;
                }
                var hiddenElement = document.createElement('a');
                hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
                hiddenElement.target = '_self';
                hiddenElement.download = 'Payments.csv';
                document.body.appendChild(hiddenElement);
                hiddenElement.click();
            } else {
                helper.showToastMsg('Please select records to export', 'Error');
            }
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    SelectAllPayments: function(component, event, helper) {
        try {
            var checkvalue = event.getSource().get("v.value");
            component.set('v.isSelectAll', checkvalue);
            var checkPayment = component.find("checkPayment");
            if (checkvalue == true) {
                for (var i = 0; i < checkPayment.length; i++) {
                    checkPayment[i].set("v.value", true);
                }
            } else {
                for (var i = 0; i < checkPayment.length; i++) {
                    checkPayment[i].set("v.value", false);
                }
            }
            var a = component.get('c.SelectSinglePayment');
            $A.enqueueAction(a);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    SelectSinglePayment: function(component, event, helper) {
        try {
            var paymentsList = component.get('v.Payments');
            var selectedPayments = [];
            var k = 0;
            for (var i = 0; i < paymentsList.length; i++) {
                var s = paymentsList[i];
                if (s.isSelected) {
                    selectedPayments[k] = s;
                    k++;
                }
            }
            component.set('v.NoOfSelectedRecords', k);
            if (selectedPayments.length > 0) {
                component.set('v.disableImportBtn', false);
                component.set('v.disableExportBtn', false);
                component.set('v.selectedPayments', selectedPayments);
            } else {
                component.set('v.disableImportBtn', true);
                component.set('v.disableExportBtn', true);
            }
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    ImportPayments: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            helper.importPayments(component, event);
            component.set("v.isOpen", false);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again........!', 'Error');
        }
    },
    clearLog: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            component.set("v.isOpen", false);
            helper.clearLog(component, event);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    openModel: function(component, event, helper) {
        try {
            var whichOne = event.getSource().getLocalId();
            if (whichOne == 'Import') {
                component.set('v.modalTitle', 'Import Received Payments');
                component.set('v.modalContent', whichOne);
            } else {
                component.set('v.modalTitle', 'Clear Download Log');
                component.set('v.modalContent', whichOne);
            }
            component.set("v.isOpen", true);
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
    handleSortlog: function(component, event, helper) {
        var sortBy = event.getParam("fieldName");
        var sortDirection = event.getParam("sortDirection");
        component.set("v.sortBy", sortBy);
        component.set("v.sortDirection", sortDirection);
        helper.sortDatalogs(component, sortBy, sortDirection);
    },
    updateSelectedText: function(cmp, event) {
        var selectedRows = event.getParam('selectedRows');
        if (selectedRows.length > 0) {
            cmp.set('v.disableImportBtn', false);
            cmp.set('v.disableExportBtn', false);
            cmp.set('v.selectedPayments', selectedRows);
        } else {
            cmp.set('v.disableImportBtn', true);
            cmp.set('v.disableExportBtn', true);
        }
        cmp.set('v.NoOfSelectedRecords', selectedRows.length);
    },
    validateForm: function(component, event, helper) {
        try {
            var FromDate = component.get('v.FromDate');
            var ToDate = component.get('v.ToDate');
            if (!$A.util.isEmpty(FromDate) && !$A.util.isEmpty(ToDate)) {
                var fDate = new Date(FromDate);
                var tDate = new Date(ToDate);
                var timeDiffrence = tDate - fDate;
                if (timeDiffrence <= 0) {
                    component.set('v.disableFindBtn', true);
                    helper.showToast('From date should be less than To date!', 'Error');
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
    ClearDateRange: function(component, event, helper) {
        try {
            component.set('v.FromDate', null);
            component.set('v.ToDate', null);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    findPayments: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            component.set('v.downloadNext', false);
            var searchBy = {};
            searchBy.fromDate = component.get('v.FromDate');
            searchBy.toDate = component.get('v.ToDate');
            searchBy = JSON.stringify(searchBy);
            component.set("v.currentIndex", 0);
            component.set("v.startLimit", 0);
            component.set("v.CurrentPaymentsCount", 0);
            component.set("v.AllPayments", []);
            helper.findPayments(component, event, searchBy);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    closeModel: function(component, event, helper) {
        try {
            component.set("v.isOpen", false);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
})