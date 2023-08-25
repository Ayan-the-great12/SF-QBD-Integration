({
    onfocus: function(component, event, helper) {
        try {
            $A.util.addClass(component.find("mySpinner"), "slds-show");
            var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            var getInputkeyWord = '';
            var getParentId = component.get("v.parentId");
            helper.searchHelper(component, event, getInputkeyWord, getParentId);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    onblur: function(component, event, helper) {
        try {
            component.set("v.listOfSearchRecords", null);
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    keyPressController: function(component, event, helper) {
        try {
            var getParentId = component.get("v.parentId");
            var getInputkeyWord = component.get("v.SearchKeyWord");
            if (getInputkeyWord.length > 0) {
                var forOpen = component.find("searchRes");
                $A.util.addClass(forOpen, 'slds-is-open');
                $A.util.removeClass(forOpen, 'slds-is-close');
                helper.searchHelper(component, event, getInputkeyWord, getParentId);
            } else {
                component.set("v.listOfSearchRecords", null);
                var forclose = component.find("searchRes");
                $A.util.addClass(forclose, 'slds-is-close');
                $A.util.removeClass(forclose, 'slds-is-open');
            }
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    clear: function(component, event, heplper) {
        try {
            var pillTarget = component.find("lookup-pill");
            var lookUpTarget = component.find("lookupField");
            $A.util.addClass(pillTarget, 'slds-hide');
            $A.util.removeClass(pillTarget, 'slds-show');
            $A.util.addClass(lookUpTarget, 'slds-show');
            $A.util.removeClass(lookUpTarget, 'slds-hide');
            component.set("v.SearchKeyWord", null);
            component.set("v.listOfSearchRecords", null);
            component.set("v.selectedRecord", {});
            var compEvent = component.getEvent("callParentCmpMethod");
            compEvent.setParam("actionName", 'clearFields');
            compEvent.setParam("objectName", '');
            compEvent.fire();
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    handleComponentEvent: function(component, event, helper) {
        try {
            var selectedAccountGetFromEvent = event.getParam("recordByEvent");
            component.set("v.selectedRecord", selectedAccountGetFromEvent);
            var forclose = component.find("lookup-pill");
            $A.util.addClass(forclose, 'slds-show');
            $A.util.removeClass(forclose, 'slds-hide');
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
            var lookUpTarget = component.find("lookupField");
            $A.util.addClass(lookUpTarget, 'slds-hide');
            $A.util.removeClass(lookUpTarget, 'slds-show');
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
})