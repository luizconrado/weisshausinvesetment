/**
 * Created by prasad on 18.06.20.
 */

import { LightningElement, api } from 'lwc';
import uri from '@salesforce/label/c.community_uri';
import compTitle from '@salesforce/label/c.ContactButton_Title';
import compLabel from '@salesforce/label/c.ContactButton_buttonLabel';
import compDesc from '@salesforce/label/c.ContactButton_Description';
export default class ChatButton extends LightningElement {
    chatLogo
    @api title;
    @api description;
    @api buttonLabel;

    connectedCallback() {
        let support = uri.replace('s/', '');
        this.chatLogo = `${support}resource/Support_Images/chat-3.png`
        this.title = compTitle;
        this.description = compDesc;
        this.buttonLabel = compLabel;
    }
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