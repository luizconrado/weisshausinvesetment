import { LightningElement,api } from 'lwc';
import register from '@salesforce/apex/SubscriptionService.createLeadAndSubscription';




export default class Waitinglist_leadSubscripiton extends LightningElement {
    
    @api subscriptionType;
    @api leadOrigin='Website';
    @api tcText;
    
    @api tcLink;
    @api tcLinkText;


    isTcAccepted;
    emailAddress;
    lastName;
    firstName;
    loaded;


    parameters = {};



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
         
          
        }
        .ev-Design .ev-button button{
            background: #EB0A0A;
            border-radius: 4px;
            padding: 0px 24px;
            align-items: center;
            color:white;
            height:48px;
            width:60%;
            
            
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

    connectedCallback() {

        this.parameters = this.getQueryParameters();

    }

    //handler
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

    //server call
    subscribe() {
        let that = this;
        if (this.validate()) {
            that.loaded = true;
            try {
                let properties = {
                    "utm_source": this.parameters?.utm_source,
                    "utm_medium": this.parameters?.utm_medium,
                    "utm_campaign": this.parameters?.utm_campaign,
                    "utm_term": this.parameters?.utm_term,
                    "utm_content": this.parameters?.utm_content,
                };

                const fullurl = location.href;

                register(
                    {
                        firstName:this.firstName,
                        lastName:this.lastName,
                        email: this.emailAddress,
                        productName: this.subscriptionType,
                        origin: this.leadOrigin,
                        website: fullurl,
                        utmParameters: properties
                    }
                ).
                    then(result => {
                        that.showToast("Vielen Dank für Ihre Anmeldung. Bitte prüfen Sie Ihr E-Mail-Postfach und bestätigen Sie Ihre E-Mail-Adresse.");
                    })
                    .catch(error => {
                        console.error('error', error)
                        that.showToast("Bitte geben Sie die richtige E-Mail-Adresse ein.");
                        that.loaded = false;
                    }).finally(() => {
                        setTimeout(() => {
                            that.loaded = false
                        }, 60000);
                    })
            }
            catch (err) {
                console.error('error', err)
                that.loaded = false
            }
        }
    }

    //helper
    showToast(text) {
        this.template.querySelector("c-ev-toast").showToast(text);
    }
    validate() {
        let checkbox = this.template.querySelector('.tc-checkbox');
        let checkboxText = this.template.querySelector('.ev-checkbox_text');
        let tc_link = this.template.querySelector('.tc_link');
        let email_textbox = this.template.querySelector('.email-textbox');
        let fist = this.template.querySelector('.fist-textbox');
        let last = this.template.querySelector('.last-textbox');

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






        return this.isTcAccepted && this.emailAddress && email_textbox.reportValidity() && fist.reportValidity() && last.reportValidity();
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