({
    getProducts: function(component, event) {
        var fromDate = component.get('v.fromDate');
        var toDate = component.get('v.toDate');
        var action = component.get("c.getAllProductsApxc");
        action.setParams({
            fromDate: fromDate,
            toDate: toDate
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                component.set("v.Spinner", false);
                var dataList = res.ProductList.map(function(rowData) {
                    if (rowData.prodName) {
                        rowData.provenanceIconNameProductName = 'utility:variation_products';
                    }
                    if (rowData.prodQuantity) {
                        rowData.provenanceIconNameProductQuantity = 'utility:number_input';
                    }
                    if (rowData.prodDescription) {
                        rowData.provenanceIconNameProductDescription = 'utility:quip';
                    }
                    if (!rowData.prodName) {
                        rowData.prodName = '-';
                    }
                    if (!rowData.prodDescription) {
                        rowData.prodDescription = '-';
                    }
                    if (!rowData.prodQuantity) {
                        rowData.prodQuantity = '-';
                    }
                    if (!rowData.prodPrice) {
                        rowData.prodPrice = '-';
                    }
                    if (!rowData.prodPrice) {
                        rowData.prodPrice = '-';
                    }
                    return rowData;
                });
                component.set("v.Products", res.ProductList);
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
    sortDataLogs: function(component, fieldName, sortDirection) {
        var data = component.get("v.productLog");
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
        component.set("v.productLog", data);
    },
    syncProducts: function(component, event) {
        var action = component.get("c.syncProductsGwApxc");
        action.setParams({
            prodIds: component.get('v.selectedProdIds')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.Spinner', false);
                this.showToast('Products uploaded successfully!', 'Success');
                this.getProducts(component, event);
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
            logname: 'Product'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                component.set("v.Spinner", false);
                if (res.length > 0) {
                    var dataList = res.map(function(rowData) {
                        if (rowData.prodName) {
                            rowData.provenanceIconNameProductName = 'utility:variation_products';
                        }
                        if (rowData.quantity) {
                            rowData.provenanceIconNameProductQuantity = 'utility:number_input';
                        }
                        if (rowData.description) {
                            rowData.provenanceIconNameProductDescription = 'utility:quip';
                        }
                        if (!rowData.prodName) {
                            rowData.prodName = '-';
                        }
                        if (!rowData.description) {
                            rowData.description = '-';
                        }
                        if (!rowData.quantity) {
                            rowData.quantity = '-';
                        }
                        if (!rowData.amount) {
                            rowData.amount = '-';
                        }
                        if (rowData.status == 'Uploaded') {
                            rowData.provenanceIconNameUpload = 'action:new_task';
                        } else {
                            rowData.provenanceIconNameUpload = 'action:close';
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
                this.showToast('Upload log cleared successfully!', 'Success');
                component.set("v.productLog", null);
            } else {
                var errors = response.getError();
                component.set('v.Spinner', false);
                this.showToast('Something went wrong ' + errors[0].message + '!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    sortData: function(component, fieldName, sortDirection) {
        var data = component.get("v.Products");
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
        component.set("v.Products", data);
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