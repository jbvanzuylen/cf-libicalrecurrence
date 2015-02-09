<cffunction name="libicalrecurrenceReset" returntype="void" output="false">
  <cfargument name="recurrence" type="libicalrecurrence.ICalRecurrence" required="true" />

  <!--- Resets the recurrence at its first occurrence date --->
  <cfset arguments.recurrence.reset() />
</cffunction>
