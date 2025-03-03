@RestResource(urlMapping='/AccountApi/*')
global with sharing class InboundServiceAssignment {

    @HttpGet
    global static Account getRecord(){
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String accountId = req.RequestURI.substring(req.RequestURI.lastIndexOf('/')+1);
        Account result = [SELECT Id, Name FROM Account WHERE Id = :accountId];
        return result;
    }    
}