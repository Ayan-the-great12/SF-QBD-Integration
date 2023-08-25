({
    getContacts: function(component, event) {
        var fromDate = component.get('v.fromDate');
        var toDate = component.get('v.toDate');
        var action = component.get("c.getAllContactApxc");
        action.setParams({
            fromDate: fromDate,
            toDate: toDate
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set('v.Spinner', false);
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                component.set("v.Spinner", false);
                var dataList = res.ContactList.map(function(rowData) {
                    if (rowData.conEmail) {
                        rowData.provenanceIconNameEmail = 'utility:email';
                    }
                    if (rowData.conPhone) {
                        rowData.provenanceIconNamePhone = 'utility:dialing';
                    }
                    if (!rowData.conEmail) {
                        rowData.conEmail = '-';
                    }
                    if (!rowData.conFirstName) {
                        rowData.conFirstName = '-';
                    }
                    if (!rowData.conLastName) {
                        rowData.conLastName = '-';
                    }
                    if (!rowData.conPhone) {
                        rowData.conPhone = '-';
                    }
                    return rowData;
                });
                component.set("v.ContactList", res.ContactList);
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
    syncContacts: function(component, event) {
        var action = component.get("c.syncContactGwApxc");
        action.setParams({
            conIds: component.get('v.selectedConIds')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.Spinner', false);
                this.showToast('Contacts uploaded successfully!', 'Success');
                component.set('v.isSelectAll', false);
                this.getContacts(component, event);
            } else {
                component.set('v.Spinner', false);
                var errors = response.getError();
                this.showToast('Something went wrong ' + errors[0].message + '!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    getUploadLog: function(component, event) {
        var action = component.get("c.getLogApxcContact");
        action.setParams({
            logname: 'Contact'
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
                            rowData.conStatus = rowData.status + ': ' + rowData.message
                        }
                        return rowData;
                    });
                    component.set("v.contactLog", res);
                } else {
                    component.set("v.contactLog", null);
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
            logname: 'Contact'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                component.set("v.Spinner", false);
                this.showToast('Upload log cleared successfully!', 'Success');
                component.set("v.contactLog", null);
            } else {
                var errors = response.getError();
                component.set('v.Spinner', false);
                this.showToast('Something went wrong ' + errors[0].message + '!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    sortData: function(component, fieldName, sortDirection) {
        var data = component.get("v.ContactList");
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
        } else if (fieldName == 'HyperUrlContact') {
            var key = function(a) {
                return a['conName'];
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
        component.set("v.ContactList", data);
    },
    sortDataLogs: function(component, fieldName, sortDirection) {
        var data = component.get("v.contactLog");
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
        component.set("v.ContactList", data);
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