xquery version "1.0";

import module namespace customFunctions = "customFunctionsforXML" at "file:/Users/RonakSumbaly/Documents/UCLA/240A%20-%20Database%20%26%20Knowledge%20Bases/Project%20-%201/CustomFunctions.xquery";

declare variable $employee-xml as xs:string := "v-emps.xml";
declare variable $department-xml as xs:string := "v-depts.xml";

(:Temporal Avg.  Print the history of the average salary for the whole company:) 

declare variable $dept-no := doc("v-emps.xml")//deptno;
declare variable $salary := doc("v-emps.xml")//salary;

declare variable $start-dates :=
    for $i in distinct-values($salary/@tstart)
        order by $i
        return xs:date($i);
    
declare variable $end-dates :=
    for $i in distinct-values($salary/@tend)
        order by $i
        return xs:date($i);

declare variable $combined-dates := 
	for $i in distinct-values(($start-dates, $end-dates))
		order by $i
		return $i;    

declare variable $average-salary :=
    for $start at $pos in $combined-dates 
        let $x := $salary[@tstart <= $start and $start < @tend]
        let $avg := avg($x)
        order by $start
        return <avg date="{$start}">{xs:float($avg)}</avg>; 

declare variable $max := count($average-salary);

<whole-company>
{
     for $tstart at $pos in $average-salary
	      let $tend := $average-salary[$pos + 1]
	       where( $pos < $max )
	       return <average tstart="{$tstart/@date}" tend="{$tend/@date}">
	       {string($average-salary[$pos])}</average>
}
</whole-company>
