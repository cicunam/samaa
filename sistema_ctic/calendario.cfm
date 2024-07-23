<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 05/06/2009 --->
<!--- FECHA ÚLTIMA MOD.: 17/05/2022 --->
<!--- CALENDARIO DE SESIONES--->
<!--- Parámetros --->
<cfparam name="attributes.cdatasource" type="string" default="calendar">
<cfparam name="attributes.ctable" type="string" default="calendar">
<cfparam name="mLink" type="numeric" default="0">
<!--- Determinar el tipo de acción que se debe realizar según el valor de la variable mLink --->
<cfif #mLink# is 0>
	<cfset Session.cMonth = Month(Now())>
	<cfset Session.cYear = Year(Now())>
	<cfset Session.nDays = DaysInMonth(Now())>
	<cfset Session.startDay = DayOfWeek(CreateDate(Session.cYear,Session.cMonth,1))>
<cfelseif #mLink# is 1>
	<cfset Session.cMonth = Session.cMonth-1>
	<cfif  Session.cMonth lt 1>
		<cfset Session.cYear = Session.cYear-1>
		<cfset Session.cMonth = 12>
	</cfif>
	<cfset Session.nDays = DaysInMonth(CreateDate(Session.cYear, Session.cMonth,1))>
	<cfset Session.startDay = DayOfWeek(CreateDate(Session.cYear, Session.cMonth,1))>
<cfelseif #mLink# is 2>
	<cfset Session.cMonth = Session.cMonth+1>
	<cfif  Session.cMonth GT 12>
		<cfset Session.cYear = Session.cYear+1>
		<cfset Session.cMonth = 1>
	</cfif>
	<cfset Session.nDays = DaysInMonth(CreateDate(Session.cYear, Session.cMonth,1))>
	<cfset Session.startDay = DayOfWeek(CreateDate(Session.cYear, Session.cMonth,1))>
</cfif>
<cfswitch expression = #Session.cMonth#>
<cfcase value="1,3,5,7,8,10,12">
	<cfset vLimiteDias = 32>
</cfcase>							<!---
							<a href="asuntos/sic_asuntos_index.cfm?modulo=AsuntosCAAA" target="_parent">Recomendaciones CAAA</a><br>
							<a href="asuntos/sic_asuntos_index.cfm?modulo=AsuntosCTIC" target="_parent">Decisiones CTIC</a>
							--->
<cfcase value="4,6,9,11">
	<cfset vLimiteDias = 31>
</cfcase>
<cfcase value="2">
	<cfset vLimiteDias = 29>
</cfcase>
</cfswitch>
<cfset pos = 1>

