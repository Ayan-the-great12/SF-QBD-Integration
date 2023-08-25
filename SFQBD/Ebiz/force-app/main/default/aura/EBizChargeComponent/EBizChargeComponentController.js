({
    doInit: function(component, event, helper) {
        try {
            helper.CheckCompSettings(component);
            var objectName = component.get('v.sObjectName');
            if (objectName.includes('__c')) {
                helper.UpdateConfigInfo(component, event, helper);
            }
            component.set("v.PendingListColumns", [{
                    label: 'Request Date and Time',
                    fieldName: 'PaymentRequestDateTime',
                    type: 'date',
                    hideDefaultActions: true,
                    sortable: false,
                    typeAttributes: {
                        day: 'numeric',
                        month: 'numeric',
                        year: 'numeric',
                        hour: '2-digit',
                        minute: '2-digit',
                        second: '2-digit',
                        hour12: false,
                    }
                },
                {
                    label: 'Request Type',
                    hideDefaultActions: true,
                    fieldName: 'methodType',
                    type: 'text',
                    sortable: false,
                },
                {
                    label: 'Source',
                    hideDefaultActions: true,
                    fieldName: 'Source',
                    type: 'text',
                    sortable: false,
                }
            ]);
            component.set("v.DataColumns", [{
                    label: 'Transaction Date and Time',
                    fieldName: 'formattedDateTimeTransaction',
                    type: 'date',
                    hideDefaultActions: true,
                    sortable: false,
                    typeAttributes: {
                        day: 'numeric',
                        month: 'numeric',
                        year: 'numeric',
                        hour: '2-digit',
                        minute: '2-digit',
                        second: '2-digit',
                        hour12: false,
                    }
                },
                {
                    label: 'Contact',
                    hideDefaultActions: true,
                    fieldName: 'transHyperURL',
                    type: 'url',
                    sortable: false,
                    typeAttributes: {
                        label: {
                            fieldName: 'contact'
                        },
                        target: '_self',
                        tooltip: 'Click to visit Contact'
                    }
                },
                {
                    label: 'Amount Paid',
                    hideDefaultActions: true,
                    fieldName: 'amountPaid',
                    type: 'currency',
                    typeAttributes: {
                        currencyCode: 'USD'
                    },
                    sortable: false,
                    cellAttributes: {
                        alignment: 'center'
                    }
                },
                {
                    label: 'Payment Method',
                    hideDefaultActions: true,
                    fieldName: 'paymentMethod',
                    type: 'text',
                    sortable: false,
                    cellAttributes: {
                        alignment: 'center',
                        class: {
                            fieldName: 'cardClass'
                        }
                    }
                },
                {
                    label: 'Reference #',
                    hideDefaultActions: true,
                    fieldName: 'refNum',
                    type: 'text',
                    sortable: false,
                },
                {
                  label: 'Type',
                  fieldName: 'TransType',
                  type: 'text',
                  hideDefaultActions: true,
                  sortable: false,
              },
            ]);
            component.set("v.RecPaymentColumns", [{
                    label: 'Transaction Date and Time',
                    fieldName: 'PaymentRequestDateTime',
                    type: 'date',
                    hideDefaultActions: true,
                    sortable: false,
                    typeAttributes: {
                        day: 'numeric',
                        month: 'numeric',
                        year: 'numeric',
                        hour: '2-digit',
                        minute: '2-digit',
                        second: '2-digit',
                        hour12: false,
                    }
                },
                {
                    label: 'Order #',
                    fieldName: 'OrderHyperUrl',
                    hideDefaultActions: true,
                    type: 'url',
                    sortable: false,
                    typeAttributes: {
                        label: {
                            fieldName: 'InvoiceNumber'
                        },
                        target: '_self',
                        tooltip: 'Click to visit account'
                    }
                },
                {
                    label: 'Amount Paid',
                    fieldName: 'PaidAmount',
                    hideDefaultActions: true,
                    sortable: false,
                    type: 'currency',
                    typeAttributes: {
                        currencyCode: 'USD'
                    },
                    cellAttributes: {
                        alignment: 'left',
                        iconName: {
                            fieldName: 'provenanceIconAuthAmount'
                        },
                        iconLabel: {
                            fieldName: 'provenanceIconAuthAmountLabel'
                        },
                        iconPosition: 'left'
                    }
                },
                {
                    label: 'Source',
                    fieldName: 'PaymentSourceId',
                    hideDefaultActions: true,
                    type: 'text',
                    sortable: false,
                    cellAttributes: {
                        iconName: {
                            fieldName: 'provenanceIconNameSource'
                        },
                        iconLabel: {
                            fieldName: 'provenanceIconLabelSource'
                        },
                        iconPosition: 'left'
                    }
                },
                {
                    label: 'Payment Method',
                    fieldName: 'Last4',
                    hideDefaultActions: true,
                    initialWidth: 170,
                    type: 'text',
                    sortable: false,
                    cellAttributes: {
                        alignment: 'center',
                        class: {
                            fieldName: 'cardClass'
                        }
                    }
                },
            ]);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
            component.set('v.Spinner', false);
        }
    },
    forceHandler: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            var objectName = component.get('v.sObjectName');
            if (objectName == 'Account' || objectName == 'Order' || objectName === 'Opportunity' || objectName === 'Quote') {
                var accId = component.get('v.recordId');
                var accFields = component.get("v.obj");
                if (objectName == 'Order') {
                    accId = accFields.AccountId;
                    component.set('v.AccountName', accFields.Account.Name);
                    component.set('v.Spinner', true);
                    helper.getAccountDetail(component, event);
                    helper.getTransactionsOrder(component, event, accFields);
                    helper.getPendingEmailRequests(component, event, accFields, objectName);
                    helper.getReceivedPaymentEmail(component, event, accFields, objectName);
                    helper.getPaymentMethods(component, event, accId);
                } else if (objectName == 'Opportunity') {
                    accId = accFields.AccountId;
                    component.set('v.AccountName', accFields.Account.Name);
                    component.set('v.Spinner', true);
                    helper.getAccountDetail(component, event);
                    helper.getTransactionsOpp(component, event, accFields);
                    helper.getPendingEmailRequests(component, event, accFields, objectName);
                    helper.getReceivedPaymentEmail(component, event, accFields, objectName);
                    helper.getPaymentMethods(component, event, accId);
                } else if (objectName == 'Quote') {
                    accId = accFields.AccountId;
                    component.set('v.AccountName', accFields.Account.Name);
                    component.set('v.Spinner', true);
                    helper.getAccountDetail(component, event);
                    helper.getTransactionsQuote(component, event, accFields);
                    helper.getPendingEmailRequests(component, event, accFields, objectName);
                    helper.getReceivedPaymentEmail(component, event, accFields, objectName);
                    helper.getPaymentMethods(component, event, accId);
                } else if (objectName == 'Account') {
                    component.set('v.Spinner', true);
                    component.set('v.isAccountObject', true);
                    helper.getAccountDetail(component, event);
                    component.set('v.AccountName', accFields.Name);
                    helper.getTransactionsAccount(component, event, accFields);
                    helper.getPendingEmailRequests(component, event, accFields, objectName);
                    helper.getPaymentMethods(component, event, accId);
                }
                component.set("v.VerifyAccount", accId);
                var RefNum = accFields.Ebiz_C__EBizCharge_Reference_Number__c;
                if (RefNum != null && RefNum != '') {
                    component.set('v.Spinner', true);
                    helper.getTransaction(component, event, RefNum);
                }
            } else if (objectName == 'Contact') {
                var ConFields = component.get("v.obj");
                var conId = component.get('v.recordId');
                helper.getContactDetail(component, event);
                component.set('v.Spinner', true);
                helper.getPendingEmailRequests(component, event, ConFields, objectName);
                helper.getTransactionsContact(component, event, ConFields);
                component.set('v.ContactName', ConFields.Name);
                helper.getPaymentMethodsContact(component, event, conId);
                component.set('v.Spinner', false);
            } else if (objectName.includes('__c')) {
                var custId = component.get('v.recordId');
                helper.UpdateCustomerInfo(component, event, custId);
                helper.getCustomDetail(component, event);
                component.set('v.isCustomObject', true);
                var delayInMilliseconds = 2000;
                setTimeout(function() {
                    helper.UpdateCustomerInternalId(component, event, custId);
                }, delayInMilliseconds);
                setTimeout(function() {
                    helper.getPaymentMethodsCustomCustomer(component, event, custId);
                }, delayInMilliseconds);
                component.set('v.Spinner', false);
            } else {
                component.set('v.Spinner', false);
                component.set("v.isDisable", true);
            }
        } catch (e) {
            component.set("v.isDisable", true);
            component.set('v.Spinner', false);
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    Refresher: function(component, event, helper) {
        try {
            component.set('v.Spinner', false);
            $A.get('e.force:refreshView').fire();
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    SetCmpConfiguration: function(component, event, helper) {
        try {
            component.set('v.showPopUp', true);
            component.set('v.clickedButton', event.getSource().get("v.value"));
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    PaymentMethodsHandler: function(component, event, helper) {
        try {
            component.set('v.showModalPayMethods', true);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    ClickHandler: function(component, event, helper) {
        try {
            if (component.get('v.isDisable')) {
                helper.showToastMsg('Please refresh the page and try again!', 'Error');
                return;
            }
            var objectName = component.get('v.sObjectName');
            component.set('v.showPopUp', true);
            component.set('v.clickedButton', event.getSource().get("v.value"));
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    ObjConfigModelHandle: function(component, event, helper) {
        helper.UpdateConfigxApeInfoClose(component, event, helper);
    },
    ObjConfigOnSave: function(component, event, helper) {
        component.set('v.Spinner', true);
        component.set("v.ShowObjConfigModel", false);
        helper.UpdateConfigxApeInfo(component, event, helper);
    },
    ViewHandler: function(component, event, helper) {
        try {
            var evt = $A.get("e.force:navigateToComponent");
            evt.setParams({
                componentDef: "c:EBizCharge_Transaction",
                target: "_blank",
                componentAttributes: {
                    RefNum: component.get('v.TransInfo.Ebiz_C__Ref_Number__c')
                }
            });
            evt.fire();
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    NavigationHandling: function(component, event, helper) {
        try {
            var id_to_pass;
            var evt = $A.get("e.force:navigateToComponent");
            var obj = component.get("v.obj");
            var objectname = component.get("v.sObjectName");
            if (objectname == 'Opportunity' || objectname == 'Order' || objectname == 'Quote') {
                id_to_pass = obj.Account.Id;
            }
            evt.setParams({
                componentDef: "c:EBizCharge_EmailPay",
                target: "_blank",
                componentAttributes: {
                    CallingComponent: id_to_pass
                }
            });
            evt.fire();
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    NavigationHandler: function(component, event, helper) {
        try {
            var Qbd_Customer_Id = component.get('v.QbdCustomerId');
            var id_to_pass;
            var evt = $A.get("e.force:navigateToComponent");
            var obj = component.get("v.obj");     
            var objectname = component.get("v.sObjectName");
            if (objectname == 'Opportunity' || objectname == 'Account') {
                id_to_pass = Qbd_Customer_Id;
            } else if (objectname == 'Order') {
                id_to_pass = obj.OrderNumber;
            } else if (objectname == 'Quote') {
                id_to_pass = obj.QuoteNumber;
            } else if (objectname.includes('__c')) {
                var customObj = component.get("v.CustomObjectDetail");
                id_to_pass = customObj.Ebiz_C__EBizCharge_CustomerId__c;
            } else {
                id_to_pass = obj.Id;
            }
            evt.setParams({
                componentDef: "c:EBizCharge_Transaction",
                target: "_blank",
                componentAttributes: {
                    RefNum: id_to_pass
                }
            });
            evt.fire();
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    handleChangeAmount: function(cmp, event) {
        var selectedOptionValue = event.getParam("value");
        var OBJ_config = cmp.get("v.ObjectConfig");
        OBJ_config.Ebiz_C__EBizAmountApi__c = selectedOptionValue;
        cmp.set('v.ObjectConfig', OBJ_config);
    },
    handleChangeEmail: function(cmp, event) {
        var selectedOptionValue = event.getParam("value");
        var OBJ_config = cmp.get("v.ObjectConfig");
        OBJ_config.Ebiz_C__EBizCustomerEmailApi__c = selectedOptionValue;
        cmp.set('v.ObjectConfig', OBJ_config);
    },
    handleChangeName: function(cmp, event) {
        var selectedOptionValue = event.getParam("value");
        var OBJ_config = cmp.get("v.ObjectConfig");
        OBJ_config.Ebiz_C__EBizCustomerNameApi__c = selectedOptionValue;
        cmp.set('v.ObjectConfig', OBJ_config);
    },
    selectedTextUpdated: function(cmp, event) {
        var selectedRows = event.getParam('selectedRows');
        var data = []
        if (selectedRows.length > 0) {
            selectedRows.map(function(rowData) {
                data.push(rowData);
            });
            cmp.set('v.RecordsSelected', selectedRows);
            cmp.set('v.disableButtonApply', false);
        } else {
            cmp.set('v.countSelectedRows', 0);
            cmp.set('v.RecordsSelected', null);
            cmp.set('v.disableButtonApply', true);
        }
        cmp.set('v.countSelectedRows', selectedRows.length);
    },
    handleSorting: function(component, event, helper) {
        var sortBy = event.getParam("fieldName");
        var sortDirection = event.getParam("sortDirection");
        component.set("v.sortBy", sortBy);
        component.set("v.sortDirection", sortDirection);
        helper.receivedSortData(component, sortBy, sortDirection);
    },
    applyPayments: function(component, event, helper) {
        try {
            var emailPayList = component.get("v.RecordsSelected");
            if (emailPayList == null) {
                helper.showToast('Please select atleast one Email Pay to Apply!', 'Error');
                return;
            }
            component.set('v.Spinner', true);
            helper.markAllPaymentsApply(component, event, emailPayList);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    handleSort: function(component, event, helper) {
        var sortBy = event.getParam("fieldName");
        var sortDirection = event.getParam("sortDirection");
        component.set("v.sortBy", sortBy);
        component.set("v.sortDirection", sortDirection);
        helper.sortData(component, sortBy, sortDirection);
    }
})