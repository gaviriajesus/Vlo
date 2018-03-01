({
    doInit : function(component, event, helper) {
        if (component.get("v.record")) {
            component.set("v.entityId", component.get("v.record.Id")); // Lightning Extension
        } else if (component.get("v.recordId")) {
            component.set("v.entityId", component.get("v.recordId")); // Lightning Experience
        } else if (!component.get("v.entityId")) {
            console.error('No objectId is passed into Lightning Profiler'); // if none of the above, then VF page has to pass in objectId
        }
        helper.isLanguageRTL(component);
    },

    handleNavigationEvent : function(component, event) {
        var navigateFrom = event.getParam("navigateFrom");
        var navigateTo = event.getParam("navigateTo");
        var wrapperCmp = component.find('wrapper');
        $A.util.removeClass(wrapperCmp.getElement(), navigateFrom);
        $A.util.addClass(wrapperCmp.getElement(), navigateTo);
    }
})