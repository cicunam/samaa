<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 17/06/2010 --->
<!--- FECHA ULTIMA MOD.: 09/01/2023 --->
<!--- ENVIA EL CORREO ELECTRONICO A LOS MIEMBROS DE LA CAAA ASIGNANDO --->

<cfquery name="tbSesion" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM sesiones 
    WHERE ssn_clave = 4 AND ssn_fecha >= GETDATE() 
    ORDER BY ssn_id
</cfquery>

<cfset vSesionActualCaaa = #tbSesion.ssn_id#>

<cfquery name="ctMiembroCAAA" datasource="#vOrigenDatosSAMAA#">
	SELECT ISNULL(T2.acd_prefijo,'') + ' ' + ISNULL(T2.acd_apepat,'') AS vNombre, T1.comision_acd_id, T1.acd_id, T2.acd_email
	FROM (academicos_comisiones AS T1
	LEFT JOIN academicos AS T2 ON T1.acd_id = T2.acd_id)
	WHERE (T1.status = 1 AND T1.comision_clave = 1)
	OR (T1.ssn_id = #vSesionActualCaaa# AND T1.sustitucion = 1)
	ORDER BY T2.acd_apepat, T2.acd_apemat DESC
</cfquery>

<html>
	<head>
		<title>STCTIC - Asuntos Acad&eacute;mico-Administrativos</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<cfoutput>
            <link href="#vCarpetaCSS#/formularios.css" rel="stylesheet" type="text/css">
            <link href="#vCarpetaCSS#/general.css" rel="stylesheet" type="text/css">
            <link href="#vCarpetaCSS#/fuentes.css" rel="stylesheet" type="text/css">
		</cfoutput>            
	</head>
	<body>

		<cfquery name="tbAccesoComisiones" datasource="#vOrigenDatosSAMAA#">
			SELECT * FROM samaa_accesos_comisiones
            WHERE ssn_id = #vSesionActualCaaa#
            AND asu_reunion = 'CAAA'
		</cfquery>
		<!-- LE ASIGNA EL NÚMERO ALEATORIO PARA VISITAR LA PAGINA DE LA CAAA -->
		<cfif #tbAccesoComisiones.RecordCount# EQ 1>
			<cfset vClaveAleatorio = #tbAccesoComisiones.clave_acceso#>
			<cfset vClaveAlfaNum = #tbAccesoComisiones.clave_alfanum#>
		<cfelseif #tbAccesoComisiones.RecordCount# EQ 0>

			<!--- MÓDULO COMÚN PARA LA GENERACIÓN DE LA LLAVES DINÁMICAS DE LAS LIGAS PARA LAS DIFERENTES COMISIONES
			<cfmodule template="#vCarpetaCOMUN#/modulo_genera_claves_acceso.cfm" SsnId="#vSesionActualCaaa#" SsnClave="4" SsnDescrip="CAAA" OrigenDatos="#vOrigenDatosSAMAA#">
			 --->			
        	<!--- REMPLAZAR ESTE CÓDIGO POR EL MÓDULO DE ARRIBA --->
        	
			<cfquery name="tbSysClaves" datasource="#vOrigenDatosSAMAA#">
                SELECT top 1
                newid() AS clave_alfanum,
                RAND() AS 'Random',
                abs(CHECKSUM(newid())) AS clave_acceso
                FROM sys.tables
			</cfquery>

			<cfset vClaveAleatorio = #tbSysClaves.clave_acceso#>
			<cfset vClaveAlfaNum = #tbSysClaves.clave_alfanum#>
        
			<cfquery datasource="#vOrigenDatosSAMAA#">
				INSERT INTO samaa_accesos_comisiones
                (ssn_id, clave_acceso, clave_alfanum, ssn_clave, asu_reunion, email_texto)
               	VALUES 
				(
					#vSesionActualCaaa#, #vClaveAleatorio#, '#vClaveAlfaNum#', 4, 'CAAA',
					<cfif #txtDescripcion# NEQ ''>
                    '#txtDescripcion#'<cfelse>NULL</cfif>
				)
			</cfquery>
		</cfif>

		<table height="" width="100%">
			<tr>
				<td width="180" valign="top">
					<table width="180" border="0">
						<tr>
							<td></td>
						</tr>
						<tr>
							<td></td>
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td><div class="linea_menu"></div></td>
						</tr>
						<tr>
							<td><div align="left" class="Sans10NeNe">Men&uacute;:</div></td>
						</tr>
						<tr>
							<td><input type="button" name="cmdcerrar" value="Cerrar" class="botones" onClick="window.location='caaa_correo.cfm'"></td>
						</tr>
					</table>
				</td>
				<td align="center">
					<cfoutput query="ctMiembroCAAA">
						<cfset vIdAcadCaaa = #comision_acd_id#>
						<cfset vAcdId = #acd_id#>
						<cfset vComisionAcdId = 'chk' & #comision_acd_id#>
						<cfset vAsignaInicio = 'txtIni' & #comision_acd_id#>
						<cfset vAsignaFinal = 'txtFin' & #comision_acd_id#>

						<cfif #CGI.SERVER_PORT# EQ '31221'>
							<cfset vCorreoTo = 'aramp@unam.mx'>
							<cfset vCorreoCc = 'aramp@cic.unam.mx'>
							<cfset vCorreoRTo = 'aramp@unam.mx'>
							<cfset vLigaAppCaaa = '#vCarpetaRaiz#'>
						<cfelse>
							<cfset vCorreoTo = #ctMiembroCAAA.acd_email#>
							<cfset vCorreoCc = 'sectec_ctic@cic.unam.mx'><!--- CAMBIO DE SECRETARIO TÉCNICO DEL CTIC 21/01/2022 --->
							<cfset vCorreoRTo = 'sectec_ctic@cic.unam.mx'><!--- SE AGREGO REPLYTO PARA RESPONDER A LA CUENTA DE bcruz@ Y NO samaa@ --->
							<cfset vLigaAppCaaa = 'https://sesiones-ctic.cic.unam.mx'>                                
						</cfif>

						<cfif IsDefined(vComisionAcdId)>
							<cfmail type="html" from="samaa@cic.unam.mx" to="#vCorreoTo#" cc="#vCorreoCc#" bcc="samaa@cic.unam.mx" replyto="#vCorreoRTo#" subject="#txtAsunto#" username="samaa@cic.unam.mx" password="HeEaSamaa%8282" server="smtp.gmail.com" port="465" useSSL="yes"><!--- cambio de pass el 17/06/2019 --->
							<!---
							<cfmail type="html" to="aramp@unam.mx" from="samaa@cic.unam.mx" subject="#FORM.txtAsunto#" server="correo.cic.unam.mx" username="samaa" password="QQQwww123" server="correo.cic.unam.mx">
							--->
								Estimado(a) #vNombre#:<br>
								<br>
								Por este medio le notifico que los asuntos para la sesión #vSesionActualCaaa# que se revisarán en la Comisión de Asuntos Académico-Administrativos se encuentran disponibles. Para accesar a ellos de un click en la siguiente liga:
								<br><br>
								<a href="#vLigaAppCaaa#/inicia_sesion.cfm?vChargesLt=#vClaveAleatorio#&vDanFautsQb=#vClaveAlfaNum#&vMiembro=#vIdAcadCaaa#&vReunionTipo=CAAA&vSesionActual=#vSesionActualCaaa#" target="WINCAAA">VER ASUNTOS DE LA SESIÓN #vSesionActualCaaa#</a>
								<br><br>o copie y pegue la siguiente liga en el navegador:
								<br><br>#vLigaAppCaaa#/inicia_sesion.cfm?vChargesLt=#vClaveAleatorio#&vDanFautsQb=#vClaveAlfaNum#&vMiembro=#vIdAcadCaaa#&vReunionTipo=CAAA&vSesionActual=#vSesionActualCaaa#
								<br><br>
								Los asuntos delegados a CI y/o CD y que le corresponden revisar son del #Evaluate(vAsignaInicio)# al #Evaluate(vAsignaFinal)# y se encuentran marcados con un una paloma. Además, en otra pestaña de la página principal se encuentran los asuntos sujetos a decisión del CTIC y en otra los objetados. los que deberán ser analizados por el pleno de la comisión.
								<br><br>
								<cfif #FORM.txtDescripcion# NEQ ''>
								#FORM.txtDescripcion#
								<br><br>
								</cfif>
								Sin más por el momento, reciban un cordial saludo.
							</cfmail>

							<!-- DESPLIEGA EL CORREO ELECTRONICO ENVIADO -->
							<table width="80%" >
								<tr>
									<td>
										<span class="Sans12GrNe">CORREO ENVIADO</span><br><br>
										<span class="Sans9GrNe">
										Estimado(a) #vNombre#:<br>
										<br>
										Por este medio le notifico que los asuntos para la sesión #vSesionActualCaaa# que se revisarán en la Comisión de Asuntos Académico-Administrativos se encuentran disponibles. Para acceder a ellos de un click en la siguiente liga:
										<br>
										<br>
										<a href="#vLigaAppCaaa#/inicia_sesion.cfm?vChargesLt=#vClaveAleatorio#&vDanFautsQb=#vClaveAlfaNum#&vMiembro=#vIdAcadCaaa#&vReunionTipo=CAAA&vSesionActual=#vSesionActualCaaa#" target="WINCAAA">VER ASUNTOS DE LA SESIÓN #vSesionActualCaaa#</a>
										<br><br>o copie y pegue la siguiente liga en el navegador:
										<br><br>#vLigaAppCaaa#/inicia_sesion.cfm?vChargesLt=#vClaveAleatorio#&vDanFautsQb=#vClaveAlfaNum#&vMiembro=#vIdAcadCaaa#&vReunionTipo=CAAA&vSesionActual=#vSesionActualCaaa#
										<br><br>
	<!--- POR INSTRUCCIONES DE LA LIC. BEATRIZ CRUZ SE ELIMINA ESTE PÁRRAFO 11/10/2019
										Los asuntos delegados a CI y/o CD y que le corresponden revisar son del #Evaluate(vAsignaInicio)# al #Evaluate(vAsignaFinal)#  y se encuentran marcados con color. Además, en otra pestaña de la página principal se encuentran los asuntos sujetos a decisión del CTIC y en otra los objetados. los que deberán ser analizados por el pleno de la comisión.
										<br><br>
	--->									
											<cfif #FORM.txtDescripcion# NEQ ''>
											#FORM.txtDescripcion#
											<br><br>
											</cfif>
										Sin más por el momento, reciban un cordial saludo.
										</span>
									</td>
								</tr>
								<tr>                
									<td>
										<hr>
									</td>
								</tr>
							</table>
							<!-- SELECCIONA LOS ASUINTOS QUE SE DISTRIBUIRAN ENTRE EL MIEMBRO -->
							<cfquery name="tbSolicitudCaaa"  datasource="#vOrigenDatosSAMAA#">
								SELECT * FROM (movimientos_solicitud AS T1
								LEFT JOIN movimientos_asunto AS T2 ON T1.sol_id = T2.sol_id AND T2.asu_reunion = 'CAAA')
								LEFT JOIN movimientos_solicitud_comision AS T3 ON T1.sol_id = T3.sol_id
								WHERE T2.ssn_id = #vSesionActualCaaa#
								<!--- AND T2.asu_reunion = 'CAAA'--->
								AND T2.asu_parte = 1 
								AND T2.asu_numero BETWEEN #Evaluate(vAsignaInicio)# AND #Evaluate(vAsignaFinal)#
								ORDER BY T1.sol_id
							</cfquery>

							<!-- MARCA EN LA BASE DE DATOS LOS ASUNTOS QUE LE CORRESPONDEN AL MIEMBRO DE LA CAAA -->
							<cfloop query="tbSolicitudCaaa">

								<cfset vSolIdTemp = #tbSolicitudCaaa.sol_id#>
								<cfif #CGI.SERVER_PORT# EQ '31221'>#vIdAcadCaaa# - #vSolIdTemp# - #vSesionActualCaaa#<br></cfif>

								<cfquery name="tbSolicitudCaaaTemp" datasource="#vOrigenDatosSAMAA#">
									SELECT * FROM movimientos_solicitud_comision 
									WHERE sol_id = #vSolIdTemp#
									AND ssn_id = #vSesionActualCaaa#
								</cfquery>

								<cfif #tbSolicitudCaaaTemp.RecordCount# EQ 0>
									<cfquery datasource="#vOrigenDatosSAMAA#">
										INSERT INTO movimientos_solicitud_comision 
										(comision_acd_id, sol_id, ssn_id) 
										VALUES 
										(#vIdAcadCaaa#, #vSolIdTemp#, #vSesionActualCaaa#)
									</cfquery>
								<cfelseif #tbSolicitudCaaaTemp.RecordCount# EQ 1>
									<cfquery datasource="#vOrigenDatosSAMAA#">
										UPDATE movimientos_solicitud_comision SET
										comision_acd_id = #vIdAcadCaaa#
										WHERE sol_id = #vSolIdTemp# 
										AND ssn_id = #vSesionActualCaaa#
									</cfquery>
								</cfif>
							</cfloop>

							<cfquery name="tbCorreosCaaa" datasource="#vOrigenDatosSAMAA#">
								SELECT* FROM caaa_email 
								WHERE ssn_id = #tbSesion.ssn_id# 
								AND comision_acd_id = #vIdAcadCaaa#
							</cfquery>

							<cfquery datasource="#vOrigenDatosSAMAA#">
								<cfif #tbCorreosCaaa.RecordCount# EQ 0>
									INSERT INTO caaa_email 
									(ssn_id, comision_acd_id, acd_id, acd_email, sol_inicio, sol_final, fecha_email) 
									VALUES
									(#vSesionActualCaaa#, #vIdAcadCaaa#, #vAcdId#, '#ctMiembroCAAA.acd_email#', #Evaluate(vAsignaInicio)#, #Evaluate(vAsignaFinal)#, GETDATE())
								<cfelseif #tbCorreosCaaa.RecordCount# EQ 1>
									UPDATE caaa_email SET
									sol_inicio = #Evaluate(vAsignaInicio)#
									, 
									sol_final = #Evaluate(vAsignaFinal)#
									,
									acd_email = '#ctMiembroCAAA.acd_email#'
									,
									fecha_email = GETDATE()
									WHERE ssn_id = #tbSesion.ssn_id# 
									AND comision_acd_id = #vIdAcadCaaa#
								</cfif>
							</cfquery>
						</cfif>
					</cfoutput>
			  </td>
		  </tr>
		</table>
	</body>   
</html>