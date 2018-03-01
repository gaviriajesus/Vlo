({

    setupIframeResizer: function(cmp, event, helper) {
        var actionHandler = $A.getCallback(function(data) {
            helper.handleIFrameMessage(cmp, data.message, cmp.get('v.openInActionsIn'));
        });
        var config = {
            log: false,
            checkOrigin:false,
            scrolling: 'no',
            heightCalculationMethod: 'lowestElement',
            messageCallback : actionHandler
        };
        if (cmp.get('v.maxHeight')) {
            config.maxHeight = Number(''+cmp.get('v.maxHeight').replace('px', ''));
        }
        iFrameResize(config, cmp.find('iframe').getElement());   
        cmp.set('v.iFrameResizer', cmp.find('iframe').getElement().iFrameResizer);          
    },

    handleDestroy: function(cmp, event, helper) {
        var iframeresizer = cmp.get('v.iFrameResizer');
        iframeresizer.close();
    }
})