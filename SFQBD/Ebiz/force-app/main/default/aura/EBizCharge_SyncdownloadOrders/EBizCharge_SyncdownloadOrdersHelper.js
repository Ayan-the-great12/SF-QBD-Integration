({
    getOrders: function(component, event, searchBy) {
        var startLimit = component.get("v.startLimit");
        var endLimit = component.get("v.endLimit");
        var AllOrders = component.get("v.AllOrders");
        var CurrentOrdersCount = component.get("v.CurrentOrdersCount");
        var currentPageNumber = component.get("v.currentPageNumber");
        var action = component.get("c.getOrdersApxc");
        action.setParams({
            filters: searchBy,
            startLimit: startLimit,
            endLimit: endLimit
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                var dataLength = res.length;
                if (dataLength > 0) {
                    var dataList = res.map(function(rowData) {
                        if (!rowData.OrderNumber) {
                            rowData.OrderNumber = '-';
                        }
                        if (!rowData.accName) {
                            rowData.accName = '-';
                        }
                        if (!rowData.accEmail) {
                            rowData.accEmail = '-';
                        }
                        if (!rowData.AmountPaid) {
                            rowData.AmountPaid = 0.0;
                        }
                        if (!rowData.TotalAmount) {
                            rowData.TotalAmount = 0.0;
                        }
                        if (!rowData.Portal) {
                            rowData.Portal = '-';
                        }
                        return rowData;
                    });
                    for (var i = 0; i < dataLength; i++) {
                        if (res[i].OrderPayments != null) {
                            res[i]._children = res[i].OrderPayments;
                        }
                        AllOrders.push(res[i]);
                    }
                    component.set("v.AllOrders", AllOrders);
                    this.sortOrdersData(component, 'CreatedDate', 'desc');
                    var ord = component.get("v.AllOrders");
                    res = ord;
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
                        if (res[i].OrderPayments != null) {
                            res[i]._children = res[i].OrderPayments;
                        }
                        subset.push(res[i]);
                    }
                    component.set("v.Orders", subset);
                    component.set("v.currentIndex", maxGridLimit);
                    component.set('v.FromDate', res[0].fromDate);
                    component.set('v.ToDate', res[0].toDate);
                    component.set("v.CurrentOrdersCount", CurrentOrdersCount + dataLength);
                    startLimit = startLimit + 50;
                    component.set("v.startLimit", startLimit);
                    component.set("v.currentPageNumber", 1);
                    component.set('v.disableDownloadBtn', true);
                    component.set("v.OrdersDownloaded", true);
                    component.set("v.Spinner", false);
                } else {
                    component.set("v.Orders", null);
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
    getOrdersNext: function(component, event, searchBy) {
        var startLimit = component.get("v.startLimit");
        var endLimit = component.get("v.endLimit");
        var AllOrders = component.get("v.AllOrders");
        var existingOrders = component.get("v.Orders");
        var currentIndex = component.get("v.currentIndex");
        var CurrentOrdersCount = component.get("v.CurrentOrdersCount");
        var action = component.get("c.getOrdersApxc");
        action.setParams({
            filters: searchBy,
            startLimit: startLimit,
            endLimit: endLimit
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                var dataLength = res.length;
                if (dataLength == 0) {
                    component.set("v.Spinner", false);
                    component.set('v.disableNextBtn', true);
                } else if (dataLength > 0) {
                    var dataList = res.map(function(rowData) {
                        if (!rowData.OrderNumber) {
                            rowData.OrderNumber = '-';
                        }
                        if (!rowData.accName) {
                            rowData.accName = '-';
                        }
                        if (!rowData.accEmail) {
                            rowData.accEmail = '-';
                        }
                        if (!rowData.AmountPaid) {
                            rowData.AmountPaid = 0.0;
                        }
                        if (!rowData.TotalAmount) {
                            rowData.TotalAmount = 0.0;
                        }
                        if (!rowData.Portal) {
                            rowData.Portal = '-';
                        }
                        return rowData;
                    });
                    for (var i = 0; i < dataLength; i++) {
                        if (res[i].OrderPayments != null) {
                            res[i]._children = res[i].OrderPayments;
                        }
                        AllOrders.push(res[i]);
                    }
                    component.set("v.AllOrders", AllOrders);
                    var ord = component.get("v.AllOrders");
                    res = ord;
                    var subset = [];
                    var i = currentIndex;
                    var maxGridLimit = component.get("v.maxGridLimit");
                    maxGridLimit = currentIndex + maxGridLimit;
                    for (; i < maxGridLimit; i++) {
                        if (res[i].OrderPayments != null) {
                            res[i]._children = res[i].OrderPayments;
                        }
                        subset.push(res[i]);
                    }
                    component.set("v.Orders", subset);
                    component.set("v.currentIndex", maxGridLimit);
                    component.set('v.FromDate', res[0].fromDate);
                    component.set('v.ToDate', res[0].toDate);
                    component.set("v.CurrentOrdersCount", CurrentOrdersCount + dataLength);
                    startLimit = startLimit + 50;
                    component.set("v.startLimit", startLimit);
                    component.set("v.maxGridLimit", 20);
                    component.set('v.disableDownloadBtn', true);
                    component.set("v.OrdersDownloaded", true);
                    component.set("v.Spinner", false);
                } else {
                    component.set("v.Orders", null);
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
    downloadOrders: function(component, event, searchBy) {
        var startLimit = component.get("v.startLimit");
        var endLimit = component.get("v.endLimit");
        var AllOrders = component.get("v.AllOrders");
        var CurrentOrdersCount = component.get("v.CurrentOrdersCount");
        var action = component.get("c.getDownloadOrdersApxc");
        action.setParams({
            filters: searchBy,
            startLimit: startLimit,
            endLimit: endLimit
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                var dataLength = res.length;
                if (dataLength > 0) {
                    var dataList = res.map(function(rowData) {
                        if (!rowData.OrderNumber) {
                            rowData.OrderNumber = '-';
                        }
                        if (!rowData.accName) {
                            rowData.accName = '-';
                        }
                        if (!rowData.accEmail) {
                            rowData.accEmail = '-';
                        }
                        if (!rowData.AmountPaid) {
                            rowData.AmountPaid = 0.0;
                        }
                        if (!rowData.TotalAmount) {
                            rowData.TotalAmount = 0.0;
                        }
                        if (!rowData.Portal) {
                            rowData.Portal = '-';
                        }
                        return rowData;
                    });
                    for (var i = 0; i < dataLength; i++) {
                        if (res[i].OrderPayments != null) {
                            res[i]._children = res[i].OrderPayments;
                        }
                        AllOrders.push(res[i]);
                    }
                    component.set("v.AllOrders", AllOrders);
                    this.sortOrdersData(component, 'CreatedDate', 'desc');
                    var ord = component.get("v.AllOrders");
                    res = ord;
                    var subset = [];
                    var i = 0;
                    var maxGridLimit = component.get("v.maxGridLimit");
                    if (dataLength < maxGridLimit) {
                        component.set('v.disableNextBtn', true);
                    }
                    maxGridLimit = (maxGridLimit > dataLength) ? dataLength : maxGridLimit;
                    for (; i < maxGridLimit; i++) {
                        if (res[i].OrderPayments != null) {
                            res[i]._children = res[i].OrderPayments;
                        }
                        subset.push(res[i]);
                    }
                    component.set("v.Orders", subset);
                    component.set("v.currentIndex", maxGridLimit);
                    component.set('v.FromDate', res[0].fromDate);
                    component.set('v.ToDate', res[0].toDate);
                    component.set("v.CurrentOrdersCount", CurrentOrdersCount + dataLength);
                    component.set('v.disableDownloadBtn', true);
                    component.set("v.maxGridLimit", 20);
                    component.set("v.OrdersDownloaded", true);
                    component.set("v.Spinner", false);
                } else {
                    component.set("v.Orders", null);
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
    updateOrdersList: function(component) {
        var allOrders = component.get("v.Orders");
        var action = component.get("c.getUpdatedOrdersApxc");
        action.setParams({
            ordList: allOrders
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                var subset = [];
                if (res.length > 0) {
                    for (var i = 0; i < res.length; i++) {
                        if (res[i].OrderPayments != null) {
                            res[i]._children = res[i].OrderPayments;
                        }
                        subset.push(res[i]);
                    }
                    component.set('v.Orders', subset);
                    component.set('v.Spinner', false);
                } else {
                    component.set('v.Orders', subset);
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
        var data = component.get("v.Orders");
        var key = function(a) {
            return a[fieldName];
        }
        var reverse = sortDirection == 'asc' ? 1 : -1;
        if (fieldName == 'TotalAmount' || fieldName == 'AmountPaid') {
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
    sortDatalogs: function(component, fieldName, sortDirection) {
        var data = component.get("v.orderLog");
        var key = function(a) {
            return a[fieldName];
        }
        var reverse = sortDirection == 'asc' ? 1 : -1;
        if (fieldName == 'balance' || fieldName == 'PaidAmount') {
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
    getLog: function(component, event) {
        component.set("v.Spinner", false);
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
                        if (!rowData.ordNumber) {
                            rowData.ordNumber = '-';
                        }
                        if (!rowData.accName) {
                            rowData.accName = '-';
                        }
                        if (!rowData.email) {
                            rowData.email = '-';
                        }
                        if (!rowData.orderType) {
                            rowData.orderType = '-';
                        }
                        if (!rowData.DatePaid) {
                            rowData.DatePaid = '-';
                        }
                        if (!rowData.PaidAmount) {
                            rowData.PaidAmount = 0.0;
                        }
                        if (!rowData.balance) {
                            rowData.balance = 0.0;
                        }
                        if (!rowData.Source) {
                            rowData.Source = '-';
                        }
                        if (rowData.status == 'Imported') {
                            rowData.provenanceIconNameDownload = 'action:new_task';
                        } else {
                            rowData.provenanceIconNameDownload = 'action:close';
                            rowData.conStatus = rowData.status + ': ' + rowData.message
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
                this.showToast('Download log cleared successfully!', 'Success');
                component.set("v.orderLog", null);
            } else {
                var errors = response.getError();
                component.set('v.Spinner', false);
                this.showToast('Something went wrong ' + errors[0].message + '!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    importOrders: function(component, event) {
        var selOrders = component.get('v.selectedOrders');
        var action = component.get("c.importOrderApxc");
        action.setParams({
            orderlist: selOrders
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                component.set('v.Spinner', false);
                if (res == 'Success') {
                    this.showToast('Orders imported successfully!', 'Success');
                    this.updateOrdersList(component);
                } else {
                    this.showToast('Orders not imported successfully!', 'Error');
                }
            } else {
                component.set('v.Spinner', false);
                var errors = response.getError();
                this.showToast('Something went wrong ' + errors[0].message + '!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    convertOrdersToCSV: function(component, objectRecords) {
        var csvStringResult, counter, keys, columnDivider, lineDivider;
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        columnDivider = ',';
        lineDivider = '\n';
        var tabName = component.get('v.activeTab');
        if (tabName == 'list') {
            keys = ['OrderNumber', 'AccountName', 'Email', 'AmountPaid', 'OrderTotal', 'BalanceDue', 'Source'];
        } else {
            keys = ['OrderNumber', 'AccountName', 'Email', 'AmountPaid', 'BalanceDue', 'Source', 'ImportStatus'];
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
                    if (skey == 'OrderNumber') {
                        csvStringResult += '"' + objectRecords[i].OrderNumber + '"';
                    } else if (skey == 'AccountName') {
                        csvStringResult += '"' + objectRecords[i].accName + '"';
                    } else if (skey == 'Email') {
                        csvStringResult += '"' + objectRecords[i].accEmail + '"';
                    } else if (skey == 'AmountPaid') {
                        csvStringResult += '"' + objectRecords[i].AmountPaid + '"';
                    } else if (skey == 'OrderTotal') {
                        csvStringResult += '"' + objectRecords[i].TotalAmount + '"';
                    } else if (skey == 'BalanceDue') {
                        csvStringResult += '"' + objectRecords[i].AmountDue + '"';
                    } else if (skey == 'Source') {
                        csvStringResult += '"' + objectRecords[i].Portal + '"';
                    }
                } else {
                    if (skey == 'OrderNumber') {
                        csvStringResult += '"' + objectRecords[i].ordNumber + '"';
                    } else if (skey == 'AccountName') {
                        csvStringResult += '"' + objectRecords[i].accName + '"';
                    } else if (skey == 'Email') {
                        csvStringResult += '"' + objectRecords[i].email + '"';
                    } else if (skey == 'AmountPaid') {
                        csvStringResult += '"' + objectRecords[i].PaidAmount + '"';
                    } else if (skey == 'Balance') {
                        csvStringResult += '"' + objectRecords[i].balance + '"';
                    } else if (skey == 'Source') {
                        csvStringResult += '"' + objectRecords[i].Source + '"';
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
    sortOrdersData: function(component, fieldName, sortDirection) {
        var data = component.get("v.AllOrders");
        var key = function(a) {
            return a[fieldName];
        }
        var reverse = sortDirection == 'asc' ? 1 : -1;
        data.sort(function(a, b) {
            var a = key(a) ? key(a).toLowerCase() : '';
            var b = key(b) ? key(b).toLowerCase() : '';
            return reverse * ((a > b) - (b > a));
        });
        component.set("v.AllOrders", data);
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