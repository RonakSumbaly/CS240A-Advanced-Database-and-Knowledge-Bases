xquery version "1.0";

import module namespace customFunctions = "customFunctionsforXML" at "file:/Users/RonakSumbaly/Documents/UCLA/240A%20-%20Database%20%26%20Knowledge%20Bases/Project%20-%201/CustomFunctions.xquery";

declare variable $employee-xml as xs:string := "v-emps.xml";
declare variable $department-xml as xs:string := "v-depts.xml";

(:Duration after Coalescing. For each employee, find the longest period (or periods) 
during which he/she went with no change in salary: for each employee  print the period(s), his/her name and the actual salary.:)

element durationCoalescing
{
    for $emp in doc($employee-xml)//employee
    	let $durations := (for $salary in $emp/salary
    	                   return customFunctions:untilChangedToNow($salary/@tend) - xs:date($salary/@tstart)
    	                  )
    	return element
    	
    	{node-name($emp)}
    	
    	{
    			customFunctions:slice($emp, '1900-01-01', customFunctions:currentDate()),
    			customFunctions:untilChangedToAll(($emp/firstname, $emp/lastname)),
    			
    			element LongestPeriod {max($durations)},
    			for $salary	in 
    			    $emp/salary[customFunctions:untilChangedToNow(@tend) - 
    			                xs:date(@tstart)=max($durations)]
    			    order by $salary/@tstart, $salary/@tend
    				return element 
    					{node-name($salary)}
    					{
    						customFunctions:slice($salary, '1900-01-01', customFunctions:currentDate()),
    						string($salary)
    					}
    	}
}


