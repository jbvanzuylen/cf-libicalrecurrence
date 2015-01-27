<cfcomponent displayname="ICalRecurrence" output="false">
  <!---
    Retrieves the recurrence iterator
  --->
  <cffunction name="getIterator" access="private" returntype="any" output="false">
    <cfreturn variables.iterator />
  </cffunction>

  <!---
    Sets the recurrence iterator
  --->
  <cffunction name="setIterator" access="private" returntype="void" output="false">
    <cfargument name="iterator" type="any" required="true" />

    <cfset variables.iterator = arguments.iterator />
  </cffunction>

  <!---
  --->
  <cffunction name="init" access="public" returntype="libicalrecurrence.ICalRecurrence" output="false">
    <cfargument name="startDate" type="date" required="true" />
    <cfargument name="rrule" type="string" required="true" />
    <cfargument name="exrule" type="string" required="false" />
    <cfargument name="exdate" type="string" required="false" />
    <cfargument name="rdate" type="string" required="false" />

    <!--- Define local variables --->
    <cfset var iteratorFactory = createObject("java", "com.google.ical.iter.RecurrenceIteratorFactory") />
    <cfset var dvStart = dateToDateValue(arguments.startDate) />

    <!--- Create iterator --->
    <cfset setIterator(iteratorFactory.createRecurrenceIterator(
                        javaCast("string", arguments.rrule),
                        dvStart,
                        JavaCast("null", ""),
                        javaCast("boolean", true)))
    />

    <cfreturn this />
  </cffunction>

  <!---
    Indicates whether there are more dates in the series

    @return true if there are more dates in the series, false otherwise
  --->
  <cffunction name="hasNext" access="public" returntype="boolean" output="false">
    <cfreturn getIterator().hasNext() />
  </cffunction>

  <!---
    Returns the next date in the series

    @return the next date in the series
  --->
  <cffunction name="next" access="public" returntype="date" output="false">
    <cfreturn dateValueToDate(getIterator().next()) />
  </cffunction>

  <!---
    Skips all dates in the series before the specified date

    @param newDate the date to which
  --->
  <cffunction name="advanceTo" access="public" returntype="void" output="false">
    <cfargument name="newDate" type="date" required="true" />

    <!--- Define local variables --->
    <cfset var dateValue = createObject("java", "com.google.ical.values.DateValueImpl") />

    <cfset getIterator().advanceTo(dateToDateValue(arguments.newDate)) />
  </cffunction>

  <!---
    Converts the specified date to a DateValue object
  --->
  <cffunction name="dateToDateValue" access="private" returntype="any" output="false">
    <cfargument name="date" type="date" required="true" />

    <!--- Define local variables --->
    <cfset var dateValue = createObject("java", "com.google.ical.values.DateValueImpl") />

    <cfreturn dateValue.init(year(arguments.date), month(arguments.date), day(arguments.date)) />
  </cffunction>

  <!---
    Converts the specified DateValue object to a date
  --->
  <cffunction name="dateValueToDate" access="private" returntype="date" output="false">
    <cfargument name="dateValue" type="any" required="true" />

    <cfreturn createDate(arguments.dateValue.year(), arguments.dateValue.month(), arguments.dateValue.day()) />
  </cffunction>
</cfcomponent>