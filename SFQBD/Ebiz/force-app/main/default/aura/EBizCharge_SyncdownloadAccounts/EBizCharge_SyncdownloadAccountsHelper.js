({
    getAccountsCount: function(component, event) {
        var totalPages;
        var action = component.get("c.getAccountsCountApxc");
        var maxGridLimit = component.get("v.maxGridLimit");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                component.set('v.TotalAccountsCount', res);
                if (res > maxGridLimit) {
                    totalPages = Math.ceil(res / maxGridLimit);
                } else {
                    totalPages = 1;
                }
                component.set('v.totalPages', totalPages);
                component.set('v.Spinner', false);
            } else {
                var errors = response.getError();
                component.set('v.Spinner', false);
                this.showToast('Something went wrong ' + errors[0].message + '!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    getAccounts: function(component, event, searchBy) {
        var allAccounts = component.get("v.AllAccounts");
        var CurrentAccountsCount = component.get("v.CurrentAccountsCount");
        var action = component.get("c.getAccountsApxc");
        var startLimit = component.get("v.startLimit");
        var endLimit = component.get("v.endLimit");
        action.setParams({
            filters: searchBy,
            startLimit: startLimit,
            endLimit: endLimit
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resData = response.getReturnValue();
                var res = resData.AccountsList;
                var dataLength = res.length;
                if (dataLength > 0) {
                    var dataList = res.map(function(rowData) {
                        if (!rowData.accName) {
                            rowData.accName = '-';
                        }
                        if (!rowData.accFirstName) {
                            rowData.accFirstName = '-';
                        }
                        if (!rowData.accLastName) {
                            rowData.accLastName = '-';
                        }
                        if (!rowData.accEmail) {
                            rowData.accEmail = '-';
                        }
                        if (!rowData.accPhone) {
                            rowData.accPhone = '-';
                        }
                        if (!rowData.accSource) {
                            rowData.accSource = '-';
                        }
                        if (rowData.isImported) {
                            rowData.provenanceIconNameImported = 'utility:success';
                        }
                        return rowData;
                    });
                    for (var i = 0; i < dataLength; i++) {
                        allAccounts.push(res[i]);
                    }
                    component.set("v.AllAccounts", allAccounts);
                    this.sortAccountsData(component, 'accDateTimeCreated', 'desc');
                    var acc = component.get("v.AllAccounts");
                    res = acc;
                    var subset = [];
                    var i = 0;
                    var maxGridLimit = component.get("v.maxGridLimit");
                    if (dataLength < maxGridLimit) {
                        component.set('v.disableNextBtn', true);
                    } else {
                        component.set('v.disableNextBtn', false);
                    }
                    maxGridLimit = (maxGridLimit > dataLength) ? dataLength : maxGridLimit;
                    for (; i < maxGridLimit; i++) {
                        subset.push(res[i]);
                    }
                    component.set("v.Accounts", subset);
                    this.sortData(component, 'accDateTimeCreated', 'desc');
                    component.set("v.currentIndex", maxGridLimit);
                    component.set('v.FromDate', resData.fromDate);
                    component.set('v.ToDate', resData.toDate);
                    component.set("v.CurrentAccountsCount", CurrentAccountsCount + dataLength);
                    startLimit = startLimit + 1000;
                    component.set("v.startLimit", startLimit);
                    component.set("v.currentPageNumber", 1);
                    component.set("v.AccountsDownloaded", true);
                    component.set('v.disableDownloadBtn', true);
                    component.set("v.Spinner", false);
                } else {
                    component.set("v.Accounts", null);
                    component.set("v.Spinner", false);
                }
            } else {
                var errors = response.getError();
                component.set('v.Spinner', false);
                this.showToast('Something went wrong ' + errors[0].message + '!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    getAccountsNext: function(component, event, searchBy) {
        var allAccounts = component.get("v.AllAccounts");
        var CurrentAccountsCount = component.get("v.CurrentAccountsCount");
        var action = component.get("c.getAccountsApxc");
        var currentIndex = component.get("v.currentIndex");
        var startLimit = component.get("v.startLimit");
        var endLimit = component.get("v.endLimit");
        action.setParams({
            filters: searchBy,
            startLimit: startLimit,
            endLimit: endLimit
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resData = response.getReturnValue();
                var res = resData.AccountsList;
                var dataLength = res.length;
                if (dataLength == 0) {
                    component.set("v.Spinner", false);
                    component.set('v.disableNextBtn', true);
                } else if (dataLength > 0) {
                    var dataList = res.map(function(rowData) {
                        if (!rowData.accName) {
                            rowData.accName = '-';
                        }
                        if (!rowData.accFirstName) {
                            rowData.accFirstName = '-';
                        }
                        if (!rowData.accLastName) {
                            rowData.accLastName = '-';
                        }
                        if (!rowData.accEmail) {
                            rowData.accEmail = '-';
                        }
                        if (!rowData.accPhone) {
                            rowData.accPhone = '-';
                        }
                        if (!rowData.accSource) {
                            rowData.accSource = '-';
                        }
                        if (rowData.isImported) {
                            rowData.provenanceIconNameImported = 'utility:success';
                        }
                        return rowData;
                    });
                    for (var i = 0; i < dataLength; i++) {
                        allAccounts.push(res[i]);
                    }
                    component.set("v.AllAccounts", allAccounts);
                    var acc = component.get("v.AllAccounts");
                    res = acc;
                    var subset = [];
                    var i = currentIndex;
                    var maxGridLimit = component.get("v.maxGridLimit");
                    maxGridLimit = currentIndex + maxGridLimit;
                    for (; i < maxGridLimit; i++) {
                        subset.push(res[i]);
                    }
                    component.set("v.Accounts", subset);
                    this.sortData(component, 'accDateTimeCreated', 'desc');
                    component.set("v.currentIndex", maxGridLimit);
                    component.set('v.FromDate', resData.fromDate);
                    component.set('v.ToDate', resData.toDate);
                    component.set("v.CurrentAccountsCount", CurrentAccountsCount + dataLength);
                    startLimit = startLimit + 1000;
                    component.set("v.startLimit", startLimit);
                    component.set("v.AccountsDownloaded", true);
                    component.set('v.disableDownloadBtn', true);
                    component.set("v.Spinner", false);
                } else {
                    component.set("v.Accounts", null);
                    component.set("v.Spinner", false);
                }
            } else {
                var errors = response.getError();
                component.set('v.Spinner', false);
                this.showToast('Something went wrong ' + errors[0].message + '!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    DownloadAccounts: function(component, event) {
        var allAccounts = component.get("v.AllAccounts");
        var CurrentAccountsCount = component.get("v.CurrentAccountsCount");
        var action = component.get("c.getAccountsDownloadApxc");
        var startLimit = component.get("v.startLimit");
        var endLimit = component.get("v.endLimit");
        action.setParams({
            startLimit: startLimit,
            endLimit: endLimit
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resData = response.getReturnValue();
                var res = resData.AccountsList;
                var dataLength = res.length;
                if (dataLength > 0) {
                    var dataList = res.map(function(rowData) {
                        if (!rowData.accName) {
                            rowData.accName = '-';
                        }
                        if (!rowData.accFirstName) {
                            rowData.accFirstName = '-';
                        }
                        if (!rowData.accLastName) {
                            rowData.accLastName = '-';
                        }
                        if (!rowData.accEmail) {
                            rowData.accEmail = '-';
                        }
                        if (!rowData.accPhone) {
                            rowData.accPhone = '-';
                        }
                        if (!rowData.accSource) {
                            rowData.accSource = '-';
                        }
                        if (rowData.isImported) {
                            rowData.provenanceIconNameImported = 'utility:success';
                        }
                        return rowData;
                    });
                    for (var i = 0; i < dataLength; i++) {
                        allAccounts.push(res[i]);
                    }
                    component.set("v.AllAccounts", allAccounts);
                    this.sortAccountsData(component, 'accDateTimeCreated', 'desc');
                    var acc = component.get("v.AllAccounts");
                    res = acc;
                    var subset = [];
                    var i = 0;
                    var maxGridLimit = component.get("v.maxGridLimit");
                    if (dataLength < maxGridLimit) {
                        component.set('v.disableNextBtn', true);
                    }
                    maxGridLimit = (maxGridLimit > dataLength) ? dataLength : maxGridLimit;
                    for (; i < maxGridLimit; i++) {
                        subset.push(res[i]);
                    }
                    component.set("v.Accounts", subset);
                    this.sortData(component, 'accDateTimeCreated', 'desc');
                    component.set("v.currentIndex", maxGridLimit);
                    component.set('v.FromDate', resData.fromDate);
                    component.set('v.ToDate', resData.toDate);
                    component.set("v.CurrentAccountsCount", CurrentAccountsCount + dataLength);
                    component.set("v.AccountsDownloaded", true);
                    component.set('v.disableDownloadBtn', true);
                    component.set("v.Spinner", false);
                } else {
                    component.set("v.Accounts", null);
                    component.set("v.Spinner", false);
                }
            } else {
                var errors = response.getError();
                component.set('v.Spinner', false);
                this.showToast('Something went wrong ' + errors[0].message + '!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    updateAccountsList: function(component) {
        var allAccounts = component.get("v.Accounts");
        var selAccounts = component.get('v.selectedAccounts');
        var action = component.get("c.getUpdatedAccountsApxc");
        var cs = component.get('v.CS');
        action.setParams({
            accList: allAccounts,
            selAcclist: selAccounts,
            settings: cs
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                if (res.length > 0) {
                    component.set('v.Accounts', res);
                    component.set('v.Spinner', false);
                } else {
                    component.set('v.Accounts', []);
                    component.set('v.Spinner', false);
                }
            } else {
                var errors = response.getError();
                component.set('v.Spinner', false);
                this.showToast('Something went wrong ' + errors[0].message + '!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    sortData: function(component, fieldName, sortDirection) {
        var data = component.get("v.Accounts");
        var key = function(a) {
            return a[fieldName];
        }
        var reverse = sortDirection == 'asc' ? 1 : -1;
        if (fieldName == 'accPhone') {
            data.sort(function(a, b) {
                var a = key(a) ? parseFloat(key(a)) : '';
                var b = key(b) ? parseFloat(key(b)) : '';
                return reverse * ((a > b) - (b > a));
            });
        } else {
            data.sort(function(a, b) {
                var a = key(a) ? key(a).toLowerCase() : '';
                var b = key(b) ? key(b).toLowerCase() : '';
                return reverse * ((a > b) - (b > a));
            });
        }
        component.set("v.Accounts", data);
    },
    sortDatalogs: function(component, fieldName, sortDirection) {
        var data = component.get("v.accountLog");
        var key = function(a) {
            return a[fieldName];
        }
        var reverse = sortDirection == 'asc' ? 1 : -1;
        if (fieldName == 'Phone') {
            data.sort(function(a, b) {
                var a = key(a) ? parseFloat(key(a)) : '';
                var b = key(b) ? parseFloat(key(b)) : '';
                return reverse * ((a > b) - (b > a));
            });
        } else {
            data.sort(function(a, b) {
                var a = key(a) ? key(a).toLowerCase() : '';
                var b = key(b) ? key(b).toLowerCase() : '';
                return reverse * ((a > b) - (b > a));
            });
        }
        component.set("v.accountLog", data);
    },
    getLog: function(component, event) {
        component.set("v.Spinner", false);
        var action = component.get("c.getLogApxc");
        action.setParams({
            logname: 'Account'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                component.set("v.Spinner", false);
                if (res.length > 0) {
                    var dataList = res.map(function(rowData) {
                        if (!rowData.accName) {
                            rowData.accName = '-';
                        }
                        if (!rowData.firstName) {
                            rowData.firstName = '-';
                        }
                        if (!rowData.lastName) {
                            rowData.lastName = '-';
                        }
                        if (!rowData.email) {
                            rowData.email = '-';
                        }
                        if (!rowData.Phone) {
                            rowData.Phone = '-';
                        }
                        if (!rowData.accSource) {
                            rowData.accSource = '-';
                        }
                        if (rowData.status == 'Imported') {
                            rowData.provenanceIconNameDownload = 'action:new_task';
                        } else {
                            rowData.provenanceIconNameDownloads = 'action:close';
                            rowData.status = rowData.status + ': ' + rowData.message
                        }
                        return rowData;
                    });
                    component.set("v.accountLog", res);
                } else {
                    component.set("v.accountLog", null);
                }
            } else {
                var errors = response.getError();
                component.set('v.Spinner', false);
                this.showToast('Something went wrong ' + errors[0].message + '!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    clearLog: function(component, event) {
        var action = component.get("c.clearLogApxc");
        action.setParams({
            logname: 'Account'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                component.set("v.Spinner", false);
                this.showToast('Download log cleared successfully!', 'Success');
                component.set("v.accountLog", null);
            } else {
                var errors = response.getError();
                component.set('v.Spinner', false);
                this.showToast('Something went wrong ' + errors[0].message + '!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    importAccounts: function(component, event) {
        var selAccounts = component.get('v.selectedAccounts');
        var action = component.get("c.importAccountApxc");
        action.setParams({
            accountlist: selAccounts
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                component.set('v.Spinner', false);
                if (res == 'Success') {
                    this.showToast('Accounts imported successfully!', 'Success');
                    var dt = component.get('v.ToDate');;
                    var settings = component.get('v.CS');
                    settings.Ebiz_C__EBizcharge_Last_Import_Date__c = dt;
                    component.set('v.CS', settings);
                    this.updateAccountsList(component);
                } else {
                    this.showToast(res, 'Error');
                }
            } else {
                component.set('v.Spinner', false);
                var errors = response.getError();
                this.showToast('Something went wrong ' + errors[0].message + '!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    convertAccountsToCSV: function(component, objectRecords) {
        var csvStringResult, counter, keys, columnDivider, lineDivider;
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        columnDivider = ',';
        lineDivider = '\n';
        var tabName = component.get('v.activeTab');
        if (tabName == 'list') {
            keys = ['AccountName', 'FirstName', 'LastName', 'Email', 'PhoneNumber', 'Source'];
        } else {
            keys = ['AccountName', 'FirstName', 'LastName', 'Email', 'PhoneNumber', 'Source', 'ImportStatus'];
        }
        csvStringResult = '';
        csvStringResult += keys.join(columnDivider);
        csvStringResult += lineDivider;
        for (var i = 0; i < objectRecords.length; i++) {
            counter = 0;
            for (var sTempkey in keys) {
                var skey = keys[sTempkey];
                if (counter > 0) {
                    csvStringResult += columnDivider;
                }
                if (tabName == 'list') {
                    if (skey == 'AccountName') {
                        csvStringResult += '"' + objectRecords[i].accName + '"';
                    } else if (skey == 'FirstName') {
                        csvStringResult += '"' + objectRecords[i].accFirstName + '"';
                    } else if (skey == 'LastName') {
                        csvStringResult += '"' + objectRecords[i].accLastName + '"';
                    } else if (skey == 'Email') {
                        csvStringResult += '"' + objectRecords[i].accEmail + '"';
                    } else if (skey == 'PhoneNumber') {
                        csvStringResult += '"' + objectRecords[i].accPhone + '"';
                    } else if (skey == 'Source') {
                        csvStringResult += '"' + objectRecords[i].accSource + '"';
                    }
                } else {
                    if (skey == 'AccountName') {
                        csvStringResult += '"' + objectRecords[i].accName + '"';
                    } else if (skey == 'FirstName') {
                        csvStringResult += '"' + objectRecords[i].firstName + '"';
                    } else if (skey == 'LastName') {
                        csvStringResult += '"' + objectRecords[i].lastName + '"';
                    } else if (skey == 'Email') {
                        csvStringResult += '"' + objectRecords[i].email + '"';
                    } else if (skey == 'PhoneNumber') {
                        csvStringResult += '"' + objectRecords[i].Phone + '"';
                    } else if (skey == 'Source') {
                        csvStringResult += '"' + objectRecords[i].accSource + '"';
                    } else if (skey == 'ImportStatus') {
                        csvStringResult += '"' + objectRecords[i].status + '"';
                    }
                }
                counter++;
            }
            csvStringResult += lineDivider;
        }
        return csvStringResult;
    },
    sortAccountsData: function(component, fieldName, sortDirection) {
        var data = component.get("v.AllAccounts");
        var key = function(a) {
            return a[fieldName];
        }
        var reverse = sortDirection == 'asc' ? 1 : -1;
        if (fieldName == 'accPhone') {
            data.sort(function(a, b) {
                var a = key(a) ? parseFloat(key(a)) : '';
                var b = key(b) ? parseFloat(key(b)) : '';
                return reverse * ((a > b) - (b > a));
            });
        } else {
            data.sort(function(a, b) {
                var a = key(a) ? key(a).toLowerCase() : '';
                var b = key(b) ? key(b).toLowerCase() : '';
                return reverse * ((a > b) - (b > a));
            });
        }
        component.set("v.AllAccounts", data);
    },
    showToast: function(message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: type + '!',
            message: message,
            duration: ' 5000',
            key: type + '_alt',
            type: type,
            mode: 'dismissible'
        });
        toastEvent.fire();
    }
})