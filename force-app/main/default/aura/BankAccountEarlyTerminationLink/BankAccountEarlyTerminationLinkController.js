({
     onInit: function(component, event, helper) {
        let accountRecord=component.get('v.accountRecord');
        let type=component.get('v.type');    
        
        
        let communityur=$A.get("$Label.c.siteUrl")+'/s/';
        
         communityur+='early-termination-form';
        let resultsToast = $A.get("e.force:showToast");
        let dismissActionPanel = $A.get("e.force:closeQuickAction");
        if(!accountRecord.Person_Account__r.Auth0_ID__c){
            
            resultsToast.setParams({
                "title": "Auth0 Id missing",
                "message": "Please update user auth0 id",
                "varient":"error"
            });
            resultsToast.fire();
            dismissActionPanel.fire();
            return;
        }
         else if(!accountRecord.Person_Account__r.Solarisbank_Id__c){
             resultsToast.setParams({
                 "title": "Solarisbank Id missing",
                 "message": "Please update user Solarisbank id",
                 "varient":"error"
             });
             resultsToast.fire();
             dismissActionPanel.fire();
             return;
         }
         let authId=accountRecord.Person_Account__r.Auth0_ID__c.replace('auth0|','');
         component.set('v.url',communityur+`?language=de&ci=${accountRecord.Person_Account__r.Solarisbank_Id__c}&ai=${authId}&si=${accountRecord.Id}`);
    },
    copyText : function(component, event, helper) {
       
        
        let accountRecord=component.get('v.accountRecord');
    	let type=component.get('v.type');    

	
        let communityurl=$A.get("$Label.c.siteUrl")+'/s/';
        
           communityurl+='early-termination-form';
        let resultsToast = $A.get("e.force:showToast");
        let dismissActionPanel = $A.get("e.force:closeQuickAction");
        if(!accountRecord.Person_Account__r.Auth0_ID__c){
          
            resultsToast.setParams({
                "title": "Auth0 Id missing",
                "message": "Please update user auth0 id",
                "varient":"error"
            });
            resultsToast.fire();
            dismissActionPanel.fire();
            return;
        }
        else if(!accountRecord.Person_Account__r.Solarisbank_Id__c){
             resultsToast.setParams({
                 "title": "Solarisbank Id missing",
                 "message": "Please update user Solarisbank id",
                 "varient":"error"
            });
            resultsToast.fire();
            dismissActionPanel.fire();
            return;
        }
        let authId=accountRecord.Person_Account__r.Auth0_ID__c.replace('auth0|','');
        let copyText =`${communityurl}?language=de&ci=${accountRecord.Person_Account__r.Solarisbank_Id__c}&ai=${authId}&si=${accountRecord.Id}`;
        const el = document.createElement('textarea');
        el.value = copyText;
        document.body.appendChild(el);
        el.select();
        document.execCommand('copy');
        document.body.removeChild(el);
        resultsToast.setParams({
            "title": "Link Copied!",
            "message": "Form Link coped to clipboard successfully",
            "varient":"success"
        });
        resultsToast.fire();
        dismissActionPanel.fire();
        
    }
})