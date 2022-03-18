trigger CaseTrigger on Case (before insert, before update, after update) {

    if(Trigger.isBefore && Trigger.isInsert){
        CaseServices.firstMethod(Trigger.new);
    } 
    
    if(Trigger.isUpdate){
        List<Case> casesToProcess = new List<Case>();
        for(Case c : Trigger.new){
            if(c.Status == 'Closed' && 
               Trigger.oldMap.get(c.Id).Status != 'Closed' && 
               c.AccountId != null){
               casesToProcess.add(c);
            }
        }
        ExternalSystemService.registerAttendees(JSON.serialize(casesToProcess));
    }
}