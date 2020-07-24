public class OpportuntiyTriggerHandler  extends TriggerHandler {
  
    protected override void afterUpdate(final Map<Id, SObject> newObjects, final Map<Id, SObject> oldObjects) {
        //track record changes
        if(!System.Label.Track_History_Exclusion.contains(Userinfo.getUserName()))
            TrackHistory.publishChanges('Opportunity', Trigger.new,oldObjects);
    }

}