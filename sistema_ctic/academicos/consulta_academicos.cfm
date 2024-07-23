<!--- CREADO: ARAM PICHARDO--->
<!--- EDITO: ARAM PICHARDO--->
<!--- FECHA CREA: 05/06/2009--->
<!--- FECHA ULTIMA MOD.: 26/02/2024 --->

<!--- PENDIENTE --->
<!--- Registrar la ruta del módulo actual --->
<cfset Session.sModulo = '#CGI.SCRIPT_NAME#'>
<!--- Crear un arreglo para guardar la información del filtro --->
<cfif NOT IsDefined('Session.AcademicosFiltro')>
	<!--- Crear un arreglo para guardar la información del filtro --->
	<cfscript>
		AcademicosFiltro = StructNew();
		AcademicosFiltro.vAcadId = '';
		AcademicosFiltro.vAcadRfc = '';
		AcademicosFiltro.vAcadNom = '';
		AcademicosFiltro.vCn = '';
		AcademicosFiltro.vContrato = '';
		AcademicosFiltro.vAcadDep = '';
		AcademicosFiltro.vAcadSexo = '';
		AcademicosFiltro.vActivo = 0;
		AcademicosFiltro.vPagina = '1';
		AcademicosFiltro.vRPP = '25';
		AcademicosFiltro.vOrden = 'acd_apepat';
		AcademicosFiltro.vOrdenDir = 'ASC';
	</cfscript>
	<cfset Session.AcademicosFiltro = '#AcademicosFiltro#'>
</cfif>

<!--- Obtener información del catálogo de categoría y nivel (CATÁLOGOS GENERALES MYSQL) --->
<cfquery name="ctCategoria" datasource="#vOrigenDatosCATALOGOS#">
	SELECT * FROM catalogo_cn 
    WHERE cn_status = 1 ORDER BY cn_clave
</cfquery>

<!--- Obtener información del catálogo de tipo de contrato (CATÁLOGOS GENERALES MYSQL) --->
<cfquery name="ctContrato" datasource="#vOrigenDatosCATALOGOS#">
	SELECT * FROM catalogo_contratos
	WHERE con_clave BETWEEN 1 AND 3 OR con_clave BETWEEN 5 AND 10
	ORDER BY con_clave
