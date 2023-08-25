({
    getAccounts: function(component, event) {
        var fromDate = component.get('v.fromDate');
        var toDate = component.get('v.toDate');
        var action = component.get("c.getAllAccountsApxc");
        action.setParams({
            fromDate: fromDate,
            toDate: toDate
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                var dataList = res.AccountList.map(function(rowData) {
                    if (rowData.accEmail) {
                        rowData.provenanceIconNameEmail = 'utility:email';
                    }
                    if (rowData.accPhone) {
                        rowData.provenanceIconNamePhone = 'utility:dialing';
                    }
                    if (!rowData.accEmail) {
                        rowData.accEmail = '-';
                    }
                    if (!rowData.accFirstName) {
                        rowData.accFirstName = '-';
                    }
                    if (!rowData.accLastName) {
                        rowData.accLastName = '-';
                    }
                    if (!rowData.accPhone) {
                        rowData.accPhone = '-';
                    }
                    return rowData;
                });
                component.set("v.Spinner", false);
                component.set("v.Accounts", res.AccountList);
                component.set("v.fromDate", res.fromDate);
                component.set("v.toDate", res.toDate);
            } else {
                var errors = response.getError();
                component.set('v.Spinner', false);
                this.showToast('Something went wrong ' + errors[0].message + '!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    syncAccounts: function(component, event) {
        var action = component.get("c.syncAccountsGwApxc");
        action.setParams({
            accIds: component.get('v.selectedAccIds')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.Spinner', false);
                this.showToast('Accounts uploaded successfully!', 'Success');
                this.getAccounts(component, event);
            } else {
                component.set('v.Spinner', false);
                var errors = response.getError();
                this.showToast('Something went wrong ' + errors[0].message + '!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    getUploadLog: function(component, event) {
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
                        if (!rowData.amount) {
                            rowData.amount = 0.0;
                        }
                        if (!rowData.email) {
                            rowData.email = '-';
                        }
                        if (!rowData.firstName) {
                            rowData.firstName = '-';
                        }
                        if (!rowData.lastName) {
                            rowData.lastName = '-';
                        }
                        if (!rowData.Phone) {
                            rowData.Phone = '-';
                        }
                        if (rowData.status == 'Uploaded') {
                            rowData.provenanceIconNameUpload = 'action:new_task';
                        } else {
                            rowData.provenanceIconNameUpload = 'action:close';
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
                this.showToast('Upload log cleared successfully!', 'Success');
                component.set("v.accountLog", null);
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
        if (fieldName == 'accAmount') {
            data.sort(function(a, b) {
                var a = key(a) ? key(a) : '';
                var b = key(b) ? key(b) : '';
                return reverse * ((a > b) - (b > a));
            });
        } else if (fieldName == 'HyperUrlAccount') {
            var key = function(a) {
                return a['accName'];
            }
            data.sort(function(a, b) {
                var a = key(a) ? key(a).toLowerCase() : '';
                var b = key(b) ? key(b).toLowerCase() : '';
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
    sortDataLogs: function(component, fieldName, sortDirection) {
        var data = component.get("v.Accounts");
        var key = function(a) {
            return a[fieldName];
        }
        var reverse = sortDirection == 'asc' ? 1 : -1;
        if (fieldName == 'accAmount') {
            data.sort(function(a, b) {
                var a = key(a) ? key(a) : '';
                var b = key(b) ? key(b) : '';
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
    },
})