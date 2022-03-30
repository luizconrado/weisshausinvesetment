import { LightningElement } from 'lwc';

import evsmartmoney_URL from '@salesforce/label/c.evsmartmoney_URL';

export default class Communityfooter extends LightningElement {
    hostUrl = evsmartmoney_URL
    footerlogo = 'https://ev-smartmoney--c.documentforce.com/servlet/servlet.ImageServer?id=0155I000000nLMT&oid=00D5I000002GOw0';
    emailIcon = 'https://ev-smartmoney--c.documentforce.com/servlet/servlet.ImageServer?id=0155I000000eT6o&oid=00D5I000002GOw0';
    clockIcon = 'https://ev-smartmoney--c.documentforce.com/servlet/servlet.ImageServer?id=0155I000000ebs2&oid=00D5I000002GOw0';
    homeIcon = 'https://ev-smartmoney--c.documentforce.com/servlet/servlet.ImageServer?id=0155I000000ebs7&oid=00D5I000002GOw0';
    phoneIcon = 'https://ev-smartmoney--c.documentforce.com/servlet/servlet.ImageServer?id=0155I000000ebsC&oid=00D5I000002GOw0';
    verbraucherinformationenUrl = evsmartmoney_URL + '/de/verbraucherinformationen';
    datenschutzUrl=evsmartmoney_URL + '/de/datenschutz';
    impressumUrl = evsmartmoney_URL + '/de/impressum';
    newsUrl = evsmartmoney_URL + '/de/news';
    supportUrl = evsmartmoney_URL + '/de/support';
    uberunsUrl = evsmartmoney_URL + '/de/uberuns';
    bankingUrl = evsmartmoney_URL + '/de/banking'
    immobilienUrl = evsmartmoney_URL + '/de/immobilien';
}