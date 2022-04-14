import { LightningElement,api } from 'lwc';

export default class EvToast extends LightningElement {
    showtoast = false;
    message
    @api showToast(message) {
        this.message=message;
        let that = this;
        this.showtoast = true;
        setTimeout(function () {
            that.showtoast = false;
            that.loaded = false
        }, 10000);
    }
}