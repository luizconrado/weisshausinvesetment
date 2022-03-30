import { LightningElement, api } from 'lwc';
import register from '@salesforce/apex/SubscriptionService.registerSubscription';

export default class Waitinglist_subscription extends LightningElement {

    @api subscriptionType;

    isTcAccepted;
    emailAddress;
    loaded;


   

    applyStyle() {
        const style = document.createElement('style');
        style.innerText = `
        .ev-Design .ev-checkbox  .slds-checkbox_faux{
            border-radius: 4px;
            border: 1px solid #BCBDBC;
        }

        .ev-Design .ev-checkbox_red  .slds-checkbox_faux{
            border-radius: 4px;
            border: 1px solid #B30000  !important;
        }

        .ev-Design .ev-input input{
            border-radius: 4px;
            border: 1px solid #BCBDBC;
            height:48px;
            color:#BCBDBC;
          
        }
        .ev-Design .ev-button button{
            background: #EB0A0A;
            border-radius: 4px;
            padding: 0px 24px;
            align-items: center;
            color:white;
            height:48px;
            
            
        }
        .ev-Design .ev-button button:hover{
            box-shadow: 0 8px 12px 0 rgba(0, 0, 0, 0.13);
        }
        @media (max-width:  1023px){
            .ev-Design .ev-button button{
                margin-top:12px;
                width:100%
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

    handleCheckboxValueChange(event) {
        let name = event.target.name;
        let value = event.target.checked;
        this[name] = value;
    }
    handleValueChange(event) {
        let value = event.target.value;
        let name = event.target.name;
        this[name] = value;



    }

    subscribe() {
        let that = this;
        if (this.validate()) {
            that.loaded = true;
            try {
                register({ email: this.emailAddress, productName: this.subscriptionType, origin: 'Marketing Website', website: window.location.origin }).
                    then(result => {
                      
                        that.showToast();
                    })
                    .catch(error => {
                        console.error('error', error)
                        that.loaded = false;
                    }).finally(() => that.loaded = false)
            }
            catch (err) {
                console.error('error', err)
                that.loaded = false
            }
        }
    }

    showToast() {
        this.template.querySelector("c-ev-toast").showToast("Vielen Dank für Ihre Anmeldung. Bitte bestätigen Sie Ihre E-Mail-Adresse.");
    }
    validate() {
        let checkbox = this.template.querySelector('.tc-checkbox');
        let checkboxText = this.template.querySelector('.ev-checkbox_text');
        let tc_link = this.template.querySelector('.tc_link');

        if (this.isTcAccepted) {
            checkbox.classList.remove('ev-checkbox_red');
            checkbox.classList.add('ev-checkbox');

            checkboxText.classList.remove('ev-text_color-red');
            tc_link.classList.remove('ev-text_color-red');

        }
        else if (!this.isTcAccepted) {
            checkbox.classList.add('ev-checkbox_red');
            checkbox.classList.remove('ev-checkbox');

            checkboxText.classList.add('ev-text_color-red');
            tc_link.classList.add('ev-text_color-red');
        }

        return this.isTcAccepted && this.emailAddress;
    }
}