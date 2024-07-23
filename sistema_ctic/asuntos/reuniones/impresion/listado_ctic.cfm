<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 02/11/2009 --->
<!--- FECHA ÚLTIMA MOD.: 30/04/2019 --->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<!--- IMPRESION DE LA LISTA DE ASUNTOS QUE PASAN AL PLENO --->
<!--- Enviar el contenido a un archivo MS Word --->
<cfheader name="Content-Disposition" value="inline; filename=listado_pleno_ctic_#vActa#.doc">
<cfcontent type="application/msword; charset=utf-8"><!--- iso-8859-1 --->
<!--- Incluir las funciones para generar el detalle de los asuntos y otros --->
<cfinclude template="detalle_asuntos.cfm">
<cfinclude template="detalle_asuntos_rel.cfm">
<!--- Obtener información del periodo de sesión --->
<cfquery name="tbSesiones" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM sesiones 
	WHERE ssn_id = #vActa# 
	AND ssn_clave = 1
</cfquery>
<html>
	<head>
		<title>STCTIC - Asuntos Acad&eacute;mico-Administrativos</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"><!--- iso-8859-1 --->
		<link href="<cfoutput>#vCarpetaCSS#</cfoutput>/listados.css" rel="stylesheet" type="text/css">
	</head>
	<body>
		<!--- SECCION I --->
		<cfif #vSeccion# IS 1>
			<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
				SELECT *
				FROM consulta_solicitudes_listados
				WHERE sol_status <= 1 <!--- Asuntos que pasan al pleno y asuntos resueltos --->
				AND asu_reunion = 'CTIC' <!--- Registro de asunto CTIC --->
				AND ssn_id = #vActa# <!--- Del acta seleccionada --->
				AND asu_parte = 1 <!--- Solo incluir los asuntos de la sección I --->
				ORDER BY
				asu_parte,
				asu_numero
<!---            
				SELECT *,
				(
					ISNULL(dbo.SINACENTOS(acd_apepat),'') + 
					CASE WHEN acd_apepat IS NULL THEN '' ELSE ' ' END + 
					ISNULL(dbo.SINACENTOS(acd_apemat),'') + 
					CASE WHEN acd_apemat IS NULL THEN '' ELSE ' ' END + 
					ISNULL(dbo.SINACENTOS(acd_nombres),'')
				) AS nombre_comp
				FROM (((movimientos_solicitud
				LEFT JOIN movimientos_asunto ON movimientos_solicitud.sol_id = movimientos_asunto.sol_id)
				LEFT JOIN academicos ON movimientos_solicitud.sol_pos2 = academicos.acd_id)
				LEFT JOIN catalogo_movimiento ON movimientos_solicitud.mov_clave = catalogo_movimiento.mov_clave)
				LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C2 ON movimientos_solicitud.sol_pos1 = C2.dep_clave <!---CATALOGOS GENERALES MYSQL --->
				WHERE sol_status <= 1 <!--- Asuntos que pasan al pleno y asuntos resueltos --->
				AND movimientos_asunto.asu_reunion = 'CTIC' <!--- Registro de asunto CTIC --->
				AND movimientos_asunto.ssn_id = #vActa# <!--- Del acta seleccionada --->
				AND movimientos_asunto.asu_parte = 1 <!--- Solo incluir los asuntos de la sección I --->
				ORDER BY
				movimientos_asunto.asu_parte,
				movimientos_asunto.asu_numero
