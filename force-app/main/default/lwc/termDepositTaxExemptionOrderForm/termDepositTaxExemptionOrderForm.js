import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';

import retrivePersonRecordTypeId from '@salesforce/apex/TaxExemptionFormController.getPersonAccountRecordTypeId';

import fetchCusomerDetails from '@salesforce/apex/TaxExemptionFormController.getCustomerDetails';
import fetchMFARequest from '@salesforce/apex/TaxExemptionFormController.initiateMFARequest';
import fetchCRPRequest from '@salesforce/apex/TaxExemptionFormController.initiateCRPRequest';
import setMFARequest from '@salesforce/apex/TaxExemptionFormController.closeMFARequest';
import setCRPRequest from '@salesforce/apex/TaxExemptionFormController.closeCRPFRequest';

import createNewCase from '@salesforce/apex/TaxExemptionFormController.createTaxExemptionCase';


import DigibankCaseForm_SubmitButton from '@salesforce/label/c.DigibankCaseForm_SubmitButton';
import Close from '@salesforce/label/c.Close';
import TermDepositTaxExemptionOrderForm_Title from '@salesforce/label/c.TermDepositTaxExemptionOrderForm_Title';

import TermDepositTaxExemptionOrderForm_InvalidTitle from '@salesforce/label/c.TermDepositTaxExemptionOrderForm_InvalidTitle';
import TermDepositTaxExemptionOrderForm_SuccessTitle from '@salesforce/label/c.TermDepositTaxExemptionOrderForm_SuccessTitle';
import EarlyTerminationForm_CustomerName from '@salesforce/label/c.EarlyTerminationForm_CustomerName';
import EarlyTerminationForm_DepositAccount from '@salesforce/label/c.EarlyTerminationForm_DepositAccount';
import EarlyTerminationForm_TaxId from '@salesforce/label/c.EarlyTerminationForm_TaxId';
import Martial_Status from '@salesforce/label/c.Martial_Status';
import EarlyTerminationForm_SpouseName from '@salesforce/label/c.EarlyTerminationForm_SpouseName';
import EarlyTerminationForm_SpuseTaxId from '@salesforce/label/c.EarlyTerminationForm_SpuseTaxId';
import EarlyTerminationForm_SpuseBirthDate from '@salesforce/label/c.EarlyTerminationForm_SpuseBirthDate';
import EarlyTerminationForm_SpouseAddress from '@salesforce/label/c.EarlyTerminationForm_SpouseAddress';
import Start_Date from '@salesforce/label/c.Start_Date';
import End_Date from '@salesforce/label/c.End_Date';
import EarlyTerminationForm_Authtunticate from '@salesforce/label/c.EarlyTerminationForm_Authtunticate';
import EarlyTerminationForm_AuthtunticateLabel from '@salesforce/label/c.EarlyTerminationForm_AuthtunticateLabel';
import EarlyTerminationForm_BookingMissing from '@salesforce/label/c.EarlyTerminationForm_BookingMissing';
import EarlyTerminationForm_ContactEV from '@salesforce/label/c.EarlyTerminationForm_ContactEV';
import EarlyTerminationForm_CustomerMissingError from '@salesforce/label/c.EarlyTerminationForm_CustomerMissingError';
import EarlyTerminationForm_AccountMissingError from '@salesforce/label/c.EarlyTerminationForm_AccountMissingError';
import EarlyTerminationForm_InvaidTaxId from '@salesforce/label/c.EarlyTerminationForm_InvaidTaxId';
import EarlyTerminationForm_InvalidMartialStatus from '@salesforce/label/c.EarlyTerminationForm_InvalidMartialStatus';
import EarlyTerminationForm_NoBooking from '@salesforce/label/c.EarlyTerminationForm_NoBooking';
import EarlyTerminationForm_InvalidToken from '@salesforce/label/c.EarlyTerminationForm_InvalidToken';

import EarlyTerminationForm_IsSpouseAddress from '@salesforce/label/c.EarlyTerminationForm_IsSpouseAddress'

export default class TermDepositTaxExemptionOrderForm extends LightningElement {
    rendered = false;
    showForm = false;
    loaded = true;
    error = false;
    popup = false;
    showSuccess = false;
    askSpouseDetails = false;



