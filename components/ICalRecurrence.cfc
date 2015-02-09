<cfcomponent displayname="ICalRecurrence" output="false">
  <!---
    Retrieves the iterator for this recurrence

    @return the iterator for this recurrence
  --->
  <cffunction name="getIterator" access="private" returntype="any" output="false">
    <cfreturn variables.iterator />
  </cffunction>

  <!---
    Sets the iterator for this recurrence

    @param iterator the iterator to be set for this recurrence
  --->
  <cffunction name="setIterator" access="private" returntype="void" output="false">
    <cfargument name="iterator" type="any" required="true" />

    <cfset variables.iterator = arguments.iterator />
  </cffunction>

  <!---
    Initializes this recurrence

    @param startDate the date at which the recurrence starts
    @param rrule the iCalendar value for the RRULE property of the recurrence
    @param exrule the iCalendar value for the EXRULE property of the recurrence
    @param rdate the iCalendar value for the RDATE property of the recurrence
    @param exdate the iCalendar value for the EXDATE property of the recurrence

    @return a instance of this component
  --->
  <cffunction name="init" access="public" returntype="libicalrecurrence.ICalRecurrence" output="false">
    <cfargument name="startDate" type="date" required="true" />
    <cfargument name="rrule" type="string" required="false" />
    <cfargument name="exrule" type="string" required="false" />
    <cfargument name="rdate" type="string" required="false" />
    <cfargument name="exdate" type="string" required="false" />

    <!--- Save arguments --->
    <cfset variables.data = structCopy(arguments) />

    <!--- Initializes the iterator --->
    <cfset initIterator() />

    <cfreturn this />
  </cffunction>

  <!---
    Indicates whether there are more dates in this recurrence

    @return true if there are more dates in this recurrence, false otherwise
  --->
  <cffunction name="hasNext" access="public" returntype="boolean" output="false">
    <cfreturn getIterator().hasNext() />
  </cffunction>

  <!---
    Returns the next date in this recurrence

    @return the next date in this recurrence
  --->
  <cffunction name="next" access="public" returntype="date" output="false">
    <cfreturn dateValueToDate(getIterator().next()) />
  </cffunction>

  <!---
    Indicates whether this recurrence is infinite

    @return true if this recurrence is infinite, false otherwise
  --->
  <cffunction name="isInfinite" access="public" returntype="boolean" ouput="false">
    <!--- Define local variables --->
    <cfset var rrule = createObject("java", "com.google.ical.values.RRule") />

    <!--- Check --->
    <cfif structKeyExists(variables.data, "rrule") AND (NOT isNull(variables.data.rrule)) AND (len(variables.data.rrule) gt 0)>
      <cfset rrule.init("RRULE:" & variables.data.rrule) />
      <cfreturn (rrule.getCount() lte 0) AND isNull(rrule.getUntil()) />
    <cfelse>
      <cfreturn false />
    </cfif>
  </cffunction>

  <!---
    Skips all dates in this recurrence before the specified date

    @param newDate the date to which this recurrence is to be moved forward
  --->
  <cffunction name="advanceTo" access="public" returntype="void" output="false">
    <cfargument name="newDate" type="date" required="true" />

    <cfset getIterator().advanceTo(dateToDateValue(arguments.newDate)) />
  </cffunction>

  <!---
    Resets the recurrence at its first occurrence date
  --->
  <cffunction name="reset" access="public" returntype="void" ouput="false">
    <cfset inititerator() />
  </cffunction>

  <!---
    Initializes the iterator for this recurrence
  --->
  <cffunction name="initIterator" access="private" returntype="void" output="false">
    <!--- Define local variables --->
    <cfset var iteratorFactory = createObject("java", "com.google.ical.iter.RecurrenceIteratorFactory") />
    <cfset var rdata = createObject("java", "java.lang.StringBuilder") />

    <!--- Build recurrence data --->
    <cfif structKeyExists(variables.data, "rrule") AND (NOT isNull(variables.data.rrule)) AND (len(variables.data.rrule) gt 0)>
      <cfset rdata.append("RRULE:").append(variables.data.rrule).append(chr(10)) />
    </cfif>
    <cfif structKeyExists(variables.data, "exrule") AND (NOT isNull(variables.data.exrule)) AND (len(variables.data.exrule) gt 0)>
      <cfset rdata.append("EXRULE:").append(variables.data.exrule).append(chr(10)) />
    </cfif>
    <cfif structKeyExists(variables.data, "rdate") AND (NOT isNull(variables.data.rdate)) AND (len(variables.data.rdate) gt 0)>
      <cfset rdata.append("RDATE:").append(variables.data.rdate).append(chr(10)) />
    </cfif>
    <cfif structKeyExists(variables.data, "exdate") AND (NOT isNull(variables.data.exdate)) AND (len(variables.data.exdate) gt 0)>
      <cfset rdata.append("EXDATE:").append(variables.data.exdate).append(chr(10)) />
    </cfif>

    <!--- Create iterator --->
    <cfset setIterator(iteratorFactory.createRecurrenceIterator(
                          rdata.toString(),
                          dateToDateValue(variables.data.startDate),
                          javaCast("null", ""),
                          javaCast("boolean", true)))
    />
  </cffunction>

  <!---
    Converts the specified date to a DateValue object

    @param date the date to be converted

    @return a DateValue object
  --->
  <cffunction name="dateToDateValue" access="private" returntype="any" output="false">
    <cfargument name="date" type="date" required="true" />

    <!--- Define local variables --->
    <cfset var h = hour(arguments.date) />
    <cfset var m = minute(arguments.date) />
    <cfset var s = second(arguments.date) />
    <cfset var dateValue = "" />

    <!--- Convert --->
    <cfif (h eq 0) AND (m eq 0) AND (s eq 0)>
      <cfset dateValue = createObject("java", "com.google.ical.values.DateValueImpl") />
      <cfreturn dateValue.init(year(arguments.date),
                               month(arguments.date),
                               day(arguments.date))
      />
    <cfelse>
      <cfset dateValue = createObject("java", "com.google.ical.values.DateTimeValueImpl") />
      <cfreturn dateValue.init(year(arguments.date),
                               month(arguments.date),
                               day(arguments.date),
                               h,
                               m,
                               s)
      />
    </cfif>
  </cffunction>

  <!---
    Converts the specified DateValue object to a date

    @param dateValue the DateValue object to be converted

    @return a date
  --->
  <cffunction name="dateValueToDate" access="private" returntype="date" output="false">
    <cfargument name="dateValue" type="any" required="true" />

    <!--- Convert --->
    <cfif arguments.dateValue.getClass().getName() eq "com.google.ical.values.DateTimeValueImpl">
      <cfreturn createDateTime(arguments.dateValue.year(),
                               arguments.dateValue.month(),
                               arguments.dateValue.day(),
                               arguments.dateValue.hour(),
                               arguments.dateValue.minute(),
                               arguments.dateValue.second())
      />
    <cfelse>
      <cfreturn createDate(arguments.dateValue.year(),
                           arguments.dateValue.month(),
                           arguments.dateValue.day())
      />
    </cfif>
  </cffunction>
</cfcomponent>