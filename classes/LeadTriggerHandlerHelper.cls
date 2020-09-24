public with sharing class LeadTriggerHandlerHelper {

    public void checkRequiredFields(List<Lead> newLeads) {
        for (Lead lead : newLeads) {
            if (lead.Email == null) {
                lead.addError('Enter email');
            }
            if (lead.Phone == null) {
                lead.addError('Enter phone');
            }
        }
    }

    public void createTaskToCallNewLead(List<Lead> newLeads) {
        List <Task> tasks = new List<Task>();
        for (Lead lead : newLeads) {
            Task task = new Task();
            task.Description = 'Please call' + lead.FirstName + ' ' + lead.LastName;
            task.Subject = 'NEW LEAD: ' + lead.FirstName + ' ' + lead.LastName;
            tasks.add(task);
        }
        insert(tasks);
    }

    public void restrictNameUpdating(Map<Id, Lead> oldMap, Map<Id, Lead> newMap) {
        for (Id id : oldMap.keySet()) {
            if (!(oldMap.get(id).FirstName.equals(newMap.get(id).FirstName))) {
                newMap.get(id).addError('You cant update FirstName');
            }
            if (!(oldMap.get(id).LastName.equals(newMap.get(id).LastName))) {
                newMap.get(id).addError('You cant update LastName');
            }

        }
    }

    public void updateDescriptions(Map<Id, Lead> oldMap, Map<Id, Lead> newMap) {
        Integer i = 1;
        List<Lead> leads = [SELECT FirstName FROM Lead WHERE Id IN :newMap.keySet()];
        for (Lead lead : leads) {
            lead.Description = 'It was updated ' + i + ' times';
            i++;
        }
        update leads;
    }

    public void checkLeadStatus(List<Lead> oldLeads, Map<Id, Lead> oldLeadsMap) {
        for (Lead lead : oldLeads) {
            if (!(lead.Status.equals('Closed - Not Converted') || lead.Status.equals('Closed - Converted'))) {
                lead.addError('You have not process the negotiations with that lead to complete stage');
            }
        }
    }

    public void newTaskDueToDeletingLeads(List<Lead> oldLeads, Map<Id, Lead> oldLeadsMap) {
        List <Task> tasks = new List<Task>();
        for (Lead lead : oldLeads) {
            Task task = new Task();
            task.Description = 'Please make a note about this lead: ' + lead.FirstName + ' '
                    + lead.LastName + ' in report with your manager ' ;
            task.Subject = 'LEAD ' + lead.FirstName + '' + lead.LastName + 'WAS REMOVED';
            tasks.add(task);
        }
        insert(tasks);
    }


}