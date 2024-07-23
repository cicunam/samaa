<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 14/01/2010 --->
<!--- FECHA ÚLTIMA MOD.: 10/12/2015 --->

<!--- IMPRESION DE OFICIOS DE LICENCIAS Y COMISIONES --->
<!--- Enviar el contenido a un archivo MS Word --->
<cfheader name="Content-Disposition" value="inline; filename=oficios_lyc.doc">
<cfcontent type="application/msword; charset=iso-8859-1">

<!--- Obtener la información del COORDINADOR actual --->
<cfquery name="tbAcademicosCargosCoord" datasource="#vOrigenDatosSAMAA#">
	SELECT caa_firma, caa_siglas 
    FROM academicos_cargos
    WHERE adm_clave = 84
    AND caa_status = 'A'
</cfquery>

<!--- Obtener información de la sesión del CTIC --->
<cfquery name="tbSesiones" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM sesiones 
    WHERE ssn_id = #vActa#
</cfquery>
<!--- Fecha la sesión de pleno --->
<cfif IsDate(#tbSesiones.ssn_fecha_m#)>
	<cfset DiaCTIC = Ucase(FechaCompleta(tbSesiones.ssn_fecha_m))>
<cfelse>
	<cfset DiaCTIC = Ucase(FechaCompleta(tbSesiones.ssn_fecha))>
</cfif>
<!--- Fecha del día despues de la sesión de pleno --->
<cfif IsDate(#tbSesiones.ssn_fecha_m#)>
	<cfset SiguienteDiaCTIC = Ucase(FechaCompleta(tbSesiones.ssn_fecha_m))>
<cfelse>
	<cfset SiguienteDiaCTIC = Ucase(FechaCompleta(tbSesiones.ssn_fecha))>
</cfif>
<html>
	<head>
		<title>STCTIC - Asuntos Acad&eacute;mico-Administrativos</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href="<cfoutput>#vCarpetaCSS#</cfoutput>/oficios.css" rel="stylesheet" type="text/css">
	</head>
	<body style="color:#000000; font-family:sans-serif; font-weight:normal;">
		<!--- Obtener solicitudes de licencias y comisiones --->
		<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
			SELECT * FROM ((((movimientos_solicitud 
			LEFT JOIN movimientos_asunto ON movimientos_solicitud.sol_id = movimientos_asunto.sol_id)
			LEFT JOIN academicos ON movimientos_solicitud.sol_pos2 = academicos.acd_id)
			LEFT JOIN catalogo_movimiento ON movimientos_solicitud.mov_clave = catalogo_movimiento.mov_clave) 
			LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C2 ON movimientos_solicitud.sol_pos1 = C2.dep_clave)
			LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_cn')# AS C3 ON academicos.cn_clave = C3.cn_clave
			WHERE movimientos_asunto.ssn_id = #vActa#
			AND movimientos_asunto.asu_reunion = 'CTIC'
			AND (movimientos_solicitud.mov_clave = 40 OR movimientos_solicitud.mov_clave = 41) <!--- licencias y comisiones --->
			ORDER BY 
			C2.dep_orden,
			movimientos_solicitud.mov_clave DESC,
			academicos.acd_apepat,
			academicos.acd_apemat,
			academicos.acd_nombres,
			movimientos_solicitud.sol_pos14
		</cfquery>
		<!--- Generar oficios de respuesta --->
		<cfoutput query="tbSolicitudes" group="dep_clave">
			<!--- Obtener el nombre del director --->
			<cfquery name="tbAcademicosCargos" datasource="#vOrigenDatosSAMAA#">
				SELECT * FROM (academicos_cargos
				LEFT JOIN academicos ON academicos_cargos.acd_id = academicos.acd_id)
				LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C2 ON academicos_cargos.dep_clave = C2.dep_clave
				WHERE academicos_cargos.dep_clave = '#tbSolicitudes.sol_pos1#' 
				AND academicos_cargos.adm_clave = '32'
				AND academicos_cargos.caa_fecha_inicio <= GETDATE()
				AND academicos_cargos.caa_fecha_final >= GETDATE()
			</cfquery>
			<!--- Contador de comisiones --->
			<cfset CC = 0>
			<!--- Contador de licencias --->
			<cfset CL = 0>
			<!--- Generar oficio y lista anexa --->
			<cfoutput group="mov_titulo">
				<cfset HD = 0>
				<!--- Lista de licencias y comisiones --->
				<table id="lyc" width="100%" border="0" cellspacing="0" cellpadding="0">
					<!--- Datos --->	
					<cfoutput>
						<!--- Solo inclir las solicitudes seleccionadas --->
						<cfif ArrayContainsValue(Session.AsuntosCTICFiltro.vMarcadas, #tbSolicitudes.sol_id#) IS TRUE>
							<!--- Si no se ha puesto el encabezado entonces ponerlo --->
							<cfif #HD# IS 0>
								<!--- Titulo de la lista --->
								<tr>
									<td colspan="3" align="left">#Ucase(tbSolicitudes.mov_titulo)#</td>
									<td colspan="3" align="right">#tbSolicitudes.asu_oficio#</td>
								</tr>
								<!--- Línea --->
								<tr><td colspan="6"><hr></td></tr>
								<!--- Encabezados --->
								<tr>
									<td>NOMBRE</td>
									<td>CATEGOR&Iacute;A</td>
									<td>DURACI&Oacute;N</td>
									<td>INICIO</td>
									<td>ACTIVIDAD</td>
									<td>DECISI&Oacute;N</td>
								</tr>
								<!--- Línea --->
								<tr><td colspan="6"><hr></td></tr>
								<!--- Levantar bandera que indica que ya se imprimió el encabezado --->
								<cfset HD = 1>
							</cfif>
							<tr>
								<!--- Nombre del académico --->
								<td>#Trim(tbSolicitudes.acd_prefijo)# #Trim(tbSolicitudes.acd_nombres)# #Trim(tbSolicitudes.acd_apepat)# #Trim(tbSolicitudes.acd_apemat)#</td>
								<!--- Categoría y nivel --->
								<td>#tbSolicitudes.cn_siglas#</td>
								<!--- Duración (en días) --->
								<td>#LsNumberFormat(tbSolicitudes.sol_pos13_d,99)# DIAS</td>
								<!--- Fecha de incio --->
								<td>#LsDateFormat(tbSolicitudes.sol_pos14,'dd/mm/yyyy')#</td>
								<!--- Actividad --->
								<cfquery name="ctActividad" datasource="#vOrigenDatosSAMAA#">
									SELECT * FROM catalogo_actividad
									WHERE activ_clave = #tbSolicitudes.sol_pos12#
								</cfquery>
								<td>#ctActividad.activ_descrip#</td>
								<!--- Recomendación --->
								<cfquery name="tbAsuntosCAAA" datasource="#vOrigenDatosSAMAA#">
									SELECT * FROM movimientos_asunto
									INNER JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave
									WHERE sol_id = #tbSolicitudes.sol_id# AND ssn_id = #vActa# AND asu_reunion = 'CAAA'
								</cfquery>
								<!--- Decisión --->
								<cfquery name="tbAsuntosCTIC" datasource="#vOrigenDatosSAMAA#">
									SELECT * FROM movimientos_asunto
									INNER JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave
									WHERE sol_id = #tbSolicitudes.sol_id# AND ssn_id = #vActa# AND asu_reunion = 'CTIC'
								</cfquery>
								<!--- Como la ST-CTIC genera los oficios antes de que el CTIC emita su decisión, es necesario tomar en su lugar la recomendación de la CAAA --->
								<td>
									<cfif #tbAsuntosCTIC.dec_descrip# IS NOT ''>#tbAsuntosCTIC.dec_descrip#<cfelse>#tbAsuntosCAAA.dec_descrip#</cfif>
								</td>
							</tr>
							<!--- Incrementar los contadores --->
							<cfif #tbSolicitudes.mov_clave# IS 40><cfset CC = CC + 1></cfif>
							<cfif #tbSolicitudes.mov_clave# IS 41><cfset CL = CL + 1></cfif>
						</cfif>
					</cfoutput>
				</table>
				<br><br>
			</cfoutput>
			<!--- Si hay asuntos generar el oficio --->
			<cfif #CC# GT 0 OR #CL# GT 0>	
				<!--- Salto de página --->
				<br class="SaltoPagina">
				<!-- Tabla para situar la firma siempre en el mismo lugar -->	
				<table width="100%" border="0" cellpadding="4" cellspacing="0">
					<tr>
						<td width="100%" height="490" valign="top">
							<!--- Número de oficio y asunto --->
							<p class="OficioAsunto">
								Oficio #tbSolicitudes.asu_oficio#<br>
								Asunto: Licencias y comisiones<br>
								<br><br><br><br><br>
							</p>
							<!--- Dirigido a --->
							<p class="Academico">
								#Trim(tbAcademicosCargos.acd_prefijo)# #Trim(tbAcademicosCargos.acd_nombres)# #Trim(tbAcademicosCargos.acd_apepat)# #Trim(tbAcademicosCargos.acd_apemat)#<br>
								DIRECTOR<cfif #tbAcademicosCargos.acd_sexo# IS 'F'>A</cfif> DEL #Ucase(tbSolicitudes.dep_nombre)#<br>
								Presente
							</p>
							<!--- Texto del oficio --->				
							<p class="Parrafo">
								Comunico a usted que el Consejo T&eacute;cnico de la Investigaci&oacute;n Cient&iacute;fica,
								en su sesi&oacute;n ORDINARIA del #DiaCTIC#,
								con fundamento en el art&iacute;culo 95 inciso B) 
								del Estatuto del Personal Acad&eacute;mico de la UNAM, resolvi&oacute; 
								las solicitudes de licencias y comisiones presentadas con las decisiones que aparecen en la lista anexa.
							</p>
						</td>
					</tr>
					<tr>
						<td width="100%" height="390" valign="top">			
							<!--- Firma --->
							<p class="Firma">
								<br>
								Atentamente<br><br>
								"Por mi raza hablar&aacute; el esp&iacute;ritu"<br>
								Ciudad Universitaria, Cd. Mx. a #FechaCompleta(Now())#
                                <br><br><br><br><br><br>
								#UCASE(tbAcademicosCargosCoord.caa_firma)#<br>
								PRESIDENTE DEL CONSEJO T&Eacute;CNICO DE LA INVESTIGACI&Oacute;N CIENT&Iacute;FICA<br><br><br>
							</p>
							<!--- Pie --->
							<p class="Pie">
								Se anexa lista con:<br>
								<cfif #CL# GT 0>#CL# licencias</cfif><cfif #CL# GT 0 AND #CC# GT 0>,</cfif>
								<cfif #CC# GT 0>#CC# comisiones</cfif>
								<br><br><br><br><br><br>
								C.C.P. CONSEJO INTERNO DE LA ENTIDAD ACADÉMICA<br>
								<br>
								Acta #vActa#<br><br>
								#tbAcademicosCargosCoord.caa_siglas#/BCM
							</p>
						</td>
					</tr>
				</table>
				<!--- Salto de página --->
				<br class="SaltoPagina">
			</cfif>	
		</cfoutput>
	</body>
</html>
