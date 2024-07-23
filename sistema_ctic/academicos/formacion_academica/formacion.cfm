<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA CREA: 05/06/2009 --->
<!--- FECHA ULTIMA MOD.: 12/01/2023 --->
<!--- FORMULARIO DE FORMACIÓN ACADÉMICA --->
<!--- Parámetros --->
<cfparam name="vFechaCreacion" default="">
<!--- Determinar si se debe crear un nuevo registro u obtener uno existente--->
<cfif #vTipoComando# IS "NUEVO">
	<!--- Valores predeterminados --->
	<cfset grado_clave = '1'>
	<cfset pais_clave = 'MEX'>
	<cfset uni_clave = '3024'>
	<cfset vInstitucionClave = '3024'>
	<cfset dep_clave = ''>
	<cfset car_clave = ''>
	<cfset carrera_programa = ''>
	<cfset grado_obtenido = '0'>
	<cfset porcentaje_creditos = ''>
	<cfset porcentaje_tesis = ''>
	<cfset fecha_grado = ''>
	<cfset tesis_titulo = ''>
	<cfset tesis_director = ''>
	<cfset mencion_honorifica = '0'>
<cfelseif #vTipoComando# IS "EDITA" OR #vTipoComando# IS "CONSULTA">
	<!--- Obtener los datos del registro --->
	<cfquery name="tbFormacionAcademica" datasource="#vOrigenDatosCURRICULUM#">
		SELECT * FROM formacion_academica
		WHERE acd_id = #vAcadId# AND cap_fecha_crea = '#vFechaCreacion#'
	</cfquery>
	<!--- Cargar los campos con los valores correspondientes --->
	<cfset grado_clave = '#tbFormacionAcademica.grado_clave#'>
	<cfset pais_clave = '#tbFormacionAcademica.pais_clave#'>
	<cfset uni_clave = '#tbFormacionAcademica.uni_clave#'>
	<cfset vInstitucionClave = '#tbFormacionAcademica.institucion_clave#'>
	<cfset dep_clave = '#tbFormacionAcademica.dep_clave#'>
	<cfset car_clave = '#tbFormacionAcademica.car_clave#'>
	<cfset carrera_programa = '#tbFormacionAcademica.carrera_programa#'>
	<cfset grado_obtenido = #Iif(tbFormacionAcademica.grado_obtenido IS 1, DE("Si"),DE("No"))#>
	<cfset porcentaje_creditos = '#tbFormacionAcademica.porcentaje_creditos#'>
	<cfset porcentaje_tesis = '#tbFormacionAcademica.porcentaje_tesis#'>
	<cfset fecha_grado = #LsDateFormat(tbFormacionAcademica.fecha_grado,'dd/mm/yyyy')#>
	<cfset tesis_titulo = '#tbFormacionAcademica.tesis_titulo#'>
	<cfset tesis_director = '#tbFormacionAcademica.tesis_director#'>
	<cfset mencion_honorifica = #Iif(tbFormacionAcademica.mencion_honorifica IS 1,DE("Si"),DE("No"))#>
</cfif>
<!--- Habilitar/Deshabilitar controles --->
<cfif #vTipoComando# EQ "NUEVO" OR #vTipoComando# EQ "EDITA">
	<cfset vActivaCampos = "">
<cfelse>
	<cfset vActivaCampos = "disabled">
</cfif>
<!--- Obtener datos del académico --->
<cfquery name="tbAcademico" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM academicos 
    WHERE acd_id = #vAcadId#
</cfquery>

<!--- Obtener datos del catalogo de pais --->
<cfquery name="ctPais" datasource="#vOrigenDatosCATALOGOS#">
	SELECT * FROM catalogo_paises 
    ORDER BY pais_nombre
</cfquery>

<!--- Obtener datos del catalogo de grados --->
<cfquery name="ctGrado" datasource="#vOrigenDatosCATALOGOS#">
	SELECT * FROM catalogo_grados 
    ORDER BY grado_clave
</cfquery>

<!--- Obtener datos del catalogo de dependencias (facultades y escuelas) --->
<cfquery name="ctDependencia" datasource="#vOrigenDatosCATALOGOS#">
	SELECT * FROM catalogo_dependencias 
    WHERE dep_tipo = 'FYE' 
    ORDER BY dep_nombre
