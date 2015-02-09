<cffunction name="libicalrecurrenceAdvanceTo" returntype="void" output="false">
  <cfargument name="recurrence" type="libicalrecurrence.ICalRecurrence" required="true" />
  <cfargument name="newDate" type="date" required="true" />

  <!--- Skip all dates in the given recurrence before the given date --->
  <cfset arguments.recurrence.advanceTo(arguments.newDate) />
</cffunction>
