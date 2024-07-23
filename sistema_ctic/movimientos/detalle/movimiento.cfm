<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 13/19/2009 --->
<!--- FECHA ÚLTIMA MOD.: 30/07/2019 --->

<!--- FORMULARIO DE CAPTURA Y EDICIÓN DE MOVIMIENTOS --->
<cfparam name="vMenuHidden" default="1">
<!--- Incluir los siguientes archivos --->
<cfinclude template="mov_campos.cfm">
<cfinclude template="mov_scripts_ajax.cfm">
<cfinclude template="mov_scripts_varios.cfm">

<!--- Obtener la lista de dependencias --->
<cfquery name="ctDependencia" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_dependencia
    ORDER BY dep_nombre
</cfquery>

<!--- Obtener la lista de categorías y niveles --->
<cfquery name="ctCategoria" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_cn
	WHERE cn_siglas LIKE 'AYU%'
	OR cn_siglas LIKE 'INV%'
	OR cn_siglas LIKE 'PRO%'
	OR cn_siglas LIKE 'SIN%'
	OR cn_siglas LIKE 'TEC%'<!--- Solución temporal --->
	ORDER BY cn_siglas
</cfquery>

<!--- Obtener la lista de tipos de contrato --->
<cfquery name="ctContrato" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_contrato
    ORDER BY con_orden
</cfquery>

<!--- Obtener datos del catalogo de pais ---> 
<cfquery name="ctPais" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_pais
    ORDER BY pais_nombre
</cfquery>

<!--- Obtener datos del catalogo de programas de apoyo ---> 
<cfquery name="ctPrograma" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_programa
    ORDER BY prog_nombre
</cfquery>

<!--- Obtener datos del catálogo de tipos de baja --->
<cfquery name="ctBaja" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_baja
    ORDER BY baja_descrip
</cfquery>

<!--- Obtener datos del catálogo de actividades --->
<cfquery name="ctActividad" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_actividad
    ORDER BY activ_orden
</cfquery>

<!--- Obtener datos del catálogo de decisiones --->
<cfquery name="ctDecision" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_decision
    ORDER BY dec_clave
</cfquery>

<!--- Si se abrió el formulario para realizar una corrección por FT-CTIC-31, sobre escribir los valores que cambian --->
<cfif #vTipoComando# EQ 'CORRECCION'>
	<!--- Verificar si hay cambio en el nombre --->
	<cfquery name="tbCorrecciones" datasource="#vOrigenDatosSAMAA#">
		SELECT * FROM movimientos_correccion
		WHERE sol_id = #vIdSolCO# AND co_tipo = 'DEBE DECIR' AND co_campo = 'NOMBRE'
	</cfquery>
	<cfif #tbCorrecciones.RecordCount# GT 0>
		<cfset acd_id_txt = '#Trim(tbCorrecciones.co_nombres)# #Trim(tbCorrecciones.co_apepat)# #Trim(tbCorrecciones.co_apemat)#'>
	</cfif>
	<!--- Verificar si hay cambio en duración y fecha --->
	<cfquery name="tbCorrecciones" datasource="#vOrigenDatosSAMAA#">
		SELECT * FROM movimientos_correccion
		WHERE sol_id = #vIdSolCO# AND co_tipo = 'DEBE DECIR' AND co_campo = 'DURACION'
	</cfquery>
	<cfif #tbCorrecciones.RecordCount# GT 0>
		<cfset mov_fecha_inicio = '#LsDateFormat(tbCorrecciones.co_fecha_inicio,'dd/mm/yyyy')#'>
		<cfif #tbCorrecciones.co_fecha_final# IS NOT ''>
			<cfset mov_fecha_final = '#LsDateFormat(tbCorrecciones.co_fecha_final,'dd/mm/yyyy')#'>
		</cfif>	
	</cfif>
</cfif>
<html>
	<head>
		<title>STCTIC - Asuntos Acad&eacute;mico-Administrativos</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<cfoutput>
			<link href="#vCarpetaCSS#/formularios.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/general.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/fuentes.css" rel="stylesheet" type="text/css">
			<link href="#vHttpWebGlobal#/css/jquery/jquery-ui-1.8.16.custom.css" type="text/css" rel="Stylesheet">
			<script type="text/javascript" src="#vHttpWebGlobal#/xmlHttpRequest.js"></script>
			<script type="text/javascript" src="#vHttpWebGlobal#/jquery/jquery-1.6.2.min.js"></script>
			<script type="text/javascript" src="#vHttpWebGlobal#/jquery/jquery-ui-1.8.16.custom.min.js"></script>
			<!--- <script src="#vCarpetaRaizLogica#/SpryAssets/SpryTabbedPanels.js" type="text/javascript"></script> --->
            <cfif #vMenuHidden# EQ 1>                        
			    <cfinclude template="include_script_menu.cfm">
            </cfif>                    
			<cfinclude template="include_script_formulario.cfm">
	    	<!--- <link href="#vCarpetaRaizLogica#/SpryAssets/SpryTabbedPanels.css" rel="stylesheet" type="text/css"> --->
			<!--- LLAMADO A CÓDIGO DE JAVA SCRIPT COMÚN O GLOBAL --->
            <script type="text/javascript" src="#vCarpetaRaizLogica#/sistema_ctic/comun/java_script/limpia_validacion.js"></script>
            <script type="text/javascript" src="#vCarpetaRaizLogica#/sistema_ctic/comun/java_script/mascara_entrada.js"></script>
            <script type="text/javascript" src="#vCarpetaRaizLogica#/sistema_ctic/comun/java_script/valida_general.js"></script>            
		</cfoutput>            
		<script language="JavaScript" type="text/JavaScript">
			// Listar la historia del asunto:
			function fHistoriaAsunto()
			{
				$.ajax({
					//async: false,
					method: "POST",
					data: 
						{
							<cfoutput>
							vSolMovId:#sol_id#,
							vTipoAsunto:'MOV'
							<cfif #vActivaCampos# NEQ ''>
								, 
								vActivaCampos:'#vActivaCampos#'
							</cfif>
							</cfoutput>							
						},
					url: "<cfoutput>#vCarpetaRaizLogicaSistema#</cfoutput>/comun/movimientos_asunto_lista.cfm",
					success: function(data) {
						$("#historia_asunto_dynamic").html(data);
					},
					error: function(data) {
						alert('ERROR AL DESPLEGAR LA HISTORIA DE LOS ASUNTOS');
						//alert(data);
					}
				});
			}
		</script>			
	</head>
	<body onLoad="fReordenar(); fActualizar(); fHistoriaAsunto();">
		<!--- Formulario --->
		<cfform name="formFt" method="POST" enctype="multipart/form-data" action="#vRutaPagSig#">
			<!-- Campos ocultos -->
			<cfinput name="vTipoComando" id="vTipoComando" type="hidden" value="#vTipoComando#">
			<cfinput name="vIdMov" id="vIdMov" type="#vTipoInput#" value="#vIdMov#"><!--- Sustituir el name= e id= por mov_id, es más correcto, aunque de la lista provenga vIdMov  --->
			<cfinput name="sol_id" id="sol_id" type="#vTipoInput#" value="#sol_id#">
			<cfinput name="mov_clave" id="mov_clave" type="#vTipoInput#" value="#mov_clave#"><!--- Para agregar nuevos movimientos --->
			<!--- En caso de corrección a oficio registrar el identificador de la solicitud FT-CTIC-31 --->
			<cfif #vTipoComando# IS 'CORRECCION'>
				<cfinput name="vIdSolCO" id="vIdSolCO" type="#vTipoInput#" value="#vIdSolCO#">
			</cfif>	
			<!-- Cintillo con nombre y número de registro --> 
            <cfif #vMenuHidden# EQ 1>
    			<table class="Cintillo">
	    			<tr>
		    			<td width="100%"><span class="Sans9GrNe">DETALLE DEL MOVIMIENTO &gt;&gt; </span><cfoutput><span class="Sans9Gr">#vTipoComando#</span></cfoutput></td>
