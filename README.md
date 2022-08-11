# Org
https://ev-smartmoney.my.salesforce.com/

# Community 

## Banking
    https://support.ev-smartmoney.com/

## Investment
    https://invest.ev-smartmoney.com/


# Configurations

## Custom Metadata

### History Tracker Configuration
configure fields that are to be tracked of objects 

### Solarisbank Api
configure  apis and keys used in org

### File Type Options
configure default file types available by record type for each object that is available when uploading file using custom button attach file

### Trigger Settings
Activate or deactivate trigger

### Constant
Configure constant values that are used in admin settings

### Slack Alert Configurations
Configure slack alert for which object it should sent

## Custom Settings

### Scramble Configuration	
Configure object and fields related to account for which all data in it will be scrambled






# Git deployment

1. Create a new PR with related components to deploy
2. On Create of PR code package check will occurs with production org
3. on successfully merge it will be deployed to production org

## Specify Test class to run as comma separated values in pr

    Apex::[ConstantTest]::Apex

## Specify all as value to run all local tests

    Apex::[all]::Apex



### Note
add git secrete variable

SFDX_PRODUCTION_URL

and value of it copy from running command

`sfdx force:org:display --targetusername evprod --verbose`

and copy Sfdx Auth Url