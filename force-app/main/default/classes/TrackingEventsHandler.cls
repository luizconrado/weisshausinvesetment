public class TrackingEventsHandler  extends TriggerHandler {
    protected override void afterInsert(final List<SObject> newObjects) {
        List<Tracking_Events__e> events=(List<Tracking_Events__e>) newObjects;
        TrackHistory.captureChanges(events);
    }
}