import { LightningElement, api } from 'lwc';
import confirmEmail from '@salesforce/apex/SubscriptionService.confirmSubscriptionOfLead';
import { NavigationMixin, CurrentPageReference } from 'lightning/navigation';

export default class Waitinglist_verifyLead extends LightningElement {

    @api headerText;
    @api headerDescription;

    parameters;


    connectedCallback() {


        this.parameters = this.getQueryParameters();
        
        if (this.parameters.email && this.parameters.product)
            this.handleOnInit();

    }

    handleOnInit() {
        console.info(decodeURIComponent(this.parameters.email))
        console.info(decodeURIComponent(this.parameters.product))
        const params = {
            "email": decodeURIComponent(this.parameters.email),
            "product": decodeURIComponent(this.parameters.product),
        };

        confirmEmail(params)
            .then(result => {


                //setTimeout(() => location.href = 'https://www.ev-smartmoney.com/', 5000);

            })
            .catch(error => {
                console.error(error);
            })
    }

    getQueryParameters() {

        let params = {};
        let search = (window.location.search) ? window.location.search.substring(1) : undefined;

        if (search) {
            params = JSON.parse('{"' + search.replace(/&/g, '","').replace(/=/g, '":"') + '"}', (key, value) => {
                return key === "" ? value : decodeURIComponent(value)
            });
        }

        return params;
    }
}