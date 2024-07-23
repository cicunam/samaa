<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA: 21/04/2009 --->
<!--- FT-CTIC-25.-Contrato bajo condiciones similares al anterior --->

<!--- Incluir los siguientes archivos --->
<cfif #vTipoComando# EQ 'IMPRIME_EJEMPLO'>
	<cfinclude template="ft_campos_blanco.cfm"> <!---PERIMITE IMPRIMIR LA FT EN BLANCO --->
	<cfset vTipoComando = 'IMPRIME'>
<cfelse>
	<cfinclude template="ft_campos.cfm">
</cfif>
<cfinclude template="ft_scripts_valida.cfm">
<cfinclude template="ft_scripts_ajax.cfm">
<cfinclude template="ft_scripts_varios.cfm">
<!--- Obtener la lista de ubicaciones de la dependencia --->
<cfquery name="ctUbicacion" datasource="#vOrigenDatosSAMAA#">
	SELECT *, dbo.TRIM(ubica_nombre) + ', ' + dbo.TRIM(ubica_lugar) AS ubica_completa FROM catalogo_dependencia_ubica
	WHERE dep_clave = '#vCampoPos1#' AND ubica_status = 1
	ORDER BY ubica_clave
</cfquery>
<!--- Obtener los datos del COA --->
<cfquery name="tbMovimientosCOA" datasource="#vOrigenDatosSAMAA#">
	SELECT TOP 1 *
	FROM (movimientos
	LEFT JOIN movimientos_asunto ON movimientos.sol_id = movimientos_asunto.sol_id)
	LEFT JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave
	WHERE acd_id = #vIdAcad#
	AND (mov_clave = 5 OR mov_clave = 17)
	AND asu_reunion = 'CTIC'
	AND dec_super = 'AP' <!--- Asuntos aprobados --->
	ORDER BY mov_fecha_inicio DESC
</cfquery>
<!--- Obtener los datos de la última promoción --->
<cfquery name="tbMovimientosPRO" datasource="#vOrigenDatosSAMAA#">
	SELECT TOP 1 *
	FROM (movimientos
	LEFT JOIN movimientos_asunto ON movimientos.sol_id = movimientos_asunto.sol_id)
	LEFT JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave
	WHERE acd_id = #vIdAcad#
	AND (mov_clave = 9 OR mov_clave = 10)
	AND mov_cn_clave = '#tbMovimientosCOA.mov_cn_clave#'
	AND asu_reunion = 'CTIC'
	AND dec_super = 'AP' <!--- Asuntos aprobados --->
	ORDER BY mov_fecha_inicio DESC
</cfquery>
<!--- Obtener el número de renovación correspondiente --->
<cfquery name="tbMovimientosREN" datasource="#vOrigenDatosSAMAA#">
	SELECT *
	FROM (movimientos
	LEFT JOIN movimientos_asunto ON movimientos.sol_id = movimientos_asunto.sol_id)
	LEFT JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave
	WHERE acd_id = #vIdAcad#
	AND mov_clave = 25
	<cfif tbMovimientosPRO.RecordCount GT 0> AND mov_fecha_inicio > '#LsdateFormat(tbMovimientosPRO.mov_fecha_inicio,'dd/mm/yyyy')#'
	<cfelseif tbMovimientosPRO.RecordCount EQ 0> AND mov_fecha_inicio > '#LsdateFormat(tbMovimientosCOA.mov_fecha_inicio,'dd/mm/yyyy')#'
	</cfif>
	AND asu_reunion = 'CTIC'
	AND dec_super = 'AP' <!--- Asuntos aprobados --->
	ORDER BY mov_fecha_inicio DESC
</cfquery>
<!--- Registrar el movimiento anterior (por compatibilidad con los datos históricos) --->
<cfif #vCampoPos12# EQ ''>
	<cfif #tbMovimientosREN.RecordCount# GT 0>
		<cfset vCampoPos12=#tbMovimientosREN.mov_id#>
	<cfelseif #tbMovimientosCOA.RecordCount# GT 0>
		<cfset vCampoPos12=#tbMovimientosCOA.mov_id#>
	</cfif>
