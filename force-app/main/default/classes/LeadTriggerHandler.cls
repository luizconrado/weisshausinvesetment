public class LeadTriggerHandler extends TriggerHandler {
    
    protected override void beforeInsert(final List<SObject> newObjects) {
        //LeadService.updateActualProductInterested(newObjects);
        LeadService.leadDupeMerge(newObjects);
    }
    
    protected override void afterInsert(final List<SObject> newObjects) {
        if(Label.performLeadDuplicateCheck == 'true'){
            LeadService.checkDuplicateAfterInsert(newObjects);
        }
    }
}