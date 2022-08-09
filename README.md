# Org
https://ev-smartmoney.my.salesforce.com/
# Community 
## FAQ
https://support.ev-smartmoney.com/

# Configurations

## Custom Metadata

### History Tracker Configuration
configure fields that are to be tracked of objects

### Solarisbank Api
configure solarisbank apis and credentials

### File Type Options
configure default file types available by record type for each object that is available when uploading file using custom button attach file

### Trigger Settings
Activate or deactivate trigger



# Apex
SolarisbankCRPRequestWrapper

# Object
Change_Request_Log__c


# retrieve
sfdx force:source:retrieve -m CustomObject:Slack_Alert_Configuration__mdt

# deploy to prod
sfdx force:source:deploy -m ApexClass:RestServiceAccountSMICreate --json --loglevel fatal  --testlevel RunSpecifiedTests --runtests 'RestServiceAccountSMICreateTest' -u evprod1

# import export data
sfdx force:data:tree:export -u evqa01 --query "SELECT Id, Name, Field__c, IsReference__c, Object__c FROM Scramble_Configuration__c" --prefix scramble-config --outputdir data --plan

sfdx force:data:tree:import -u evprod1 --plan data/scramble-config-Scramble_Configuration__c-plan.json