@RestResource(UrlMapping='/generate/lead/*')
global class webLeadRestService {

    @HttpPost
    global static void doPost() {
        RestResponse res = RestContext.response;

        RestRequest req = RestContext.request;

        Map<String, String> headersMap = req.headers;

        String userAgent =(headersMap.get('User-Agent')!=null) ? headersMap.get('User-Agent') : '';
        String productInterest = req.params.get('fields[productInterested][value]');
        String email = req.params.get('fields[email][value]');
        String company = req.params.get('fields[websiteSource][value]');

        Lead lead = new Lead();

        lead.Email = email;
        lead.ProductInterest__c = productInterest;

        lead.State = 'New';
        lead.LastName = '[Not Provided]';
        lead.LeadSource = 'Website';
        lead.RecordTypeId = Util.getRecordTypeId('WebLeads', 'Lead');

        lead.Website = (String.isNotEmpty(userAgent) && userAgent.contains(';')) ? userAgent.split(';').get(1):'';

        if(lead.Website!=null && String.isNotEmpty(lead.Website) && lead.Website.contains('www.')) lead.Lead_Origin__c=lead.Website.substringBetween('://www.', '.');
        else if(lead.Website!=null && String.isNotEmpty(lead.Website) ) lead.Lead_Origin__c=lead.Website.substringBetween('://', '.');

		lead=LeadService.leadDupeMerge(lead);        
        upsert lead;

        Database.DMLOptions dmlOptions = new Database.DMLOptions();
        dmlOptions.assignmentRuleHeader.useDefaultRule = true;
        Database.update(lead, dmlOptions);

        res.statusCode = 200;
    }
    
}