</cfquery>

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

			<!--- LLAMADO A CÓDIGO DE JAVA SCRIPT COMÚN O GLOBAL --->
            <script type="text/javascript" src="#vCarpetaRaizLogicaSistema#/comun/java_script/mascara_entrada.js"></script>

		</cfoutput>
        <!--- ******* JAVASCRIPT ******* --->
		<script type="text/javascript">
			// Mostrar la lista de académicos:
			function fListarAcademicos(vPagina, vOrden, vOrdenDir)
			{
				// Icono de espera:
				document.getElementById('academicos_dynamic').innerHTML = "<img src=\"<cfoutput>#vCarpetaIMG#</cfoutput>/wait.gif\" style=\"display:block; margin:auto;\">";
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Función de atención a las petición HTTP:
				xmlHttp.onreadystatechange = function(){
					if (xmlHttp.readyState == 4) {
						document.getElementById('academicos_dynamic').innerHTML = xmlHttp.responseText;
						document.getElementById('vRegRan_dynamic').innerHTML = document.getElementById('vRegRan').value;
						document.getElementById('vRegTot_dynamic').innerHTML = document.getElementById('vRegTot').value;
					}
				}
				// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones
				xmlHttp.open("POST", "lista_academicos.cfm", true);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "vAcadId=" + encodeURIComponent(document.getElementById('vAcadId').value);
				parametros += "&vAcadNom=" + encodeURIComponent(document.getElementById('vAcadNom').value);
				parametros += "&vAcadRfc="; // + encodeURIComponent(document.getElementById('vAcadRfc').value);
				parametros += "&vCn=" + encodeURIComponent(document.getElementById('vCn').value);
				parametros += "&vContrato=" + encodeURIComponent(document.getElementById('vContrato').value);
				if (document.getElementById('vAcadDep')) parametros += "&vAcadDep=" + encodeURIComponent(document.getElementById('vAcadDep').value);
				parametros += document.getElementById('vActivo').checked ? "&vActivo=1": "&vActivo=0";
				parametros += "&vAcdSexo=" + encodeURIComponent(document.getElementById('vAcdSexo').value);;                
				parametros += "&vPagina=" + encodeURIComponent(vPagina);
				parametros += "&vRPP=" + encodeURIComponent(document.getElementById('vRPP').value);
				parametros += "&vOrden=" + encodeURIComponent(vOrden);
				parametros += "&vOrdenDir=" + encodeURIComponent(vOrdenDir);
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);
			}

            
            // Abrir la ventana de captura de nuevas solicitudes:
			function NuevoAcademico()
			{
				window.location = 'academico_nuevo/nuevo_academico.cfm?vFt=0'
			}
			// Imprimir la lista de académicos:
			function fImprimirListado()
			{
				window.open("impresion/listado_academicos.cfm", "_blank", "modal=yes,location=no,menubar=no,titlebar=no,width=800,height=600,resizable=yes,scrollbars=yes,status=no");
			}
		</script>
        
		<!--- ******* JQUERY ******* --->
        <script language="JavaScript" type="text/JavaScript">
			// Ventana del diálogo (jQuery) para LIBERAR EL REGISTRO
			$(function() {
				$('#dialog:ui-dialog').dialog('destroy');
				$('#divNuevoAcademico').dialog({
					autoOpen: false,
					height: 600,
					width: 750,
					modal: true,
					maxHeight: 700,
					title:'ALTA NUEVO ACADÉMICO',
					open: function() {
						$(this).load('<cfoutput>#vCarpetaRaizWebSistema#</cfoutput>/academicos/academico_nuevo/nuevo_academico.cfm',{});
					}
				});
				$('#cmdNuevoAcad').click(function(){
					$('#divNuevoAcademico').dialog('open');
				});
			});				
		</script>        
	</head>
	<body onLoad="fListarAcademicos(<cfoutput>#Session.AcademicosFiltro.vPagina#</cfoutput>,'<cfoutput>#Session.AcademicosFiltro.vOrden#</cfoutput>','<cfoutput>#Session.AcademicosFiltro.vOrdenDir#</cfoutput>');">
		<!-- Cintillo con nombre del módulo y filtro -->
		<table class="Cintillo">
			<tr>
				<td><span class="Sans9GrNe">PERSONAL ACAD&Eacute;MICO</span><span class="Sans9Gr"> >> LISTADO</span></td>
			</tr>
		</table>
		<!-- Cuerpo de la lista de académicos -->
		<table width="97%" height="600" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<!-- Columna izquierda (comandos) -->
				<td width="180px" valign="top" class="bordesmenu">
                	<div style="width:180px;"></div>
					<!-- Menú -->
					<table width="180px" border="0" style="position:fixed;">
						<!-- Menú del submódulo -->
						<tr><td><div class="linea_menu"></div></td></tr>
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">Men&uacute;:</div></td>
						</tr>
						<cfif #Session.sTipoSistema# IS 'stctic' AND #Session.sUsuarioNivel# LT 2>
                            <!-- Opción: Nuevo académico -->
                            <tr>
                                <td><input name="cmdNuevoAcad" id="cmdNuevoAcad" type="button" value="Nuevo acad&eacute;mico" class="botones"></td>
                            </tr>
						</cfif>
						<!-- Opción: Imprimir la lista -->
						<tr>
							<td><input type="button" value="Imprimir listado" class="botones" onClick="fImprimirListado();"></td>
						</tr>
						<!---
						<!-- Navegación -->
						<tr><td valign="top"><br><div class="linea_menu"></div></td></tr>
						<tr>
							<td><span class="Sans10NeNe">Navegaci&oacute;n:</span></td>
						</tr>
						<!-- Menú principal -->
						<tr>
							<td>
								<input type="button" class="botones" value="Menú principal" onclick="top.location.replace('../../<cfoutput>#Session.sTipoSistema#</cfoutput>_index.cfm');">
							</td>
						</tr>
						--->
						<!-- Filtrar por -->
						<tr><td valign="top"><br><div class="linea_menu"></div></td></tr>
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">Filtrar por:</div></td>
						</tr>
						<!-- Dependencia -->
						<cfif #Session.sTipoSistema# IS 'stctic'>
							<!--- Obtener datos del catálogo de dependencias (CATÁLOGOS GENERALES MYSQL)--->
                            <cfquery name="ctDependencia" datasource="#vOrigenDatosCATALOGOS#">
                                SELECT * FROM catalogo_dependencias
                                WHERE dep_clave LIKE '03%'
                                <cfif #Session.sUsuario# NEQ 'aram_st' AND #Session.sUsuarioNivel# LT 5>
									AND dep_tipo <> 'PRO'<!--- AND (dep_tipo = 'CEN' OR dep_tipo = 'INS' OR dep_tipo = 'UPE') --->
                                    AND dep_status = 1
								<cfelseif #Session.sUsuarioNivel# EQ 20> 
	                                AND (dep_clave = '030101' OR dep_tipo = 'UPE')
                                    AND dep_status = 1                                
                                </cfif>
                                ORDER BY dep_tipo, dep_siglas
                            </cfquery>
							<tr>
								<td valign="top">
								  <span class="Sans9GrNe">Entidad:<br></span>
									<select name="vAcadDep" id="vAcadDep" class="datos" style="width:95%;" onChange="fListarAcademicos(1,'<cfoutput>#Session.AcademicosFiltro.vOrden#</cfoutput>','<cfoutput>#Session.AcademicosFiltro.vOrdenDir#</cfoutput>');">
										<option value="">Todas</option>
										<cfoutput query="ctDependencia">
										<option value="#dep_clave#" <cfif #dep_clave# EQ #Session.AcademicosFiltro.vAcadDep#>selected</cfif>>#dep_siglas#</option>
										</cfoutput>
									</select>
								</td>
							</tr>
