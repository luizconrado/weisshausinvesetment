import { LightningElement, wire, api, track } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";


import retriveCode from '@salesforce/apex/AgentReferalFormController.fetchCustomerReferalCode';
import retriveBuninessAccountName from '@salesforce/apex/AgentReferalFormController.getBuninessAccountName';

import privacyWebLink from '@salesforce/label/c.Privacy_Web_Link';


//labels
import VerifyAccountText from '@salesforce/label/c.VerifyAccountText';
import VerifiedAccountText from '@salesforce/label/c.VerifiedAccountText';
import TermsAndConditionsText from '@salesforce/label/c.AgentReferalForm_TCTEXT';
import TermsAndConditionsText2 from '@salesforce/label/c.AgentReferalForm_TCTEXT2';
import TermsAndConditionsText3 from '@salesforce/label/c.AgentReferalForm_TCTEXT3';
import TermsAndConditionsText4 from '@salesforce/label/c.AgentReferalForm_TCTEXT4';
import TermsAndConditionsText5 from '@salesforce/label/c.AgentReferalForm_TCTEXT5';

import VerifyButtonText from '@salesforce/label/c.VerifyButtonText';
import SalutationText from '@salesforce/label/c.SalutationText';
import FirstName from '@salesforce/label/c.FirstName';
import Surname from '@salesforce/label/c.Surname';

import AgentReferalForm_Title from '@salesforce/label/c.AgentReferalForm_Title';
import AgentReferalForm_SubTitle from '@salesforce/label/c.AgentReferalForm_SubTitle';
import AgentReferalForm_SuccessTitle from '@salesforce/label/c.AgentReferalForm_SuccessTitle';
import AgentReferalForm_SuccessSubTitle from '@salesforce/label/c.AgentReferalForm_SuccessSubTitle';
import AgentReferalForm_ErrorTitle from '@salesforce/label/c.AgentReferalForm_ErrorTitle';
import AgentReferalForm_Description from '@salesforce/label/c.AgentReferalForm_Description';
import AgentReferalForm_TC2TEXT from '@salesforce/label/c.AgentReferalForm_TC2TEXT';
import PhoneNumber from '@salesforce/label/c.AgentReferalForm_ContactPhoneNumber';
import Email_Address from '@salesforce/label/c.Email_Address';
import AgentReferalForm_EVCustomerQuestion from '@salesforce/label/c.AgentReferalForm_EVCustomerQuestion';
import AgentReferalForm_GenerateLink from '@salesforce/label/c.AgentReferalForm_GenerateLink';
import AgentReferalForm_CopyLink from '@salesforce/label/c.AgentReferalForm_CopyLink';
import AgentReferalForm_ReferalCode from '@salesforce/label/c.AgentReferalForm_ReferalCode';
import AgentReferalForm_ReferalLink from '@salesforce/label/c.AgentReferalForm_ReferalLink';
import AgentReferalForm_ReferalLinkDescription from '@salesforce/label/c.AgentReferalForm_ReferalLinkDescription';
import AgentReferalForm_HeaderText from '@salesforce/label/c.AgentReferalForm_HeaderText';
import Step from '@salesforce/label/c.Step';
import AgentReferalForm_STEP3 from '@salesforce/label/c.AgentReferalForm_STEP3'
import AgentReferalForm_Step3Description from '@salesforce/label/c.AgentReferalForm_Step3Description';
import AgentReferalForm_Step3Description2 from '@salesforce/label/c.AgentReferalForm_Step3Description2';
import AgentReferalForm_Step3Description3 from '@salesforce/label/c.AgentReferalForm_Step3Description3';
import AgentReferalForm_IsCustomerQuestion from '@salesforce/label/c.AgentReferalForm_IsCustomerQuestion';
import AgentReferalForm_OpenAccount from '@salesforce/label/c.AgentReferalForm_OpenAccount';
import AgentReferalForm_AccountQuestion from '@salesforce/label/c.AgentReferalForm_AccountQuestion';
import AgentReferalForm_AccountQuestionDescription from '@salesforce/label/c.AgentReferalForm_AccountQuestionDescription';
import AgentReferalForm_AppStep1 from '@salesforce/label/c.AgentReferalForm_AppStep1';
import AgentReferalForm_AppStep2 from '@salesforce/label/c.AgentReferalForm_AppStep2';
import AgentReferalForm_AppStep23 from '@salesforce/label/c.AgentReferalForm_AppStep23';
import AgentReferalForm_AppStep4 from '@salesforce/label/c.AgentReferalForm_AppStep4';
import AgentReferalForm_LINKCOPIED from '@salesforce/label/c.AgentReferalForm_LINKCOPIED';
import Data_Protection_Link from '@salesforce/label/c.Data_Protection_Link';
import WissehouseWebsite_Url from '@salesforce/label/c.WissehouseWebsite_Url';
import Real_estate_advisor from '@salesforce/label/c.Real_estate_advisor';
import License_partner from '@salesforce/label/c.License_partner';
import Company_name from '@salesforce/label/c.Company_name';
 import Banking_Institution from '@salesforce/label/c.Banking_Institution';
