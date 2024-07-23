<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO DURAN --->
<!--- FECHA CREA: 05/03/2010 --->
<!--- FECHA ULTIMA MOD.: 11/09/2019 --->
<!--- FORMULARIO PARA AGREGAR NUEVOS CARGOS ACADEMICOS --->

<!--- MIEMBRO DEL CTIC --->
<cfparam name="vCaaId" default=0>

<cfquery name="tbCargosAcdAdmin" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM ((academicos_cargos AS T1
	LEFT JOIN academicos AS T2 ON T1.acd_id = T2.acd_id)
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C1 ON T1.dep_clave = C1.dep_clave)
	LEFT JOIN catalogo_nomadmo AS C2 ON T1.adm_clave = C2.adm_clave
	WHERE caa_id = #vCaaId# 
</cfquery>

<!--- Obtener información del catálogo de categoría y nivel (CATÁLOGOS LOCALES SAMAA) --->
<cfquery name="tbCatalogoCargos" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_nomadmo
    WHERE adm_ctic_miembro = 1 <!---(adm_clave = '01' OR adm_clave = '12' OR adm_clave = '13' OR adm_clave = '32' OR adm_clave = '82'  OR adm_clave = '84')--->
    ORDER BY adm_descrip
</cfquery>

<!--- Obtener información del catálogo de categoría y nivel (CATÁLOGOS LOCALES SAMAA) --->
<cfquery name="ctConsejerosPeriodo" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_consejero_rep_fechas 
	ORDER BY rep_fecha_inicio DESC
</cfquery>

<!--- Obtener información del catálogo de categoría y nivel (CATÁLOGOS GENERALES MYSQL) --->
<cfquery name="tbCatalogoEntidad" datasource="#vOrigenDatosCATALOGOS#">
	SELECT * FROM catalogo_dependencias
    WHERE dep_clave LIKE '03%' AND dep_status = 1 
    ORDER BY dep_nombre
</cfquery>

<cfif #vTipoComando# EQ "NUEVO">
	<cfset vActivaCampos = "">
	<cfset vActivaCamposN = "">
	<cfset vCaa_Id = "">
	<cfset vNombre_Acad = "">
	<cfset vAcd_clave = "">	
	<cfset vAdm_clave = "">
	<cfset vDep_clave = "">
	<cfset vFecha_inicio = "">
	<cfset vFecha_final = "">
	<cfset vSsn_id = "">
	<cfset vCaa_status = "A">
	<cfset vCaa_depto = "">
	<cfset vCaa_email = "">
	<cfset vCaa_oficio = "">
	<cfset vCaa_nota = "">	
<cfelseif #vTipoComando# EQ "EDITA" OR #vTipoComando# EQ "CONSULTA">
	<cfif #vTipoComando# EQ "EDITA">
		<cfset vActivaCampos = "">
		<cfset vActivaCamposN = "disabled">
	<cfelseif #vTipoComando# EQ "CONSULTA">
		<cfset vActivaCampos = "disabled">
		<cfset vActivaCamposN = "disabled">
	</cfif>
	<cfset vCaa_Id = #tbCargosAcdAdmin.caa_id#>
	<cfset vNombre_Acad = #tbCargosAcdAdmin.acd_apepat# & " " & #tbCargosAcdAdmin.acd_apemat# & " " & #tbCargosAcdAdmin.acd_nombres#>
	<cfset vAcd_clave = #tbCargosAcdAdmin.acd_id#>	
	<cfset vAdm_clave = #tbCargosAcdAdmin.adm_clave#>
	<cfset vDep_clave = #tbCargosAcdAdmin.dep_clave#>
	<cfset vFecha_inicio = #LsDateFormat(tbCargosAcdAdmin.caa_fecha_inicio,"dd/mm/yyyy")#>
	<cfset vFecha_final = #LsDateFormat(tbCargosAcdAdmin.caa_fecha_final,"dd/mm/yyyy")#>
	<cfset vSsn_id = #tbCargosAcdAdmin.ssn_id#>
	<cfset vCaa_status = #tbCargosAcdAdmin.caa_status#>
	<cfset vCaa_depto = #tbCargosAcdAdmin.caa_depto#>
	<cfset vCaa_email = #tbCargosAcdAdmin.caa_email#>
	<cfset vCaa_oficio = #tbCargosAcdAdmin.no_oficio#>
	<cfset vCaa_nota = #tbCargosAcdAdmin.caa_nota#>	
</cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
		<title>STCTIC - Miembros del CTIC</title>
		<cfoutput>
			<link href="#vCarpetaCSS#/formularios.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/general.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/fuentes.css" rel="stylesheet" type="text/css">
			<link href="#vHttpWebGlobal#/css/jquery/jquery-ui-1.8.16.custom.css" type="text/css" rel="Stylesheet">
			<script type="text/javascript" src="#vHttpWebGlobal#/xmlHttpRequest.js"></script>
			<script type="text/javascript" src="#vHttpWebGlobal#/jquery/jquery-1.6.2.min.js"></script>
			<script type="text/javascript" src="#vHttpWebGlobal#/jquery/jquery-ui-1.8.16.custom.min.js"></script>

			<!--- JAVA SCRIPT USO LOCAL --->
			<script type="text/javascript" src="javaScript_consejeros.js"></script>

			<!--- LLAMADO A CÓDIGO DE JAVA SCRIPT COMÚN O GLOBAL --->
			<script type="text/javascript" src="#vCarpetaRaizLogicaSistema#/comun/java_script/ajax_lista_academicos.js"></script>
			<script type="text/javascript" src="#vCarpetaRaizLogicaSistema#/comun/java_script/limpia_validacion.js"></script>
			<script type="text/javascript" src="#vCarpetaRaizLogicaSistema#/comun/java_script/mascara_entrada.js"></script>
			<script type="text/javascript" src="#vCarpetaRaizLogicaSistema#/comun/java_script/valida_campo_lleno.js"></script>
			<script type="text/javascript" src="#vCarpetaRaizLogicaSistema#/comun/java_script/valida_formato_fecha.js"></script>
		</cfoutput>

	</head>
	<body onload="vActivaDesCampos();">
		<!-- Cintillo con nombre del módulo y filtro--> 
		<table class="Cintillo">
			<tr>
				<td>
					<span class="Sans9GrNe">MIEMBROS DEL CTIC &gt;&gt; </span><span class="Sans9Gr"><cfoutput>#vTipoComando#</cfoutput></span>
				</td>
				<td align="right">
					<span class="Sans9Gr">
						Sesi&oacute;n vigente: <cfoutput>#LsNumberFormat(Session.sSesion,'9999')#</cfoutput>
					</span>
				</td>
			</tr>
		</table>
		<!-- Contenido -->
		<cfform id="frmCaptura" action="" method="post">
			<table width="1024" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td width="180" height="14" valign="top">
						<table width="155" border="0" align="center">
							<!-- Menú de la lista de sesiones -->
							<tr><td><div class="linea_menu"></div></td></tr>
							<tr>
								<td valign="top"><div align="left" class="Sans10NeNe">Men&uacute;:</div></td>
							</tr>
							<!--- NOTA: Buscar un mejor lugar para poner esto, o quizá no sea necesario en hiddens (!) --->
							<tr>
								<td>
									<cfinput type="#vTipoInput#" name="vTipoComando" id="vTipoComando" value="#vTipoComando#">
									<cfinput type="#vTipoInput#" name="vCaaId" id="vCaaId" value="#vCaaId#">
									<cfinput type="#vTipoInput#" name="vConsejeroPeriodo" id="vConsejeroPeriodo" value="#LsDateFormat(ctConsejerosPeriodo.rep_fecha_final, 'dd/mm/yyyy')#">
								</td>
							</tr>
							<cfif #Session.sTipoSistema# IS 'stctic' AND #Session.sUsuarioNivel# LTE 1>
								<cfif #vTipoComando# EQ "CONSULTA">
                                    <!-- Opción: Corregir -->
                                    <tr>
                                        <td>
                                            <input type="button" class="botones" value="Corregir" onclick="fSubmitFormulario('EDITA');" <cfif #Session.sTipoSistema# IS 'sic'>disabled</cfif>>
                                        </td>
                                    </tr>
                                    <!-- Opción: Regresar -->
                                    <tr>
                                        <td>
                                            <input type="button" class="botones" value="Eliminar" onclick="fSubmitFormulario('ELIMINAR');" <cfif #Session.sTipoSistema# IS 'sic'>disabled</cfif>>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <input name="subRegresa" type="button" class="botones" value="Regresar" onclick="fSubmitFormulario('REGRESA');">
                                        </td>
                                    </tr>