--->				
			</cfquery>
			<!--- Lista de asuntos --->
			<cfoutput query="tbSolicitudes" group="asu_parte">
				<!--- Obtener el nombre de la parte actual del listado (MOVERLO AL SQL) --->
				<cfquery name="ctListado" datasource="#vOrigenDatosSAMAA#">
					SELECT * FROM catalogo_listado WHERE parte_numero = #tbSolicitudes.asu_parte#
				</cfquery>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" style="page:vertical;">
					<!--- Encabezado --->
					<cfinclude template="detalle_encabezado.cfm">
					<!--- Agrupación por dependencia --->
					<cfoutput group="dep_orden">
						<tr>
							<td colspan="3">#UCase(tbSolicitudes.dep_nombre)#</td>
						</tr>
						<!--- División --->
						<tr><td colspan="3" height="10"></td></tr>
						<!--- Asuntos a considerar --->
						<cfoutput>
							#DetalleAsunto(tbSolicitudes)#
						</cfoutput>
					</cfoutput>
				</table>
				<p style="page-break-after:always"><br></p>
			</cfoutput>
		</cfif>
		<!--- SECCION II --->
		<cfif #vSeccion# IS 2>
			<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
				SELECT *
				FROM consulta_solicitudes_listados
				WHERE sol_status <= 1 <!--- Asuntos que pasan al pleno y asuntos resueltos --->
				AND asu_reunion = 'CTIC' <!--- Registro de asunto CTIC --->
				AND ssn_id = #vActa# <!--- Del acta seleccionada --->
				AND asu_parte > 1 AND asu_parte < 3 <!--- Solo incluir los asuntos de la Sección II --->
				<!--- NOTA: Los asuntos no deben ordenarse por número de asunto sino por entidad, nombre y fecha --->
				ORDER BY
				asu_parte,
				C2.dep_orden,
				acd_apepat,
				acd_apemat,
				acd_nombres,
				sol_pos14
<!---
				SELECT *,
				(
					ISNULL(dbo.SINACENTOS(acd_apepat),'') + 
					CASE WHEN acd_apepat IS NULL THEN '' ELSE ' ' END + 
					ISNULL(dbo.SINACENTOS(acd_apemat),'') + 
					CASE WHEN acd_apemat IS NULL THEN '' ELSE ' ' END + 
					ISNULL(dbo.SINACENTOS(acd_nombres),'')
				) AS nombre_comp                
				FROM (((movimientos_solicitud
				LEFT JOIN movimientos_asunto ON movimientos_solicitud.sol_id = movimientos_asunto.sol_id)
				LEFT JOIN academicos ON movimientos_solicitud.sol_pos2 = academicos.acd_id)
				LEFT JOIN catalogo_movimiento ON movimientos_solicitud.mov_clave = catalogo_movimiento.mov_clave)
				LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C2 ON movimientos_solicitud.sol_pos1 = C2.dep_clave <!---CATALOGOS GENERALES MYSQL --->
				WHERE sol_status <= 1 <!--- Asuntos que pasan al pleno y asuntos resueltos --->
				AND movimientos_asunto.asu_reunion = 'CTIC' <!--- Registro de asunto CTIC --->
				AND movimientos_asunto.ssn_id = #vActa# <!--- Del acta seleccionada --->
				AND movimientos_asunto.asu_parte > 1 AND movimientos_asunto.asu_parte < 3 <!--- Solo incluir los asuntos de la Sección II --->
				<!--- NOTA: Los asuntos no deben ordenarse por número de asunto sino por entidad, nombre y fecha --->
				ORDER BY
				movimientos_asunto.asu_parte,
				C2.dep_orden,
				academicos.acd_apepat,
				academicos.acd_apemat,
				academicos.acd_nombres,
				movimientos_solicitud.sol_pos14
--->				
			</cfquery>
			<!--- Lista de asuntos --->
			<cfoutput query="tbSolicitudes" group="asu_parte">
				<!--- Obtener el nombre de la parte actual del listado (MOVERLO AL SQL) --->
				<cfquery name="ctListado" datasource="#vOrigenDatosSAMAA#">
					SELECT * FROM catalogo_listado WHERE parte_numero = #tbSolicitudes.asu_parte#
				</cfquery>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" style="page:vertical;">
					<!--- Encabezado --->
					<cfinclude template="detalle_encabezado.cfm">
					<!--- Agrupación por dependencia --->
					<cfoutput group="dep_orden">
						<tr>
							<td colspan="3">#UCase(tbSolicitudes.dep_nombre)#</td>
						</tr>
						<!--- División --->
						<tr><td colspan="3" height="10"></td></tr>
						<!--- Asuntos a considerar --->
						<cfoutput>
							#DetalleAsunto(tbSolicitudes)#
						</cfoutput>
					</cfoutput>
				</table>
				<p style="page-break-after:always"><br></p>
			</cfoutput>
		</cfif>
		<!--- SECCION III --->
		<cfif #vSeccion# IS 3>
			<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
				SELECT *
				FROM consulta_solicitudes_listados
				WHERE sol_status <= 1 <!--- Asuntos que pasan al pleno y asuntos resueltos --->
				AND asu_reunion = 'CTIC' <!--- Registro de asunto CTIC --->
				AND ssn_id = #vActa# <!--- Del acta seleccionada --->
				AND asu_parte = 3 <!--- Solo incluir los asuntos de la Sección III --->
				ORDER BY
				asu_parte,
				LEFT(cn_siglas, 3), <!--- Solución temporal --->
				asu_numero
