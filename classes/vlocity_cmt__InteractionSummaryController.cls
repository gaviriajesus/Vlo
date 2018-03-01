/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class InteractionSummaryController {
    global String actionListString {
        get;
        set;
    }
    global Id interactionId {
        get;
        set;
    }
    global Boolean isLanguageRTL {
        get;
        set;
    }
    global static String namespacePrefix {
        get;
        set;
    }
    global InteractionSummaryController() {

    }
    global InteractionSummaryController(ApexPages.StandardController stdController) {

    }
    @RemoteAction
    global static vlocity_cmt.InteractionObj getInteractionObject(Id interactionId) {
        return null;
    }
    @RemoteAction
    global static String getTrackingEntries(Id interactionId) {
        return null;
    }
    @RemoteAction
    global static void updateTask(vlocity_cmt.InteractionObj interactionObj, Id interactionId) {

    }
}
