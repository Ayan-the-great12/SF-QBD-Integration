({
    doInit: function(component, event, helper) {
        var month = [];
        for (var i = 1; i <= 12; i++) {
            month.push({
                'label': (i < 10) ? '0' + i : '' + i,
                'value': (i < 10) ? '0' + i : '' + i
            });
        }
        component.set('v.monthList', month);
        var today = new Date();
        var todayYear = today.getFullYear();
        var options = [];
        for (var i = 0; i <= 9; i++) {
            options.push({
                'label': (i < 10) ? '202' + i : i,
                'value': (i < 10) ? '202' + i : i
            });
            todayYear++;
        }
        component.set('v.yearList', options);
    },
    handleActiveTab: function(component, event, helper) {
        var tab = event.getSource();
        tab = tab.get('v.id');
        component.set('v.SelectedTab', tab);
        if (tab == 'CreditCard') {
            component.set('v.selectedACH', 'addnewach');
            var Elements = component.find('tab');
            for (var i = 0; i < Elements.length; i++) {
                var ele = Elements[i].getElement();
                if (ele != null) {
                    var val = ele.getAttribute('data-id');
                    if (val != 0) {
                        $A.util.removeClass(Elements[i], "slds-is-active");
                    } else {
                        $A.util.addClass(Elements[i], "slds-is-active");
                    }
                }
            }
        } else {
            component.set('v.selectedCard', 'addnewcard');
            var Elements = component.find('tabACH');
            for (var i = 0; i < Elements.length; i++) {
                var ele = Elements[i].getElement();
                if (ele != null) {
                    var val = ele.getAttribute('data-id');
                    if (val != 0) {
                        $A.util.removeClass(Elements[i], "slds-is-active");
                    } else {
                        $A.util.addClass(Elements[i], "slds-is-active");
                    }
                }
            }
        }
        helper.resetObject(component, event);
    },
    checkDefault: function(component, event, helper) {
        var checkbox = event.getSource().get("v.value");
        component.set('v.isDefault', checkbox);
    },
    checkLengthCard: function(component, event, helper) {
        var val = component.get('v.CardInfo.CardNumber');
        if (val.length > 16) {
            component.set('v.CardInfo.CardNumber', val.substring(0, 16));
        }
        var a = component.get('c.validateFormAC');
        $A.enqueueAction(a);
    },
    checkLengthZip: function(component, event, helper) {
        var val = component.get('v.CardInfo.AvsZip');
        if (val.length > 10) {
            component.set('v.CardInfo.AvsZip', val.substring(0, 10));
        }
        var a = component.get('c.validateFormAC');
        $A.enqueueAction(a);
    },
    checkLengthCVC: function(component, event, helper) {
        var val = component.get('v.CardInfo.CardCode');
        if (val.length > 4) {
            component.set('v.CardInfo.CardCVC', val.substring(0, 4));
        }
    },
    validateFormAC: function(component, event, helper) {
        var allValid = component.find('req-fields').reduce(function(validSoFar, inputCmp) {
            return validSoFar && !inputCmp.get('v.validity').valueMissing;
        }, true);
        if (allValid) {
            if (component.get('v.selectedCard') != 'addnewcard') {
                component.set('v.disableUpdateBtn', false);
                component.set('v.enableReadOnly', false);
            } else {
                component.set('v.disableSubmitBtn', false);
                component.set('v.enableReadOnly', false);
            }
        } else {
            component.set('v.disableSubmitBtn', true);
            component.set('v.disableUpdateBtn', true);
            component.set('v.enableReadOnly', false);
        }
    },
    checkRoutLength: function(component, event, helper) {
        var val = component.get('v.AChInfo.Routing');
        if (val.length > 9) {
            component.set('v.AChInfo.Routing', val.substring(0, 9));
        }
        var a = component.get('c.validateFormACH');
        $A.enqueueAction(a);
    },
    checkAccountLength: function(component, event, helper) {
        var val = component.get('v.AChInfo.Account');
        if (val.length > 9) {}
        var a = component.get('c.validateFormACH');
        $A.enqueueAction(a);
    },
    validateFormACH: function(component, event, helper) {
        var allValid = component.find('reqfield').reduce(function(validSoFar, inputCmp) {
            return validSoFar && !inputCmp.get('v.validity').valueMissing;
        }, true);
        if (allValid) {
            if (component.get('v.selectedACH') != 'addnewach') {
                component.set('v.disableUpdateBtn', false);
                component.set('v.enableReadOnly', true);
            } else {
                component.set('v.disableSubmitBtn', false);
                component.set('v.enableReadOnly', false);
            }
        } else {
            component.set('v.disableSubmitBtn', true);
            component.set('v.disableUpdateBtn', true);
            component.set('v.enableReadOnly', false);
        }
    },
    CardHandler: function(component, event, helper) {
        var Card = {};
        var CardsList = component.get('v.savedCardList');
        var selectedItem = event.currentTarget;
        var id = selectedItem.dataset.id;
        if (id != 0) {
            component.set('v.disableSubmitBtn', true);
            component.set('v.disableUpdateBtn', false);
            component.set('v.enableReadOnly', true);
            for (var i = 0; CardsList.length; i++) {
                var cc = CardsList[i];
                if (cc.MethodID == id) {
                    component.set('v.selectedCard', ' ending in ');
                    var cd = component.find("setCCdefault");
                    if (cc.SecondarySort == 0) {
                        cd.set("v.value", true);
                    } else {
                        cd.set("v.value", false);
                    }
                    component.set('v.CardInfo', cc);
                    break;
                }
            }
        } else {
            component.set('v.selectedCard', 'addnewcard');
            component.set('v.disableUpdateBtn', true);
            component.set('v.enableReadOnly', false);
            helper.resetObject(component, event);
        }
        var Elements = component.find('tab');
        for (var i = 0; i < Elements.length; i++) {
            var val = Elements[i].getElement().getAttribute('data-id');
            if (val != id) {
                $A.util.removeClass(Elements[i], "slds-is-active");
            } else {
                $A.util.addClass(Elements[i], "slds-is-active");
            }
        }
    },
    ACHHandler: function(component, event, helper) {
        var Card = {};
        var ACHList = component.get('v.savedACHList');
        var selectedItem = event.currentTarget;
        var id = selectedItem.dataset.id;
        if (id != 0) {
            component.set('v.disableSubmitBtn', true);
            component.set('v.disableUpdateBtn', false);
            component.set('v.enableReadOnly', true);
            for (var i = 0; ACHList.length; i++) {
                var ach = ACHList[i];
                if (ach.MethodID == id) {
                    component.set('v.selectedACH', ' ending in ');
                    var cd = component.find("setACHdefault");
                    if (ach.SecondarySort == 0) {
                        cd.set("v.value", true);
                    } else {
                        cd.set("v.value", false);
                    }
                    component.set('v.AChInfo', ach);
                    break;
                }
            }
        } else {
            component.set('v.selectedACH', 'addnewach');
            component.set('v.disableUpdateBtn', true);
            component.set('v.enableReadOnly', false);
            helper.resetObject(component, event);
        }
        var Elements = component.find('tabACH');
        for (var i = 0; i < Elements.length; i++) {
            var val = Elements[i].getElement().getAttribute('data-id');
            if (val != id) {
                $A.util.removeClass(Elements[i], "slds-is-active");
            } else {
                $A.util.addClass(Elements[i], "slds-is-active");
            }
        }
    },
    DeleteHandler: function(component, event, helper) {
        component.set("v.isDelete", true);
        var SelectedTab = component.get('v.SelectedTab');
        if (SelectedTab == 'CreditCard') {
            component.set('v.DelThisMethod', component.get('v.CardInfo.MethodID'));
        } else {
            component.set('v.DelThisMethod', component.get('v.AChInfo.MethodID'));
        }
    },
    UpdateHandler: function(component, event, helper) {
        component.set("v.Spinner", true);
        helper.updatePaymentMethod(component, event);
    },
    SaveHandler: function(component, event, helper) {
        component.set("v.Spinner", true);
        helper.addPaymentMethod(component, event);
    },
    DeletePaymentMethod: function(component, event, helper) {
        component.set("v.isDelete", false);
        component.set("v.Spinner", true);
        helper.deletePaymentMethod(component, event);
    },
    returnToScreen: function(component, event, helper) {
        component.set("v.isDelete", false);
        $A.get('e.force:refreshView').fire();
    },
    UpdateRetryHandler: function(component, event, helper) {
        component.set('v.Spinner', true);
        helper.voidTransactionWithoutReload(component, event);
    },
    AcceptTransactionHandler: function(component, event, helper) {
        component.set('v.Spinner', true);
        component.set('v.isAVSCheck', false);
        helper.voidAVSTransaction(component, event);
        component.set('v.Spinner', true);
        var ac = component.get('v.avsAction');
        if (ac == 'Update') {
            helper.updatePaymentMethod(component, event);
        } else {
            helper.addPaymentMethod(component, event);
        }
    },
    CancelTransactionHandler: function(component, event, helper) {
        component.set('v.avsCheckAction', 'Cancel');
        component.set('v.avsCheckModalHeader', 'Void a Transaction');
    },
    cancelHandler: function(component, event, helper) {
        component.set('v.avsCheckModalHeader', 'Security Mismatch');
        component.set('v.avsCheckAction', 'Mismatch');
    },
    voideHandler: function(component, event, helper) {
        component.set('v.Spinner', true);
        helper.voidTransaction(component, event);
    },
    closeModel: function(component, event, helper) {
        component.set("v.isOpen", false);
    },
})