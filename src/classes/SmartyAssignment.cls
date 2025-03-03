public class SmartyAssignment {
    
    @future(callout=true)
    public static void callWebApi(Set<Id> ids) {
        
        List<Contact> updatedContactList = new List<Contact>();
        List<Contact> conList = [SELECT Id, MailingCity, MailingState, MailingPostalCode, Is_Verified__c FROM Contact WHERE Id IN :ids];
        for(Contact con : conList){
            
            String API_URL = string.format('https://us-zipcode.api.smarty.com/lookup?key=224586036507204595&city={0}&state={1}&zipcode={2}',new string[]{con.MailingCity,con.MailingState,con.MailingPostalCode});
            String BEARER_TOKEN = 'VHYFNsxmQzzKPeZk8G9M';
            
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(API_URL);
            request.setMethod('GET');
            
            // Set headers
            request.setHeader('Authorization', 'Bearer ' + BEARER_TOKEN);
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Referer', 'fexle16-dev-ed.develop.lightning.force.com');  
            
            System.debug('Request = '+request);
            HttpResponse response;
            try {
                response = http.send(request);
                
                if (response.getStatusCode() == 200) {
                    System.debug('Inside 200 Ok');
                    String responseBody = response.getBody();
                    boolean status = responseBody.contains(con.MailingPostalCode);
                    if(status){
                        con.Is_Verified__c = true;
                        System.debug('Verification = True');
                    }
                    else{
                        con.Is_Verified__c = false;
                        System.debug('Verification = False');
                    }
                    updatedContactList.add(con);
                    update updatedContactList;
                    
                } else {
                    System.debug('Error: ' + response.getStatusCode() + ' - ' + response.getBody());
                }
            } catch (Exception e) {
                System.debug('Exception: ' + e.getMessage());
            }
        }
    }
}



/*
Anonymous Code 

Contact c1 = new Contact(LastName='Smarty8',MailingCity='mountain+view',MailingState='CA',MailingPostalCode='94035');
Contact c2 = new Contact(LastName='Smarty9',MailingCity='mountain+view',MailingState='USA',MailingPostalCode='94035');

List<Contact> conList = new List<Contact>();
conList.add(c1);
conList.add(c2);

SmartyAssignment.updateSmartyAppAddress(conList);
*/