</cfif>
<!--- Asignar la fecha en que ganó el COA --->
<cfif #vCampoPos21# EQ ''>
	<cfset vCampoPos21=#LsdateFormat(tbMovimientosCOA.mov_fecha_inicio,'dd/mm/yyyy')#>
</cfif>
<!--- Asignar la fecha de la última promoción --->
<cfif #vCampoPos22# EQ ''>
	<cfset vCampoPos22=#LsdateFormat(tbMovimientosPRO.mov_fecha_inicio,'dd/mm/yyyy')#>
</cfif>
<!--- Asignar la fecha de inicio del siguiente contrato --->
<cfif #vCampoPos14# EQ ''>
	<cfif tbMovimientosPRO.RecordCount GT 0>
		<cfif tbMovimientosREN.RecordCount GT 0>
			<cfset vCampoPos14=#LsdateFormat(DateAdd("yyyy", 1, tbMovimientosREN.mov_fecha_inicio),'dd/mm/yyyy')#>
		<cfelse>
			<cfset vCampoPos14=#LsdateFormat(DateAdd("yyyy", 1, tbMovimientosPRO.mov_fecha_inicio),'dd/mm/yyyy')#>
		</cfif>
	<cfelseif tbMovimientosCOA.RecordCount GT 0>
		<cfif tbMovimientosREN.RecordCount GT 0>
			<cfset vCampoPos14=#LsdateFormat(DateAdd("yyyy", 1, tbMovimientosREN.mov_fecha_inicio),'dd/mm/yyyy')#>
		<cfelse>
			<cfset vCampoPos14=#LsdateFormat(DateAdd("yyyy", 1, tbMovimientosCOA.mov_fecha_inicio),'dd/mm/yyyy')#>
		</cfif>
	</cfif>
</cfif>
<!--- Asignar el número de renovaciones de contrato --->
<cfif #vCampoPos17# EQ ''>
	<cfset vCampoPos17=#tbMovimientosREN.RecordCount# + 1>
