({
	onInit : function(component, event, helper) {
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