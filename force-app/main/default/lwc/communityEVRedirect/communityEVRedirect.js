import { LightningElement } from 'lwc';
import evsmartmoney_URL from '@salesforce/label/c.evsmartmoneyInvestment_URL';

export default class CommunityHomeRedirect extends LightningElement {
    connectedCallback() {
        setTimeout(function () { window.location.href = evsmartmoney_URL }, 4000);
    }
}