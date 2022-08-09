import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";


import fetchCusomerDetails from '@salesforce/apex/TaxExemptionFormController.getCustomerDetails';
import fetchMFARequest from '@salesforce/apex/TaxExemptionFormController.initiateMFARequest';
import setMFARequest from '@salesforce/apex/TaxExemptionFormController.closeMFARequest';

import createNewCase from '@salesforce/apex/TaxExemptionFormController.createTaxExemptionCase';


import DigibankCaseForm_SubmitButton from '@salesforce/label/c.DigibankCaseForm_SubmitButton';
import Close from '@salesforce/label/c.Close';

import EarlyTerminationForm_Success from '@salesforce/label/c.EarlyTerminationForm_Success';
import EarlyTerminationForm_Invalid from '@salesforce/label/c.EarlyTerminationForm_Invalid';
import EarlyTerminationForm_SuccessTitle from '@salesforce/label/c.EarlyTerminationForm_SuccessTitle';
import EarlyTerminationForm_CustomerName from '@salesforce/label/c.EarlyTerminationForm_CustomerName';
import EarlyTerminationForm_DepositAccount from '@salesforce/label/c.EarlyTerminationForm_DepositAccount';
import EarlyTerminationForm_StartDate from '@salesforce/label/c.EarlyTerminationForm_StartDate';
import EarlyTerminationForm_Authtunticate from '@salesforce/label/c.EarlyTerminationForm_Authtunticate';
import EarlyTerminationForm_AuthtunticateLabel from '@salesforce/label/c.EarlyTerminationForm_AuthtunticateLabel';
import EarlyTerminationForm_CustomerMissingError from '@salesforce/label/c.EarlyTerminationForm_CustomerMissingError';
import EarlyTerminationForm_ReasonForTermination from '@salesforce/label/c.EarlyTerminationForm_ReasonForTermination';
import EarlyTerminationForm_AccountMissingError from '@salesforce/label/c.EarlyTerminationForm_AccountMissingError';
import EarlyTerminationForm_InvalidToken from '@salesforce/label/c.EarlyTerminationForm_InvalidToken';
import EarlyTerminationForm_SelectStartDate from '@salesforce/label/c.EarlyTerminationForm_SelectStartDate';

export default class TermDepositTaxExemptionOrderForm extends LightningElement {
    rendered = false;
    showForm = false;
    loaded = true;
    error = false;
    popup = false;
    showSuccess = false;
    askSpouseDetails = false;


    TITLE = EarlyTerminationForm_Success
    INVALID_TITLE = EarlyTerminationForm_Invalid
    SUCCESS_TITLE = EarlyTerminationForm_SuccessTitle
    CUSTOMERNAME = EarlyTerminationForm_CustomerName
    DEPOSITACCOUNT = EarlyTerminationForm_DepositAccount

    INVALID_BOOKING_ERROR = EarlyTerminationForm_SelectStartDate;
    STARTDATE_LABEL = EarlyTerminationForm_StartDate
    SUBMIT_BUTTON = DigibankCaseForm_SubmitButton;
    CLOSE_BUTTON = Close;
    AUTHUNTICATE_TITLE = EarlyTerminationForm_Authtunticate
    ATHUNTICATE_LABEL = EarlyTerminationForm_AuthtunticateLabel
    TERMINIATION_REASON = EarlyTerminationForm_ReasonForTermination


    CUSTOMER_MISSING_ERROR = EarlyTerminationForm_CustomerMissingError
    DEPOSIT_MISSING_ERROR = EarlyTerminationForm_AccountMissingError
    INVALID_TOKEN_ERROR = EarlyTerminationForm_InvalidToken


    accountId = '';
    auth0Id = '';
    mfaId = '';
    bankAccountId = '';
    counterInteveal = '';
    @track counterValue = '';

    customerName = '';
    depositAccount = '';
    customerId = '';
    reasonTermination = '';
    startDate;
    minDateValue;
    otp = '';





    //geting user details
    @wire(fetchCusomerDetails, { sbId: '$customerId', authId: '$auth0Id', sfId: '$accountId' })
    wiredfetchCusomerDetails({ error, data }) {
        if (error) {
            let errorObj = JSON.parse(JSON.stringify(error));
            console.error(errorObj);
            this.error = true;
        }
        if (data) {
            let accountData = data.Account;
            let bookingData = data.Booking;
            if (accountData && accountData.length > 0) {
                let accountDetails = accountData[0];
                this.customerName = accountDetails.Legal_Name__c;

                this.accountId = accountDetails.Id;

                if (accountDetails.Bank_Accounts__r && accountDetails.Bank_Accounts__r.length > 0) {
                    this.depositAccount = accountDetails.Bank_Accounts__r[0].Name;
                    this.bankAccountId = accountDetails.Bank_Accounts__r[0].Id;

                }
                let dt = new Date();


                let month = dt.getMonth();
                month = month + 1;
                let date = dt.getDate();
                if (month < 10) month = '0' + month;
                if (date < 10) date = '0' + date;
                this.startDate = `${dt.getFullYear()}-${month}-${date}`;
                this.minDateValue = `${dt.getFullYear()}-${month}-${date}`;


                this.showForm = true;
            }
            else {
                this.error = true;
            }

        }
        this.loaded = false;
    }



