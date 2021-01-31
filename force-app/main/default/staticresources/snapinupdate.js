window._snapinsSnippetSettingsFile = (function () {
    let Origin = window.location.origin || window.location.href || 'unknown';

    embedded_svc.snippetSettingsFile.extraPrechatFormDetails = [
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

    embedded_svc.snippetSettingsFile.extraPrechatInfo = [{
        "entityFieldMaps": [{
            "doCreate": false,
            "doFind": false,
            "fieldName": "LastName",
            "isExactMatch": false,
            "label": "Nachname"
        }, {
            "doCreate": false,
            "doFind": false,
            "fieldName": "FirstName",
            "isExactMatch": false,
            "label": "Vorname"
        }, {
            "doCreate": false,
            "doFind": true,
            "fieldName": "Email",
            "isExactMatch": true,
            "label": "E-Mail"
        }],
        "entityName": "Contact"
    }];

    //embeddedServiceLiveAgentStateOfflineSupportDefaultUI
    let embeddedServiceHelpButton = document.querySelector(".embeddedServiceHelpButton");
    let config = { attributes: true, childList: true }

    let observer = new MutationObserver((mutations) => {
        let embeddedServiceLiveAgentStateOfflineSupportDefaultUI = document.querySelector(".embeddedServiceLiveAgentStateOfflineSupportDefaultUI");
        console.log('embeddedServiceLiveAgentStateOfflineSupportDefaultUI')
        if (embeddedServiceLiveAgentStateOfflineSupportDefaultUI) {
            let fieldList = embeddedServiceLiveAgentStateOfflineSupportDefaultUI.querySelector('.fieldList');
            console.log('fieldList', fieldList)
            let infoTextDiv = document.createElement('DIV');
            infoTextDiv.setAttribute('class', 'embeddedServiceSidebarFormField offline-info');
            infoTextDiv.innerText = 'Bitte geben Sie Ihre E-Mail-Adresse und Ihr Thema.Einer unserer Mitarbeiter wird sich in Kürze mit Ihnen in Verbindung setzen';
            fieldList.appendChild(infoTextDiv);
        }


    });
    observer.observe(embeddedServiceHelpButton, config);
})();