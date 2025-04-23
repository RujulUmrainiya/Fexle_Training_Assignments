public class AccountTriggerHandler {
/*    
    public static void countActivities(List<Account> newList , Map<Id,Account> oldMap){
        
        Set<id> ids = new Set<id>();
        
        for (Account acc : newList) {
            
            ids.add(acc.Id);
            
            System.debug('ID added: ' + acc.Id);
            
        }
        
        List<AggregateResult> aggResult = [SELECT Id, count(WhatId) TaskCount FROM Task WHERE WhatId IN :Ids GROUP BY WhatId ];
        
        Map<Id,Integer> countMap = new Map<Id,Integer>();
        
        for(AggregateResult agg : aggResult){
            
            countMap.put(agg.Id, agg.TaskCount);
        }
        
        List<Task> allTasks = [SELECT Id, Status, WhatID from Task
                         
                         WHERE WhatID IN :ids];
        
        System.debug('allTasks is ' + allTasks.size());
        
        List<Task> TaskArray = new List<Task>();   
        
        Map<Id,Task> countAllTasks = new Map<Id,Task>();
        
        for (Task u : allTasks) {
            
            TaskArray.add(u.WhatID);
            
        }  
        
        System.debug(allTasks.size());    
        
        // Get the matching tasks from the Map - and count Status
        
        //Start with our Account
        
        for (Account acc : newList) {
            
            //Count all Tasks
            
            for(String key : TaskArray)
                
            {
                
                if(!countAllTasks.containsKey(key)){
                    
                    countAllTasks.put(key,0);
                    
                }
                
                Integer currentInt = countAllTasks.get(key)+1;
                
                countAllTasks.put(key,currentInt);
                
            }
            
            acc.countofAllTasks__c = countAllTasks.get(acc.ID);
            
        }
    }*/
}