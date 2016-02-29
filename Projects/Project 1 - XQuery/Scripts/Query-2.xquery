xquery version "1.0";

import module namespace customFunctions = "customFunctionsforXML" at "file:/Users/RonakSumbaly/Documents/UCLA/240A%20-%20Database%20%26%20Knowledge%20Bases/Project%20-%201/CustomFunctions.xquery";

declare variable $employee-xml as xs:string := "v-emps.xml";
declare variable $department-xml as xs:string := "v-depts.xml";

declare variable $date := '1995-01-01';

(:Temporal Snapshot. Print  the name, salary and department of  each employee who, on 1995-01-01, was making more than $80,000.:)
element snapshot
{
    for $emp in doc($employee-xml)//employee[@tstart <= $date and $date <= @tend]
	let $salary := $emp/salary[@tstart <= $date and $date <= @tend],
	    $deptno := $emp/deptno[@tstart <= $date and $date <= @tend]
	where($salary and $deptno and $salary > 80000 )
	return element
	
	{node-name($emp)}	
	{
	   customFunctions:snapshot(($emp/firstname, $emp/lastname, customFunctions:deptNumber($deptno), $salary))
	}
}


