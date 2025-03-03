public class ContactTriggerHandler extends TriggerHandler {
    
    //SmartyStreet Assignment
    public static void updateSmartyAppAddress(List<Contact> newList){
        
        Set<Id> ids = new Set<Id>();
        for(Contact con : newList){
            
            ids.add(con.Id);
        }
        SmartyAssignment.callWebApi(ids);
    }
    
    //public static String errorMessage = 'Email does not match the Related Account Domain';
    public static String errMsg = 'RecordID does not exist, Please enter a valid RecordID';
    
    public override void beforeInsert(){
        
        ContactTriggerHandler.emailValidation();
        populateObjectAndPicklist(Trigger.new);
        //ContactTriggerHandler.updateFieldMetadataUsingDynamicApex();
    }
    
    
    
    private static void emailValidation(){
        
        String errorMsg = 'Email domain did\'nt match with the Account domain!!';
        List<Contact> beforeInsertList = Trigger.New;
        
        Set<Id> accIdSet = new Set<Id>();   //Contains -> AccountId of Contacts
        //List<Account> accList = [SELECT Id from Account where Id = : ];
        for(Contact con : beforeInsertList){
            
            accIdSet.add(con.AccountId);
        }
        
        System.debug('@@@ beforeInsertList : ' + beforeInsertList);
        //Set<id> ids = Trigger.newMap.keySet();
        System.debug('@@@ accIdSet : ' + accIdSet);
        List<Account> accList = [SELECT Id, Domain_Name__c from Account where Id in : accIdSet];
        System.debug('@@@ accList : ' + accList);
        
        Map<Id,Account> accMap = new Map<Id,Account> (accList);
               
        for(Contact con : beforeInsertList){
            
            //matching condition for error
            if(con.Email != NULL && con.AccountId != NULL && accMap.get(con.AccountId).Domain_Name__c != NULL 
               && !con.Email.endsWith(accMap.get(con.AccountId).Domain_Name__c)){
                   con.addError(errorMsg);
               }
        }
    }
     
    
    
    public static void populateObjectAndPicklist(List<Contact> newList)
    {
        //Check if new records are present
        if(!newList.isEmpty())
        {
            for(Contact con : newList)
            {
                System.debug('1 : ' + con.RecordID__c);
                //Check if current record has RecordID or not
                if(!String.isEmpty(con.RecordID__c)) 
                { 
                    try
                    {
                        System.debug('2 : ' + Id.valueOf(con.RecordID__c));
                        System.debug('3 : ' + Id.valueOf(con.RecordID__c).getSObjectType());
                        if(Id.valueOf(con.RecordID__c).getSObjectType() != null)
                        {
                            //Store Record ID in variable of type Id
                            Id recordId;
                            recordId = Id.valueOf(con.RecordID__c); 
                            
                            //Get Object Name of that Id
                            SobjectType SObjectName = recordId.getSObjectType();
                            System.debug('4 : ' + SObjectName);
                            
                            //List to store picklist field names
                            List<string> picklistfields = new List<string>();
                            
                            //Get all Metadata of the particular Object Name
                            Schema.DescribeSObjectResult sObjectDescribe = SObjectName.getDescribe(); 
                            
                            System.debug('5 - getDescribe : ' + sObjectDescribe);
                            System.debug('5 - fields : ' + sObjectDescribe.fields);
                            System.debug('5 - getMap : ' + sObjectDescribe.fields.getMap());
                            System.debug('5 : ' + sObjectDescribe.fields.getMap().values());
                            // Iterate through the fields of the sObject 
                            for (Schema.SObjectField field : sObjectDescribe.fields.getMap().values()) 
                            { 
                                //Get information about the current field value
                                Schema.DescribeFieldResult fieldDescribe = field.getDescribe(); 
                                
                                System.debug('6 : ' + fieldDescribe);
                                
                                // Check if the field is a picklist 
                                if (fieldDescribe.getType() == Schema.DisplayType.Picklist) 
                                { 
                                    // Print the picklist field name 
                                    picklistfields.add(fieldDescribe.getName());
                                    System.debug('6.1 - fieldDescribe.getName : ' + fieldDescribe.getName());
                                } 
                            }
                            
                            System.debug('7 : ' + ((Id)recordId).getSobjectType().getDescribe().getName());
                            
                            //Updating value of Object in the field
                            con.Object_Name__c = ((Id)recordId).getSobjectType().getDescribe().getName();
                            
                            //Adding picklist field names in seperate lines
                            if(!picklistfields.isEmpty())
                            {
                                con.Picklist_Field__c = '';
                                for(String val : picklistfields)
                                {
                                    con.Picklist_Field__c += val + '\n';       
                                }
                            }
                            //If there are no picklist fields, set the field empty
                            else
                            {
                                con.Picklist_Field__c = '';
                            }
                            
                            System.debug('8 : ' + con.Picklist_Field__c);
                    	}
                    }
                    catch(Exception e)
                    {
                        con.addError(errMsg);
                    }
                }
            }
        }
    }
    
    
    /*---------Different approach
    private static void updateFieldMetadataUsingDynamicApex(){
        
        List<Contact> beforeInsertList = Trigger.New;
        for(Contact con : beforeInsertList){
            
            //processSObjectsSOQL(con.recordId__c, con);
            processSObjectsSOSL(con.recordId__c, con);
        }       
    }
   
    
    public static void processSObjectsSOSL(String recordId, Contact con) {
        // Retrieve all SObject types
        Map<String, Schema.SObjectType> sObjectTypes = Schema.getGlobalDescribe();
        
        // Build SOSL query dynamically
        String soslQuery = 'FIND \'' + recordId + '\' IN ALL FIELDS RETURNING ';
        
        List<String> returningClauses = new List<String>();
        for (String sObjectName : sObjectTypes.keySet()) {
            try {
                // Describe the SObject
                Schema.DescribeSObjectResult sObjectDescribe = sObjectTypes.get(sObjectName).getDescribe();
                              
                //System.debug('@@@@ sObjectName = ' + sObjectName);
                

                
                // Describe object to check if it supports search
                if (sObjectDescribe.isSearchable()) {
                    returningClauses.add(sObjectName + '(Id)');
                }
                
                // Append returning clauses to the SOSL query
                soslQuery += String.join(returningClauses, ', ');
                
                System.debug('soslQuery: ' + soslQuery);
                
                // Execute the SOSL query
                List<List<SObject>> searchResults = Search.query(soslQuery);
                
                // If the SObject has records, check for picklist fields
                if (!searchResults.isEmpty()) {
                    System.debug('SObject with records: ' + sObjectName);
                    
                    con.Object_Name__c = sObjectName;
                    
                    // Retrieve fields of the SObject
                    Map<String, Schema.SObjectField> fields = sObjectDescribe.fields.getMap();
                    String pickListFieldName = '';
                    for (String fieldName : fields.keySet()) {
                        Schema.SObjectField field = fields.get(fieldName);
                        Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
                        
                        // Check if the field is a picklist
                        if (fieldDescribe.getType() == Schema.DisplayType.PICKLIST) {
                            System.debug('  Picklist Field: ' + fieldName);
                            pickListFieldName = pickListFieldName + ' ' + fieldName;
                        }
                    }
                    con.Picklist_Field__c = pickListFieldName;
                    update con;
                }
            } catch (Exception e) {
                // Handle exceptions for specific SObjects that might not be queryable or have special restrictions
                System.debug('Error processing SObject: ' + sObjectName + '. Exception: ' + e.getMessage());
            }
        }
    }
    
    
    public static void processSObjectsSOQL(String recordId, Contact con) {
        // Retrieve all SObject types
        Map<String, Schema.SObjectType> sObjectTypes = Schema.getGlobalDescribe();
        
        for (String sObjectName : sObjectTypes.keySet()) {
            try {
                // Describe the SObject
                Schema.DescribeSObjectResult sObjectDescribe = sObjectTypes.get(sObjectName).getDescribe();
                
                // Check if the SObject is queryable
                if (!sObjectDescribe.isQueryable()) {
                    continue;
                }
                
                //System.debug('@@@@ sObjectName = ' + sObjectName);
                
                if (!(sObjectName == 'Lead')) {
                    continue;
                }
                
                // Query the Id field to ensure the SObject has records
                String query = 'SELECT Id FROM ' + sObjectName + ' WHERE Id = \'00QNS00000KvsGU2AZ\''; //+ recordId;
                System.debug('@@@@ query = ' + query);
                List<SObject> records = Database.query(query);
                
                
                // If the SObject has records, check for picklist fields
                if (!records.isEmpty()) {
                    System.debug('SObject with records: ' + sObjectName);
                    
                    con.Object_Name__c = sObjectName;
                    
                    // Retrieve fields of the SObject
                    Map<String, Schema.SObjectField> fields = sObjectDescribe.fields.getMap();
                    String pickListFieldName = '';
                    for (String fieldName : fields.keySet()) {
                        Schema.SObjectField field = fields.get(fieldName);
                        Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
                        
                        // Check if the field is a picklist
                        if (fieldDescribe.getType() == Schema.DisplayType.PICKLIST) {
                            System.debug('  Picklist Field: ' + fieldName);
                            pickListFieldName = pickListFieldName + ' ' + fieldName;
                        }
                    }
                    con.Picklist_Field__c = pickListFieldName;
                    update con;
                }
            } catch (Exception e) {
                // Handle exceptions for specific SObjects that might not be queryable or have special restrictions
                System.debug('Error processing SObject: ' + sObjectName + '. Exception: ' + e.getMessage());
            }
        }
    }  
	*/
}