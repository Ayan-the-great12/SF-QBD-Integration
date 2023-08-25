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
        var year = [];
        for (var i = 0; i <= 9; i++) {
            year.push({
                key: todayYear,
                value: todayYear
            });
            todayYear++;
        }
        component.set('v.yearList', year);
        component.set('v.accountHolderName' , component.get('v.accInfo.Name'));
        component.set('v.routingNumber' , component.get('v.accInfo.ABA__c'));
        component.set('v.accountNumber' , component.get('v.accInfo.DDA_Enc__c'));
        component.set('v.accountType' , component.get('v.accInfo.DDA_Type__c'));
        component.set('v.ABA_Debit', component.get('v.accInfo.ABA_Debit__c'));
        component.set('v.DDA_Debit', component.get('v.accInfo.DDA_Enc_Debit__c'));
        component.set('v.DDA_Debit_Type', component.get('v.accInfo.DDA_Debit_Type__c'));
        component.set('v.CardInfo' , component.get('v.savedCardList'));
        helper.getAccountDetail(component, event);
        component.set('v.Spinner', true);
    },
    handleActiveTab: function(component, event, helper) {
        var ACHList = component.get('v.savedACHList');
        var tab = event.getSource();
        tab = tab.get('v.id');
        component.set('v.SelectedTab', tab);
        if (tab == 'CreditCard') {
            component.set('v.selectedACH', 'addnewach');
            component.set('v.enableReadOnly', false);
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
            var numberOfTimeLaod = component.get('v.numberOfTimeExecute');
            if(numberOfTimeLaod == 0){
                component.set('v.enableReadOnly', false);
               //#region Set the priority
                var ABA = component.get('v.accInfo.ABA_Debit__c');
                var DDA = component.get('v.accInfo.DDA_Enc_Debit__c');
                var DDA_Type = component.get('v.accInfo.DDA_Debit_Type__c');
                if(ABA == null || ABA == '' || ABA == undefined){
                    component.set('v.accInfo.ABA__c' , component.get('v.routingNumber'));
                }else{
                    component.set('v.accInfo.ABA__c' , component.get('v.ABA_Debit'));
                }
                if(DDA == null || DDA == '' || DDA == undefined){
                    component.set('v.accInfo.DDA_Enc__c' , component.get('v.accountNumber'));
                }else{
                    component.set('v.accInfo.DDA_Enc__c' , component.get('v.DDA_Debit'));
                }
                if(DDA_Type == null || DDA_Type == '' || DDA_Type == undefined){
                    component.set('v.accInfo.DDA_Type__c' , component.get('v.accountType'));
                }else{
                    component.set('v.accInfo.DDA_Type__c' , component.get('v.DDA_Debit_Type'));
                }
                //#endregion priority set
                    component.set('v.accountHolderName' , component.get('v.accInfo.Name'));
                    component.set('v.accountNickName' , '');
                    var cd = component.find("setACHdefault");
                    cd.set("v.value", false);
                    if(component.get('v.accountHolderName')!=null && component.get('v.accInfo.ABA__c')!=null && component.get('v.accInfo.DDA_Type__c')!=null && component.get('v.accInfo.DDA_Enc__c')!=null){
                        component.set('v.disableSubmitBtn',false);
                    }else{
                        component.set('v.disableSubmitBtn',true);
                    }
                    numberOfTimeLaod = numberOfTimeLaod + 1;
                    component.set('v.numberOfTimeExecute' , numberOfTimeLaod);
                    //#region prevent for pre-population for same card
                if(ACHList.length > 0){
                    var updatedRoutingNumber = component.get('v.accInfo.ABA__c');
                    var updatingAccountNumber = component.get('v.accInfo.DDA_Enc__c');
                if(updatedRoutingNumber == null || updatedRoutingNumber == undefined || updatedRoutingNumber == ''){
                    component.set('v.accInfo.ABA__c', ''); 
                }else{
                    var routeLength = updatedRoutingNumber.length;
                    var routeNumberMatcher = updatedRoutingNumber.substring(routeLength-4, routeLength);
                    for (var i = 0; i<ACHList.length; i++) {
                        var ach = ACHList[i];
                        var routingLength =  ach.Routing.length;
                        var routingNumber = ach.Routing.substring(routingLength-4, routingLength);
                        if(routingNumber == routeNumberMatcher){
                            var accountNumberLength = updatingAccountNumber.length;
                            var accountNumberMatcher = updatingAccountNumber.substring(accountNumberLength-4, accountNumberLength);
                            var acclength = ach.Account.length;
                            var accountNumber = ach.Account.substring(acclength-4, acclength);
                            if(accountNumber == accountNumberMatcher){
                            component.set('v.routeMatch',true);
                            }
                        }
                    }
                }
                if(updatingAccountNumber == null || updatingAccountNumber == undefined || updatingAccountNumber == ''){
                    component.set('v.accInfo.DDA_Enc__c', '');
                }else{
                    var accountNumberLength = updatingAccountNumber.length;
                    var accountNumberMatcher = updatingAccountNumber.substring(accountNumberLength-4, accountNumberLength);
                    for (var i = 0; i<ACHList.length; i++) {
                     var ach = ACHList[i];
                     var acclength = ach.Account.length;
                     var accountNumber = ach.Account.substring(acclength-4, acclength);
                     if(accountNumber == accountNumberMatcher){
                        var routingLength =  ach.Routing.length;
                        var routingNumber = ach.Routing.substring(routingLength-4, routingLength);
                        var accountNumberLength = updatingAccountNumber.length;
                        var accountNumberMatcher = updatingAccountNumber.substring(accountNumberLength-4, accountNumberLength);
                        if(routingNumber == routeNumberMatcher){ 
                        component.set('v.accountMatch',true);
                        }
                     }
                    }
                }    
                   var routeMatcher = component.get('v.routeMatch');
                   var accountMatcher = component.get('v.accountMatch');
                   if(routeMatcher && accountMatcher){
                      component.set('v.accInfo.ABA__c', '');
                      component.set('v.accInfo.DDA_Enc__c', '');
                      component.set('v.accInfo.DDA_Type__c','');
                   }
                } 
                    //#endregion prevent for pre-population for same card
            }else{
                component.set('v.accountHolderName' , component.get('v.accInfo.Name'));
                component.set('v.accInfo.ABA__c','');
                component.set('v.accInfo.DDA_Enc__c' ,'');
                component.set('v.accInfo.DDA_Type__c' ,'');
                component.set('v.accountNickName' , '');
                component.set('v.enableReadOnly', false);
                var cd = component.find("setACHdefault");
                cd.set("v.value", false);
                component.set('v.disableSubmitBtn',true); 
            }
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
            component.set('v.CardInfo.CardCode', val.substring(0, 4));
        }
    },
    validateFormAC: function(component, event, helper) {
        var allValid = component.find('req-fields').reduce(function(validSoFar, inputCmp) {
            return validSoFar && !inputCmp.get('v.validity').valueMissing;
        }, true);
        if (allValid) {
            if (component.get('v.selectedCard') != 'addnewcard') {
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
    checkRoutLength: function(component, event, helper) {
        var a = component.get('c.validateFormACH');
        $A.enqueueAction(a);
    },
    checkAccountLength: function(component, event, helper) {
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
    checkAccountNickName: function(component, event, helper){},
    ACHHandler: function(component, event, helper) {
        var ACHList = component.get('v.savedACHList');
        var selectedItem = event.currentTarget;
        var id = selectedItem.dataset.id;
        if (id != 0) {
            //#region Saved Bank Region
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
                    component.set('v.accountHolderName' , ach.AccountHolderName);
                    component.set('v.accInfo.ABA__c' , ach.Routing);
                    component.set('v.accInfo.DDA_Enc__c' , ach.Account);
                    component.set('v.accInfo.DDA_Type__c' , ach.AccountType);
                    component.set('v.accountNickName' , ach.MethodName);
                    break;
                }
            }
            //#endregion Saved Bank Region
        } else {
            //#region Add New Bank Account
            component.set('v.selectedACH', 'addnewach');
            component.set('v.disableUpdateBtn', true);
            component.set('v.enableReadOnly', false);
            component.set('v.accountHolderName' , component.get('v.accInfo.Name'));
            component.set('v.accInfo.ABA__c','');
            component.set('v.accInfo.DDA_Enc__c' ,'');
            component.set('v.accInfo.DDA_Type__c' ,'');
            component.set('v.accountNickName' , '');
            var cd = component.find("setACHdefault");
            cd.set("v.value", false);
            component.set('v.disableSubmitBtn',true);
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
        //#endregion Add New Bank Account
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