<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA: 02/11/2009 --->
<!--- IMPRESION DE LA LISTA DE SOLICITUDES --->


<!--- Obtener el nombre del secretario académico para firma --->
<cfinclude template="#vCarpetaCOMUN#/include_firma_docs.cfm">

<!---
<!--- Obtener el nombre del secretario académico --->
<cfquery name="tbFirma" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM academicos AS T1
	LEFT JOIN academicos_cargos AS T2 ON T1.acd_id = T2.acd_id
	WHERE 1 = 1
	<cfif #Session.sIdDep# EQ '030101' OR #Session.sIdDep# EQ '034201' OR #Session.sIdDep# EQ '034301' OR #Session.sIdDep# EQ '034401' OR #Session.sIdDep# EQ '034501'>
        AND T2.dep_clave = '030101'
        AND T2.adm_clave = 100 <!--- SE CAMBIÓ LA FIRMA DEL COORDINADOR POR EL SECRETARIO DE INVESTIGACIÓN Y DESARROLLO 03/04/2018 --->
    <cfelse>
        AND T2.dep_clave = '#Session.sIdDep#' 
        AND T2.adm_clave = 82
        AND T2.caa_fecha_inicio <= GETDATE()
	</cfif>
	AND T2.caa_status = 'A'
</cfquery>
--->