<!---
				SELECT *, 
				LEFT(C3.cn_siglas, 3) AS clase_academico,
				(
					ISNULL(dbo.SINACENTOS(acd_apepat),'') + 
					CASE WHEN acd_apepat IS NULL THEN '' ELSE ' ' END + 
					ISNULL(dbo.SINACENTOS(acd_apemat),'') + 
					CASE WHEN acd_apemat IS NULL THEN '' ELSE ' ' END + 
					ISNULL(dbo.SINACENTOS(acd_nombres),'')
				) AS nombre_comp
				FROM ((((movimientos_solicitud
				LEFT JOIN movimientos_asunto ON movimientos_solicitud.sol_id = movimientos_asunto.sol_id)
				LEFT JOIN academicos ON movimientos_solicitud.sol_pos2 = academicos.acd_id)
				LEFT JOIN catalogo_movimiento ON movimientos_solicitud.mov_clave = catalogo_movimiento.mov_clave)
				LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C2 ON movimientos_solicitud.sol_pos1 = C2.dep_clave) <!---CATALOGOS GENERALES MYSQL --->
				LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_cn')# AS C3 ON C3.cn_clave = ISNULL(movimientos_solicitud.sol_pos8, movimientos_solicitud.sol_pos3) <!---CATALOGOS GENERALES MYSQL --->
				WHERE sol_status <= 1 <!--- Asuntos que pasan al pleno y asuntos resueltos --->
				AND movimientos_asunto.asu_reunion = 'CTIC' <!--- Registro de asunto CTIC --->
				AND movimientos_asunto.ssn_id = #vActa# <!--- Del acta seleccionada --->
				AND movimientos_asunto.asu_parte = 3 <!--- Solo incluir los asuntos de la Sección III --->
				ORDER BY
				movimientos_asunto.asu_parte,
				LEFT(C3.cn_siglas, 3), <!--- Solución temporal --->
				movimientos_asunto.asu_numero
--->				
			</cfquery>
			<!--- Lista de asuntos --->
			<cfoutput query="tbSolicitudes" group="asu_parte">
				<!--- Obtener el nombre de la parte actual del listado (MOVERLO AL SQL) --->
				<cfquery name="ctListado" datasource="#vOrigenDatosSAMAA#">
					SELECT * FROM catalogo_listado WHERE parte_numero = #tbSolicitudes.asu_parte#
				</cfquery>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" style="page:vertical;">
					<!--- Encabezado --->
					<cfinclude template="detalle_encabezado.cfm">
					<!--- Agrupación por tipo de académico --->
					<cfoutput group="clase_academico">
						<!--- Clase (Investigador o Técnico Académico) --->
						<tr>
							<td colspan="3">
								<b>
								<cfif #clase_academico# IS 'INV'>
									INVESTIGADORES
								<cfelseif #clase_academico# IS 'TEC'>
									T&Eacute;CNICOS ACAD&Eacute;MICOS
								</cfif>
								</b>
							</td>
						</tr>
						<!--- Separación --->
						<tr><td colspan="3" height="10"></td></tr>
						<!--- Agrupación por dependencia --->
						<cfoutput group="dep_orden">
							<tr>
								<td colspan="3">#UCase(tbSolicitudes.dep_nombre)#</td>
							</tr>
							<!--- División --->
							<tr><td colspan="3" height="10"></td></tr>
							<!--- Asuntos a considerar --->
							<cfoutput>
								#DetalleAsunto(tbSolicitudes)#
							</cfoutput>
						</cfoutput>
					</cfoutput>
				</table>
				<p style="page-break-after:always"><br></p>
			</cfoutput>
		</cfif>
		<!--- SECCION III.I --->
		<cfif #vSeccion# IS 3.1>
			<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
				SELECT *
				FROM consulta_solicitudes_listados
				WHERE sol_status <= 1 <!--- Asuntos que pasan al pleno y asuntos resueltos --->
				AND asu_reunion = 'CTIC' <!--- Registro de asunto CTIC --->
				AND ssn_id = #vActa# <!--- Del acta seleccionada --->
				AND asu_parte = 3.1 <!--- Solo incluir los asuntos de la Sección III.I --->
				ORDER BY
				asu_parte,
				asu_numero
