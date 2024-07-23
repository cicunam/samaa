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
		<!--- SECCION V --->
		<!--- Obtener la lista de solicitudes enviadas por las entidades académicas del SIC --->
		<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
			SELECT *, LEFT(C3.cn_siglas, 3) AS clase_academico FROM ((((movimientos_solicitud 
			LEFT JOIN movimientos_asunto ON movimientos_solicitud.sol_id = movimientos_asunto.sol_id)
			LEFT JOIN academicos ON movimientos_solicitud.sol_pos2 = academicos.acd_id)
			LEFT JOIN catalogo_movimiento ON movimientos_solicitud.mov_clave = catalogo_movimiento.mov_clave) <!---CATALOGOS GENERALES MYSQL --->
			LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C2 ON movimientos_solicitud.sol_pos1 = C2.dep_clave) <!---CATALOGOS GENERALES MYSQL --->
			LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_cn')# AS C3 ON academicos.cn_clave = C3.cn_clave
			WHERE sol_status <= 1 <!--- Asuntos que pasan al pleno y asuntos resueltos --->
			AND movimientos_asunto.asu_reunion = 'CTIC' <!--- Registro de asunto CTIC --->
			AND movimientos_asunto.ssn_id = #vActa# <!--- Del acta seleccionada --->
			AND movimientos_asunto.asu_parte = 5 <!--- Solo incluir los asuntos de la Sección V --->
			ORDER BY movimientos_asunto.asu_numero <!--- No se requieren más ordenamiemto pues el AJAX indexar_asuntos.cfm hace el trabajo --->
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
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td colspan="2">#ctListado.parte_titulo#</td>
							</tr>
							<tr>
								<td>RELACION DEL #FechaCompleta(tbSesiones.ssn_fecha)#</td>
								<td align="right">ACTA #vActa#</td>
							</tr>
						</table>
					</td>
				</tr>
				<!--- Línea --->
				<tr><td colspan="7"><hr class="doble"></td></tr>
				<!--- Separación --->
				<tr><td colspan="7" height="10"></td></tr>
				<!--- Lista de licenias y comisiones --->
				<cfoutput group="dep_orden">
					<!--- Dependencia --->
					<tr>
						<td colspan="7" align="center">#UCase(tbSolicitudes.dep_nombre)#</td>
					</tr>
					<!--- Agrupación por tipo de movimiento ---->
					<cfoutput group="mov_clave">
						<!--- Tipo de movimiento --->
						<tr>
							<td colspan="3" align="left">
								<cfif #tbSolicitudes.mov_clave# IS 40>
									COMISIONES MENORES A 22 D&Iacute;AS
								<cfelse>
									LICENCIAS CON GOCE DE SUELDO
								</cfif>
							</td>
							<!--- Número de oficio --->
							<td colspan="4" align="right">OFICIO: #tbSolicitudes.asu_oficio#</td>
						</tr>
						<!--- Encabezados --->
						<tr class="encabezado">
							<td style="width:0.8cm;"></td>
							<td>NOMBRE</td>
							<td>CATEGOR&Iacute;A</td>
							<td>DURACI&Oacute;N</td>
							<td>FECHA INICIO</td>
							<td>ACTIVIDAD</td>
							<td><cfif #vTipo# IS 'REC'>RECOMENDACI&Oacute;N<cfelseif #vTipo# IS 'ACTA'>DECISI&Oacute;N</cfif></td>
						</tr>
						<!--- Datos --->	
						<cfoutput>
							<tr>
								<!-- Número de asunto -->
								<td align="center">#tbSolicitudes.asu_numero#</td>
								<!-- Nombre del académico -->
								<td>#Trim(tbSolicitudes.acd_prefijo)# #Trim(tbSolicitudes.acd_nombres)# #Trim(tbSolicitudes.acd_apepat)# #Trim(tbSolicitudes.acd_apemat)#</td>
								<!-- Categoría y nivel -->
								<cfquery name="ctCategoria" datasource="#vOrigenDatosSAMAA#">
									SELECT * FROM catalogo_cn
									WHERE cn_clave = '#tbSolicitudes.sol_pos3#'
								</cfquery>
								<td>#ctCategoria.cn_siglas#</td>
								<!-- Duración (en días) -->
								<td>#LsNumberFormat(tbSolicitudes.sol_pos13_d,99)# D&Iacute;A<cfif #tbSolicitudes.sol_pos13_d# GT 1>S</cfif></td>
								<!-- Fecha de incio -->
								<td>#FechaCompleta(tbSolicitudes.sol_pos14)# </td>
								<!-- Actividad -->
								<cfquery name="ctActividad" datasource="#vOrigenDatosSAMAA#">
									SELECT * FROM catalogo_actividad
									WHERE activ_clave = #tbSolicitudes.sol_pos12#
								</cfquery>
								<td>#ctActividad.activ_descrip#</td>
								<cfif #vTipo# IS 'REC'>
									<!-- Recomendación/Decisión -->
									<cfquery name="tbAsuntosCAAA" datasource="#vOrigenDatosSAMAA#">
										SELECT * FROM movimientos_asunto
										INNER JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave
										WHERE sol_id = #tbSolicitudes.sol_id# AND ssn_id = #vActa# AND asu_reunion = 'CAAA'
									</cfquery>
									<td>#tbAsuntosCAAA.dec_descrip#</td>
								<cfelseif #vTipo# IS 'ACTA'>
									<!--- Obtener el registro de la CTIC --->
									<cfquery name="tbAsuntosCTIC" datasource="#vOrigenDatosSAMAA#">
										SELECT * FROM movimientos_asunto
										INNER JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave
										WHERE sol_id = #tbSolicitudes.sol_id# AND ssn_id = #vActa# AND asu_reunion = 'CTIC'
									</cfquery>
									<td>#tbAsuntosCTIC.dec_descrip#</td>
								</cfif>	
							</tr>
						</cfoutput>
						<!--- División --->
						<tr><td colspan="3" height="15"></td></tr>
					</cfoutput>
				</cfoutput>
			</table>
		</cfoutput>
	</body>
</html>
