({
    getUrlForAction: function(cmp, actionId, contextId, objType, extraParams) {
        var me = this;
        var getUrlForAction = cmp.get('c.getUrlForAction');
        getUrlForAction.setParams({
            actionId: actionId,
            contextId: contextId,
            objType: objType
        });
        getUrlForAction.setCallback(this, function(result) {
            var url = result.getReturnValue();
            if (url) {
                var queryString = '';
                if (extraParams && Object.keys(extraParams).length > 0) {
                    queryString = Object.keys(extraParams).reduce(function(str, key) {
                        return str + '&' + encodeURIComponent(key) + '=' + encodeURIComponent(extraParams[key]);
                    }, '').substring(1) + '&';
                }
                if (url.indexOf('?') > -1) {
                    url = url.substring(0, url.indexOf('?') + 1) + queryString + url.substring(url.indexOf('?') + 1); 
                } else if (queryString != '') {
                    url += '?' + queryString;
                }
                me.handleURL(cmp, url, true);
            } else {
                cmp.set('v.isOmniScriptValid', false);
            }
        });
        $A.enqueueAction(getUrlForAction);
    }, 

    handleURL: function(cmp, url, isredirect) {
        var hostRoot;
        if (/livepreview/.test(window.location.host)) {
            hostRoot = window.location.protocol + '//' + window.location.host + '/sfsites/c';
        } else {
            hostRoot = window.location.protocol + '//' + window.location.host + window.location.pathname.split("/s/")[0];
        }
        if (/^\/[a-zA-Z0-9]+(\?.*)*$/.test(url)) {
            // special case for view object
            var urlEvent = $A.get("e.force:navigateToSObject");
            urlEvent.setParams({
                "recordId": url.substring(1),
                "isredirect": !!isredirect
            });
            urlEvent.fire();
        } else if (/^\/([a-zA-Z0-9]+)\/e(\?.*)*$/.test(url)) {
            // special case for edit object 
            var result = /^\/([a-zA-Z0-9]+)\/e(\?.*)*$/.exec(url);
            var urlEvent = $A.get("e.force:editRecord");
            urlEvent.setParams({
                "recordId": result[1],
                "isredirect": !!isredirect
            });
            urlEvent.fire();
        } else {
            var protocolRegex = new RegExp('://'),
                urlHelper = document.createElement("a"),
                queryString = 'omniCancelAction=back';
            urlHelper.href = ((!protocolRegex.test(url) && url.charAt(0) !== '/') ? '/' : '') + url;
            urlHelper.search += (urlHelper.search.length == 0 ? '?' : '&') + queryString;
            var oldStyleOmniRegex = new RegExp("/OmniScriptType/([^/]*)/OmniScriptSubType/([^/]*)/OmniScriptLang/([^/]*)/ContextId/([^/]*)/");
            if (oldStyleOmniRegex.test(urlHelper.hash)) {
                var matches = oldStyleOmniRegex.exec(urlHelper.hash);
                $A.createComponent('vlocity_cmt:OmniScriptCommunity', {
                    type: matches[1],
                    subtype: matches[2],
                    language: matches[3],
                    recordId: (matches[4] || this.getUrlParam(urlHelper.search, 'ContextId') || this.getUrlParam(urlHelper.search, 'id')),
                    extraParams: cmp.get('v.extraParams')
                }, function(omniComponent, status, errorMessage) {
                    if (status === "SUCCESS") {
                        var body = cmp.get("v.body");
                        body.push(omniComponent);
                        cmp.set("v.body", body);
                    }
                    else if (status === "INCOMPLETE") {
                        console.log("No response from server or client is offline.")
                    }
                    else if (status === "ERROR") {
                        console.log("Error: " + errorMessage);
                    }
                });
            } else if (/OmniScriptType=/.test(urlHelper.search) &&
                    /OmniScriptSubType=/.test(urlHelper.search) &&
                    /OmniScriptLang=/.test(urlHelper.search)) {
                $A.createComponent('vlocity_cmt:OmniScriptCommunity', {
                    type: this.getUrlParam(urlHelper.search, 'OmniScriptType'),
                    subtype: this.getUrlParam(urlHelper.search, 'SubType'),
                    language: this.getUrlParam(urlHelper.search, 'OmniScriptLang'),
                    recordId: this.getUrlParam(urlHelper.search, 'ContextId'),
                    extraParams: cmp.get('v.extraParams')
                }, function(omniComponent, status, errorMessage) {
                    if (status === "SUCCESS") {
                        var body = cmp.get("v.body");
                        body.push(omniComponent);
                        cmp.set("v.body", body);
                    }
                    else if (status === "INCOMPLETE") {
                        console.log("No response from server or client is offline.")
                    }
                    else if (status === "ERROR") {
                        console.log("Error: " + errorMessage);
                    }
                });
            } else if (new RegExp('^/apex/').test(url)) {
                $A.createComponent('vlocity_cmt:vlocityIframeComponent', {
                    url: hostRoot + url
                }, function(iframeComponent, status, errorMessage) {
                    if (status === "SUCCESS") {
                        var body = cmp.get("v.body");
                        body.push(iframeComponent);
                        cmp.set("v.body", body);
                    }
                    else if (status === "INCOMPLETE") {
                        console.log("No response from server or client is offline.")
                    }
                    else if (status === "ERROR") {
                        console.log("Error: " + errorMessage);
                    }
                });
            } else { 
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": url,
                    "isredirect": !!isredirect
                });
                urlEvent.fire();
            }
        }
        cmp.set('v.isOmniScriptValid', true);
    },

    setupExtraParams: function(cmp, source) {
        var extraParams = /extraParams=([^&#=]*)/i.exec(source);
        if (extraParams && extraParams.length > 1) {
            try { 
                extraParams = JSON.parse(decodeURIComponent(extraParams[1]));
                Object.keys(extraParams).forEach(function(key){
                    extraParams[key] = extraParams[key].replace(/\+/g, ' ');
                });
            } catch(e) {
                extraParams = {};
            }
        } else {
            extraParams = {};
        }
        cmp.set('v.extraParams', extraParams);
    },

    getUrlParam: function(url, paramName) {
        var paramMatch = new RegExp(paramName + '=([^&#=]*)', 'i').exec(url);
        if (paramMatch && paramMatch.length > 1) {
            return decodeURIComponent(paramMatch[1]);
        } 
        return null;
    }


})