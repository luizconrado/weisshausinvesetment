/**
 * Created by prasad on 11.06.20.
 */

import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import updateLead from '@salesforce/apex/SubscriptionService.updateSubscriptionWithConfirmation';
import checkLeadOnLoad from '@salesforce/apex/SubscriptionService.checkAndUpdateSubscriptionOnload';
import privacyWebLink from '@salesforce/label/c.Privacy_Web_Link';
import successMsg from '@salesforce/label/c.from_success_msg';
import errorMsg from '@salesforce/label/c.form_error_msg';
import warrningMsg from '@salesforce/label/c.form_warrning_msg';

//labels
import VerifyAccountText from '@salesforce/label/c.VerifyAccountText';
import VerifiedAccountText from '@salesforce/label/c.VerifiedAccountText';
import TermsAndConditionsText from '@salesforce/label/c.TermsAndConditionsText';
import VerifyButtonText from '@salesforce/label/c.VerifyButtonText';
import SalutationText from '@salesforce/label/c.SalutationText';
import FirstName from '@salesforce/label/c.FirstName';
import Surname from '@salesforce/label/c.Surname';
import EmailAddress from '@salesforce/label/c.EmailAddress';
import PhoneNumber from '@salesforce/label/c.PhoneNumber';





export default class VerifyEmailAccount extends LightningElement {
    //depricated
    @api subscribedtext;
    //labels
    verifyAccountHeaderText = VerifyAccountText;
    subscribedHeadertext = VerifiedAccountText;
    acceptTermsAndConditionsText = TermsAndConditionsText;
    verifyText = VerifyButtonText;
    placeholderSalutationText = SalutationText;
    firstNameText = FirstName;
    surnameText = Surname;
    phoneNumberText = PhoneNumber;
    emailAddressText = EmailAddress;

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

    salutationsList_de = [
        { label: 'Herr', value: 'Herr' },
        { label: 'Frau', value: 'Frau' },
        { label: 'Herr Dr.', value: 'Herr Dr.' },
        { label: 'Frau Dr.', value: 'Frau Dr.' },
        { label: 'Herr Prof.', value: 'Herr Prof.' },
        { label: 'Frau  Prof.', value: 'Frau  Prof.' },
    ];

    get salutationOptions() {
        return this.salutationsList_de;
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
                this.leadId = result.leadId;
                this.showForm = result.showForm;
                if (this.showForm == false) {
                    setTimeout(() => location.href = 'https://www.ev-smartmoney.com/', 5000);
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
                    setTimeout(() => location.href = 'https://www.ev-smartmoney.com/', 2000);
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
        let elements = this.template.querySelectorAll('lightning-input,lightning-combobox');
        return [...elements]
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