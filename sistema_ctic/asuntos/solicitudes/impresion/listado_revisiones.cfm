<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA: 02/11/2009 --->
<!--- IMPRESION DE LA LISTA DE SOLICITUDES --->
<!--- Enviar el contenido a un archivo MS Word --->
<cfheader name="Content-Disposition" value="inline; filename=listado_ctic.doc">
<cfcontent type="application/msword">	
<!--- Parámetros de filtrado --->
<cfparam name="vFt" default="#Session.AsuntosRevisionFiltro.vFt#">
<cfparam name="vAcadNom" default="#Session.AsuntosRevisionFiltro.vAcadNom#">
<cfparam name="vDepId" default="#Session.AsuntosRevisionFiltro.vDepId#">
<cfparam name="vNumSol" default="#Session.AsuntosRevisionFiltro.vNumSol#">
<cfparam name="vOrden" default="#Session.AsuntosRevisionFiltro.vOrden#">
<cfparam name="vOrdenDir" default="#Session.AsuntosRevisionFiltro.vOrdenDir#">
<!--- Obtener datos de la sesión para los movimientos que inician un día después de ésta --->
<cfquery name="tbSesiones" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM sesiones WHERE ssn_clave = 1 AND ssn_id = #Session.sSesion#
</cfquery>
<html>
	<head>
		<title>STCTIC - Asuntos Acad&eacute;mico-Administrativos</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href="<cfoutput>#vCarpetaCSS#</cfoutput>/listados_v.css" rel="stylesheet" type="text/css">
	</head>
	<body>
		<!--- Obtener la lista de solicitudes enviadas por las entidades académicas del SIC --->
		<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
			SELECT * FROM ((movimientos_solicitud 
			LEFT JOIN catalogo_movimiento ON movimientos_solicitud.mov_clave = catalogo_movimiento.mov_clave) 
			LEFT JOIN catalogo_dependencia ON movimientos_solicitud.sol_pos1 = catalogo_dependencia.dep_clave)
			LEFT JOIN academicos ON movimientos_solicitud.sol_pos2 = academicos.acd_id
			WHERE sol_status = 3 <!--- Solicitudes enviadas --->
			AND ISNULL(sol_retirada,0) = 0
			<!--- Filtro por tipo de movimiento --->
			<cfif #Session.AsuntosRevisionFiltro.vFt# NEQ 0>
				AND 
		        <cfif #Session.AsuntosRevisionFiltro.vFt# EQ 100>
					(movimientos_solicitud.mov_clave <> 40 AND movimientos_solicitud.mov_clave <> 41)
		        <cfelseif #Session.AsuntosRevisionFiltro.vFt# EQ 101>
					(movimientos_solicitud.mov_clave = 40 OR movimientos_solicitud.mov_clave = 41)
		        <cfelse>
					movimientos_solicitud.mov_clave = #Session.AsuntosRevisionFiltro.vFt#
		        </cfif>
			</cfif>
			<!--- Filtro por académico --->
			<cfif #vAcadNom# IS NOT ''>AND ISNULL(acd_apepat,'') + ' ' + ISNULL(acd_apemat,'') + ' ' + ISNULL(acd_nombres,'') LIKE '%#vAcadNom#%'</cfif>
			<!--- Filtro por dependencia --->
			<cfif #Session.sTipoSistema# IS 'sic'>
				AND sol_pos1 = '#Session.sIdDep#'
			<cfelse>
				<cfif #vDepId# IS NOT ''>AND sol_pos1 = '#vDepId#'</cfif>
			</cfif>
			<!--- Filtro por número de solicitud --->
			<cfif #vNumSol# IS NOT ''>AND sol_id = #vNumSol#</cfif>
			<!--- Ordenamiento --->
			<cfif #vOrden# IS NOT ''> ORDER BY #vOrden# </cfif><cfif #vOrdenDir# IS NOT ''> #vOrdenDir#</cfif>
		</cfquery>
		<!---
		<!--- Titulo de la página --->
		<center>
			<span style="font-size:10pt;">
				<br>
				<b>CONSEJO T&Eacute;CNICO DE LA INVESTIGACI&Oacute;N CIENT&Iacute;FICA</b>
				<br>
				<b><cfoutput>#Session.sDep#</cfoutput></b>
				<br>
				<i>LISTA DE SOLICITUDES</i>
				<br>
				<br>
			</span>
		</center>
		--->
		<!-- Tabla de datos -->
		<table border="0" cellspacing="1" cellpadding="1" style="page:horizontal; width:100%;">
			<!-- Titulo -->
			<tr>
				<td class="Sans10GrNe" colspan="3">
					SOLICITUDES ENVIADAS POR LAS ENTIDADES
				</td>
				<td class="Sans10GrNe" colspan="2" align="right">
					HASTA EL <cfoutput>#Ucase(FechaCompleta(tbSesiones.ssn_fecha))#</cfoutput>
				</td>
			</tr>
			<!-- Línea -->
			<tr><td colspan="5"><hr class="doble"></td></tr>
			<!-- Encabezados -->
			<tr valign="middle">
				<td class="Sans9GrNe" width="5%">No.</td>
				<td class="Sans9GrNe" width="8%">Entidad</td>
				<td class="Sans9GrNe">Nombre</td>
				<td class="Sans9GrNe">Asunto</td>
				<td class="Sans9GrNe" width="8%">Fecha</td>
			</tr>
			<!-- Línea -->
			<tr><td colspan="5"><hr></td></tr>
			<!-- Datos -->
			<cfoutput query="tbSolicitudes"> 	
				<tr>
					<td class="Sans9Gr">#tbSolicitudes.sol_id#</td>
					<td class="Sans9Gr">#tbSolicitudes.dep_siglas#</td>
					<td class="Sans9Gr">#Trim(tbSolicitudes.acd_apepat)# #Trim(tbSolicitudes.acd_apemat)# #Trim(PrimeraPalabra(tbSolicitudes.acd_nombres))#</td>
					<td class="Sans9Gr">#Ucase(tbSolicitudes.mov_titulo_corto)#</td>
					<!--- Fecha de inicio del movimiento --->
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
				</tr>
			</cfoutput>
		</table>
	</body>
</html>
