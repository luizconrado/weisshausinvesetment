import { LightningElement } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import unsubscribeFromProduct from '@salesforce/apex/LeadService.updateLeadToUnSubscribed';
import errorMsg from '@salesforce/label/c.form_error_msg';
import successUnsubscribeMessage from '@salesforce/label/c.from_successUnsubscribe_msg';

export default class Unsubscribe extends LightningElement {

    parameters;
    emailAddress;
    rendered = false;
    productname;
    reason;
    loaded;
    reasonOptions = [
        { label: 'nicht interessiert', value: 'nicht interessiert' },
        { label: 'andere', value: 'andere' },

    ];

    get reasonOptions() {
        return this.reasonOptions;
    }

    connectedCallback() {
        this.parameters = this.getQueryParameters();
        this.emailAddress = this.parameters.email;
        this.productname = this.parameters.product;
    }
    applyStyle() {
        const style = document.createElement('style');
        style.innerText = `
        .inputDesign .slds-input{
            height:48px;
            border-radius: 0px;
          
        }`;
        //applying styles dynmicaly to shadow dom elements
        let inputs = this.template.querySelectorAll('div.inputDesign');
        for (let div of inputs) {
            div.appendChild(style);
        }

    }

    renderedCallback() {
        if (this.rendered) return;
        this.applyStyle();
        this.rendered = true;
    }

    getQueryParameters() {

        let params = {};
        let search = location.search.substring(1);

        if (search) {
            params = JSON.parse('{"' + search.replace(/&/g, '","').replace(/=/g, '":"') + '"}', (key, value) => {
                return key === "" ? value : decodeURIComponent(value)
            });
        }

        return params;
    }
    handleOptout(event) {
        this.loaded = true;
        const params = {
            "email": this.emailAddress,
            "product": this.productname,
            "reason": this.reason,

        };
        unsubscribeFromProduct(params)
            .then(result => {
                this.showToast('Success', successUnsubscribeMessage, 'success');
                this.loaded = false;
                setTimeout(() => location.href = 'https://www.weisshausinvestment.com/', 2000);
            })
        then(error => {
            this.showToast('Error', errorMsg, 'error');
            this.loaded = false;
        })

    }
    handleResonChange(event) {
        this.reason = event.target.value;
    }
    showToast(theTitle, theMessage, theVariant) {
        const event = new ShowToastEvent({
            title: theTitle,
            message: theMessage,
            variant: theVariant,
            messageTemplate: "{0}",
            messageTemplateData: [theMessage]
        });
        this.dispatchEvent(event);
    }

}