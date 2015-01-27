<cffunction name="libicalrecurrenceAdvanceTo" returntype="date" output="false">
  <cfargument name="recurrence" type="libicalrecurrence.ICalRecurrence" required="true" />
  <cfargument name="newDate" type="date" required="true" />

  <!--- Skip all dates in the given recurrence before the given date --->
  <cfreturn arguments.recurrence.advanceTo(arguments.newDate) />
</cffunction>
