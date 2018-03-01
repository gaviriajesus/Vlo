({
    getBaseURL : function(cmp) {
        var baseurl = cmp.get('c.getCommunityBaseURL');
        var namespace = cmp.get('c.getNameSpacePrefix');
        var recordType = cmp.get('c.getObjectType');
        var url = window.location.host;
        if (url.includes('livepreview')) {
            cmp.set('v.isPreview', true);
        }
        
        //If valid record type, get baseurl and nsPrefix for frame

            baseurl.setCallback(this, function(b) {
                var returnObjects = b.getReturnValue();
                var host, temp;
                if (cmp.get('v.isPreview')) {
                    temp = returnObjects.split('.com/');
                    host = temp[0] + '.com';
                }else {
                    temp = returnObjects.split('/s/');
                    host = temp[0];
                }
                cmp.set('v.hostURL', host);
                cmp.set('v.baseURL', '&baseURL=' + returnObjects);
                console.log(host);
            });
            $A.enqueueAction(baseurl);
            //Get nsPrefix
            namespace.setCallback(this, function(response) {
                var state = response.getState();
                if (cmp.isValid() && state === 'SUCCESS') {
                    var nsPrefix = response.getReturnValue();
                    cmp.set('v.nsPrefix', nsPrefix);
                }
            });
            $A.enqueueAction(namespace);
        }

})