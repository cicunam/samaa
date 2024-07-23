<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 27/04/2020 --->
<!--- FECHA ÚLTIMA MOD.: 27/04/2020 --->

<!-- LLMADO A LA COSULTA DE CARGOS ACADEMICO-ADMINISTRATIVOS Y CONTIENE A LOS MIEMBROS DEL CTIC -->
<cfinclude template="include_llamado_bd.cfm"></cfinclude>

<cfinclude template="clpctic_genera_liga.cfm"></cfinclude>

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
							<td><input type="button" name="cmdcerrar" value="Cerrar" class="botones" onClick="window.location='correo_liga_pleno_inicio.cfm'"></td>
						</tr>
					</table>
				</td>
				<td align="center">
					<cfoutput query="csMiembrosPleno">
						<cfset vCaaPlenoId = #caa_id#>
						<cfset vAcdId = #acd_id#>

						<cfif #CGI.SERVER_PORT# EQ '31221'>
							<cfif #FIND('@',acd_email)# GT 0 AND #FIND('@',caa_email)# GT 0>
								<cfset vCorreoTo = 'aramp@unam.mx; aramp@cic.unam.mx'>
							<cfelseif #FIND('@',acd_email)# GT 0 AND #FIND('@',caa_email)# EQ 0>
								<cfset vCorreoTo = 'aramp@unam.mx'>
							<cfelseif #FIND('@',acd_email)# EQ 0 AND #FIND('@',caa_email)# GT 0>
								<cfset vCorreoTo = 'aramp@cic.unam.mx'>								
							</cfif>							
							<cfset vCorreoCc = 'aramp@cic.unam.mx'>
							<cfset vCorreoRTo = 'aramp@unam.mx'>
						<cfelse>
							<cfif #FIND('@',acd_email)# GT 0 AND #FIND('@',caa_email)# GT 0>
								<cfset vCorreoTo = '#acd_email#; #caa_email#'>
							<cfelseif #FIND('@',acd_email)# GT 0 AND #FIND('@',caa_email)# EQ 0>
								<cfset vCorreoTo = '#acd_email#'>
							<cfelseif #FIND('@',acd_email)# EQ 0 AND #FIND('@',caa_email)# GT 0>
								<cfset vCorreoTo = '#caa_email#'>								
							</cfif>
							<cfset vCorreoCc = 'bcruz@unam.mx'>
							<cfset vCorreoRTo = 'bcruz@unam.mx'><!--- SE AGREGO REPLYTO PARA RESPONDER A LA CUENTA DE bcruz@ Y NO samaa@ --->
						</cfif>

						<cfif IsDefined('vCaaPlenoId') AND #vCaaPlenoId# GT 0>
							<cfmail type="html" from="samaa@cic.unam.mx" to="#vCorreoTo#" cc="#vCorreoCc#" bcc="samaa@cic.unam.mx" replyto="#vCorreoRTo#" subject="#txtAsunto#" username="samaa@cic.unam.mx" password="HeEaSamaa%8282" server="smtp.gmail.com" port="465" useSSL="yes"><!--- cambio de pass el 17/06/2019 --->
								Estimado(a) #nombre_completo_pmn#:<br>
								<br>
								Por este medio le notifico que los asuntos para la sesión #vSesionActualPleno# del Pleno del CTIC se encuentran disponibles. Para acceder a ellos de un click en la siguiente liga:
								<br><br>
								<a href="#Application.vCarpetaRaiz#/inicia_sesion.cfm?vChargesLt=#vClaveAleatorio#&vDanFautsQb=#vClaveAlfaNum#&vMiembro=PCTIC_#vSesionActualPleno#&vReunionTipo=PCTIC&vSesionActual=#vSesionActualPleno#" target="WINPLENO#vSesionActualPleno#">VER ASUNTOS DE LA SESIÓN #vSesionActualPleno#</a>
								<br><br>o copie y pegue el siguiente texto en el navegador:
								<br><br>#Application.vCarpetaRaiz#/inicia_sesion.cfm?vChargesLt=#vClaveAleatorio#&vDanFautsQb=#vClaveAlfaNum#&vMiembro=PCTIC_#vSesionActualPleno#&vReunionTipo=PCTIC&vSesionActual=#vSesionActualPleno#
								<br><br>
								<cfif #FORM.txtDescripcion# NEQ ''>
									#FORM.txtDescripcion#
									<br><br>
								</cfif>
								Sin m&aacute;s por el momento, reciban un cordial saludo.
							</cfmail>

							<!-- DESPLIEGA EL CORREO ELECTRONICO ENVIADO -->
							<table width="80%" >
								<tr>
									<td>
										<span class="Sans12GrNe">CORREO ENVIADO</span><br><br>
										<span class="Sans9GrNe">
											Estimado(a) #nombre_completo_pmn#:<br>
											<br>
											Por este medio le notifico que los asuntos para la sesión #vSesionActualPleno# del Pleno del CTIC se encuentran disponibles. Para acceder a ellos de un click en la siguiente liga:
											<br>
											<br>
											<a href="#Application.vCarpetaRaiz#/inicia_sesion.cfm?vChargesLt=#vClaveAleatorio#&vDanFautsQb=#vClaveAlfaNum#&vMiembro=PCTIC_#vSesionActualPleno#&vReunionTipo=PCTIC&vSesionActual=#vSesionActualPleno#" target="WINPLENO#vSesionActualPleno#">VER ASUNTOS DE LA SESIÓN #vSesionActualPleno#</a>
											<br><br>o copie y pegue le siguiente texto en el navegador:
											<br><br>#Application.vCarpetaRaiz#/inicia_sesion.cfm?vChargesLt=#vClaveAleatorio#&vDanFautsQb=#vClaveAlfaNum#&vMiembro=PCTIC_#vSesionActualPleno#&vReunionTipo=PCTIC&vSesionActual=#vSesionActualPleno#
											<br><br>
											<cfif #txtDescripcion# NEQ ''>
												#txtDescripcion#
												<br><br>
											</cfif>
											Sin m&aacute;s por el momento, reciba un cordial saludo.
										</span>
									</td>
								</tr>
								<tr>                
									<td><hr></td>
								</tr>
							</table>
						</cfif>		
					</cfoutput>
				</td>
			</tr>
		</table>
	</body>   
</html>			
