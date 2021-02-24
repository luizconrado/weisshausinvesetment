/**
 * Created by prasad on 18.06.20.
 */

import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation'; ///Navigation
import uri from '@salesforce/label/c.community_uri';
import compTitle from '@salesforce/label/c.ContactSupport_Title';
import compDesc from '@salesforce/label/c.ContactSupport_Description';
import compLabel from '@salesforce/label/c.ContactSupport_ButtonLabel';

export default class ContactSupport extends NavigationMixin(LightningElement) {
    emailLogo
    @api title;
    @api description;
    @api buttonLabel;

    connectedCallback() {
        let support = uri.replace('s/', '');
        this.emailLogo = `${support}resource/Support_Images/email.png`;
        this.title = compTitle;
        this.description = compDesc;
        this.buttonLabel = compLabel;
    }

    openContactSupport() {
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                pageName: 'contactsupport',
            },
        });
    }
}