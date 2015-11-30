xquery version "1.0";

import module namespace customFunctions = "customFunctionsforXML" 
at "file:/Users/RonakSumbaly/Documents/UCLA/240A%20-%20Database%20%26%20Knowledge%20Bases/Project%20-%201/CustomFunctions.xquery";

declare variable $employee-xml as xs:string := "v-emps.xml";
declare variable $department-xml as xs:string := "v-depts.xml";

(:Query 1 - Selection and Temporal Projection.  Print the salary history of employee "Anneke Preusig.":)
element history
{
    for $employee in doc($employee-xml)//employee[firstname="Anneke" and lastname="Preusig"]
	     return $employee//salary
}


