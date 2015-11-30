xquery version "1.0";

import module namespace customFunctions = "customFunctionsforXML" at "file:/Users/RonakSumbaly/Documents/UCLA/240A%20-%20Database%20%26%20Knowledge%20Bases/Project%20-%201/CustomFunctions.xquery";

declare variable $employee-xml as xs:string := "v-emps.xml";
declare variable $department-xml as xs:string := "v-depts.xml";

(:Temporal Avg.  Print the history of the average salary for each job title:)

declare variable $titles := doc($employee-xml)//title;
declare variable $emps := doc($employee-xml);

declare variable $job-titles :=
    for $i in distinct-values($titles)
        order by $i
        return xs:string($i);

<company>
{
    for $job in $job-titles
        let $jobs := $emps/employees/employee[title=$job]/salary                
        let $dates :=
            for $date in distinct-values(($jobs/@tstart, $jobs/@tend))
                order by $date
                return ($date)
        let $max := count($dates)
        return
        <job>
                <job-title>{$job}</job-title>
                {
                    for $tstart at $pos in ($dates)
                        let $y := $jobs[@tstart <= $tstart and $tstart < @tend],
                            $tend := $dates[$pos + 1]
                            where $pos < $max and not($tstart = "9999-12-31")
                        return <average tstart="{$tstart}" tend="{$tend}">{avg($y)}</average>
                }
        </job>
}
</company>



