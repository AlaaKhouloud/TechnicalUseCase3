public  class ExternalSystemService {


    @future(callout=true)
    public static void registerAttendees(String casesToProcess){
            List<Case> closedCases = (List<Case>) JSON.deserialize(casesToProcess,List<Case>.class);
            List<Task> tasksToInsert = new List<Task>();
            List<MyWrapper> bodycontent = new List<MyWrapper>();
            Set<Id> accountIds = new Set<Id>();

            for(Case c : closedCases){
                accountIds.add(c.AccountId);
            }

            for(Account a : [SELECT id, (SELECT id,name, email FROM Contacts )
                             FROM Account 
                             WHERE id In :accountIds]){
                for(Contact ctc : a.Contacts){
                    MyWrapper content = new MyWrapper(ctc.name,ctc.email);
                    bodycontent.add(content);
                    tasksToInsert.add(notifyAttendeeByEmail(ctc));   
                }
            }
            if(bodycontent.size()>0){
                    Web_Service_Links__mdt linkData = Web_Service_Links__mdt.getInstance('Link1');
                    String body = JSON.serialize(bodycontent);
                    Http http = new Http();
                    HttpRequest request = new HttpRequest();
                    request.setEndpoint(linkData.Link__c);
                    request.setMethod('POST');
                    request.setHeader('Content-Type', 'application/json;charset=UTF-8');
                    // Set the body as a JSON object
                    request.setBody(body);
                    HttpResponse response = http.send(request);

                    if(response.getStatusCode() != 201) {
                        System.debug('The status code returned was not expected: ' +
                            response.getStatusCode() + ' ' + response.getStatus());
                    }else{
                        try{
                            if(tasksToInsert.size()>0)
                                insert(tasksToInsert);
                        }catch(DMLException ex){
                            System.debug(ex.getMessage());
                        }  
                    }
            }
    } 

    public static Task notifyAttendeeByEmail(Contact ctc){
        Task tk = new Task();
        tk.Subject = 'Send Email To' + ctc.name;
        tk.Status = 'Open';
        tk.Priority = 'Normal';
        tk.WhatId = ctc.Id;
        return tk;
    } 


    public class MyWrapper{
        public String name;
        public String email;
        public MyWrapper(String name, String email){
            this.name = name;
            this.email = email;
        }
    }

}
