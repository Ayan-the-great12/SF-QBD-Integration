({
    doInit: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            helper.getProducts(component, event);
            component.set("v.DataColumns", [{
                    label: 'Product Code',
                    fieldName: 'HyperUrlProduct',
                    type: 'url',
                    sortable: true,
                    iconName: 'standard:product',
                    typeAttributes: {
                        label: {
                            fieldName: 'prodCode'
                        },
                        target: '_self',
                        tooltip: 'Click to visit account'
                    }
                },
                {
                    label: 'Product Name',
                    fieldName: 'prodName',
                    type: 'text',
                    sortable: true,
                    cellAttributes: {
                        iconName: {
                            fieldName: 'provenanceIconNameProductName'
                        },
                        iconLabel: {
                            fieldName: 'provenanceIconLabelProductName'
                        },
                        iconPosition: 'left'
                    }
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
                            fieldName: 'provenanceIconAuthAmount'
                        },
                        iconLabel: {
                            fieldName: 'provenanceIconAuthAmountLabel'
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
                    type: 'text',
                    sortable: true,
                    cellAttributes: {
                        iconName: {
                            fieldName: 'provenanceIconNameProductQuantity'
                        },
                        iconLabel: {
                            fieldName: 'provenanceIconLabelProductQuantity'
                        },
                        iconPosition: 'left'
                    }
                },
                {
                    label: 'Description',
                    fieldName: 'prodDescription',
                    type: 'text',
                    sortable: true,
                    cellAttributes: {
                        iconName: {
                            fieldName: 'provenanceIconNameProductDescription'
                        },
                        iconLabel: {
                            fieldName: 'provenanceIconLabelProductDescription'
                        },
                        iconPosition: 'left'
                    }
                },
            ]);
            component.set("v.DataColumnsLogs", [{
                    label: 'Product Code',
                    fieldName: 'HyperUrlProduct',
                    type: 'url',
                    sortable: true,
                    iconName: 'standard:product',
                    typeAttributes: {
                        label: {
                            fieldName: 'prodCode'
                        },
                        target: '_self',
                        tooltip: 'Click to visit account'
                    }
                },
                {
                    label: 'Product Name',
                    fieldName: 'prodName',
                    type: 'text',
                    sortable: true,
                    cellAttributes: {
                        iconName: {
                            fieldName: 'provenanceIconNameProductName'
                        },
                        iconLabel: {
                            fieldName: 'provenanceIconLabelProductName'
                        },
                        iconPosition: 'left'
                    }
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
                            fieldName: 'provenanceIconAuthAmount'
                        },
                        iconLabel: {
                            fieldName: 'provenanceIconAuthAmountLabel'
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
                    type: 'text',
                    sortable: true,
                    cellAttributes: {
                        iconName: {
                            fieldName: 'provenanceIconNameProductQuantity'
                        },
                        iconLabel: {
                            fieldName: 'provenanceIconLabelProductQuantity'
                        },
                        iconPosition: 'left'
                    }
                },
                {
                    label: 'Description',
                    fieldName: 'description',
                    type: 'text',
                    sortable: true,
                    cellAttributes: {
                        iconName: {
                            fieldName: 'provenanceIconNameProductDescription'
                        },
                        iconLabel: {
                            fieldName: 'provenanceIconLabelProductDescription'
                        },
                        iconPosition: 'left'
                    }
                },
                {
                    label: 'Upload Status',
                    fieldName: 'status',
                    type: 'text',
                    sortable: true,
                    cellAttributes: {
                        iconName: {
                            fieldName: 'provenanceIconNameUpload'
                        },
                        iconLabel: {
                            fieldName: 'provenanceIconNameUploads'
                        },
                        iconPosition: 'left'
                    }
                },
            ]);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    validateDate: function(component, event, helper) {
        try {
            var today = new Date();
            var fromDate = component.get('v.fromDate');
            var toDate = component.get('v.toDate');
            if (fromDate != '' && fromDate != null && toDate != null && toDate != '') {
                var fromDate = new Date(fromDate);
                var toDate = new Date(toDate);
                var timeDiffrence = toDate - fromDate;
                if (fromDate > toDate) {
                    component.set('v.disableFindBtn', true);
                    helper.showToast('End date should be greater than Start date!', 'Error');
                } else {
                    component.set('v.disableFindBtn', false);
                }
            } else {
                component.set('v.disableFindBtn', true);
            }
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    handleActiveTab: function(component, event, helper) {
        try {
            var tab = event.getSource();
            tab = tab.get('v.id');
            component.set('v.activeTab', tab);
            if (tab == 'log') {
                component.set('v.Spinner', true);
                helper.getUploadLog(component, event);
            } else {
                component.set('v.Spinner', true);
                helper.getProducts(component, event);
            }
            component.set('v.fromDate', null);
            component.set('v.toDate', null);
            component.set('v.disableFindBtn', false);
            component.set('v.disableUploadBtn', true);
            component.set('v.isSelectAll', false);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    FindProducts: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            helper.getProducts(component, event);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    clearDateRange: function(component, event, helper) {
        try {
            component.set('v.disableFindBtn', false);
            component.set('v.fromDate', null);
            component.set('v.toDate', null);
            component.set('v.Spinner', true);
            helper.getProducts(component, event);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    SelectAllProducts: function(component, event, helper) {
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
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    SelectSingleProduct: function(component, event, helper) {
        try {
            var productList = component.get('v.Products');
            var selectedProdIds = [];
            var k = 0;
            for (var i = 0; i < productList.length; i++) {
                var s = productList[i];
                if (s.isSelected) {
                    selectedProdIds[k] = s.Id;
                    k++;
                }
            }
            component.set('v.NoOfSelectedRecords', k);
            if (selectedProdIds.length > 0) {
                component.set('v.disableUploadBtn', false);
                component.set('v.selectedProdIds', selectedProdIds);
            } else {
                component.set('v.disableUploadBtn', true);
            }
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    handleSortLogs: function(component, event, helper) {
        var sortBy = event.getParam("fieldName");
        var sortDirection = event.getParam("sortDirection");
        component.set("v.sortBy", sortBy);
        component.set("v.sortDirection", sortDirection);
        helper.sortDataLogs(component, sortBy, sortDirection);
    },
    uploadProducts: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            component.set("v.isOpen", false);
            helper.syncProducts(component, event);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    clearLog: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            component.set("v.isOpen", false);
            helper.clearLog(component, event);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    openModel: function(component, event, helper) {
        try {
            var whichOne = event.getSource().getLocalId();
            if (whichOne == 'Upload') {
                component.set('v.modalTitle', 'Upload Products');
                component.set('v.modalContent', whichOne);
            } else {
                component.set('v.modalTitle', 'Clear Upload Log');
                component.set('v.modalContent', whichOne);
            }
            component.set("v.isOpen", true);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    updateSelectedText: function(cmp, event) {
        var selectedRows = event.getParam('selectedRows');
        var dataList = selectedRows.map(function(rowData) {
            return rowData.Id;
        });
        if (dataList.length > 0) {
            cmp.set('v.disableUploadBtn', false);
            cmp.set('v.NoOfSelectedRecords', dataList.length);
            cmp.set('v.selectedProdIds', dataList);
        } else {
            cmp.set('v.disableUploadBtn', true);
        }
    },
    handleSort: function(component, event, helper) {
        var sortBy = event.getParam("fieldName");
        var sortDirection = event.getParam("sortDirection");
        component.set("v.sortBy", sortBy);
        component.set("v.sortDirection", sortDirection);
        helper.sortData(component, sortBy, sortDirection);
    },
    closeModel: function(component, event, helper) {
        try {
            component.set("v.isOpen", false);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
})