xquery version "1.0";

import module namespace customFunctions = "customFunctionsforXML" at "file:/Users/RonakSumbaly/Documents/UCLA/Project-1/CustomFunctions.xquery";

declare variable $employee-xml as xs:string := "v-emps.xml";
declare variable $department-xml as xs:string := "v-depts.xml";

 (:Temporal Max. For the employees  in department d005, find the maximum of their salaries over time, 
 and print the history of such a maximum.:)

declare variable $emps := doc($employee-xml)/employees/employee[deptno='d005'];

declare variable $start-dates :=
        for $i in distinct-values($emps/salary/@tstart)
        order by $i
        return xs:date($i);

declare variable $end-dates :=
        for $i in distinct-values($emps/salary/@tend)
        order by $i
        return xs:date($i);
        
declare variable $combined-dates := 
	for $i in distinct-values(($start-dates, $end-dates))
		order by $i
		return $i; 

declare variable $temporal-max := 
    for $start at $pos in $combined-dates
        let $x := $emps/salary[@tstart <= $start and $start < @tend]
        let $max-salary := max($x)
        order by $start
        return <max date="{$start}">{xs:float($max-salary)}</max>; 

declare variable $maxCount := count($temporal-max);

declare variable $max-date :=
    for $tstart at $pos in $temporal-max
	      let $tend := $temporal-max[$pos + 1]
	       where( $pos < $maxCount )
	       return <max tstart="{$tstart/@date}" tend="{$tend/@date}">{string($temporal-max[$pos])}</max>;

declare variable $unique-salaries := distinct-values($max-date) ;

declare variable $coalesce := 
    for $v in $unique-salaries
        let $sal := $max-date[text()=$v]
        let $start := '9999-12-31'
        let $end := '1900-12-31' 
        let $s := 
            for $x in $sal 
               let $start := customFunctions:minDate($x/@tstart,$start)
            return min($start)
        let $e := 
            for $x in $sal 
               let $end := customFunctions:maxDate($x/@tend,$end)
            return max($end)
        return <max tstart="{min($s)}" tend="{max($e)}">{string($v)}</max>; 
        
            
<company>
{
     for $value in $coalesce
        return $value
}
</company>
