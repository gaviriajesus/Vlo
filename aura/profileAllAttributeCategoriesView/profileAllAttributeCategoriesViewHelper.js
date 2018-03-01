({
    // Make Profiler self-sufficient in getting nsPrefix, rather than relying on top-level component to pass along nsPrefix.
    // This is necessary because whereas in being embedded inside VF page would have access to the VF controller mechanism to
    // access nsPrefix, the same is NOT true for Profiler to function inside Lightning Experience.  In Lightning Experience,
    // the Profiler has NO immediate container, and has to access nsPrefix by its own means.
    getNameSpacePrefix: function (component) {
        var action = component.get('c.getNameSpacePrefix');

        action.setCallback(this, function (response) {

            var state = response.getState();

            if (component.isValid() && state === 'SUCCESS') {

                var nsPrefix = response.getReturnValue();
                component.set('v.nsPrefix', nsPrefix);

                this.getAttributeCategories(component);

            } else if (component.isValid() && state === 'ERROR') {

                var errors = response.getError();
                if (errors) {
                    console.error('profileAllAttributeCategoriesViewHelper.js: getNameSpacePrefix encountered error:');
                    console.error(errors);
                    if (errors[0] && errors[0].message) {
                        console.error('profileAllAttributeCategoriesViewHelper.js: getNameSpacePrefix: Error message: ' +
                            errors[0].message);
                    }
                } else {
                    console.error('profileAllAttributeCategoriesViewHelper.js: getNameSpacePrefix: Unknown error');
                }

            }

        });
        $A.enqueueAction(action);
    },

    isLanguageRTL: function (component) {
        var action = component.get('c.isLanguageRTL');

        action.setCallback(this, function (response) {

            var state = response.getState();

            if (component.isValid() && state === 'SUCCESS') {

                var isLanguageRTL = response.getReturnValue();
                component.set('v.isLanguageRTL', isLanguageRTL);

            } else if (component.isValid() && state === 'ERROR') {

                var errors = response.getError();
                if (errors) {
                    console.error('profileAllAttributeCategoriesViewHelper.js: isLanguageRTL encountered error:');
                    console.error(errors);
                    if (errors[0] && errors[0].message) {
                        console.error('profileAllAttributeCategoriesViewHelper.js: isLanguageRTL: Error message: ' +
                            errors[0].message);
                    }
                } else {
                    console.error('profileAllAttributeCategoriesViewHelper.js: isLanguageRTL: Unknown error');
                }

            }

        });
        $A.enqueueAction(action);
    },

    getAttributeCategories: function (component) {
        var action = component.get('c.getAttributeCategories');
        action.setParams({
            'entityId': component.get('v.entityId'),
            'applicableSubTypes': component.get('v.applicableSubTypes'),
            'ignoreApplicableTypes>': component.get('v.ignoreApplicableTypes')
        });

        action.setCallback(this, function (response) {

            var state = response.getState();

            if (component.isValid() && state === 'SUCCESS') {
                var nsPrefix = component.get('v.nsPrefix');
                var attributeCategoriesInfo = [];

                //alert('# of attributeCategories: ' + a.getReturnValue().length);
                for (var i = 0; i < response.getReturnValue().length; i += 1) {
                    var attributeCategory = response.getReturnValue()[i];
                    attributeCategoriesInfo.push({
                        type: attributeCategory[nsPrefix + 'UIControlType__c'],
                        code: attributeCategory[nsPrefix + 'Code__c'],
                        locked: attributeCategory[nsPrefix + 'LockedFlg__c'],
                        name: attributeCategory.Name,
                        color: attributeCategory[nsPrefix + 'ColorCode__c']
                    });
                }

                component.set('v.attributeCategoriesInfo', attributeCategoriesInfo);

            } else if (component.isValid() && state === 'ERROR') {

                var errors = response.getError();
                if (errors) {
                    console.error('profileAllAttributeCategoriesViewHelper.js: getAttributeCategories encountered error:');
                    console.error(errors);
                    if (errors[0] && errors[0].message) {
                        console.error('profileAllAttributeCategoriesViewHelper.js: getAttributeCategories: Error message: ' +
                            errors[0].message);
                    }
                } else {
                    console.error('profileAllAttributeCategoriesViewHelper.js: getAttributeCategories: Unknown error');
                }

            }

        });
        $A.enqueueAction(action);
    }

})