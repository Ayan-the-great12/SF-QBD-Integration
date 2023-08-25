({
    doInit: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            component.set("v.DataColumns", [{
                    label: 'TYPE',
                    fieldName: 'objectName',
                    type: 'text',
                    sortable: true,
                    initialWidth: 225,
                    hideDefaultActions: true,
                },
                {
                    label: 'ACCOUNT/CONTACT NAME',
                    fieldName: 'CustomerName',
                    type: 'url',
                    sortable: true,
                    hideDefaultActions: true,
                    cellAttributes: {
                        alignment: 'left'
                    },
                    typeAttributes: {
                        label: {
                            fieldName: 'accName'
                        },
                        target: '_self',
                        tooltip: 'Click to visit account'
                    }
                },
                {
                    label: 'EMAIL',
                    fieldName: 'CustomerEmailAddress',
                    type: 'text',
                    sortable: true,
                    hideDefaultActions: true,
                    cellAttributes: {
                        alignment: 'left'
                    }
                },
                {
                    label: 'DATE & TIME ADDED',
                    fieldName: 'PaymentRequestDateTime',
                    type: 'date',
                    typeAttributes: {
                        month: 'numeric',
                        day: 'numeric',
                        year: 'numeric',
                        hour: '2-digit',
                        minute: '2-digit',
                        second: '2-digit',
                        hour12: false
                    },
                    sortable: true,
                    hideDefaultActions: true,
                    cellAttributes: {
                        alignment: 'left'
                    }
                },
                {
                    label: 'ADDED PAYMENT METHOD',
                    fieldName: 'Last4',
                    type: 'text',
                    sortable: true,
                    hideDefaultActions: true,
                    cellAttributes: {
                        class: {
                            fieldName: 'cardClass'
                        },
                        alignment: 'center',
                    }
                },
            ]);
            helper.getReceivedPayments(component, event);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!!', 'Error');
        }
    },
    onPrev: function(component, event, helper) {
        component.set('v.SelectedreceivedPayList', []);
        component.set("v.ReceivedPayments", []);
        var AllReceivedPayments = component.get("v.receivedPayList");
        var currentIndex = component.get("v.currentIndex");
        var maxGridLimit = component.get("v.maxGridLimit");
        currentIndex = currentIndex - maxGridLimit - maxGridLimit;
        var currentPageNumber = component.get("v.currentPageNumber");
        var maxLimit = currentIndex + maxGridLimit;
        var accList = [];
        if (currentIndex >= 0) {
            currentPageNumber = currentPageNumber - 1;
            component.set("v.currentPageNumber", currentPageNumber);
        }
        for (var i = currentIndex; i < maxLimit; i++) {
            accList.push(AllReceivedPayments[i]);
        }
        component.set("v.ReceivedPayments", accList);
        component.set('v.disableNextBtn', false);
        component.set("v.currentIndex", maxLimit);
    },
    onNext: function(component, event, helper) {
        component.set("v.ReceivedPayments", []);
        var CurrentAccountsCount = component.get("v.CurrentAccountsCount");
        var maxGridLimit = component.get("v.maxGridLimit");
        if (CurrentAccountsCount >= maxGridLimit) {
            var AllReceivedPayments = component.get("v.receivedPayList");
            var endLimit = component.get("v.endLimit");
            var currentIndex = component.get("v.currentIndex");
            var currentPageNumber = component.get("v.currentPageNumber");
            var maxLimit = currentIndex + maxGridLimit;
            if (maxLimit > CurrentAccountsCount) {
                maxLimit = AllReceivedPayments.length;
            }
            var accList = [];
            if (currentIndex <= maxLimit) {
                currentPageNumber = currentPageNumber + 1;
                component.set("v.currentPageNumber", currentPageNumber);
            }
            for (var i = currentIndex; i < maxLimit; i++) {
                accList.push(AllReceivedPayments[i]);
            }
            component.set("v.ReceivedPayments", accList);
            currentIndex = currentIndex + maxGridLimit;
            component.set("v.currentIndex", currentIndex);
            if (maxLimit == CurrentAccountsCount) {
                component.set('v.disableNextBtn', true);
            }
        } else {
            component.set('v.disableNextBtn', true);
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
                if (timeDiffrence <= 0) {
                    component.set('v.disableFindBtn', true);
                    helper.showToast('From date should be less than to date!', 'Error');
                } else {
                    component.set('v.disableFindBtn', false);
                }
            } else {
                component.set('v.disableFindBtn', false);
            }
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    applyPayments: function(component, event, helper) {
        try {
            var requestPayList = component.get("v.SelectedreceivedPayList");
            if (requestPayList == null) {
                helper.showToast('Please select atleast one Email Pay to Apply!', 'Error');
                return;
            }
            component.set('v.Spinner', true);
            helper.markAllPaymentsApply(component, event, requestPayList);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    applyAddedPayments: function(component, event, helper) {
        try {
            var maxcount = component.get("v.MaxRecords");
                var recordlist = [];
                var i = 0;
                var requestPayList = component.get("v.SelectedreceivedPayList");
                if (requestPayList == null) {
                    component.set('v.isActive', false);
                    helper.showToast('Please select atleast one Email Pay to Apply!', 'Error');
                    return;
                }
                for (i = 0; i < maxcount; i++) {
                    recordlist.push(requestPayList[i]);
                }
                component.set('v.isActive', false);
                component.set("v.Spinner", true);
                helper.markAllPaymentsApply(component, event, recordlist);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    searchReceivedPayments: function(component, event, helper) {
        try {
            component.set("v.currentPageNumber", 1);
            component.set("v.currentIndex", 0);
            component.set("v.CurrentAccountsCount", 0);
            component.set("v.ReceivedPayments", []);
            component.set("v.receivedPayList", []);
            component.set('v.Spinner', true);
            helper.getReceivedPayments(component, event);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    searchAllReceivedPayments: function(component, event, helper) {
        try {
            component.set("v.currentPageNumber", 1);
            component.set("v.currentIndex", 0);
            component.set("v.CurrentAccountsCount", 0);
            component.set("v.ReceivedPayments", []);
            component.set("v.receivedPayList", []);
            component.set('v.Spinner', true);
            component.set('v.FromDate', null);
            component.set('v.ToDate', null);
            helper.getReceivedPayments(component, event);
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
            cmp.set('v.disableExportBtn', false);
            cmp.set('v.SelectedreceivedPayList', selectedRows);
            cmp.set('v.NoOfSelectedRecords', selectedRows.length);
            cmp.set('v.SelectT', selectedRows);
        } else {
            cmp.set('v.disableBtns', true);
            cmp.set('v.disableExportBtn', true);
            cmp.set('v.SelectedreceivedPayList', []);
            cmp.set('v.SelectT', []);
        }
        cmp.set('v.NoOfSelectedRecords', selectedRows.length);
    },
    handleSort: function(component, event, helper) {
        var sortBy = event.getParam("fieldName");
        var sortDirection = event.getParam("sortDirection");
        component.set("v.sortBy", sortBy);
        component.set("v.sortDirection", sortDirection);
        helper.sortData(component, sortBy, sortDirection);
    },
    handleExportcsv: function(component, event, helper) {
        try {
            var allTransactions = component.get("v.SelectT");
            var selectedTransactions = [];
            var exportAs = 'csv';
            if (exportAs == 'csv') {
                selectedTransactions = allTransactions;
                if (selectedTransactions.length > 0) {
                    var csv = helper.convertArrayOfObjectsToCSV(component, selectedTransactions);
                    if (csv == null) {
                        return;
                    }
                    var hiddenElement = document.createElement('a');
                    hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
                    hiddenElement.target = '_self';
                    hiddenElement.download = 'ExportData.csv';
                    document.body.appendChild(hiddenElement);
                    hiddenElement.click();
                } else {
                    helper.showToastMsg('Please select records to export', 'Error');
                }
            }
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    removeReceivedPayments: function(component, event, helper) {
        try {
            component.set("v.Spinner", true);
            helper.removeReceivedRecords(component, event);
            component.set('v.isOpen', false);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    searchTable: function(cmp, event, helper) {
        var maxGridLimit = cmp.get("v.maxGridLimit");
        var allRecords = cmp.get("v.allData");
        var searchFilter = event.getSource().get("v.value").toUpperCase();
        var tempArray = [];
        var i;
        for (i = 0; i < allRecords.length; i++) {
            if ((allRecords[i].accName && allRecords[i].accName.toUpperCase().indexOf(searchFilter) != -1) ||
                (allRecords[i].CustomerId && allRecords[i].CustomerId.toUpperCase().indexOf(searchFilter) != -1)) {
                tempArray.push(allRecords[i]);
            }
        }
        cmp.set("v.ReceivedPayments", tempArray);
        if (tempArray.length < maxGridLimit) {
            cmp.set('v.disableNextBtn', true);
        } else {
            cmp.set('v.disableNextBtn', false);
        }
    },
    removeRequests: function(component, event, helper) {
        component.set("v.isOpen", true);
    },
    closeModel: function(component, event, helper) {
        try {
            component.set("v.isOpen", false);
            component.set('v.isActive', false);
            component.set('v.Spinner', false);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    }
})