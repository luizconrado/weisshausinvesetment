import { LightningElement } from 'lwc';

import CreateCase from '@salesforce/apex/CommunityWLSupportPageController.createCase';

import INVESTMENT_WEBSITE from '@salesforce/label/c.evsmartmoneyInvestment_URL'

export default class WaitingList_supportPage extends LightningElement {

    loading = false;

    email;
    subject;
    description;
    tcAccept = false;
    disableTimeout = false;

    get isFormDisabled() {
        return this.loading || this.disableTimeout;
    }


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
        
        .ev-Design .ev-input textarea{
            border-radius: 4px;
            border: 1px solid #BCBDBC;
            min-height:100px;
        }
        .ev-Design .ev-button button{
            background: #EB0A0A;
            border-radius: 4px;
            padding: 0px 24px;
            align-items: center;
            color:white;
            height:48px;
            
            width:200px;
        }
        .ev-Design .ev-button button:hover{
            box-shadow: 0 8px 12px 0 rgba(0, 0, 0, 0.13);
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

    rendered = false;
    renderedCallback() {
        if (this.rendered) return;
        this.applyStyle();

        this.rendered = true;
    }

    handleValueChange(event) {
        this[event.target.name] = event.target.value;
    }
    handleCheckChange(event) {
        const datasets = event.currentTarget.dataset
        let name = datasets.name;
        if (name === 'tcAcceptText') {
            this.tcAccept = !this.tcAccept;
            return;
        }


        this[event.target.name] = event.target.checked;
    }
    navigateToHome() {
        window.location.href = INVESTMENT_WEBSITE;
    }

    handleSave(event) {
        if (this.validate()) {
            this.loading = true;
            CreateCase({
                subject: this.subject,
                description: this.description,
                email: this.email,
                recordTypeName: 'Investment_Case'
            })
                .then(result => {
                    this.showToast("Your message has been sent.")
                    this.loading = false;
                    this.disableCaseCreation();
                })
                .catch(error => {
                    console.error(error);
                    this.loading = false;
                })
        }
    }


    validate() {
        let isEmail = false;
        let isSubject = false;
        let isDesc = false;

        let email = this.template.querySelector('.email-input');
        if (email) {
            email.reportValidity();
            isEmail = email.checkValidity();
        }

        let subject = this.template.querySelector('.subject-input');
        if (subject) {
            subject.reportValidity();
            isSubject = email.checkValidity();
        }
        let desc = this.template.querySelector('.desc-input');
        if (desc) {
            desc.reportValidity();
            isDesc = email.checkValidity();
        }


        let tcElement = this.template.querySelector('.checkbox-input');
        if (tcElement) {
            tcElement.reportValidity();
            email.checkValidity();
        }



        return this.tcAccept && isEmail && isSubject && isDesc;

    }

    showToast(text) {
        this.template.querySelector("c-ev-toast").showToast(text);
    }
    disableCaseCreation(){
        this.disableTimeout=true;
        setTimeout(()=> {
            this.disableTimeout=false;
          }, 60000);
          
    }
}