import AgentReferalForm_BankDisclamier from '@salesforce/label/c.AgentReferalForm_BankDisclamier';
import AgentReferalForm_UserNameLabel from '@salesforce/label/c.AgentReferalForm_UserNameLabel';
import AgentReferalForm_UserNameLabel2 from '@salesforce/label/c.AgentReferalForm_UserNameLabel2';
import AgentReferalForm_UserEmail from '@salesforce/label/c.AgentReferalForm_UserEmail';
import AgentReferalForm_UserPhoneLabel from '@salesforce/label/c.AgentReferalForm_UserPhoneLabel';
import AgentReferalForm_STEP3BUTTONTEXT from '@salesforce/label/c.AgentReferalForm_STEP3BUTTONTEXT';





import Yes from '@salesforce/label/c.Yes';
import No from '@salesforce/label/c.No';






export default class AgentReferalForm extends LightningElement {
    //labels
    pagetitle = AgentReferalForm_Title;
    pageSubtitle = AgentReferalForm_SubTitle;
    SUCESSHEADERTEXT = AgentReferalForm_SuccessTitle;
    SUCESSHEADERSUBTEXT = AgentReferalForm_SuccessSubTitle;
    ERRORTEXT = AgentReferalForm_ErrorTitle;
    SUCCESSDESCRIPITONTEXT = AgentReferalForm_Description;
    dataProtectionLink = Data_Protection_Link;
    BANKDATA_DISCLAIMER = AgentReferalForm_BankDisclamier;


    verifyAccountHeaderText = VerifyAccountText;
    subscribedHeadertext = VerifiedAccountText;
    acceptTermsAndConditionsTextStart = TermsAndConditionsText;
    acceptTermsAndConditionsTextDeliveryCondition = TermsAndConditionsText2;
    acceptTermsAndConditionsTextand = TermsAndConditionsText3;
    acceptTermsAndConditionsTextDataProdtection = TermsAndConditionsText4;
    acceptTermsAndConditionsTextEnd = TermsAndConditionsText5;
    placeholderSalutationText = SalutationText;
    firstNameText = FirstName;
    surnameText = Surname;
    phoneNumberText = PhoneNumber;
    emailAddressText = Email_Address;
    privacyLink = privacyWebLink;
    isCusomterLabel = AgentReferalForm_EVCustomerQuestion;
    verifyText = VerifyButtonText;
    personTCAcceptText = AgentReferalForm_TC2TEXT;
    companyNameTitle = Company_name;
    bankNameTitle = Banking_Institution;
    personBusinessAccountLabel=License_partner;

    GENERATELINKBUTTON = AgentReferalForm_GenerateLink;
    COPYLINKTEXT = AgentReferalForm_CopyLink;
    REFERALCODETEXT = AgentReferalForm_ReferalCode;
    REFERALLINKTEXT = AgentReferalForm_ReferalLink;
    REFERALLINKDESCRIPTION = AgentReferalForm_ReferalLinkDescription;
    STEPTEXT = Step;
    HEADERSTEPTEXT = AgentReferalForm_HeaderText;
    AREYOUCUSTOMERQUESTION = AgentReferalForm_IsCustomerQuestion;
    STEP3TEXT = AgentReferalForm_STEP3;
    STEP3BUTTONTEXT=AgentReferalForm_STEP3BUTTONTEXT;
    STEP3DESCRIPTIONTEXT = AgentReferalForm_Step3Description;
    STEP3DESCRIPTIONTEXT2=AgentReferalForm_Step3Description2;
    STEP3DESCRIPTIONTEXT3=AgentReferalForm_Step3Description3;
    OPENACCOUNTTEXT = AgentReferalForm_OpenAccount;
    ISACCOUNTQUESTION = AgentReferalForm_AccountQuestion;
    ISACCOUNTDESCRIPITON = AgentReferalForm_AccountQuestionDescription;
    APPSTEP1TEXT = AgentReferalForm_AppStep1;
    APPSTEP2TEXT = AgentReferalForm_AppStep2;
    APPSTEP3TEXT = AgentReferalForm_AppStep23;
    APPSTEP4TEXT = AgentReferalForm_AppStep4;
    LINKCOPIEDTEXT = AgentReferalForm_LINKCOPIED;

