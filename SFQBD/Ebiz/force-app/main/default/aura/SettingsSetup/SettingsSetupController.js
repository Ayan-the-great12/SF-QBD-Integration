({
    doInit: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            var CurrencyOptions = [];
            CurrencyOptions.push({
                'label': 'US Dollar',
                'value': 'USD'
            });
            CurrencyOptions.push({
                'label': 'Canadian Dollar',
                'value': 'CAD'
            });
            component.set('v.CurrencyOptions', CurrencyOptions);
            helper.getSettings(component, event);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    saveSettings: function(component, event, helper) {
        try {
            var allValid = component.find('req-fields').reduce(function(validSoFar, inputCmp) {
                inputCmp.showHelpMessageIfInvalid();
                return validSoFar && !inputCmp.get('v.validity').valueMissing;
            }, true);
            if (allValid) {
                helper.saveSettings(component, event);
            } else {
                helper.showToast('Please update the invalid form entries and try again.', 'Error');
            }
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    saveSettingsSetup: function(component, event, helper) {
        try {
            var allValid = component.find('req-fields').reduce(function(validSoFar, inputCmp) {
                inputCmp.showHelpMessageIfInvalid();
                return validSoFar && !inputCmp.get('v.validity').valueMissing;
            }, true);
            if (allValid) {
                helper.saveSettingsNew(component, event, 'Setup ');
            } else {
                helper.showToast('Please update the invalid form entries and try again.', 'Error');
            }
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    TransHandler: function(component, event, helper) {},
})