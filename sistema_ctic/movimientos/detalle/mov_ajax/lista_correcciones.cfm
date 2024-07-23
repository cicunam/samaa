<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA: 26/01/2010--->
<!--- AJAX PARA LISTAR LA HISTORIA DE UN ASUNTO --->
<!--- Base de datos para seleccionar destinos de una comisión --->
<cfquery name="tbCorrecciones" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM movimientos_asunto 
	INNER JOIN movimientos_correccion 
	ON movimientos_asunto.sol_id = movimientos_correccion.sol_id
	WHERE asu_reunion = 'CTIC' 
	AND  co_tipo = 'DICE' 
	AND movimientos_correccion.mov_id = #vIdMov#
	AND ssn_id < #Session.sSesion#
</cfquery>
<!--- Lista de correcciones --->
<cfif #tbCorrecciones.Recordcount# GT 0>
	<table width="100%" border="0" cellpadding="0" align="center">
		<!-- Encabezados -->
		<tr>
			<td class="Sans9GrNe">Sesi&oacute;n</td>
			<td class="Sans9GrNe">Campo</td>
			<td class="Sans9GrNe">Decia</td>
			<td class="Sans9GrNe">Oficio</td>
			<td><!--- PDF ---></td>
		</tr>
		<cfoutput query="tbCorrecciones">
			<tr>
				<!-- Sesión -->
				<td class="Sans9Gr">#tbCorrecciones.ssn_id#</td>
				<!-- Dato que se modificó -->
				<td class="Sans9Gr">#tbCorrecciones.co_campo#</td>
				<!-- Descripción del cambio -->
				<td class="Sans9Gr">
					<cfif #tbCorrecciones.co_campo# IS 'NOMBRE'>
						#tbCorrecciones.co_nombres# #tbCorrecciones.co_apepat# #tbCorrecciones.co_apemat#
					<cfelseif #tbCorrecciones.co_campo# IS 'DURACION'>	
						<cfif #tbCorrecciones.co_fecha_final# EQ ''>
							<cfif #vMov# EQ 22>
								Diferir de la fecha #LsDateFormat(tbCorrecciones.co_fecha_inicio,'dd/mm/yyyy')#
							<cfelse>
								A partir del #LsDateFormat(tbCorrecciones.co_fecha_inicio,'dd/mm/yyyy')#
							</cfif>
						<cfelse>
							<cfif #vMov# NEQ 22>
								<!--- Desglosar el periodo en años, meses y días --->
								<cfset vFF = #dateadd('d',1,tbCorrecciones.co_fecha_final)#>
								<cfset vF1 = #tbCorrecciones.co_fecha_inicio#>
								<cfset vAnios = #DateDiff('yyyy',#vF1#, #vFF#)#>
								<cfset vF2 = #dateadd('yyyy',vAnios,vF1)#>
								<cfset vMeses = #DateDiff('m',#vF2#, #vFF#)#>
								<cfset vF3 = #dateadd('m',vMeses,vF2)#>			
								<cfset vDias = #DateDiff('d',#vF3#, #vFF#)#>
								<cfif #vAnios# GT 0>#vAnios# año </cfif>
								<cfif #vMeses# GT 0>#vMeses# <cfif #vMeses# EQ 1>mes<cfelse>meses</cfif></cfif>
								<cfif #vDias# GT 0>#vDias# <cfif #vDias# EQ 1>día<cfelse>días</cfif></cfif>
							</cfif>
							<cfif #vMov# EQ 22> 
								Diferir del #LsDateFormat(tbCorrecciones.co_fecha_inicio,'dd/mm/yyyy')# 
							<cfelse> 
								del #LsDateFormat(tbCorrecciones.co_fecha_inicio,'dd/mm/yyyy')#
							</cfif>
							al #LsDateFormat(tbCorrecciones.co_fecha_final,'dd/mm/yyyy')#
						</cfif>
					<cfelse>
						#tbCorrecciones.co_texto#
					</cfif>
				</td>
				<!-- Oficio -->
				<td class="Sans9Gr">#tbCorrecciones.asu_oficio#</td>
				<!--- Archivo PDF relacionado --->
				<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
					SELECT * FROM movimientos_solicitud_historia WHERE sol_id = #tbCorrecciones.sol_id#
				</cfquery>
				<cfset vArchivoPdf = #tbSolicitudes.sol_pos2# & '_' & #tbSolicitudes.sol_id# & '_' & #tbCorrecciones.ssn_id# & '.pdf'>
				<cfset vArchivoSolicitudPdf = #vCarpetaAcademicos# & #vArchivoPdf#>
				<cfset vArchivoSolicitudPdfWeb = #vWebAcademicos# & #vArchivoPdf#>
				<td>
					<cfif FileExists(#vArchivoSolicitudPdf#)>
						<a id="LigaArchivoPDF" href="#vArchivoSolicitudPdfWeb#" target="_blank">
							<img src="#vCarpetaICONO#/pdf_icon_2017.png" width="15" style="border:none; cursor:pointer;" title="Archivo PDF disponible">
						</a>
					</cfif>	
				</td>
			</tr>
		</cfoutput>
	</table>
<cfelse>
	<br>
</cfif>