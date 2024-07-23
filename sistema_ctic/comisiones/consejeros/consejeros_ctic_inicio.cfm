<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO DURAN --->
<!--- FECHA CREA: 05/03/2010 --->
<!--- FECHA ULTIMA MOD.: 31/05/2016 --->

<!--- Registrar el módulo actual --->
<cfset Session.sModulo = '#CGI.SCRIPT_NAME#'>

<!--- Crear un arreglo para guardar la información del filtro --->
<cfif NOT IsDefined('Session.ConsejerosFiltro')>
	<!--- Crear un arreglo para guardar la información del filtro --->
	<cfscript>
		ConsejerosFiltro = StructNew();
		ConsejerosFiltro.vDep = '';
		ConsejerosFiltro.vAdmClave = '';
		ConsejerosFiltro.vActivos = 'checked';
		ConsejerosFiltro.vPagina = '1';
		ConsejerosFiltro.vRPP = '25';
		ConsejerosFiltro.vOrden = 'acd_apepat'; // 'asu_parte ASC, asu_numero'
		ConsejerosFiltro.vOrdenDir = 'ASC';  //'ASC'
	</cfscript>
	<cfset Session.ConsejerosFiltro = '#ConsejerosFiltro#'>
</cfif>

<!--- Obtener la lista de cargos de los miembros del SIC (CATÁLOGOS LOCAL SAMAA) --->
<cfquery name="tbCatalogoCargos" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_nomadmo 
    WHERE adm_ctic_miembro = 1 <!---(adm_clave = '01' OR adm_clave = '12' OR adm_clave = '32' OR adm_clave = '82'  OR adm_clave = '84')--->
	ORDER BY adm_descrip
</cfquery>

