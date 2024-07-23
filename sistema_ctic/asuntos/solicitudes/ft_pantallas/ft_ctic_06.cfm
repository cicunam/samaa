<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 22/04/2009 --->
<!--- FECHA ÚLTIMA MOD.: 17/07/2024 --->
<!--- FT-CTIC-6.-Contrato para obra determinada --->

<!--- Incluir los siguientes archivos --->
<cfif #vTipoComando# EQ 'IMPRIME_EJEMPLO'>
	<cfinclude template="ft_campos_blanco.cfm"> <!---PERIMITE IMPRIMIR LA FT EN BLANCO --->
	<cfset vTipoComando = 'IMPRIME'>
<cfelse>
	<cfinclude template="ft_campos.cfm">
</cfif>

<!--- Obtener la lista de ubicaciones de la dependencia  (CATÁLOGOS GENERALES MYSQL) --->
<cfquery name="ctUbicacion" datasource="#vOrigenDatosCATALOGOS#">
	SELECT *, CONCAT(TRIM(ubica_nombre),  ', ', TRIM(ubica_lugar)) AS ubica_completa
    FROM catalogo_dependencias_ubica
	WHERE dep_clave = '#vCampoPos1#'
    AND ubica_status = 1
	ORDER BY ubica_clave
</cfquery>

<!--- Catálogo de programas de apoyos (CATÁLOGOS LOCAL SAMAA) --->
<cfquery name="ctPrograma" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_programa 
    WHERE prog_status = 1 
    ORDER BY prog_nombre
</cfquery>

<!--- Obtener datos del catálogo de nombramiento (CATÁLOGOS GENERALES MYSQL) --->
<cfquery name="ctCategoria" datasource="#vOrigenDatosCATALOGOS#">
	SELECT * FROM catalogo_cn 
    WHERE cn_status = 1 
    ORDER BY cn_orden DESC
</cfquery>

<cfset vFechas_COD = "">
<cfset vContratos_COD = "">
<cfset vContratos_CODn = "">
<cfset vNoContratos = 0>
<cfset vNoContratosDiasSuma = 0>

