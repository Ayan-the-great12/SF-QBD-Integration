({
    getOrders: function(component, event) {
        var accountId = component.get('v.selectedLookUpAccRecord.Id');
        var orderId = component.get('v.selectedLookUpOrdRecord.Id');
        var fromDate = component.get('v.fromDate');
        var toDate = component.get('v.toDate');
        var action = component.get("c.getAllOrdersApxc");
        action.setParams({
            AccountId: accountId,
            OrderId: orderId,
            fromDate: fromDate,
            toDate: toDate
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                component.set("v.Spinner", false);
                let FilterOrders = res.OrdersList;
                var dataList = FilterOrders.map(function(rowData) {
                    if (rowData.accEmail) {
                        rowData.provenanceIconNameEmail = 'utility:email';
                    }
                    if (!rowData.accEmail) {
                        rowData.accEmail = '-';
                    }
                    return rowData;
                });
                component.set("v.Orders", FilterOrders);
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
    syncOrders: function(component, event) {
        var selOrders = component.get('v.selectedOrders');
        var action = component.get("c.syncOrdersGwApxc");
        action.setParams({
            selectedOrders: selOrders
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.Spinner', false);
                this.showToast('Orders uploaded successfully!', 'Success');
                this.getOrders(component, event);
            } else {
                var errors = response.getError();
                component.set('v.Spinner', false);
                this.showToast('Something went wrong ' + errors[0].message + '!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    getUploadLog: function(component, event) {
        var action = component.get("c.getLogApxc");
        action.setParams({
            logname: 'Order'
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
                        if (!rowData.balance) {
                            rowData.balance = 0.0;
                        }
                        if (rowData.status == 'Uploaded') {
                            rowData.provenanceIconNameUpload = 'action:new_task';
                        } else {
                            rowData.provenanceIconNameUpload = 'action:close';
                            rowData.status = rowData.status + ': ' + rowData.message
                        }
                        return rowData;
                    });
                    component.set("v.orderLog", res);
                } else {
                    component.set("v.orderLog", null);
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
            logname: 'Order'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                component.set("v.Spinner", false);
                this.showToast('Upload log cleared successfully!', 'Success');
                component.set("v.orderLog", null);
            } else {
                var errors = response.getError();
                component.set('v.Spinner', false);
                this.showToast('Something went wrong ' + errors[0].message + '!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    sortData: function(component, fieldName, sortDirection) {
        var data = component.get("v.Orders");
        var key = function(a) {
            return a[fieldName];
        }
        var reverse = sortDirection == 'asc' ? 1 : -1;
        if (fieldName == 'HyperUrlOrder') {
            var key = function(a) {
                return a['OrderNumber'];
            }
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
        } else if (fieldName == 'TotalAmount' || fieldName == 'Order_balance') {
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
        component.set("v.Orders", data);
    },
    sortDataLog: function(component, fieldName, sortDirection) {
        var data = component.get("v.orderLog");
        var key = function(a) {
            return a[fieldName];
        }
        var reverse = sortDirection == 'asc' ? 1 : -1;
        if (fieldName == 'HyperUrlOrder') {
            var key = function(a) {
                return a['ordNumber'];
            }
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
        } else if (fieldName == 'amount' || fieldName == 'balance') {
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
        component.set("v.orderLog", data);
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