</cfquery>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<title>STCTIC - Asuntos Acad&eacute;mico-Administrativos</title>
		<cfoutput>
			<link href="#vCarpetaCSS#/formularios.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/general.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/fuentes.css" rel="stylesheet" type="text/css">
			<link href="#vHttpWebGlobal#/css/jquery/jquery-ui-1.8.16.custom.css" type="text/css" rel="Stylesheet">
			<!--- JQUERY --->
			<script type="text/javascript" src="#vHttpWebGlobal#/jquery/jquery-1.6.2.min.js"></script>
			<script type="text/javascript" src="#vHttpWebGlobal#/jquery/jquery-ui-1.8.16.custom.min.js"></script>
        	<script type="text/javascript" src="http://www.cic-ctic.unam.mx:31220/comun_cic/xmlHttpRequest.js"></script>
		    <script type="text/javascript" src="mascaraEntrada.js"></script>            
            
		</cfoutput>
		<script type="text/javascript">
			// Actaulizar el formulario según los datos ingresados:
			function fActualizar()
			{
				// LLamar AJAX:
				// Controles para la UNAM: 
				document.getElementById('var_fac_unam').style.display = 'none';
				document.getElementById('var_car_unam').style.display = 'none';
				document.getElementById('var_car_otro').style.display = 'none';
				if (document.getElementById('institucion_clave').value == '3024')
				{
					// Facultades:
					if (document.getElementById('grado_clave').value <= 2) {
						document.getElementById('var_fac_unam').style.display = '';
					}
					// Carreras/programas:	
					if (document.getElementById('grado_clave').value == 5) {
						document.getElementById('var_car_otro').style.display = '';
					} else if (document.getElementById('grado_clave').value > 0) {
						document.getElementById('var_car_unam').style.display = '';
					}
					fListarCarreras();					
				}
				else
				{
					document.getElementById('var_fac_unam').style.display = 'none';
					document.getElementById('var_car_unam').style.display = 'none';
					document.getElementById('var_car_otro').style.display = '';
				}
				// Controles para grado obtenido:
				document.getElementById('var_fec_grado').style.display = 'none';
				document.getElementById('var_tes_tit').style.display = 'none';
				document.getElementById('var_tes_dir').style.display = 'none';
				document.getElementById('var_mencion').style.display = 'none';
				document.getElementById('var_tes_ava').style.display = 'none';
				document.getElementById('var_creditos').style.display = 'none';
				if (document.getElementById('grado_obtenido_si').checked)
				{
					document.getElementById('var_fec_grado').style.display = '';
					if (document.getElementById('grado_clave').value > 0) {
						document.getElementById('var_tes_tit').style.display = '';
						document.getElementById('var_tes_dir').style.display = '';
						document.getElementById('var_mencion').style.display = '';
						// Actualizar el porcentaje de cráditos y tesis (a 100%) para se registre ese valor:
						document.getElementById('porcentaje_creditos').value = 100;
						document.getElementById('porcentaje_tesis').value = 100;
					}	
				}
				else
				{
					if (document.getElementById('grado_clave').value > 0) document.getElementById('var_tes_ava').style.display = '';
					document.getElementById('var_creditos').style.display = '';
					// Limpiar los campos que se ocultan:
					document.getElementById('fecha_grado').value = '';
					document.getElementById('tesis_titulo').value = '';
					document.getElementById('tesis_director').value = '';
					document.getElementById('mencion_honorifica').checked = false;
				}
			}
			// Obtener la lista de universidades del país seleccionado:
			function fListarUniversidades()
			{
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Función de atención a las petición HTTP:
				xmlHttp.onreadystatechange = function(){
					if (xmlHttp.readyState == 4) {
						document.getElementById('universidades_dynamic').innerHTML = xmlHttp.responseText;
						fActualizar();
					}
				}
				// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
				xmlHttp.open("POST", "lista_universidades.cfm", true);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "vPais=" + encodeURIComponent(document.getElementById('pais_clave').value);
				parametros += "&vInstitucionClave=" + encodeURIComponent('<cfoutput>#vInstitucionClave#</cfoutput>');
				parametros += "&vActivaCampos=" + encodeURIComponent('<cfoutput>#vActivaCampos#</cfoutput>');
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);
			}
			// Obtener la lista de universidades del país seleccionado:
			function fListarCarreras()
			{
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Función de atención a las petición HTTP:
				xmlHttp.onreadystatechange = function(){
					if (xmlHttp.readyState == 4) {
						document.getElementById('carreras_dynamic').innerHTML = xmlHttp.responseText;
					}
				}
				// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
				xmlHttp.open("POST", "lista_carreras.cfm", true);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "vGrado=" + encodeURIComponent(document.getElementById('grado_clave').value);
				parametros += "&vCarrera=" + encodeURIComponent(document.getElementById('car_clave').value);
				parametros += "&vActivaCampos=" + encodeURIComponent('<cfoutput>#vActivaCampos#</cfoutput>');
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);
			}
			function fEnviarComando(vAccion, vParam)
			{
				if (vAccion == 'GUARDA' && vParam == 'NUEVO')
				{
					document.forms[0].action = 'formacion_nuevo.cfm';
					document.forms[0].submit();
				}
				else if (vAccion == 'GUARDA' && vParam == 'EDITA')
				{
					document.forms[0].action = 'formacion_edita.cfm';
					document.forms[0].submit();
				}
				else if (vAccion == 'CANCELA' && vParam == 'NUEVO')
				{
					window.location.replace('consulta_formacion.cfm?vAcadId=<cfoutput>#vAcadId#</cfoutput>');
				}
				else if (vAccion == 'ELIMINA')
				{
					if (confirm('¿En realidad desea eliminar permanentemente el registro que aparece en pantalla?'))
					{
						document.forms[0].action = 'formacion_elimina.cfm';
						document.forms[0].submit();
					}	
				}
				else if (vAccion == 'CANCELA' && vParam == 'EDITA')
				{
					document.getElementById('vTipoComando').value = 'CONSULTA';
					document.forms[0].action = 'formacion.cfm';
					document.forms[0].submit();
				}
				else if (vAccion == 'EDITA')
				{
					document.getElementById('vTipoComando').value = 'EDITA';
					document.forms[0].action = 'formacion.cfm';
					document.forms[0].submit();
				}
			}
		</script>
	</head>
	<body onload="fListarUniversidades();">
		<!-- Cintillo con nombre del módulo y filtro --> 
		<table class="Cintillo">
			<tr>
				<td><span class="Sans9GrNe">FORMACI&Oacute;N ACAD&Eacute;MICA &gt;&gt; </span><span class="Sans9Gr">DETALLE</span></td>
				<td align="right">
					<span class="Sans9Gr">
						<b>Filtro:</b> <cfoutput>#tbAcademico.acd_apepat# #tbAcademico.acd_apemat# #tbAcademico.acd_nombres#</cfoutput>
					</span>
				</td>
			</tr>
		</table>
		<cfform method="post">
			<!--- Campos ocultos --->
			<cfinput name="vAcadId" id="vAcadId" value="#vAcadId#" type="hidden">
			<cfinput name="vFechaCreacion" id="vFechaCreacion" value="#vFechaCreacion#" type="hidden"><!--- Necesario para obtener el registro --->
			<cfinput name="vTipoComando" id="vTipoComando" value="#vTipoComando#" type="hidden">
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td width="180" valign="top">
						<table width="180" border="0">
							<!-- Menú del submódulo -->
							<tr><td><div class="linea_menu"></div></td></tr>
							<tr>
								<td valign="top"><div align="left" class="Sans10NeNe">Men&uacute;:</div></td>
							</tr>
							<cfif #vTipoComando# EQ "CONSULTA">
								<!-- Opción: Corregir -->
								<tr>
									<td valign="top">
										<input type="button" class="botones" value="Corregir" onclick="fEnviarComando('EDITA','');">
									</td>
								</tr>
								<!-- Opción: Eliminar -->
								<tr>
									<td valign="top">
										<input type="button" class="botones" value="Eliminar" onclick="fEnviarComando('ELIMINA','');">
									</td>
								</tr>
								<!-- Opción: Imprimir -->
								<tr>
									<td valign="top">
										<input type="button" class="botones" value="Imprimir">
									</td>
								</tr>
								<!-- Opción: Regresar -->
								<tr>
									<td>
										<input type="button" value="Regresar" class="botones" onclick="window.location.replace('consulta_formacion.cfm?vAcadId=<cfoutput>#vAcadId#</cfoutput>');">
									</td>
								</tr>
							<cfelse>
								<!-- Opción: Gurdar -->
								<tr>
									<td valign="top">
										<input type="submit" class="botones" value="Guardar" onclick="fEnviarComando('GUARDA','<cfoutput>#vTipoComando#</cfoutput>');">
									</td>
								</tr>
								<!-- Opción: Cancelar -->
								<tr>
									<td valign="top">
										<input type="reset" class="botones" value="Cancelar" onclick="fEnviarComando('CANCELA','<cfoutput>#vTipoComando#</cfoutput>');">
									</td>
								</tr>
							</cfif>
							<cfif #vTipoComando# EQ "CONSULTA">
                                <!--- Include para consutar o anexar documento(s) en PDF --->
                                <cfmodule template="#vCarpetaINCLUDE#/archivopdf_vista_carga.cfm" ModuloConsulta="GRADOACAD" AcdId="#vAcadId#" NumRegistro="" SsnId="" DepClave="" SolStatus="#grado_clave#" SolDevolucionSatus="" vCarpetaINCLUDE="#vCarpetaINCLUDE#">
                            </cfif>
							<!-- Más información -->
							<tr><td><br><div class="linea_menu"></div></td></tr>
							<!-- Número de académico -->
							<tr>
								<td><span class="Sans9GrNe">No. de acad&eacute;mico:</span><span class="Sans9Vi"><cfoutput>#LSNumberFormat(tbAcademico.acd_id,'99999')#</cfoutput></span></td>
							</tr>
						</table>
					</td>
					<td width="844" valign="top">
						<!---
						<!-- Datos del académico -->
						<table width="844" cellspacing="0" border="0">
							<tr>
								<td>
									<div id="AcadDatos_dynamic"><!-- AJAX: Lista Datos Académico --></div>
								</td>
							</tr>
						</table>
						--->
						<!-- Titulo del registro -->
						<h1  class="Sans12NeNe" align="center">
							<br>
							FORMACI&Oacute;N ACAD&Eacute;MICA
						</h1>
						<br>
						<!-- Detalle --->	
						<table width="95%" border="0" class="cuadros">
							<cfoutput>
								<!-- Nivel de estudios -->
								<tr>
									<td width="25%"><span class="Sans9GrNe">Estudios de</span></td>
									<td>
										<cfselect name="grado_clave" id="grado_clave" query="ctGrado" display="grado_descrip" value="grado_clave" selected="#grado_clave#" class="datos" disabled="#vActivaCampos#" onchange="fActualizar();">
										</cfselect>
									</td>
								</tr>
								<!-- País donde realizó sus estudios -->
								<tr>
									<td><span class="Sans9GrNe">Pa&iacute;s</span></td>
									<td>
										<span class="Sans9GrNe">
											<cfselect name="pais_clave" id="pais_clave" class="datos" query="ctPais" display="pais_nombre" value="pais_clave" selected="#pais_clave#" disabled="#vActivaCampos#" onchange="fListarUniversidades();">
											</cfselect>
										</span>
									</td>
								</tr>
								<!-- Universidad donde realizó sus estudios -->
								<tr>
									<td class="Sans9GrNe">Universidad</td>
									<td>
										<div id="universidades_dynamic">
											<!--- AJAX: Universidades del país selecionado --->
										</div>
									</td>
								</tr>
								<!-- Facultad de la UNAM -->
								<tr id="var_fac_unam">
									<td><span class="Sans9GrNe">Facultad</span></td>
									<td>
										<span class="Sans9GrNe">
											<cfselect name="dep_clave" id="dep_clave" class="datos100" query="ctDependencia" display="dep_nombre" value="dep_clave" selected="#dep_clave#" queryPosition="below" disabled="#vActivaCampos#">
												<option value="">SELECCIONE</option>
											</cfselect>
										</span>
									</td>
								</tr>
								<!-- Carrera/Programa de la UNAM -->
								<tr id="var_car_unam">
									<td class="Sans9GrNe">Carrera/Programa</td>
									<td>
										<div id="carreras_dynamic">
											<!--- AJAX: Carreras/Programas de la UNAM --->
											<input name="car_clave" id="car_clave" value="#car_clave#" type="hidden" >
										</div>
									</td>
								</tr>
								<!-- Carrera o programa en otros paises -->
								<tr id="var_car_otro">
									<td><span class="Sans9GrNe">Carrera/Programa</span></td>
									<td>
										<cfinput name="carrera_programa" id="carrera_programa" value="#carrera_programa#" type="text" maxlength="254" class="datos100" disabled="#vActivaCampos#">
									</td>
								</tr>
								<!-- Grado obtenido -->
								<tr>
									<td><span class="Sans9GrNe">Grado obtenido</span></td>
									<td class="Sans9Gr">
										<cfinput type="radio" name="grado_obtenido" value="Si" id="grado_obtenido_si" checked="#Iif(grado_obtenido EQ "Si",DE("yes"),DE("no"))#" onclick="fActualizar();" disabled="#vActivaCampos#">S&iacute;
										<cfinput type="radio" name="grado_obtenido" value="No" id="grado_obtenido_no" checked="#Iif(grado_obtenido EQ "No",DE("yes"),DE("no"))#" onclick="fActualizar();" disabled="#vActivaCampos#">No
									</td>
								</tr>
								<!-- Fecha de obtención del grado -->
								<tr id="var_fec_grado">
									<td><span class="Sans9GrNe">Fecha de obtenci&oacute;n</span></td>
									<td>
										<cfinput name="fecha_grado" id="fecha_grado" value="#fecha_grado#" type="text" class="datos" size="10" maxlength="10" disabled="#vActivaCampos#"  onkeypress="return MascaraEntrada(event, '99/99/9999');">
									</td>
								</tr>
								<!-- Titulo de la tesis -->
								<tr id="var_tes_tit">
									<td><span class="Sans9GrNe">Titulo de tesis</span></td>
									<td>
										<cfinput name="tesis_titulo" id="tesis_titulo" value="#tesis_titulo#" type="text" class="datos100" maxlength="254" disabled="#vActivaCampos#">
									</td>
								</tr>
								<!-- Director de la tesis -->
								<tr id="var_tes_dir">
									<td class="Sans9GrNe">Director de tesis</td>
									<td>
										<cfinput name="tesis_director" id="tesis_director" value="#tesis_director#" type="text" class="datos100" maxlength="254" disabled="#vActivaCampos#">              
									</td>
								</tr>
								<!-- Créditos -->
								<tr id="var_creditos">
									<td><span class="Sans9GrNe">Cr&eacute;ditos</span></td>
									<td>
										<cfinput name="porcentaje_creditos" id="porcentaje_creditos" value="#porcentaje_creditos#" type="text" class="datos" size="3" maxlength="3" onkeypress="return MascaraEntrada(event, '999');" disabled="#vActivaCampos#">
										<span class="Sans9GrNe">%</span>
									</td>
								</tr>
								<!-- Avance de tesis -->
								<tr id="var_tes_ava">
									<td><span class="Sans9GrNe">Avance de tesis</span></td>
									<td>
										<cfinput name="porcentaje_tesis" id="porcentaje_tesis" value="#porcentaje_tesis#" type="text" class="datos" size="3" maxlength="3" onkeypress="return MascaraEntrada(event, '999');" disabled="#vActivaCampos#">
										<span class="Sans9GrNe">%</span>
									</td>
								</tr>
								<!-- Mención honorífica -->
								<tr id="var_mencion">
									<td><span class="Sans9GrNe">Menci&oacute;n honor&iacute;fica</span></td>
									<td>
										<cfinput name="mencion_honorifica" id="mencion_honorifica" value="Si" type="checkbox" class="datos" checked="#Iif(mencion_honorifica EQ "Si",DE("yes"),DE("no"))#" disabled="#vActivaCampos#">
									</td>
								</tr>
							</cfoutput>	
						</table>
					</td>
				</tr>
			</table>
		</cfform>
        <cfif #vTipoComando# EQ "CONSULTA">
            <!--- Include para abrir archivo PDF enviando parámetros por POST --->                    
            <cfinclude template="#vCarpetaRaizLogicaSistema#/comun/consulta_pdf_comun.cfm">
        </cfif>                
	</body>
</html>
