import { LightningElement, api, wire } from 'lwc';


import fetchTopArticle from '@salesforce/apex/CommunityArticleService.getTopArticles';
export default class TopArticles extends LightningElement {
    load = false;
    topArticles;
    @api title;

    @wire(fetchTopArticle)
    wiredKnowlodge({ error, data }) {
        if (error) {
            console.log(error)
        } else if (data) {
            this.topArticles = data.map(a => {
                let record = JSON.parse(JSON.stringify(a));
                record.Url = `/s/article/${record.UrlName}`;
                return record;
            })
            this.load = true;
            console.log(this.topArticles)
        }
    }
    chatClick() {

    }
}