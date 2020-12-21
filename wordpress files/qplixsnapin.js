var initESW = function (gslbBaseURL) {
    embedded_svc.settings.displayHelpButton = true; //Or false
    embedded_svc.settings.language = "de"; //For example, enter 'en' or 'en-US'

    embedded_svc.settings.defaultMinimizedText = "Nehmen Sie Kontakt auf "; //(Defaults to Chat with an Expert)
    embedded_svc.settings.disabledMinimizedText = "Nehmen Sie Kontakt auf "; //(Defaults to Agent Offline)

    embedded_svc.settings.loadingText = "Nehmen Sie Kontakt auf"; //(Defaults to Loading)

    embedded_svc.settings.offlineSupportMinimizedText = "Nehmen Sie Kontakt auf"; //(Defaults to Contact Us)

    let Origin = window.location.origin || window.location.href || "unknown";
    embedded_svc.settings.extraPrechatFormDetails = [
        {
            label: "Vorname",
            transcriptFields: ["Last_Name__c"],
            displayToAgent: true,
        },
        {
            label: "Nachname",
            transcriptFields: ["First_Name__c"],
            displayToAgent: true,
        },
        {
            label: "E-Mail",
            transcriptFields: ["Email__c"],
            displayToAgent: true,
        },
        {
            label: "Chat Origin",
            transcriptFields: ["Chat_Origin__c"],
            value: Origin,
            displayToAgent: true,
        },
    ];

    embedded_svc.settings.extraPrechatInfo = [
        {
            entityFieldMaps: [
                {
                    doCreate: false,
                    doFind: false,
                    fieldName: "LastName",
                    isExactMatch: false,
                    label: "Nachname",
                },
                {
                    doCreate: false,
                    doFind: false,
                    fieldName: "FirstName",
                    isExactMatch: false,
                    label: "Vorname",
                },
                {
                    doCreate: false,
                    doFind: true,
                    fieldName: "Email",
                    isExactMatch: true,
                    label: "E-Mail",
                },
            ],
            entityName: "Contact",
        },
    ];

    //embedded_svc.settings.storageDomain = 'yourdomain.com'; //(Sets the domain for your deployment so that visitors can
    navigate subdomains during a chat session)

    // Settings for Chat
    //embedded_svc.settings.directToButtonRouting = function(prechatFormData) {
    // Dynamically changes the button ID based on what the visitor enters in the pre-chat form.
    // Returns a valid button ID.
    //};
    //embedded_svc.settings.prepopulatedPrechatFields = {}; //Sets the auto-population of pre-chat form fields
    //embedded_svc.settings.fallbackRouting = []; //An array of button IDs, user IDs, or userId_buttonId

    embedded_svc.settings.enabledFeatures = ["LiveAgent"];
    embedded_svc.settings.entryFeature = "LiveAgent";

    embedded_svc.init(
        "https://weisshausinvestment--dev.my.salesforce.com",
        "https://dev-weisshausinvestment.cs101.force.com/support",
        gslbBaseURL,
        "00D1X0000008dzV",
        "Web_Support",
        {
            baseLiveAgentContentURL:
                "https://c.la1-c1cs-cdg.salesforceliveagent.com/content",
            deploymentId: "5725I000000gPtx",
            buttonId: "5735I000000gQ4O",
            baseLiveAgentURL: "https://d.la1-c1cs-cdg.salesforceliveagent.com/chat",
            eswLiveAgentDevName: "Web_Support",
            isOfflineSupportEnabled: true,
        }
    );
};

if (!window.embedded_svc) {
    var s = document.createElement("script");
    s.setAttribute(
        "src",
        "https://weisshausinvestment--dev.my.salesforce.com/embeddedservice/5.0/esw.min.js"
    );
    s.onload = function () {
        initESW(null);
    };
    document.body.appendChild(s);
} else {
    initESW("https://service.force.com");
}