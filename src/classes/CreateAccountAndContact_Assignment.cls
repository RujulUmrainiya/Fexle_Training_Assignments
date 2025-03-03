@RestResource(urlMapping='/AccountAndContact/*')
global with sharing class CreateAccountAndContact_Assignment{
    
    @HttpPost
    global static String createAccountAndContact(String accountName, String firstName, String lastName, String email){
        
        // check if we have all required fields and if required field are missing then show error 
        if(String.isBlank(accountName) || String.isBlank(firstName) || String.isBlank(lastName) || String.isBlank(email)){
            
            return 'Error : Required Fields are Missing!!';
        }
        
        try{
            
            // check if Account already exists with the provided name
            List<Account> existingAccount = [SELECT Id, Name FROM Account WHERE Name = :accountName LIMIT 1];
            // if Account already exists
            if(!existingAccount.isEmpty()){
                System.debug('existingAccount is not nulls');
                System.debug('existingAccount: '+existingAccount);
                System.debug('existing Account Id: '+existingAccount[0]);
                
                // check if Contact's email = Account's email
                List<Contact> existingContact = [SELECT Id, email FROM Contact WHERE AccountId = :existingAccount[0].Id AND Email = :email LIMIT 1];
                System.debug('existingContact: '+existingContact);
                if(!existingContact.isEmpty()){
                    System.debug('List is not null');
                    
                    return 'Error : Contact already exists with same email in Account\'s Email!! - AccountId = '+existingAccount[0].Id;
                }
                else{
                    System.debug('List is null');
                    // if contact don't exists then create a new contact
                    Contact newContact = new Contact(
                        FirstName=firstName, 
                        LastName=lastName, 
                        Email=email, 
                        AccountId=existingAccount[0].Id
                    );
                    
                    insert newContact;
                    System.debug('Contact inserted');
                    
                    return 'Success: Contact Created!! - AccountId = '+ existingAccount[0].Id +' ContactId = '+ newContact.Id;
                }
            }
            else{
                System.debug('existingAccount is nulls');
                
                // Create a new Account & new Contact
                Account newAccount = new Account(Name=accountName);
                insert newAccount;
                
                Contact newContact = new Contact(
                    FirstName=firstName, 
                    LastName=lastName, 
                    Email=email, 
                    AccountId=newAccount.Id
                );
                
                insert newContact; 
                
                return 'Both Account & Contact are created!! - AccountId = '+newAccount.Id+' ContactId = '+newContact;
            }
        }catch(Exception e){
            
            return 'Exceptional Error: '+ e.getMessage();
        }
    }
}