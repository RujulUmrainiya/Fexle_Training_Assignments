/*
    Description : Tasks which contains use of Collections - Lists, Sets, Maps
    Created By : Rujul Umrainiya
    Created Date : 26-11-2024
    Revision Logs : v1.0
*/

public class ApexAssignment1 {

    // Task1 - Created Map representing 'department' as keys and 'list of employees' as values
    public void Task1(){
        Map<String,List<String>> empInDept = new Map<String,List<String>>();
        /*
        ---- Another Way to add data in List-----

        List<string> employees = new List<string>();
        employees.add('Rakesh');
        employees.add('Gita');
        employees.add('Vijay');
        */
        List<String> employees_HR_Dept = new List<String>{'Ajay','Gita','Vijay'};  
        empInDept.put('HR', employees_HR_Dept);
        
        List<String> employees_Sales_Dept = new List<String>{'Sales1','Sales2','Sales3'}; 
        empInDept.put('Sales', employees_Sales_Dept);
        
        for(String deptKey: empInDept.keySet()){
            
            System.Debug('Department = '+deptKey);
            for(string emp : empInDept.get(deptKey)){
                System.Debug('EmployeeName = '+emp);
            }
        }
    }
    
    /*
    public void AddDepartmentAndEmployees(String deptName,List<String> empNames){
        Map<String,List<String>> empInDept = new Map<String,List<String>>();
        
        empInDept.put(deptName, empNames);
        
        for(String deptKey: empInDept.keySet()){
            
            System.Debug('Department = '+deptKey);
            for(String emp : empInDept.get(deptKey)){
                System.Debug('EmployeeName = '+emp);
            }
        }
    }
    */
    
    //Task2 - To find Union, Intersection, Difference b/w two sets
    public void Task2(){
        Set<String> StudentGroup1 = new Set<String>{'A','B','C','D'};    //Set1
        Set<String> StudentGroup2 = new Set<String>{'E','A','H','I','F','C','G'};   //Set2
            
        // Union
        Set<String> unionSet = StudentGroup1.clone(); 
        unionSet.addAll(StudentGroup2);
        System.debug('Union: ' + unionSet); 
        
        // Intersection
        Set<String> intersectionSet = StudentGroup1.clone(); 
        intersectionSet.retainAll(StudentGroup2);
        System.debug('Intersection: ' + intersectionSet);
        
        // Difference
        Set<String> differenceSet = StudentGroup1.clone();
        differenceSet.removeAll(StudentGroup2);
        System.debug('Difference: ' + differenceSet); 
    

    }
    
    
    //Task3 - To Sort List in Ascending Order and then print
    public void Task3(){
        List<Integer> Numbers = new List<Integer>{56,23,78,14,10,85,99,48,57,64};
        Numbers.Sort();
        System.debug(Numbers);
    }
}