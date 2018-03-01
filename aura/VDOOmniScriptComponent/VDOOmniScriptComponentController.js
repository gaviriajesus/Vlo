({
    doInit : function(cmp, event, helper) {
        var url = window.location.host;
        var isPreview = false;
        if (url.includes('livepreview')) {
            cmp.set('v.isPreview', true);
            isPreview = true;
        }
        if (!isPreview) {
            helper.getBaseURL(cmp);
            var src = window.location.href.split('?src=');
            var apexPage = src[1];
            if (apexPage !== undefined && apexPage.includes('apex')) {
                console.log('verify component', apexPage);
                helper.validateOmiScript(cmp, apexPage);
                document.getElementsByClassName('homeButton')[0].addEventListener('click', function(e) {
                    e.preventDefault();
                    location.href = cmp.get('v.baseURL');
                });
            }
        }
    },
})