<<<<<<< Updated upstream
=======
# Automation
1. External system will push account details
2. External system will financial account details
3. External system will card  details

# issue
Fix unsubscribe link

# Improvement
1. based on case email attach account to case 
2. Check if chat works in normal app
3. Api call log(New Object) - Reason,user,endpoint,status,case,account/finaccount,
4. if lead record has solaris account id then convert him automaticaly
5. Case Type to identiy type of case
6. get bookings,reservations,statements
7. Do not create duplicate bookings,reservations id
8. junction object between case and bookings,reservations 
9. if record is selected in search then mark is true 
10. case record type -> general info,e&v app,banking,investment

11. Add name in bookings table - Done
12. Add global search for tables - Done
13. Capatilize BIC,IBAN and I of id - Done
14. Add Sepa data to bookings  - Done
15. format all currency with , to last two digits - Done
16. remove transation id filter and add iban filter - Done
17. remove attach statment to case button - Done
18. perform block,unblock,close card ooperations - Done

19. Convert Button on lead make Person Account Correct - Done
20. In forms get email field on top
21. min search lentth to 2 - Done 
22. Cards,Bookings,Reservation,Staement order of tabs - Done
23. Un-Block to Unblock - Done 
24. Update card status even if error occurs - Done
25. add sort funcnality to all tabels - Done
27. fix Sender IBAN in bookings table - Done
28. add show more details on bookings - Done
29. based on pdf ask required details form user and confirm with system - Done
31. booking date, before sepa transation =>See transaction, - Done
35. Ask SB   - Done
    - Crating of Jira account (B2B)
    - API access to create tickets directly from CRM
    - Boundaries between what we can do for the customer and what we MUST inform SolarisBank\

30. Format date to have 0 in month - Done
36. Implement Standing Order ,tied order, betwwen bokkings and reservations  - Requires Authrization?????
26. get Credit Transfer,Sepa Direct Debit we can get transaction data for bookings,reservation - Done
32. Support@wiss make it primary  - Done
33. move email to first in case,fix case layout - Done
34. If no action change the text to "No Actions contact SB" - Done
37. Generate email/pdf of statement - Ignore
38. Add header selection for checkbox and add sort - Done
39. making booking date clickabe and show data - Done
40. remove save as booking in transation dilog - Done
41. change header to transaction - iban -date - Done
42. change junction object names to card case, booking case,reservation case - Done

43. add picklist to case cards - Done
44. move apis to custom metadata - Done
45. action on account fetch solaris bank details - Done
    - get PII
    - get cards
    - get bank accounts
    - GET Retrieve All Identification
    - Get tax identificationx

47. talk to garthe about the chat  - Done

48. person account gender based on salutation - Done
49. use phone and email insted of other in person account sync - Done
50. get rid of product a,b,c,d - Done
51. create isTest in parent object and in child get it as formula   - Done
52. get title from person - Done
53. parse all date/time in utc  
54. get all solaris ids uder created date  - Done
55. fix more info of bookings -> error with type SEPA_CREDIT_TRANSFER - Done
56. fix Recorded At in bookings more info and sort by record at insted of booking in booking - Done
57. fix filters in all tables - Done
58. store record at in bookings object - Done

59. new case in chat not posible  - Done
60. based on email contact/account is not getting mapped - Done
61. enable multi cur and lang  - Done



# Todo
1. If no contact is present when case is created based on email create new contact/person account  - Done

2. Fix Origin in lead and account ,- Done
3. Marital Status,industry type in pesron account - Done
4. Is Test - Done
5. create formula field https://webui-ng.solarisbank.de/#/persons/ - Done
6. change method POSTIDENT IDnow Person Identification - Done
7. change status in Person Identification - Done
8. add on identification object https://api.solarisbank.de/v1/persons/89fd379fd38864790f256409dc70dc39cper/identifications/604aa1585c57b8b6d7b177f9341324adcidt/idnow_attempts?page[size]=1000 - Done
9. move currency to system fields in all page layouts - Done
10. Closure Reasons in Bank Account - Done
11. migrate from custom currency to standard curency field - Done
12. Fix Unit and move to sys info - Done
13. add resolved in status of resurvation - Done
14. change form autonumber to text statement name - Done

- Cases - Done
	- Solution / User Flow for the best of the two worlds
	- Solution / User Flow for a 1 to 1 relation (for demo purposes)

- Button / Action to load / refresh Person Data + Bank Account + Bookings, etc. - Done
- Talk to Gareth about the rebranding of the website + do the changes - Done
- Email, Case Form, Chat - Done
	 - Checks by Email (No duplicates)!
	 - Chance to create a case from the chat area - Pls solve that with SF or custom component/action



16. Stop opening of bank case on creation - Done
17. Remove status on bank case - Done
18. remove Type,TypeII,Reason for contact on bank case - Done
19. Remove jira ticket object - Done





1. Tax Identification Number = Country + Number - Done
2. Tax Identification Number crete new field - Done
3. Cards,Bookings,Reservations,timed orders,standing orders,statments - Done
4. format currency accept 0 - Done

5. End chat is not invoking from the app - Done
6. Community translation text  Done

8. change from text area to long text description in bank case - Done
9. create formula field on bank cas - Done
10. support email is deafult in case - Done



