({
    makeUrl : function(cmp, contextId, type, subtype, language) {
        var types, queryStringObj, queryString, getNameSpacePrefix, extraParams;
        types = {
            "/native/bridge.app": "hybrid",
            "/one/one.app": "web"
        };
        queryStringObj = {
            id: contextId,
            ContextId: contextId,
            OmniScriptType: type, 
            OmniScriptSubType: subtype,
            OmniScriptLang: language,
            scriptMode: 'vertical',
            layout: 'lightning',
            omniIframeEmbedded: true,
            omniCancelAction: 'back',
            isdtp: "p1",
            sfdcIFrameOrigin: this.getOrigin(),
            sfdcIFrameHost: "sfNativeBridge"in window ? "hybrid" : types[window.location.pathname.toLowerCase()] || "web"
        };
        queryString = Object.keys(queryStringObj).reduce(function(queryString, key) {
            return queryString + (queryString.length > 1 ? '&' : '') + encodeURIComponent(key) + '=' + encodeURIComponent(queryStringObj[key]);
        }, '');
        extraParams = cmp.get('v.extraParams');
        if (extraParams && Object.keys(extraParams).length > 0) {
            queryString = Object.keys(extraParams).reduce(function(queryString, key) {
                return queryString + (queryString.length > 1 ? '&' : '') + encodeURIComponent(key) + '=' + encodeURIComponent(extraParams[key]);
            }, '');
        }
        getNameSpacePrefix = cmp.get('c.getNameSpacePrefix');
        getNameSpacePrefix.setCallback(this, function(result) {
            var ns = result.getReturnValue() || '';
            var a = document.createElement('a');
            var vfPage = cmp.get('v.customVFPage') || ns + 'OmniScriptUniversalPage';
            a.href = '/apex/' + vfPage + '?' + queryString;
            cmp.set('v.url', a.pathname + a.search + a.hash);
        });
        $A.enqueueAction(getNameSpacePrefix);
    },
    getOrigin: function() {
        return "origin" in window.location ? window.location.origin : [window.location.protocol, "//", window.location.hostname, window.location.port ? ":" + window.location.port : ""].join("")
    }
})