({
    doInit: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            helper.getOrders(component, event);
            component.set("v.DataColumns", [{
                    label: 'Order #',
                    fieldName: 'HyperUrlOrder',
                    type: 'url',
                    sortable: true,
                    iconName: 'standard:orders',
                    typeAttributes: {
                        label: {
                            fieldName: 'OrderNumber'
                        },
                        target: '_self',
                        tooltip: 'Click to visit account'
                    }
                },
                {
                    label: 'Account / Contact Name',
                    fieldName: 'HyperUrlAccount',
                    type: 'url',
                    sortable: true,
                    iconName: 'standard:account',
                    typeAttributes: {
                        label: {
                            fieldName: 'accName'
                        },
                        target: '_self',
                        tooltip: 'Click to visit account'
                    }
                },
                {
                    label: 'Email',
                    fieldName: 'accEmail',
                    type: 'text',
                    sortable: true,
                    cellAttributes: {
                        iconName: {
                            fieldName: 'provenanceIconNameEmail'
                        },
                        iconLabel: {
                            fieldName: 'provenanceIconLabelEmail'
                        },
                        iconPosition: 'left'
                    }
                },
                {
                    label: 'Order Date',
                    fieldName: 'CreatedDate',
                    type: 'date',
                    typeAttributes: {
                        day: 'numeric',
                        month: 'short',
                        year: 'numeric',
                        hour: '2-digit',
                        minute: '2-digit',
                        second: '2-digit',
                        hour12: false,
                    },
                    sortable: true,
                    cellAttributes: {
                        iconName: 'utility:date_input',
                        iconPosition: 'left'
                    }
                },
                {
                    label: 'Amount',
                    fieldName: 'TotalAmount',
                    sortable: true,
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
                    label: 'Balance',
                    fieldName: 'Order_balance',
                    sortable: true,
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
                }
            ]);
            component.set("v.DataColumnsLogs", [{
                    label: 'Order #',
                    fieldName: 'HyperUrlOrder',
                    type: 'url',
                    sortable: true,
                    iconName: 'standard:orders',
                    typeAttributes: {
                        label: {
                            fieldName: 'ordNumber'
                        },
                        target: '_self',
                        tooltip: 'Click to visit account'
                    }
                },
                {
                    label: 'Account / Contact Name',
                    fieldName: 'HyperUrlAccount',
                    type: 'url',
                    sortable: true,
                    iconName: 'standard:account',
                    typeAttributes: {
                        label: {
                            fieldName: 'accName'
                        },
                        target: '_self',
                        tooltip: 'Click to visit account'
                    }
                },
                {
                    label: 'Email',
                    fieldName: 'email',
                    type: 'text',
                    sortable: true,
                    cellAttributes: {
                        iconName: {
                            fieldName: 'provenanceIconNameEmail'
                        },
                        iconLabel: {
                            fieldName: 'provenanceIconLabelEmail'
                        },
                        iconPosition: 'left'
                    }
                },
                {
                    label: 'Order Date',
                    fieldName: 'ordDate',
                    type: 'date',
                    sortable: true,
                    cellAttributes: {
                        iconName: 'utility:date_input',
                        iconPosition: 'left'
                    }
                },
                {
                    label: 'Order Amount',
                    fieldName: 'amount',
                    sortable: true,
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
                    label: 'Balance',
                    fieldName: 'balance',
                    sortable: true,
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
    handleCompEvent: function(component, event, helper) {
        try {
            var actionName = event.getParam("actionName");
            var objectName = event.getParam("objectName");
            if (actionName == 'showGrid') {
                /*if(objectName == 'account'){
                component.set('v.selectedLookUpOrdRecord',null);    
            }else if(objectName == 'Order'){
                component.set('v.selectedLookUpAccRecord',null);
            } 
            */
            } else {
                component.set('v.Spinner', true);
                helper.getOrders(component, event);
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
                helper.getOrders(component, event);
            }
            component.set('v.fromDate', null);
            component.set('v.toDate', null);
            component.set('v.disableFindBtn', false);
            component.set('v.disableUploadBtn', true);
            component.set('v.isSelectAll', false);
            component.set('v.NoOfOrders', 0);
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
                if (timeDiffrence <= 0) {
                    component.set('v.disableFindBtn', true);
                    helper.showToast('End date should be greater than start date!', 'Error');
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
    searchOrder: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            helper.getOrders(component, event);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    FindOrder: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            helper.getOrders(component, event);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    clearDateRange: function(component, event, helper) {
        try {
            component.set('v.fromDate', null);
            component.set('v.toDate', null);
            component.set('v.disableFindBtn', false);
            component.set('v.Spinner', true);
            helper.getOrders(component, event);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    SelectAllOrders: function(component, event, helper) {
        try {
            var checkvalue = event.getSource().get("v.value");
            component.set('v.isSelectAll', checkvalue);
            var checkOrder = component.find("checkOrder");
            if (checkvalue == true) {
                for (var i = 0; i < checkOrder.length; i++) {
                    checkOrder[i].set("v.value", true);
                }
            } else {
                for (var i = 0; i < checkOrder.length; i++) {
                    checkOrder[i].set("v.value", false);
                }
            }
            var a = component.get('c.SelectSingleOrder');
            $A.enqueueAction(a);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    SelectSingleOrder: function(component, event, helper) {
        try {
            var orderList = component.get('v.Orders');
            var selectedOrders = [];
            var k = 0;
            for (var i = 0; i < orderList.length; i++) {
                var s = orderList[i];
                if (s.isSelected) {
                    selectedOrders[k] = s;
                    k++;
                }
            }
            component.set('v.NoOfOrders', k);
            if (selectedOrders.length > 0) {
                component.set('v.disableUploadBtn', false);
                component.set('v.selectedOrders', selectedOrders);
            } else {
                component.set('v.disableUploadBtn', true);
            }
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    uploadOrders: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            component.set("v.isOpen", false);
            helper.syncOrders(component, event);
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
                component.set('v.modalTitle', 'Upload Orders');
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
    handleSort: function(component, event, helper) {
        var sortBy = event.getParam("fieldName");
        var sortDirection = event.getParam("sortDirection");
        component.set("v.sortBy", sortBy);
        component.set("v.sortDirection", sortDirection);
        helper.sortData(component, sortBy, sortDirection);
    },
    handleSortLogs: function(component, event, helper) {
        var sortBy = event.getParam("fieldName");
        var sortDirection = event.getParam("sortDirection");
        component.set("v.sortBy", sortBy);
        component.set("v.sortDirection", sortDirection);
        helper.sortDataLog(component, sortBy, sortDirection);
    },
    updateSelectedText: function(cmp, event) {
        var selectedRows = event.getParam('selectedRows');
        if (selectedRows.length > 0) {
            cmp.set('v.selectedOrders', selectedRows);
            cmp.set('v.disableUploadBtn', false);
        } else {
            cmp.set('v.disableUploadBtn', true);
        }
        cmp.set('v.NoOfOrders', selectedRows.length);
    },
    closeModel: function(component, event, helper) {
        try {
            component.set("v.isOpen", false);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
})