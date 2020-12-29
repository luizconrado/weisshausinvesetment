import { LightningElement, wire, api } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import unsubscribeFromProduct from '@salesforce/apex/LeadService.updateLeadToUnSubscribed';
import checkUnsubscribedStatus from '@salesforce/apex/LeadService.checkUnsubscribedStatus';
import allOptions from '@salesforce/apex/LeadService.getUnsubscribeOptions';
import errorMsg from '@salesforce/label/c.form_error_msg';
import successUnsubscribeMessage from '@salesforce/label/c.from_successUnsubscribe_msg';


import UnsubscribeLabelText from '@salesforce/label/c.Unsubscribe';
import ReasonForUnsubscribeText from '@salesforce/label/c.ReasonForUnsubscribeText';
import ChooseOption from '@salesforce/label/c.ChooseOption';
import UnsubscribedText from '@salesforce/label/c.UnsubscribeText';
import SignOut from '@salesforce/label/c.SignOut';
import NichtOffenlegen from '@salesforce/label/c.UnsubscribeOption1';
import NichtInteressiert from '@salesforce/label/c.UnsubscribeOption2';
import Andere from '@salesforce/label/c.UnsubscribeOption3';





export default class Unsubscribe extends LightningElement {
    //depricated
    @api unsubscribedtext = '';

    //labels
    unsubscribeText = UnsubscribeLabelText;
    reasonForUnsubscribeText = ReasonForUnsubscribeText;
    requiredFieldText = ChooseOption;
    headerUnsubscribedtext = UnsubscribedText
    signOutText = SignOut;

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
                if (lable == 'Nicht Offenlegen') {
                    lable = NichtOffenlegen;
                }
                else if (lable == 'Nicht Interessiert') {
                    lable = NichtInteressiert;
                }
                else if (lable == 'Andere') {
                    lable = Andere;
                }

                reasonOptions.push({ value: data[value], label: lable });
            }

            this.reasonOptions = reasonOptions;
        }
    }

    connectedCallback() {
        this.parameters = this.getQueryParameters();
        this.emailAddress = this.parameters.email;
        this.productname = (this.parameters.product) ? this.parameters.product.replace(/\+/g, ' ') : '';

        checkUnsubscribedStatus({
            email: this.emailAddress,
            product: this.productname
        }).then(data => {
            if (data === false) {
                this.showform = false;
                setTimeout(() => location.href = 'https://www.weisshausinvestment.com/', 4000);
            }

        })
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
        if (!this.reason) {
            this.template.querySelector('.GrundField').reportValidity();
            return;
        }
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
                setTimeout(() => location.href = 'https://www.weisshausinvestment.com/', 4000);
            })
        then(error => {
            this.showToast('Error', errorMsg, 'error');
            this.loaded = false;
        })

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

}