</cfif>
<html>
	<head>
		<title>STCTIC - Asuntos Acad&eacute;mico-Administrativos</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href="<cfoutput>#vCarpetaCSS#</cfoutput>/formularios.css" rel="stylesheet" type="text/css">
		<link href="<cfoutput>#vCarpetaCSS#</cfoutput>/general.css" rel="stylesheet" type="text/css">
		<link href="<cfoutput>#vCarpetaCSS#</cfoutput>/fuentes.css" rel="stylesheet" type="text/css">
		<cfif #vTipoComando# IS 'IMPRIME' AND #vSolStatus# GT 3>
			<style type="text/css">
				body {
					background-image:url(<cfoutput>#vCarpetaIMG#/iPreliminar.gif</cfoutput>);
					background-position:center;
				}
			</style>
		</cfif>
		<script type="text/javascript">
			// Actaukuzar el formulario:
			function fActualizar()
			{
				CalcularSiguienteFecha();
			}
			// Validar los datos ingresados por el usuario:
			function fValidaCamposFt()
			{
				var vMensaje = '';
				fLimpiaValida();
				vMensaje += fValidaCampoLleno('pos1_u','UBICACIÓN');
				vMensaje += fValidaFecha('pos14','INICIO');
				if (document.getElementById('pos22').value)
				{
					vMensaje += fValidaFechaPosterior('pos14','pos22') ? '': 'La fecha de INICIO debe ser posterior que la fecha de la última promoción.\n';
				}
				else
				{
					vMensaje += fValidaFechaPosterior('pos14','pos21') ? '': 'La fecha de INICIO debe ser posterior que la fecha en que ganó el COA.\n';
				}
				vMensaje += document.getElementById('pos12').value != '' ? '': 'No se encontró ningún contrato anterior.\n';
				if (vMensaje.length > 0)
				{
					alert(vMensaje);
					return false;
				}
				else
				{
					return true;
				}
			}
		</script>
	</head>
	<body onLoad="fActualizar();">
		<!--- IFRAME PARA EL ENVIO DE DOCUMENTOS DIGITALIZADOS (PDF) --->
		<iframe scrolling="no" class="EmergenteArchivo" frameborder="no" name="ifrmSelArchivo" id="ifrmSelArchivo" src="enviar_pdf/ft_archivo_selecciona.cfm?&vIdSol=<cfoutput>#vIdSol#</cfoutput>" style="display:none;"></iframe>
		<cfform name="form" method="POST" enctype="multipart/form-data" action="#vRutaPagSig#">
		<!-- Cintillo con nombre y número de forma telegrámica -->
		<table class="Cintillo">
			<tr>
				<td width="690"><span class="Sans9GrNe">SOLICITUDES &gt;&gt; </span><cfoutput><span class="Sans9Gr">#vTipoComando#</span></cfoutput></td>
				<td width="100" align="right"><cfoutput><span class="Sans9GrNe">FT-CTIC-#vFt#</span></cfoutput></td>
			</tr>
		</table>
		<!-- Forma telegrámica -->
		<table width="790" border="0">
			<tr>
				<!-- Menú lateral -->
				<cfif #vTipoComando# IS NOT 'IMPRIME'>
					<td valign="top">
						<iframe id="MenuLateral" src="ft_menu.cfm?&vTipoComando=<cfoutput>#vTipoComando#</cfoutput>&vIdAcad=<cfoutput>#vIdAcad#</cfoutput>&vFt=<cfoutput>#vFt#</cfoutput>&vSolStatus=<cfoutput>#vSolStatus#</cfoutput>&vDevuelta=<cfoutput>#vDevuelta#</cfoutput>
						<cfif #vTipoComando# EQ 'EDITA' OR #vTipoComando# EQ 'CONSULTA'>&vIdSol=<cfoutput>#vIdSol#</cfoutput></cfif>
						" frameborder="no" scrolling="false"></iframe>
					</td>
				</cfif>
				<!-- Formulario -->
				<td class="formulario">
					<!-- Titulo de la forma telegrámica -->
					<cfoutput>
					<p align="center">
					<span class="Sans12GrNe">#ctMovimiento.mov_titulo#</span>
					<br>
					<cfif #ctMovimiento.mov_subtitulo# NEQ ''><span class="Sans9Gr">#ctMovimiento.mov_subtitulo#</span></cfif>
					<cfif #ctMovimiento.mov_clase# NEQ ''><br><span class="Sans9Gr">#ctMovimiento.mov_clase#</span></cfif>
					<cfif #vTipoComando# IS 'IMPRIME'><br><br></cfif>
					</p>
					</cfoutput>
					<!-- Campos ocultos -->
					<cfinput name="vFt" id="vFt" type="hidden"value="#vFt#">
					<cfinput name="vIdAcad" type="hidden" id="vIdAcad" value="#vIdAcad#">
					<cfinput name="vTipoComando" type="hidden" id="vTipoComando">
					<cfinput name="vIdSol" type="hidden" value="#vIdSol#">
					<cfinput name="vSolStatus" type="hidden" value="#vSolStatus#">
					<!-- Registrar el movimiento anterior (por compatibilidad con los datos históricos -->
					<cfinput name="pos12" type="hidden" value="#vCampoPos12#">
					<!-- Datos para ser llenados por la ST-CTIC -->
					<cfif #Session.sTipoSistema# IS 'stctic' AND #vSolStatus# LT 3 AND #vTipoComando# IS NOT 'NUEVO' AND #vTipoComando# IS NOT 'IMPRIME'>
						<cfinclude template="ft_control.cfm">
					</cfif>
					<!-- Datos generales -->
					<cfoutput>
					<table width="620" height="53" border="0" class="cuadros">
						<!-- Dependencia -->
						<tr>
							<td width="20%"><span class="Sans9GrNe">#ctMovimiento.mov_pos1#</span></td>
							<td width="80%">
								<cfif #vTipoComando# IS 'IMPRIME'>
									<span class="Sans9Gr">#vCampoPos1_txt#</span>
								<cfelse>
									<cfinput name="pos1_txt" id="pos1_txt" type="text" class="datos100" value="#vCampoPos1_txt#" disabled>
									<cfinput name="pos1" id="pos1" type="hidden" value="#vCampoPos1#">
								</cfif>
							</td>
						</tr>
						<!-- Ubicación -->
						<tr>
							<td><span class="Sans9GrNe">#ctMovimiento.mov_pos1_u#</span></td>
							<td>
								<cfif #vTipoComando# IS 'IMPRIME'>
									<cfloop query="ctUbicacion">
										<cfif #ubica_clave# IS #vCampoPos1_u#>
											<cfset vCampoPos1_u_txt = '#ubica_completa#'>
											<cfbreak>
										</cfif>
									</cfloop>
									<span class="Sans9Gr">#vCampoPos1_u_txt#</span>
								<cfelse>
									<cfselect name="pos1_u" class="datos" id="pos1_u" query="ctUbicacion" value="ubica_clave" display="ubica_completa" queryPosition="below" selected="#vCampoPos1_u#" style="width:480px" disabled='#vActivaCampos#'>
									<cfif #ctUbicacion.RecordCount# GT 1>
										<option value="">SELECCIONE</option>
									</cfif>
									</cfselect>
								</cfif>
							</td>
						</tr>
						<!-- Académico -->
						<tr>
							<td><span class="Sans9GrNe">#ctMovimiento.mov_pos2#</span></td>
							<td>
								<cfif #vTipoComando# IS 'IMPRIME'>
									<span class="Sans9Gr">#vCampoPos2_txt#</span>
								<cfelse>
									<cfinput name="pos2_txt" id="pos2_txt" type="text" class="datos100" value="#vCampoPos2_txt#" disabled>
									<cfinput name="pos2" id="pos2" type="hidden" value="#vCampoPos2#">
								</cfif>
							</td>
						</tr>
					</table>
					</cfoutput>
					<!-- Datos obtenidos por el sistema -->
					<cfoutput>
					<table width="620" height="42" border="0" class="cuadros">
						<!-- Categoría y nivel -->
						<tr>
							<td width="20%"><span class="Sans9GrNe">#ctMovimiento.mov_pos3#</span></td>
							<td width="80%" colspan="2">
								<cfif #vTipoComando# IS 'IMPRIME'>
									<span class="Sans9Gr">#vCampoPos3_txt#</span>
								<cfelse>
									<cfinput name="pos3_txt" id="pos3_txt" type="text" class="datos" size="20" value="#vCampoPos3_txt#" disabled>
									<cfinput name="pos3" id="pos3" type="hidden" value="#vCampoPos3#">
								</cfif>
							</td>
						</tr>
						<tr>
							<!-- Antigüedad académica -->
							<td><span class="Sans9GrNe">#ctMovimiento.mov_pos6#</span></td>
							<td>
								<cfif #vTipoComando# IS 'IMPRIME'>
									<span class="Sans9Gr">#vCampoPos6_txt#</span>
								<cfelse>
									<cfinput name="pos6_txt" id="pos6_txt" type="text" class="datos" size="30" value="#vCampoPos6_txt#" disabled>
									<cfinput name="pos6" id="pos6" type="hidden" value="#vCampoPos6#">
								</cfif>
							</td>
							<!-- Primer contrato -->
							<td align="right">
								<span class="Sans9GrNe">#ctMovimiento.mov_pos7#</span>
								<cfif #vTipoComando# IS 'IMPRIME'>
									<span class="Sans9Gr">#FechaCompleta(vCampoPos7)#&nbsp;</span>
								<cfelse>
									<cfinput name="pos7" id="pos7" type="text" class="datos" size="10" value="#vCampoPos7#" disabled>
								</cfif>
							</td>
						</tr>
					</table>
					</cfoutput>
					<!-- Datos que deben ingresarse -->
					<cfoutput>
					<table width="620" border="0" align="center" class="cuadros">
						<!-- Fecha en que ganó el concurso abierto -->
						<tr>
							<td width="25%"><span class="Sans9GrNe">#ctMovimiento.mov_pos21# </span></td>
							<td width="75%">
								<cfif #vTipoComando# IS 'IMPRIME'>
									<span class="Sans9Gr">#FechaCompleta(vCampoPos21)#</span>
								<cfelse>
									<cfinput name="pos21" id="pos21" type="text" class="datos" size="10" maxlength="10" disabled="true" value="#vCampoPos21#">
								</cfif>
							</td>
						</tr>
						<!-- Fecha de la última promoción -->
						<tr>
							<td><span class="Sans9GrNe">#ctMovimiento.mov_pos22# </span></td>
							<td>
								<cfif #vTipoComando# IS 'IMPRIME'>
									<span class="Sans9Gr">#FechaCompleta(vCampoPos22)#</span>
								<cfelse>
									<cfinput name="pos22" id="pos22" type="text" class="datos" size="10" maxlength="10" disabled="true" value="#vCampoPos22#">
								</cfif>
							</td>
						</tr>
						<!-- Duración -->
						<!-- Se remplazó el código original por duración año(s), mes(es) y día(s) -->
						<tr>
							<td width="25%"><span class="Sans9GrNe">#ctMovimiento.mov_pos13#</span></td>
							<td width="75%">
								<cfif #vTipoComando# IS 'IMPRIME'>
									<span
										<cfif #vCampoPos13_a# EQ 0>class="NoImprimir"</cfif>
									>
									<span class="Sans9Gr">
										#vCampoPos13_a# #ctMovimiento.mov_pos13_a#&nbsp;
									</span>
									</span>
									<span
									<cfif #vCampoPos13_m# EQ 0>class="NoImprimir"</cfif>
										>
									<span class="Sans9Gr">
										#vCampoPos13_m# #ctMovimiento.mov_pos13_m#&nbsp;
									</span>
									</span>
									<span
										<cfif #vCampoPos13_d# EQ 0>class="NoImprimir"</cfif>
									>
									<span class="Sans9Gr">#vCampoPos13_d# #ctMovimiento.mov_pos13_d#&nbsp;</span>
									</span>
								<cfelse>
									<span
										<cfif #vCampoPos13_a# EQ 0>class="NoImprimir"</cfif>
									><cfinput type="text" name="pos13_a" disabled='#vActivaCampos#' class="datos" id="pos13_a" onChange="CalcularSiguienteFecha();" value="#vCampoPos13_a#" size="1" maxlength="1" onkeypress="return MascaraEntrada(event, '9');">
									<span class="Sans9Gr">#ctMovimiento.mov_pos13_a#</span>
									</span>
									<span
										<cfif #vCampoPos13_m# EQ 0>class="NoImprimir"</cfif>
									><cfinput type="text" name="pos13_m" disabled='#vActivaCampos#' class="datos" id="pos13_m" onChange="CalcularSiguienteFecha();" value="#vCampoPos13_m#" size="2" maxlength="2" onkeypress="return MascaraEntrada(event, '99');">
									<span class="Sans9Gr">#ctMovimiento.mov_pos13_m#</span>
									</span>
									<span
									<cfif #vCampoPos13_d# EQ 0>class="NoImprimir"</cfif>
									><cfinput type="text" name="pos13_d" disabled='#vActivaCampos#' class="datos" id="pos13_d" onChange="CalcularSiguienteFecha();" value="#vCampoPos13_d#" size="2" maxlength="2" onkeypress="return MascaraEntrada(event, '99');">
									<span class="Sans9Gr">#ctMovimiento.mov_pos13_d#</span>
									</span>
								</cfif>
								<!-- Fechas -->
								<span class="Sans9Gr">#MID(ctMovimiento.mov_pos14,10,13)#</span>
								<cfif #vTipoComando# IS 'IMPRIME'>
									<span class="Sans9Gr">#FechaCompleta(vCampoPos14)#&nbsp;</span>
								<cfelse>
									<cfinput type="text" name="pos14" disabled='#vActivaCampos#' class="datos" id="pos14" onChange="CalcularSiguienteFecha();" value="#vCampoPos14#" size="10" maxlength="10" onkeypress="return MascaraEntrada(event, '99/99/9999');">
								</cfif>
								<span class="Sans9Gr">#ctMovimiento.mov_pos15#</span>
								<cfif #vTipoComando# IS 'IMPRIME'>
									<span class="Sans9Gr">#FechaCompleta(vCampoPos15)#</span>
								<cfelse>
									<cfinput onclick="pos15.value=''" name="pos15" type="text" class="datos" id="pos15" size="10" maxlength="10" disabled value="#vCampoPos15#">
								</cfif>
							</td>
						</tr>
						<!-- Código original hasta el 25/01/2011 -->
						<!---
						<tr>
							<td><span class="Sans9GrNe">#ctMovimiento.mov_pos13#</span><br></td>
							<td>
								<cfif #vTipoComando# IS 'IMPRIME'>
									<span class="Sans9Gr">1</span>
								<cfelse>
									<cfinput name="pos13_a" type="text" class="datos" id="pos13_a" size="1" maxlength="1" disabled="true" value="1">
								</cfif>
								<span class="Sans9Gr">#ctMovimiento.mov_pos13_a#&nbsp;</span>
								<!---
								<cfinput name="pos13_m" type="text" class="datos" id="pos13_m" size="2" maxlength="2" disabled="true" value="#vCampoPos13_m#">
								<span class="Sans9Gr">#ctMovimiento.mov_pos13_m#</span>
								<cfinput name="pos13_d" type="text" class="datos" id="pos13_d" size="2" maxlength="2" disabled="true"  value="#vCampoPos13_d#">
								<span class="Sans9Gr">#ctMovimiento.mov_pos13_d#,</span>
								--->
								<!-- Fechas -->
								<span class="Sans9Gr">#ctMovimiento.mov_pos14# </span>
								<cfif #vTipoComando# IS 'IMPRIME'>
									<span class="Sans9Gr">#FechaCompleta(vCampoPos14)#&nbsp;</span>
								<cfelse>
									<cfinput type="text" name="pos14" class="datos" id="pos14" size="10" maxlength="10" disabled='#vActivaCampos#' value="#vCampoPos14#" onChange="CalcularSiguienteFecha();" onkeypress="return MascaraEntrada(event, '99/99/9999');">
								</cfif>
								<span class="Sans9Gr">#ctMovimiento.mov_pos15# </span>
								<cfif #vTipoComando# IS 'IMPRIME'>
									<span class="Sans9Gr">#FechaCompleta(vCampoPos15)#</span>
								<cfelse>
									<cfinput name="pos15" id="pos15" type="text" class="datos" size="10" maxlength="10" value="#vCampoPos15#" disabled="true">
								</cfif>
							</td>
						</tr>
						--->
						<!-- Número de renovación -->
						<tr>
							<td><span class="Sans9GrNe">#ctMovimiento.mov_pos17#</span></td>
							<td>
								<cfif #vTipoComando# IS 'IMPRIME'>
									<span class="Sans9Gr">#NumberFormat(vCampoPos17,"99")#</span>
								<cfelse>
									<cfinput name="pos17" type="text" class="datos" id="pos17" size="2" value="#LsNumberFormat(vCampoPos17, '99')#" disabled="true">
								</cfif>
							</td>
						</tr>
					</table>
					</cfoutput>
					<!-- Dictámenes -->
					<cfoutput>
					<table width="620" border="0" align="center" class="cuadros">
						<!-- Encabezados -->
						<tr bgcolor="##CCCCCC">
							<td></td>
							<td width="110"><div align="center" class="Sans10NeNe">Aprobatoria</div></td>
							<td width="100"><div align="center" class="Sans10NeNe">Se anexa</div></td>
						</tr>
						<!-- Opinión del consejo interno -->
						<tr>
							<td><span class="Sans9GrNe">#ctMovimiento.mov_pos26#</span></td>
							<td>
								<div align="center" class="Sans9GrNe">
									<cfinput name="pos26" type="radio" value="Si" checked="#Iif(vCampoPos26 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>S&iacute;&nbsp;
									<cfinput name="pos26" type="radio" value="No" checked="#Iif(vCampoPos26 EQ "No",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>No
								</div>
							</td>
							<td>
								<div align="center">
									<cfinput name="pos27" type="checkbox" id="pos27" value="Si" checked="#Iif(vCampoPos27 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>
								</div>
							</td>
						</tr>
						<!-- Apreciación del director -->
						<tr>
							<td><span class="Sans9GrNe">#ctMovimiento.mov_pos28#</span></td>
							<td>
								<div align="center" class="Sans9GrNe">
									<cfinput name="pos28" type="radio" value="Si" checked="#Iif(vCampoPos28 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>S&iacute;&nbsp;
									<cfinput name="pos28" type="radio" value="No" checked="#Iif(vCampoPos26 EQ "No",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>No
								</div>
							</td>
							<td>
								<div align="center">
									<cfinput name="pos29" type="checkbox" id="pos29" value="Si" checked="#Iif(vCampoPos29 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>
								</div>
							</td>
						</tr>
					</table>
					</cfoutput>
					<cfoutput>
					<table width="620" border="0" align="center" class="cuadros">
						<!-- Encabezados -->
						<tr bgcolor="##CCCCCC">
							<td></td>
							<td width="100" height="2"><div align="center" class="Sans10NeNe">Se anexa</div></td>
						</tr>
						<!-- Carta razonada del interesado -->
						<tr>
							<td><span class="Sans9GrNe">#ctMovimiento.mov_pos32#</span></td>
							<td><div align="center"><cfinput name="pos32" type="checkbox" id="pos32" value="Si" checked="#Iif(vCampoPos32 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
						</tr>
						<!-- Informe y programa de actividades (avalados para el caso de técnicos académicos) -->
						<tr>
							<td><span class="Sans9GrNe">#ctMovimiento.mov_pos34#</span></td>
							<td><div align="center"><cfinput name="pos34" type="checkbox" id="pos34" value="Si" checked="#Iif(vCampoPos34 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
						</tr>
						<!-- Curriculum vitae -->
						<tr>
							<td class="Sans9GrNe">#ctMovimiento.mov_pos36#</td>
							<td><div align="center"><cfinput name="pos36" type="checkbox" id="pos36" value="Si" checked="#Iif(vCampoPos36 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
						</tr>
						<!-- Trabajos publicados (sin copias) -->
						<tr>
							<td><span class="Sans9GrNe">#ctMovimiento.mov_pos39#</span></td>
							<td><div align="center"><cfinput name="pos39" type="checkbox" id="pos39" value="Si" checked="#Iif(vCampoPos39 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
						</tr>
					</table>
					</cfoutput>
					<cfif #Session.sTipoSistema# IS 'sic' AND #vSolStatus# EQ 3 AND #vTipoComando# IS NOT 'NUEVO' AND #vTipoComando# IS NOT 'IMPRIME'>
						<cfinclude template="ft_firma.cfm">
					</cfif>
				</td>
			</tr>
		</table>
		<br>
		</cfform>
	</body>
</html>
<!-- Si de entrada el movimiento no procede, avisar al usuario para evitarle la captura -->
<script type="text/javascript">
	<cfif #vTipoComando# EQ 'NUEVO' AND #vCampoPos12# EQ ''>
		alert('AVISO: No se encontró ningún contrato anterior. Si prosigue con la captura la solicitud será rechazada.');
	</cfif>
</script>
