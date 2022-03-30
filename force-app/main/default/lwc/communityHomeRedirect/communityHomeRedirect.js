import { LightningElement } from 'lwc';
import evsmartmoney_URL from '@salesforce/label/c.evsmartmoney_URL';

export default class CommunityHomeRedirect extends LightningElement {
    connectedCallback() {
        setTimeout(function () { location.href = evsmartmoney_URL }, 4000);
    }
}