<div align="center">
	<cfoutput>
	<table border="0" width="100%">
		<!-- Nombre del mes y controles -->	
		<tr>
			<td colspan="7">
				<div align="center" class="Sans11NeNe">
					<table width="100%" border="0">
						<tr>
							<td width="36" bgcolor="##FFFFFF"><div align="center" class="Sans11NeNe"><img src="#vCarpetaIMG#/arrow_ln.gif" width="20" height="20" style="cursor:pointer;" border="0" onclick="fActualizarCalendario('1');"></div></td>
							<td width="175" bgcolor="##FFFFFF"><div align="center" class="Sans11NeNe">#Ucase(MonthAsString(Session.cMonth))# #Session.cYear#</div></td>
							<td width="37" bgcolor="##FFFFFF"><div align="center" class="Sans11NeNe"><img src="#vCarpetaIMG#/arrow_rn.gif" width="20" height="20" style="cursor:pointer;" border="0" onclick="fActualizarCalendario('2');"></div></td>
						</tr>
					</table>
				</div>
			</td>
		</tr>
		<!-- Nombres de los días de la semana -->
		<tr class="Sans11NeNe">
			<td width="36" height="20px"><div align="center">Dom</div></td>
			<td width="35"><div align="center">Lun</div></td>
			<td width="35"><div align="center">Mar</div></td>
			<td width="35"><div align="center">Mi&eacute;</div></td>
			<td width="35"><div align="center">Jue</div></td>
			<td width="35"><div align="center">Vie</div></td>
			<td width="37"><div align="center">S&aacute;b</div></td>
		</tr>
		<!-- Números del més -->		
		<tbody>
		<cfloop index ="i" from="1" to="6">
			<tr>
				<cfloop index ="j" from="1" to="7">
					<cfset theDay = pos - (Session.startDay-1)>
					<cftry>
						<cfset newDate = CreateODBCDate(CreateDate(Session.cYear, Session.cMonth, theDay))>
						<cfset trigger = 1>
						<cfcatch>
							<cfset trigger = 0>
						</cfcatch>
					</cftry>
					<cfif #theDay# GT 0 AND #theDay# LT #vLimiteDias#>
						<cfset vDiaHoy = LsDateFormat(#theDay# & "/" & #Session.cMonth# & "/" &#Session.cYear#, "dd/mm/yyyy")>
						<cfquery name="tbSesiones" datasource="#vOrigenDatosSAMAA#">
							SELECT ssn_fecha, ssn_id, ssn_clave 
                            FROM sesiones 
                            WHERE (year(ssn_fecha) = year('#vDiaHoy#') AND month(ssn_fecha) = month('#vDiaHoy#') AND day(ssn_fecha) = day('#vDiaHoy#'))
						</cfquery>   
                        <cfif #tbSesiones.RecordCount# GTE 1>
                            <cfif #tbSesiones.ssn_clave# EQ 1>
							    <cfset vBgrd = "5EBEFF">
                                <cfif #tbSesiones.RecordCount# EQ 1>
                                    <cfset vCssFont = "Sans11NeNe">
		    					    <cfset vSesionPlenoIndica = "Sesi&oacute;n Ordinaria del Pleno (" & #LsNumberFormat(tbSesiones.ssn_id,"9999")# & ") a partir de las " & #LsTimeFormat(tbSesiones.ssn_fecha,"HH:mm")# & " hrs.">
                                <cfelse>
                                    <cfset vCssFont = "Sans11ViNe">
                                    <cfset vSesionVig = #LsNumberFormat(tbSesiones.ssn_id,'9999')#>
                                	<cfloop query="tbSesiones" startrow="2">
		                                <cfset vSesionVig = "#vSesionVig# y " & #LsNumberFormat(tbSesiones.ssn_id,'9999')#>
	                                </cfloop>
							        <cfset vSesionPlenoIndica = "Sesi&oacute;n Ordinaria del Pleno (#vSesionVig#) a partir de las " & #LsTimeFormat(tbSesiones.ssn_fecha,"HH:mm")# & " hrs.">
                                </cfif>
                            <cfelseif #tbSesiones.ssn_clave# EQ 2>
    							<cfset vBgrd = "B3E0FF">
                                <cfset vCssFont = "Sans11NeNe">
		    					<cfset vSesionPlenoIndica = "Sesi&oacute;n Extraordinaria del Pleno a partir de las " & #LsTimeFormat(tbSesiones.ssn_fecha,"HH:mm")# & " hrs.">
                            <cfelseif #tbSesiones.ssn_clave# EQ 4>
    							<cfset vBgrd = "FF9900">
                                <cfset vCssFont = "Sans11NeNe">
		    					<cfset vSesionPlenoIndica = "Reuni&oacute;n de la CAAA: " & #LsNumberFormat(tbSesiones.ssn_id,"9999")#>                                
                            <cfelseif #tbSesiones.ssn_clave# EQ 5>
    							<cfset vBgrd = "CCCCCC">
                                <cfset vCssFont = "Sans11NeNe">
		    					<cfset vSesionPlenoIndica = "Recepci&oacute;n de documentos para sesi&oacute;n: " & #LsNumberFormat(tbSesiones.ssn_id,"9999")#>
    						<cfelse>
	    						<cfset vBgrd = "FCFAE9">
                                <cfset vCssFont = "Sans11Ne">
			    				<cfset vSesionPlenoIndica = "">
                            </cfif>
					    <cfelse>
    						<cfset vBgrd = "FCFAE9">
                            <cfset vCssFont = "Sans11Ne">
	    					<cfset vSesionPlenoIndica = "">
                        </cfif>
                    <cfelse>
    					<cfset vBgrd = "FFFFFF">
                        <cfset vCssFont = "Sans11Ne">
	    				<cfset vSesionPlenoIndica = "">
                    </cfif>
					<td width="35" height="20" align="center" valign="middle" bgcolor="#vBgrd#">
						<!-- If the date in the right range than it is dysplayed -->
						<cfif NOT (theDay LT 1 OR theDay GT Session.nDays)>
							<cfif trigger eq 1>
								<cfif #vSesionPlenoIndica# NEQ ''>
									<span class="#vCssFont#" title="#vSesionPlenoIndica#" style="cursor:pointer;">#theDay#</span>
								<cfelse>
									<span class="#vCssFont#" title="#vSesionPlenoIndica#">#theDay#</span>                                
								</cfif>
							</cfif>
							<!-- Otherwise, the hidden dash is inserted in order to dysplay the table borders correctly -->
						<cfelse>
							<span class="Sans11Ne">-</span>
						</cfif>
					</td>
					<cfset pos = pos + 1>
				</cfloop>
			</tr>
		</cfloop>
	</table>
	</cfoutput>
	<!-- Etiquetas -->
</div>
