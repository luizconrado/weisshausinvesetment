/**
 * Created by prasad on 11.06.20.
 */

import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import updateLead from '@salesforce/apex/LeadService.updateLeadWithConfirmation';
import checkLeadOnLoad from '@salesforce/apex/LeadService.checkAndUpdateLeadOnload';
import privacyWebLink from '@salesforce/label/c.Privacy_Web_Link';
import successMsg from '@salesforce/label/c.from_success_msg';
import errorMsg from '@salesforce/label/c.form_error_msg';
import warrningMsg from '@salesforce/label/c.form_warrning_msg';


export default class VerifyEmailAccount extends LightningElement {
    @api subscribedtext = 'Danke fürs Abonnieren';
    parameters = {};
    salutation;
    firstName;
    lastName;
    emailAddress;
    phoneNumber;
    loaded = false;
    leadId;
    privacyLink = privacyWebLink;
    showForm = true;
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
    rendered = false;
    renderedCallback() {
        if (this.rendered) return;
        this.applyStyle();
        this.rendered = true;
    }
    connectedCallback() {

        this.parameters = this.getQueryParameters();
        this.emailAddress = this.parameters.email;
        this.handleOnInit();

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

    salutationsList = [
        { label: 'Herr', value: 'Herr' },
        { label: 'Frau', value: 'Frau' },
        { label: 'Herr Dr.', value: 'Herr Dr.' },
        { label: 'Frau Dr.', value: 'Frau Dr.' },
        { label: 'Herr Prof.', value: 'Herr Prof.' },
        { label: 'Frau  Prof.', value: 'Frau  Prof.' },
    ];

    get salutationOptions() {
        return this.salutationsList;
    }

    handlePhoneChange(event) {
        this.phoneNumber = event.target.value;
    }


    handleSalutationChange(event) {
        this.salutation = event.target.value;
    }

    handleFirstNameChange(event) {
        this.firstName = event.target.value;
    }

    handleLastNameChange(event) {
        this.lastName = event.target.value;
    }

    handleOnInit() {
        const params = {
            "email": this.parameters.email,
            "product": this.parameters.product,
        };

        checkLeadOnLoad(params)
            .then(result => {
                console.log(JSON.stringify(result));
                this.leadId = result.leadId;
                this.showForm = result.showForm;
                if (this.showForm == false) {
                    setTimeout(() => location.href = 'https://www.weisshausinvestment.com/', 5000);
                }
            })
            .catch(error => {
                this.showToast('Error', error, 'error');
                this.loaded = false;
            })
    }

    handleSave() {
        if (this.checkFieldValidity()) {
            this.loaded = true;
            const params = {
                "email": this.parameters.email,
                "product": this.parameters.product,
                "salutation": this.salutation,
                "lastName": this.lastName,
                "firstName": this.firstName,
                "termsAndConditions": true,
                "phoneNumber": this.phoneNumber,
                "leadId": this.leadId
            };

            updateLead(params)
                .then(result => {
                    this.showToast('Success', successMsg, 'success');
                    this.loaded = false;
                    setTimeout(() => location.href = 'https://www.weisshausinvestment.com/', 2000);
                })
                .catch(error => {
                    this.showToast('Error', errorMsg, 'error');
                    this.loaded = false;
                })

        } else {
            this.showToast('Warning', warrningMsg, 'warning');
            this.loaded = false;
        }
    }

    checkFieldValidity() {
        return [...this.template.querySelectorAll('lightning-input,lightning-combobox')]
            .reduce((validSoFar, inputCmp) => {
                inputCmp.reportValidity();
                return validSoFar && inputCmp.checkValidity();
            }, true);
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