xquery version "1.0";

import module namespace customFunctions = "customFunctionsforXML" at "file:/Users/RonakSumbaly/Documents/UCLA/240A%20-%20Database%20%26%20Knowledge%20Bases/Project%20-%201/CustomFunctions.xquery";

declare variable $employee-xml as xs:string := "v-emps.xml";
declare variable $department-xml as xs:string := "v-depts.xml";

(:Temporal Join. For each employee find the longest consecuitive period in which he/she worked in the same  department and  the same department manager: 
Print the  employee number, his/her department number and  name, his/her manager number, and the period.:)

declare function local:calculateDuration($duration as xs:dayTimeDuration?)  as xs:decimal? {
   $duration div xs:dayTimeDuration('P1D')
 } ;

declare function local:getPeriod($dept){
    for $r in $dept
        let $period := $r/@tend cast as xs:date - $r/@tstart cast as xs:date
        let $days := local:calculateDuration($period) cast as xs:integer
        return <dept period="{$days}">{data($r)}</dept>
};

element temporalJoin
{
    for $emp in doc($employee-xml)//employee
	   let $dept := doc($department-xml)//department[deptno=$emp/deptno]
	   let $deptRange := local:getPeriod($emp/deptno)
	   let $department := $deptRange[@period = max($deptRange/@period)]
	   let $managerNo := $dept[deptno=data($department)]/mgrno
	   let $managerRange := local:getPeriod($managerNo)
	   let $manager :=  $managerRange[@period=max($managerRange/@period)] 
	   where not (empty($deptRange)) and not(empty($managerRange))	   
	   return 
	   <employee>
            <empno>{data($emp/empno)}</empno>
            <name>{data($emp/firstname),data($emp/lastname)}</name>
            <deptNo>{data($department)}</deptNo>
            <manager>{data($manager)}</manager>
            <period>{$department/@period}</period>
        </employee>   
}


