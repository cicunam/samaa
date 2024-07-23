<!--- CREADO: ARAM PICHARDO--->
<!--- EDITO: ARAM PICHARDO--->
<!--- FECHA: 06/05/2009--->
<!--- LISTAR LOS ASUNTOS ACADÉMICO-ADMINISTRATIVOS DE UN ACADÉMICO (PARA RECORSOS DE REVISIÓN, RECURSOS DE RECONSIDERACIÓN Y CORRECCIONES A OFICIOS) --->
<!--- Obtener el tipo del año o semestre sabático que se va a modificar --->
<cfparam name="vIdAcad" default=1931>
<cfparam name="vFt" default=5>
<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM ((movimientos_solicitud 
	LEFT JOIN catalogo_movimiento ON movimientos_solicitud.mov_clave = catalogo_movimiento.mov_clave) 
	LEFT JOIN catalogo_dependencia ON movimientos_solicitud.sol_pos1 = catalogo_dependencia.dep_clave)
	LEFT JOIN academicos ON movimientos_solicitud.sol_pos2 = academicos.acd_id
	WHERE movimientos_solicitud.mov_clave = #vFt# AND movimientos_solicitud.sol_pos2 = #vIdAcad# AND movimientos_solicitud.sol_status > 0
    ORDER BY movimientos_solicitud.cap_fecha_crea DESC
</cfquery>

<cfif #tbSolicitudes.RecordCount# GT 0>
	<cfif #tbSolicitudes.sol_status# IS 4><cfset vStatusDuplicado = "EN CAPTURA">
	<cfelseif #tbSolicitudes.sol_status# IS 3><cfset vStatusDuplicado = "ENVIADA">
	<cfelseif #tbSolicitudes.sol_status# IS 2 OR #tbSolicitudes.sol_status# IS 1><cfset vStatusDuplicado = "EN PROCESO">
	</cfif>

	<cfoutput>
	<cfset vTextoConfirm = "Se encontró otra solicitud " & #UCASE(tbSolicitudes.mov_noft)# & " con no. " & #tbSolicitudes.sol_id#  & " de " & #Trim(tbSolicitudes.acd_apepat)# & " " & #Trim(tbSolicitudes.acd_apemat)# & " " & #Trim(tbSolicitudes.acd_nombres)# & ",">
	<cfset vTextoConfirm2 = "capturada el " & #LsDateFormat(tbSolicitudes.cap_fecha_mod,'dd/mm/yyyy')# & ", y status " & #vStatusDuplicado#>

	<input type="hidden" name="vResConf" id="vResConf" value="#vTextoConfirm#">
	<input type="hidden" name="vResConf2" id="vResConf2" value="#vTextoConfirm2#">
	</cfoutput>
	<!-- MOVIMIENTOS EN MODO TABLA -->
<!---
	<table style="width:800px; margin: 10px 0px 10px 15px; border: none" cellspacing="0" cellpadding="1">
		<!-- Encabezados -->
		<cfoutput>
		<tr valign="middle" bgcolor="##CCCCCC">
			<td><span class="Sans9GrNe">No.</span></td>
			<td>Nombre</span></td>
			<td><span class="Sans9GrNe">Asunto</span></td>
			<td><span class="Sans9GrNe">Fecha</span></td>
			<td class="Sans9GrNe">Status</td>
		  </tr>
		</cfoutput>
		<!-- Datos -->
		<cfoutput query="tbSolicitudes"> 			
		<!--- Crea variable de archivo de solicitud --->
		<cfset vArchivoPdf = #tbSolicitudes.sol_pos2# & '_' & #tbSolicitudes.sol_id# & '.pdf'>
		<cfset vArchivoSolicitudPdf = #vCarpetaENTIDAD# & #MID(tbSolicitudes.sol_pos1,1,4)# & '\' & #vArchivoPdf#>			
		<cfset vArchivoSolicitudPdfWeb = #vWebENTIDAD# & #MID(tbSolicitudes.sol_pos1,1,4)# & '\' & #vArchivoPdf#>
		<tr onMouseOver="this.style.backgroundColor='##E8E8E8'" onMouseOut="this.style.backgroundColor='##FFFFFF'">
			<td class="Sans9Gr">#tbSolicitudes.sol_id#</td>
			<td class="Sans9Gr">#Trim(tbSolicitudes.acd_apepat)# #Trim(tbSolicitudes.acd_apemat)# #Trim(tbSolicitudes.acd_nombres)#</td>
			<td class="Sans9Gr">#Ucase(tbSolicitudes.mov_titulo_corto)#</td>
			<td class="Sans9Gr">#LSDateFormat(tbSolicitudes.cap_fecha_mod,'DD/MM/YYYY')#</td>
			<td>
				<span class="Sans9Gr">
				<cfif #tbSolicitudes.sol_status# IS 4>EN CAPTURA
				<cfelseif #tbSolicitudes.sol_status# IS 3>ENVIADA
				<cfelseif #tbSolicitudes.sol_status# IS 2 OR #tbSolicitudes.sol_status# IS 1>EN PROCESO
				</cfif>
				</span>
			</td>
		  </tr>
		</cfoutput>
	</table>
--->
	
</cfif>
