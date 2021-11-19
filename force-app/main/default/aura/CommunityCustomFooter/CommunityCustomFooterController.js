({
	onInit: function (component, event, helper) {
        component.set('v.hostUrl',$A.get("$Label.c.evsmartmoney_URL"));
 		component.set('v.footerlogo', 'https://ev-smartmoney--c.documentforce.com/servlet/servlet.ImageServer?id=0155I000000nLMT&oid=00D5I000002GOw0');
        component.set('v.emailIcon','https://ev-smartmoney--c.documentforce.com/servlet/servlet.ImageServer?id=0155I000000eT6o&oid=00D5I000002GOw0');
        component.set('v.clockIcon','https://ev-smartmoney--c.documentforce.com/servlet/servlet.ImageServer?id=0155I000000ebs2&oid=00D5I000002GOw0');
        component.set('v.homeIcon','https://ev-smartmoney--c.documentforce.com/servlet/servlet.ImageServer?id=0155I000000ebs7&oid=00D5I000002GOw0');
        component.set('v.phoneIcon','https://ev-smartmoney--c.documentforce.com/servlet/servlet.ImageServer?id=0155I000000ebsC&oid=00D5I000002GOw0');
	}
})