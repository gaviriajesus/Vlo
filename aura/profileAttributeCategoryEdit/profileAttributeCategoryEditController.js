({
    handleNavigationEvent: function(component, event, helper) {
        var attributeCategoryCode = event.getParam('attributeCategoryCode');
        var attributeCategoryName = event.getParam('attributeCategoryName');
        var attributeCategoryLocked = event.getParam('attributeCategoryLocked');
        var appliedAttributes = event.getParam('appliedAttributes');
        var entityId = event.getParam('entityId');
        var nsPrefix = event.getParam('nsPrefix') || '';
        component.set('v.attributeCategoryCode', attributeCategoryCode);
        component.set('v.attributeCategoryName', attributeCategoryName);
        component.set('v.attributeCategoryLocked', attributeCategoryLocked);
        component.set('v.appliedAttributes', appliedAttributes);
        component.set('v.entityId', entityId);
        component.set('v.nsPrefix', nsPrefix);

        helper.getUnappliedAttributes(component, entityId, attributeCategoryCode);
    },

    applyAttribute: function(component, event, helper) {
        var segmentCode = event.getParam('segmentCode');
        var entityId = component.get('v.entityId');
        helper.applyAttribute(component, entityId, segmentCode);
    },

    unapplyAttribute: function(component, event, helper) {
        var segmentCode = event.getParam('segmentCode');
        var entityId = component.get('v.entityId');
        helper.unapplyAttribute(component, entityId, segmentCode);
    },

    addAttribute: function(component, event, helper) {
        var attributeNameToBeAdded = event.getParam('attributeName');
        var entityId = component.get('v.entityId');
        var attributeCategoryCode = component.get('v.attributeCategoryCode');
        helper.addAttribute(component, entityId, attributeNameToBeAdded, attributeCategoryCode);
    },

    handleBackButtonClicked: function() {
        var navigationEvent = $A.get('e.vlocity_cmt:profileNavigationEvent');
        navigationEvent.setParams({
            'navigateFrom': 'slide-to-profiler-edit',
            'navigateTo': 'slide-to-profiler-view'
        });
        navigationEvent.fire();
    }
})