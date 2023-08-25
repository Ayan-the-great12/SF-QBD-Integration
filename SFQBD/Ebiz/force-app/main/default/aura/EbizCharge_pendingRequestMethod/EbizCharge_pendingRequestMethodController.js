({
    doInit: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            component.set("v.DataColumns", [{
                    label: 'TYPE',
                    fieldName: 'objectName',
                    type: 'text',
                    initialWidth: 225,
                    sortable: true,
                    hideDefaultActions: true,
                },
                {
                    label: 'ACCOUNT/CONTACT NAME',
                    fieldName: 'CustomerName',
                    type: 'url',
                    sortable: true,
                    hideDefaultActions: true,
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
                },
                {
                    label: 'ORIG. DATE & TIME SENT',
                    fieldName: 'PaymentRequestDateTime',
                    type: 'date',
                    typeAttributes: {
                        day: 'numeric',
                        month: 'numeric',
                        year: 'numeric',
                        hour: '2-digit',
                        minute: '2-digit',
                        second: '2-digit',
                        hour12: false,
                    },
                    sortable: true,
                    hideDefaultActions: true,
                },
                {
                    label: '# OF TIMES SENT',
                    fieldName: 'ResendCount',
                    type: 'numeric',
                    sortable: true,
                    hideDefaultActions: true,
                },
            ]);
            helper.searchPending(component, event);
        } catch (e) {}
    },
    onPrev: function(component, event, helper) {
        component.set("v.PendingPayments", []);
        var AllPendingPayments = component.get("v.pendingPayList");
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
            accList.push(AllPendingPayments[i]);
        }
        component.set("v.PendingPayments", accList);
        component.set('v.disableNextBtn', false);
        component.set("v.currentIndex", maxLimit);
    },
    onNext: function(component, event, helper) {
        component.set("v.PendingPayments", []);
        var CurrentAccountsCount = component.get("v.CurrentAccountsCount");
        var maxGridLimit = component.get("v.maxGridLimit");
        if (CurrentAccountsCount >= maxGridLimit) {
            var AllAccounts = component.get("v.pendingPayList");
            var endLimit = component.get("v.endLimit");
            var currentIndex = component.get("v.currentIndex");
            var currentPageNumber = component.get("v.currentPageNumber");
            var maxLimit = currentIndex + maxGridLimit;
            if (maxLimit > CurrentAccountsCount) {
                maxLimit = AllAccounts.length;
            }
            var accList = [];
            if (currentIndex <= maxLimit) {
                currentPageNumber = currentPageNumber + 1;
                component.set("v.currentPageNumber", currentPageNumber);
            }
            for (var i = currentIndex; i < maxLimit; i++) {
                accList.push(AllAccounts[i]);
            }
            component.set("v.PendingPayments", accList);
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
    searchPendingPayments: function(component, event, helper) {
        try {
            component.set("v.currentPageNumber", 1);
            component.set("v.currentIndex", 0);
            component.set("v.CurrentAccountsCount", 0);
            component.set("v.PendingPayments", []);
            component.set("v.pendingPayList", []);
            component.set('v.Spinner', true);
            helper.searchPending(component, event);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    searchAllPendingPayments: function(component, event, helper) {
        try {
            component.set("v.currentPageNumber", 1);
            component.set("v.currentIndex", 0);
            component.set("v.CurrentAccountsCount", 0);
            component.set("v.PendingPayments", []);
            component.set("v.pendingPayList", []);
            component.set('v.Spinner', true);
            component.set('v.FromDate', null);
            component.set('v.ToDate', null);
            helper.searchPending(component, event);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
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
    handleSort: function(component, event, helper) {
        var sortBy = event.getParam("fieldName");
        var sortDirection = event.getParam("sortDirection");
        component.set("v.sortBy", sortBy);
        component.set("v.sortDirection", sortDirection);
        helper.sortData(component, sortBy, sortDirection);
    },
    updateSelectedText: function(component, event) {
        var selectedRows = event.getParam('selectedRows');
        var dataList = selectedRows.map(function(rowData) {
            rowData.isSelected = true;
            return rowData;
        });
        if (selectedRows.length > 0) {
            component.set('v.disableBtns', false);
            component.set('v.disableExportBtn', false);
            component.set('v.SelectedpendingPayList', selectedRows);
            component.set('v.SelectT', selectedRows);
            component.set('v.disablesendReqBtn', false);
        } else {
            component.set('v.disableBtns', true);
            component.set('v.disableExportBtn', true);
            component.set('v.SelectedpendingPayList', []);
            component.set('v.disablesendReqBtn', true);
            component.set('v.SelectT', []);
            component.set('v.NoOfSelectedRecords', 0);
        }
        component.set('v.NoOfSelectedRecords', selectedRows.length);
    },
    searchTable: function(component, event, helper) {
        var maxGridLimit = component.get("v.maxGridLimit");
        var allRecords = component.get("v.allData");
        var searchFilter = event.getSource().get("v.value").toUpperCase();
        var tempArray = [];
        var i;
        for (i = 0; i < allRecords.length; i++) {
            if ((allRecords[i].accName && allRecords[i].accName.toUpperCase().indexOf(searchFilter) != -1) ||
                (allRecords[i].CustomerId && allRecords[i].CustomerId.toUpperCase().indexOf(searchFilter) != -1)) {
                tempArray.push(allRecords[i]);
            }
        }
        component.set("v.PendingPayments", tempArray);
        if (tempArray.length < maxGridLimit) {
            component.set('v.disableNextBtn', true);
        } else {
            component.set('v.disableNextBtn', false);
        }
    },
    resendRequest: function(component, event, helper) {
        try {
            component.set("v.Spinner", true);
            helper.SendRequestsNow(component, event);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    removehPendingPayments: function(component, event, helper) {
        try {
            component.set("v.Spinner", true);
            helper.removePendingRecords(component, event);
            component.set('v.isOpen', false);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    removeRequests: function(component, event, helper) {
        component.set("v.isOpen", true);
    },
    closeModel: function(component, event, helper) {
        try {
            component.set("v.isOpen", false);
            component.set('v.Spinner', false);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    }
})