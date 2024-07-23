<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA: 02/11/2009 --->
<!--- IMPRESION DE LA LISTA DE SOLICITUDES --->
<!--- Enviar el contenido a un archivo PDF --->
<cfdocument format="PDF" fontembed="yes" orientation="portrait" pagetype="letter" margintop="3.1" unit="cm" backgroundvisible="yes">		
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
			<style type="text/css">
				body {
					background-image:url(<cfoutput>#vCarpetaIMG#/iUsoInterno.gif</cfoutput>);
					background-position: center; 
				}
			</style>
		</head>
		<body>
			<!--- Obtener la lista de solicitudes de la entidad --->
			<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
				SELECT * FROM ((movimientos_solicitud 
				LEFT JOIN catalogo_movimiento ON movimientos_solicitud.mov_clave = catalogo_movimiento.mov_clave) 
				LEFT JOIN catalogo_dependencia ON movimientos_solicitud.sol_pos1 = catalogo_dependencia.dep_clave)
				LEFT JOIN academicos ON movimientos_solicitud.sol_pos2 = academicos.acd_id
				WHERE sol_pos1 = '#Session.sIdDep#'
				AND ISNULL(sol_retirada,0) = 0
				<!--- Filtro por tipo de movimiento --->
				<cfif #Session.AsuntosSolicitudFiltro.vFt# NEQ 0>
					AND 
			        <cfif #Session.AsuntosSolicitudFiltro.vFt# EQ 100>
						(movimientos_solicitud.mov_clave <> 40 AND movimientos_solicitud.mov_clave <> 41)
			        <cfelseif #Session.AsuntosSolicitudFiltro.vFt# EQ 101>
						(movimientos_solicitud.mov_clave = 40 OR movimientos_solicitud.mov_clave = 41)
			        <cfelse>
						movimientos_solicitud.mov_clave = #Session.AsuntosSolicitudFiltro.vFt#
			        </cfif>
				</cfif>
				<!--- Filtro por académico --->
				<cfif #vAcadNom# IS NOT ''>AND ISNULL(acd_apepat,'') + ' ' + ISNULL(acd_apemat,'') + ' ' + ISNULL(acd_nombres,'') LIKE '%#vAcadNom#%'</cfif>
				<!--- Filtro por número de solicitud --->
				<cfif #vNumSol# IS NOT ''>AND sol_id = #vNumSol#</cfif>
				<!--- Filtro por status de la solicitud --->
				<cfif #vStatus# IS NOT ''>
			    	AND (
					<cfset vActivaOr = FALSE>
					<cfif Find('C','#vStatus#')>
						<cfif vActivaOr IS TRUE> OR </cfif>
							(movimientos_solicitud.sol_status = 4 AND movimientos_solicitud.sol_devuelta = 0)
						<cfset vActivaOr = TRUE>
					</cfif>	
					<cfif Find('D','#vStatus#')>
						<cfif vActivaOr IS TRUE> OR </cfif>
							(movimientos_solicitud.sol_status = 4 AND movimientos_solicitud.sol_devuelta = 1)
						<cfset vActivaOr = TRUE>	
					</cfif>
					<cfif Find('E','#vStatus#')>
						<cfif vActivaOr IS TRUE> OR </cfif>
							movimientos_solicitud.sol_status = 3
						<cfset vActivaOr = TRUE>
					</cfif>
					<cfif Find('P','#vStatus#')>
						<cfif vActivaOr IS TRUE> OR </cfif>
							(movimientos_solicitud.sol_status = 2 OR movimientos_solicitud.sol_status = 1)
						<cfset vActivaOr = TRUE>		
					</cfif>
					<cfif Find('R','#vStatus#')>
						<cfif vActivaOr IS TRUE> OR </cfif>
							movimientos_solicitud.sol_status = 0
						<cfset vActivaOr = TRUE>		
					</cfif>
					)
				<cfelse>
					AND 1=0	
				</cfif>
				<!--- Ordenamiento --->
				<cfif #vOrden# IS NOT ''>ORDER BY #vOrden#</cfif>
				<cfif #vOrdenDir# IS NOT ''>#vOrdenDir# </cfif>
			</cfquery>
			<!--- Encabezado --->
			<cfdocumentitem type="header">
				<link href="<cfoutput>#vCarpetaCSS#</cfoutput>/listados_lyc.css" rel="stylesheet" type="text/css">
				<!-- Titulo da la página --->
				<center>
					<span style="font-size:9pt;">
						<br>
						<b>CONSEJO T&Eacute;CNICO DE LA INVESTIGACI&Oacute;N CIENT&Iacute;FICA</b>
						<br>
						<b><cfoutput>#Session.sDep#</cfoutput></b>
						<br><br>
						<i>LISTA DE SOLICITUDES</i>
						<br>
						<br>
					</span>
				</center>
				<!-- Encabezados de las columnas -->
				<table border="0" cellspacing="1" cellpadding="1" style="width:100%;">
					<!-- Línea -->
					<tr><td colspan="5"><hr class="doble"></td></tr>
					<!-- Encabezados -->
					<tr valign="middle">
						<td class="Sans9GrNe" width="50">No.</td>
						<td class="Sans9GrNe">Nombre</td>
						<td class="Sans9GrNe" width="220">Asunto</td>
						<td class="Sans9GrNe" width="80">Fecha</td>
						<td class="Sans9GrNe" width="80">Status</td>
					</tr>
					<!-- Línea -->
					<tr><td colspan="5"><hr class="doble"></td></tr>
				</table>
			</cfdocumentitem>
			<!-- Tabla de datos -->
			<table border="0" cellspacing="1" cellpadding="1" style="width:100%;">
				<cfoutput query="tbSolicitudes"> 	
					<tr>
						<td class="Sans9Gr" width="50">#tbSolicitudes.sol_id#</td>
						<td class="Sans9Gr">#Trim(tbSolicitudes.acd_apepat)# #Trim(tbSolicitudes.acd_apemat)# #Trim(PrimeraPalabra(tbSolicitudes.acd_nombres))#</td>
						<td class="Sans9Gr" width="220">#Ucase(tbSolicitudes.mov_titulo_corto)#</td>
						<!-- Fecha de inicio del movimiento -->
						<td class="Sans9Gr" width="80">
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
						<!-- Status de la solicitud -->
						<td width="80">
							<cfif #tbSolicitudes.sol_status# IS 4>
								<cfif #tbSolicitudes.sol_devuelta# IS 1>
									<span class="Sans9Vi">DEVUELTA</span>
								<cfelse>
									<span class="Sans9Gr">EN CAPTURA</span>
								</cfif>
							<cfelseif #tbSolicitudes.sol_status# IS 3>
								<span class="Sans9Gr">ENVIADA</span>
							<cfelseif #tbSolicitudes.sol_status# IS 2 OR #tbSolicitudes.sol_status# IS 1>
								<span class="Sans9Gr">EN PROCESO</span>
							<cfelseif #tbSolicitudes.sol_status# IS 0>
								<span class="Sans9GrNe">RESUELTO</span>
							</cfif>
						</td>
					</tr>
				</cfoutput>
			</table>
			<br><br><br>
			<p style="font-family:sans-serif; font-size:9px; color:#990000; font-weight:bold; text-align:center;">
				Este listado es para uso exclusivo de la entidad. La Secretar&iacute;a T&eacute;cnica del CTIC no lo recibirá como acuse de recibo.
			</p>
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