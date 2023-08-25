({
    getDataCount: function(component, event) {
        var FromDate = component.get('v.FromDate');
        var ToDate = component.get('v.ToDate');
        var searchInput = component.get("v.searchInput");
        var action = component.get("c.getCustomersCountApxc");
        action.setParams({
            sDate: FromDate,
            eDate: ToDate,
            searchInput: searchInput
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseValue = response.getReturnValue();
                component.set("v.CurrentAccountsCount", responseValue);
                component.set('v.TotalAccounts', responseValue);
            }
        });
        $A.enqueueAction(action);
    },
    LoadNextData: function(component, event) {
        var searchInput = component.get("v.searchInput");
        var FromDate = component.get('v.FromDate');
        var ToDate = component.get('v.ToDate');
        var CurrentAccountsCount = component.get("v.CurrentAccountsCount");
        var maxGridLimit = component.get("v.maxGridLimit");
        var currentIndex = component.get("v.currentIndex");
        var payments = component.get("v.Payments");
        var AllPayments = component.get("v.SendRequestPayment");
        var customersMap = component.get("v.CustomersMap");
        var accountDate = component.get('v.AccountDate');
        var contactDate = component.get('v.ContactDate');
        var action = component.get("c.getCustomersApxc");
        action.setParams({
            sDate: FromDate,
            eDate: null,
            customersMap: customersMap,
            accountDate: accountDate,
            contactDate: contactDate,
            searchInput: searchInput 
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.Spinner', false);
                
                var responseValue = response.getReturnValue();
                var records = responseValue.customersData;
                var dataLength = records.length;
                if (dataLength > 0) {
                    for (var i = 0; i < dataLength; i++) {
                        AllPayments.push(records[i]);
                    }
                this.sortAccountsData(component, 'dateCreated', 'desc', AllPayments);
                component.set("v.AccountDate", responseValue.accountDate);
                component.set("v.ContactDate", responseValue.contactDate);
                component.set("v.CustomersMap", responseValue.customersMap);
                if(CurrentAccountsCount < AllPayments.length)
                {
                    component.set('v.disableNextBtn', false);
                }
                }
                else
                {
                    component.set("v.allDataFetched", true);
                }
                if(currentIndex < AllPayments.length && currentIndex % maxGridLimit != 0 && AllPayments.length <= CurrentAccountsCount)
                {
                    while(currentIndex % maxGridLimit != 0)
                    {
                        payments.push(AllPayments[currentIndex]);
                        currentIndex = currentIndex + 1;
                    }
                    component.set("v.currentIndex", currentIndex);
                    component.set("v.Payments", payments);
                }
            }
            else {
                var errors = response.getError();
                component.set('v.Spinner', false);
                this.showToast('Something went wrong ' + errors[0].message + '!', 'Error');
            }
            
        });
        $A.enqueueAction(action);
    },
    
    AllAccounts: function(component, event) {
        var FromDate = component.get('v.FromDate');
        var ToDate = component.get('v.ToDate');
        var searchInput = component.get("v.searchInput");
        var CurrentAccountsCount = component.get("v.CurrentAccountsCount");
        var AllPayments = component.get("v.SendRequestPayment");
        var customersMap = component.get("v.CustomersMap");
        var action = component.get("c.getCustomersApxc");
        action.setParams({
            sDate: FromDate,
            eDate: ToDate,
            customersMap: null,
            accountDate: null,
            contactDate: null,
            searchInput: searchInput
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseValue = response.getReturnValue();
                var records = responseValue.customersData;
                component.set("v.AccountDate", responseValue.accountDate);
                component.set("v.ContactDate", responseValue.contactDate);
                component.set("v.CustomersMap", responseValue.customersMap);
                var dataLength = records.length;
                var subset = [];
                if (dataLength > 0) {
                    for (var i = 0; i < dataLength; i++) {
                        AllPayments.push(records[i]);
                    }
                    component.set("v.FilterPayments", AllPayments);
                    this.sortAccountsData(component, 'dateCreated', 'desc', AllPayments);
                    var accounts = component.get("v.SendRequestPayment");
                    records = accounts;
                    var i;
                    var maxGridLimit = component.get("v.maxGridLimit");
                    if (dataLength <= maxGridLimit) {
                        component.set('v.disableNextBtn', true);
                    } else {
                        component.set('v.disableNextBtn', false);
                    }
                    maxGridLimit = (maxGridLimit > dataLength) ? dataLength : maxGridLimit;
                    for (i = 0; i < maxGridLimit; i++) {
                        subset.push(records[i]);
                    }
                    component.set("v.Payments", subset);
                    component.set('v.FromDate', FromDate);
                    component.set('v.ToDate', ToDate);
                    component.set("v.currentIndex", maxGridLimit);
                } else {
                    component.set("v.SendRequestPayment", null);
                    component.set("v.Payments", null);
                    component.set('v.Spinner', false);  
                }
                component.set('v.allData', subset);
                component.set('v.Spinner', false);
            } else {
                var errors = response.getError();
                component.set("v.SendRequestPayment", null);
                component.set("v.Payments", null);
                component.set('v.Spinner', false);
                this.showToast('Something went wrong ' + errors[0].message + '!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    sortNextData: function(fieldName, sortDirection, data) {
        var key = function(a) {
            return a[fieldName];
        }
        var reverse = sortDirection == 'asc' ? 1 : -1;
        data.sort(function(a, b) {
            var a = key(a) ? key(a).toLowerCase() : '';
            var b = key(b) ? key(b).toLowerCase() : '';
            return reverse * ((a > b) - (b > a));
        });
        return data;
    },
    sortAccountsData: function(component, fieldName, sortDirection, data) {
        var key = function(a) {
            return a[fieldName];
        }
        var reverse = sortDirection == 'asc' ? 1 : -1;
        data.sort(function(a, b) {
            var a = key(a) ? key(a).toLowerCase() : '';
            var b = key(b) ? key(b).toLowerCase() : '';
            return reverse * ((a > b) - (b > a));
        });
        component.set("v.SendRequestPayment", data);
    },
    getExpiringAccountsList: function(component, event) {
        var startLimit = component.get("v.startLimit");
        var endLimit = component.get("v.endLimit");
        var action = component.get("c.getExpiringCardsInfo");
        action.setParams({
            startLimit: startLimit,
            endLimit: endLimit
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
            }
        });
        $A.enqueueAction(action);
    },
    FilterdAccounts: function(component, event) {
        var FromDate = component.get('v.FromDate');
        var ToDate = component.get('v.ToDate');
        var CurrentAccountsCount = component.get("v.CurrentAccountsCount");
        var newSubset = component.get("v.FilterPayments");
        var fList = [];
        for (var i = 0; i < newSubset.length; i++) {
            var fdata = {};
            fdata.accEmail = newSubset[i].accEmail;
            fdata.accExtId = newSubset[i].accExtId;
            fdata.accId = newSubset[i].accId;
            fdata.accName = newSubset[i].accName;
            fdata.dateCreated = newSubset[i].dateCreated;
            fdata.isSelected = newSubset[i].isSelected
            fList.push(fdata);
        }
        var srAccounts = component.get('v.srAccounts');
        var ExpiringAccounts = component.get("v.ExpiringAccounts");
        var filterAction = component.get("c.FilteredAccountsApxc");
        filterAction.setParams({
            subset: fList,
            srAccounts: srAccounts,
            ExpiringAccounts: ExpiringAccounts,
            sDate: FromDate,
            eDate: ToDate
        });
        filterAction.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var filteredData = response.getReturnValue();
                    var dataLength = filteredData.length;
                    var subset = [];
                    var AllPayments = [];
                    component.set("v.SendRequestPayment", []);
                    if (dataLength > 0) {
                        for (var i = 0; i < dataLength; i++) {
                            AllPayments.push(filteredData[i]);
                        }
                        component.set("v.SendRequestPayment", AllPayments);
                        var i;
                        var maxGridLimit = component.get("v.maxGridLimit");
                        if (dataLength <= maxGridLimit) {
                            component.set('v.disableNextBtn', true);
                        } else {
                            component.set('v.disableNextBtn', false);
                        }
                        maxGridLimit = (maxGridLimit > dataLength) ? dataLength : maxGridLimit;
                        for (i = 0; i < maxGridLimit; i++) {
                            subset.push(filteredData[i]);
                        }
                        component.set("v.Payments", subset);
                        component.set("v.currentIndex", maxGridLimit);
                    }
                    component.set('v.Spinner', false);
                } else {
                    component.set('v.Spinner', false);
                    var errors = response.getError();
                    this.showToast('Something went wrong ' + errors[0].message + '!', 'Error');
                }
            }),
            $A.enqueueAction(filterAction);
    },
    sortData: function(component, fieldName, sortDirection) {
        var data = component.get("v.Payments");
        var key = function(a) {
            return a[fieldName];
        }
        var reverse = sortDirection == 'asc' ? 1 : -1;
        if (fieldName == 'dateCreated' || fieldName == 'accId') {
            data.sort(function(a, b) {
                var a = key(a) ? key(a) : '';
                var b = key(b) ? key(b) : '';
                return reverse * ((a > b) - (b > a));
            });
        } else if (fieldName == 'HyperUrlAccount') {
            var key = function(a) {
                return a['accName'];
            }
            data.sort(function(a, b) {
                var a = key(a) ? key(a).toLowerCase() : '';
                var b = key(b) ? key(b).toLowerCase() : '';
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
    getPaymentMethods: function(component, event, accId, Type) {
        var action = component.get('c.getCustPaymentMethodsApx');
        action.setParams({
            'AccountId': accId,
            Type: Type
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var resInfo = response.getReturnValue();
            if (state == "SUCCESS") {
                var payM = resInfo.savedPaymentMethods;
                var sCard = [];
                var sACH = [];
                for (var key in payM) {
                    var arr = [];
                    arr = key.toString().split('@');
                    if (arr[1] == 'C') {
                        sCard.push({
                            value: arr[0],
                            label: payM[key]
                        });
                    } else {
                        sACH.push({
                            value: arr[0],
                            label: payM[key]
                        });
                    }
                }
                component.set("v.savedCard", sCard);
                component.set("v.savedACH", sACH);
                var savedCard = [];
                var savedACH = [];
                if (resInfo.SavedPaymentMethodslist != null) {
                    var payM = resInfo.SavedPaymentMethodslist;
                    for (var i = 0; i < payM.length; i++) {
                        if (payM[i].MethodType == 'cc') {
                            savedCard.push(payM[i]);
                        } else {
                            savedACH.push(payM[i]);
                        }
                    }
                }
                component.set("v.savedCardList", savedCard);
                component.set("v.savedACHList", savedACH);
                component.set('v.Spinner', false);
                if (resInfo.AccountInfo != null) {
                    component.set("v.accountDetail", resInfo.AccountInfo);
                    component.set('v.showModalPayMethods', true);
                } else if (resInfo.ContactInfo != null) {
                    component.set("v.contactDetail", resInfo.ContactInfo);
                    component.set('v.showModalPayMethodsContact', true);
                }
            } else {
                component.set('v.Spinner', false);
                if (Type == 'Account') {
                    component.set('v.showModalPayMethods', true);
                } else if (Type == 'Contact') {
                    component.set('v.showModalPayMethodsContact', true);
                }
            }
            component.set('v.Spinner', false);
            if (Type == 'Account') {
                component.set('v.showModalPayMethods', true);
            } else if (Type == 'Contact') {
                component.set('v.showModalPayMethodsContact', true);
            }
        });
        $A.enqueueAction(action);
    },
    getAccountDetail: function(component, event, accId, Type) {
        var action = component.get('c.getDetailApxc');
        action.setParams({
            "recordId": accId,
            "ObjectName": 'Account',
        });
        action.setCallback(this, function(response) {});
        $A.enqueueAction(action);
    },
    convertArrayOfObjectsToCSV: function(component, objectRecords) {
        var csvStringResult, counter, keys, columnDivider, lineDivider;
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        columnDivider = ',';
        lineDivider = '\n';
        keys = ['TYPE', 'ACCOUNT/CONTACT NAME', 'DATE CREATED', 'EMAIL'];
        csvStringResult = '';
        csvStringResult += keys.join(columnDivider);
        csvStringResult += lineDivider;
        var counter = 0;
        for (var i = 0; i < objectRecords.length; i++) {
            var rec = objectRecords[i];
            csvStringResult += '"' + rec.objectName + '"';
            csvStringResult += columnDivider;
            csvStringResult += '"' + rec.accName + '"';
            csvStringResult += columnDivider;
            csvStringResult += '"' + rec.dateCreated + '"';
            csvStringResult += columnDivider;
            csvStringResult += '"' + rec.accEmail + '"';
            csvStringResult += lineDivider;
            counter++;
        }
        return csvStringResult;
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
    showToastMsg: function(msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            duration: ' 5000',
            mode: 'dismissible',
            message: msg,
            type: type,
            title: type + "!",
        });
        toastEvent.fire();
    },
})