<html>
	<head>
		<!-- INCLUDE que agrega parte del contenido del encabezado -->
		<cfinclude template="ft_include_head_comun.cfm">

		<!-- JAVA SCRIT de uso local -->
		<script type="text/javascript" src="/comun_cic/jquery/jquery-ui-1.8.16.custom.min.js" ></script>
		<script type="text/javascript" src="/comun_cic/jquery/jquery.meio.mask.min.js" ></script>
		<script type="text/javascript" src="/comun_cic/jquery/mascaras.js" ></script>
		<script type="text/javascript">
			// Validar los datos ingresados por el usuario:
			function fValidaCamposFt()
			{
				var vOk;
				var vMensaje = '';
				fLimpiaValida();
				CalcularSiguienteFecha();
				vMensaje += fValidaCampoLleno('pos1_u','UBICACIÓN');
				vMensaje += fValidaDuracionAMD();
				vMensaje += fValidaFecha('pos14','INICIO');
				vMensaje += fValidaDuracion();
				vMensaje += fValidaCampoLleno('pos16','NÚMERO DE HORAS');
				vMensaje += fValidaHoras(40,'Campo: NÚMERO DE HORAS no debe ser mayor a 40\n', 'F6');
				if (document.getElementById('no_plaza_valida'))
				{
					if (document.getElementById('no_plaza_valida').value == '1') vMensaje += 'Campo: PLAZA el número de plaza no es válido\n';
				}
				// No validar número de plaza para PFAMU:
				//if (document.getElementById('pos12').value != "2")
				//{
				vMensaje += fValidaCampoLleno('pos9','NÚMERO DE PLAZA');
				//	vMensaje += fValidaPlaza();
				//}
				vMensaje += fValidaCampoLleno('pos8','SUELDO EQUIVALENTE');
				vMensaje += fValidaCampoLleno('memo1','OBJETO DEL CONTRATO');
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
			// SI LA OBRA DETERMINADA ESTA LIGADA A UN PROGRAMA NO SE RQUIERE NÚMERO DE PLAZA
			function fPrograma()
			{
				if (document.getElementById('pos12').value == '1' || document.getElementById('pos12').value == '3')
				{
					document.getElementById('pos9').value = '00000-00';
					if (document.getElementById('pos12').value == '1') document.getElementById('pos9').disabled = true;
					// EN CASO DE QUE EL PROGRAMA ASOCIADO SEA (CATÁLOGO ID 3) EL SUBPROGRAMA DE INCORPORACIÓN DE JOVENES ACADÉMICOS DESPLIEGA REQUISITOS POR MEDIO DE JQUERY
					if (document.getElementById('pos12').value == '3') 	mostrarRequisitos();
					document.getElementById('trSubProgJAC').style.display = '';
				}
				else
				{
					document.getElementById('pos9').value = '';
					document.getElementById('pos9').disabled = false;
					document.getElementById('trSubProgJAC').style.display = 'none';
				}
			}
/*
		// CHECA QUE LA PALZA SEA CORRECTA CON EL DÍGITO VERIFICADOR DE LA PLAZA
			function fCodigoPlaza()
			{
				if (document.getElementById('pos9').value != '')
				{
					var vCodigoRF
//					alert(document.getElementById('pos9').value.substring(0,5))
					var vValorPlaza = document.getElementById('pos9').value.substring(0,5)
//					alert(parseInt(vValorPlaza,10))
					var vCodigo = (100000 - parseInt(vValorPlaza,10)).toString()
//					alert(vCodigo)
//					alert(vCodigo.substring(0,1))
					var vCodigoR1 = parseInt(vCodigo.substring(0,1)) + parseInt(vCodigo.substring(2,3)) + parseInt(vCodigo.substring(4,5));
					var vCodigoR2 = parseInt(vCodigo.substring(1,2)) +  parseInt(vCodigo.substring(3,4));
//					alert(vCodigoR1);
//					alert(vCodigoR2);
					vCodigoR1 = parseInt(vCodigoR1) * 7;
					vCodigoR2 = parseInt(vCodigoR2) * 3;
//					alert(vCodigoR1);
//					alert(vCodigoR2);
//					alert(vCodigoR1.toString().length);
					if (vCodigoR1.toString().length == 3)
					 {
//						alert(vCodigoR1.toString().substring(2,3));
						vCodigoRF1 = vCodigoR1.toString().substring(2,3);
					 }
					else
					{
//						alert(vCodigoR1.toString().substring(1,2));
						vCodigoRF1 = vCodigoR1.toString().substring(1,2);
					}

					if (vCodigoR2.toString().length == 3)
					 {
//						alert(vCodigoR2.toString().substring(2,3));
						vCodigoRF2 = vCodigoR2.toString().substring(2,3);
					 }
					else
					{
//						alert(vCodigoR2.toString().substring(1,2));
						vCodigoRF2 = vCodigoR2.toString().substring(1,2);
					}
					vCodigoRF = vCodigoRF1.toString() + vCodigoRF2.toString()
//					alert(vCodigoRF.toString())
					if (document.getElementById('pos9').value.substring(6,8) != vCodigoRF.toString())
					{
						alert('EL NÚMERO DE LA PLAZA NO ES VALIDO, FAVOR DE REVISARLO.');
						document.getElementById('pos9').focus();
					}
				}
			}
*/
			<!-- AJAX QUE PERMITE VERIFICAR SI EL NÚMERO DE PLAZA ES CORRECTO -->
			function VerificaNoPlaza()
			{
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// FunciÃ³n de atenciÃ³n a las peticiÃ³n HTTP:
				//alert(document.getElementById('plaza_numero').value.length)
				document.getElementById('verifica_plaza_dynamic').style.top = document.getElementById('pos9').getBoundingClientRect().top ;
				document.getElementById('verifica_plaza_dynamic').style.left = document.getElementById('pos9').getBoundingClientRect().left + 75;
				if (document.getElementById('pos9').value.length == 8)
				{
					xmlHttp.onreadystatechange = function(){
						if (xmlHttp.readyState == 4) {
							document.getElementById('verifica_plaza_dynamic').innerHTML = xmlHttp.responseText;
							// if ($('#no_plaza_valida').val() == '0'){$('#informacion_plaza_dynamic').html(''); fDatosPlaza();}
							//if 	(document.getElementById('hidPlazaNumero').value == '1')
							//	{
							//		document.getElementById('plaza_numero').focus()
							//	}
						}
					}
					// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones
					xmlHttp.open("POST", "/comun_cic/ajax/codigo_verificador.cfm", true);
					xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
					// Crear la lista de parÃ¡metros:
					parametros = "vpNoPlaza=" + encodeURIComponent(document.getElementById('pos9').value);
					// Enviar la peticiÃ³n HTTP:
					xmlHttp.send(parametros);
				}
				else if (document.getElementById('pos9').value.length == 0)
				{
					// alert('EL NÚMERO DE PLAZA ES INCORRECTO')
					document.getElementById('verifica_plaza_dynamic').innerHTML = '';
				}
				else
				{
					alert('EL NÚMERO DE PLAZA ES INCORRECTO')
					document.getElementById('verifica_plaza_dynamic').innerHTML = '';
				}
			}
			//FUNCIÓN PARA MOSTRAR JQUERY DE VENTANA EMERGENTE
			function mostrarRequisitos() {
				$('#divRequisitos').dialog('open');
			}
			// Ventana del diálogo (jQuery)
			$(function() {
				$('#dialog:ui-dialog').dialog('destroy');
				$('#divRequisitos').dialog({
					autoOpen: false,
					height: 'auto',
					width: 600,
					modal: true,
					maxHeight: 600
				});
			});
			
			function fDatosPlaza()
			{
				if ($('#vTipoComando').val() == 'CONSULTA' && $('#pos9').val() != '00000-00')
					var posTop = $('#cmdMovHistoria').offset().top; //verifica_plaza_dynamic
					document.getElementById('informacion_plaza_dynamic').style.top = (posTop + 20) + 'px';				

					$.ajax({
						async: false,
						url: "ft_ajax/plaza_informacion.cfm",
						type:'POST',
						data: {vpNoPlaza: $('#pos9').val()},
						dataType: 'html',
						success: function(data, textStatus) {
							//alert(data);
							$('#informacion_plaza_dynamic').html(data);
						},
						error: function(data) {
							alert('ERROR AL CARGAR LA INFORMACION DE LA PLAZA');
							//location.reload();
						},
					});
			}
		</script>
	</head>
	<body onLoad="ObtenerNoContratos(); fDatosPlaza();">
        <!--- INCLUDE Cintillo con nombre y número de forma telegrámica / INCLUDE que contiene FORM para abrir archivo PDF (05/04/2019) --->
        <cfinclude template="ft_include_cintillo.cfm">
		<!--- FORMULARIO forma telegrámica --->
		<cfform name="formFt" id="formFt" method="POST" action="#vRutaPagSig#">
            <!-- Forma telegrámica -->
            <table width="100%" border="0">
                <tr>
                    <!-- Menú lateral -->
                    <cfif #vTipoComando# IS NOT 'IMPRIME' AND #vHistoria# IS NOT 1>
                        <td class="menuformulario">
                            <!-- INCLUDE Ménu izquierdo -->
							<cfinclude template="ft_include_menu.cfm">
                        </td>
                    </cfif>
                    <!-- Formulario -->
                    <td class="formulario">

                        <!-- INCLUDE Titulos de la forma telegrámica -->
                        <cfinclude template="ft_include_titulos.cfm">

                        <!-- INCLUDE Campos ocultos GENERALES-->
                        <cfinclude template="ft_include_campos_ocultos.cfm">
                        <!-- Datos para ser llenados por la ST-CTIC -->
                        <cfif #Session.sTipoSistema# IS 'stctic' AND #vSolStatus# LT 3 AND #vTipoComando# IS NOT 'NUEVO' AND #vTipoComando# IS NOT 'IMPRIME' AND #vHistoria# IS NOT 1>
                            <cfinclude template="ft_control.cfm">
                        </cfif>

                        <!-- INCLUDE para visualisar Datos generales -->
                        <cfinclude template="ft_include_general.cfm">

                        <!-- Datos que deben ingresarse -->
                        <cfoutput>
                            <table border="0" class="cuadrosFormularios">
                                <!-- Programa asociado a esta obra determinada -->
                                <tr>
                                    <td colspan="2"><span class="Sans9GrNe">#ctMovimiento.mov_pos12#</span></td>
                                <tr>
                                    <td></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <cfset vCampoPos12_txt = 'NINGUNO'>
                                            <cfloop query="ctPrograma">
                                                <cfif #prog_clave# IS #vCampoPos12#>
                                                    <cfset vCampoPos12_txt = #prog_nombre#>
                                                    <cfbreak>
                                                </cfif>
                                            </cfloop>
                                            <span class="Sans9Gr">#vCampoPos12_txt#</span>
                                        <cfelse>
                                            <cfselect name="pos12" class="datos100" id="pos12" query="ctPrograma" queryPosition="below" value="prog_clave" display="prog_nombre" disabled='#vActivaCampos#' selected="#vCampoPos12#" style="width:390;" onChange="fPrograma();">
                                                <option value="">NINGUNO</option>
                                            </cfselect>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Duración del contrato -->
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
                                                <cfif #vCampoPos13_d# EQ 0>class="NoImprimir"</cfif>>
                                                <cfinput type="text" name="pos13_d" disabled='#vActivaCampos#' class="datos" id="pos13_d" onChange="CalcularSiguienteFecha();" value="#vCampoPos13_d#" size="2" maxlength="2" onkeypress="return MascaraEntrada(event, '99');">
                                                <span class="Sans9Gr">
                                                    #ctMovimiento.mov_pos13_d#
                                            </span>
                                            </span>
                                        </cfif>
                                        <!-- Fechas -->
                                        <span class="Sans9Gr">#ctMovimiento.mov_pos14#</span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos14)#&nbsp;</span>
                                        <cfelse>
                                            <cfinput type="text" name="pos14" disabled='#vActivaCampos#' class="datos" id="pos14" onChange="CalcularSiguienteFecha();" value="#vCampoPos14#" size="10" maxlength="10" onkeypress="return MascaraEntrada(event, '99/99/9999');" onBlur="ObtenerNoContratos();">
                                        </cfif>
                                        <span class="Sans9Gr">#ctMovimiento.mov_pos15#</span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos15)#</span>
                                        <cfelse>
                                            <cfinput onclick="pos15.value=''" name="pos15" type="text" class="datos" id="pos15" size="10" maxlength="10" disabled value="#vCampoPos15#">
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Número de horas -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos16#</span></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#NumberFormat(vCampoPos16,"99")#</span>
                                        <cfelse>
                                            <cfinput name="pos16" type="text" class="datos" id="pos16" size="3" maxlength="4" disabled='#vActivaCampos#' value="#LsNumberFormat(vCampoPos16,'99')#" onKeyPress="return MascaraEntrada(event, '99');">
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Número de plaza -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos9#</span></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoPos9#</span>
                                        <cfelse>
											<cfinput name="pos9" type="text" class="datos" id="pos9" size="8" maxlength="8" disabled='#vActivaCampos#' value="#vCampoPos9#" onkeypress="return MascaraEntrada(event, '99999-99');" onBlur="ObtenerNoContratos(); VerificaNoPlaza();">
											<div id="verifica_plaza_dynamic" style="position:absolute; width:20%;"></div>
											<cfif vTipoComando EQ 'CONSULTA' AND #vCampoPos9# NEQ '00000-00'>
												<div id="informacion_plaza_dynamic" class="divPlazaDgpo"></div>
											</cfif>
                                        <!---<cfinput name="pos9" type="text" class="datos" id="pos9" size="8" maxlength="9" disabled='#vActivaCampos#' value="#vCampoPos9#" onkeypress="return MascaraEntrada(event, '99999-99');" onBlur="fCodigoPlaza();">--->
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Área de adscripción plaza DGPo (12/03/2020) -->
								<cfif #vTipoComando# IS 'CONSULTA'>
									<cfinclude template="include_plaza_area_dgpo.cfm">
								</cfif>
								<!-- Sueldo equivalente a (categoría y nivel) -->
                                <tr>
                                  <td colspan="2">
                                        <span class="Sans9GrNe">#ctMovimiento.mov_pos8#&nbsp;</span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoPos8_txt#</span>
                                        <cfelse>
                                            <cfselect name="pos8" class="datos" id="pos8" query="ctCategoria" queryPosition="below" value="cn_clave" display="cn_siglas" disabled='#vActivaCampos#' selected="#vCampoPos8#" onChange="ObtenerNoContratos();">
                                                <option value="" selected>SELECCIONE</option>
                                            </cfselect>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Objeto del contrato precisando productos -->
                                <tr>
                                    <td colspan="2"><span class="Sans9GrNe">#ctMovimiento.mov_memo1#</span></td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoMemo1#</span>
                                        <cfelse>
                                            <cftextarea name="memo1" rows="5" class="datos100" id="memo1" disabled='#vActivaCampos#' value="#vCampoMemo1#"></cftextarea>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Justificación de la contratación -->
                                <tr>
                                    <td colspan="2"><span class="Sans9GrNe">#ctMovimiento.mov_memo2#</span></td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoMemo2#</span>
                                        <cfelse>
                                            <cftextarea name="memo2" rows="5" class="datos100" id="memo2" disabled='#vActivaCampos#' value="#vCampoMemo2#"></cftextarea>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Controles dinámicos -->
                                <tr>
                                    <td colspan="2" id="contratos_dynamic">
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <cfset vCcnActual='#vCampoPos8#'>
                                            <cfset vNoPlaza='#vCampoPos9#'>
                                            <cfset vDepClave='#vCampoPos1#'>
                                            <cfset vProgramaClave='#vCampoPos12#'>                                        
                                            <cfinclude template="ft_ajax/lista_contratos.cfm">
                                        <cfelse>
                                            <!-- AJAX: Contratos anteriores -->
                                        </cfif>
                                    </td>
                                </tr>
                                <!--- Área Adscripción DGPo (SE INSERTÓ 11/03/2020)
								<cfif #vTipoComando# IS 'IMPRIME'>
									<tr>
										<td colspan="2" id="contratos_dynamic">
											<cfif #vTipoComando# IS 'IMPRIME'>
												<cfset vNoPlaza='#vCampoPos9#'>
												<cfinclude template="ft_ajax/lista_contratos.cfm">
											<cfelse>
												<!--- AJAX: Contratos anteriores --->
											</cfif>
										</td>
									</tr>
								</cfif>
 								--->										
                            </table>
                        </cfoutput>

						<!-- Dictámenes -->
						<!--- Llamado a INCLUDE general de los dictámenes requeridos en la FT 17/07/2024 --->
						<cfinclude template="ft_include_anexoDictamen.cfm">
<!---
                        <!-- Dictámenes -->
                        <cfoutput>
                            <table border="0" class="cuadrosFormularios">
                                <tr bgcolor="##CCCCCC">
                                    <td width="65%"></td>
                                    <td width="20%"><div class="Sans9GrNe" align="center">Aprobatoria</div></td>
                                    <td width="15%"><div class="Sans9GrNe" align="center">Se anexa</div></td>
                                </tr>
                                <!-- Opinión de la Comisión Dictaminadora -->
                                <tr>
                                    <td class="Sans9GrNe">#ctMovimiento.mov_pos30#</td>
                                    <td class="Sans9GrNe">
                                        <div align="center">
                                            <cfinput name="pos30" id="pos30_s" type="radio" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos30 EQ 'Si',DE("yes"),DE("no"))#">S&iacute;&nbsp;
                                            <cfinput name="pos30" id="pos30_n" type="radio" value="No" disabled='#vActivaCampos#' checked="#Iif(vCampoPos30 EQ 'No',DE("yes"),DE("no"))#">No
                                        </div>
                                    </td>
                                    <td>
                                        <div align="center">
                                            <cfinput name="pos31" type="checkbox" id="pos31" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos31 EQ 'Si',DE("yes"),DE("no"))#">
                                        </div>
                                    </td>
                                </tr>
                                <!-- Opinión del Consejero Interno -->
                                <tr>
                                    <td class="Sans9GrNe">#ctMovimiento.mov_pos26#</td>
                                    <td>
                                        <div class="Sans9GrNe" align="center">
                                            <cfinput name="pos26" id="pos26_s" type="radio" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos26 EQ 'Si',DE("yes"),DE("no"))#">S&iacute;&nbsp;
                                            <cfinput name="pos26" id="26_n" type="radio" value="No" disabled='#vActivaCampos#' checked="#Iif(vCampoPos26 EQ 'No',DE("yes"),DE("no"))#">No
                                        </div>
                                    </td>
                                    <td class="Sans9GrNe">
                                        <div align="center">
                                            <cfinput name="pos27" type="checkbox" id="pos27" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos27 EQ 'Si',DE("yes"),DE("no"))#">
                                        </div>
                                    </td>
                                </tr>
                                <!-- Carta del director -->
                                <tr>
                                    <td class="Sans9GrNe">#ctMovimiento.mov_pos28#</td>
                                    <td class="Sans9GrNe">
                                        <div align="center">
                                            <cfinput name="pos28" id="pos28_s" type="radio" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos28 EQ 'Si',DE("yes"),DE("no"))#">S&iacute;&nbsp;
                                            <cfinput name="pos28" id="pos28_n" type="radio" value="No" disabled='#vActivaCampos#' checked="#Iif(vCampoPos28 EQ 'No',DE("yes"),DE("no"))#">No
                                        </div>
                                    </td>
                                    <td class="Sans9GrNe">
                                        <div align="center">
                                            <cfinput name="pos29" type="checkbox" id="pos29" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos29 EQ 'Si',DE("yes"),DE("no"))#">
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </cfoutput>
--->
						<!-- Documentación -->
						<!--- Llamado a INCLUDE general de los anexos requeridos en la FT 17/07/2024 --->
						<cfinclude template="ft_include_anexoAnexos.cfm">