    TITLE = TermDepositTaxExemptionOrderForm_Title
    INVALID_TITLE = TermDepositTaxExemptionOrderForm_InvalidTitle
    SUCCESS_TITLE = TermDepositTaxExemptionOrderForm_SuccessTitle
    CUSTOMERNAME = EarlyTerminationForm_CustomerName
    ADDRESSSAMEASSPOUSE = EarlyTerminationForm_IsSpouseAddress;
    DEPOSITACCOUNT = EarlyTerminationForm_DepositAccount
    TAXID = EarlyTerminationForm_TaxId
    MARTIALSTATUS = Martial_Status
    SPOUSENAME = EarlyTerminationForm_SpouseName
    SPOUSETAXID = EarlyTerminationForm_SpuseTaxId
    SPOUSEBIRTHDATE = EarlyTerminationForm_SpuseBirthDate
    SPOUSEADDRESS = EarlyTerminationForm_SpouseAddress
    STARTDATE_LABEL = Start_Date
    ENDDATE_LABEL = End_Date
    SUBMIT_BUTTON = DigibankCaseForm_SubmitButton;
    CLOSE_BUTTON = Close;
    AUTHUNTICATE_TITLE = EarlyTerminationForm_Authtunticate
    ATHUNTICATE_LABEL = EarlyTerminationForm_AuthtunticateLabel
    BOOKING_MISSING_PART1 = EarlyTerminationForm_BookingMissing
    BOOKING_MISSING_PART2 = EarlyTerminationForm_ContactEV
    CUSTOMER_MISSING_ERROR = EarlyTerminationForm_CustomerMissingError
    DEPOSIT_MISSING_ERROR = EarlyTerminationForm_AccountMissingError
    INVALID_TAX_ID_ERROR = EarlyTerminationForm_InvaidTaxId
    INVALID_MARTIAL_STATUS_ERROR = EarlyTerminationForm_InvalidMartialStatus
    INVALID_BOOKING_ERROR = EarlyTerminationForm_NoBooking
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

    taxId = '';
    martialStatus = '';
    orignalMartialStatus = '';
    spouseName = '';
    spouseTaxId = '';
    spouseBirthDay;
    spouseAddress;
    startDate;
    endDate;
    otp = '';
    crpRequestUrl = '';
    minDateValue;
    isAddressSameAsSpouse = false;
    exemptionAmount;
    maxTaxExemptionValue;
    personAccountId = '';
    martialStatusOptions = [];

    get otpOption() {
        if (this.martialStatus != this.orignalMartialStatus) {
            return 'CRPA';
        }
        else {
            return 'MFA';
        }

    }
    get showBookingMissingMessage() {
        return (this.startDate) ? false : true;
    }

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
                this.customerName = accountDetails.LastName;

                

                if (this.martialStatus == 'UNKNOWN') {
                    this.martialStatus = '';
                }

                this.toggleSpouseDetails(this.martialStatus);
                this.accountId = accountDetails.Id;
                if (accountDetails.Banks__r && accountDetails.Banks__r.length > 0) {
                    this.martialStatus = accountDetails.Banks__r[0].Marital_Status__c;
                    this.orignalMartialStatus = accountDetails.Banks__r[0].Marital_Status__c;
                    this.customerName=accountDetails.Banks__r[0].Name;
                }

                if (accountDetails.Tax_Identifications__r && accountDetails.Tax_Identifications__r.length > 0) {
                    this.taxId = accountDetails.Tax_Identifications__r[0].Name;
                }
                if (accountDetails.Bank_Accounts__r && accountDetails.Bank_Accounts__r.length > 0) {
                    this.depositAccount = accountDetails.Bank_Accounts__r[0].Name;
                    this.bankAccountId = accountDetails.Bank_Accounts__r[0].Id;

                }

                if (bookingData.length > 0 && bookingData[0].Booking_Date__c) {
                    const bookingDate = bookingData[0].Booking_Date__c;
                    this.startDate = this.getDateValue(new Date(bookingDate));
                    let newDate = new Date(bookingDate);
                    newDate = newDate.setMonth(newDate.getMonth() + 3);
                    this.endDate = this.getDateValue(new Date(newDate));
                }
                this.minDateValue = this.getDateValue(new Date());



