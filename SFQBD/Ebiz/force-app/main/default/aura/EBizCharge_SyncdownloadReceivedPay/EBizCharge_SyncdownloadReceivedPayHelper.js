({
    getPayments: function(component, event) {
        var startLimit = component.get("v.startLimit");
        var endLimit = component.get("v.endLimit");
        var startLimit = startLimit.toString();
        var endLimit = endLimit.toString();
        var AllPayments = component.get("v.AllPayments");
        var CurrentPaymentsCount = component.get("v.CurrentPaymentsCount");
        var action = component.get("c.getPaymentsApxc");
        action.setParams({
            startLimit: startLimit,
            endLimit: endLimit
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                component.set("v.Spinner", false);
                var dataLength = res.length;
                if (dataLength > 0) {
                    var dataList = res.map(function(rowData) {
                        if (rowData.PayBy == 'CreditCard') {
                            rowData.card = 'ending in ' + rowData.CardNumber;
                            if (rowData.CardType == 'V') {
                                rowData.cardClass = 'visa';
                            } else if (rowData.CardType == 'M') {
                                rowData.cardClass = 'master';
                            } else if (rowData.CardType == 'A') {
                                rowData.cardClass = 'american';
                            } else if (rowData.CardType == 'DS') {
                                rowData.cardClass = 'discover';
                            }
                        } else {
                            rowData.cardClass = 'ach';
                            rowData.card = rowData.checkAccount;
                        }
                        return rowData;
                    });
                    for (var i = 0; i < dataLength; i++) {
                        AllPayments.push(res[i]);
                    }
                    component.set("v.AllPayments", AllPayments);
                    this.sortPaymentsData(component, 'CreatedDate', 'desc');
                    var payments = component.get("v.AllPayments");
                    res = payments;
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
                    component.set("v.Payments", subset);
                    component.set("v.currentIndex", maxGridLimit);
                    component.set("v.FromDate", subset[0].fromDate);
                    component.set("v.ToDate", subset[0].toDate);
                    component.set("v.CurrentPaymentsCount", CurrentPaymentsCount + dataLength);
                    component.set("v.Spinner", false);
                    component.set('v.disableDownloadBtn', true);
                    component.set("v.ReceivedPaymentsDownloaded", true);
                } else {
                    component.set("v.Payments", null);
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
    updatePaymentsList: function(component) {
        var allPayments = component.get("v.Payments");
        var action = component.get("c.getUpdatedPaymentsApxc");
        action.setParams({
            paymentList: allPayments
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                if (res.length > 0) {
                    var recPayment = {};
                    component.set('v.Payments', recPayment);
                    component.set('v.Payments', res);
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
    convertPaymentsToCSV: function(component, objectRecords) {
        var csvStringResult, counter, keys, columnDivider, lineDivider;
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        columnDivider = ',';
        lineDivider = '\n';
        keys = ['OrderNumber', 'RefNumber', 'AuthCode', 'AccountName', 'DatePaid', 'AmountPaid', 'PaymentMethod'];
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
                if (skey == 'OrderNumber') {
                    csvStringResult += '"' + objectRecords[i].OrderNumber + '"';
                } else if (skey == 'RefNumber') {
                    csvStringResult += '"' + objectRecords[i].RefNumber + '"';
                } else if (skey == 'AuthCode') {
                    csvStringResult += '"' + objectRecords[i].AuthCode + '"';
                } else if (skey == 'AccountName') {
                    csvStringResult += '"' + objectRecords[i].AccountName + '"';
                } else if (skey == 'DatePaid') {
                    csvStringResult += '"' + objectRecords[i].FormatedTransDate + '"';
                } else if (skey == 'AmountPaid') {
                    csvStringResult += '"' + objectRecords[i].AuthAmount + '"';
                } else if (skey == 'PaymentMethod') {
                    csvStringResult += '"' + objectRecords[i].card + '"';
                } else if (skey == 'UploadStatus') {
                    if (objectRecords[i].status != undefined) {
                        csvStringResult += '"' + objectRecords[i].status + '"';
                    }
                }
                counter++;
            }
            csvStringResult += lineDivider;
        }
        return csvStringResult;
    },
    sortData: function(component, fieldName, sortDirection) {
        var data = component.get("v.Payments");
        var key = function(a) {
            return a[fieldName];
        }
        var reverse = sortDirection == 'asc' ? 1 : -1;
        if (fieldName == 'AuthAmount') {
            data.sort(function(a, b) {
                var a = key(a) ? key(a) : '';
                var b = key(b) ? key(b) : '';
                return reverse * ((a > b) - (b > a));
            });
        } else if (fieldName == 'OrderNumber' || fieldName == 'RefNumber' || fieldName == 'AuthCode') {
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
        component.set("v.Payments", data);
    },
    sortDatalogs: function(component, fieldName, sortDirection) {
        var data = component.get("v.paymentLog");
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
        component.set("v.paymentLog", data);
    },
    importPayments: function(component, event) {
        var selPayments = component.get('v.selectedPayments');
        var action = component.get("c.importReceivedPaymentApxc");
        action.setParams({
            importPayments: selPayments
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                component.set('v.Spinner', false);
                if (res == 'Success') {
                    this.showToast('Received payments imported successfully!', 'Success');
                    this.updatePaymentsList(component);
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
    getLog: function(component, event) {
        var action = component.get("c.getLogApxc");
        action.setParams({
            logname: 'Payment'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                component.set("v.Spinner", false);
                if (res.length > 0) {
                    var dataList = res.map(function(rowData) {
                        if (!rowData.PaidAmount) {
                            rowData.PaidAmount = '-';
                        }
                        if (!rowData.InvoiceNumber) {
                            rowData.InvoiceNumber = '-';
                        }
                        if (!rowData.RefNum) {
                            rowData.RefNum = '-';
                        }
                        if (!rowData.AuthCode) {
                            rowData.AuthCode = '-';
                        }
                        if (!rowData.CustNum) {
                            rowData.CustNum = '-';
                        }
                        if (!rowData.PaidAmount) {
                            rowData.PaidAmount = '-';
                        }
                        if (rowData.status == 'Imported') {
                            rowData.provenanceIconNameUpload = 'action:new_task';
                        } else {
                            rowData.provenanceIconNameUpload = 'action:close';
                            rowData.conStatus = rowData.status + ': ' + rowData.message
                        }
                        rowData.Source = '-';
                        rowData.card = rowData.Last4;
                        return rowData;
                    });
                    component.set("v.paymentLog", res);
                } else {
                    component.set("v.paymentLog", null);
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
            logname: 'Payment'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                component.set("v.Spinner", false);
                this.showToast('Download log cleared successfully!', 'Success');
                component.set("v.paymentLog", null);
            } else {
                var errors = response.getError();
                component.set('v.Spinner', false);
                this.showToast('Something went wrong ' + errors[0].message + '!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    sortPaymentsData: function(component, fieldName, sortDirection) {
        var data = component.get("v.AllPayments");
        var key = function(a) {
            return a[fieldName];
        }
        var reverse = sortDirection == 'asc' ? 1 : -1;
        data.sort(function(a, b) {
            var a = key(a) ? key(a).toLowerCase() : '';
            var b = key(b) ? key(b).toLowerCase() : '';
            return reverse * ((a > b) - (b > a));
        });
        component.set("v.AllPayments", data);
    },
    findPayments: function(component, event, searchBy) {
        var AllPayments = component.get("v.AllPayments");
        var CurrentPaymentsCount = component.get("v.CurrentPaymentsCount");
        var startLimit = component.get("v.startLimit");
        var endLimit = component.get("v.endLimit");
        var action = component.get("c.findPaymentsApxc");
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
                    for (var i = 0; i < dataLength; i++) {
                        AllPayments.push(res[i]);
                    }
                    component.set("v.AllPayments", AllPayments);
                    this.sortPaymentsData(component, 'CreatedDate', 'desc');
                    var pay = component.get("v.AllPayments");
                    res = pay;
                    var subset = [];
                    var i = 0;
                    var maxGridLimit = component.get("v.maxGridLimit");
                    if (dataLength <= maxGridLimit) {
                        component.set('v.disableNextBtn', true);
                    } else {
                        component.set('v.disableNextBtn', false);
                    }
                    maxGridLimit = (maxGridLimit > dataLength) ? dataLength : maxGridLimit;
                    for (; i < maxGridLimit; i++) {
                        subset.push(res[i]);
                    }
                    component.set("v.Payments", subset);
                    component.set("v.currentIndex", maxGridLimit);
                    component.set('v.FromDate', res[0].fromDate);
                    component.set('v.ToDate', res[0].toDate);
                    component.set("v.CurrentPaymentsCount", CurrentPaymentsCount + dataLength);
                    component.set("v.Spinner", false);
                    startLimit = startLimit + 1000;
                    component.set('v.startLimit', startLimit);
                    component.set("v.currentPageNumber", 1);
                    component.set('v.disableDownloadBtn', true);
                    component.set("v.ReceivedPaymentsDownloaded", true);
                } else {
                    component.set("v.Payments", null);
                }
                component.set("v.Spinner", false);
            } else {
                var errors = response.getError();
                component.set('v.Spinner', false);
                this.showToast('Something went wrong ' + errors[0].message + '!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    findPaymentsNext: function(component, event, searchBy) {
        var currentIndex = component.get("v.currentIndex");
        var AllPayments = component.get("v.AllPayments");
        var CurrentPaymentsCount = component.get("v.CurrentPaymentsCount");
        var startLimit = component.get("v.startLimit");
        var endLimit = component.get("v.endLimit");
        var action = component.get("c.findPaymentsApxc");
        action.setParams({
            filters: searchBy,
            startLimit: startLimit,
            endLimit: endLimit
        })
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                var dataLength = res.length;
                if (dataLength == 0) {
                    component.set("v.Spinner", false);
                    component.set('v.disableNextBtn', true);
                } else if (dataLength > 0) {
                    for (var i = 0; i < dataLength; i++) {
                        AllPayments.push(res[i]);
                    }
                    component.set("v.AllPayments", AllPayments);
                    var pay = component.get("v.AllPayments");
                    res = pay;
                    var subset = [];
                    var i = currentIndex;
                    var maxGridLimit = component.get("v.maxGridLimit");
                    maxGridLimit = currentIndex + maxGridLimit;
                    for (; i < maxGridLimit; i++) {
                        subset.push(res[i]);
                    }
                    component.set("v.Payments", subset);
                    component.set("v.currentIndex", maxGridLimit);
                    component.set('v.FromDate', res[0].fromDate);
                    component.set('v.ToDate', res[0].toDate);
                    component.set("v.CurrentPaymentsCount", CurrentPaymentsCount + dataLength);
                    component.set("v.Spinner", false);
                    startLimit = startLimit + 1000;
                    component.set('v.startLimit', startLimit);
                    component.set('v.disableDownloadBtn', true);
                    component.set("v.ReceivedPaymentsDownloaded", true);
                } else {
                    component.set("v.Payments", null);
                }
                component.set("v.Spinner", false);
            } else {
                var errors = response.getError();
                component.set('v.Spinner', false);
                this.showToast('Something went wrong ' + errors[0].message + '!', 'Error');
            }
        });
        $A.enqueueAction(action);
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