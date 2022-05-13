import { LightningElement, api } from 'lwc';

export default class Waitinglist_section1 extends LightningElement {
    @api imageUrl;

    @api headerText;

    @api headerDescription;
    @api headerDescription2;

    get showDescripiton2(){
        return (this.headerDescription2)?true:false;
    }

    @api subscriptionType;

    @api tcText;
    @api tcLink;
    @api tcLinkText;
    @api showSubscribeButton;

    rendered = false;
    renderedCallback() {
        if (this.rendered) return;
        this.applyStyle();
        this.rendered = true;
    }

    applyStyle() {

        const divs = this.template.querySelectorAll('div.ev_section-image');

        if (divs) {
            divs[0].style.backgroundImage = `url(${this.imageUrl})`;
        }
    }
}