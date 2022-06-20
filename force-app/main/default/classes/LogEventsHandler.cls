/***************
* @group Handler Class
* @description Log Events Trigger router
*/
public class LogEventsHandler  extends TriggerHandler {
    protected override void afterInsert() {
        List<Log_Event__e> events=(List<Log_Event__e>) Trigger.new;
        LogService.captureLogs(events);
        
    } 
    
}