<!---
				SELECT *,
				(
					ISNULL(dbo.SINACENTOS(acd_apepat),'') + 
					CASE WHEN acd_apepat IS NULL THEN '' ELSE ' ' END + 
					ISNULL(dbo.SINACENTOS(acd_apemat),'') + 
					CASE WHEN acd_apemat IS NULL THEN '' ELSE ' ' END + 
					ISNULL(dbo.SINACENTOS(acd_nombres),'')
				) AS nombre_comp
				FROM (((movimientos_solicitud
				LEFT JOIN movimientos_asunto ON movimientos_solicitud.sol_id = movimientos_asunto.sol_id)
				LEFT JOIN academicos ON movimientos_solicitud.sol_pos2 = academicos.acd_id)
				LEFT JOIN catalogo_movimiento ON movimientos_solicitud.mov_clave = catalogo_movimiento.mov_clave)
				LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C2 ON movimientos_solicitud.sol_pos1 = C2.dep_clave <!---CATALOGOS GENERALES MYSQL --->
				WHERE sol_status <= 1 <!--- Asuntos que pasan al pleno y asuntos resueltos --->
				AND movimientos_asunto.asu_reunion = 'CTIC' <!--- Registro de asunto CTIC --->
				AND movimientos_asunto.ssn_id = #vActa# <!--- Del acta seleccionada --->
				AND movimientos_asunto.asu_parte = 3.1 <!--- Solo incluir los asuntos de la Sección III.I --->
				ORDER BY
				movimientos_asunto.asu_parte,
				movimientos_asunto.asu_numero
--->				
			</cfquery>
			<!--- Lista de asuntos --->
			<cfoutput query="tbSolicitudes" group="asu_parte">
				<!--- Obtener el nombre de la parte actual del listado (MOVERLO AL SQL) --->
				<cfquery name="ctListado" datasource="#vOrigenDatosSAMAA#">
					SELECT * FROM catalogo_listado WHERE parte_numero = #tbSolicitudes.asu_parte#
				</cfquery>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" style="page:vertical;">
					<!--- Encabezado --->
					<cfinclude template="detalle_encabezado.cfm">
					<!--- Agrupación por dependencia --->
					<cfoutput group="dep_orden">
						<tr>
							<td colspan="3">#UCase(tbSolicitudes.dep_nombre)#</td>
						</tr>
						<!--- División --->
						<tr><td colspan="3" height="10"></td></tr>
						<!--- Asuntos a considerar --->
						<cfoutput>
							#DetalleAsunto(tbSolicitudes)#
						</cfoutput>
					</cfoutput>
				</table>
				<p style="page-break-after:always"><br></p>
			</cfoutput>
		</cfif>
		<!--- SECCION III.II --->
		<cfif #vSeccion# IS 3.2>
			<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
				SELECT *
				FROM consulta_solicitudes_listados
				WHERE sol_status <= 1 <!--- Asuntos que pasan al pleno y asuntos resueltos --->
				AND su_reunion = 'CTIC' <!--- Registro de asunto CTIC --->
				AND ssn_id = #vActa# <!--- Del acta seleccionada --->
				AND asu_parte = 3.2 <!--- Solo incluir los asuntos de la Sección III.II --->
				ORDER BY
				asu_parte,
				asu_numero                
