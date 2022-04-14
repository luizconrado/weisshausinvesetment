import { LightningElement, api, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';

import fetchTopArticle from '@salesforce/apex/CommunityArticleService.getTopArticles';
import uri from '@salesforce/label/c.community_uri';
import compTitle from '@salesforce/label/c.TopArticle_Title';


export default class TopArticles extends LightningElement {
    load = false;
    topArticles;
    questionLogo
    @api title;
    compURl
    connectedCallback() {
        let support = uri.replace('s/', '');
        this.questionLogo = `${support}resource/Support_Images/question.png`;
        this.title = compTitle;

    }

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        this.compURl = currentPageReference?.state?.language || 'de';
    }

    @wire(fetchTopArticle, {
        url: '$compURl'
    })
    wiredKnowlodge({ error, data }) {
        if (error) {
            console.error(error)
        } else if (data) {
            this.topArticles = data.map(a => {
                let record = JSON.parse(JSON.stringify(a));
                record.Url = `${uri}article/${record.UrlName}`;
                return record;
            })
            this.load = true;
        }
    }
    chatClick() {

    }
}