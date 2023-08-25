({
    onPrev: function(component, event, helper) {
        var AllOrders = component.get("v.AllOrders");
        var currentIndex = component.get("v.currentIndex");
        var maxGridLimit = component.get("v.maxGridLimit");
        currentIndex = currentIndex - maxGridLimit - maxGridLimit;
        var currentPageNumber = component.get("v.currentPageNumber");
        var maxLimit = currentIndex + maxGridLimit;
        var ordList = [];
        if (currentIndex >= 0) {
            currentPageNumber = currentPageNumber - 1;
            component.set("v.currentPageNumber", currentPageNumber);
        }
        for (var i = currentIndex; i < maxLimit; i++) {
            ordList.push(AllOrders[i]);
        }
        component.set("v.Orders", ordList);
        component.set('v.disableNextBtn', false);
        component.set("v.currentIndex", maxLimit);
    },
    onNext: function(component, event, helper) {
        var CurrentOrdersCount = component.get("v.CurrentOrdersCount");
        var maxGridLimit = component.get("v.maxGridLimit");
        if (CurrentOrdersCount >= maxGridLimit) {
            var AllOrders = component.get("v.AllOrders");
            var endLimit = component.get("v.endLimit");
            var currentIndex = component.get("v.currentIndex");
            var downloadNext = component.get("v.downloadNext");
            var currentPageNumber = component.get("v.currentPageNumber");
            var maxLimit = currentIndex + maxGridLimit;
            if (maxLimit > CurrentOrdersCount) {
                maxLimit = AllOrders.length;
            }
            var ordList = [];
            if (currentIndex <= maxLimit) {
                currentPageNumber = currentPageNumber + 1;
                component.set("v.currentPageNumber", currentPageNumber);
            }
            for (var i = currentIndex; i < maxLimit; i++) {
                ordList.push(AllOrders[i]);
            }
            if (ordList.length < maxGridLimit) {
                if (downloadNext == true) {
                    component.set('v.disableNextBtn', true);
                } else {
                    var searchBy = {};
                    searchBy.fromDate = component.get('v.FromDate');
                    searchBy.toDate = component.get('v.ToDate');
                    searchBy = JSON.stringify(searchBy);
                    component.set("v.Spinner", true);
                    component.set("v.Orders", []);
                    helper.getOrdersNext(component, event, searchBy);
                }
            }
            component.set("v.Orders", ordList);
            currentIndex = currentIndex + maxGridLimit;
            component.set("v.currentIndex", currentIndex);
        } else {
            component.set('v.disableNextBtn', true);
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
                },
                {
                    label: 'Account Name',
                    fieldName: 'accName',
                    type: 'text',
                },
                {
                    label: 'Email',
                    fieldName: 'accEmail',
                    type: 'text',
                    cellAttributes: {
                        iconName: {
                            fieldName: 'provenanceIconNameEmail'
                        },
                        iconLabel: {
                            fieldName: 'provenanceIconLabelEmail'
                        },
                        iconPosition: 'left'
                    }
                },
                {
                    label: 'Ref #',
                    fieldName: 'RefNumber',
                    type: 'text',
                },
                {
                    label: 'Type',
                    fieldName: 'TransType',
                    type: 'text',
                    cellAttributes: {
                        iconName: {
                            fieldName: 'provenanceIconLName'
                        },
                        iconLabel: {
                            fieldName: 'provenanceIconLabelLname'
                        },
                        iconPosition: 'left'
                    }
                },
                {
                    label: 'Payment Method',
                    fieldName: 'PaymentMethod',
                    type: 'text',
                    cellAttributes: {
                        alignment: 'right',
                        class: {
                            fieldName: 'CardClass'
                        }
                    }
                },
                {
                    label: 'Amount Paid',
                    fieldName: 'AmountPaid',
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
                    label: 'Order Total',
                    fieldName: 'TotalAmount',
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
                    label: 'Balance Due',
                    fieldName: 'AmountDue',
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
                    label: 'Source',
                    fieldName: 'Portal',
                    type: 'text',
                },
            ]);
            component.set("v.DataColumnsLogs", [{
                    label: 'Order #',
                    fieldName: 'ordNumber',
                    type: 'text',
                    sortable: true,
                },
                {
                    label: 'Account Name',
                    fieldName: 'accName',
                    type: 'text',
                    sortable: true,
                },
                {
                    label: 'Email',
                    fieldName: 'email',
                    type: 'text',
                    sortable: true,
                    cellAttributes: {
                        iconName: {
                            fieldName: 'provenanceIconNameEmail'
                        },
                        iconLabel: {
                            fieldName: 'provenanceIconLabelEmail'
                        },
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
                    label: 'Balance Due',
                    fieldName: 'balance',
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
                }, {
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
                component.set('v.Spinner', false);
                helper.getLog(component, event);
            } else {
                if (component.get('v.disableImportBtn')) {
                    component.set('v.disableExportBtn', true);
                } else {
                    component.set('v.disableExportBtn', false);
                }
                var OrdersDownloaded = component.get("v.OrdersDownloaded");
                if (OrdersDownloaded == false) {
                    component.set('v.disableDownloadBtn', false);
                }
            }
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    getOrders: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            var searchBy = {};
            searchBy.fromDate = component.get('v.FromDate');
            searchBy.toDate = component.get('v.ToDate');
            searchBy = JSON.stringify(searchBy);
            component.set("v.currentIndex", 0);
            component.set("v.startLimit", 0);
            component.set("v.CurrentOrdersCount", 0);
            component.set("v.AllOrders", []);
            component.set("v.downloadNext", false);
            helper.getOrders(component, event, searchBy);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    downloadOrder: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            component.set("v.currentIndex", 0);
            component.set("v.CurrentOrdersCount", 0);
            component.set("v.AllOrders", []);
            component.set("v.downloadNext", true);
            helper.downloadOrders(component, event, '');
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
    SelectAllOrders: function(component, event, helper) {
        try {
            var checkvalue = event.getSource().get("v.value");
            component.set('v.isSelectAll', checkvalue);
            var checkOrder = component.find("checkOrder");
            if (checkvalue == true) {
                for (var i = 0; i < checkOrder.length; i++) {
                    checkOrder[i].set("v.value", true);
                }
            } else {
                for (var i = 0; i < checkOrder.length; i++) {
                    checkOrder[i].set("v.value", false);
                }
            }
            var a = component.get('c.SelectSingleOrder');
            $A.enqueueAction(a);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    SelectSingleOrder: function(component, event, helper) {
        try {
            var ordersList = component.get('v.Orders');
            var selectedOrders = [];
            var k = 0;
            for (var i = 0; i < ordersList.length; i++) {
                var s = ordersList[i];
                if (s.isSelected) {
                    selectedOrders[k] = s.Id;
                    k++;
                }
            }
            component.set('v.NoOfSelectedRecords', k);
            if (selectedOrders.length > 0) {
                component.set('v.disableImportBtn', false);
                component.set('v.disableExportBtn', false);
                component.set('v.selectedOrders', selectedOrders);
            } else {
                component.set('v.disableImportBtn', true);
                component.set('v.disableExportBtn', true);
            }
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
    handleSortlog: function(component, event, helper) {
        var sortBy = event.getParam("fieldName");
        var sortDirection = event.getParam("sortDirection");
        component.set("v.sortBy", sortBy);
        component.set("v.sortDirection", sortDirection);
        helper.sortDatalogs(component, sortBy, sortDirection);
    },
    updateSelectedText: function(cmp, event, helper) {
        var selectedRows = event.getParam('selectedRows');
        var selectedData = [];
        for (var i = 0; i < selectedRows.length; i++) {
            if (selectedRows[i].hasOwnProperty('OrderNumber')) {
                selectedData.push(selectedRows[i]);
            } else {
                helper.showToast('Only select orders to import / export', 'Warning');
            }
        }
        if (selectedData.length > 0) {
            cmp.set('v.disableImportBtn', false);
            cmp.set('v.disableExportBtn', false);
            cmp.set('v.selectedOrders', selectedData);
        } else {
            cmp.set('v.disableImportBtn', true);
            cmp.set('v.disableExportBtn', true);
        }
        cmp.set('v.NoOfSelectedRecords', selectedData.length);
    },
    ImportOrders: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            component.set("v.isOpen", false);
            helper.importOrders(component, event);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    exportOrders: function(component, event, helper) {
        try {
            var tabName = component.get('v.activeTab');
            if (tabName == 'list') {
                var stockData = component.get("v.selectedOrders");
                if (stockData.length > 0) {
                    var csv = helper.convertOrdersToCSV(component, stockData);
                    if (csv == null) {
                        return;
                    }
                    var hiddenElement = document.createElement('a');
                    hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
                    hiddenElement.target = '_self';
                    hiddenElement.download = 'Orders.csv';
                    document.body.appendChild(hiddenElement);
                    hiddenElement.click();
                } else {
                    helper.showToast('Please select records to export', 'Error');
                }
            } else {
                var stockData = component.get("v.orderLog");
                if (stockData != null) {
                    var csv = helper.convertOrdersToCSV(component, stockData);
                    if (csv == null) {
                        return;
                    }
                    var hiddenElement = document.createElement('a');
                    hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
                    hiddenElement.target = '_self';
                    hiddenElement.download = 'OrdersLog.csv';
                    document.body.appendChild(hiddenElement);
                    hiddenElement.click();
                } else {
                    helper.showToast('No records to export', 'Error');
                }
            }
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    clearLog: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            component.set("v.isOpen", false);
            helper.clearLog(component, event);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    openModel: function(component, event, helper) {
        try {
            var whichOne = event.getSource().getLocalId();
            if (whichOne == 'Import') {
                component.set('v.modalTitle', 'Import Orders');
                component.set('v.modalContent', whichOne);
            } else {
                component.set('v.modalTitle', 'Clear Download Log');
                component.set('v.modalContent', whichOne);
            }
            component.set("v.isOpen", true);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    closeModel: function(component, event, helper) {
        try {
            component.set("v.isOpen", false);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
})