<!---
                        <!-- Documentación -->
                        <cfoutput>
                            <table border="0" class="cuadrosFormularios">
                                <tr bgcolor="##CCCCCC" class="Sans9GrNe">
                                    <td width="85%"></td>
                                    <td width="15%"> <div align="center" class="Sans9GrNe">Se anexa</div></td>
                                </tr>
                                <!-- Programa e informe de actividades (avalado para el caso de técnicos académicos)  -->
                                <tr>
                                    <td class="Sans9GrNe">#ctMovimiento.mov_pos34#</td>
                                    <td>
                                        <div align="center">
                                            <cfinput name="pos34" type="checkbox" id="pos34" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos34 EQ 'Si',DE("yes"),DE("no"))#">
                                        </div>
                                    </td>
                                </tr>
                                <!-- Curriculum vitae -->
                                <tr>
                                    <td class="Sans9GrNe">#ctMovimiento.mov_pos36#</td>
                                    <td>
                                        <div align="center">
                                            <cfinput name="pos36" type="checkbox" id="pos36" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos36 EQ 'Si',DE("yes"),DE("no"))#">
                                        </div>
                                    </td>
                                </tr>
                                <!-- Constancia de último grado obtenido -->
                                <tr>
                                    <td class="Sans9GrNe">#ctMovimiento.mov_pos38#</td>
                                    <td>
                                        <div align="center">
                                            <cfinput name="pos38" type="checkbox" id="pos38" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos38 EQ 'Si',DE("yes"),DE("no"))#">
                                        </div>
                                    </td>
                                </tr>
                                <!-- Trabajos publicados sólo para los contratos señalados (*) -->
                                <tr>
                                    <td class="Sans9GrNe">#ctMovimiento.mov_pos39#</td>
                                    <td>
                                        <div align="center">
                                            <cfinput name="pos39" type="checkbox" id="pos39" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos39 EQ 'Si',DE("yes"),DE("no"))#">
                                        </div>
                                    </td>
                                </tr>
