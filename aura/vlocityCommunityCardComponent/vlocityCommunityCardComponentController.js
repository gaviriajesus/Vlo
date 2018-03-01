({
	doInit : function(cmp, event, helper) {
		helper.getBaseURL(cmp);
	},
    
    handleCardEvent: function(cmp, event) {
        var layoutName = event.getParam("layoutName");
        var message = event.getParam("message");
        
        helper.sendIframeMessage(cmp, {
            type: "cardevent",
            layoutName: layoutName,
            message: message
        });
    }
})