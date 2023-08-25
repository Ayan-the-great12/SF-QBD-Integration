({
    doInit: function(component, event, helper) {
        try {
            component.set('v.Spinner', false);
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
                    fieldName: 'HyperUrlAccount',
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
                    label: 'DATE CREATED',
                    fieldName: 'dateCreated',
                    type: 'date',
                    typeAttributes: {
                        day: 'numeric',
                        month: 'numeric',
                        year: 'numeric'
                    },
                    sortable: true,
                    hideDefaultActions: true,
                },
                {
                    label: 'EMAIL',
                    fieldName: 'accEmail',
                    type: 'Text',
                    sortable: true,
                    hideDefaultActions: true,
                    editable: true,
                },
                {
                    label: 'PAYMENT METHODS',
                    fieldName: 'paymentmethodurl',
                    type: 'button',
                    hideDefaultActions: true,
                    typeAttributes: {
                        variant: 'base',
                        label: 'View Payment Method',
                        title: 'View Payment Method',
                        name: 'view_PM'
                    }
                },
            ]);
            component.set('v.Spinner', true);
            helper.getDataCount(component, event);
            helper.AllAccounts(component, event);
        } catch (e) {}
    },
    handleSaveEdition: function(cmp, event, helper) {
        var draftValues = event.getParam('draftValues');
        var Payments = cmp.get("v.Payments");
        for (var i = 0; i < draftValues.length; i++) {
            var index = draftValues[i].Id.split('-')[1];
            Payments[index].accEmail = draftValues[i].accEmail;
        }
        cmp.set('v.Payments', Payments);
        cmp.find("SendRequestPayment").set("v.draftValues", null);
        helper.showToast('Email is successfully updated!', 'Success');
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
                    helper.showToastMsg('From date must be less than to date!', 'Error');
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
    onPrev: function(component, event, helper) {
        var AllAccounts = component.get("v.SendRequestPayment");
        component.set("v.Payments", []);
        component.set('v.SelectedRecords', []);
        var currentIndex = component.get("v.currentIndex");
        var maxGridLimit = component.get("v.maxGridLimit");
        if(currentIndex % maxGridLimit != 0)
        {
            var remainingRecordsCount = currentIndex % maxGridLimit;
            remainingRecordsCount = maxGridLimit - remainingRecordsCount;
            currentIndex = currentIndex + remainingRecordsCount;
        }
        currentIndex = currentIndex - maxGridLimit - maxGridLimit;
        var currentPageNumber = component.get("v.currentPageNumber");
        var maxLimit = currentIndex + maxGridLimit;
        var accList = [];
        if (currentIndex >= 0) {
            currentPageNumber = currentPageNumber - 1;
            component.set("v.currentPageNumber", currentPageNumber);
        }
        for (var i = currentIndex; i < maxLimit; i++) {
            accList.push(AllAccounts[i]);
        }
        component.set("v.Payments", accList);
        component.set('v.disableNextBtn', false);
        component.set("v.currentIndex", maxLimit);
    },
    onNext: function(component, event, helper) {
        component.set('v.Spinner', true);
        component.set("v.Payments", []);
        component.set('v.SelectT', []);
        component.set('v.SelectedRecords', []);
        var allDataFetched = component.get("v.allDataFetched");
        var CurrentAccountsCount = component.get("v.CurrentAccountsCount");
        var maxGridLimit = component.get("v.maxGridLimit");
        if (CurrentAccountsCount >= maxGridLimit) {
            var AllAccounts = component.get("v.SendRequestPayment");
            var endLimit = component.get("v.endLimit");
            var currentIndex = component.get("v.currentIndex");
            var currentPageNumber = component.get("v.currentPageNumber");
            var maxLimit = currentIndex + maxGridLimit;
            if (maxLimit > CurrentAccountsCount || maxLimit > AllAccounts.length) {
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
            component.set("v.Payments", accList);
            currentIndex = currentIndex + maxGridLimit;
            component.set('v.Spinner', false);
            if(currentIndex > AllAccounts.length && allDataFetched == false)
            {
                currentIndex = AllAccounts.length;
                component.set('v.Spinner', true);
                component.set("v.currentIndex", currentIndex);
                helper.LoadNextData(component, event);
            }
            if(currentIndex % component.get("v.dbCallLimit") == 0 && allDataFetched == false)
            {
                component.set('v.Spinner', true);
                helper.LoadNextData(component, event);
            }
            component.set("v.currentIndex", currentIndex);
            if (maxLimit == component.get("v.CurrentAccountsCount")) {
                component.set('v.disableNextBtn', true);
            }
        } else {
            component.set('v.disableNextBtn', true);
        }
    },
    handleSearch: function(component, event, helper) {
        component.set("v.currentPageNumber", 1);
        component.set("v.allDataFetched", false);
        component.set("v.currentIndex", 0);
        component.set("v.CurrentAccountsCount", 0);
        component.set("v.SendRequestPayment", []);
        component.set('v.Spinner', true);
        helper.getDataCount(component, event);
        helper.AllAccounts(component, event);
    },
    searchAllAccounts: function(component, event, helper) {
        try {
            component.set("v.currentPageNumber", 1);
            component.set("v.allDataFetched", false);
            component.set("v.currentIndex", 0);
            component.set("v.CurrentAccountsCount", 0);
            component.set("v.SendRequestPayment", []);
            component.set('v.Spinner', true);
            component.set('v.FromDate', null);
            component.set('v.ToDate', null);
            helper.getDataCount(component, event);
            helper.AllAccounts(component, event);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    searchTable: function(component, event, helper) {
        var maxGridLimit = component.get("v.maxGridLimit");
        var allRecords = component.get("v.SendRequestPayment");
        var searchFilter = event.getSource().get("v.value").toUpperCase();
        var tempArray = [];
        var i;
        for (i = 0; i < allRecords.length; i++) {
            if ((allRecords[i].accName && allRecords[i].accName.toUpperCase().indexOf(searchFilter) != -1)) {
                tempArray.push(allRecords[i]);
            }
        }
        component.set("v.Payments", tempArray);
        if (tempArray.length < maxGridLimit) {
            component.set('v.disableNextBtn', true);
        } else {
            component.set('v.disableNextBtn', false);
        }
    },
    handleSort: function(component, event, helper) {
        var sortBy = event.getParam("fieldName");
        var sortDirection = event.getParam("sortDirection");
        component.set("v.sortBy", sortBy);
        component.set("v.sortDirection", sortDirection);
        helper.sortData(component, sortBy, sortDirection);
    },
    updateSelectedText: function(cmp, event, helper) {
        var selectedRows = event.getParam('selectedRows');
        var showWarning = false;
        var data = []
        if (selectedRows.length > 0) {
            selectedRows.map(function(rowData) {
                if (rowData.accEmail != null && rowData.accEmail != '') {
                    data.push(rowData);
                } else {
                    showWarning = true;
                }
            });
            cmp.set('v.recordWithNoEmail', showWarning);
            cmp.set('v.NoOfRequestSend', data.length);
            if (data.length > 0) {
                cmp.set('v.disableSubmitBtn', false);
            } else {
                cmp.set('v.disableSubmitBtn', true);
            }
            cmp.set('v.disableExportBtn', false);
            cmp.set('v.SelectT', selectedRows);
            cmp.set('v.SelectedRecords', data);
        } else {
            cmp.set('v.selectedRowsCount', 0);
            cmp.set('v.SelectedRecords', []);
            cmp.set('v.disableExportBtn', true);
            cmp.set('v.disableSubmitBtn', true);
        }
        cmp.set('v.NoOfSelectedRecords', selectedRows.length);
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
    sendRequest: function(component, event, helper) {
        try {
            var selectRecord = component.get("v.SelectedRecords");
            var NoOfSelectedRecords = component.get("v.NoOfSelectedRecords");
            if (selectRecord == null) {
                helper.showToast('Please select atleast one Account to send Payment Request!', 'Error');
                return;
            }
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
        component.set('v.showpopup', true);
    },
    handleSelectAction: function(component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        component.set('v.Spinner', true);
        var Type = row.objectName;
        component.set('v.AccountName', row.accName);
        component.set('v.Spinner', true);
        helper.getPaymentMethods(component, event, row.accId, Type);
    },
    closeModel: function(component, event, helper) {
        try {
            component.set("v.isOpen", false);
            window.location.reload();
            $A.get('e.force:refreshView').fire();
            component.set('v.Spinner', false);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    }
})