--->
                        <cfoutput>
                            <table border="0" class="cuadrosFormularios">
                                <!-- Notas para el Subprograma de Incorporación de Jóvenes Académicos de Carrera -->
                                <tr id="trSubProgJAC" style="display:none">
                                    <td>
                                        <span class="Sans10ViNe">*** Documentos para el Expediente Administrativo ***</span>
                                    </td>
                                </tr>
                                <!-- Notas sobre la documentación -->
                                <tr>
                                    <td>
                                        <span class="Sans9Gr">(*) Investigador Titular C </span>
                                        <br>
                                        <span class="Sans9Gr">(*) T&eacute;cnico Acad&eacute;mico con contrato 1 o cambio de nivel </span>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
										<span class="VerVinoNegP"><cfoutput>#ctMovimiento.mov_comentarios#</cfoutput></span>
                                    </td>
                                </tr>
                            </table>
                        </cfoutput>
                        <cfif #Session.sTipoSistema# IS 'sic' AND #vSolStatus# EQ 3 AND #vTipoComando# IS NOT 'NUEVO' AND #vTipoComando# IS NOT 'IMPRIME'>
                            <cfinclude template="ft_firma.cfm">
                        </cfif>
                    </td>
                </tr>
            </table>
		</cfform>
		<cfif #vTipoComando# NEQ 'IMPRIME'>
        	<cfinclude template="#vCarpetaRaizLogica#/include_pie.cfm">
		</cfif>
	</body>
</html>