<html>
	<head>
		<title>STCTIC - Consejeros ante el CTIC</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <cfoutput>
			<link href="#vCarpetaCSS#/formularios.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/general.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/fuentes.css" rel="stylesheet" type="text/css">
			<script type="text/javascript" src="#vHttpWebGlobal#/xmlHttpRequest.js"></script>
		</cfoutput>
		<script type="text/javascript">
			function NuevaCargoAcad()
			{
				window.location.replace('consejero_ctic.cfm?vTipoComando=NUEVO')
			}
			// Mostrar la lista de consejeros CTIC:
			function fListarConsejeros(vPagina, vOrden, vOrdenDir)
			{
				// Icono de espera:
				document.getElementById('consejeros_dynamic').innerHTML = "<img src=\"<cfoutput>#vCarpetaIMG#</cfoutput>/wait.gif\" style=\"display:block; margin:auto;\">";
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Función de atención a las petición HTTP:
				xmlHttp.onreadystatechange = function(){
					if (xmlHttp.readyState == 4) {
						document.getElementById('consejeros_dynamic').innerHTML = xmlHttp.responseText;
						document.getElementById('vRegRan_dynamic').innerHTML = document.getElementById('vRegRan').value;
						document.getElementById('vRegTot_dynamic').innerHTML = document.getElementById('vRegTot').value;
					}
				}
				// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones
				xmlHttp.open("POST", "lista_consejeros_ctic.cfm", true);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "vAdmClave=" + encodeURIComponent(document.getElementById('vCargoAdmClave').value);
				parametros += "&vDepClave=" + encodeURIComponent(document.getElementById('vDepClave').value);
				parametros += document.getElementById('vActivo').checked ? "&vActivo=checked": "&vActivo=";
				parametros += "&vPagina=" + encodeURIComponent(vPagina);
				parametros += "&vRPP=" + encodeURIComponent(document.getElementById('vRPP').value);
				parametros += "&vOrden=" + encodeURIComponent(<cfoutput>'#Session.ConsejerosFiltro.vOrden#'</cfoutput>);
				parametros += "&vOrdenDir=" + encodeURIComponent(<cfoutput>'#Session.ConsejerosFiltro.vOrdenDir#'</cfoutput>);

				// Enviar la petición HTTP:
				xmlHttp.send(parametros);
			}
		</script>
	</head>
	<body onLoad="fListarConsejeros(<cfoutput>#Session.ConsejerosFiltro.vPagina#</cfoutput>);">
		<!-- Cintillo con nombre del módulo y filtro-->
		<table class="Cintillo">
			<tr>
				<td>
					<span class="Sans9GrNe">CONSEJEROS ANTE EL CTIC</span>
				</td>
				<td align="right"><cfinclude template="#vCarpetaINCLUDE#/sesion_vigente.cfm"></td>
			</tr>
		</table>
		<!-- Contenido -->
		<table width="1024" border="0">
			<tr>
				<!-- Columna izquierda (comandos) -->
				<td width="180" valign="top">
					<!-- Controles -->
					<table width="95%" border="0">
						<!-- Menú de la lista de sesiones -->
						<tr><td><div class="linea_menu"><input id="NumPagina" name="NumPagina" value="1" type="hidden"></div></td></tr>
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">Men&uacute;:</div></td>
						</tr>
						<cfif #Session.sTipoSistema# IS 'stctic' AND #Session.sUsuarioNivel# LTE 1>
                            <!-- Opción: Nuevo cargo -->
                            <tr>
                                <td valign="top">
                                    <input name="button" type="button" value="Nuevo cargo" class="botones" onClick="NuevaCargoAcad();" <cfif #Session.sTipoSistema# IS 'sic'>disabled</cfif>>
                                </td>
                            </tr>
						</cfif>
                        <!-- Opción: Exportar directorio -->
						<tr>
							<td valign="top">
								<input name="cmdExportaDir" id="cmdExportaDir" type="button" value="Exportar directorio (Excel)" class="botones" onClick="window.open('ExportaConsejerosCtic.cfm')">
							</td>
						</tr>
						<tr><td valign="top"><br><div class="linea_menu"></div></td></tr>
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">Filtrar por:</div></td>
						</tr>
						<tr>
                        	<td><span class="Sans9Gr">Tipo</span></td>
                        </tr>
						<tr>
                        	<td>
								<select name="vCargoAdmClave" id="vCargoAdmClave" class="datos" style="width:95%;" onChange="fListarConsejeros(<cfoutput>#Session.ConsejerosFiltro.vPagina#</cfoutput>);">
									<option value="" selected>-- TODOS LOS CONSEJEROS --</option>
									<cfoutput query="tbCatalogoCargos">
										<option value="#adm_clave#" <cfif isDefined("Session.ConsejerosFiltro.vAdmClave") AND #adm_clave# EQ #Session.ConsejerosFiltro.vAdmClave#>selected</cfif>>#adm_descrip#</option>
									</cfoutput>
								</select>
							</td>
                        </tr>
						<!--- Selección de entidades para filtro --->
						<cfif #Session.sTipoSistema# IS 'stctic'>
							<cfmodule template="../../../includes/select_entidades.cfm" filtro="ConsejerosFiltro" funcion="fListarConsejeros" origendatos="#vOrigenDatosCATALOGOS#" ordenable="yes">
						</cfif>
						<!--- Selección de número de registros por página --->
						<cfmodule template="../../../includes/registros_pagina.cfm" filtro="ConsejerosFiltro" funcion="fListarConsejeros" ordenable="yes">
						<tr>
                        	<td>&nbsp;</td>
                        </tr>
						<tr>
                        	<td valign="middle">
								<div align="left" style="width:130px; position:absolute;"><span class="Sans10ViNe">SÓLO ACTIVO</span></div>
								<div align="left" style="width:20px; position:absolute; left:133px;">
                                <cfoutput>
	                                <input name="vActivo" id="vActivo" type="checkbox" class="datos" #Session.ConsejerosFiltro.vActivos# onClick="fListarConsejeros(#Session.ConsejerosFiltro.vPagina#);">
                                </cfoutput>
								</div>
                            </td>
                        </tr>
						<tr>
                        	<td>&nbsp;</td>
                        </tr>
						<!--- Contador de registros --->
						<cfmodule template="../../../includes/contador_registros.cfm">
					</table>
				</td>
				<td width="844" valign="top">
					<div id="consejeros_dynamic" width="100%" align="center">
						<!-- AJAX: Lista de consejeros CTIC -->
					</div>
				</td>
			</tr>
		</table>
	</body>
</html>
