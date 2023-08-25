({
    getProducts: function(component, event) {
        var AllProducts = component.get("v.AllProducts");
        var CurrentProductsCount = component.get("v.CurrentProductsCount");
        var startLimit = component.get("v.startLimit");
        var endLimit = component.get("v.endLimit");
        var action = component.get("c.getProductsApxc");
        action.setParams({
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
                        if (!rowData.prodCode) {
                            rowData.prodCode = '-';
                        }
                        if (!rowData.prodName) {
                            rowData.prodName = '-';
                        }
                        if (!rowData.prodPrice) {
                            rowData.prodPrice = 0.0;
                        }
                        if (!rowData.prodQuantity) {
                            rowData.prodQuantity = 0;
                        }
                        if (!rowData.prodDescription) {
                            rowData.prodDescription = '-';
                        }
                        if (!rowData.prodSoftware) {
                            rowData.prodSoftware = '-';
                        }
                        return rowData;
                    });
                    for (var i = 0; i < dataLength; i++) {
                        AllProducts.push(res[i]);
                    }
                    component.set("v.AllProducts", AllProducts);
                    this.sortProductData(component, 'FormatedTransDate', 'desc');
                    var prod = component.get("v.AllProducts");
                    res = prod;
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
                    component.set("v.Product", subset);
                    component.set("v.currentIndex", maxGridLimit);
                    component.set('v.FromDate', res[0].fromDate);
                    component.set('v.ToDate', res[0].toDate);
                    component.set("v.CurrentProductsCount", CurrentProductsCount + dataLength);
                    component.set("v.Spinner", false);
                    component.set('v.disableDownloadBtn', true);
                    component.set("v.ProductsDownloaded", true);
                } else {
                    component.set("v.Product", null);
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
    findProduct: function(component, event, searchBy) {
        var AllProducts = component.get("v.AllProducts");
        var CurrentProductsCount = component.get("v.CurrentProductsCount");
        var startLimit = component.get("v.startLimit");
        var endLimit = component.get("v.endLimit");
        var action = component.get("c.findProductsApxc");
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
                        if (!rowData.prodCode) {
                            rowData.prodCode = '-';
                        }
                        if (!rowData.prodName) {
                            rowData.prodName = '-';
                        }
                        if (!rowData.prodPrice) {
                            rowData.prodPrice = 0.0;
                        }
                        if (!rowData.prodQuantity) {
                            rowData.prodQuantity = 0;
                        }
                        if (!rowData.prodDescription) {
                            rowData.prodDescription = '-';
                        }
                        if (!rowData.prodSoftware) {
                            rowData.prodSoftware = '-';
                        }
                        return rowData;
                    });
                    for (var i = 0; i < dataLength; i++) {
                        AllProducts.push(res[i]);
                    }
                    component.set("v.AllProducts", AllProducts);
                    this.sortProductData(component, 'FormatedTransDate', 'desc');
                    var prod = component.get("v.AllProducts");
                    res = prod;
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
                    component.set("v.Product", subset);
                    component.set("v.currentIndex", maxGridLimit);
                    component.set('v.FromDate', res[0].fromDate);
                    component.set('v.ToDate', res[0].toDate);
                    component.set("v.CurrentProductsCount", CurrentProductsCount + dataLength);
                    startLimit = startLimit + 1000;
                    component.set("v.startLimit", startLimit);
                    component.set("v.currentPageNumber", 1);
                    component.set("v.Spinner", false);
                    component.set('v.disableDownloadBtn', true);
                    component.set("v.ProductsDownloaded", true);
                } else {
                    component.set("v.Product", null);
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
    findProductNext: function(component, event, searchBy) {
        var AllProducts = component.get("v.AllProducts");
        var CurrentProductsCount = component.get("v.CurrentProductsCount");
        var currentIndex = component.get("v.currentIndex");
        var startLimit = component.get("v.startLimit");
        var endLimit = component.get("v.endLimit");
        var action = component.get("c.findProductsApxc");
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
                        if (!rowData.prodCode) {
                            rowData.prodCode = '-';
                        }
                        if (!rowData.prodName) {
                            rowData.prodName = '-';
                        }
                        if (!rowData.prodPrice) {
                            rowData.prodPrice = 0.0;
                        }
                        if (!rowData.prodQuantity) {
                            rowData.prodQuantity = 0;
                        }
                        if (!rowData.prodDescription) {
                            rowData.prodDescription = '-';
                        }
                        if (!rowData.prodSoftware) {
                            rowData.prodSoftware = '-';
                        }
                        return rowData;
                    });
                    for (var i = 0; i < dataLength; i++) {
                        AllProducts.push(res[i]);
                    }
                    component.set("v.AllProducts", AllProducts);
                    this.sortProductData(component, 'FormatedTransDate', 'desc');
                    var prod = component.get("v.AllProducts");
                    res = prod;
                    var subset = [];
                    var i = currentIndex;
                    maxGridLimit = currentIndex + maxGridLimit;
                    for (; i < maxGridLimit; i++) {
                        subset.push(res[i]);
                    }
                    component.set("v.Product", subset);
                    component.set("v.currentIndex", maxGridLimit);
                    component.set('v.FromDate', res[0].fromDate);
                    component.set('v.ToDate', res[0].toDate);
                    component.set("v.CurrentProductsCount", CurrentProductsCount + dataLength);
                    startLimit = startLimit + 1000;
                    component.set("v.startLimit", startLimit);
                    component.set("v.Spinner", false);
                    component.set('v.disableDownloadBtn', true);
                    component.set("v.ProductsDownloaded", true);
                } else {
                    component.set("v.Product", null);
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
    updateProductsList: function(component) {
        var allProducts = component.get("v.Product");
        var action = component.get("c.getUpdatedProductsApxc");
        action.setParams({
            prodList: allProducts
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                if (res.length > 0) {
                    component.set('v.Product', res);
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
    importProducts: function(component, event) {
        var selProducts = component.get('v.selectedProducts');
        var action = component.get("c.importProductApxc");
        action.setParams({
            productlist: selProducts
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                component.set('v.Spinner', false);
                if (res == 'Success') {
                    this.showToast('Products imported successfully!', 'Success');
                    this.updateProductsList(component);
                } else {
                    this.showToast('Products not imported successfully!', 'Error');
                }
            } else {
                component.set('v.Spinner', false);
                var errors = response.getError();
                this.showToast('Something went wrong ' + errors[0].message + '!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    sortData: function(component, fieldName, sortDirection) {
        var data = component.get("v.Product");
        var key = function(a) {
            return a[fieldName];
        }
        var reverse = sortDirection == 'asc' ? 1 : -1;
        if (fieldName == 'prodprice' || fieldName == 'prodQuantity') {
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
        component.set("v.Product", data);
    },
    sortDatalogs: function(component, fieldName, sortDirection) {
        var data = component.get("v.productLog");
        var key = function(a) {
            return a[fieldName];
        }
        var reverse = sortDirection == 'asc' ? 1 : -1;
        if (fieldName == 'prodprice' || fieldName == 'prodQuantity') {
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
        component.set("v.productLog", data);
    },
    getLog: function(component, event) {
        component.set("v.Spinner", false);
        var action = component.get("c.getLogApxc");
        action.setParams({
            logname: 'Product'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                component.set("v.Spinner", false);
                if (res.length > 0) {
                    var dataList = res.map(function(rowData) {
                        if (!rowData.prodCode) {
                            rowData.prodCode = '-';
                        }
                        if (!rowData.prodName) {
                            rowData.prodName = '-';
                        }
                        if (!rowData.amount) {
                            rowData.amount = 0.0;
                        }
                        if (!rowData.quantity) {
                            rowData.quantity = 0;
                        }
                        if (!rowData.description) {
                            rowData.description = '-';
                        }
                        if (!rowData.prodSoftware) {
                            rowData.prodSoftware = '-';
                        }
                        if (rowData.status == 'Imported') {
                            rowData.provenanceIconNameDownload = 'action:new_task';
                        } else {
                            rowData.provenanceIconNameDownloads = 'action:close';
                            rowData.status = rowData.status + ': ' + rowData.message
                        }
                        return rowData;
                    });
                    component.set("v.productLog", res);
                } else {
                    component.set("v.productLog", null);
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
            logname: 'Product'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                component.set("v.Spinner", false);
                this.showToast('Download log cleared successfully!', 'Success');
                component.set("v.productLog", null);
            } else {
                var errors = response.getError();
                component.set('v.Spinner', false);
                this.showToast('Something went wrong ' + errors[0].message + '!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    convertProductToCSV: function(component, objectRecords) {
        var csvStringResult, counter, keys, columnDivider, lineDivider;
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        columnDivider = ',';
        lineDivider = '\n';
        var tabName = component.get('v.activeTab');
        if (tabName == 'list') {
            keys = ['ProductCode', 'ProductName', 'UnitPrice', 'Quantity', 'Description', 'Source'];
        } else {
            keys = ['ProductCode', 'ProductName', 'UnitPrice', 'Quantity', 'Description', 'Source', 'ImportStatus'];
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
                    if (skey == 'ProductCode') {
                        csvStringResult += '"' + objectRecords[i].prodCode + '"';
                    } else if (skey == 'ProductName') {
                        csvStringResult += '"' + objectRecords[i].prodName + '"';
                    } else if (skey == 'UnitPrice') {
                        csvStringResult += '"' + objectRecords[i].prodPrice + '"';
                    } else if (skey == 'Quantity') {
                        csvStringResult += '"' + objectRecords[i].prodQuantity + '"';
                    } else if (skey == 'Description') {
                        csvStringResult += '"' + objectRecords[i].prodDescription + '"';
                    } else if (skey == 'Source') {
                        csvStringResult += '"' + objectRecords[i].prodSoftware + '"';
                    }
                } else {
                    if (skey == 'ProductCode') {
                        csvStringResult += '"' + objectRecords[i].prodCode + '"';
                    } else if (skey == 'ProductName') {
                        csvStringResult += '"' + objectRecords[i].prodName + '"';
                    } else if (skey == 'UnitPrice') {
                        csvStringResult += '"' + objectRecords[i].amount + '"';
                    } else if (skey == 'Quantity') {
                        csvStringResult += '"' + objectRecords[i].quantity + '"';
                    } else if (skey == 'Description') {
                        csvStringResult += '"' + objectRecords[i].description + '"';
                    } else if (skey == 'Source') {
                        csvStringResult += '"' + objectRecords[i].prodSoftware + '"';
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
    sortProductData: function(component, fieldName, sortDirection) {
        var data = component.get("v.AllProducts");
        var key = function(a) {
            return a[fieldName];
        }
        var reverse = sortDirection == 'asc' ? 1 : -1;
        if (fieldName == 'prodprice' || fieldName == 'prodQuantity') {
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
        component.set("v.AllProducts", data);
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