<cffunction name="libicalrecurrenceNew" returntype="libicalrecurrence.ICalRecurrence" output="false">
  <cfargument name="startDate" type="date" required="true" />
  <cfargument name="rrule" type="string" required="true" />
  <cfargument name="exrule" type="string" required="false" />
  <cfargument name="exdate" type="string" required="false" />
  <cfargument name="rdate" type="string" required="false" />

  <!--- Create a new recurrence with the given arguments --->
  <cfreturn createObject("component", "libicalrecurrence.ICalRecurrence").init(argumentCollection = arguments) />
</cffunction>