<!---
							<tr>
								<td valign="top">
                                    <span class="Sans9GrNe">Ubicación:<br></span>
                                    <div></div>
								</td>
							</tr>
--->
						</cfif>
						<!-- Categoría y Nivel -->
						<tr>
							<td valign="top">
								<span class="Sans9GrNe">Categor&iacute;a y nivel:<br></span>
								<select name="vCn" id="vCn" class="datos" style="width:95%;" onChange="fListarAcademicos(1,'<cfoutput>#Session.AcademicosFiltro.vOrden#</cfoutput>','<cfoutput>#Session.AcademicosFiltro.vOrdenDir#</cfoutput>');">
									<option value="">Todas</option>
                                    <option value="">-----------------------------------</option>
									<option value="INV">INVESTIGADORES</option>
									<option value="TEC">TECNICOS ACADÉMICOS</option>
                                    <option value="">-----------------------------------</option>
									<cfoutput query="ctCategoria">
										<option value="#cn_clave#" <cfif #cn_clave# EQ #Session.AcademicosFiltro.vCn#>selected</cfif>>#CnSinTiempo(cn_siglas)#</option>
									</cfoutput>
								</select>
							</td>
						</tr>
						<!-- Tipo de contrato -->
						<tr>
							<td valign="top">
								<span class="Sans9GrNe">Tipo de contrato:<br></span>
								<select name="vContrato" id="vContrato" class="datos" style="width:95%;" onChange="fListarAcademicos(1,'<cfoutput>#Session.AcademicosFiltro.vOrden#</cfoutput>','<cfoutput>#Session.AcademicosFiltro.vOrdenDir#</cfoutput>');">
									<option value="">Todos</option>
									<cfoutput query="ctContrato">
										<option value="#con_clave#" <cfif #con_clave# EQ #Session.AcademicosFiltro.vContrato#>selected</cfif>>#con_descrip#</option>
									</cfoutput>
								</select>
							</td>
						</tr>
						<!-- Sexo (Se agrego el 04/12/2023) -->
						<tr>
							<td valign="top">
								<span class="Sans9GrNe">Sexo:<br></span>
								<select name="vAcdSexo" id="vAcdSexo" class="datos" style="width:95%;" onChange="fListarAcademicos(1,'<cfoutput>#Session.AcademicosFiltro.vOrden#</cfoutput>','<cfoutput>#Session.AcademicosFiltro.vOrdenDir#</cfoutput>');">
									<option value="">Todos</option>
								    <option value="F" <cfif 'F' EQ #Session.AcademicosFiltro.vAcadSexo#>selected</cfif>>Mujeres</option>
								    <option value="M" <cfif 'M' EQ #Session.AcademicosFiltro.vAcadSexo#>selected</cfif>>Hombres</option>
<!---                                    
									<cfoutput query="ctContrato">
										<option value="#con_clave#" <cfif #con_clave# EQ #Session.AcademicosFiltro.vContrato#>selected</cfif>>#con_descrip#</option>
									</cfoutput>
