module namespace customFunctions = "customFunctionsforXML";

(:Return the current date - timestamp:)
declare function customFunctions:currentDate() as xs:string
{
	xs:string(fn:adjust-date-to-timezone(current-date(), ()))
};

(:Convert 'Until Changed' to current timestamp:) 
declare function customFunctions:untilChangedToNow($x as xs:string) as xs:date
{
	if( $x="9999-12-31" )
	then xs:date(customFunctions:currentDate())
	else xs:date($x)
};

(:Return the minimum of two dates:)
declare function customFunctions:minDate($x1 as xs:string, $x2 as xs:string) as xs:date
{
	if(xs:date($x1)>xs:date($x2))
	then xs:date($x2)
	else xs:date($x1)
};

(:Return Maximum of two dates:)
declare function customFunctions:maxDate($x1 as xs:string, $x2 as xs:string) as xs:date
{
    if(xs:date($x1)>xs:date($x2))
    then
        xs:date($x1)
    else
        xs:date($x2)
};

(:Convert all elements from Until Changed to Current-Timestamp:)
declare function customFunctions:untilChangedToAll($elements as element()*) as element()*
{
	for $element in $elements
		order by $element/@tstart, $element/@tend
		return element
			{node-name($element)}
			{
				customFunctions:slice($element, '1900-01-01', customFunctions:currentDate()),
				string($element)
			}
};

(:Return the snapshot of the data:)
declare function customFunctions:snapshot($elements as element()*) as element()*
{
	for $element in $elements
	   return element
	       	{node-name($element)}
		    {
		       $element/@*[name(.)!="tend" and name(.)!="tstart"],
		       data($element)
		    }
};

(:Get the department number of each element:)
declare function customFunctions:deptNumber( $deptnos as element()* ) as element()*
{
	for $deptno in $deptnos
		return element 
		{node-name($deptno)}
	{
		$deptno/@*,
		attribute deptname {string(doc("v-depts.xml")//department[deptno=$deptno]/deptname)},
		string($deptno)
	}
};

(:Return element which lie between start & end date:)
declare function customFunctions:slice( $element as element(), $start as xs:string, $stop as xs:string ) as attribute()*
{
	attribute tstart {customFunctions:maxDate($start,$element/@tstart)},
    attribute tend   {customFunctions:minDate($stop,$element/@tend)},
	$element/@*[name(.)!="tend" and name(.)!="tstart"]
};


declare function customFunctions:sliceAll( $elements as element()*,
								 $start as xs:string, $stop as xs:string ) as element()*
{
	for $element in $elements
		return 
			element {node-name($element)}
			{
				customFunctions:slice($element, $start, $stop),
				string($element)
			}
};


