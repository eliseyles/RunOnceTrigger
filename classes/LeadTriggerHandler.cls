public with sharing class LeadTriggerHandler {

    public static Boolean IS_RUN_ONCE = false;
    LeadTriggerHandlerHelper helper = new LeadTriggerHandlerHelper();

    public void beforeInsert(List<Lead> newLeads) {
        helper.checkRequiredFields(newLeads);
    }

    public void afterInsert(List<Lead> newLeads) {
        helper.createTaskToCallNewLead(newLeads);
    }

    public void beforeUpdate(Map<Id, Lead> oldMap, Map<Id, Lead> newMap) {
        helper.restrictNameUpdating(oldMap, newMap);
    }

    public void afterUpdate(Map<Id, Lead> oldMap, Map<Id, Lead> newMap) {
        helper.updateDescriptions(oldMap, newMap);
    }

    public void beforeDelete(List<Lead> oldLeads, Map<Id, Lead> oldLeadsMap) {
        helper.checkLeadStatus(oldLeads, oldLeadsMap);
    }

    public void afterDelete(List<Lead> oldLeads, Map<Id, Lead> oldLeadsMap) {
        helper.newTaskDueToDeletingLeads(oldLeads, oldLeadsMap);
    }

    public void afterUndelete(List<Lead> newLeads) {
        helper.createTaskToCallNewLead(newLeads);
    }
}