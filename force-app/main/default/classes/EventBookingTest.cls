@isTest
public class EventBookingTest {  

        @TestSetup
        static void makeData(){
            List<Account> accounts = TestDataFactory.createaccounts(40);
        }

        @isTest
        public static void refuseCaseCreationWhenAnAccountIsNotAttachedToACase(){
            List<Case> cases = TestDataFactory.createcases(40);
            // When 

            Test.startTest();

            Database.SaveResult result = Database.insert(cases, false);

            Test.stopTest();

            // Then

            System.assert(!result.isSuccess());
            System.assert(result.getErrors().size() > 0);
            System.assertEquals('You cannot create a request without attaching an account',
            result.getErrors()[0].getMessage());
        }
        
        @isTest
        public static void refuseCaseCreationWhenNoContactIsAttachedToAnAccount(){
            List<Account> accounts = [SELECT id FROM Account];

            List<Case> cases = TestDataFactory.createcaseswithaccounts(accounts , 'Phone');
            
            // When 

            Test.startTest();

            Database.SaveResult result = Database.insert(cases, false);

            Test.stopTest();

            // Then

            System.assert(!result.isSuccess());
            System.assert(result.getErrors().size() > 0);
            System.assertEquals('You cannot create a request for accounts without contacts',
            result.getErrors()[0].getMessage());
        }
        
        @isTest
        public static void bookEventFromPhone(){
            List<Account> accounts = [SELECT id FROM Account];

            List<Contact> contacts = TestDataFactory.createcontacts(accounts);

            List<Case> cases = TestDataFactory.createcases(accounts);
            
        
            // When 

            Test.startTest();

            Database.SaveResult result = Database.insert(contacts, false);
            Database.SaveResult result = Database.insert(cases, false);

            Test.stopTest();

            // Then

            System.assert(result.isSuccess());


        @isTest
        public static void refuseEventBookingWhenNumberOfAttendeesIsMoreThanThreeForPhoneCases(){
            // Given
            List<Account> accounts = [SELECT id FROM Account];
            
            List<Contact> cts = TestDataFactory.createcontactsforaccount(accounts[0],5);
            
            List<Case> cases = TestDataFactory.createcaseswithaccounts(accounts,'Phone');

            // When 

            Test.startTest();

            Database.SaveResult result = Database.insert(cts, false);
            Database.SaveResult result = Database.insert(cases, false);

            Test.stopTest();

            // Then
            System.assert(!result.isSuccess());
            System.assert(result.getErrors().size() > 0);
            System.assertEquals('Phone request are only allowed to have three attendee',
            result.getErrors()[0].getMessage());

        }
        
        @isTest
        public static void bookEventFromTheWeb(){
            List<Account> accounts = [SELECT id FROM Account];
            
            List<Contact> cts = TestDataFactory.createcontactsforaccount(accounts[0],1);
            
            List<Case> cases = TestDataFactory.createcaseswithaccounts(accounts,'Web');
            // When 

            Test.startTest();
            Database.SaveResult result = Database.insert(cts, false);
            Database.SaveResult result = Database.insert(cases, false);

            Test.stopTest();

            // Then

            System.assert(result.isSuccess());

                
        } 
            
        @isTest
        public static void refuseEventBookingWhenNumberOfAttendeesIsMoreThanOneForWebCases(){
            List<Account> accounts = [SELECT id FROM Account];
            
            List<Contact> cts = TestDataFactory.createcontactsforaccount(accounts[0],5);
            
            List<Case> cases = TestDataFactory.createcaseswithaccounts(accounts,'Web');

            // When 

            Test.startTest();

            Database.SaveResult result = Database.insert(cts, false);
            Database.SaveResult result = Database.insert(request, false);

            Test.stopTest();

            // Then

            System.assert(!result.isSuccess());
            System.assert(result.getErrors().size() > 0);
            System.assertEquals('Web request are only allowed to have one attendee',
            result.getErrors()[0].getMessage());

                
        } 
    
    
}
