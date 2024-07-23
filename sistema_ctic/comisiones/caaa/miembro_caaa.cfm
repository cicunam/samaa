<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM_PICHARDO DUAN --->
<!--- FECHA CREA: 05/03/2010 --->
<!--- FECHA ULTIMA MOD.: 30/11/2015 --->

<!--- MIEMBRO DEL CAAA --->

<cfparam name="vComisionId" default=0>
<!---
<!-- ESTE LLAMADO PUEDE SER COMÚN PARA VARIAS COSAS -->
<cfinclude template="../javascript/comisiones_scripts_valida.cfm">
--->
<!-- BASE DE DATOS DE LA MIEMBRO DE LA COMISION  -->
<cfquery name="tbComisionAcd" datasource="#vOrigenDatosSAMAA#">
	SELECT academicos_comisiones.acd_id AS AcdIdComision, academicos_comisiones.acd_id_remplazo AS AcdIdSus, academicos.acd_id AS AcdId, * FROM (academicos_comisiones
	LEFT JOIN academicos ON academicos_comisiones.acd_id = academicos.acd_id OR academicos_comisiones.acd_id_remplazo = academicos.acd_id)
	WHERE academicos_comisiones.comision_acd_id = #vComisionId# 
</cfquery>

<!-- BASE DE DATOS DE CATALOGOS DE COMISIONES -->
<cfquery name="ctComision" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_comisiones ORDER BY comision_nombre
</cfquery>

<!-- BASE DE DATOS CATALOGO DE SESIONES -->
<cfquery name="ctSesiones" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM sesiones 
    WHERE ssn_id >= #Session.sSesion# AND ssn_clave = 1
    ORDER BY ssn_id
</cfquery>

<cfif #vTipoComando# EQ "NUEVO">
	<cfset vActivaCampos = "">
	<cfset vActivaCamposN = "">    
	<cfset vComision_Id = "">
	<cfset vNombre_Acad = "">
	<cfset vNombre_AcadSus = "">    
	<cfset vAcd_id = "">
	<cfset vAcd_idSus = "">    
	<cfset vComision_clave = "">
	<cfset vDep_clave = "">
	<cfset vFecha_inicio = "">
	<cfset vPresidente = 0>
	<cfset vTemporal = 0>
	<cfset vSsn_id = #Session.sSesion#>
	<cfset vNota = "">
	<cfset vComision_status = 1>
