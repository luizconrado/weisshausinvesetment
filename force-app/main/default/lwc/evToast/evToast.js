import { LightningElement, api } from 'lwc';

export default class EvToast extends LightningElement {
    showtoast = false;
    message
    @api type = 'success';

    get toastClassName() {
        if (this.type == 'information') {
            return 'ev-toast_container ev-toast_information';
        }
        return 'ev-toast_container ev-toast_success';

    }

    get toastIconUrl() {
        if (this.type == 'information') {
            return 'https://ev-smartmoney--c.documentforce.com/servlet/servlet.ImageServer?id=0157T000000c6j9&oid=00D5I000002GOw0';
        }
        return 'https://ev-smartmoney--c.documentforce.com/servlet/servlet.ImageServer?id=0157T000000c5yc&oid=00D5I000002GOw0';
    }

    @api showToast(message) {
        this.message = message;
        let that = this;
        this.showtoast = true;
        setTimeout(function () {
            that.showtoast = false;
            that.loaded = false
        }, 15000);
    }
}