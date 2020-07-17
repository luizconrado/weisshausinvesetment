window._snapinsSnippetSettingsFile = (function () {
    console.log('Chat setup load')
    let Origin = window.location.origin || window.location.href || 'unknown';
    console.log('Chat Origin', Origin)
    embedded_svc.settings.extraPrechatFormDetails = [
        {
            "label": "Vorname",
            "transcriptFields": ["Last_Name__c"],
            "displayToAgent": true

        },
        {
            "label": "Nachname",
            "transcriptFields": ["First_Name__c"],
            "displayToAgent": true

        },
        {
            "label": "E-Mail",
            "transcriptFields": ["Email__c"],
            "displayToAgent": true

        },
        {
            "label": "Chat Origin",
            "transcriptFields": ["Chat_Origin__c"],
            "value": Origin,
            "displayToAgent": true

        }
    ];
})();