<!--- Enviar el contenido a un archivo PDF --->
<cfdocument format="PDF" fontembed="yes" orientation="portrait" pagetype="letter" margintop="1.5" unit="cm">		
	<!--- Parámetros de filtrado --->
	<cfparam name="vFt" default="#Session.AsuntosSolicitudFiltro.vFt#">
	<cfparam name="vAcadNom" default="#Session.AsuntosSolicitudFiltro.vAcadNom#">
	<cfparam name="vNumSol" default="#Session.AsuntosSolicitudFiltro.vNumSol#">
	<cfparam name="vOrden" default="#Session.AsuntosSolicitudFiltro.vOrden#">
	<cfparam name="vOrdenDir" default="#Session.AsuntosSolicitudFiltro.vOrdenDir#">
	<cfparam name="vStatus" default="#Session.AsuntosSolicitudFiltro.vStatus#">
	<!--- Obtener datos de la sesión para los movimientos que inician un día después de ésta --->
	<cfquery name="tbSesiones" datasource="#vOrigenDatosSAMAA#">
		SELECT * FROM sesiones 
        WHERE ssn_clave = 1 
        AND ssn_id = #Session.sSesion#
	</cfquery>
	<html>
		<head>
			<title>STCTIC - Asuntos Acad&eacute;mico-Administrativos</title>
			<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
			<link href="<cfoutput>#vCarpetaCSS#</cfoutput>/listados_lyc.css" rel="stylesheet" type="text/css">
		</head>
		<body>
			<!--- Obtener la lista de solicitudes de la entidad --->
			<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
				SELECT * FROM ((movimientos_solicitud 
				LEFT JOIN catalogo_movimiento ON movimientos_solicitud.mov_clave = catalogo_movimiento.mov_clave) 
				LEFT JOIN catalogo_dependencia ON movimientos_solicitud.sol_pos1 = catalogo_dependencia.dep_clave)
				LEFT JOIN academicos ON movimientos_solicitud.sol_pos2 = academicos.acd_id
				<!--- Filtro --->
				WHERE sol_pos1 = '#Session.sIdDep#'
				AND sol_status = 3
				AND movimientos_solicitud.mov_clave = 38 <!--- Solo --->
				<!--- Ordenamiento --->
				ORDER BY acd_apepat, acd_apemat, acd_nombres, movimientos_solicitud.mov_clave, sol_pos14
			</cfquery>
			<!--- Encabezado --->
			<link href="<cfoutput>#vCarpetaCSS#</cfoutput>/listados_lyc.css" rel="stylesheet" type="text/css">
			<!-- Titulo da la página --->
			<center>
				<b>CONSEJO T&Eacute;CNICO DE LA INVESTIGACI&Oacute;N CIENT&Iacute;FICA</b><br>
				<span style="font-size:8pt;"></span>ACUSE DE SOLICITUDES DE BECAS POSDOCTORALES ENVIADAS</span><br>
				<cfif #Session.sTipoSistema# IS 'sic'>
					<br><i><cfoutput>#Session.sDep#</cfoutput></i>
				</cfif>
				<br><br>
			</center>
			<!-- Encabezados de las columnas -->
			<table border="0" cellspacing="1" cellpadding="1" style="width:100%;">
				<!-- Encabezados -->
				<tr valign="middle">
					<td><b>No.</b></td>
					<td><b>NOMBRE</b></td>
					<td><b>ASUNTO</b></td>
					<td><b>INICIO</b></td>
					<td><b>T&Eacute;RMINO</b></td>
				</tr>
				<!-- Línea -->
				<tr><td colspan="5"><hr></td></tr>
				<!-- Tabla de datos -->
				<cfoutput query="tbSolicitudes"> 	
					<tr>
						<td class="Sans9Gr">#tbSolicitudes.sol_id#</td>
						<td class="Sans9Gr">#Trim(tbSolicitudes.acd_apepat)# #Trim(tbSolicitudes.acd_apemat)# #Trim(PrimeraPalabra(tbSolicitudes.acd_nombres))#</td>
						<td class="Sans9Gr">#Ucase(tbSolicitudes.mov_titulo_corto)#</td>
						<!-- Fecha de inicio -->
						<td class="Sans9Gr">
							<cfif #tbSolicitudes.mov_clave# IS 5 OR #tbSolicitudes.mov_clave# IS 7 OR #tbSolicitudes.mov_clave# IS 8 OR #tbSolicitudes.mov_clave# IS 9 OR #tbSolicitudes.mov_clave# IS 10 OR #tbSolicitudes.mov_clave# IS 17 OR #tbSolicitudes.mov_clave# IS 18 OR #tbSolicitudes.mov_clave# IS 19 OR #tbSolicitudes.mov_clave# IS 28><!--- Si es un movimiento que inicia un día un día despues de la reunión de pleno --->
								<cfif #tbSesiones.ssn_fecha_m# IS ''><!--- Si no cambió la fecha de la sesión --->
									#LsDateFormat(DateAdd("d",1,tbSesiones.ssn_fecha),"dd/mm/yyyy")#
								<cfelse>		
									 #LsDateFormat(DateAdd("d",1,tbSesiones.ssn_fecha_m),"dd/mm/yyyy")#
								</cfif>	 
							<cfelseif #tbSolicitudes.sol_pos14# IS NOT ''><!--- Si el campo no está vacío --->
								#LsDateFormat(tbSolicitudes.sol_pos14,"dd/mm/yyyy")#
							</cfif>
						</td>
						<!-- Fecha de término -->
						<td class="Sans9Gr">
							<cfif #tbSolicitudes.mov_clave# IS 5 OR (#tbSolicitudes.mov_clave# IS 17 AND #tbSolicitudes.sol_pos5# NEQ 1)><!--- Si es un movimiento que inicia un día un día despues de la reunión de pleno --->
								<cfif #tbSesiones.ssn_fecha_m# IS ''><!--- Si no cambió la fecha de la sesión --->
									<cfset FF = #DateAdd("d",1,tbSesiones.ssn_fecha)#>
									<cfset FF = #DateAdd("yyyy",1,FF)#>
									#LsDateFormat(FF,"dd/mm/yyyy")#
								<cfelse>		
									<cfset FF = #DateAdd("d",1,tbSesiones.ssn_fecha_m)#>
									<cfset FF = #DateAdd("yyyy",1,FF)#>
									#LsDateFormat(FF,"dd/mm/yyyy")#
								</cfif>	 
							<cfelseif #tbSolicitudes.sol_pos15# IS NOT ''><!--- Si el campo no está vacío --->
								#LsDateFormat(tbSolicitudes.sol_pos15,"dd/mm/yyyy")#
							</cfif>
						</td>
					</tr>
				</cfoutput>
			</table>
			<!--- Espacio para el nombre y la firma del responsable --->
			<div style="bottom:1cm; width:100%;">
				<br><br><br><br><br>
				<table border="0" style="width:100%; font-size:7pt;">
					<tr>
						<td style="width:100%; text-align:center;">
							<hr width="50%">
						</td>
					</tr>
					<tr>
						<td style="width:100%; text-align:center;">
							<cfoutput>#tbFirma.acd_prefijo# #tbFirma.acd_nombres# #tbFirma.acd_apepat# #tbFirma.acd_apemat#</cfoutput>
						</td>
					</tr>
				</table>
			</div>
			<!--- Pie de página --->
			<cfdocumentitem type="footer">
				<table width="100%">
					<tr>
						<td align="left" style="font-family:sans-serif; font-size:7pt; font-weight:normal;"><cfoutput>#FechaCompleta(Now())#</cfoutput></td>	
						<td align="right" style="font-family:sans-serif; font-size:7pt; font-weight:normal;"><cfoutput>P&aacute;gina #cfdocument.currentpagenumber# de #cfdocument.totalpagecount#</cfoutput></td>
					</tr>
				</table>		
			</cfdocumentitem>
		</body>
	</html>
</cfdocument>