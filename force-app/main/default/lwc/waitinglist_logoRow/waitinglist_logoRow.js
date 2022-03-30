import { LightningElement, api } from 'lwc';

export default class Waitinglist_logoRow extends LightningElement {
    @api logoUrl1;
    @api logoUrl2;
    @api logoUrl3;

    @api logoText1;
    @api logoText2;
    @api logoText3;

}