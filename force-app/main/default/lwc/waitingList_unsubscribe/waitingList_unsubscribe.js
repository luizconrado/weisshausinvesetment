import { LightningElement, wire, api } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import unsubscribeFromProduct from '@salesforce/apex/SubscriptionService.updateSubscriptionToUnSubscribed';
import checkUnsubscribedStatus from '@salesforce/apex/SubscriptionService.checkUnsubscribedStatus';
import allOptions from '@salesforce/apex/SubscriptionService.getUnsubscribeOptions';
import errorMsg from '@salesforce/label/c.form_error_msg';
 






export default class WaitingList_unsubscribe extends LightningElement {
    //depricated
    @api headertext = '';
    @api buttontext = '';
    @api successtext = ''

    //labels
    reasonForUnsubscribeText = 'Grund für die Abmeldung';
    requiredFieldText = 'Sie haben sich erfolgreich abgemeldet';
 
    parameters;
    emailAddress;
    rendered = false;
    productname;
    reason;
    loaded;
    reasonOptions;
    showform = true;

    get reasonOptions() {
        return this.reasonOptions;
    }
    @wire(allOptions)
    wiredallContacts({ error, data }) {
        if (error) {

        } else if (data) {
            let reasonOptions = [];
            for (let value in data) {
                let lable = value;
                reasonOptions.push({ value: data[value], label: lable });
            }

            this.reasonOptions = reasonOptions;
        }
    }

    connectedCallback() {
        this.parameters = this.getQueryParameters();
        this.emailAddress = this.parameters.email;
        this.productname = (this.parameters.product) ? this.parameters.product.replace(/\+/g, ' ') : '';
        if (this.emailAddress && this.productname) {
            checkUnsubscribedStatus({
                email: this.emailAddress,
                product: this.productname
            }).then(data => {
                if (data === false) {
                    this.showform = false;
                    setTimeout(() => location.href = 'https://www.ev-smartmoney.com/', 10000);
                }

            })
        }
    }
    applyStyle() {
        const style = document.createElement('style');
        style.innerText = `
    .inputDesign .slds-input{
        height:48px;
        border-radius: 0px;
    
    }
    .inputDesign  .slds-combobox__input{
        height: 48px;
        border-radius: 0px;
        align-items: CENTER;
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
        let search = (location.search) ? location.search.substring(1) : undefined;

        if (search) {
            params = JSON.parse('{"' + search.replace(/&/g, '","').replace(/=/g, '":"') + '"}', (key, value) => {
                return key === "" ? value : decodeURIComponent(value)
            });
        }

        return params;
    }
    handleOptout(event) {
        if (!this.reason) {
            this.template.querySelector('.GrundField').reportValidity();
            return;
        }
        if (this.emailAddress && this.productname) {
            this.loaded = true;
            const params = {
                "email": this.emailAddress,
                "product": this.productname,
                "reason": this.reason,

            };
            unsubscribeFromProduct(params)
                .then(result => {
                    this.showEvToast('erfolgreich abgemeldet');
                    this.loaded = false;
                    this.showform=false;
                   // setTimeout(() => location.href = 'https://www.ev-smartmoney.com/', 4000);
                })
            then(error => {
                this.showToast('Error', errorMsg, 'error');
                this.loaded = false;
            })
        }

    }
    handleResonChange(event) {
        this.reason = event.target.value;
        this.template.querySelector('.GrundField').reportValidity();
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
    showEvToast(msg) {
        this.template.querySelector("c-ev-toast").showToast(msg);
    }
}