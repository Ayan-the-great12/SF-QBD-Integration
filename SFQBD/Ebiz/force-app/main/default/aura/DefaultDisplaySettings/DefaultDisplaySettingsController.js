({
    doInit: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            var DefaultTransBy = [];
            DefaultTransBy.push({
                'label': 'Display transactions run today',
                'value': 'Today'
            });
            DefaultTransBy.push({
                'label': 'Display transactions run in the past week',
                'value': 'Past Week'
            });
            DefaultTransBy.push({
                'label': 'Display transactions run in the past month',
                'value': 'Past Month'
            });
            DefaultTransBy.push({
                'label': 'Display transactions run in the past year',
                'value': 'Past Year'
            });
            component.set('v.DefaultTransBy', DefaultTransBy);
            var DefEmailReqSendBy = [];
            DefEmailReqSendBy.push({
                'label': 'Display requests sent today',
                'value': 'Today'
            });
            DefEmailReqSendBy.push({
                'label': 'Display requests sent in the past week',
                'value': 'Past Week'
            });
            DefEmailReqSendBy.push({
                'label': 'Display requests sent in the past month',
                'value': 'Past Month'
            });
            DefEmailReqSendBy.push({
                'label': 'Display requests sent in the past year',
                'value': 'Past Year'
            });
            component.set('v.DefaultEmailReqSendBy', DefEmailReqSendBy);
            var DefaultOrdersBy = [];
            DefaultOrdersBy.push({
                'label': 'Display orders created or modified today',
                'value': 'Today'
            });
            DefaultOrdersBy.push({
                'label': 'Display orders created or modified in the past week',
                'value': 'Past Week'
            });
            DefaultOrdersBy.push({
                'label': 'Display orders created or modified in the past month',
                'value': 'Past Month'
            });
            DefaultOrdersBy.push({
                'label': 'Display orders created or modified in the past year',
                'value': 'Past Year'
            });
            component.set('v.DefaultOrdersBy', DefaultOrdersBy);
            var DefaultAccountsBy = [];
            DefaultAccountsBy.push({
                'label': 'Display accounts/contacts created or modified today',
                'value': 'Today'
            });
            DefaultAccountsBy.push({
                'label': 'Display accounts/contacts created or modified in the past week',
                'value': 'Past Week'
            });
            DefaultAccountsBy.push({
                'label': 'Display accounts/contacts created or modified in the past month',
                'value': 'Past Month'
            });
            DefaultAccountsBy.push({
                'label': 'Display accounts/contacts created or modified in the past year',
                'value': 'Past Year'
            });
            component.set('v.DefaultAccountsBy', DefaultAccountsBy);
            var DefaultRecurringPaymentsBy = [];
            DefaultRecurringPaymentsBy.push({
                'label': 'Display recurring payments scheduled today',
                'value': 'Today'
            });
            DefaultRecurringPaymentsBy.push({
                'label': 'Display recurring payments scheduled within the next week',
                'value': 'Next Week'
            });
            DefaultRecurringPaymentsBy.push({
                'label': 'Display recurring payments scheduled within the next month',
                'value': 'Next Month'
            });
            DefaultRecurringPaymentsBy.push({
                'label': 'Display recurring payments scheduled within the next year',
                'value': 'Next Year'
            });
            component.set('v.DefaultRecurringPaymentsBy', DefaultRecurringPaymentsBy);
            helper.getSettings(component, event);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    TransHandler: function(component, event, helper) {},
    saveSettingsDisplay: function(component, event, helper) {
        try {
            helper.saveSettingsNew(component, event, 'Default display ');
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
})