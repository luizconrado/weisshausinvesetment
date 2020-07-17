import { LightningElement, api, wire } from 'lwc';


import fetchTopArticle from '@salesforce/apex/CommunityArticleService.getTopArticles';
import uri from '@salesforce/label/c.community_uri';

export default class TopArticles extends LightningElement {
    load = false;
    topArticles;
    questionLogo
    @api title;

    connectedCallback() {
        let support = uri.replace('s/', '');
        this.questionLogo = `${support}resource/Support_Images/question.png`
    }

    @wire(fetchTopArticle)
    wiredKnowlodge({ error, data }) {
        if (error) {
            console.log(error)
        } else if (data) {
            this.topArticles = data.map(a => {
                let record = JSON.parse(JSON.stringify(a));
                record.Url = `${uri}article/${record.UrlName}`;
                return record;
            })
            this.load = true;
            console.log(this.topArticles)
        }
    }
    chatClick() {

    }
}