({
    onPageSizeChange: function(component, event, helper) {},
    onFirst: function(component, event, helper) {},
    onPrev: function(component, event, helper) {
        var allAccounts = component.get("v.AllAccounts");
        var currentIndex = component.get("v.currentIndex");
        var maxGridLimit = component.get("v.maxGridLimit");
        currentIndex = currentIndex - maxGridLimit - maxGridLimit;
        var currentPageNumber = component.get("v.currentPageNumber");
        var TotalAccountsCount = component.get("v.TotalAccountsCount");
        var maxLimit = currentIndex + maxGridLimit;
        var accList = [];
        if (currentIndex >= 0) {
            currentPageNumber = currentPageNumber - 1;
            if (currentPageNumber == 1) {
                component.set('v.disableNextBtn', false);
            }
            component.set("v.currentPageNumber", currentPageNumber);
        }
        for (var i = currentIndex; i < maxLimit; i++) {
            accList.push(allAccounts[i]);
        }
        component.set("v.Accounts", accList);
        component.set('v.disableNextBtn', false);
        component.set("v.currentIndex", maxLimit);
    },
    onNext: function(component, event, helper) {
        var CurrentAccountsCount = component.get("v.CurrentAccountsCount");
        var maxGridLimit = component.get("v.maxGridLimit");
        var downloadNext = component.get("v.downloadNext");
        if (CurrentAccountsCount >= maxGridLimit) {
            var allAccounts = component.get("v.AllAccounts");
            var currentIndex = component.get("v.currentIndex");
            var currentPageNumber = component.get("v.currentPageNumber");
            var TotalAccountsCount = component.get("v.TotalAccountsCount");
            var maxLimit = currentIndex + maxGridLimit;
            if (maxLimit > CurrentAccountsCount) {
                maxLimit = allAccounts.length;
            }
            var accList = [];
            if (currentIndex != maxLimit) {
                currentPageNumber = currentPageNumber + 1;
                component.set("v.currentPageNumber", currentPageNumber);
            }
            for (var i = currentIndex; i < maxLimit; i++) {
                accList.push(allAccounts[i]);
            }
            if (accList.length < maxGridLimit) {
                if (downloadNext == true) {
                    component.set('v.disableNextBtn', true);
                } else {
                    component.set('v.Spinner', true);
                    var searchBy = {};
                    searchBy.fromDate = component.get('v.FromDate');
                    if (searchBy.fromDate == null) {
                        var settings = component.get('v.CS');
                        if (settings.Ebiz_C__EBizcharge_Last_Import_Date__c != null) {
                            searchBy.fromDate = settings.Ebiz_C__EBizcharge_Last_Import_Date__c;
                        }
                    }
                    searchBy.toDate = component.get('v.ToDate');
                    searchBy = JSON.stringify(searchBy);
                    helper.getAccountsNext(component, event, searchBy);
                }
            }
            component.set("v.Accounts", accList);
            currentIndex = currentIndex + maxGridLimit;
            component.set("v.currentIndex", currentIndex);
        } else {
            component.set('v.disableNextBtn', true);
        }
    },
    onLast: function(component, event, helper) {},
    handleActiveTab: function(component, event, helper) {
        try {
            var tab = event.getSource();
            tab = tab.get('v.id');
            component.set('v.activeTab', tab);
            component.set("v.DataColumns", [{
                    label: 'Account Name',
                    fieldName: 'accName',
                    type: 'text',
                    sortable: true,
                },
                {
                    label: 'First Name',
                    fieldName: 'accFirstName',
                    type: 'text',
                    sortable: true,
                },
                {
                    label: 'Last Name',
                    fieldName: 'accLastName',
                    type: 'text',
                    sortable: true,
                },
                {
                    label: 'Account Email',
                    fieldName: 'accEmail',
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
                    label: 'Phone',
                    fieldName: 'accPhone',
                    type: 'text',
                    sortable: true,
                    cellAttributes: {
                        iconName: {
                            fieldName: 'provenanceIconNamePhone'
                        },
                        iconLabel: {
                            fieldName: 'provenanceIconLabelPhone'
                        },
                        iconPosition: 'left'
                    }
                },
                {
                    label: 'Source',
                    initialWidth: 180,
                    fieldName: 'accSource',
                    type: 'text',
                    sortable: true,
                    cellAttributes: {
                        alignment: 'center',
                        iconName: {
                            fieldName: 'provenanceIconNameImported'
                        },
                        iconPosition: 'right'
                    }
                },
                {
                    label: 'Date Created',
                    fieldName: 'accDateTimeCreated',
                    type: 'date',
                    sortable: true,
                    cellAttributes: {
                        iconName: 'utility:event',
                        iconPosition: 'left'
                    }
                },
                {
                    label: 'Date Modified',
                    fieldName: 'accDateTimeModified',
                    type: 'date',
                    sortable: true,
                    cellAttributes: {
                        iconName: 'utility:event',
                        iconPosition: 'left'
                    }
                },
            ]);
            component.set("v.DataColumnsLogs", [{
                    label: 'Account Name',
                    fieldName: 'accName',
                    type: 'text',
                    sortable: true,
                },
                {
                    label: 'First Name',
                    fieldName: 'firstName',
                    type: 'text',
                    sortable: true,
                },
                {
                    label: 'Last Name',
                    fieldName: 'lastName',
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
                    label: 'Phone #',
                    fieldName: 'Phone',
                    type: 'text',
                    sortable: true,
                    cellAttributes: {
                        iconName: {
                            fieldName: 'provenanceIconNamePhone'
                        },
                        iconLabel: {
                            fieldName: 'provenanceIconLabelPhone'
                        },
                        iconPosition: 'left'
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
                helper.getAccountsCount(component, event);
                if (component.get('v.disableImportBtn')) {
                    component.set('v.disableExportBtn', true);
                } else {
                    component.set('v.disableExportBtn', false);
                }
                var AccountsDownloaded = component.get("v.AccountsDownloaded");
                if (AccountsDownloaded == false) {
                    component.set('v.disableDownloadBtn', false);
                }
            }
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    getAccounts: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            var searchBy = {};
            searchBy.fromDate = component.get('v.FromDate');
            if (searchBy.fromDate == null) {
                var settings = component.get('v.CS');
                if (settings.Ebiz_C__EBizcharge_Last_Import_Date__c != null) {
                    searchBy.fromDate = settings.Ebiz_C__EBizcharge_Last_Import_Date__c;
                }
            }
            searchBy.toDate = component.get('v.ToDate');
            searchBy = JSON.stringify(searchBy);
            component.set("v.currentIndex", 0);
            component.set("v.downloadNext", false);
            component.set("v.startLimit", 0);
            component.set("v.CurrentAccountsCount", 0);
            component.set("v.AllAccounts", []);
            helper.getAccounts(component, event, searchBy);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    DownloadAccounts: function(component, event, helper) {
        try {
            component.set("v.Spinner", true);
            component.set("v.currentIndex", 0);
            component.set("v.CurrentAccountsCount", 0);
            component.set("v.downloadNext", true);
            component.set("v.AllAccounts", []);
            helper.DownloadAccounts(component, event);
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
    SelectAllAccounts: function(component, event, helper) {
        try {
            var checkvalue = event.getSource().get("v.value");
            component.set('v.isSelectAll', checkvalue);
            var checkAccount = component.find("checkAccount");
            if (checkvalue == true) {
                for (var i = 0; i < checkAccount.length; i++) {
                    checkAccount[i].set("v.value", true);
                }
            } else {
                for (var i = 0; i < checkAccount.length; i++) {
                    checkAccount[i].set("v.value", false);
                }
            }
            var a = component.get('c.SelectSingleAccount');
            $A.enqueueAction(a);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    SelectSingleAccount: function(component, event, helper) {
        try {
            var AccountsList = component.get('v.Accounts');
            var selectedAccounts = [];
            var k = 0;
            for (var i = 0; i < AccountsList.length; i++) {
                var s = AccountsList[i];
                if (s.isSelected) {
                    selectedAccounts[k] = s.Id;
                    k++;
                }
            }
            component.set('v.NoOfSelectedRecords', k);
            if (selectedAccounts.length > 0) {
                component.set('v.disableImportBtn', false);
                component.set('v.disableExportBtn', false);
                component.set('v.selectedAccounts', selectedAccounts);
            } else {
                component.set('v.disableImportBtn', true);
                component.set('v.disableExportBtn', true);
            }
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
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
            cmp.set('v.selectedAccounts', selectedRows);
        } else {
            cmp.set('v.disableImportBtn', true);
            cmp.set('v.disableExportBtn', true);
        }
        cmp.set('v.NoOfSelectedRecords', selectedRows.length);
    },
    ImportAccounts: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            component.set("v.isOpen", false);
            helper.importAccounts(component, event);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    exportAccounts: function(component, event, helper) {
        try {
            var tabName = component.get('v.activeTab');
            if (tabName == 'list') {
                var stockData = component.get("v.selectedAccounts");
                if (stockData.length > 0) {
                    var csv = helper.convertAccountsToCSV(component, stockData);
                    if (csv == null) {
                        return;
                    }
                    var hiddenElement = document.createElement('a');
                    hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
                    hiddenElement.target = '_self';
                    hiddenElement.download = 'Accounts.csv';
                    document.body.appendChild(hiddenElement);
                    hiddenElement.click();
                } else {
                    helper.showToast('Please select records to export', 'Error');
                }
            } else {
                var stockData = component.get("v.accountLog");
                if (stockData != null) {
                    var csv = helper.convertAccountsToCSV(component, stockData);
                    if (csv == null) {
                        return;
                    }
                    var hiddenElement = document.createElement('a');
                    hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
                    hiddenElement.target = '_self';
                    hiddenElement.download = 'AccountsLog.csv';
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
                component.set('v.modalTitle', 'Import Accounts');
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
    }
})