--->
								</select>
							</td>
						</tr>
						<!-- Personal activo -->
						<tr>
							<td valign="middle" height="20px">
								<div align="left" style="width:130px; position:fixed;"><span class="Sans10ViNe">SÓLO PERSONAL ACTIVO</span></div>
								<div align="left" style="width:20px; position:fixed; left:133px;">
                                <input name="vActivo" id="vActivo" type="checkbox" class="datos" onClick="fListarAcademicos(1,'<cfoutput>#Session.AcademicosFiltro.vOrden#</cfoutput>','<cfoutput>#Session.AcademicosFiltro.vOrdenDir#</cfoutput>');" <cfif #Session.AcademicosFiltro.vActivo# EQ 1>checked</cfif>>
								</div>
							</td>
						</tr>
						<!--- Selección de número de registros por página --->
						<cfmodule template="#vCarpetaINCLUDE#/registros_pagina.cfm" filtro="AcademicosFiltro" funcion="fListarAcademicos" ordenable="yes">
						<!--- Contador de registros --->
						<cfmodule template="#vCarpetaINCLUDE#/contador_registros.cfm">
					</table>
				</td>
				<!-- Columna derecha (listado) -->
				<td width="844" valign="top">
					<!-- Filtro de la lista por académico -->
					<table style="width:90%; margin:5px 0px 10px 15px; border:none" cellspacing="0" cellpadding="0">
						<tr>
							<!-- Titulo del recuadro -->
							<td style="padding: 5px; background-color: #FFCC66"><span class="Sans9ViNe">B&uacute;squeda de acad&eacute;micos:</span></td>
							<!-- Botones de comando -->
							<td width="100" rowspan="2" bgcolor="#FFCC66">
								<table width="100" border="0" cellspacing="0" bgcolor="#FFFFFF">
									<tr bgcolor="#FFCC66">
										<td align="center">
											<input type="button" class="botones" value="BUSCAR" style="width: 80px;" onClick="fListarAcademicos(<cfoutput>#Session.AcademicosFiltro.vPagina#</cfoutput>,'<cfoutput>#Session.AcademicosFiltro.vOrden#</cfoutput>','<cfoutput>#Session.AcademicosFiltro.vOrdenDir#</cfoutput>');">
										</td>
									</tr>
									<tr bgcolor="#FFCC66">
										<td align="center">
											<input type="button" class="botones" value="LIMPIAR" style="width: 80px;" onClick="fBorrarParametros(); fListarAcademicos(<cfoutput>#Session.AcademicosFiltro.vPagina#</cfoutput>,'<cfoutput>#Session.AcademicosFiltro.vOrden#</cfoutput>','<cfoutput>#Session.AcademicosFiltro.vOrdenDir#</cfoutput>');">
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr bgcolor="#FFCC66">
							<!-- Ingreso de parámetros -->
							<td bgcolor="#FFCC66">
								<table style="margin:0px 5px 5px 5px;" border="0" cellspacing="0" callpadding="1">
									<!-- Nombre -->
									<tr>
										<td width="80%"><span class="Sans9Ne">Nombre</span></td>
<!---
                                        <td>
											<span class="Sans9Ne">RFC</span>
											<br>
										</td>
--->
										<td width="20%"><span class="Sans9Ne">ID académico</span></td>
									</tr>
									<tr>
										<!-- Nombre -->
										<td>
											<input name="vAcadNom" id="vAcadNom" type="text" class="datos" maxlength="100" style="width:450px" autocomplete="off" value="<cfoutput>#Session.AcademicosFiltro.vAcadNom#</cfoutput>" onFocus="fBorrarParametros();"><!---  onKeyUp="fTeclas();" fListaSeleccionAcademico('NAME') --->
                                            <!--- INCLUDE ADICIONAL PARA LA BÚSQUEDA DE ACADÉMICOS (FECHA INCORPORA 12/11/2019) --->
                                            <cfset vTipobusquedaValor = 'SelAcdCons'>
                                            <cfinclude template="#vCarpetaCOMUN#/lista_academicos_teclas_contol.cfm"></cfinclude>
                                        </td>
										<!-- RFC -->
<!--- ELIMINAR
                                        <td width="76" valign="top">
											<input name="vAcadRfc" id="vAcadRfc" type="text" size="14" maxlength="13" style="width:120px" class="datos" value="<cfoutput>#Session.AcademicosFiltro.vAcadRfc#</cfoutput>" onFocus="fBorrarParametros();" >
										</td>
--->
										<!-- Número de trabajador -->
										<td width="13" align="right" valign="top">
											<input name="vAcadId" id="vAcadId" type="text" size="5" maxlength="5" style="width:120px" class="datos" value="<cfoutput>#Session.AcademicosFiltro.vAcadId#</cfoutput>" onFocus="fBorrarParametros();"  onkeypress="return MascaraEntrada(event, '99999');"><!---onkeyup="fListaSeleccionAcademico('CLAVE');"--->
											<input name="vSelAcad" id="vSelAcad" type="hidden" size="5" maxlength="5" style="width:120px" class="datos" value="">
										</td>
									</tr>
									<tr>
										<td colspan="3">
											<div id="lstAcad_dynamic" style="position:absolute;display:block;">
												<!-- AJAX: Lista desplegable de académicos -->
											</div>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
                    <!-- Lista de académicos -->
					<div id="academicos_dynamic" width="100%"><!-- AJAX: Lista de académicos --></div>
                    <!-- Div para ejecutar JQuery para agregar nuevo académico -->
                    <div id="divNuevoAcademico" style="text-align: left;display: none;"><!-- DIV para dar de alta nuevo académico --></div>
				</td>
			</tr>
		</table>
	</body>
</html>

<!--- JAVA SCRIPT COMÚN PARA REALIZAR BÚSQUEDAD DE ACADÉMICOS (FECHA INCORPORA 12/11/2019) --->
<cfoutput>
    <script type="text/javascript" src="#vCarpetaRaizLogicaSistema#/comun/java_script/ajax_lista_academicos_teclas.js"></script>
</cfoutput>