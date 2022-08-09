import { LightningElement } from 'lwc';

import FirstName from '@salesforce/label/c.FirstName';
import Last_Name from '@salesforce/label/c.Last_Name';
import Email_Address from '@salesforce/label/c.Email_Address';
import Send	 from '@salesforce/label/c.Send';
import SalutationText from '@salesforce/label/c.SalutationText';

import support_kontoform_header	 from '@salesforce/label/c.support_kontoform_header';
import support_kontoform_description from '@salesforce/label/c.support_kontoform_description';
import support_kontoform_tcPart1 from '@salesforce/label/c.support_kontoform_tcPart1';
import support_kontoform_tcPart2 from '@salesforce/label/c.support_kontoform_tcPart2';
import Privacy_Policy from '@salesforce/label/c.Privacy_Policy';
import Data_Protection_Link from '@salesforce/label/c.Data_Protection_Link';
import support_kontoform_mOptin from '@salesforce/label/c.support_kontoform_mOptin';
import support_kontoform_successHeader from '@salesforce/label/c.support_kontoform_successHeader';
import support_kontoform_successDescription from '@salesforce/label/c.support_kontoform_successDescription';
import support_kontoform_successButtonText from '@salesforce/label/c.support_kontoform_successButtonText';
import evsmartmoney_URL from '@salesforce/label/c.evsmartmoney_URL';

import createBankingLead from '@salesforce/apex/CommunitySupportBankingLeadController.createBankingLead'

	
export default class Support_kontoform extends LightningElement {

    rendered = false;
    loading = false;
    disabled = false;
    showSuccess=false;

    parameters;

    //labels
    headerText=support_kontoform_header;
    descripitonText=support_kontoform_description;
    firstNameText=FirstName;
    lastNameText=Last_Name;
    emailText=Email_Address;
    tcTextPart1=support_kontoform_tcPart1;
    tcTextPart2=support_kontoform_tcPart2;
    tcLinkText=Privacy_Policy;
    tcLink=Data_Protection_Link;
    mOptinText=support_kontoform_mOptin;
    buttonText=Send;
    successHeaderText=support_kontoform_successHeader;
    successHeaderDescription=support_kontoform_successDescription;
    successButtonText=support_kontoform_successButtonText;
    homePageUrl=evsmartmoney_URL;
    placeholderSalutationText = SalutationText;

    //options
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


    //values
    moptinAgree;
    tcAgree;
    email;
    lastname;
    firstname;
    salutation;


    /*
    TODO : 
    Create Lead
    RecordType = Banking Customer
    New Fields
    Marketing opt-in and time stamp
    auto response send to customer 

    */

    applyStyle() {
        const style = document.createElement('style');
        style.innerText = `
        .ev-Design .ev-checkbox  .slds-checkbox_faux{
            border-radius: 4px;
            border: 1px solid #BCBDBC;
        }
        .ev-Design .ev-checkbox  abbr,.ev-Design .ev-checkbox .slds-form-element__help{
            display:none;
        }

        

        .ev-Design .slds-has-error .slds-input{
            border-radius: 4px;
            border: 1px solid #B30000  !important;
        }

        .ev-Design .ev-input input{
            border-radius: 4px;
            border: 1px solid #BCBDBC;
            height:48px;
         
        }
        .ev-Design .ev-input label{
            color: #777777;
        }
        
       
        .ev-Design_button .ev-button button{
            background: #EB0A0A;
            border-radius: 4px;
            padding: 0px 24px;
            align-items: center;
            color:white;
            height:48px;
            
            width:200px;
        }
        .ev-Design_button .ev-button button:hover{
            box-shadow: 0 8px 12px 0 rgba(0, 0, 0, 0.13);
        }
        
        
        .ev-Design .ev-checkbox_red  .slds-checkbox_faux{
            border-radius: 4px;
            border: 1px solid #B30000  !important;
        }

        .ev-Design .ev-input .slds-combobox__input{
            height:48px;
            border-radius: 0px;
            align-items: center;
        }

        @media (max-width:  1023px){
            .ev-Design .ev-button button{
                margin-top:12px;
                
            }
        }
        `;
        //applying styles dynmicaly to shadow dom elements
        let inputs = this.template.querySelectorAll('div.ev-Design');
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
        this.parameters = this.getQueryParameters();
    }

