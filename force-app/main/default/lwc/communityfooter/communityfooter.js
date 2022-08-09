import { LightningElement } from 'lwc';

import evsmartmoney_URL from '@salesforce/label/c.evsmartmoney_URL';

export default class Communityfooter extends LightningElement {
    hostUrl = evsmartmoney_URL
    support = 'https://support.ev-smartmoney.com/s/kontoanmeldung?language=de';
    impressum = this.hostUrl + '/imprint';
    datenschutz = this.hostUrl + '/datenschutz';
    agb = this.hostUrl + '/signup';

    footerlogo = 'https://ev-smartmoney--c.documentforce.com/servlet/servlet.ImageServer?id=0155I000000nLMT&oid=00D5I000002GOw0';
    emailIcon = 'https://ev-smartmoney--c.documentforce.com/servlet/servlet.ImageServer?id=0155I000000eT6o&oid=00D5I000002GOw0';
    clockIcon = 'https://ev-smartmoney--c.documentforce.com/servlet/servlet.ImageServer?id=0155I000000ebs2&oid=00D5I000002GOw0';
    homeIcon = 'https://ev-smartmoney--c.documentforce.com/servlet/servlet.ImageServer?id=0155I000000ebs7&oid=00D5I000002GOw0';
    phoneIcon = 'https://ev-smartmoney--c.documentforce.com/servlet/servlet.ImageServer?id=0155I000000ebsC&oid=00D5I000002GOw0';
    


    smartmoney = 'https://ev-smartmoney--c.documentforce.com/servlet/servlet.ImageServer?id=0155I000000dk5N&oid=00D5I000002GOw0';
    commercial = 'https://ev-smartmoney--c.documentforce.com/servlet/servlet.ImageServer?id=0157T000000sweh&oid=00D5I000002GOw0';
    yatching = 'https://ev-smartmoney--c.documentforce.com/servlet/servlet.ImageServer?id=0157T000000swem&oid=00D5I000002GOw0';
    charity = 'https://ev-smartmoney--c.documentforce.com/servlet/servlet.ImageServer?id=0157T000000swer&oid=00D5I000002GOw0';
    captial = 'https://ev-smartmoney--c.documentforce.com/servlet/servlet.ImageServer?id=0157T000000swew&oid=00D5I000002GOw0';
    devlopment = 'https://ev-smartmoney--c.documentforce.com/servlet/servlet.ImageServer?id=0157T000000swf1&oid=00D5I000002GOw0';
    school = 'https://ev-smartmoney--c.documentforce.com/servlet/servlet.ImageServer?id=0157T000000swf6&oid=00D5I000002GOw0';
    aviation = 'https://ev-smartmoney--c.documentforce.com/servlet/servlet.ImageServer?id=0157T000000swfB&oid=00D5I000002GOw0';
    gg = 'https://ev-smartmoney--c.documentforce.com/servlet/servlet.ImageServer?id=0157T000000swfG&oid=00D5I000002GOw0';

}