6. TODO : Previous to old in field names - Done
7. TODO : Crete jira ticket mail button on case 
8. TODO : Dynamic solaris api call based on account type - Done







15. preapre a sheet that defines dependecy on domain change

7. when case is created form community form send mail to customer 



6. Find how knowledge article can be added to email body

4. Remove Email From Bankcase recordtype origin









1. TODO:Label

2. TODO: get files module here

10. TODO:duplicate rules phone/Mobile

2. Change Bank Case to Bank Case Item - Done
 



1. get jira ticket  button on case 

/*   Bank Module   */
1. Verify All Layotus post deployment - Done
2. Create Base Email Template - Done
3. Find how to set footer and header for all emails sent from sf - Done
4. Account New Field to store customer name - Complete Name - Done
5. Date in sync buttons fix the code - Done


/*   Loging Module   */
2. TODO:Error Loging Records  - Done
3. TODO:Integeration Lgoging Records   - Done

evsmrtmnydedev
f618e589


3. Tax Identification Number= Country + Number - Done
5. Bug on statment componetn Enter Valid Quater - Done
2. Save reason for contact save to new Internal Description  field in case - Done
6. Devide by 100 currency - Done
7. Change log number to uuid - Done
46. action on bank account - Done 
    - get bank balance - Done
5. TODO : Add balance button on bank record- Done 
62. Person account type is customer- Done
6. move email next to log a call - Done

/*   Lead Module [Migrated to person account]   */
9. Account Type 
    Prospect : These are new unverified/verified leads(To be converted to person account)
    Coustomer : SB Bank customer - Done



1. Create Process Jira button on banking case record type
2. Get feedback on templates and fix them - Done
3. Fix Mobile Chat window - Done
4. Change Lead module and migrate it to create person account - Done
5. Create Files module - Done
6. Find how knowledge article can be added to email body - Done
7. When case is created form community form send mail to customer - Auto respons (conditional if else) - Done Partial
8. Preapre a sheet that defines dependecy on domain change

9. Community Support for multi language
10. re-wrtie all components to support multi language
11. Chat Label Multi Language

12. Make Knowlodge Multi Language
13. Privide translated knowlodge architecture

14. While storing amount devide by 100 and remove devide by 100 in all components - Done

15. Athinticate Emails in owa- Done
16. Email to case for new emails - Done
17. Verify DKIMS for new domain - asap 24 hrs

18. Update Mail utitlity to get email from custom setting rather then name - Done


>>>>>>> Stashed changes
# Changes
MailUtility
MailUtilityTest

<<<<<<< Updated upstream
## EmailTemplate
Weisshausinvestment Lead Thank You Email	
Weisshausinvestment Lead unsubscribe Email	
Weisshausinvestment Lead Subscribe Email	
Weisshausinvestment Person Account Verify Email	
Weisshausinvestment Person Account unsubscribe Email	
Weisshausinvestment Person Account Verify Email	

## Apex Page
AgentSupport
LiveAgent
LiveAgentChatWindow
LiveAgentPreChat

## ApexClass
LeadService
webLeadRestService
MailUtility
RandomUtil
=======
SyncAccountAndSolarisbankController

StatmentCaseView
TimedOrderCaseView
ReservationCaseView
BookingsCaseView
## Deploy

customLookUpController 

BankCaseNewOverride
customLookupResult
customLookup
selectedsObjectRecordEvent


>>>>>>> Stashed changes
Constant
SchemaUtil
AccountTriggerHandler
LeadTriggerHandler
OpportuntiyTriggerHandler
Util
TrackingEventsHandler
SyncCampaignMembersController
CaseTriggerHandler
TrackerDashboardController
--
TestDataFactory
SyncCampaignMembersControllerTest
webLeadRestServiceTest
LeadServiceTest
AccountServiceTest
TrackHistoryTest
TrackerDashboardControllerTest

OpportuntiyTriggerHandlerTest
AccountTriggerHandlerTest
LeadTriggerHandlerTest
CampaignTriggerHandlerTest
CaseTriggerHandlerTest

SchemaUtilTest
RandomUtilTest
MailUtilityTest
ConstantTest
UtilTest
## ApexTrigger
AccountTrigger
LeadTrigger
TrackingEventsTrigger
OpportuntiyTrigger
CaseTrigger

## Custom Filed
Contact.Origin__pc
Contact.ProductInterest__c
Contact.Last_Email_Sent__c
Lead.Last_Email_Sent__c
Lead.ProductInterest_Encode__c
Contact.ProductInterest_Encode__c
Campaing.Product__c



## Custom Object
History Tracker

## Custom Metadata
Trigger Settings
History Tracker Configuration

## Platform Event
Tracking Event

## Custom Settings
Email_Configuration__c

## Record Type
Campaign.Standard_Campaign
Contract.Standard_Contract
Opportuntiy.Standard_Opportunity
Case.Standard_Case

## Aura components
CommunityCustomFooter
CommunityCustomHeader
CommunityCustomTheme
ConvertLeadToPersonAccountAndContact
SendAccountEmailConfirmation
SendLeadEmailConfirmation
SyncCampaignMembers

## web components
loginUsageReport
verifyEmailAccount
unsubscribe
usageDashboard

## static resource
charjs
charjs_treemap

## Global Value Set
Unsubscription reasons
Product_Subscription_Status

# Sales process
Default

# Support Process
Default