<cffunction name="libicalrecurrenceLast" returntype="date" output="false">
  <cfargument name="recurrence" type="libicalrecurrence.ICalRecurrence" required="true" />

  <!--- Return the last date in the given recurrence --->
  <cfreturn arguments.recurrence.last() />
</cffunction>
