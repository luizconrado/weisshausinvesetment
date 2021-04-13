({
    onInit: function (component, event, helper) {
        component.set('v.headerLogo', 'https://ev-smartmoney--c.documentforce.com/servlet/servlet.ImageServer?id=0155I000000cWLT&oid=00D5I000002GOw0');
        let lang=helper.getUrlParameter('language')
        console.log('lang',lang)
        component.set('v.langSelected',lang)
        document.addEventListener('DOMContentLoaded', (event) => {
            let togglebutton = document.querySelector('#nav-toggle');
            let navpoupup = document.querySelector('#nav-popup');
            let popup = document.querySelector('.toggle');
            togglebutton.addEventListener('click', function () {
                popup.style.display = "block";
            });
            navpoupup.addEventListener('click', function () {
                popup.style.display = "none";
            });

        });
    },
 	changeLanguage:function (component, event, helper) {
    	let selectedLang=event.target.value;
   		let queryParams = new URLSearchParams(window.location.search);
        queryParams.set("language", selectedLang);
        history.replaceState(null, null, "?"+queryParams.toString());
    	location.reload();

	}
})