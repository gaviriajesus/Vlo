({   
    /*
     * returns true if it was handled, or false if not.
     */
    handleIFrameMessage: function(cmp, message, openActionIn) {
        switch (message.message) {
            case 'actionLauncher:windowopen':   this.handleActionLauncherEvent(cmp, message, openActionIn);
                                                break;
            case 'omni:doneCancelAux':          this.handleOmniNavigation(cmp, message.type, message.destination);
                                                break;
            case 'omni:cancelGoBack':           window.history.back();
                                                break; 
            case 'ltng:event':                  this.fireLightningEvent(cmp, message);
                                                break;
            default: // no-op
        }
    },

    handleActionLauncherEvent: function(cmp, message, openActionIn) {
        var action = message.action;
        switch(action.type) {
            case 'Custom':  
            case 'OmniScript':  this.handleUrl(cmp, openActionIn, action.url, action, message.actionConfig);
                                break;
            default:            this.handleRegularAction(cmp, openActionIn, action, message.contextId, message.sObjType, message.actionConfig);
        }
    },

    handleUrl: function(cmp, openActionIn, url, action, actionConfig) {
        var isAbsoluteUrl = new RegExp('^(?:[a-z]+:)?//', 'i');
        if (/^\/[a-zA-Z0-9]+(\?.*)*$/.test(url)) {
            // special case for view object
            var urlEvent = $A.get("e.force:navigateToSObject");
            urlEvent.setParams({
                "recordId": url.substring(1)
            });
            urlEvent.fire();
        } else if (/^\/([a-zA-Z0-9]+)\/e(\?.*)*$/.test(url)) {
            // special case for edit object 
            var result = /^\/([a-zA-Z0-9]+)\/e(\?.*)*$/.exec(url),
                urlEvent = $A.get("e.force:editRecord");
            urlEvent.setParams({
                "recordId": result[1]
            });
            urlEvent.fire(); 
        } else if(isAbsoluteUrl.test(url)){
            var openUrlMode = action['OpenUrlMode__c'] || action['OpenURLMode__c'] || action.openUrlIn;
            var params = (openUrlMode === 'New Tab / Window') ? '_blank' : '_self';
            if (params === '_self') {
                window.open(url, params);
            } else {
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": url
                });
                urlEvent.fire();
            }
        } else {
            var protocolRegex = new RegExp('://'),
                urlEvent = $A.get("e.force:navigateToURL"),
                urlHelper = document.createElement("a"),
                queryString = 'omniCancelAction=back' + this.buildQueryString(actionConfig);
            urlHelper.href = ((!protocolRegex.test(url) && url.charAt(0) !== '/') ? '/' : '') + url;
            urlHelper.search += (urlHelper.search.length == 0 ? '?' : '&') + queryString;
            var oldStyleOmniRegex = new RegExp("/OmniScriptType/[^/]*/OmniScriptSubType/[^/]*/OmniScriptLang/[^/]*/");
            if (action.type === 'OmniScript' || (oldStyleOmniRegex.test(urlHelper.hash) ||
                (/OmniScriptType=/.test(urlHelper.search) &&
                    /OmniScriptSubType=/.test(urlHelper.search) &&
                    /OmniScriptLang=/.test(urlHelper.search)))) {
                console.log('would\'ve gone to OmniScript Component');
            }
            if (openActionIn) {
                urlHelper.href = openActionIn + "?actionUrl=" + encodeURIComponent(urlHelper.pathname + urlHelper.search + urlHelper.hash);
            }
            urlEvent.setParams({
                "url": urlHelper.pathname + urlHelper.search + urlHelper.hash
            });
            urlEvent.fire();
        }
    },

    handleOmniNavigation: function(cmp, type, destination) {
        if (type === 'URL') {
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": destination
            });
            urlEvent.fire();
        } else if (type == 'SObject') {
            var urlEvent = $A.get("e.force:navigateToSObject");
            urlEvent.setParams({
                "recordId": destination
            });
            urlEvent.fire();
        }
    },

    isSObjectUrl: function(url) {
        return /^\/[a-zA-Z0-9]+(\?.*)*$/.test(url) || /^\/([a-zA-Z0-9]+)\/e(\?.*)*$/.test(url);
    },

    handleRegularAction: function(cmp, openActionIn, action, contextId, sObjectType, actionConfig) {
        var url = '', urlEvent;
        /*if (openActionIn) {
            url = this.buildCommunityActionUrl(cmp, openActionIn, action, contextId, sObjectType, actionConfig);
            if (url) {
                urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": url
                });
                urlEvent.fire();
            }
            return;
        }*/
        this.getActionFromServer(cmp, openActionIn, action, contextId, sObjectType, actionConfig);
    },

    buildQueryString: function(actionConfig) {
        var queryString = '';        
        if (actionConfig && actionConfig.extraParams) {
            queryString = Object.keys(actionConfig.extraParams).reduce(function(str, key) {
                return str + '&' + encodeURIComponent(key) + '=' + encodeURIComponent(actionConfig.extraParams[key]);
            }, queryString) + '&';
        }
        return queryString;
    },
    
    buildCommunityActionUrl: function(cmp, openActionIn, action, contextId, sObjectType, actionConfig) {
        var urlHelper, queryString;
        if(action.isCustomAction) {
           return this.buildCustomActionUrl(openActionIn, action, actionConfig);
        }
        urlHelper = document.createElement('a');
        urlHelper.href = action.URL__c || action.Url__c;
        if (urlHelper.hostname !== window.location.host || urlHelper.protocol !== window.location.protocol) {
            this.getActionFromServer(cmp, openActionIn, action, contextId, sObjectType, actionConfig);
            return null;
        }
        queryString = 'actionId=' + encodeURIComponent(action.Id) + "&contextId=" + encodeURIComponent(contextId) + '&objType=' + encodeURIComponent(sObjectType) + (actionConfig && actionConfig.extraParams && Object.keys(actionConfig.extraParams).length > 0 ? '&extraParams=' + encodeURIComponent(JSON.stringify(actionConfig.extraParams)) : '');
        urlHelper.href = openActionIn;
        if (urlHelper.search == "") {
            urlHelper.href = openActionIn + '?' + queryString;
        } else {
            urlHelper.search += '&' + queryString;
        }
        return urlHelper.pathname + urlHelper.search + (urlHelper.hash !== '#' ? urlHelper.hash : '');
    },

    buildCustomActionUrl: function(urlHelper, openActionIn, action, actionConfig) {
        var urlHelper = document.createElement('a'),
            queryString = this.buildQueryString(actionConfig),
            oldStyleOmniRegex = new RegExp("/OmniScriptType/[^/]*/OmniScriptSubType/[^/]*/OmniScriptLang/[^/]*/"),
            url = action.url;
        if (url.indexOf('?') > -1) {
            url = url.substring(0, url.indexOf('?') + 1) + queryString + url.substring(url.indexOf('?')+1); 
        } else {
            url += '?' + queryString;
        }
        if (action.type === 'OmniScript' || (oldStyleOmniRegex.test(urlHelper.hash) ||
            (/OmniScriptType=/.test(urlHelper.search) &&
                /OmniScriptSubType=/.test(urlHelper.search) &&
                /OmniScriptLang=/.test(urlHelper.search)))) {
            queryString = "actionUrl=" + encodeURIComponent(url);
            urlHelper.href = openActionIn + '?' + queryString;
        } else {
            urlHelper.href = action.url;
        }
        return urlHelper.pathname + urlHelper.search + urlHelper.hash;
    },

    getActionFromServer: function(cmp, openActionIn, action, contextId, sObjectType, actionConfig) {
        var getUrlForAction = cmp.get('c.getUrlForAction'),
            me = this;
        getUrlForAction.setParams({
            actionId: action.Id,
            contextId: contextId,
            objType: sObjectType
        });
        getUrlForAction.setCallback(this, function(result) {
            if (result) {
                me.handleUrl(cmp, openActionIn, result.getReturnValue(), action, actionConfig);
            }
        });
        $A.enqueueAction(getUrlForAction);
    },

    fireLightningEvent: function(cmp, message) {
        var evt = $A.get(message.event);
        if (message.params) {
            evt.setParams(message.params);
        }
        evt.fire();
    },

    sendIframeMessage: function(cmp, message) {
        cmp.get('v.iFrameResizer').sendMessage(message);
    }
})