<!---
				SELECT *,
				(
					ISNULL(dbo.SINACENTOS(acd_apepat),'') + 
					CASE WHEN acd_apepat IS NULL THEN '' ELSE ' ' END + 
					ISNULL(dbo.SINACENTOS(acd_apemat),'') + 
					CASE WHEN acd_apemat IS NULL THEN '' ELSE ' ' END + 
					ISNULL(dbo.SINACENTOS(acd_nombres),'')
				) AS nombre_comp
				FROM (((movimientos_solicitud
				LEFT JOIN movimientos_asunto ON movimientos_solicitud.sol_id = movimientos_asunto.sol_id)
				LEFT JOIN academicos ON movimientos_solicitud.sol_pos2 = academicos.acd_id)
				LEFT JOIN catalogo_movimiento ON movimientos_solicitud.mov_clave = catalogo_movimiento.mov_clave)
				LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C2 ON movimientos_solicitud.sol_pos1 = C2.dep_clave <!---CATALOGOS GENERALES MYSQL --->
				WHERE sol_status <= 1 <!--- Asuntos que pasan al pleno y asuntos resueltos --->
				AND movimientos_asunto.asu_reunion = 'CTIC' <!--- Registro de asunto CTIC --->
				AND movimientos_asunto.ssn_id = #vActa# <!--- Del acta seleccionada --->
				AND movimientos_asunto.asu_parte = 3.2 <!--- Solo incluir los asuntos de la Sección III.II --->
				ORDER BY
				movimientos_asunto.asu_parte,
				movimientos_asunto.asu_numero
--->				
			</cfquery>
			<!--- Lista de asuntos --->
			<cfoutput query="tbSolicitudes" group="asu_parte">
				<!--- Obtener el nombre de la parte actual del listado (MOVERLO AL SQL) --->
				<cfquery name="ctListado" datasource="#vOrigenDatosSAMAA#">
					SELECT * FROM catalogo_listado WHERE parte_numero = #tbSolicitudes.asu_parte#
				</cfquery>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" style="page:vertical;">
					<!--- Encabezado --->
					<cfinclude template="detalle_encabezado.cfm">
					<!--- Agrupación por dependencia --->
					<cfoutput group="dep_orden">
						<tr>
							<td colspan="3">#UCase(tbSolicitudes.dep_nombre)#</td>
						</tr>
						<!--- División --->
						<tr><td colspan="3" height="10"></td></tr>
						<!--- Asuntos a considerar --->
						<cfoutput>
							#DetalleAsunto(tbSolicitudes)#
						</cfoutput>
					</cfoutput>
				</table>
				<p style="page-break-after:always"><br></p>
			</cfoutput>
		</cfif>
		<!--- SECCION III.IV --->
		<cfif #vSeccion# IS 3.4>
			<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#" result="ppp">
				SELECT *
				FROM consulta_solicitudes_listados
				WHERE sol_status <= 1 <!--- Asuntos que pasan al pleno y asuntos resueltos --->
				AND asu_reunion = 'CTIC' <!--- Registro de asunto CTIC --->
				AND ssn_id = #vActa# <!--- Del acta seleccionada --->
				AND asu_parte = 3.4 <!--- Solo incluir los asuntos de la Sección III.IV --->
				ORDER BY
				asu_parte,
				asu_numero
