({
	onInit : function(component, event, helper) {
        component.set('v.headerLogo','https://weisshausinvestment--c.documentforce.com/servlet/servlet.ImageServer?id=0155I000000cWLT&oid=00D5I000002GOw0&lastMod=1600356035000');
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
	}
})