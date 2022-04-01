import { LightningElement, api } from 'lwc';
import confirmEmail from '@salesforce/apex/SubscriptionService.registerWaitingListSubscriptionUser';
export default class WaitingList_confirmEmail extends LightningElement {

    @api headerText;
    @api headerDescription;

    parameters;

    connectedCallback() {

        this.parameters = this.getQueryParameters();
        console.log(this.parameters)
        if (this.parameters.email && this.parameters.product)
            this.handleOnInit();

    }

    handleOnInit() {
        const params = {
            "email": this.parameters.email,
            "product": this.parameters.product,
        };
        console.log('params', params)
        confirmEmail(params)
            .then(result => {


                setTimeout(() => location.href = 'https://www.ev-smartmoney.com/', 5000);

            })
            .catch(error => {
                console.error(error);
            })
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