<!---
				SELECT *,
				(
					ISNULL(dbo.SINACENTOS(acd_apepat),'') + 
					CASE WHEN acd_apepat IS NULL THEN '' ELSE ' ' END + 
					ISNULL(dbo.SINACENTOS(acd_apemat),'') + 
					CASE WHEN acd_apemat IS NULL THEN '' ELSE ' ' END + 
					ISNULL(dbo.SINACENTOS(acd_nombres),'')
				) AS nombre_comp
				FROM (((movimientos_solicitud
				LEFT JOIN movimientos_asunto ON movimientos_solicitud.sol_id = movimientos_asunto.sol_id)
				LEFT JOIN academicos ON movimientos_solicitud.sol_pos2 = academicos.acd_id)
				LEFT JOIN catalogo_movimiento ON movimientos_solicitud.mov_clave = catalogo_movimiento.mov_clave)
				LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C2 ON movimientos_solicitud.sol_pos1 = C2.dep_clave <!---CATALOGOS GENERALES MYSQL --->
				WHERE sol_status <= 1 <!--- Asuntos que pasan al pleno y asuntos resueltos --->
				AND movimientos_asunto.asu_reunion = 'CTIC' <!--- Registro de asunto CTIC --->
				AND movimientos_asunto.ssn_id = #vActa# <!--- Del acta seleccionada --->
				AND movimientos_asunto.asu_parte = 3.4 <!--- Solo incluir los asuntos de la Sección III.IV --->
				ORDER BY
				movimientos_asunto.asu_parte,
				movimientos_asunto.asu_numero
--->
			</cfquery>
			<!--- Lista de asuntos --->
			<cfoutput query="tbSolicitudes" group="asu_parte">
				<!--- Obtener el nombre de la parte actual del listado (MOVERLO AL SQL) --->
				<cfquery name="ctListado" datasource="#vOrigenDatosSAMAA#">
					SELECT * FROM catalogo_listado WHERE parte_numero = #tbSolicitudes.asu_parte#
				</cfquery>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" style="page:vertical;">
					<!--- Encabezado --->
					<cfinclude template="detalle_encabezado.cfm">
					<!--- Agrupación por dependencia --->
					<cfoutput group="dep_orden">
						<tr>
							<td colspan="3">#UCase(tbSolicitudes.dep_nombre)#</td>
						</tr>
						<!--- División --->
						<tr><td colspan="3" height="10"></td></tr>
						<!--- Asuntos a considerar --->
						<cfoutput>
							#DetalleAsunto(tbSolicitudes)#
						</cfoutput>
					</cfoutput>
				</table>
				<p style="page-break-after:always"><br></p>
			</cfoutput>
		</cfif>
		<!--- SECCION IV --->
		<cfif #vSeccion# IS 4>
			<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
				SELECT *
				FROM consulta_solicitudes_listados
				WHERE sol_status <= 1 <!--- Asuntos que pasan al pleno y asuntos resueltos --->
				AND asu_reunion = 'CTIC' <!--- Registro de asunto CTIC --->
				AND ssn_id = #vActa# <!--- Del acta seleccionada --->
				AND asu_parte >= 4 AND asu_parte < 5 <!--- Solo incluir los asuntos de la Sección IV --->
				<!--- NOTA: Los asuntos no deben ordenarse por número de asunto sino por entidad, nombre y fecha --->
				ORDER BY
				asu_parte,
				dep_orden,
				acd_apepat,
				acd_apemat,
				acd_nombres,
				sol_pos14
<!---
				SELECT *,
				(
					ISNULL(dbo.SINACENTOS(acd_apepat),'') + 
					CASE WHEN acd_apepat IS NULL THEN '' ELSE ' ' END + 
					ISNULL(dbo.SINACENTOS(acd_apemat),'') + 
					CASE WHEN acd_apemat IS NULL THEN '' ELSE ' ' END + 
					ISNULL(dbo.SINACENTOS(acd_nombres),'')
				) AS nombre_comp
				FROM (((movimientos_solicitud
				LEFT JOIN movimientos_asunto ON movimientos_solicitud.sol_id = movimientos_asunto.sol_id)
				LEFT JOIN academicos ON movimientos_solicitud.sol_pos2 = academicos.acd_id)
				LEFT JOIN catalogo_movimiento ON movimientos_solicitud.mov_clave = catalogo_movimiento.mov_clave)
				LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C2 ON movimientos_solicitud.sol_pos1 = C2.dep_clave <!---CATALOGOS GENERALES MYSQL --->
				WHERE sol_status <= 1 <!--- Asuntos que pasan al pleno y asuntos resueltos --->
				AND movimientos_asunto.asu_reunion = 'CTIC' <!--- Registro de asunto CTIC --->
				AND movimientos_asunto.ssn_id = #vActa# <!--- Del acta seleccionada --->
				AND movimientos_asunto.asu_parte >= 4 AND movimientos_asunto.asu_parte < 5 <!--- Solo incluir los asuntos de la Sección IV --->
				<!--- NOTA: Los asuntos no deben ordenarse por número de asunto sino por entidad, nombre y fecha --->
				ORDER BY
				movimientos_asunto.asu_parte,
				C2.dep_orden,
				academicos.acd_apepat,
				academicos.acd_apemat,
				academicos.acd_nombres,
				movimientos_solicitud.sol_pos14
