public virtual class TriggerHandler {

    public List<SObject> triggerNew;
    public Map<Id, SObject> triggerNewMap;
    public Map<Id, SObject> triggerOldMap;
    public System.TriggerOperation operation;

    public TriggerHandler() {}

    public virtual void init(final System.TriggerOperation operation, final List<SObject> triggerNew, final Map<Id, SObject> triggerNewMap,
             final Map<Id, SObject> triggerOldMap){

        this.triggerNew = triggerNew;
        this.triggerNewMap = triggerNewMap;
        this.triggerOldMap = triggerOldMap;
        this.operation = operation;
    }

    public virtual void execute() {

        switch on this.operation {

            when BEFORE_INSERT {
                beforeInsert(this.triggerNew);
            }

            when AFTER_INSERT {
                afterInsert(this.triggerNew);
            }

            when BEFORE_UPDATE {
                beforeUpdate(this.triggerNewMap, this.triggerOldMap);
            }

            when AFTER_UPDATE {
                afterUpdate(this.triggerNewMap, this.triggerOldMap);
            }
            
            when BEFORE_DELETE {
                beforeDelete(this.triggerOldMap);
            }
        }
    }

    protected virtual void beforeInsert(final List<SObject> newObjects) {}
    protected virtual void afterInsert(final List<SObject> newObjects) {}
    protected virtual void beforeUpdate(final Map<Id, SObject> newObjects, final Map<Id, SObject> oldObjects) {}
    protected virtual void afterUpdate(final Map<Id, SObject> newObjects, final Map<Id, SObject> oldObjects) {}
    protected virtual void beforeDelete(final Map<Id, SObject> oldObjects) {}
}