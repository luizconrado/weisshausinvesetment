({
    RESEND:"Confirmation Resent",
    AWAITING:"Awaiting Confirmation",
    callServer: function (component, actionName, callback,actionParams) {
        var action = component.get('c.'+actionName); 
        if (actionParams) {
            action.setParams(actionParams);
        }
        var self = this;
        action.setCallback(this, callback);
        
        $A.enqueueAction(action);
    },
    getLocalDate: function (nodeValue) {
        $A.localizationService.UTCToWallTime(new Date(nodeValue), $A.get('$Locale.timezone'), function (offSetDateTime) {
            nodeValue = offSetDateTime;
        });
        nodeValue = $A.localizationService.formatDateTimeUTC(nodeValue, $A.get('$Locale').dateFormat + ' ' + $A.get('$Locale').timeFormat);
        return nodeValue
    }
})