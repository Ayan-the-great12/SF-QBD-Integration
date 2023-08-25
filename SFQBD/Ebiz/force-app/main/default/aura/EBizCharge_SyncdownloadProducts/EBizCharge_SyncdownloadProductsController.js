({
    onPrev: function(component, event, helper) {
        var AllProducts = component.get("v.AllProducts");
        var currentIndex = component.get("v.currentIndex");
        var maxGridLimit = component.get("v.maxGridLimit");
        currentIndex = currentIndex - maxGridLimit - maxGridLimit;
        var currentPageNumber = component.get("v.currentPageNumber");
        var maxLimit = currentIndex + maxGridLimit;
        var prodList = [];
        if (currentIndex >= 0) {
            currentPageNumber = currentPageNumber - 1;
            component.set("v.currentPageNumber", currentPageNumber);
        }
        for (var i = currentIndex; i < maxLimit; i++) {
            prodList.push(AllProducts[i]);
        }
        component.set("v.Product", prodList);
        component.set('v.disableNextBtn', false);;
        component.set("v.currentIndex", maxLimit);
    },
    onNext: function(component, event, helper) {
        var CurrentProductsCount = component.get("v.CurrentProductsCount");
        var maxGridLimit = component.get("v.maxGridLimit");
        var downloadNext = component.get("v.downloadNext");
        if (CurrentProductsCount >= maxGridLimit) {
            var AllProducts = component.get("v.AllProducts");
            var currentIndex = component.get("v.currentIndex");
            var currentPageNumber = component.get("v.currentPageNumber");
            var maxLimit = currentIndex + maxGridLimit;
            if (maxLimit > CurrentProductsCount) {
                maxLimit = AllProducts.length;
            }
            var prodList = [];
            if (currentIndex != maxLimit) {
                currentPageNumber = currentPageNumber + 1;
                component.set("v.currentPageNumber", currentPageNumber);
            }
            for (var i = currentIndex; i < maxLimit; i++) {
                prodList.push(AllProducts[i]);
            }
            if (prodList.length < maxGridLimit) {
                if (downloadNext == true) {
                    component.set('v.disableNextBtn', true);
                } else {
                    component.set('v.Spinner', true);
                    var searchBy = {};
                    searchBy.fromDate = component.get('v.FromDate');
                    searchBy.toDate = component.get('v.ToDate');
                    searchBy = JSON.stringify(searchBy);
                    helper.findProductNext(component, event, searchBy);
                }
            }
            component.set("v.Product", prodList);
            currentIndex = currentIndex + maxGridLimit;
            component.set("v.currentIndex", currentIndex);
        } else {
            component.set('v.disableNextBtn', true);
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
    handleActiveTab: function(component, event, helper) {
        try {
            var tab = event.getSource();
            tab = tab.get('v.id');
            component.set('v.activeTab', tab);
            component.set("v.DataColumns", [{
                    label: 'Product Code',
                    fieldName: 'prodCode',
                    type: 'text',
                    sortable: true,
                },
                {
                    label: 'Product Name',
                    fieldName: 'prodName',
                    type: 'text',
                    sortable: true,
                },
                {
                    label: 'Unit Price',
                    fieldName: 'prodPrice',
                    sortable: false,
                    type: 'currency',
                    typeAttributes: {
                        currencyCode: 'USD'
                    },
                    cellAttributes: {
                        iconName: {
                            fieldName: 'provenanceIconAuthPrice'
                        },
                        iconLabel: {
                            fieldName: 'provenanceIconAuthPriceLabel'
                        },
                        iconPosition: 'left',
                        class: {
                            fieldName: 'count'
                        }
                    }
                },
                {
                    label: 'Quantity',
                    fieldName: 'prodQuantity',
                    type: 'number',
                    sortable: true,
                },
                {
                    label: 'Description',
                    fieldName: 'prodDescription',
                    type: 'text',
                    sortable: true,
                },
                {
                    label: 'Source',
                    fieldName: 'prodSoftware',
                    initialWidth: 130,
                    type: 'text',
                    sortable: true,
                }
            ]);
            component.set("v.DataColumnsLogs", [{
                    label: 'Product Code',
                    fieldName: 'prodCode',
                    type: 'text',
                    sortable: true,
                },
                {
                    label: 'Product Name',
                    fieldName: 'prodName',
                    type: 'text',
                    sortable: true,
                },
                {
                    label: 'Unit Price',
                    fieldName: 'amount',
                    sortable: false,
                    type: 'currency',
                    typeAttributes: {
                        currencyCode: 'USD'
                    },
                    cellAttributes: {
                        iconName: {
                            fieldName: 'provenanceIconAuthPrice'
                        },
                        iconLabel: {
                            fieldName: 'provenanceIconAuthPriceLabel'
                        },
                        iconPosition: 'left',
                        class: {
                            fieldName: 'count'
                        }
                    }
                },
                {
                    label: 'Quantity',
                    fieldName: 'quantity',
                    type: 'number',
                    sortable: true,
                },
                {
                    label: 'Description',
                    fieldName: 'description',
                    type: 'text',
                    sortable: true,
                },
                {
                    label: 'Source',
                    fieldName: 'prodSoftware',
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
                component.set('v.Spinner', false);
                helper.getLog(component, event);
            } else {
                if (component.get('v.disableImportBtn')) {
                    component.set('v.disableExportBtn', true);
                } else {
                    component.set('v.disableExportBtn', false);
                }
                var ProductsDownloaded = component.get("v.ProductsDownloaded");
                if (ProductsDownloaded == false) {
                    component.set('v.disableDownloadBtn', false);
                }
            }
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    getProducts: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            component.set("v.currentIndex", 0);
            component.set("v.CurrentProductsCount", 0);
            component.set("v.downloadNext", true);
            component.set("v.AllProducts", []);
            helper.getProducts(component, event);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    findProducts: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            var searchBy = {};
            searchBy.fromDate = component.get('v.FromDate');
            searchBy.toDate = component.get('v.ToDate');
            searchBy = JSON.stringify(searchBy);
            component.set("v.currentIndex", 0);
            component.set("v.startLimit", 0);
            component.set("v.downloadNext", false);
            component.set("v.CurrentProductsCount", 0);
            component.set("v.AllProducts", []);
            helper.findProduct(component, event, searchBy);
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
    SelectProducts: function(component, event, helper) {
        try {
            var checkvalue = event.getSource().get("v.value");
            component.set('v.isSelectAll', checkvalue);
            var checkProduct = component.find("checkProduct");
            if (checkvalue == true) {
                for (var i = 0; i < checkProduct.length; i++) {
                    checkProduct[i].set("v.value", true);
                }
            } else {
                for (var i = 0; i < checkProduct.length; i++) {
                    checkProduct[i].set("v.value", false);
                }
            }
            var a = component.get('c.SelectSingleProduct');
            $A.enqueueAction(a);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    SelectSingleProduct: function(component, event, helper) {
        try {
            var ProductList = component.get('v.Product');
            var selectedProducts = [];
            var k = 0;
            for (var i = 0; i < ProductsList.length; i++) {
                var s = ProductsList[i];
                if (s.isSelected) {
                    selectedProducts[k] = s.Id;
                    k++;
                }
            }
            component.set('v.NoOfSelectedRecords', k);
            if (selectedProducts.length > 0) {
                component.set('v.disableImportBtn', false);
                component.set('v.disableExportBtn', false);
                component.set('v.selectedProducts', selectedProducts);
            } else {
                component.set('v.disableImportBtn', true);
                component.set('v.disableExportBtn', true);
            }
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    handleSort: function(component, event, helper) {
        d
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
            cmp.set('v.selectedProducts', selectedRows);
        } else {
            cmp.set('v.disableImportBtn', true);
            cmp.set('v.disableExportBtn', true);
        }
        cmp.set('v.NoOfSelectedRecords', selectedRows.length);
    },
    ImportProducts: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            component.set("v.isOpen", false);
            helper.importProducts(component, event);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    openModel: function(component, event, helper) {
        try {
            var whichOne = event.getSource().getLocalId();
            if (whichOne == 'Import') {
                component.set('v.modalTitle', 'Import Products');
                component.set('v.modalContent', whichOne);
            } else {
                component.set('v.modalTitle', 'Clear Import Log');
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
    },
    exportProduct: function(component, event, helper) {
        try {
            var tabName = component.get('v.activeTab');
            if (tabName == 'list') {
                var stockData = component.get("v.selectedProducts");
                if (stockData.length > 0) {
                    var csv = helper.convertProductToCSV(component, stockData);
                    if (csv == null) {
                        return;
                    }
                    var hiddenElement = document.createElement('a');
                    hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
                    hiddenElement.target = '_self';
                    hiddenElement.download = 'Products.csv';
                    document.body.appendChild(hiddenElement);
                    hiddenElement.click();
                } else {
                    helper.showToast('Please select records to export', 'Error');
                }
            } else {
                var stockData = component.get("v.productLog");
                if (stockData != null) {
                    var csv = helper.convertProductToCSV(component, stockData);
                    if (csv == null) {
                        return;
                    }
                    var hiddenElement = document.createElement('a');
                    hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
                    hiddenElement.target = '_self';
                    hiddenElement.download = 'ProductsLog.csv';
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
                component.set('v.modalTitle', 'Import Product');
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
    },
    exportProduct: function(component, event, helper) {
        try {
            var tabName = component.get('v.activeTab');
            if (tabName == 'list') {
                var stockData = component.get("v.selectedProducts");
                if (stockData.length > 0) {
                    var csv = helper.convertProductToCSV(component, stockData);
                    if (csv == null) {
                        return;
                    }
                    var hiddenElement = document.createElement('a');
                    hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
                    hiddenElement.target = '_self';
                    hiddenElement.download = 'Product.csv';
                    document.body.appendChild(hiddenElement);
                    hiddenElement.click();
                } else {
                    helper.showToast('Please select records to export', 'Error');
                }
            } else {
                var stockData = component.get("v.productLog");
                if (stockData.length > 0) {
                    var csv = helper.convertProductToCSV(component, stockData);
                    if (csv == null) {
                        return;
                    }
                    var hiddenElement = document.createElement('a');
                    hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
                    hiddenElement.target = '_self';
                    hiddenElement.download = 'ProductLog.csv';
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
                component.set('v.modalTitle', 'Import Product');
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
    },
})