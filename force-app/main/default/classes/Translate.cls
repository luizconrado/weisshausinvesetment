global inherited sharing  class Translate {
    
    global List<TranslationWrapper> translatedValues{set;get;}
    
    global Translate(){
        Map<String, String> reqParams = ApexPages.currentPage().getParameters(); 
        if(reqParams.get('type')=='PICKLIST'){
         	getTranlsatedPicklistValues(reqParams.get('objectName'),reqParams.get('fieldName'));   
        }
        
        
        
    }
    
    
    
    private void getTranlsatedPicklistValues(String objectName,String fieldName){
        Map<String,PicklistEntry[]> vaues= SchemaUtil.getObjectPicklistFileds(SchemaUtil.getSobjectType(objectName));
        List<TranslationWrapper> values=new List<TranslationWrapper>();
        for(PicklistEntry entr:vaues.get(fieldName)){
            if(entr.isActive()){
                values.add(new TranslationWrapper('de',entr.getValue(),entr.getLabel()));
            }
        }
        translatedValues=values;
        
    }
    
    global static String getTranslatedPickListValues( String objectName,String fieldName){
        Pagereference pRef = Page.Translate;
        pRef.getParameters().put('objectName', objectName);
        pRef.getParameters().put('fieldName', fieldName);
        pRef.getParameters().put('type', 'PICKLIST');
        String labelValue = '';
        if(!Test.isRunningTest()) labelValue=pRef.getContent().toString();
        labelValue=labelValue.removeEnd(',]') + ']';
        if(Test.isRunningTest()) labelValue='[]';
        return labelValue;
    }
    
    global class TranslationWrapper{
        global String label{set;get;}
        global String value{set;get;}
        global String language{set;get;}
         global TranslationWrapper(String language,String value,String label ){
            this.label=label;
            this.value=value;
            this.language=language;
           
        }
    }
    
}