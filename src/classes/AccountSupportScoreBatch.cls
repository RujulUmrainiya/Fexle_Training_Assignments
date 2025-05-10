global class AccountSupportScoreBatch implements Database.Batchable<sObject> , Database.Stateful{

    public Integer Score = 0;
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        
        String query = 'SELECT Id , Priority, Status FROM Case';
       
        return Database.getQueryLocator(query);
		
    }
    
    global void execute(Database.BatchableContext BC , List<Case> caseList){
        
        List<Account> accListToBeUpdated = new List<Account>();
        for(Case cs : caseList){
            
            Account acc = new Account();
            acc.Id = cs.AccountId;
            if(cs.Priority == 'High'){
                
                Score = Score + 3;
                acc.Support_Score__c = Score;
                accListToBeUpdated.add(acc);
            }
            
            else if(cs.Priority == 'Medium'){
                
                Score = Score + 2;
                acc.Support_Score__c = Score;
                accListToBeUpdated.add(acc);
            }
            
            else{
                
                Score = Score + 1;
                acc.Support_Score__c = Score;
                accListToBeUpdated.add(acc);
            }
        }
        
        update accListToBeUpdated;
    }
    
    global void Finish(Database.BatchableContext BC){
        
        
    }
}