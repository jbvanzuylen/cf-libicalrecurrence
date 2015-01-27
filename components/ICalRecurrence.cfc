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

    @param startDate
    @param rrule
    @param exrule
    @param rdate
    @param exdate

    @return a instance of this component
  --->
  <cffunction name="init" access="public" returntype="libicalrecurrence.ICalRecurrence" output="false">
    <cfargument name="startDate" type="date" required="true" />
    <cfargument name="rrule" type="string" required="true" />
    <cfargument name="exrule" type="string" required="false" />
    <cfargument name="rdate" type="string" required="false" />
    <cfargument name="exdate" type="string" required="false" />

    <!--- Define local variables --->
    <cfset var iteratorFactory = createObject("java", "com.google.ical.iter.RecurrenceIteratorFactory") />

    <!--- Create iterator --->
    <cfset setIterator(iteratorFactory.createRecurrenceIterator(
                          javaCast("string", arguments.rrule),
                          dateToDateValue(arguments.startDate),
                          javaCast("null", ""),
                          javaCast("boolean", true)))
    />

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
    Skips all dates in this recurrence before the specified date

    @param newDate the date to which this recurrence is to be moved forward
  --->
  <cffunction name="advanceTo" access="public" returntype="void" output="false">
    <cfargument name="newDate" type="date" required="true" />

    <!--- Define local variables --->
    <cfset var dateValue = createObject("java", "com.google.ical.values.DateValueImpl") />

    <cfset getIterator().advanceTo(dateToDateValue(arguments.newDate)) />
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