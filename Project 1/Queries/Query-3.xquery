xquery version "1.0";

import module namespace customFunctions = "customFunctionsforXML" at "file:/Users/RonakSumbaly/Documents/UCLA/240A%20-%20Database%20%26%20Knowledge%20Bases/Project%20-%201/CustomFunctions.xquery";

declare variable $employee-xml as xs:string := "v-emps.xml";
declare variable $department-xml as xs:string := "v-depts.xml";

declare variable $tstart := '1994-05-01';
declare variable $tend   := '1996-05-06';

(:Temporal Slicing. For all departments, print their histories for the period starting on 1994-05-01 and ending 1996-05-06.:)
element slicing
{
    for $dept in doc($department-xml)//department[not( @tstart > $tend or $tstart >= @tend)]
       	return element
       	
       	{node-name($dept)}
       		{
       			customFunctions:slice($dept, $tstart, $tend),
       			customFunctions:sliceAll($dept/*[not( @tstart > $tend or $tstart >= @tend)], $tstart, $tend)
       		}
}


