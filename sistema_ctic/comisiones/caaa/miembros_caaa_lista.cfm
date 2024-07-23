<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA: 21/10/2009 --->
<!--- LISTA DE MIEMBROS DE AL CAAA --->
<!--- Parámetros --->
<cfparam name="vTipoCargoAdmin" default="">
<cfparam name="vComisionClave" default=0>
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfparam name="PageNum" default="1">

<cfquery name="tbSesionCaaa" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM sesiones WHERE ssn_clave = 4 AND ssn_fecha >= GETDATE() ORDER BY ssn_id
</cfquery>

<cfset vSesionActualCaaa = #tbSesionCaaa.ssn_id#>

<cfquery name="tbComision" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM ((academicos_comisiones
	LEFT JOIN academicos ON academicos_comisiones.acd_id = academicos.acd_id)
	LEFT JOIN catalogo_comisiones ON academicos_comisiones.comision_clave = catalogo_comisiones.comision_clave)
	WHERE (academicos_comisiones.status) = 1 OR (academicos_comisiones.ssn_id = #vSesionActualCaaa#)
	<cfif #vComisionClave# GT 1>
		AND academicos_comisiones.comision_clave = #vComisionClave#
	</cfif>
	ORDER BY academicos_comisiones.comision_clave ASC, academicos.acd_apepat, academicos.acd_apemat DESC
</cfquery>

<cfquery name="tbCatalogoComision" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_comisiones
	ORDER BY comision_nombre
</cfquery>

<html>
	<head>
		<title>STCTIC - Miembros del CTIC</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href="<cfoutput>#vCarpetaCSS#</cfoutput>/formularios.css" rel="stylesheet" type="text/css">
		<link href="<cfoutput>#vCarpetaCSS#</cfoutput>/general.css" rel="stylesheet" type="text/css">
		<link href="<cfoutput>#vCarpetaCSS#</cfoutput>/fuentes.css" rel="stylesheet" type="text/css">
		<script type="text/javascript">
			function fNuevaComisionAcad()
			{
				window.location.replace('miembro_caaa.cfm?vTipoComando=NUEVO')
			}
			function fEnviaCorreo()
			{
				window.location.replace('caaa_correo.cfm')
			}
		</script>
	</head>
	<body>
		<!-- Cintillo con nombre del módulo y filtro--> 
		<table class="Cintillo">
			<tr>
				<td><span class="Sans9GrNe">COMISIÓN DE ASUNTOS ACADÉMICO-ADMINISTRATIVOS</span></td>
				<td align="right"><cfinclude template="#vCarpetaINCLUDE#/sesion_vigente.cfm"></td>
			</tr>
		</table>
		<!-- Contenido -->
		<table width="1024" border="0">
			<tr>
				<!-- Columna izquierda (comandos) --> 
				<td width="180" valign="top">
					<!-- Controles -->
					<table width="155" border="0">
						<!-- Menú de la lista de sesiones -->
						<tr><td><div class="linea_menu"></div></td></tr>
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">Men&uacute;:</div></td>
						</tr>
						<!-- Opción: Nuevo cargo -->
						<tr>
							<td valign="top">
								<input name="button" type="button" class="botones" onClick="fNuevaComisionAcad();" value="Nuevo miembro CAAA">
							</td>
						</tr>
						<tr>
							<td valign="top">
								<input name="button" type="button" class="botones" onClick="" value="Imprimir relación" disabled>
							</td>
						</tr>
						<!-- Contador de registros -->
						<tr><td valign="top"><br><div class="linea_menu"></div></td></tr>
						<tr>
							<td valign="top">
								<span class="Sans9GrNe">Total: </span>
								<span class="Sans9Gr">
									<cfoutput>#tbComision.RecordCount#</cfoutput>
								</span>
							</td>
						</tr>
					</table>
				</td>
				<!-- Columna derecha (listado) -->
				<td width="844" valign="top">
				    <!-- Lista de consejeros -->
					<table style="width: 800px;  margin: 10px 0px 10px 15px; border: none" cellspacing="0" cellpadding="1">
						<tr valign="middle" bgcolor="#CCCCCC" style="height: 18px;">
							<td width="72%"><span class="Sans9GrNe">NOMBRE</span></td>
							<td width="10%">&nbsp;</td>
							<td width="15%"><span class="Sans9GrNe">FECHA INICIO</span></td>
							<td width="3%" bgcolor="#0066FF"></td>
						</tr>
						<cfoutput query="tbComision">
						<tr onMouseOver="this.style.backgroundColor='##E8E8E8'" onMouseOut="this.style.backgroundColor='##FFFFFF'">
							<td valign="top"><span class="Sans9Gr">#tbComision.acd_prefijo# #tbComision.acd_apepat# #tbComision.acd_apemat#, #tbComision.acd_nombres#</span></td>
							<td valign="top">
                            	<span class="Sans9Gr">
                            	<cfif #presidente# EQ 1>Presidente</cfif>
                            	<cfif #sustitucion# EQ 1>Sustituto</cfif>
								</span>
							</td>
							<td valign="top"><span class="Sans9Gr">#LsDateFormat(tbComision.fecha_inicio,'dd/mm/yyyy')#</span></td>
							<!-- Botón VER -->
							<td align="center"><a href="miembro_caaa.cfm?vComisionId=#tbComision.comision_acd_id#&vTipoComando=CONSULTA"><img src="#vCarpetaICONO#/detalle_15.jpg" style="border:none;"></a></td>
						</tr>
						</cfoutput>
					</table>
				</td>
			</tr>
		</table>
	</body>
</html>
