({
    isLanguageRTL: function(component) {
        var action = component.get("c.isLanguageRTL");

        action.setCallback(this, function(response) {

            var state = response.getState();

            if (component.isValid() && state === "SUCCESS") {

                var isLanguageRTL = response.getReturnValue();
                component.set("v.isLanguageRTL", isLanguageRTL);

            } else if (component.isValid() && state === "ERROR") {

                var errors = response.getError();
                if (errors) {
                    console.error("profileTopLevelContainerViewHelper.js: isLanguageRTL encountered error:");
                    console.error(errors);
                    if (errors[0] && errors[0].message) {
                        console.error("profileTopLevelContainerViewHelper.js: isLanguageRTL: Error message: " +
                                 errors[0].message);
                    }
                } else {
                    console.error("profileTopLevelContainerViewHelper.js: isLanguageRTL: Unknown error");
                }

            }

        });
        $A.enqueueAction(action);
    }

})