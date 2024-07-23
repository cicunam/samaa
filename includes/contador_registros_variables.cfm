<!--- Total de registros --->
<cfoutput>
	<input id="vPagAct" type="hidden" value="#PageNum#">
	<input id="vRegRan" type="hidden" value="<cfif tbSolicitudes.RecordCount GT 0>#StartRow# al #EndRow#<cfelse>0</cfif>">
	<input id="vRegTot" type="hidden" value="#tbSolicitudes.RecordCount#">
</cfoutput>