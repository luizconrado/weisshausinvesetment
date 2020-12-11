({
    callApex:function(component,actionName,callback,params){
        let action = component.get("c."+actionName);
        if(params)
            action.setParams(params);
        action.setCallback(this,callback);
        $A.enqueueAction(action);
    },
    showToast:function(title,message,type){
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type":type
        });
        toastEvent.fire();
    },
    formatDateTime:function(value){
        if(!value)return '';
        let locale = $A.get('$Locale');
        if(value.includes('T')){
            $A.localizationService.UTCToWallTime(new Date(value), $A.get('$Locale.timezone'), function (offSetDateTime) {
                value = offSetDateTime;
            });
            return $A.localizationService.formatDateTimeUTC(
                value,(locale.dateFormat,' ', locale.timeFormat));
        }
        return $A.localizationService.formatDate(value,locale.dateFormat);
    },
   formatCurrency:function(value){
        if(value === 0) return '0 '+ $A.get('$Locale.currency');
        if(!value ) return '';
        let locale = $A.get('$Locale');
        return value.toLocaleString(locale.userLocaleCountry) +' '+ $A.get('$Locale.currency');
    },
})