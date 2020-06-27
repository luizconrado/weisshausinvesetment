/**
 * Created by prasad on 18.06.20.
 */

import {LightningElement, api} from 'lwc';

export default class ChatButton extends LightningElement {

    @api title;
    @api description;
    @api buttonLabel;

    chatClick() {
        if (this.template.querySelectorAll('.outter-wrapper')[0]) {
            let chatEvent = new CustomEvent(
                'chatEvent',
                {
                    detail: {
                        startChat: true
                    },
                    bubbles: true,
                    cancelable: true
                }
            );
            this.template.querySelectorAll('.outter-wrapper')[0].dispatchEvent(chatEvent);
        }
    }

}