                this.showForm = true;
            }
            else {
                this.error = true;
            }

        }
        this.loaded = false;
    }



    @wire(retrivePersonRecordTypeId)
    wiredretrivePersonRecordTypeId({ error, data }) {
        if (error) {
            console.error(error)
        } else if (data) {

            this.personAccountId = data;

        }
    }

    @wire(getPicklistValuesByRecordType, { objectApiName: 'Account', recordTypeId: '$personAccountId' })
    picklistInfoData({ error, data }) {
        if (error) {
            let errorObj = JSON.parse(JSON.stringify(error));
            console.error(errorObj);
        }
        if (data) {
            this.martialStatusOptions = data.picklistFieldValues.Marital_Status__c.values.map(value => {
                return { value: value.value, label: value.label }
            }).filter(value => value.value != 'UNKNOWN');





        }
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
        if (field == 'martialStatus') this.toggleSpouseDetails(value);

    }
    handleCheckboxValueChange(event) {
        let name = event.target.name;
        let value = event.target.checked;
        this[name] = value;
    }

    toggleSpouseDetails(value) {
        if (value == 'MARRIED') {
            this.askSpouseDetails = true;
            this.maxTaxExemptionValue = 1602;
            this.exemptionAmount = 1602;
        }
        else {
            this.askSpouseDetails = false;
            this.maxTaxExemptionValue = 801;
            this.exemptionAmount = 801;
        }
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
    getDateValue(dt) {
        let month = dt.getMonth();
        month = month + 1;
        let date = dt.getDate();
        if (month < 10) month = '0' + month;
        if (date < 10) date = '0' + date;
        return `${dt.getFullYear()}-${month}-${date}`;
    }

    getGermanDateValue(dt) {
        let month = dt.getMonth();
        month = month + 1;
        let date = dt.getDate();
        if (month < 10) month = '0' + month;
        if (date < 10) date = '0' + date;
        return `${date}.${month}.${dt.getFullYear()}`;
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

            else if (!this.taxId) {
                isValid = false;
                this.showToast(this.INVALID_TAX_ID_ERROR, '', 'error');
            }

            else if (!this.martialStatus) {
                isValid = false;
                this.showToast(this.INVALID_MARTIAL_STATUS_ERROR, '', 'error');
            }
            else if (!this.startDate) {
                isValid = false;
                this.showToast(this.INVALID_BOOKING_ERROR, '', 'error');
            }
            else if (!this.endDate) {
                isValid = false;
                this.showToast(this.INVALID_BOOKING_ERROR, '', 'error');
            }
        }

        return isValid;
    }
    //operations
    handleSave() {
        if (this.checkFieldValidity()) {
            if (this.otpOption == 'CRPA') {
                this.athunticateCRPRequest();
            }
            else {
                this.athunticateMFARequest();
            }
        }

        else {
            console.log('fail');
        }
    }



    openPopup() {

        if (this.checkFieldValidity()) {
            if (this.otpOption == 'CRPA') {

                this.sendCRPRequest();
            }
            else {

                this.sendMFARequest();
            }
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
                return;
            }
            this.createCase();


        }).catch(error => {
            this.loaded = false;
            this.popup = false;
            console.log('error', error)
        })
    }
    sendCRPRequest() {

        this.popup = true;
        this.loaded = true;
        let changes = {};
        changes.tax_information = {};
        changes.tax_information.marital_status = this.martialStatus;
        fetchCRPRequest({
            sfId: this.accountId,
            requestChangebody: JSON.stringify(changes)
        }).then(response => {


            this.crpRequestUrl = response.url;
            this.loaded = false;
        }).catch(error => {
            this.loaded = false;


        });

    }
    athunticateCRPRequest() {
        this.loaded = true;
        setCRPRequest({
            sfId: this.accountId,
            tanurl: this.crpRequestUrl.replace('/authorize', '/confirm'),
            otp: this.otp,
            martialStatus: this.martialStatus
        }).then(response => {
            let result = JSON.parse(response);

            if (result.errors) {
                this.popup = false;
                this.showToast(this.INVALID_TOKEN_ERROR, '', 'error');
                this.loaded = false;
                return;
            }
            this.createCase();

        }).catch(error => {
            this.loaded = false;
            this.popup = false;

        })
    }
    createCase() {
        let subject = `${this.depositAccount} - ${this.customerId} – Tax exemption order`;
        let userEnteredAddress = (this.spouseAddress) ? this.spouseAddress : '';
        let spouseAddress = '';

        if (this.isAddressSameAsSpouse) {
            spouseAddress = `Spouse Address same as customer:
                             ${this.isAddressSameAsSpouse}`;
        }
        else {
            spouseAddress = `Spouse Address:
                            ${userEnteredAddress}`;
        }



        const spouseName = (this.spouseName) ? this.spouseName : '';
        const spouseTaxId = (this.spouseTaxId) ? this.spouseTaxId : '';
        const spouseBirthDay = (this.spouseBirthDay) ? this.getGermanDateValue(new Date(this.spouseBirthDay)) : '';
        const startDate = (this.startDate) ? this.getGermanDateValue(new Date(this.startDate)) : '';
        const endDate = (this.endDate) ? this.getGermanDateValue(new Date(this.endDate)) : '';
        let description = `
        Hi  Solarisbank Team,

        Here is a request for a Tax Exemption Order for the following customer,
        
        Partner: 
        EV Smart Money Holding GmbH


        Customer Name: 
        ${this.customerName}

        Person ID:
        ${this.customerId}
        
        Term Deposit Account: 
        ${this.depositAccount}
        
        Tax ID: 
        ${this.taxId}
        
        Martial Status: 
        ${this.martialStatus}
        
        Spouse Complete Name: 
        ${spouseName}
        
        Spouse Tax ID: 
        ${spouseTaxId}

        ${spouseAddress}
        
        Spouse Birthday:
        ${spouseBirthDay}

        Exemption amount
        ${this.exemptionAmount} €
        
        Order Start Date: 
        ${startDate}
        
        Order End Date: 
        ${endDate}
        
        `;
        this.loaded = true;
        createNewCase({
            accountId: this.accountId,
            bankAccountId: this.bankAccountId,
            subject: subject,
            description: description,
            reason: 'Tax Exemption Order'
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