<!---
                                    <!--- LÍNEA SEPARA --->
									<tr><td valign="top"><br><div class="linea_menu"></div></td></tr>
--->
									<!--- Módulo para consultar y/o anexar documento(s) en PDF --->
                                    <cfif #Session.sTipoSistema# IS 'stctic'>
										<!--- <cfoutput>#vCarpetaINCLUDE#</cfoutput>--->
										<cfmodule template="#vCarpetaINCLUDE#/archivopdf_vista_carga.cfm" ModuloConsulta="MCTIC" AcdId="#vAcd_clave#" NumRegistro="#vCaa_Id#" SsnId="" DepClave="" SolStatus="" SolDevolucionSatus="" vCarpetaINCLUDE="#vCarpetaINCLUDE#">
                                    </cfif>
                                    <!--- LÍNEA SEPARA --->
									<tr><td valign="top"><br><div class="linea_menu"></div></td></tr>
                                </cfif>
							</cfif>
							<cfif #vTipoComando# EQ "EDITA" OR #vTipoComando# EQ "NUEVO">
								<!-- Opción: Guardar -->
								<tr>
									<td>
										<cfinput name="Submit" type="button" class="botones" value="Guardar" onclick="fSubmitFormulario('GUARDA');">
										<cfinput type="hidden" name="GuardaReg" value="Nuevo">
									</td>
								</tr>
								<!-- Opción: Cancelar -->
								<tr>
								
									<td>
										<cfinput name="subCancela" type="button" class="botones" value="Cancelar" onclick="fSubmitFormulario('CANCELA');">
									</td>
								</tr>
							</cfif>
						</table>
						<cfif #CGI.SERVER_PORT# EQ '31221'>
                        	<cfoutput>
                            	<blockquote>
                            	<span class="Sans10NeNe">acd_id: </span><span class="Sans10Ne">#vAcd_clave#</span>
								<br />
								<span class="Sans10NeNe">caa_id: </span><span class="Sans10Ne">#vCaa_Id#</span>
								<br />
								<span class="Sans10NeNe">adm_clave: </span><span class="Sans10Ne">#vAdm_clave#</span>
								</blockquote>
							</cfoutput>
						</cfif>
					</td>
					<!-- Columna derecha (formulario de captura) -->
					<td width="844">
						<div class="Sans12GrNe" align="center">
							  <br>
							  NOMBRAMIENTOS ADMINISTRATIVOS<br>
							  <br>
						</div>
						<table width="600" border="0" align="center" class="cuadros">
							<cfoutput>
							<!-- Académico -->
							<tr>
								<td width="106"><span class="Sans9GrNe">Acad&eacute;mico</span></td>
								<td>
									<input type="hidden" name="vLigaAjax" id="vLigaAjax" value="#vAjaxListaAcademicos#">
									<cfinput name="vAcadNom" id="vAcadNom" type="text" class="datos" style="width:400px;" maxlength="100" autocomplete="off" onKeyUp="fTeclas();" value="#vNombre_Acad#" disabled="#vActivaCamposN#"><!--- fListaSeleccionAcademico('NAME') --->
									<cfinput name="vSelAcad" id="vSelAcad" type="#vTipoInput#" value="#vAcd_clave#">
									<cfinput name="vAcadRfc" id="vAcadRfc" type="hidden" value="">
									<cfinput name="vAcadId" id="vAcadId" type="hidden" value="">
									<cfinput name="caa_status" id="caa_status" type="#vTipoInput#" value="#vCaa_status#">
									<br>
									<div id="lstAcad_dynamic" style="position:absolute;display:block;">
										<!-- AJAX: Lista desplegable de académicos -->
									</div>
								</td>
							</tr>
							<!-- Cargo -->
							<tr>
								<td><span class="Sans9GrNe">Cargo</span></td>
								<td>
									<cfselect name="adm_clave" id="adm_clave" class="datos" query="tbCatalogoCargos" queryPosition="below" display="adm_descrip" value="adm_clave" style="width:400px;" selected="#vAdm_clave#" disabled="#vActivaCampos#" onChange="vActivaDesCampos();">
										<option value="">SELECCIONE</option>
									</cfselect>
								</td>
							</tr>
							<!-- Entidad -->
							<tr>
								<td><span class="Sans9GrNe">Entidad</span></td>
								<td>
									<cfselect name="dep_clave" id="dep_clave" class="datos" query="tbCatalogoEntidad" queryPosition="below" display="dep_nombre" value="dep_clave" style="width:400px;" selected="#vDep_clave#" disabled="#vActivaCampos#">
										<option value="">SELECCIONE</option>
									</cfselect>
								</td>
							</tr>
							<!-- Periodo -->
							<tr id="trApartir">
								<td>A partir del</td>
								<td>
									<cfinput type="text" name="caa_apartir" id="caa_apartir" value="#vFecha_inicio#" class="datos" size="10" maxlength="10" onkeypress="return MascaraEntrada(event, '99/99/9999');" disabled="#vActivaCampos#">
								</td>
							</tr>
							<tr id="trPeriodo">
								<td><span class="Sans9GrNe">Periodo del</span></td>
								<td>
									<cfinput type="text" name="caa_fecha_inicio" value="#vFecha_inicio#" class="datos" id="caa_fecha_inicio" onChange="CalcularSiguienteFecha();" size="10" maxlength="10" onkeypress="return MascaraEntrada(event, '99/99/9999');" disabled="#vActivaCampos#"> 
									<span class="Sans9GrNe"> al </span>
									<cfinput name="caa_fecha_final" id="caa_fecha_final" value="#vFecha_final#" type="text" class="datos" size="10" maxlength="10" onkeypress="return MascaraEntrada(event, '99/99/9999');" disabled="#vActivaCampos#">
								</td>
							</tr>
							<!-- Departamento -->
							<tr id="trJefeDepto">
								<td><span class="Sans9GrNe">Departamento</span></td>
								<td>
									<cfinput name="caa_depto" id="caa_depto" type="text" class="datos100" maxlength="254" value="#vCaa_depto#" disabled="#vActivaCampos#">
								</td>
							</tr>
							<!-- Acta -->
							<tr id="trOficio">
								<td><span class="Sans9GrNe">N&uacute;mero de oficio</span></td>
								<td><cfinput type="text" name="caa_oficio" id="caa_oficio" value="#vCaa_oficio#" class="datos" height="18" maxlength="18" disabled="#vActivaCampos#"></td>
							</tr>
							<!--- <cfif #vTipoComando# EQ "EDITA" OR #vTipoComando# EQ "CONSULTA"> --->
								<tr id="trRenunacia">
									<td><span class="Sans9GrNe">Renuncia:</span></td>
									<td>
										<cfinput type="checkbox" name="renuncia" id="renuncia" value="checkbox" disabled="#vActivaCampos#" onClick="fChkRenuncia();">
									</td>
								</tr>
							<!--- </cfif>--->
							<tr id="trActa">
								<td><span class="Sans9GrNe">N&uacute;mero de acta</span></td>
								<td>
									<cfinput name="ssn_id" id="ssn_id" type="text" class="datos" size="3" maxlength="4" value="#vSsn_id#" onkeypress="return MascaraEntrada(event, '9999');" disabled="#vActivaCampos#">
								</td>
							</tr>
							<!-- Correo electrónico para uso de informacion CTIC -->
							<tr>
								<td valign="top"><span class="Sans9GrNe">Correo electrónico</span></td>
								<td>
									<cfinput name="caa_email" id="caa_email" type="text" class="datos" size="75" maxlength="85" value="#vCaa_email#" disabled="#vActivaCampos#">
								</td>
							</tr>
							<!-- Nota -->
							<tr>
								<td valign="top"><span class="Sans9GrNe">Nota</span></td>
								<td>
									<cftextarea name="caa_nota" id="caa_nota" cols="70" rows="5" class="datos100" value="#vCaa_nota#" disabled="#vActivaCampos#"></cftextarea>
								</td>
							</tr>
							</cfoutput>
						</table>
					</td>
				</tr>
			</table>
		</cfform>
<!---        
		<!--- Include para abrir archivo PDF enviando parámetros por POST --->
		<cfinclude template="#vCarpetaRaizLogicaSistema#/comun/consulta_pdf_comun.cfm">
--->		
	</body>
</html>