    //urls
    imageUrlSuccess = 'https://ev-smartmoney--c.documentforce.com/servlet/servlet.ImageServer?id=0155I000000eJev&oid=00D5I000002GOw0';
    imageUrlLanding = 'https://ev-smartmoney--c.documentforce.com/servlet/servlet.ImageServer?id=0155I000000eJf5&oid=00D5I000002GOw0';
    imageUrlRedirect = 'https://ev-smartmoney--c.documentforce.com/servlet/servlet.ImageServer?id=0155I000000eT6P&oid=00D5I000002GOw0';
    pieIconUrl = 'https://ev-smartmoney--c.documentforce.com/servlet/servlet.ImageServer?id=0155I000000eT6U&oid=00D5I000002GOw0';
    noteIconUrl = 'https://ev-smartmoney--c.documentforce.com/servlet/servlet.ImageServer?id=0155I000000eT6e&oid=00D5I000002GOw0';
    downloadIconUrl = 'https://ev-smartmoney--c.documentforce.com/servlet/servlet.ImageServer?id=0155I000000eT6j&oid=00D5I000002GOw0';
    emailIconUrl = 'https://ev-smartmoney--c.documentforce.com/servlet/servlet.ImageServer?id=0155I000000eT6o&oid=00D5I000002GOw0';
    numberOneIcon = 'https://ev-smartmoney--c.documentforce.com/servlet/servlet.ImageServer?id=0155I000000eYnE&oid=00D5I000002GOw0';
    numberTwoIcon = 'https://ev-smartmoney--c.documentforce.com/servlet/servlet.ImageServer?id=0155I000000eYnJ&oid=00D5I000002GOw0';
    numberThreeIcon = 'https://ev-smartmoney--c.documentforce.com/servlet/servlet.ImageServer?id=0155I000000eYnT&oid=00D5I000002GOw0';

    //states
    loaded = false;
    showStep1 = true;
    showStep2 = false;
    showStep3 = false;
    showError = false;
    showisCustomerPopup = false;
    showLinkCopyMsg = false;
    customerTypeSelected = 'personAccount';
    isPersonAccount = true;
    searchAccount = true;

    salutation;
    firstName;
    lastName;
    emailAddress;
    phoneNumber;
    isCustomer;
    isPersonAccountAccept;
    isPrivacyLink;
    companyName;
    companyId;
    companyVatNumber;
    bankName;
    customerIban;

    accountList = [];
    orignalAccountList = [];

    customerTypes = [
        { label: Real_estate_advisor, value: 'personAccount' },
        { label: License_partner, value: 'businessAccount' },
    ];

    get isCustomerCheck() {
        return (this.isCustomer == 'Yes') ? true : false;
    }

    get isCustomerSearch() {
        return this.accountList.length > 0;
    }


    code = '';
    refrelLink = WissehouseWebsite_Url + '/de/landing-page/immobilienkonto?utm_source=sfagentreferral&utm_medium=ambassador&utm_campaign=onboarding&utm_term=';



    salutationsList_de = [
        { label: 'Herr', value: 'Herr' },
        { label: 'Frau', value: 'Frau' },
        { label: 'Herr Dr.', value: 'Herr Dr.' },
        { label: 'Frau Dr.', value: 'Frau Dr.' },
        { label: 'Herr Prof.', value: 'Herr Prof.' },
        { label: 'Frau  Prof.', value: 'Frau  Prof.' },
    ];
    isCustomerOptions = [
        { label: Yes, value: 'Yes' },
        { label: No, value: 'No' },
    ]
    get salutationOptions() {
        return this.salutationsList_de;
    }


    accountName = '';


