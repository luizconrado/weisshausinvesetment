public class LogEventsHandler  extends TriggerHandler {
    protected override void afterInsert(final List<SObject> newObjects) {
        List<Log_Event__e> events=(List<Log_Event__e>) newObjects;
        LogService.captureLogs(events);
        
    }
    
}