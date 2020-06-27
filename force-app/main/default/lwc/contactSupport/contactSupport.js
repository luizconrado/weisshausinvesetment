/**
 * Created by prasad on 18.06.20.
 */

import {LightningElement, api} from 'lwc';
import {NavigationMixin} from 'lightning/navigation'; ///Navigation

export default class ContactSupport extends NavigationMixin(LightningElement) {

    @api title;
    @api description;
    @api buttonLabel;

    openContactSupport() {
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                pageName: 'contactsupport',
            },
        });
    }
}