    @wire(retriveBuninessAccountName, {
        accName: '$companyName',
    })
    retrieveAccounts({ error, data }) {
        if (data) {
            if (this.companyName.length < 3 || this.searchAccount === false) {
                this.accountList = [];
            }
            else {
                this.accountList = data;
                this.orignalAccountList = data;
            }

        }
        else if (error) {
            console.error(error)
        }

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
    rendered = false;
    renderedCallback() {
        if (this.rendered) return;
        this.applyStyle();
        this.rendered = true;
    }




    handleValueChange(event) {
        let value = event.target.value;
        let name = event.target.name;
        this[name] = value;

        if (name === 'companyName') {
            this.searchAccount = true;
            if (value.length < 3) this.accountList = [];
        }

    }
    handleCheckboxValueChange(event) {
        let name = event.target.name;
        let value = event.target.checked;
        this[name] = value;
    }
    handleRadioValueChange(event) {
        let name = event.target.name;
        let value = event.target.value;
        this[name] = value;

        if (name == 'customerTypeSelected' && value === 'personAccount') {
            this.isPersonAccount = true;
        }
        else if (name == 'customerTypeSelected' && value === 'businessAccount') {
            this.isPersonAccount = false;
        }
        this.setLabels();

    }
    handleSearchField(event) {
        const ESCAPE = 27;
        if (event.keyCode === ESCAPE) this.accountList = [];
    }

    handleAccountSelected(event) {
        let accountId = event.target.id;
        if (accountId) accountId = accountId.split('-')[0];
        let selectedAccount = this.accountList.filter(a => a.Id === accountId);
        if (selectedAccount.length > 0) {
            this.searchAccount = false;
            this.companyName = selectedAccount[0].Name;
            this.companyId = selectedAccount[0].Id;
            this.accountList = [];
        }
    }
    copyLink() {
        const el = document.createElement('textarea');
        el.value = this.refrelLink;
        document.body.appendChild(el);
        el.select();
        document.execCommand('copy');
        document.body.removeChild(el)
        this.showLinkCopyMsg = true;
    }


    handleSave(event) {
        let that = this;
        if (this.checkFieldValidity()) {
            let isExsistingCustomer = (this.isCustomer == 'Yes') ? true : false;

            //security check if user changed name after selecting account
            if (this.companyId) {
                let isCompanySame = this.orignalAccountList.filter(a => a.Name.toUpperCase() == this.companyName.trim().toUpperCase());
                if (isCompanySame.length == 0) this.companyId = null;

            }

            const phone = (this.phoneNumber) ? this.phoneNumber.trim() : '';
            const bank = (this.bankName) ? this.bankName.trim() : '';
            const iban = (this.customerIban) ? this.customerIban.trim() : '';
            const accountName=(this.companyName)?this.companyName.trim():'';
            const companyPersonId=(this.companyId)?this.companyId.trim():'';
            const payload = `{
                "accountName":"${accountName}",
                "companyId":"${companyPersonId}",
                "bankName":"${bank}",
                "bankIban":"${iban}",
                "email": "${this.emailAddress}",
                "phone": "${phone}",
                "salutation": "${this.salutation}",
                "firstname": "${this.firstName}",
                "lastname": "${this.lastName}",
                "isExsistingCustomer": ${isExsistingCustomer},
                "isPersonAccount":${this.isPersonAccount}
            }`
            that.loaded = true;
            try {
                retriveCode({ payload: payload }).then(result => {
                    if (result) {
                        that.code = result;
                        that.refrelLink = this.refrelLink + this.code;
                        that.togglePage(2);
                    }
                    else {
                        that.togglePage(0);
                    }
                    that.loaded = false;

                })
                    .catch(error => {
                        console.error('error', error)
                        that.showToast('Error', error.body.message, 'error');

                        that.loaded = false;
                    }).finally(() => that.loaded = false)
            }
            catch (err) {
                console.error('error', err)
                that.loaded = false
            }

        }
    }

    showDownloadInstructions() {
        this.togglePage(3);
    }


    togglePage(step) {
        if (step == 1) {
            this.showStep1 = true;
            this.showStep2 = false;
            this.showStep3 = false;
        }
        else if (step == 2) {
            this.showStep1 = false;
            this.showStep2 = true;
            this.showStep3 = false;
            this.showCustomerPopup();
        }
        else if (step == 3) {
            this.showisCustomerPopup = false;
            this.showStep1 = false;
            this.showStep2 = false;
            this.showStep3 = true;
        }
        else if (step == 0) {
            this.showError = true;
            this.showStep1 = false;
            this.showStep2 = false;
            this.showStep3 = false;
        }
    }
    hideCustomerPopup() {
        this.showisCustomerPopup = false;
    }
    showCustomerPopup() {
        /* Not needed any more remove this
        let that = this;
        if (this.showStep3 == false && this.showisCustomerPopup == false) {
            setTimeout(function () {
                that.showisCustomerPopup = true;
            }, 5000);
        }
        */
    }
    setLabels() {
        if (this.isPersonAccount) {
            this.firstNameText = FirstName;
            this.surnameText = Surname;
            this.phoneNumberText = PhoneNumber;
            this.emailAddressText = Email_Address;
            
        }
        else {

            this.firstNameText = AgentReferalForm_UserNameLabel;
            this.surnameText = AgentReferalForm_UserNameLabel2;
            this.emailAddressText = AgentReferalForm_UserEmail;
            this.phoneNumberText = AgentReferalForm_UserPhoneLabel;
        }




    }

    //validator
    checkFieldValidity() {
        let elements = this.template.querySelectorAll('lightning-input,lightning-combobox,lightning-textarea');
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