public with sharing class CaseServices {
    
    
    public static void firstmethod(List<Case> newCases) {
        Set<Id> accountIds = new Set<Id>();
        Map<Id,Integer> mappedResults = new Map<Id,Integer>();

        for(Case c : newCases){
            if( c.AccountId != null) 
                accountIds.add(c.AccountId);
            else 
                c.addError('You cannot create a request without attaching an account');
        }

        if(!accountIds.isempty()){

            for(AggregateResult currentResult:  [SELECT AccountId, COUNT(Id) ContactCount 
                                                FROM Contact 
                                                WHERE AccountId in :accountIds
                                                GROUP BY AccountId]){
                ID customer = (ID) currentResult.get('AccountId');
                Integer count = (Integer) currentResult.get('ContactCount');
                mappedResults.put(customer,count);
            }

            for(Case c : newCases){
                Integer s = mappedResults.get(c.accountId);
                if(s==0){
                    c.addError('You cannot create a request for accounts without contacts');
                }else {
                    switch on c.Origin {
                        when 'Web' {
                            if(s >= 2 ){
                                c.addError('Web request are only allowed to have one attendee');
                            }
                        }
                        when 'Phone'{
                            if(s >= 4 ){
                                c.addError('Phone request are only allowed to have three attendee');
                            }
                        }
                    }    
                                
                }
            }
        }
    }


}
