public class TrackingEventsHandler  extends TriggerHandler {
    protected override void afterInsert() {
        List<Tracking_Events__e> events=(List<Tracking_Events__e>) Trigger.new;
        TrackHistory.captureChanges(events);
    }
}