    //handlers
    handleValueChange(event) {
        let value = event.target.value;
        let field = event.target.name;
        this[field] = value;
    }
    handleCheckboxValueChange(event) {
        let name = event.target.name;
        let value = event.target.checked;
        this[name] = value;
    }

    onSubmit() {
        let systemValidation=this.checkFieldValidity();
        let customValidation=this.checkFieldDataValidity()
        if (systemValidation && customValidation) {
            this.loading = true;
            this.disabled = true;
            let properties = {
                "utm_source": this.parameters?.utm_source,
                "utm_medium": this.parameters?.utm_medium,
                "utm_campaign": this.parameters?.utm_campaign,
                "utm_term": this.parameters?.utm_term,
                "utm_content": this.parameters?.utm_content,
            };

            createBankingLead({
                salutation:this.salutation,
                firstName:this.firstname,
                lastName:this.lastname,
                emailAddress:this.email,
                utmParameters: properties
            })
            .then(()=>{
                this.topFunction();
                this.showSuccess=true;
            })
            .catch((e)=>{
                console.error(e);
            }).finally(()=>{
                this.loading = false;
            })

            
            setTimeout(() => this.disabled = false, 9000);
        }
    }

    //helper
    checkFieldValidity() {
        let elements = this.template.querySelectorAll('lightning-input');
        return [...elements]
            .reduce((validSoFar, inputCmp) => {
                inputCmp.reportValidity();

                return validSoFar && inputCmp.checkValidity();
            }, true);
    }
    checkFieldDataValidity() {
        let valid = true;
        let emailEle = this.template.querySelector('.email');
        let lastnameEle = this.template.querySelector('.lastname');
        let firstnameEle = this.template.querySelector('.firstname');
        let tcTextEle=this.template.querySelector('.ev-checkbox_tctext');
        let mOptinText=this.template.querySelector('.ev-checkbox_moptintext');
        let tcAgreeEle=this.template.querySelector('.tcAgree');
        let moptinAgreeEle=this.template.querySelector('.moptinAgree');
        let salutationEle=this.template.querySelector('.salutation');



        
        

        if (!this.salutation) {
            salutationEle.setCustomValidity('Dieses Feld ist erforderlich');
            valid = false;
        }
        else {
            salutationEle.setCustomValidity('');
        }
        salutationEle.reportValidity();

        if(!this.tcAgree){
            tcTextEle.classList.add('ev-text_color-red');
            tcAgreeEle.classList.add('ev-checkbox_red');
        }
        else{
            tcTextEle.classList.remove('ev-text_color-red');
            tcAgreeEle.classList.remove('ev-checkbox_red');
        }

        if(!this.moptinAgree){
            mOptinText.classList.add('ev-text_color-red');
            moptinAgreeEle.classList.add('ev-checkbox_red');
            
        }
        else{
            mOptinText.classList.remove('ev-text_color-red');
            moptinAgreeEle.classList.remove('ev-checkbox_red');
        }


        if (!this.email) {
            emailEle.setCustomValidity('Dieses Feld ist erforderlich');
            valid = false;
        }
        else {
            emailEle.setCustomValidity('');
            
        }

        emailEle.reportValidity();

        if (!this.lastname) {
            lastnameEle.setCustomValidity('Bitte geben Sie ihren Nachnamen ein');
            valid = false;
        }
        else {
            lastnameEle.setCustomValidity('');
            
        }

        lastnameEle.reportValidity();

        if (!this.firstname) {
            firstnameEle.setCustomValidity('Bitte geben Sie Ihren Vornamen ein');
            valid = false;
        }
        else {
            firstnameEle.setCustomValidity('');
           
        }

        firstnameEle.reportValidity();

        return valid;
    }

    //utility
    topFunction(){
        const scrollOptions = {
            left: 0,
            top: 0,
            behavior: 'smooth'
        }
        window.scrollTo(scrollOptions);
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
   
}