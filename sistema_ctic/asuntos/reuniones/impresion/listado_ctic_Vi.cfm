<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 02/11/2009 --->
<!--- FECHA ÚLTIMA MOD.: 10/12/2015 --->

<!--- IMPRESION DE LA LISTA DE LICENCIAS Y COMISIONES (en formato horizontal) --->
<!--- Enviar el contenido a un archivo MS Word --->
<cfheader name="Content-Disposition" value="inline; filename=listado_ctic_V.doc">
<cfcontent type="application/msword; charset=iso-8859-1">
<!--- Obtener información del periodo de sesión --->
<cfquery name="tbSesiones" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM sesiones WHERE ssn_id = #vActa# AND ssn_clave = 1
</cfquery>
<html>
	<head>
		<title>STCTIC - Asuntos Acad&eacute;mico-Administrativos</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href="<cfoutput>#vCarpetaCSS#</cfoutput>/listados_v.css" rel="stylesheet" type="text/css">
	</head>
	<body>
		<!--- SECCION V (destinos nacionales) --->
		<!--- Obtener la lista de solicitudes enviadas por las entidades académicas del SIC --->
		<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
			SELECT * FROM ((((movimientos_solicitud 
			LEFT JOIN movimientos_asunto ON movimientos_solicitud.sol_id = movimientos_asunto.sol_id)
			LEFT JOIN academicos ON movimientos_solicitud.sol_pos2 = academicos.acd_id)
			LEFT JOIN catalogo_movimiento ON movimientos_solicitud.mov_clave = catalogo_movimiento.mov_clave) <!---CATALOGOS GENERALES MYSQL ---> 
			LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C2 ON movimientos_solicitud.sol_pos1 = C2.dep_clave) <!---CATALOGOS GENERALES MYSQL --->
			LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_cn')# AS C3 ON academicos.cn_clave = C3.cn_clave
			WHERE sol_status <= 1 <!--- Asuntos que pasan al pleno y asuntos resueltos --->
			AND movimientos_asunto.asu_reunion = 'CTIC' <!--- Registro de asunto CTIC --->
			AND movimientos_asunto.ssn_id = #vActa# <!--- Del acta seleccionada --->
			AND movimientos_asunto.asu_parte = 5 <!--- Solo incluir los asuntos de la Sección V --->
			AND movimientos_solicitud.sol_pos11_p <> 'MEX' <!--- Solo internacionales --->
			ORDER BY 
			C2.dep_orden,
			academicos.acd_apepat, 
			academicos.acd_apemat, 
			academicos.acd_nombres, 
			movimientos_solicitud.sol_pos14
		</cfquery>
		<!--- Agrupación por sección del informe --->
		<cfoutput query="tbSolicitudes" group="asu_parte">
			<!--- Obtener el nombre de la parte actual del listado (MOVERLO AL SQL) --->
			<cfquery name="ctListado" datasource="#vOrigenDatosSAMAA#">
				SELECT * FROM catalogo_listado
				WHERE parte_numero = #tbSolicitudes.asu_parte#
			</cfquery>
			<!--- Lista de solicitudes capturadas --->
			<table width="100%" border="0" cellspacing="0" cellpadding="0" style="page:horizontal;">
				<!-- Titulo de la sección -->
				<tr>
					<td colspan="7">
						RELACION DE LICENCIAS CON GOCE DE SUELDO Y COMISIONES MENORES A 22 D&Iacute;AS APROBADAS<br>
						POR EL CTIC EN SU SESI&Oacute;N ORDINARIA DEL #Ucase(FechaCompleta(tbSesiones.ssn_fecha))# CON FUNDAMENTO EN LOS<br>
						ART&Iacute;CULOS 97 INCISOS B Y C, 98 INCISO B Y 100 DEL ESTATUTO DEL PERSONAL ACAD&Eacute;MICO DE LA UNAM
					</td>
				</tr>
				<!--- Separación --->
				<tr><td colspan="6" height="30"></td></tr>
				<!--- Lista de licenias y comisiones --->
				<cfoutput group="dep_orden">
					<!--- Dependencia --->
					<tr>
						<td colspan="6">#UCase(tbSolicitudes.dep_nombre)#</td>
					</tr>
					<!--- Encabezados --->
					<tr class="encabezado">
						<td>ASUNTO</td>
						<td>NOMBRE</td>
						<td>DURACI&Oacute;N</td>
						<td>FECHA</td>
						<td>ACTIVIDAD</td>
						<td>LUGAR</td>
					</tr>
					<!--- Datos --->	
					<cfoutput>
						<tr>
							<!-- Número de asunto -->
							<td><cfif #mov_clave# IS 40>COMISI&Oacute;N<cfelse>LICENCIA</cfif></td>
							<!-- Nombre del académico -->
							<td>#Trim(tbSolicitudes.acd_apepat)# #Trim(tbSolicitudes.acd_apemat)# #Trim(tbSolicitudes.acd_nombres)#</td>
							<!-- Duración (en días) -->
							<td>#LsNumberFormat(tbSolicitudes.sol_pos13_d,99)# D&Iacute;A<cfif #tbSolicitudes.sol_pos13_d# GT 1>S</cfif></td>
							<!-- Fecha de incio -->
							<td>#LSDateFormat(tbSolicitudes.sol_pos14,"dd/mm/yyyy")# </td>
							<!-- Actividad -->
							<cfquery name="ctActividad" datasource="#vOrigenDatosSAMAA#">
								SELECT * FROM catalogo_actividad
								WHERE activ_clave = #tbSolicitudes.sol_pos12#
							</cfquery>
							<td>#ctActividad.activ_descrip#</td>
							<!--- Obtener el país --->
							<cfquery name="ctPais" datasource="#vOrigenDatosSAMAA#">
								SELECT * FROM catalogo_pais WHERE pais_clave = '#tbSolicitudes.sol_pos11_p#'
							</cfquery>
							<!--- Obtener el estado --->
							<cfquery name="ctEstado" datasource="#vOrigenDatosSAMAA#">
								SELECT * FROM catalogo_pais_edo WHERE edo_clave = '#tbSolicitudes.sol_pos11_e#'
							</cfquery>
							<td>#Trim(tbSolicitudes.sol_pos11_c)#, <cfif #tbSolicitudes.sol_pos11_p# IS 'USA'>#Trim(ctEstado.edo_nombre)#, E.U.A.<cfelse><cfif #tbSolicitudes.sol_pos11_e# IS NOT ''>#Trim(tbSolicitudes.sol_pos11_e)#, </cfif>#Trim(ctPais.pais_nombre)#.</cfif></td>
						</tr>
					</cfoutput>
					<!--- División --->
					<tr><td colspan="6" height="20"></td></tr>
				</cfoutput>
			</table>
		</cfoutput>
	</body>
</html>
