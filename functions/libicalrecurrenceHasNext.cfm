<cffunction name="libicalrecurrenceHasNext" returntype="boolean" output="false">
  <cfargument name="recurrence" type="libicalrecurrence.ICalRecurrence" required="true" />

  <!--- Check whether there are more dates in the given recurrence --->
  <cfreturn arguments.recurrence.hasNext() />
</cffunction>
