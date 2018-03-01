({
    getBaseURL : function(cmp) {
        var baseurl = cmp.get('c.getCommunityBaseURL');
        var namespace = cmp.get('c.getNameSpacePrefix');
        baseurl.setCallback(this, function(b) {
            var returnObjects = b.getReturnValue();
            cmp.set('v.baseURL', returnObjects);
            var host = returnObjects.split('/s/');
            host = host[0];
            cmp.set('v.hostURL', host);
        });
        $A.enqueueAction(baseurl);
        namespace.setCallback(this, function(response) {
            var state = response.getState();
            if (cmp.isValid() && state === 'SUCCESS') {
                var nsPrefix = response.getReturnValue();
                cmp.set('v.nsPrefix', nsPrefix);
            }
        });
        $A.enqueueAction(namespace);
    },
    validateOmiScript : function(cmp, src) {
        console.log('src in validate', src);
        var temp = src;
        if (src.includes('%2')) {
            temp = decodeURIComponent(src);
            src = temp;
        }
        var parse = temp.split('/');
        var m = parse.indexOf('OmniScriptType');
        var type = parse[m + 1];
        var n = parse.indexOf('OmniScriptSubType');
        var subtype = parse[n + 1];
        var o = parse.indexOf('OmniScriptLang');
        var language = parse[o + 1];
        var isOmniScriptValid = cmp.get('c.isOmniScriptValid');
        isOmniScriptValid.setParams({
            type : type,
            subtype : subtype,
            language : language
        });
        isOmniScriptValid.setCallback(this, function(result) {
            var r = result.getReturnValue();
            console.log('r', r);
            if (r) {
                cmp.set('v.src', src);
                cmp.set('v.isOmniScriptValid', true);
            } else {
                cmp.set('v.isOmniScriptValid', false);
            }
        });
        $A.enqueueAction(isOmniScriptValid);
    }
})