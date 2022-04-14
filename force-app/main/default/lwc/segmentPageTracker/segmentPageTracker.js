import { LightningElement, api } from 'lwc';

export default class SegmentPageTracker extends LightningElement {
    parameters = {};
    segmentRetryCount = 0;
    success = false;
    @api name = '';
    loadSegment() {
        try {
            this.segmentRetryCount += 1;
            let pageNamename = this.name || window.location.pathname;
            if (!this.success)
                window.analytics.page(pageNamename, this.parameters)
                    .then(() => this.success = true)
                    .catch(() => console.error("Segement error"));
        } catch (e) {

            if (this.segmentRetryCount < 4) {
                setTimeout(() => this.loadSegment(), 3000)
            }
            else {
                console.error("Segement timeout")
            }

        }
    }
    connectedCallback() {
        this.parameters = this.getQueryParameters();
    }

    rendered = false;
    renderedCallback() {
        if (this.rendered) return;
        setTimeout(() => this.loadSegment(), 1000)


        this.rendered = true;
    }
    getQueryParameters() {

        let params = {};
        let search = (location.search) ? location.search.substring(1) : undefined;

        if (search) {
            params = JSON.parse('{"' + search.replace(/&/g, '","').replace(/=/g, '":"') + '"}', (key, value) => {
                return key === "" ? value : decodeURIComponent(value)
            });
        }

        return params;
    }

}