--->
			</cfquery>
			<!--- Lista de asuntos --->
			<cfoutput query="tbSolicitudes" group="asu_parte">
				<!--- Obtener el nombre de la parte actual del listado (MOVERLO AL SQL) --->
				<cfquery name="ctListado" datasource="#vOrigenDatosSAMAA#">
					SELECT * FROM catalogo_listado WHERE parte_numero = #tbSolicitudes.asu_parte#
				</cfquery>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" style="page:vertical;">
					<!--- Encabezado --->
					<cfinclude template="detalle_encabezado.cfm">
					<!--- Agrupación por dependencia --->
					<cfoutput group="dep_orden">
						<tr>
							<td colspan="3">#UCase(tbSolicitudes.dep_nombre)#</td>
						</tr>
						<!--- División --->
						<tr><td colspan="3" height="10"></td></tr>
						<!--- Asuntos a considerar --->
						<cfoutput>
							#DetalleAsunto(tbSolicitudes)#
						</cfoutput>
					</cfoutput>
				</table>
				<p style="page-break-after:always"><br></p>
			</cfoutput>
		</cfif>
		<!--- SECCION V --->
		<cfif #vSeccion# IS 5>
			<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
				SELECT *
				FROM consulta_solicitudes_listados
				WHERE sol_status <= 1 <!--- Asuntos que pasan al pleno y asuntos resueltos --->
				AND asu_reunion = 'CTIC' <!--- Registro de asunto CTIC --->
				AND ssn_id = #vActa# <!--- Del acta seleccionada --->
				AND asu_parte = 5 <!--- Solo incluir los asuntos de la Sección V --->
				ORDER BY
				dep_orden,
				acd_apepat,
				acd_apemat,
				acd_nombres,
				sol_pos14
<!---
				SELECT *,
				LEFT(C3.cn_siglas, 3) AS clase_academico,
				(
					ISNULL(dbo.SINACENTOS(acd_apepat),'') + 
					CASE WHEN acd_apepat IS NULL THEN '' ELSE ' ' END + 
					ISNULL(dbo.SINACENTOS(acd_apemat),'') + 
					CASE WHEN acd_apemat IS NULL THEN '' ELSE ' ' END + 
					ISNULL(dbo.SINACENTOS(acd_nombres),'')
				) AS nombre_comp
				FROM ((((movimientos_solicitud
				LEFT JOIN movimientos_asunto ON movimientos_solicitud.sol_id = movimientos_asunto.sol_id)
				LEFT JOIN academicos ON movimientos_solicitud.sol_pos2 = academicos.acd_id)
				LEFT JOIN catalogo_movimiento ON movimientos_solicitud.mov_clave = catalogo_movimiento.mov_clave)
				LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C2 ON movimientos_solicitud.sol_pos1 = C2.dep_clave) <!---CATALOGOS GENERALES MYSQL --->
				LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_cn')# AS C3 ON academicos.cn_clave = C3.cn_clave <!---CATALOGOS GENERALES MYSQL --->
				WHERE sol_status <= 1 <!--- Asuntos que pasan al pleno y asuntos resueltos --->
				AND movimientos_asunto.asu_reunion = 'CTIC' <!--- Registro de asunto CTIC --->
				AND movimientos_asunto.ssn_id = #vActa# <!--- Del acta seleccionada --->
				AND movimientos_asunto.asu_parte = 5 <!--- Solo incluir los asuntos de la Sección V --->
				ORDER BY
				C2.dep_orden,
				academicos.acd_apepat,
				academicos.acd_apemat,
				academicos.acd_nombres,
				movimientos_solicitud.sol_pos14
