<cffunction name="libicalrecurrenceIsInfinite" returntype="boolean" output="false">
  <cfargument name="recurrence" type="libicalrecurrence.ICalRecurrence" required="true" />

  <!--- Check whether this recurrence is infinite --->
  <cfreturn arguments.recurrence.isInfinite() />
</cffunction>