    //init  
    applyStyle() {
        const style = document.createElement('style');
        style.innerText = `
        .inputDesign .slds-input{
            height:48px;
            border-radius: 0px;
          
        }
        .inputDesign .slds-textarea{
            border-radius: 0px;
            height:90px;
        }

        .inputDesign.textarea_large  .slds-textarea{
            height: 113px;
        }
        
        .dateTimeInput .slds-form-element{
            width:100%

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


    connectedCallback() {
        let parameters = this.getQueryParameters();

        if (!parameters.ci && !parameters.si && !parameters.ai) {
            this.error = true;
            return;
        }
        this.loaded = true;
        this.customerId = parameters.ci;
        this.accountId = parameters.si;
        this.auth0Id = 'auth0|' + parameters.ai;

    }

    //utitlty
    handleValueChange(event) {
        let value = event.target.value;
        let field = event.target.name;
        this[field] = value;

    }



    handleResonChange(event) {
        this.martialStatus = event.target.value;

    }
    getQueryParameters() {

        var params = {};
        var search = location.search.substring(1);

        if (search) {
            params = JSON.parse('{"' + search.replace(/&/g, '","').replace(/=/g, '":"') + '"}', (key, value) => {
                return key === "" ? value : decodeURIComponent(value)
            });
        }

        return params;
    }


    //validator
    checkFieldValidity() {
        let elements = this.template.querySelectorAll('lightning-input,lightning-combobox,lightning-textarea');
        let isValid = [...elements]
            .reduce((validSoFar, inputCmp) => {
                inputCmp.reportValidity();

                return validSoFar && inputCmp.checkValidity();
            }, true);

        if (isValid) {
            if (!this.customerName) {
                isValid = false;
                this.showToast(this.CUSTOMER_MISSING_ERROR, '', 'error');
            }

            else if (!this.depositAccount) {
                isValid = false;
                this.showToast(this.DEPOSIT_MISSING_ERROR, '', 'error');
            }

            else if (!this.startDate) {
                isValid = false;
                this.showToast(this.INVALID_BOOKING_ERROR, '', 'error');
            }

        }

        return isValid;
    }
    //operations
    handleSave() {
        if (this.checkFieldValidity()) {
            this.athunticateMFARequest();
        }

        else {
            console.log('fail');
        }
    }



    openPopup() {

        if (this.checkFieldValidity()) {
            this.sendMFARequest();
        }
    }

    //api call
    sendMFARequest() {

        this.popup = true;
        this.loaded = true;
        fetchMFARequest({
            sbId: this.customerId,
            sfId: this.accountId
        }).then(result => {
            let response = JSON.parse(result);
            this.mfaId = response.id;
            this.startCounter(response.expires_at);

            this.loaded = false;
        }).catch(error => {
            this.loaded = false;

            console.log('error', error)
        });
    }
    athunticateMFARequest() {
        this.loaded = true;
        setMFARequest({
            mfaId: this.mfaId,
            otp: this.otp,
            sfId: this.accountId
        }).then(result => {
            let response = JSON.parse(result);
            if (response.status == 'failed') {
                this.popup = false;
                this.showToast(this.INVALID_TOKEN_ERROR, '', 'error');
                this.loaded = false;
                this.handleClose();
                return;
            }
            this.createCase();


        }).catch(error => {
            this.loaded = false;
            this.popup = false;
            this.otp = '';
            this.mfaId = '';
            console.log('error', error)
        })
    }

    createCase() {


        let subject = `${this.depositAccount} - ${this.customerId} – Early cancelation term deposit`;
        let description = `
        Hi  Solarisbank Team,

        Here is a request for a Early Terminiation Order for the following customer,
        
        Partner: 
        EV Smart Money Holding GmbH


        Customer Name: 
        ${this.customerName}


        Person ID:
        ${this.customerId}

        Term Deposit Account: 
        ${this.depositAccount}
        
        Terminiation Reason:  
        ${this.reasonTermination}
        
      
        
        
        `;
        /*  Terminiation Date: 
        ${new Date(this.startDate).toLocaleDateString()} */
        this.loaded = true;
        createNewCase({
            accountId: this.accountId,
            bankAccountId: this.bankAccountId,
            subject: subject,
            description: description,
            reason: 'Early Termination'
        })
            .then(response => {
                this.loaded = false;
                this.showSuccess = true;
                this.showForm = false;
                this.handleClose();
            }).catch(error => {
                this.loaded = false;
                this.handleClose();

            })
    }

    //helper
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

    handleClose() {
        this.popup = false;
        this.otp = '';
        this.counterValue = '';

        clearInterval(this.counterInteveal);
    }
    startCounter(dateString) {
        const that = this;
        this.counterInteveal = setInterval(function () {

            // Get today's date and time
            let countDownDate = new Date(dateString).getTime();
            let now = new Date().getTime();
            // Find the distance between now and the count down date
            let distance = countDownDate - now;

            // Time calculations for days, hours, minutes and seconds

            let minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
            let seconds = Math.floor((distance % (1000 * 60)) / 1000);

            // Display the result in the element with id="demo"
            that.counterValue = 'Expires in : ' + minutes + "m " + seconds + "s ";

            // If the count down is finished, write some text
            if (distance < 0) {
                clearInterval(that.counterInteveal);
                that.counterValue = 'Token Expired please try again.'
                that.mfaId = '';
                that.showToast('Token Expired please try again', '', 'error');
                that.handleClose();
            }
        }, 1000);
    }
}