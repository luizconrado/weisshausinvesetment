import { LightningElement, api } from 'lwc';
import confirmEmail from '@salesforce/apex/SubscriptionService.confirmSubscriptionOfUser';
import confirmLeadEmail from '@salesforce/apex/SubscriptionService.confirmSubscriptionOfLead';
import { NavigationMixin, CurrentPageReference } from 'lightning/navigation';

export default class WaitingList_confirmEmail extends LightningElement {

    @api headerText;
    @api headerDescription;
    @api object = 'Account';

    parameters;


    connectedCallback() {


        this.parameters = this.getQueryParameters();

        if (this.parameters.email && this.parameters.product)
            this.handleOnInit();

    }

    handleOnInit() {
        const params = {
            "email": decodeURIComponent(this.parameters.email),
            "product": decodeURIComponent(this.parameters.product),
        };

        if (this.object == 'Account') {
            confirmEmail(params)
                .then(result => {


                    //setTimeout(() => location.href = 'https://www.ev-smartmoney.com/', 5000);

                })
                .catch(error => {
                    console.error(error);
                })
        }
        else if (this.object == 'Lead') {
            confirmLeadEmail(params)
                .then(result => {


                    //setTimeout(() => location.href = 'https://www.ev-smartmoney.com/', 5000);

                })
                .catch(error => {
                    console.error(error);
                })
        }
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