({
    getAccounts: function(component, helper) {
        var action = component.get("c.fetchLogs");
        var selectedOptions = component.get("v.selectedOptions");
        var selections = [];
        selectedOptions.forEach(option => {
            selections.add(option.Name);
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var data;
            if (state === 'SUCCESS') {
                var result = response.getReturnValue();
                component.set("v.recordList", result);
                component.set("v.allData", result);
            }
        });
        $A.enqueueAction(action);
    },
    sortData: function(cmp, fieldName, sortDirection) {
        var fname = fieldName;
        var data = cmp.get("v.recordList");
        var reverse = sortDirection !== 'asc';
        data.sort(this.sortBy(fieldName, reverse))
        cmp.set("v.recordList", data);
    },
    sortBy: function(field, reverse) {
        var key = function(x) {
            return x[field]
        };
        reverse = !reverse ? 1 : -1;
        return function(a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    },
    closeAllDropDown: function() {
        Array.from(document.querySelectorAll('#ms-picklist-dropdown')).forEach(function(node) {
            node.classList.remove('slds-is-open');
        });
    },
    onDropDownClick: function(dropDownDiv) {
        var classList = Array.from(dropDownDiv.classList);
        if (!classList.includes("slds-is-open")) {
            this.closeAllDropDown();
            dropDownDiv.classList.add('slds-is-open');
        } else {
            this.closeAllDropDown();
        }
    },
    handleClick: function(component, event, where) {
        var tempElement = event.target;
        var outsideComponent = true;
        while (tempElement) {
            if (tempElement.id === 'ms-list-item') {
                if (where === 'component') {
                    this.onOptionClick(component, event.target);
                }
                outsideComponent = false;
                break;
            } else if (tempElement.id === 'ms-dropdown-items') {
                outsideComponent = false;
                break;
            } else if (tempElement.id === 'ms-picklist-dropdown') {
                if (where === 'component') {
                    this.onDropDownClick(tempElement);
                }
                outsideComponent = false;
                break;
            }
            tempElement = tempElement.parentNode;
        }
        if (outsideComponent) {
            this.closeAllDropDown();
        }
    },
    rebuildPicklist: function(component) {
        var allSelectElements = component.getElement().querySelectorAll("li");
        Array.from(allSelectElements).forEach(function(node) {
            node.classList.remove('slds-is-selected');
        });
    },
    filterDropDownValues: function(component, inputText) {
        var allSelectElements = component.getElement().querySelectorAll("li");
        Array.from(allSelectElements).forEach(function(node) {
            if (!inputText) {
                node.style.display = "block";
            } else if (node.dataset.name.toString().toLowerCase().indexOf(inputText.toString().trim().toLowerCase()) != -1) {
                node.style.display = "block";
            } else {
                node.style.display = "none";
            }
        });
    },
    setPickListName: function(component, selectedOptions) {
        const maxSelectionShow = component.get("v.maxSelectedShow");
        var selectionsList = [];
        if (selectedOptions.length < 1) {
            component.set("v.selectedLabel", component.get("v.msname"));
        } else if (selectedOptions.length > maxSelectionShow) {
            component.set("v.selectedLabel", selectedOptions.length + ' Options Selected');
        } else {
            var selections = '';
            selectedOptions.forEach(option => {
                selections += option.Name + ',';
            });
            component.set("v.selectedLabel", selections.slice(0, -1));
            if (!(selectedOptions.length < 1) && !(selectedOptions.length > maxSelectionShow)) {
                selectedOptions.forEach(option => {
                    selectionsList.push('' + option.Name);
                });
            }
        }
    },
    onOptionClick: function(component, ddOption) {
        var clickedValue = {
            "Id": ddOption.closest("li").getAttribute('data-id'),
            "Name": ddOption.closest("li").getAttribute('data-name')
        };
        var selectedOptions = component.get("v.selectedOptions");
        var alreadySelected = false;
        selectedOptions.forEach((option, index) => {
            if (option.Id === clickedValue.Id) {
                selectedOptions.splice(index, 1);
                alreadySelected = true;
                ddOption.closest("li").classList.remove('slds-is-selected');
            }
        });
        if (!alreadySelected) {
            selectedOptions.push(clickedValue);
            ddOption.closest("li").classList.add('slds-is-selected');
        }
        var selectionsList = [];
        const maxSelectionShow = component.get("v.maxSelectedShow");
        if (!(selectedOptions.length < 1) && !(selectedOptions.length > maxSelectionShow)) {
            selectedOptions.forEach(option => {
                selectionsList.push('' + option.Name);
            });
        }
        var action = component.get("c.FilterdfetchLogs");
        if (selectionsList != null) {
            action.setParams({
                LogLevel: selectionsList
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                var data;
                if (state === 'SUCCESS') {
                    var result = response.getReturnValue();
                    component.set("v.recordList", result);
                    component.set("v.allData", result);
                }
            });
            $A.enqueueAction(action);
        }
        this.setPickListName(component, selectedOptions);
    },
    convertArrayOfObjectsToCSV: function(component, objectRecords) {
        var csvStringResult, counter, keys, columnDivider, lineDivider;
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        columnDivider = ',';
        lineDivider = '\n';
        keys = ['Class Name', 'Method Name', 'Message', 'Logs Level'];
        csvStringResult = '';
        csvStringResult += keys.join(columnDivider);
        csvStringResult += lineDivider;
        var counter = 0;
        for (var i = 0; i < objectRecords.length; i++) {
            var rec = objectRecords[i];
            csvStringResult += '"' + rec.Ebiz_C__EBizCharge_Class_Name__c + '"';
            csvStringResult += columnDivider;
            csvStringResult += '"' + rec.Ebiz_C__EBizCharge_Method_Name__c + '"';
            csvStringResult += columnDivider;
            csvStringResult += '"' + rec.Ebiz_C__EBizCharge_Message__c + '"';
            csvStringResult += columnDivider;
            csvStringResult += '"' + rec.Ebiz_C__EBizCharge_Log_Level__c + '"';
            csvStringResult += columnDivider;
            csvStringResult += lineDivider;
            counter++;
        }
        return csvStringResult;
    },
    showToastMsg: function(msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            duration: '5000',
            mode: 'dismissible',
            message: msg,
            type: type,
            title: type + "!",
        });
        toastEvent.fire();
    },
});