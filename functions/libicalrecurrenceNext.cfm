<cffunction name="libicalrecurrenceNext" returntype="date" output="false">
  <cfargument name="recurrence" type="libicalrecurrence.ICalRecurrence" required="true" />

  <!--- return the next date in the given recurrence --->
  <cfreturn arguments.recurrence.next() />
</cffunction>
