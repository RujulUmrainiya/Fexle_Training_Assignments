public class TrainingSessionManager {
    
    public enum TrainingSessionType{
        WEBINAR, //0
        WORKSHOP, //1
		SEMINAR //2
    }
    
    List<Training_Session__c> sessionList = new List<Training_Session__c>();
	Set<Attendee__c> AttendeeSet = new Set<Attendee__c>();
    public void createRecord(List<Training_Session__c> multipleObj){ 
        //Integer a = 20/0;    // to understand Exception (break the code)
        try{
            //Integer a = 20/0;
            
            //Scenario: Training Session Manager : Task-1
            for(Training_Session__c rec : multipleObj){
                sessionList.add(rec);
            }
        }
        catch (Exception e){
            System.debug('Error : ' + e.getMessage());
            //throw e;
        }        
        finally{
            System.debug('Execution Completed');
        }
    }
    
    public List<Training_Session__c> readRecordTrainingSession(){
        //Scenario: Training Session Manager : Task-1
        return sessionList;
    }
        
    public void updateRecord(Training_Session__c objToUpdate){
    	//Scenario: Training Session Manager : Task-1       
    	for(Training_Session__c rec : sessionList){
    		if(rec.Id == objToUpdate.Id){
        		rec.Name = objToUpdate.Name;
			}
        }
    }
	
    public void deleteSingleRecord(String id){
        //Scenario: Training Session Manager : Task-1
        Integer count = 0;
         for(Training_Session__c rec : sessionList){
             if(rec.Id == id){
                 break;
             }
             count++;
         }
        sessionList.remove(count);
    }
    
    
    // Training Session Manager (TASK-2) -----> SET
    // Scenario: Custom Labels and Enhanced Queries (TASK-1)
    public void addAttendees(Attendee__c addAttendee, TrainingSessionType sessionType){
        //Use enum to add Attendee into Webinar
        //WEBINAR,  //0
        //WORKSHOP, //1
        //SEMINAR   //2
        
        
        if(sessionType == TrainingSessionManager.TrainingSessionType.WEBINAR){
        	AttendeeSet.add(addAttendee);
        	System.debug(System.Label.Webinar_Greetings);
        }
        else if(sessionType == TrainingSessionManager.TrainingSessionType.WORKSHOP){
        	AttendeeSet.add(addAttendee);
        	System.debug(System.Label.Workshop_Greetings);
        }
        else if(sessionType == TrainingSessionManager.TrainingSessionType.SEMINAR){
        	AttendeeSet.add(addAttendee);
        	System.debug(System.Label.Seminar_Greetings);
        }
        else{
            System.debug('No data saved');
        }
    }
    
     public Set<Attendee__c> readRecordAttendee(){
        return AttendeeSet;
     }
    
    //Data Safety - Safe Navigation Task-1 
    //DML operations and SOQL Queries Task1
    public void getAttendeeFromTrainingSession(){
        List<Training_Session__c> listOfTrainingSession = [select Id , Name from Training_Session__c];
        List<Attendee__c> listOfAttendee = [select Id , Name , Training_Session__c , Training_Session__r.Name from Attendee__c];
        for(Training_Session__c tSession : listOfTrainingSession){
    		for(Attendee__c attendee : listOfAttendee){
                if(tSession.Id == attendee?.Training_Session__c){
                 	System.debug('Session Name = '+ tSession.Name + ' , Attendee = '+ attendee.Name); 
                }
			}
		}
    }
    
    //----------------------------------------------------------------------------
    //Scenario: DML Operations and SOQL Queries
    //----------------------------------------------------------------------------
  
    public void createRecordSOQL(List<Training_Session__c> multipleObj){ 
        //Integer a = 20/0;    // to understand Exception (break the code)
        try{
            //Integer a = 20/0;
            
            //Scenario: DML Operations and SOQL Queries : Task-1
        	insert multipleObj;
        }
        catch (Exception e){
            System.debug('createRecordSOQL - Error : ' + e.getMessage());
            //throw e;
        }        
        finally{
            System.debug('createRecordSOQL - Execution Completed');
        }
    }
    
    public List<Training_Session__c> readRecordTrainingSessionSOQL(){
        List<Training_Session__c> sessionListSOQL = new List<Training_Session__c>();
        try{
            //Scenario: DML Operations and SOQL Queries : Task-1
            sessionListSOQL = [select Id, Name from Training_Session__c];
        	
        }
        catch (Exception e){
            System.debug('Error : ' + e.getMessage());
        }
        finally{
            System.debug('Execution Completed');
        }
        return sessionListSOQL;
    }
    
    public void updateRecordSOQL(Training_Session__c objToUpdate){
        try{
            //Scenario: DML Operations and SOQL Queries : Task-1
            Training_Session__c updateSession = [select Id, Name from Training_Session__c where Id = :objToUpdate.Id];
        	updateSession.Name = objToUpdate.Name;
        	update updateSession;
        }
        catch (Exception e){
            System.debug('Error : ' + e.getMessage());
        }
        finally{
            System.debug('Execution Completed');
        } 
    }
                                 
	public void deleteSingleRecordSOQL(String id){ 
         try{
            //Scenario: DML Operations and SOQL Queries : Task-1
            Training_Session__c deleteSession = [select Id, Name from Training_Session__c where Id = :id];
        	delete deleteSession;
        }
        catch (Exception e){
            System.debug('Error : ' + e.getMessage());
        }
        finally{
            System.debug('Execution Completed');
        } 
    }
    
   
    //Scenario: Custom Labels and Enhanced Queries (TASK-2)
    public void fetchTrainingSessionBasedOnSOQLCriteria(Date sdate, String type, Integer rollup ){
        List<Training_Session__c> basedOnDate = [select Id, Name, Session_Date__c from Training_Session__c where Session_Date__c = :sdate];
        System.debug('basedOnDate = '+ basedOnDate);
        
        List<Training_Session__c> basedOnType = [select Id, Name, RecordType.DeveloperName from Training_Session__c where RecordType.DeveloperName = :type];
        System.debug('basedOnType = '+ basedOnType);
        
        List<Training_Session__c> basedOnAttendeeCount = [select Id, Name, Count_Attendee__c from Training_Session__c where Count_Attendee__c >= :rollup];
        System.debug('basedOnAttendeeCount = '+ basedOnAttendeeCount);
        
        List<Training_Session__c> complexQuery = [select Id, Name, Session_Date__c,RecordType.DeveloperName, Count_Attendee__c from Training_Session__c where Session_Date__c = :sdate and RecordType.DeveloperName = :type and Count_Attendee__c >= :rollup];
        System.debug('complexQuery = '+ complexQuery);
    } 
    
//---------------------------------------------------------------------------------------------------------------------
//Database Class Methods    
    public void bulkInsert(List<Training_Session__c> insertList){
        Database.SaveResult[] srList = Database.Insert(insertList,false);
        
        for(Database.SaveResult sr : srList){
            System.debug('sr = '+ sr);
            if(sr.isSuccess()){
                System.debug('Bulk Insertion is successful');
            }
            else{
                for(Database.Error err : sr.getErrors()){
                    System.debug('The following error has occured');
                    System.debug(err.getStatusCode() + ' : ' + err.getMessage());
                    System.debug('Error occured on field : ' + err.getFields());
                }
            }
        }
        
    }
    
    
    public void bulkUpdate(List<Training_Session__c> updateList){
        Database.SaveResult[] srList = Database.Update(updateList,false);
        
        for(Database.SaveResult sr : srList){
            System.debug('sr = '+ sr);
            if(sr.isSuccess()){
                System.debug('Bulk Updation is successful');
            }
            else{
                for(Database.Error err : sr.getErrors()){
                    System.debug('The following error has occured');
                    System.debug(err.getStatusCode() + ' : ' + err.getMessage());
                    System.debug('Error occured on field : ' + err.getFields());
                }
            }
        }
        
    }
    
    
    public void bulkDelete(List<Training_Session__c> deleteList){
        Database.deleteResult[] srList = Database.delete(deleteList,false);
        
        for(Database.deleteResult sr : srList){
            System.debug('sr = '+ sr);
            if(sr.isSuccess()){
                System.debug('Bulk Deletion is successful');
            }
            else{
                for(Database.Error err : sr.getErrors()){
                    System.debug('The following error has occured');
                    System.debug(err.getStatusCode() + ' : ' + err.getMessage());
                    System.debug('Error occured on field : ' + err.getFields());
                }
            }
        }
        
    }
}