<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA: 03/06/200 --->
<!--- FT-CTIC-10.-Concurso de oposición para promoción o concurso cerrado (Investigador) --->

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
<!--- Obtener datos del catálogo de categorías y niveles --->
<cfquery name="ctCategoria" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_cn WHERE cn_siglas LIKE 'INV%' AND cn_status = 1 ORDER BY cn_orden DESC
</cfquery>
<!--- ??? --->
<cfloop query="ctCategoria">
	<cfif #tbAcademico.cn_clave# EQ #cn_clave#>
		<cfset vIdCcnOrden = #cn_orden# - 1>
	</cfif>
</cfloop>
<!--- Prellenar el campo 'pos8' --->
<cfloop query="ctCategoria">
	<cfif #vIdCcnOrden# EQ #cn_orden#>
		<cfset vCampoPos8 = #cn_clave#>
	</cfif>
</cfloop>
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
			// Validar los datos ingresados por el usuario:
			function fValidaCamposFt()
			{
				var vOk;
				var vMensaje = '';
				fLimpiaValida();
				vMensaje += fValidaCampoLleno('pos1_u','UBICACIÓN');
				if (document.getElementById('pos5_d').checked == true)
				{
					vMensaje += fValidaFecha('pos14','A PARTIR DEL');
				}
				if (document.getElementById('pos5_i').checked == true)
				{
					vMensaje += fValidaDuracionAMD();
					vMensaje += fValidaFecha('pos14','INICIO');
					vMensaje += fValidaDuracion();
				}
				vMensaje += fValidaCampoLleno('pos8','CATEGORIA Y NIVEL A QUE ASPIRA');
				vMensaje += document.getElementById('vNoAniosCcnDef').value < 3 ? 'El académico no cumple con el requisito de tener como mínimo 3 años de antigüedad en esta categoría y nivel.\n': '';
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
	<body onLoad="ObtenerCcnDef();">
		<!--- Lista de movimientos --->
		<script type="text/javascript">
			$(function() {
				$('#dialog:ui-dialog').dialog('destroy');
				$('#ListaMovimientos').dialog({
					autoOpen: false,
					height: 'auto',
					width: 620,
					show: 'slow',
					modal: false,
					open: function() {
			        	fListarMovimientos(1,'mov_fecha_inicio','DESC');
			        }
				});
			});
		</script>
		<div id="ListaMovimientos" title="Historia de movimientos" style="background-color:#fafafa;"></div>
		<!--- IFRAME PARA EL ENVIO DE DOCUMENTOS DIGITALIZADOS (PDF) --->
		<iframe scrolling="no" class="EmergenteArchivo" frameborder="no" name="ifrmSelArchivo" id="ifrmSelArchivo" src="enviar_pdf/ft_archivo_selecciona.cfm?&vIdSol=<cfoutput>#vIdSol#</cfoutput>" style="display:none;"></iframe>
		<!--- DIV para la lista de movimientos --->
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
					<cfif #ctMovimiento.mov_subtitulo# NEQ ''><span class="Sans10Gr">#ctMovimiento.mov_subtitulo#</span></cfif>
					<cfif #ctMovimiento.mov_clase# NEQ ''><br><span class="Sans10Gr">#ctMovimiento.mov_clase#</span></cfif>
					<cfif #vTipoComando# IS 'IMPRIME'><br><br></cfif>
					</p>
					</cfoutput>
					<!-- Campos ocultos -->
					<cfinput name="vFt" type="hidden" id="vFt" value="#vFt#">
					<cfinput name="vIdAcad" type="hidden" id="vIdAcad" value="#vIdAcad#">
					<cfinput name="vTipoComando" type="hidden" id="vTipoComando">
					<cfinput name="vIdSol" type="hidden" value="#vIdSol#">
					<cfinput name="vSolStatus" type="hidden" value="#vSolStatus#">
					<!-- Datos para ser llenados por la ST-CTIC -->
					<cfif #Session.sTipoSistema# IS 'stctic' AND #vSolStatus# LT 3 AND #vTipoComando# IS NOT 'NUEVO' AND #vTipoComando# IS NOT 'IMPRIME'>
						<cfinclude template="ft_control.cfm">
					</cfif>
					<!-- Datos generales -->
					<cfoutput>
					<table width="620" height="50" border="0" align="center" class="cuadros">
						<!-- Dependencia -->
						<tr>
							<td width="20%"><span class="Sans9GrNe">#ctMovimiento.mov_pos1# </span></td>
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
						<!-- Nombre del académico -->
						<tr>
							<td><span class="Sans9GrNe">#ctMovimiento.mov_pos2# </span></td>
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
					<table width="620" height="111" border="0" class="cuadros">
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
						<!-- Antigüedad en esa categoría y nivel -->
						<tr>
							<td colspan="3">
								<span class="Sans9GrNe">#ctMovimiento.mov_pos4#&nbsp;</span>
								<cfif #vTipoComando# IS 'IMPRIME'>
									<span class="Sans9Gr">#vCampoPos4_txt#</span>
								<cfelse>
									<cfinput name="pos4_txt" id="pos4_txt" type="text" value="#vCampoPos4_txt#" size="30" maxlength="100" disabled class="datos">
									<cfinput name="pos4" id="pos4" type="hidden" value="#vCampoPos4#">
								</cfif>
							</td>
						</tr>
						<!-- Desde (CYN) -->
						<tr>
							<td><span class="Sans9GrNe">#ctMovimiento.mov_pos4_f#</span></td>
							<td colspan="2">
								<cfif #vTipoComando# IS 'IMPRIME'>
									<span class="Sans9Gr">#FechaCompleta(vCampoPos4_f)#</span>
								<cfelse>
									<cfinput name="pos4_f" id="pos4_f" type="text" class="datos" size="10" value="#vCampoPos4_f#" disabled>
								</cfif>
							</td>
						</tr>
						<!-- Tipo de contrato -->
						<tr>
							<td><span class="Sans9GrNe">#ctMovimiento.mov_pos5#</span></td>
							<td colspan="2">
								<span class="Sans9Gr">
									<cfinput type="radio" name="pos5" id="pos5_i" value="2" checked="#Iif(vCampoPos5 EQ "2",DE("yes"),DE("no"))#" disabled="#Iif(vTipoComando IS "IMPRIME",DE(""),DE("disabled"))#">Concurso Abierto
									<cfinput type="radio" name="pos5" id="pos5_d" value="1" checked="#Iif(vCampoPos5 EQ "1",DE("yes"),DE("no"))#" disabled="#Iif(vTipoComando IS "IMPRIME",DE(""),DE("disabled"))#">Definitivo
									<cfinput type="radio" name="pos5" id="pos5_o" value="3" checked="#Iif(vCampoPos5 EQ "3",DE("yes"),DE("no"))#" disabled="#Iif(vTipoComando IS "IMPRIME",DE(""),DE("disabled"))#">Obra determinada
								</span>
							</td>
						</tr>
						<tr>
							<!-- Antigüdad académica -->
							<td><span class="Sans9GrNe">#ctMovimiento.mov_pos6#</span></td>
							<td>
								<cfif #vTipoComando# IS 'IMPRIME'>
									<span class="Sans9Gr">#vCampoPos6_txt#</span>
								<cfelse>
									<cfinput name="pos6_txt" id="pos6_txt" type="text" class="datos" size="30" value="#vCampoPos6_txt#" disabled>
									<cfinput name="pos6" id="pos6" type="hidden" value="#vCampoPos6#">
								</cfif>
							</td>
							<!-- Fecha su primer contrato -->
							<td align="right">
								<span class="Sans9GrNe">#ctMovimiento.mov_pos7#&nbsp;</span>
								<cfif #vTipoComando# IS 'IMPRIME'>
									<span class="Sans9Gr">#FechaCompleta(vCampoPos7)#</span>
								<cfelse>
									<cfinput name="pos7" id="pos7" type="text" class="datos" size="10" value="#vCampoPos7#" disabled>
								</cfif>
							</td>
						</tr>
					</table>
					<!-- Datos que deben ingresarse -->
					<table width="620" border="0" class="cuadros">
						<!-- Categoría y nivel a que aspira -->
						<tr>
							<td colspan="2">
								<span class="Sans9GrNe">#ctMovimiento.mov_pos8#&nbsp;</span>
								<cfif #vTipoComando# IS 'IMPRIME'>
									<cfloop query="ctCategoria">
										<cfif #cn_clave# IS #vCampoPos8#>
											<cfset vCampoPos8_txt = #cn_siglas#>
											<cfbreak>
										</cfif>
									</cfloop>
									<span class="Sans9Gr">#vCampoPos8_txt#</span>
								<cfelse>
									<cfselect name="pos8" class="datos" id="pos8" disabled='#vActivaCampos#' query="ctCategoria" value="cn_clave" display="cn_siglas" selected="#vCampoPos8#" queryPosition="below">
									<option value="" selected>SELECCIONE</option>
									</cfselect>
								</cfif>
							</td>
						</tr>
						<cfif #vCampoPos5# EQ 1>
                            <!-- Activa este código si el investigador es definitivo -->
                            <tr>
                                <td width="20%"><span class="Sans9GrNe">#ctMovimiento.mov_pos14#</span></td>
                                <td width="80%">
                                    <cfif #vTipoComando# IS 'IMPRIME'>
                                        <span class="Sans9Gr">#FechaCompleta(vCampoPos14)#</span>
                                    <cfelse>
                                        <cfinput name="pos14" type="text" class="datos" id="pos14" size="10" maxlength="10" disabled='#vActivaCampos#' value="#vCampoPos14#" onKeyPress="return MascaraEntrada(event, '99/99/9999');" onBlur="ObtenerCcnDef('');">
                                    </cfif>
                                    <div id="ccnactual_dynamic"><!-- AJAX: Años de actividad ininterrumpida --></div>
                                </td>
							</tr>
						<cfelseif #vCampoPos5# EQ 2>
                            <!-- Activa este código si el investigador es interino -->
                            <tr>
                                <td width="20%"><span class="Sans9GrNe">#ctMovimiento.mov_pos13#</span></td>
                                <td width="80%">
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
                                            <span class="Sans9Gr">
                                                #vCampoPos13_d# #ctMovimiento.mov_pos13_d#&nbsp;
                                            </span>
                                        </span>
                                    <cfelse>
                                        <span
                                            <cfif #vCampoPos13_a# EQ 0>class="NoImprimir"</cfif>
                                            ><cfinput type="text" name="pos13_a" disabled='#vActivaCampos#' class="datos" id="pos13_a" onChange="CalcularSiguienteFecha();" value="#vCampoPos13_a#" size="1" maxlength="1" onkeypress="return MascaraEntrada(event, '9');">
                                            <span class="Sans9Gr">
                                                #ctMovimiento.mov_pos13_a#
                                            </span>
                                        </span>
                                        <span
                                            <cfif #vCampoPos13_m# EQ 0>class="NoImprimir"</cfif>
                                            ><cfinput type="text" name="pos13_m" disabled='#vActivaCampos#' class="datos" id="pos13_m" onChange="CalcularSiguienteFecha();" value="#vCampoPos13_m#" size="2" maxlength="2" onkeypress="return MascaraEntrada(event, '99');">
                                            <span class="Sans9Gr">
                                                #ctMovimiento.mov_pos13_m#
                                            </span>
                                        </span>
                                        <span
                                            <cfif #vCampoPos13_d# EQ 0>class="NoImprimir"</cfif>
                                            ><cfinput type="text" name="pos13_d" disabled='#vActivaCampos#' class="datos" id="pos13_d" onChange="CalcularSiguienteFecha();" value="#vCampoPos13_d#" size="2" maxlength="2" onkeypress="return MascaraEntrada(event, '99');">
                                            <span class="Sans9Gr">
                                                #ctMovimiento.mov_pos13_d#
                                            </span>
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
                                    <div id="ccnactual_dynamic"><!-- AJAX: Años de actividad ininterrumpida --></div>
                                </td>
							</tr>
						</cfif>
						<!-- Código anterior para el rubro de A PARTIR -->
<!---
						<tr>
							<td width="20%"><span class="Sans9GrNe">#ctMovimiento.mov_pos14#</span></td>
							<td width="80%">
								<cfif #vTipoComando# IS 'IMPRIME'>
									<span class="Sans9Gr">#FechaCompleta(vCampoPos14)#</span>
								<cfelse>
									<cfinput name="pos14" type="text" class="datos" id="pos14" size="10" maxlength="10" disabled='#vActivaCampos#' value="#vCampoPos14#" onKeyPress="return MascaraEntrada(event, '99/99/9999');" onBlur="ObtenerCcnDef('');">
								</cfif>
								<div id="ccnactual_dynamic"><!-- AJAX: Años de actividad ininterrumpida --></div>
							</td>
						</tr>
--->
					</table>
					</cfoutput>
					<!-- Dictámenes -->
					<cfoutput>
					<table width="620" border="0" cellpadding="0" class="cuadros">
						<tr bgcolor="##CCCCCC">
							<td></td>
							<td width="110"> <div align="center"><span class="Sans9GrNe">Aprobatoria</span></div></td>
							<td width="100"> <div align="center"><span class="Sans9GrNe">Se anexa</span></div></td>
						</tr>
						<!-- Comisión Dictaminadora -->
						<tr>
							<td><span class="Sans9GrNe">#ctMovimiento.mov_pos30#</span></td>
							<td>
								<div align="center">
									<span class="Sans9GrNe">
										<cfinput name="pos30" id="pos30_s" type="radio" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos30 EQ 'Si',DE("yes"),DE("no"))#">S&iacute;&nbsp;
										<cfinput name="pos30" id="pos30_n" type="radio" value="No" disabled='#vActivaCampos#' checked="#Iif(vCampoPos30 EQ 'No',DE("yes"),DE("no"))#">No
									</span>
								</div>
							</td>
							<td>
								<div align="center">
									<span class="Sans9GrNe">
										<cfinput name="pos31" type="checkbox" id="pos31" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos31 EQ 'Si',DE("yes"),DE("no"))#">
									</span>
								</div>
							</td>
						</tr>
						<!-- Opinión del Consejo Interno -->
						<tr>
							<td><span class="Sans9GrNe">#ctMovimiento.mov_pos26#</span></td>
							<td>
								<div align="center">
									<span class="Sans9GrNe">
										<cfinput name="pos26" id="pos26_s" type="radio" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos26 EQ 'Si',DE("yes"),DE("no"))#">S&iacute;&nbsp;
										<cfinput name="pos26" id="pos26_n" type="radio" value="No" disabled='#vActivaCampos#' checked="#Iif(vCampoPos26 EQ 'No',DE("yes"),DE("no"))#">No
									</span>
								</div>
							</td>
							<td>
								<div align="center">
									<span class="Sans9GrNe">
										<cfinput name="pos27" type="checkbox" id="pos27" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos27 EQ 'Si',DE("yes"),DE("no"))#">
									</span>
								</div>
							</td>
						</tr>
						<!-- Apreciación del director -->
						<tr>
							<td><span class="Sans9GrNe">#ctMovimiento.mov_pos28#</span></td>
							<td>
								<div align="center">
									<span class="Sans9GrNe">
										<cfinput name="pos28" id="pos28_s" type="radio" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos28 EQ 'Si',DE("yes"),DE("no"))#">S&iacute;&nbsp;
										<cfinput name="pos28" id="pos28_n" type="radio" value="No" disabled='#vActivaCampos#' checked="#Iif(vCampoPos28 EQ 'No',DE("yes"),DE("no"))#">No
									</span>
								</div>
							</td>
							<td>
								<div align="center">
									<span class="Sans9GrNe">
										<cfinput name="pos29" type="checkbox" id="pos29" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos29 EQ 'Si',DE("yes"),DE("no"))#">
									</span>
								</div>
							</td>
						</tr>
					</table>
					</cfoutput>
					<!-- Documentación -->
					<cfoutput>
					<table width="620" border="0" cellpadding="0" class="cuadros">
						<tr bgcolor="##CCCCCC">
							<td></td>
							<td width="100"> <div align="center"><span class="Sans9GrNe">Se anexa</span></div></td>
						</tr>
						<!-- Carta del director (con resumen de la obra del académico) (2) -->
						<tr>
							<td><span class="Sans9GrNe">#ctMovimiento.mov_pos33#</span></td>
							<td>
								<div align="center">
									<span class="Sans9GrNe">
										<cfinput name="pos33" type="checkbox" id="pos33" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos33 EQ 'Si',DE("yes"),DE("no"))#">
									</span>
								</div>
							</td>
						</tr>
						<!-- Carta razonada del interesado -->
						<tr>
							<td><span class="Sans9GrNe">#ctMovimiento.mov_pos32#</span></td>
							<td>
								<div align="center">
									<span class="Sans9GrNe">
										<cfinput name="pos32" type="checkbox" id="pos32" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos32 EQ 'Si',DE("yes"),DE("no"))#">
									</span>
								</div>
							</td>
						</tr>
						<!-- Informe y programa de actividades -->
						<tr>
							<td><span class="Sans9GrNe">#ctMovimiento.mov_pos34#</span></td>
							<td>
								<div align="center">
									<span class="Sans9GrNe">
										<cfinput name="pos34" type="checkbox" id="pos34" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos34 EQ 'Si',DE("yes"),DE("no"))#">
									</span>
								</div>
							</td>
						</tr>
						<!-- Curriculum vitae -->
						<tr>
							<td><span class="Sans9GrNe">#ctMovimiento.mov_pos36#</span></td>
							<td>
								<div align="center">
									<span class="Sans9GrNe">
										<cfinput name="pos36" type="checkbox" id="pos36" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos36 EQ 'Si',DE("yes"),DE("no"))#">
									</span>
								</div>
							</td>
						</tr>
						<!-- Trabajos publicados (1) -->
						<tr>
							<td><span class="Sans9GrNe">#ctMovimiento.mov_pos39#</span></td>
							<td>
								<div align="center">
									<span class="Sans9GrNe">
										<cfinput name="pos39" type="checkbox" id="pos39" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos39 EQ 'Si',DE("yes"),DE("no"))#">
									</span>
								</div>
							</td>
						</tr>
					</table>
					</cfoutput>
					<!-- Comentarios -->
					<table width="620" border="0">
						<tr>
							<td><cfoutput><span class="Sans9Gr">#ctMovimiento.mov_comentarios#</span></cfoutput></td>
						</tr>
					</table>
					<cfif #Session.sTipoSistema# IS 'sic' AND #vSolStatus# EQ 3 AND #vTipoComando# IS NOT 'NUEVO' AND #vTipoComando# IS NOT 'IMPRIME'>
						<cfinclude template="ft_firma.cfm">
					</cfif>
				</td>
			</tr>
		</table>
		</cfform>
	</body>
</html>
