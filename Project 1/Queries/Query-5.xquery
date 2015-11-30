xquery version "1.0";

import module namespace customFunctions = "customFunctionsforXML" at "file:/Users/RonakSumbaly/Documents/UCLA/240A%20-%20Database%20%26%20Knowledge%20Bases/Project%20-%201/CustomFunctions.xquery";

declare variable $employee-xml as xs:string := "v-emps.xml";
declare variable $department-xml as xs:string := "v-depts.xml";

(:Temporal Join. For each employee find the longest consecuitive period in which he/she worked in the same  department and  the same department manager: 
Print the  employee number, his/her department number and  name, his/her manager number, and the period.:)

element temporalJoin
{
    for $emp in doc($employee-xml)//employee
	   return element
	
       	{node-name($emp)}	
       		{
       			customFunctions:slice($emp, '1900-01-01', customFunctions:currentDate()),
       			customFunctions:untilChangedToAll(($emp/empno, $emp/firstname,$emp/lastname)),
       			customFunctions:untilChangedToAll(($emp/title, $emp/deptno)),
       			
       			element managers
       			{
       				for	$deptno	in $emp/deptno,	$manager in doc($department-xml)//department[deptno=$deptno]
       				       /mgrno[@tstart<=$deptno/@tend 
       				       and $deptno/@tstart<=@tend]
       					        let $deptDuration := customFunctions:slice($deptno, '1900-01-01', customFunctions:currentDate())
       					        return  customFunctions:sliceAll(($manager), string($deptDuration[1]), string($deptDuration[2]))
       			}
       		}
}