<!--- ELIMINA XXXXXXXXXXXXXX
					<td width="100" align="right"><cfoutput><span class="Sans9Gr">Registro No. </span><span class="Sans9GrNe">#vIdMov#</span></cfoutput></td>
--->    
		    		</tr>
			    </table>
            </cfif>
			<!-- Detalle del movimiento -->
			<table width="90%" border="0">
				<tr>
                    <cfif #vMenuHidden# EQ 1>
    					<!-- Menú lateral --> 
	    				<td class="menuformulario">
                		    <cfinclude template="include_mov_menu.cfm">
<!--- ELIMINA XXXXXXXXXXXXXX
						<iframe src="mov_menu.cfm?vTipoComando=<cfoutput>#vTipoComando#</cfoutput>&vIdMov=<cfoutput>#vIdMov#</cfoutput>" frameborder="no" scrolling="false" width="180" height="650"></iframe>
--->    
		    			</td>
                    </cfif>
					<!-- Formulario -->
					<td class="formulario">
						<!-- Titulo del registro -->
						<cfoutput>
							<h1 align="center">
								<span class="Sans12NeNe">#Ucase(ctMovimiento.mov_titulo)#</span>
							</h1>
						</cfoutput>
						<cfoutput>
							<!-- Datos de la dependencia y el académico -->
							<table border="0" class="cuadrosFormularios">
								<tbody id="DatosAcademico">
									<!-- Dependencia de adscripción -->
									<tr id="linea_1">
										<td width="30%"><span class="Sans9GrNe"><cfif #mov_clave# IS 13 AND #mov_logico# IS 'No'>#ctMovimiento.etq_mov_dep_clave#<cfelse>#ctMovimiento.etq_dep_clave#</cfif></span></td>
										<td>
											<cfselect name="dep_clave" id="dep_clave" query="ctDependencia" value="dep_clave" display="dep_nombre" queryPosition="below" selected="#dep_clave#" class="datos100" disabled='#vActivaCampos#' onChange="fObtenerUbicaciones('dep_clave','ubicacion_dynamic','#dep_ubicacion#');">
												<cfif #ctDependencia.RecordCount# GT 1>
													<option value="">SELECCIONE</option>
												</cfif>
											</cfselect>
										</td>
									</tr>
									<!-- Ubicación -->
									<cfswitch expression="#mov_clave#">
										<cfcase value="5,6,7,8,9,10,12,13,14,15,16,17,18,19,20,25,26,27,28,29,36,38,39,42,70,71,74">
											<tr id="linea_2">
												<td width="30%"><span class="Sans9GrNe"><cfif #mov_clave# IS 13 AND #mov_logico# IS 'No'>#ctMovimiento.etq_mov_dep_ubicacion#<cfelse>#ctMovimiento.etq_dep_ubicacion#</cfif></span></td>
												<td><div id="ubicacion_dynamic"><!-- AJAX para obtener ubicaciones --></div></td>
											</tr>
										</cfcase>
									</cfswitch>	
									<!-- Nombre del académico -->
									<cfif #mov_clave# IS NOT 15 AND #mov_clave# IS NOT 16 AND #mov_clave# IS NOT 42>
										<tr id="linea_3">
											<td width="30%"><span class="Sans9GrNe">#ctMovimiento.etq_acd_id#</span></td>
											<td>
												<cfinput name="acd_id_txt" id="acd_id_txt" type="text" value="#acd_id_txt#" class="datos100" disabled>
												<cfinput name="acd_id" id="acd_id" type="hidden" value="#acd_id#">
												<cfinput name="vIdAcad" id="vIdAcad" type="hidden" value="#acd_id#">
											</td>
										</tr>
									</cfif>
									<!---
									<!-- División -->
									<tr><td colspan="2"><br><hr><br><td></tr>
									--->
								</tbody>
							</table>
							<table border="0" class="cuadrosFormularios">
								<tbody id="DatosMovimiento">
									<!-- Categoría y nivel del académico -->
									<cfswitch expression="#mov_clave#">
										<cfcase value="1,2,3,4,5,7,8,9,10,11,12,13,14,17,18,19,20,21,22,23,28,29,30,32,34,35,36,40,41">
											<tr id="linea_4">
												<td width="30%"><span class="Sans9GrNe">#ctMovimiento.etq_cn_clave#</span></td>
												<td>
													<cfselect name="cn_clave" id="cn_clave" query="ctCategoria" value="cn_clave" display="cn_siglas" selected="#cn_clave#" queryPosition="below" class="datos" disabled='#vActivaCampos#'>
														<option value="" selected>SELECCIONE</option>
													</cfselect>
												</td>
											</tr>
										</cfcase>
									</cfswitch>
									<!-- Tipo de contrato -->
									<cfswitch expression="#mov_clave#">
										<cfcase value="1,2,3,4,5,9,10,11,12,13,14,17,19,20,21,22,29,30,35,36">
											<tr id="linea_5">
												<td width="30%"><span class="Sans9GrNe">#ctMovimiento.etq_con_clave#</span></td>
												<td>
													<span class="Sans9Gr">
														<cfinput type="radio" name="con_clave" id="con_clave_o" value="3" checked="#Iif(con_clave EQ "3",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>Obra determinada
														<cfinput type="radio" name="con_clave" id="con_clave_i" value="2" checked="#Iif(con_clave EQ "2",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>Concurso Abierto
														<cfinput type="radio" name="con_clave" id="con_clave_d" value="1" checked="#Iif(con_clave EQ "1",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>Definitivo
														<!--- Otros tipo de contrato --->
														<cfif #mov_clave# IS 14>
															<br>
															<cfinput type="radio" name="con_clave" id="con_clave_o" value="6" checked="#Iif(con_clave EQ "6",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>Beca posdoctoral
															<cfinput type="radio" name="con_clave" id="con_clave_o" value="7" checked="#Iif(con_clave EQ "7",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>Personal Visitante
															<cfinput type="radio" name="con_clave" id="con_clave_o" value="8" checked="#Iif(con_clave EQ "8",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>Reincorporación
															<cfinput type="radio" name="con_clave" id="con_clave_o" value="9" checked="#Iif(con_clave EQ "9",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>Reingreso
														</cfif>
													</span>
												</td>
											</tr>
										</cfcase>
									</cfswitch>		
									<!-- Duración -->
									<tr id="linea_6">
										<cfoutput>
											<cfif #mov_clave# EQ 7 OR #mov_clave# EQ 8 OR ((#mov_clave# EQ 9 OR #mov_clave# EQ 10 OR #mov_clave# EQ 19) AND #con_clave# EQ 1) OR #mov_clave# EQ 12 OR #mov_clave# EQ 14 OR #mov_clave# EQ 17 OR #mov_clave# EQ 18 OR #mov_clave# EQ 28 OR #mov_clave# EQ 61>
												<!--- Fecha a partir de --->
												<td width="30%"><span class="Sans9GrNe">A partir del</span></td>
												<td>
													<input name="mov_fecha_inicio" id="mov_fecha_inicio" type="text" class="datos" size="10" maxlength="10" value="#LsDateFormat(mov_fecha_inicio,'dd/mm/yyyy')#" <cfif #vActivaCampos# EQ "disabled">disabled</cfif> onKeyPress="return MascaraEntrada(event, '99/99/9999');">
												</td>
											<cfelseif ((#mov_clave# EQ 9 OR #mov_clave# EQ 10 OR #mov_clave# EQ 19) OR #con_clave# GT 1) OR (#mov_clave# NEQ 15 AND #mov_clave# NEQ 16 AND #mov_clave# NEQ 34 AND #mov_clave# NEQ 42)><!--- No procesar movimientos que no tienen fecha --->
												<td width="30%"><span class="Sans9GrNe">
                                                    <cfif #mov_clave# EQ 22>Diferici&oacute;n de la fecha
                                                    <cfelseif #mov_clave# EQ 23>Fecha del periodo que informa
                                                    <cfelse>Duración</cfif></span>
                                                </td>
												<td>
													<!--- Desglose en años, meses y días --->
													<span id="duracion_dynamic"></span>
													<!--- Fechas --->
													<!---
													<span class="Sans9Gr"><cfif #mov_clave# NEQ 22 AND #mov_clave# NEQ 23>del</cfif></span>
													--->
													<input name="mov_fecha_inicio" id="mov_fecha_inicio" type="text" class="datos" size="10" maxlength="10" value="#LsDateFormat(mov_fecha_inicio,'dd/mm/yyyy')#" <cfif #vActivaCampos# EQ "disabled">disabled</cfif> <cfif #mov_clave# NEQ 22 AND #mov_clave# NEQ 23>onblur="fDesglosarDuracion();"</cfif> onKeyPress="return MascaraEntrada(event, '99/99/9999');">
													<span class="Sans9Gr"><cfif #mov_clave# EQ 22>a la fecha<cfelse>al</cfif></span>                
													<input name="mov_fecha_final" id="mov_fecha_final" type="text" class="datos" size="10" maxlength="10" value="#LsDateFormat(mov_fecha_final,'dd/mm/yyyy')#" <cfif #vActivaCampos# EQ "disabled">disabled</cfif> <cfif #mov_clave# NEQ 22 AND #mov_clave# NEQ 23>onblur="fDesglosarDuracion();"</cfif> onKeyPress="return MascaraEntrada(event, '99/99/9999');">
													<!--- NOTA: Falta caso temporal, definitivo y por cargo/nombramiento para los movimiento 20, 22, ... --->
												</td>
											</cfif>
										</cfoutput>
									</tr>
									<!-- Dependencia a la que cambia -->
									<cfif #mov_clave# IS 13>
										<tr id="linea_7">
											<td width="30%"><span class="Sans9GrNe"><cfif #mov_clave# IS 13 AND #mov_logico# IS 'No'>#ctMovimiento.etq_dep_clave#<cfelse>#ctMovimiento.etq_mov_dep_clave#</cfif></span></td>
											<td>
												<cfselect name="mov_dep_clave" id="mov_dep_clave" query="ctDependencia" value="dep_clave" display="dep_nombre" queryPosition="below" selected="#mov_dep_clave#" class="datos100" disabled='#vActivaCampos#' onChange="fObtenerUbicaciones('mov_dep_clave','ubicacion_dynamic_mov','#mov_dep_ubicacion#');">
													<cfif #ctDependencia.RecordCount# GT 1>
														<option value="">SELECCIONE</option>
													</cfif>
												</cfselect>
											</td>
										</tr>
									</cfif>
									<!-- Ubicación a la que cambia -->
									<cfif #mov_clave# IS 13 OR #mov_clave# IS 29>
										<tr id="linea_8">
											<td><span class="Sans9GrNe"><cfif #mov_clave# IS 13 AND #mov_logico# IS 'No'>#ctMovimiento.etq_dep_ubicacion#<cfelse>#ctMovimiento.etq_mov_dep_ubicacion#</cfif></span></td>
											<td><div id="ubicacion_dynamic_mov"></div></td>
										</tr>
									</cfif>
									<!-- Nombre del asesor -->
									<cfif #mov_clave# IS 38 OR #mov_clave# IS 39>
										<tr id="linea_9">
											<td width="30%"><span class="Sans9GrNe">#ctMovimiento.etq_acd_id_asesor#</span></td>
											<td>
												<cfinput name="acd_id_asesor_txt" id="acd_id_asesor_txt" class="datos100" type="text" size="100" maxlength="254" value="#acd_id_asesor_txt#" disabled='#vActivaCampos#' autocomplete="off" onKeyUp="fObtenerAcademico('acd_id_asesor');" onblur="if(this.value.length==0) document.getElementById('acd_id_asesor').value = null;"> 
												<cfinput name="acd_id_asesor" id="acd_id_asesor" type="hidden" value="#acd_id_asesor#">
												<br>
												<div id="academico_dynamic_acd_id_asesor" style="position:absolute;display:block;"></div>
											</td>
										</tr>
									</cfif>
									<!-- Número de plaza -->
									<cfswitch expression="#mov_clave#">
										<cfcase value="5,6,12,14,15,16,17,20,28,42">
											<tr id="linea_10">
												<td width="30%"><span class="Sans9GrNe">#ctMovimiento.etq_mov_plaza#</span></td>
												<td>
													<cfinput name="mov_plaza" id="mov_plaza" type="text" class="datos" size="8" maxlength="8" value="#mov_plaza#" disabled='#vActivaCampos#' onkeypress="return MascaraEntrada(event, '99999-99');">
												</td>
											</tr>
										</cfcase>
									</cfswitch>
									<!-- Clave COA -->
									<cfif #mov_clave# IS 5 OR #mov_clave# IS 15 OR #mov_clave# IS 16 OR #mov_clave# IS 17 OR #mov_clave# IS 28 OR #mov_clave# IS 42>
										<tr id="linea_10a">
											<td width="30%"><span class="Sans9GrNe">#ctMovimiento.etq_coa_id#</span></td>
											<td>
												<cfinput name="coa_id" id="coa_id" type="text" class="datos" size="20" maxlength="20" value="#coa_id#" disabled='#vActivaCampos#'>
											</td>
										</tr>
									</cfif>
									<!-- Categoría y nivel del movimiento (casí siempre de la plaza) -->
									<cfswitch expression="#mov_clave#">
										<cfcase value="5,6,9,10,12,15,16,17,19,20,25,27,28,36,42,70,71,74">
											<tr id="linea_11">
												<td width="30%"><span class="Sans9GrNe">#ctMovimiento.etq_mov_cn_clave#</span></td>
												<td>
													<cfselect name="mov_cn_clave" id="mov_cn_clave" query="ctCategoria" value="cn_clave" display="cn_siglas" selected="#mov_cn_clave#" queryPosition="below" class="datos" disabled='#vActivaCampos#'>
														<option value="" selected>SELECCIONE</option>
													</cfselect>
												</td>
											</tr>
										</cfcase>
									</cfswitch>
									<!-- Institución -->
									<cfswitch expression="#mov_clave#">
										<cfcase value="1,2,3,4,26">
											<tr id="linea_12">
												<td width="30%"><span class="Sans9GrNe">#ctMovimiento.etq_mov_institucion#</span></td>
												<td>
													<cfinput name="mov_institucion" id="mov_institucion" type="text" class="datos100" maxlength="254" value="#mov_institucion#" disabled='#vActivaCampos#'>
												</td>
											</tr>
										</cfcase>
									</cfswitch>						
									<!-- País, Estado y Ciudad -->
									<cfswitch expression="#mov_clave#">
										<cfcase value="1,3,4,26,38,40,41">
											<!-- País -->
											<tr id="linea_13">
												<td width="30%"><span class="Sans9GrNe">#ctMovimiento.etq_pais_clave#</span></td>
												<td>
													<cfselect name="pais_clave" id="pais_clave" class="datos" query="ctPais" value="pais_clave" display="pais_nombre" queryPosition="Below" disabled='#vActivaCampos#' selected="#pais_clave#" onchange="fObtenerEstados();">
														<option value="">SELECCIONE</option>
													</cfselect>
												</td>
											</tr>
											<cfif #mov_clave# IS NOT 38>
												<!-- Estado -->
												<tr id="linea_14">
													<td><span class="Sans9GrNe">#ctMovimiento.etq_edo_clave#</span></td>
													<td>
														<span id="estados_dynamic"><!-- AJAX: Lista de estados --></span>
													</td>
												</tr>
												<!-- Ciudad -->
												<tr id="linea_15">
													<td><span class="Sans9GrNe">#ctMovimiento.etq_mov_ciudad#</span></td>
													<td>
														<cfinput name="mov_ciudad" id="mov_ciudad" type="text" disabled='#vActivaCampos#' class="datos" value="#mov_ciudad#" size="35" maxlength="50">
													</td>
												</tr>
											</cfif>	
										</cfcase>
									</cfswitch>	
									<!-- Tipo de cambio-->
									<cfswitch expression="#mov_clave#">
										<cfcase value="13,20,22,29">
											<tr id="linea_16">
												<td width="30%"><span class="Sans9GrNe">#ctMovimiento.etq_cam_clave#</span></td>
												<td class="Sans9Gr">
													<cfif #mov_clave# IS 22>
														<cfinput name="cam_clave" id="cam_clave" type="checkbox" value="3" checked="#Iif(cam_clave EQ 3,DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>
													<cfelse>	
														<cfinput name="cam_clave" id="cam_clave_d" type="radio" value="1" checked="#Iif(cam_clave EQ 1,DE("yes"),DE("no"))#" disableddisabled='#vActivaCampos#'>Definitivo  
														<cfinput name="cam_clave" id="cam_clave_c" type="radio" value="3" checked="#Iif(cam_clave EQ 3,DE("yes"),DE("no"))#" disableddisabled='#vActivaCampos#'>Por Cargo/Nombramiento<br>
														<cfinput name="cam_clave" id="cam_clave_t" type="radio" value="2" checked="#Iif(cam_clave EQ 2,DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>Temporal
														<cfinput name="cam_clave" id="cam_clave_c" type="radio" value="4" checked="#Iif(cam_clave EQ 4,DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>Transferencia de plaza por creación de Centro
													</cfif>	
												</td>
											</tr>
										</cfcase>
									</cfswitch>						
									<!-- Cargo/Nombramiento-->
									<cfswitch expression="#mov_clave#">
										<cfcase value="13,22,29">
											<cfif #cam_clave# IS 3>
												<tr id="linea_17">
													<td width="30%"><span class="Sans9GrNe">#ctMovimiento.etq_mov_cargo#</span></td>
													<td>
														<cfinput name="mov_cargo" id="mov_cargo" type="text" class="datos100" maxlength="254" value="#mov_cargo#" disabled='#vActivaCampos#'>
													</td>
												</tr>
											</cfif>
										</cfcase>
									</cfswitch>
									<!-- Tipo de periodo (Año/Semestre) -->
									<cfswitch expression="#mov_clave#">
										<cfcase value="21,23,30,32">
											<tr id="linea_18">
												<td width="30%"><span class="Sans9GrNe">#ctMovimiento.etq_mov_periodo#</span></td>
												<td class="Sans9Gr">
													<cfinput name="mov_periodo" id="mov_periodo_a" type="radio" value="A" checked="#Iif(mov_periodo EQ 'A',DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>A&ntilde;o sab&aacute;tico
													<cfinput name="mov_periodo" id="mov_periodo_s" type="radio" value="S" checked="#Iif(mov_periodo EQ 'S',DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>Semestre sab&aacute;tico
												</td>
											</tr>
										</cfcase>
									</cfswitch>
									<!-- Prorroga de comisión -->
									<cfif #mov_clave# IS 4>
										<tr id="linea_19">
											<td width="30%"><span class="Sans9GrNe">#ctMovimiento.etq_mov_prorroga#</span></td>
											<td>
												<cfinput name="mov_prorroga" id="mov_prorroga" type="checkbox" value="Si" checked="#Iif(mov_prorroga EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>
											</td>
										</tr>	
									</cfif>
									<!-- Programa asociado a una obra determinada -->
									<cfif #mov_clave# IS 6>
										<tr id="linea_20">
											<td width="30%"><span class="Sans9GrNe">#ctMovimiento.etq_prog_clave#</span></td>
											<td>	
												<cfselect name="prog_clave" id="prog_clave" query="ctPrograma" value="prog_clave" display="prog_nombre" queryPosition="below" selected="#prog_clave#" class="datos100" disabled='#vActivaCampos#'>
													<option value="">NINGUNO</option>
												</cfselect>
											</td>
										</tr>
									</cfif>
									<!-- Tipo de baja -->
									<cfif #mov_clave# IS 14>
										<tr id="linea_21">
											<td width="30%"><span class="Sans9GrNe">#ctMovimiento.etq_baja_clave#</span></td>
											<td>
												<cfselect name="baja_clave" id="baja_clave" query="ctBaja" queryPosition="below" value="baja_clave" display="baja_descrip" selected="#baja_clave#" class="datos" disabled='#vActivaCampos#'>
													<option value="">SELECCIONE</option>
												</cfselect>
											</td>
										</tr>
									</cfif>	
									<!-- Tipo de actividad -->
									<cfif #mov_clave# IS 1 OR #mov_clave# IS 40 OR #mov_clave# IS 41>
										<tr id="linea_22">
											<td width="30%"><span class="Sans9GrNe">#ctMovimiento.etq_activ_clave#</span></td>
											<td>
												<cfselect name="activ_clave" id="activ_clave" query="ctActividad" queryposition="below" value="activ_clave" display="activ_descrip" selected="#activ_clave#" class="datos" disabled='#vActivaCampos#'>
													<option value="">SELECCIONE</option>
												</cfselect>
											</td>
										</tr>	
									</cfif>
									<!-- Texto variable -->
									<cfswitch expression="#mov_clave#">
										<cfcase value="4,6,32">
											<tr id="linea_23">
												<td width="30%"><span class="Sans9GrNe">#ctMovimiento.etq_mov_texto#</span></td>
												<td>
													<cfinput name="mov_texto" id="mov_texto" type="text" value="#mov_texto#" class="datos100" maxlength="254" disabled='#vActivaCampos#'>
												</td>
											</tr>
										</cfcase>	
									</cfswitch>
									<!-- Horas -->
									<cfswitch expression="#mov_clave#">
										<cfcase value="1,6,27,38,39,70">
											<tr id="linea_24">
												<td width="30%"><span class="Sans9GrNe">#ctMovimiento.etq_mov_horas#</span></td>
												<td>
													<cfinput name="mov_horas" id="mov_horas" type="text" value="#mov_horas#" class="datos" size="4" maxlength="4" onkeypress="return MascaraEntrada(event, '99.9');" disabled='#vActivaCampos#'>
												</td>
											</tr>
										</cfcase>	
									</cfswitch>
									<!-- Número variable -->
									<cfswitch expression="#mov_clave#">
										<cfcase value="5,6,15,17,25,28,42,44">
											<tr id="linea_25">
												<td width="30%"><span class="Sans9GrNe">#ctMovimiento.etq_mov_numero#</span></td>
												<td>
													<cfinput name="mov_numero" id="mov_numero" type="text" value="#mov_numero#" class="datos" size="3" maxlength="3" onkeypress="return MascaraEntrada(event, '999');" disabled='#vActivaCampos#'>
												</td>
											</tr>
										</cfcase>	
									</cfswitch>	
									<!-- Porcentaje de sueldo -->
									<cfif #mov_clave# IS 2 OR #mov_clave# IS 3 OR #mov_clave# IS 4>
										<tr id="linea_26">
											<td width="30%"><span class="Sans9GrNe">#ctMovimiento.etq_mov_sueldo#</span></td>
											<td>
												<cfinput name="mov_sueldo" id="mov_sueldo" type="text" value="#mov_sueldo#" class="datos" size="3" maxlength="3" onkeypress="return MascaraEntrada(event, '999');" disabled='#vActivaCampos#'><span class="Sans9Gr"> %</span>
											</td>
										</tr>
									</cfif>
									<!-- Erogación adicional, más un caso especial en cátedras (1) -->
									<cfswitch expression="#mov_clave#">
										<cfcase value="1,2,4,21,30,32">
											<tr id="linea_27">
												<td width="30%"><span class="Sans9GrNe">#ctMovimiento.etq_mov_erogacion#</span></td>
												<td>
													<cfinput name="mov_erogacion" id="mov_erogacion" type="text" value="#mov_erogacion#" class="datos" size="10" maxlength="10" onkeypress="return MascaraEntrada(event, '9999999.99');" disabled='#vActivaCampos#'>
												</td>
											</tr>
										</cfcase>	
									</cfswitch>
									<!-- Fecha variable 1 -->
									<cfswitch expression="#mov_clave#">
										<cfcase value="5,15,16,17,20,21,22,25,28,30,32,34,36,38,42">
											<tr id="linea_28">
												<td width="30%"><span class="Sans9GrNe">#ctMovimiento.etq_mov_fecha_1#</span></td>
												<td>
													<cfinput name="mov_fecha_1" id="mov_fecha_1" type="text" size="10" maxlength="10" value="#mov_fecha_1#" class="datos" disabled='#vActivaCampos#' onkeypress="return MascaraEntrada(event, '99/99/9999');">
													<!-- Fecha variable 2 como complemento de la 1 -->
													<cfif "#mov_clave#" IS 21 OR "#mov_clave#" IS 22 OR "#mov_clave#" IS 30 OR "#mov_clave#" IS 32>
														<span class="Sans9Gr">#ctMovimiento.etq_mov_fecha_2#</span>
														<cfinput name="mov_fecha_2" id="mov_fecha_2" type="text" size="10" maxlength="10" value="#mov_fecha_2#" class="datos" disabled='#vActivaCampos#' onkeypress="return MascaraEntrada(event, '99/99/9999');">
													</cfif>	
												</td>
											</tr>
										</cfcase>	
									</cfswitch>							
									<!-- Fecha variable 2 independiente -->
									<cfswitch expression="#mov_clave#">
										<cfcase value="25,28">
											<tr id="linea_29">
												<td width="30%"><span class="Sans9GrNe">#ctMovimiento.etq_mov_fecha_2#</span></td>
												<td>
													<cfinput name="mov_fecha_2" id="mov_fecha_2" type="text" size="10" maxlength="10" value="#mov_fecha_2#" class="datos" disabled='#vActivaCampos#' onkeypress="return MascaraEntrada(event, '99/99/9999');">
												</td>
											</tr>
										</cfcase>	
									</cfswitch>
									<!-- Lógico variable -->
									<cfswitch expression="#mov_clave#">
										<cfcase value="2,3,6,11,27,44">
											<tr id="linea_30">
												<td width="30%"><span class="Sans9GrNe">#ctMovimiento.etq_mov_logico#</span></td>
												<td>
													<cfinput name="mov_logico" id="mov_logico" type="checkbox" value="Si" checked="#Iif(mov_logico EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>
												</td>
											</tr>	
										</cfcase>	
									</cfswitch>
									<!-- Memo 1 -->
									<cfswitch expression="#mov_clave#">
										<cfcase value="1,2,3,4,5,6,11,14,15,16,17,21,23,26,28,30,32,38,39,40,41,42,27,70">
											<tr id="linea_31">
												<td width="30%"><span class="Sans9GrNe">#ctMovimiento.etq_mov_memo_1#</span></td>
												<td>
													<cftextarea name="mov_memo_1" id="mov_memo_1"  value="#mov_memo_1#" class="datos100" rows="5" disabled='#vActivaCampos#'></cftextarea>
												</td>
											</tr>
										</cfcase>	
									</cfswitch>
									<!-- Memo 2 -->
									<cfswitch expression="#mov_clave#">
										<cfcase value="1,6,15,42">
											<tr id="linea_32">
												<td width="30%"><span class="Sans9GrNe">#ctMovimiento.etq_mov_memo_2#</span></td>
												<td>
													<cftextarea name="mov_memo_2" id="mov_memo_2"  value="#mov_memo_2#" class="datos100" rows="5" disabled='#vActivaCampos#'></cftextarea>
												</td>
											</tr>
										</cfcase>	
									</cfswitch>
									<!-- Movimiento relacionado -->
									<cfswitch expression="#mov_clave#">
										<cfcase value="3,17,18,19,14,23,25,31,35,37">
											<tr id="linea_33">
												<td width="30%"><span class="Sans9GrNe">#ctMovimiento.etq_mov_relacionado#</span></td>
												<td>
													<cfinput name="mov_relacionado_txt" id="mov_relacionado_txt" type="text" value="#mov_relacionado_txt#" class="datos100" disabled>
													<cfinput name="mov_relacionado" id="mov_relacionado" type="hidden" value="#mov_relacionado#">
													<i>Número de movimiento: </i><b><cfoutput>#mov_relacionado#</cfoutput></b>
												</td>
											</tr>
										</cfcase>	
									</cfswitch>
									<!-- Licencia sin goce de sueldo solicitada al AAPAUNAM (SE AGREGÓ EL 23/02/2024) -->
									<cfif #mov_aapaunam# EQ 'Si'>
										<cfswitch expression="#mov_clave#">
											<cfcase value="11">
												<tr id="linea_34">
													<td width="30%"><span class="Sans9GrNe">#ctMovimiento.etq_mov_aapaunam#</span></td>
													<td>
														<cfinput name="mov_aapaunam" id="mov_aapaunam_s" type="radio" value="A" checked="#Iif(mov_aapaunam EQ 'Si',DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>Si
														<cfinput name="mov_aapaunam" id="mov_aapaunam_n" type="radio" value="S" checked="#Iif(mov_aapaunam EQ 'No',DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>No
													</td>
												</tr>
											</cfcase>	
										</cfswitch>
									</cfif>
								</tbody>	
							</table>
							<!-- Dicatámenes y opiniones -->
							<!--- 
								NOTA: Hay un problema con estos datos en la base, pues no se puede determinar si el valor es FALSO o NULO.
								No obstante, prefiero resolver esto en el futuro para no tener que modificar el diseño actual.
							--->
							<cfif #ctMovimiento.etq_mov_dictamen_cd# IS NOT '' OR #ctMovimiento.etq_mov_opinion_ci# IS NOT '' OR #ctMovimiento.etq_mov_opinion_dir# IS NOT ''>
								<table border="0" class="cuadrosFormularios">
									<!-- Encabezados -->
									<tr bgcolor="##CCCCCC">
										<td width="85%"><div class="Sans9GrNe"><!---DICT&Aacute;MENES Y OPINIONES---></div></td>
										<td width="15%" align="center"><div class="Sans9GrNe">APROBATORIO</div></td>
									</tr>
									<!-- Comisión Dictaminadora -->
									<cfif #ctMovimiento.etq_mov_dictamen_cd# IS NOT '' AND NOT (mov_clave IS 13 AND cam_clave IS NOT 1)>
										<tr>
											<td class="Sans9GrNe">#ctMovimiento.etq_mov_dictamen_cd#</td>
											<td class="Sans9GrNe" align="center">
												<cfinput name="mov_dictamen_cd" id="mov_dictamen_cd_s" type="radio" value="Si" disabled='#vActivaCampos#' checked="#Iif(mov_dictamen_cd EQ 'Si',DE("yes"),DE("no"))#">S&iacute; 
												<cfinput name="mov_dictamen_cd" id="mov_dictamen_cd_n" type="radio" value="No" disabled='#vActivaCampos#' checked="#Iif(mov_dictamen_cd EQ 'No',DE("yes"),DE("no"))#">No 
											</td>
										</tr>
									</cfif>
									<!-- Consejero Interno -->
									<cfif #ctMovimiento.etq_mov_opinion_ci# IS NOT ''>
										<tr>
											<td class="Sans9GrNe">#ctMovimiento.etq_mov_opinion_ci#</td>
											<td class="Sans9GrNe" align="center">
												<cfinput name="mov_opinion_ci" id="mov_opinion_ci_s" type="radio" value="Si" disabled='#vActivaCampos#' checked="#Iif(mov_opinion_ci EQ 'Si',DE("yes"),DE("no"))#">S&iacute;
												<cfinput name="mov_opinion_ci" id="mov_opinion_ci_n" type="radio" value="No" disabled='#vActivaCampos#' checked="#Iif(mov_opinion_ci EQ 'No',DE("yes"),DE("no"))#">No
											</td>
										</tr>
									</cfif>
									<!-- Director -->
									<cfif #ctMovimiento.etq_mov_opinion_dir# IS NOT ''>
										<tr>
											<td class="Sans9GrNe">#ctMovimiento.etq_mov_opinion_dir#</td>
											<td class="Sans9GrNe" align="center">
												<cfinput name="mov_opinion_dir" id="mov_opinion_dir_s" type="radio" value="Si" disabled='#vActivaCampos#' checked="#Iif(mov_opinion_dir EQ 'Si',DE("yes"),DE("no"))#">S&iacute;
												<cfinput name="mov_opinion_dir" id="mov_opinion_dir_n" type="radio" value="No" disabled='#vActivaCampos#' checked="#Iif(mov_opinion_dir EQ 'No',DE("yes"),DE("no"))#">No 
											</td>
										</tr>
									</cfif>
								</table>
							</cfif>
<!---						SE ENVIÓ AL MENÚ PRINCIPAL
							<!-- Situación del movimiento -->
							<table border="0" class="cuadrosFormularios">
								<tr>
									<!-- El movimiento fue modificado -->
									<td width="30%"><span class="Sans9GrNe">El movimiento fue modificado</span></td>
									<td>
										<cfinput name="mov_modificado" id="mov_modificado" type="checkbox" value="Si" checked="#Iif(mov_modificado EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>
									</td>

									<!-- El movimiento fue cancelado -->
									<td align="right"><span class="Sans9GrNe">El movimiento fue cancelado</span></td>
									<td width="8%" align="right">
										<cfinput name="mov_cancelado" id="mov_cancelado" type="checkbox" value="Si" checked="#Iif(mov_cancelado EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>
									</td>
								</tr>	
							</table>
--->
							<!-- Destinos/instituciones (desplegable) -->
							<cfif #sol_id# IS NOT '' AND (#mov_clave# IS 2 OR #mov_clave# IS 21 OR #mov_clave# IS 23 OR #mov_clave# IS 30 OR #mov_clave# IS 32)>
								<table border="0" class="cuadrosFormularios">
									<!-- Titulo del recuadro -->
									<tr bgcolor="##CCCCCC">
										<td width="98%" colspan="2">
											<span class="Sans9GrNe">
												<center>
													<cfif #mov_clave# IS 2>
														DESTINOS DE LA COMISI&Oacute;N
													<cfelse>
														INSTITUCIONES DONDE REALIZA SU PERIODO SAB&Aacute;TICO
													</cfif>
												</center>
											</span>
										</td>
										<td width="2%"><div id="b_destinos_dynamic"><img src="#vCarpetaIMG#/ir_abajo_15.jpg" style="border:none;" onClick="fMostrarDestinos('#sol_id#');"></div></td>
									</tr>
									<!-- Lista de destinos/instituciones -->
									<tr>
										<td colspan="2" id="destinos_dynamic">
											<!-- AJAX: Lista de destinos/instituciones -->
										</td>
									</tr>
								</table>
							</cfif>
							<!-- Oponentes en COA (desplegable) -->
							<cfif #sol_id# IS NOT '' AND (#mov_clave# IS 5 OR #mov_clave# IS 15 OR #mov_clave# IS 16 OR #mov_clave# IS 17 OR #mov_clave# IS 28 OR #mov_clave# IS 42)>
								<table border="0" class="cuadrosFormularios">
									<!-- Titulo del recuadro -->
									<tr bgcolor="##CCCCCC">
										<td width="98%" colspan="2">
											<span class="Sans9GrNe">
												<center>
													<cfif #mov_clave# IS 15 OR #mov_clave# IS 42>
														LISTA DE CONCURSANTES
													<cfelse>
														LISTA DE OPONENTES
													</cfif>
												</center>
											</span>
										</td>
										<td width="2%"><div id="b_oponentes_dynamic"><img src="#vCarpetaIMG#/ir_abajo_15.jpg" style="border:none;" onClick="fMostrarOponentes('#mov_clave#','#coa_id#');"></div></td>
									</tr>
									<!-- Lista de oponentes -->
									<tr>
										<td colspan="2" id="oponentes_dynamic">
											<!-- AJAX: Lista de oponentes -->
										</td>
									</tr>
								</table>
							</cfif>
							<!-- Historia del asunto (desplegable) -->
							<cfif #sol_id# IS NOT ''>
								<table border="0" class="cuadrosFormularios">
									<!-- Titulo del recuadro -->
									<tr bgcolor="##CCCCCC">
										<td width="100%" colspan="2">
											<span class="Sans9GrNe"><center>HISTORIA DEL ASUNTO</center></span>
										</td>
									</tr>
									<!-- Historia del asunto -->
									<tr>
										<td>
											<div id="historia_asunto_dynamic"><!-- AJAX: Historia del asunto --></div>                                        
											<!-- AJAX: Historia del asunto -->
										</td>
									</tr>
								</table>
								<div id="divAsunto_jQuery" title="DETALLE DE ASUNTO"></div>                                
<!---
								<table border="0" class="cuadrosFormularios">
									<!-- Titulo del recuadro -->
									<tr bgcolor="##CCCCCC">
										<td width="98%" colspan="2">
											<span class="Sans9GrNe"><center>HISTORIA DEL ASUNTO</center></span>
										</td>
										<td width="2%">
											<div id="b_historia_asunto_dynamic"><img src="#vCarpetaIMG#/ir_abajo_15.jpg" style="border:none;" onClick="fHistoriaAsunto('CONSULTA');"></div>
										</td>
									</tr>
									<!-- Historia del asunto -->
									<tr>
										<td colspan="2" id="td_historia_asunto_dynamic">
											<div id="historia_asunto_dynamic"><!-- AJAX: Historia del asunto --></div>                                        
											<!-- AJAX: Historia del asunto -->
										</td>
									</tr>
									<!-- Formulario para agregar asunto -->
									<tr>
										<td colspan="2" id="frm_agregar_asunto">
											<!-- AJAX: Formulario para agregar asunto -->
										</td>
									</tr>
								</table>
--->								
							</cfif>
							<!-- Correcciones a oficio (desplegable) -->
							<cfquery name="tbCorrecciones" datasource="#vOrigenDatosSAMAA#">
								SELECT * FROM movimientos_asunto 
								INNER JOIN movimientos_correccion 
								ON movimientos_asunto.sol_id = movimientos_correccion.sol_id
								WHERE asu_reunion = 'CTIC' 
								AND movimientos_correccion.mov_id = #vIdMov#
								AND ssn_id < #Session.sSesion#
							</cfquery>
							<cfif #tbCorrecciones.RecordCount# GT 0>
								<table border="0" class="cuadrosFormularios">
									<!-- Titulo del recuadro -->
									<tr bgcolor="##CCCCCC">
										<td width="98%" colspan="2">
											<span class="Sans9GrNe"><center>CORRECCIONES A OFICIO</center></span>
										</td>
										<td width="2%"><div id="b_correcciones_oficio_dynamic"><img src="#vCarpetaIMG#/ir_abajo_15.jpg" style="border:none;" onClick="fMostrarCorreccionesOficio('#mov_id#','#mov_clave#');"></div></td>
									</tr>
									<!-- Lista de correcciones a oficio -->
									<tr>
										<td colspan="2" id="correcciones_oficio_dynamic">
											<!-- AJAX: Lista de correcciones a oficio -->
										</td>
									</tr>
								</table>
							</cfif>
							<!-- Observaciones -->
							<table border="0" class="cuadrosFormularios">
								<!-- Titulo del recuadro -->
								<tr bgcolor="##CCCCCC">
									<td>
										<span class="Sans9GrNe"><center>OBSERVACIONES<!---#Ucase(ctMovimiento.etq_mov_observaciones)#---></center></span>
									</td>
								</tr>
								<tr>
									<td>
										<cftextarea name="mov_observaciones" id="mov_observaciones"  value="#mov_observaciones#" class="datos100" rows="5" disabled='#vActivaCampos#'></cftextarea>
                                    </td>
								</tr>
							</table>
						</cfoutput>
					</td>
				</tr>
			</table>
		</cfform>
		<!--- Include para abrir archivo PDF enviando parámetros por POST --->                    
		<cfinclude template="#vCarpetaRaizLogicaSistema#/comun/consulta_pdf_comun.cfm">        
<!---
    <script type="text/javascript">
var TabbedPanels1 = new Spry.Widget.TabbedPanels("TabbedPanels1");
        </script>
--->		
	</body>
</html>