<cfelseif #vTipoComando# EQ "EDITA" OR #vTipoComando# EQ "CONSULTA">
	<cfif #vTipoComando# EQ "EDITA">
		<cfset vActivaCampos = "">
	<cfelseif #vTipoComando# EQ "CONSULTA">
		<cfset vActivaCampos = "disabled">
	</cfif>
	<cfset vComision_Id = #tbComisionAcd.comision_acd_id#>
	<cfset vAcd_idSus = ''>
	<cfset vNombre_AcadSus = ''>
	<cfloop query="tbComisionAcd">
		<cfif #AcdIdComision# EQ #AcdId#>
			MIEMBRO
			<cfset vAcd_id = #acd_id#>
			<cfset vNombre_Acad = #acd_apepat# & " " & #acd_apemat# & " " & #acd_nombres#>
		<cfelseif #AcdIdSus# EQ #AcdId#>
			EN SUSTIRUCION
			<cfset vAcd_idSus = #acd_id_remplazo#>
			<cfset vNombre_AcadSus = #acd_apepat# & " " & #acd_apemat# & " " & #acd_nombres#>
		</cfif>
	</cfloop>
	<cfset vComision_clave = #tbComisionAcd.comision_clave#>
	<cfset vFecha_inicio = #LsDateFormat(tbComisionAcd.fecha_inicio,'dd/mm/yyyy')#>
	<cfset vPresidente = #tbComisionAcd.presidente#>
	<cfset vTemporal = #tbComisionAcd.sustitucion#>
	<cfset vSsn_id = #tbComisionAcd.ssn_id#>
	<cfset vNota = #tbComisionAcd.nota#>
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
			<script type="text/javascript" src="#vHttpWebGlobal#/xmlHttpRequest.js"></script>
		</cfoutput>
		<!--- LLAMADO A CÓDIGO DE JAVA SCRIPT COMÚN O GLOBAL --->        
		<cfoutput>
			<script type="text/javascript" src="#vCarpetaRaiz#/sistema_ctic/comun/java_script/ajax_lista_academicos.js"></script>
            <script type="text/javascript" src="#vCarpetaRaiz#/sistema_ctic/comun/java_script/limpia_validacion.js"></script>
            <script type="text/javascript" src="#vCarpetaRaiz#/sistema_ctic/comun/java_script/mascara_entrada.js"></script>
            <script type="text/javascript" src="#vCarpetaRaiz#/sistema_ctic/comun/java_script/valida_campo_lleno.js"></script>
            <script type="text/javascript" src="#vCarpetaRaiz#/sistema_ctic/comun/java_script/valida_formato_fecha.js"></script>
		</cfoutput>
		<!--- JAVA SCRIPT USO LOCAL --->
		<script type="text/javascript" src="javaScript_miembros_caaa.js"></script>
        
	</head>
	<body onLoad="fSustitucionTmp();">
		<!-- Cintillo con nombre del módulo y filtro--> 
		<table class="Cintillo">
			<tr>
				<td>
					<span class="Sans9GrNe">COMISIÓN DE ASUNTOS ACADÉMICO-ADMINISTRATIVOS </span><span class="Sans9Gr"><cfoutput>#vTipoComando#</cfoutput></span>
				</td>
				<td align="right">
					<span class="Sans9Gr">
						Sesi&oacute;n vigente: <cfoutput>#LsNumberFormat(Session.sSesion,'9999')#</cfoutput>
					</span>
				</td>
			</tr>
		</table>
		<!-- Contenido -->
		<cfform action="" method="post">
		<table width="1024" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td width="180" height="14" valign="top">
					<table width="155" border="0" align="center">
						<!-- Menú de la lista de sesiones -->
						<tr><td><div class="linea_menu"></div></td></tr>
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">Men&uacute;:
						  </div></td>
						</tr>
						<!-- NOTA: Buscar un mejor lugar para poner esto, o quizá no sea necesario en hiddens (!) --->
						<tr>
							<td>
								<cfinput type="hidden" name="vTipoComando" id="vTipoComando" value="#vTipoComando#">
								<cfinput type="hidden" name="vComisionId" id="vComisionId" value="#vComisionId#">
								<cfinput type="hidden" name="comision_clave" id="comision_clave" value="1">                                
							</td>
						</tr>
						<cfif #vTipoComando# EQ "CONSULTA">
							<!-- Opción: Corregir -->
							<tr>
								<td>
									<cfinput name="Submit" type="button" class="botones" value="Corregir" onclick="fSubmitFormulario('EDITA');">
								</td>
							</tr>
							<!-- Opción: Eliminar -->
							<tr>
								<td>
									<cfinput name="cmdEliminar" type="button" class="botones" value="Eliminar" onclick="fSubmitFormulario('ELIMINAR');">
								</td>
							</tr>
						</cfif>
						<cfif #vTipoComando# EQ "EDITA" OR #vTipoComando# EQ "NUEVO">
							<!-- Opción: Guardar -->
							<tr>
								<td>
									<cfinput name="Submit" type="button" class="botones" value="Guardar" onclick="fSubmitFormulario('GUARDA');">
									<cfinput type="hidden" name="GuardaReg" value="Nuevo">
								</td>
							</tr>
							<!---
							<!-- Opción: Restablecer -->
							<tr>
								<td>
									<cfinput name="Submit2" type="reset" class="botones" value="Restablecer">
								</td>
							</tr>
							--->
							<!-- Opción: Cancelar -->
							<tr>
							
								<td>
									<cfinput name="subCancela" type="button" class="botones" value="Cancelar" onclick="fSubmitFormulario('CANCELA');">
								</td>
							</tr>
						</cfif>
						<cfif #vTipoComando# EQ 'CONSULTA'>
							<!-- Navegación -->
							<tr><td valign="top"><br><div class="linea_menu"></div></td></tr>
							<tr>
								<td><span class="Sans10NeNe">Navegaci&oacute;n:</span></td>
							</tr>
							<!-- Menú principal -->
							<tr>
								<td>
									<input type="button" class="botones" value="Menú principal" onClick="top.location.replace('../../<cfoutput>#Session.sTipoSistema#</cfoutput>_index.cfm');">
								</td>
							</tr>
							<!-- Lista de sesiones -->
							<tr>
								<td>
									<input name="subRegresa" type="button" class="botones" value="Regresar" onClick="fSubmitFormulario('REGRESA');">
								</td>
							</tr>
						</cfif>
					</table>
			  </td>
				<!-- Columna derecha (formulario de captura) -->
				<td width="844">
					<table width="600" border="0" align="center" class="cuadros">
						<cfoutput>
						<!-- Académico -->
						<tr>
							<td width="126"><span class="Sans9GrNe">Acad&eacute;mico</span></td>
							<td colspan="2">
								<input type="hidden" name="vLigaAjax" id="vLigaAjax" value="#vAjaxListaAcademicos#">
								<cfinput name="vAcadNom" id="vAcadNom" type="text" class="datos" style="width:400px;" maxlength="100" autocomplete="off" onKeyUp="fListaSeleccionAcademico('NAME');" value="#vNombre_Acad#" disabled='#vActivaCampos#'>
								<cfinput name="vSelAcad" id="vSelAcad" type="hidden" value="#vAcd_id#">
								<cfinput name="vAcadRfc" id="vAcadRfc" type="hidden" value="">
								<cfinput name="vAcadId" id="vAcadId" type="hidden" value="">
								<br>
								<div id="lstAcad_dynamic" style="position:absolute;display:block;">
									<!-- AJAX: Lista desplegable de académicos -->
								</div>
							</td>
						</tr>
						<tr>
							<td valign="top"><span class="Sans9GrNe">Presidente</span></td>
							<td colspan="2"><cfinput type="checkbox" name="presidente" id="presidente" value="1" checked="#Iif(vPresidente EQ "1",DE("yes"),DE("no"))#"  disabled='#vActivaCampos#'></td>
						</tr>
						<tr>
							<td valign="top"><span class="Sans9GrNe">Sustituci&oacute;n temporal </span></td>
							<td colspan="2"><cfinput type="checkbox" name="sustitucion" id="sustitucion" value="1" checked="#Iif(vTemporal EQ "1",DE("yes"),DE("no"))#" onclick="fSustitucionTmp();" disabled='#vActivaCampos#'></td>
						</tr>
						<tr id="trSesion">
							<td valign="top"></td>
							<td width="90" valign="top"><span class="Sans9GrNe">Para la sesi&oacute;n</span></td>
							<td width="370" valign="top">
								<cfselect name="ssn_id" id="ssn_id" class="datos" query="ctSesiones" queryPosition="below" display="ssn_id" value="ssn_id" style="width:100px;" selected="#vSsn_id#" disabled='#vActivaCampos#'>
                            		<option value="">SELECCIONE</option>
								</cfselect>
							</td>
						  </tr>
						<tr>
							<td valign="top"><span class="Sans9GrNe">En sustituci&oacute;n de:</span></td>
                                <td colspan="2">
                                    <cfinput name="vNomAcadSus" id="vNomAcadSus" type="text" class="datos" style="width:400px;" maxlength="100" autocomplete="off" onKeyUp="fListaSeleccionAcademicoSus();" value="#vNombre_AcadSus#" disabled='#vActivaCampos#'>
                                    <cfinput name="vSelAcadSus" id="vSelAcadSus" type="hidden" value="#vAcd_idSus#">
                                    <br>
                                    <div id="lstAcadSus_dynamic" style="position:absolute; display:block;">
                                        <!-- AJAX: Lista desplegable de académicos -->
                                    </div>
                                </td>
							</tr>
						<tr>
						  <td><span class="Sans9GrNe">Fecha de inicio</span></td>
						  <td colspan="2"><cfinput type="text" name="fecha_inicio" value="#vFecha_inicio#" class="datos" id="fecha_inicio" size="10" maxlength="10" onkeypress="return MascaraEntrada(event, '99/99/9999');" disabled='#vActivaCampos#'></td>
						  </tr>
						<tr>
						  <td valign="top"><span class="Sans9GrNe">Nota</span></td>
						  <td colspan="2"><cftextarea name="comision_nota" id="comision_nota" cols="70" rows="5" class="datos100" value="#vNota#" disabled='#vActivaCampos#'></cftextarea></td>
						  </tr>
						</cfoutput>
					</table>
					<br>
					<cfif #vTipoComando# EQ "CONSULTA">
                        <table  width="600" border="0" class="cuadros" bgcolor="#EEEEEE" align="center">
                            <tr bgcolor="#CCCCCC">
                                <td><div align="center" class="Sans10NeNe">SESIONES DE LA CAAA QUE HA PARTICIPADO</div></td>
                                <td width="15" align="right"><div id="bSesiones"><img src="<cfoutput>#vCarpetaIMG#</cfoutput>/ir_abajo_15.jpg" style="border:none;" onClick="fDesplegable('SESIONES',1);"></div></td>
                            </tr>
							<tbody id="dSesiones" style="display:none;">
                                <tr>
                                    <td colspan="2">SESIONES</td>
                                </tr>
							</tbody>
                        </table>
                        <table  width="600" border="0" class="cuadros" bgcolor="#EEEEEE" align="center">
                            <tr bgcolor="#CCCCCC">
                                <td><div align="center" class="Sans10NeNe">CORREOS ENVIADOS</div></td>
                                <td width="15" align="right"><div id="bCorreo"><img src="<cfoutput>#vCarpetaIMG#</cfoutput>/ir_abajo_15.jpg" style="border:none;" onClick="fDesplegable('CORREO',1);"></div></td>
                            </tr>
							<tbody id="dCorreo" style="display:none;">
                                <tr>
                                    <td colspan="2">CORREOS</td>
                                </tr>
							</tbody>
                        </table>
					</cfif>
			  </td>
			</tr>
		</table>
		</cfform>
	</body>
</html>