--->				
			</cfquery>
			<!--- Lista de asuntos --->
			<cfoutput query="tbSolicitudes" group="asu_parte">
				<!--- Obtener el nombre de la parte actual del listado (MOVERLO AL SQL) --->
				<cfquery name="ctListado" datasource="#vOrigenDatosSAMAA#">
					SELECT * FROM catalogo_listado WHERE parte_numero = #tbSolicitudes.asu_parte#
				</cfquery>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<!--- Encabezado --->
					<cfinclude template="detalle_encabezado.cfm">
					<!--- Agrupación por dependencia --->
					<cfoutput group="dep_orden">
						<tr>
							<td colspan="3">#UCase(tbSolicitudes.dep_nombre)#</td>
						</tr>
						<!-- División -->
						<tr><td colspan="3" height="10"></td></tr>
						<!--- Asuntos a considerar --->
						<cfoutput>
							#DetalleAsunto(tbSolicitudes)#
						</cfoutput>
					</cfoutput>
				</table>
				<p style="page-break-after:always"><br></p>
			</cfoutput>
		</cfif>
		<!--- SECCION VI --->
		<cfif #vSeccion# IS 6>
			<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
				SELECT *,
				(
					ISNULL(dbo.SINACENTOS(acd_apepat),'') + 
					CASE WHEN acd_apepat IS NULL THEN '' ELSE ' ' END + 
					ISNULL(dbo.SINACENTOS(acd_apemat),'') + 
					CASE WHEN acd_apemat IS NULL THEN '' ELSE ' ' END + 
					ISNULL(dbo.SINACENTOS(acd_nombres),'')
				) AS nombre_comp
                FROM (((movimientos_solicitud
				LEFT JOIN movimientos_asunto ON movimientos_solicitud.sol_id = movimientos_asunto.sol_id)
				LEFT JOIN academicos ON movimientos_solicitud.sol_pos2 = academicos.acd_id
				LEFT JOIN catalogo_movimiento ON movimientos_solicitud.mov_clave = catalogo_movimiento.mov_clave)
				LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C2 ON movimientos_solicitud.sol_pos1 = C2.dep_clave <!---CATALOGOS GENERALES MYSQL --->
				WHERE sol_status <= 1 <!--- Asuntos que pasan al pleno y asuntos resueltos --->
				AND movimientos_asunto.asu_reunion = 'CTIC' <!--- Registro de asunto CTIC --->
				AND movimientos_asunto.ssn_id = #vActa# <!--- Del acta seleccionada --->
				AND movimientos_asunto.asu_parte = 6 <!--- Solo incluir los asuntos de la sección VI --->
				AND movimientos_solicitud.mov_clave = 31 <!--- Solo correcciones a oficio --->
				ORDER BY movimientos_asunto.asu_numero
			</cfquery>
			<!--- Lista de asuntos --->
			<cfoutput query="tbSolicitudes" group="asu_parte">
				<!--- Obtener el nombre de la parte actual del listado (MOVERLO AL SQL) --->
				<cfquery name="ctListado" datasource="#vOrigenDatosSAMAA#">
					SELECT * FROM catalogo_listado WHERE parte_numero = #tbSolicitudes.asu_parte#
				</cfquery>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" style="page:vertical;">
					<!--- Encabezado --->
					<cfinclude template="detalle_encabezado.cfm">
					<!--- Agrupación por dependencia --->
					<cfoutput group="dep_orden">
						<tr>
							<td colspan="3">#UCase(tbSolicitudes.dep_nombre)#</td>
						</tr>
						<!--- División --->
						<tr><td colspan="3" height="10"></td></tr>
						<!--- Asuntos a considerar --->
						<cfoutput>
							<!---<cfinclude template="detalle_asuntos_VI.cfm">--->
							#DetalleAsunto(tbSolicitudes)#
						</cfoutput>
					</cfoutput>
				</table>
				<p style="page-break-after:always"><br></p>
			</cfoutput>
		</cfif>
	</body>
</html>
