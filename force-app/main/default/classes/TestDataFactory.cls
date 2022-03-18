public with sharing class TestDataFactory {
    
    
    public static List<Account> createaccounts(integer numberOfrecords){
        List<Account> accounts = new List<Account>();
        for(Integer i = 0 ; i<numberOfrecords ; i++){
            Account c = new Account(Name = 'Salesforce');
            accounts.add(c);
        }
        return accounts;
    }
    
    public static List<Case> createcases(integer numberOfrecords){
        List<Case> cases = new List<Case>();
        for(Integer i = 0 ; i<numberOfrecords ; i++){
            Case c = new Case(Origin = 'Phone',Subject = 'Event Booking', Description = 'Book Spots');
            cases.add(c);
        }
        return cases;
    }

    public static List<Case> createcaseswithaccounts(List<Account> accounts,String origin){
        List<Case> cases = new List<Case>();
        for(Integer i = 0 ; i<accounts.size() ; i++){
            Case c = new Case(Origin = origin,Subject = 'Event Booking', Description = 'Book Spots', AccountId=accounts[i].iD);
            cases.add(c);
        }
        return cases;
    }

    public static List<Contact> createcontacts(List<Account> accounts){
        List<Contact> contacts = new List<Contact>();
        for(Integer i = 0 ; i<accounts.size() ; i++){
            Contact c = new Contact(LastName = 'Contact '+i, AccountId=accounts[i].iD);
            contacts.add(c);
        }
        return contacts;
    }

    public static List<Contact> createcontactsforaccount(account acc, Integer numberOfRecords){
        List<Contact> contacts = new List<Contact>();
        for(Integer i = 0 ; i<numberOfRecords ; i++){
            Contact c = new Contact(LastName = 'Contact '+i, AccountId=acc.iD);
            contacts.add(c);
        }
        return contacts;
    }
}
