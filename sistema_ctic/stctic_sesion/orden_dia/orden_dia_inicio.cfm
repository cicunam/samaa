<!--- CREADO: ARAM PICHARDO DURÁN--->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 18/05/2015 --->
<!--- FECHA ÚLTIMA MOD: 29/08/2018 --->
<!--- LISTA DE SESIONES DEL CTIC (ORDEN DEL DÍA) --->

<cfset vNuevoRegistro = 0>
<cfset vAnio = 0>

<cfif NOT IsDefined('Session.sTipoSesionCel') OR #Session.sTipoSesionCel# EQ '' OR #Session.sTipoSesionCel# EQ 'P'>
	<cfset Session.sTipoSesionCel = '1'>
</cfif>

<cfif NOT IsDefined('Session.OrdenDiaFiltro')>
	<!--- Crear un arreglo para guardar la información del filtro --->
	<cfscript>
		OrdenDiaFiltro = StructNew();
		OrdenDiaFiltro.vOrden = 'ssn_id';
		OrdenDiaFiltro.vOrdenDir = 'ASC';
		OrdenDiaFiltro.vPagina = '1';
		OrdenDiaFiltro.vRPP = '25';
	</cfscript>
	<cfset Session.OrdenDiaFiltro = '#OrdenDiaFiltro#'>
</cfif>

<cfquery name="tbCatalogoAnios" datasource="#vOrigenDatosSAMAA#">
	SELECT YEAR(ssn_fecha) as vAnios FROM sesiones
	WHERE ssn_clave = 1 AND ssn_id <= #Session.sSesion#
	GROUP BY YEAR(ssn_fecha)
	ORDER BY YEAR(ssn_fecha) DESC
</cfquery>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
		<title>Documento sin t&iacute;tulo</title>
		<!--- CSS --->
        <cfoutput>
            <link href="#vCarpetaCSS#/formularios.css" rel="stylesheet" type="text/css">
            <link href="#vCarpetaCSS#/general.css" rel="stylesheet" type="text/css">
            <link href="#vCarpetaCSS#/fuentes.css" rel="stylesheet" type="text/css">
			<script type="text/javascript" src="#vHttpWebGlobal#/xmlHttpRequest.js"></script>
		</cfoutput>
		<!--- JAVA SCRIPT --->
		<script type="text/javascript">
			function fListarOrdenDia(vPagina)
			{
				//window.location = 'sesiones_lista.cfm?vTipoSesionCel=' + vValorTipoSes
				//if (document.getElementById('vTipoSesionO').checked) document.getElementById('trSemestre').style.display = '';
				//if (document.getElementById('vTipoSesionE').checked) document.getElementById('trSemestre').style.display = 'none';
				// Icono de espera:
				document.getElementById('ordendia_dynamic').innerHTML = "<img src=\"<cfoutput>#vCarpetaIMG#</cfoutput>/wait.gif\" style=\"display:block; margin:auto;\">";
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Función de atención a las petición HTTP:
				xmlHttp.onreadystatechange = function(){
					if (xmlHttp.readyState == 4) {
						document.getElementById('ordendia_dynamic').innerHTML = xmlHttp.responseText;
						document.getElementById('vRegRan_dynamic').innerHTML = document.getElementById('vRegRan').value;
						document.getElementById('vRegTot_dynamic').innerHTML = document.getElementById('vRegTot').value;
					}
				}
				// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
				xmlHttp.open("POST", "orden_dia_lista.cfm", true);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "vpAnio=" + encodeURIComponent(document.getElementById('vAnio').value);
				parametros += "&vpSsnId=" + encodeURIComponent(document.getElementById('ssn_id').value);
				parametros += "&vRPP=" + encodeURIComponent(document.getElementById('vRPP').value);
				if (document.getElementById('vTipoSesionO').checked) parametros += "&vpSesionTipo=1";
				if (document.getElementById('vTipoSesionE').checked) parametros += "&vpSesionTipo=2";
				parametros += "&vPagina=" + encodeURIComponent(vPagina);
				//parametros += "&PageNum_tbConsejeros=" + encodeURIComponent(document.getElementById('NumPagina').value);
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);
			}
			function fVerificaSsn()
			{
				if (document.getElementById('ssn_id').value > 1000)
					fListarOrdenDia(1);
			}
		</script>
	</head>
	<body  onLoad="fListarOrdenDia(<cfoutput>#Session.OrdenDiaFiltro.vPagina#</cfoutput>);">
		<!-- Cintillo con nombre del módulo y filtro--> 
		<table class="Cintillo">
			<tr>
				<td><span class="Sans9GrNe">ADMINISTRACI&Oacute;N DE SESIONES &gt;&gt; </span><span class="Sans9Gr">ORDEN DEL D&Iacute;A</span></td>
				<td align="right"><cfinclude template="#vCarpetaINCLUDE#/sesion_vigente.cfm"></td>
			</tr>
		</table>
		<!-- Contenido -->
		<table width="100%" border="0">
			<tr>
				<!-- Columna izquierda (comandos) --> 
				<td width="18%" valign="top" class="bordesmenu">
					<!-- Controles -->
					<table width="95%" border="0">
						<!-- Menú de la lista de sesiones -->
						<tr><td><div class="linea_menu"></div></td></tr>
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">Men&uacute;:</div></td>
						</tr>
<!---
						<!-- Opción: Nueva orden del día -->
						<tr>
							<td valign="top">
								<input name="cmdNueva" type="button" class="botones" value="Nueva orden del d&iacute;a" onclick="window.location.replace('orden_dia.cfm?vIdSsn=<cfoutput>#vNuevoRegistro#</cfoutput>&vTipoComando=NUEVO')" <cfif #Session.sTipoSistema# IS 'sic' OR #vNuevoRegistro# EQ 0>disabled</cfif>>
							</td>
						</tr>
--->						
						<!-- Filtrar por -->
						<tr><td valign="top"><br><div class="linea_menu"></div></td></tr>
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">Ver sesiones:</div></td>
						</tr>
						<tr>
							<td valign="top">
								<cfoutput>
									<input type="radio" name="vTipoSesion" id="vTipoSesionO" value="1" onClick="fListarOrdenDia(#Session.OrdenDiaFiltro.vPagina#);" <cfif #Session.sTipoSesionCel# EQ "1">checked="checked"</cfif>> <span class="Sans10Ne">Ordinarias</span><br>
									<input type="radio" name="vTipoSesion" id="vTipoSesionE" value="2" onClick="fListarOrdenDia(#Session.OrdenDiaFiltro.vPagina#);" <cfif #Session.sTipoSesionCel# EQ "2">checked="checked"</cfif>> <span class="Sans10Ne">Extraordinarias</span><br>
								</cfoutput>
							</td>
						</tr>
						<!-- Contador de registros -->
						<tr><td valign="top"><br><div class="linea_menu"></div></td></tr>
						<tr>
							<td width="5" valign="top"><span class="Sans10NeNe">Filtrar por:</span></td>
						</tr>
						<tr>
						  <td valign="top">
								<cfform name="frmAnio">
									<span class="Sans10Ne">Año: </span>
									<cfselect name="vAnio" id="vAnio" query="tbCatalogoAnios" queryPosition="below" selected="" display="vAnios" label="vAnios" onChange="fListarOrdenDia(#Session.OrdenDiaFiltro.vPagina#);" class="datos">
                                    	<option value="0">TODOS</option>
									</cfselect>
								</cfform>
                          </td>
						</tr>
						<tr>
							<td width="5" valign="top">&nbsp;</td>
						</tr>
						<tr>
							<td valign="top">
								<span class="Sans10Ne">Sesión: </span>
								<input type="text" name="ssn_id" id="ssn_id" max="4" value="" size="4" maxlength="4"  class="datos" onkeypress="fVerificaSsn();"/>
							</td>
						</tr>
						<!--- Selección de número de registros por página --->
						<cfmodule template="#vCarpetaINCLUDE#/registros_pagina.cfm" filtro="OrdenDiaFiltro" funcion="fListarOrdenDia" ordenable="no">
						<!--- Contador de registros --->
						<cfmodule template="#vCarpetaINCLUDE#/contador_registros.cfm">
						<tr><td valign="top"><br><div class="linea_menu"></div></td></tr>
					</table>
					<!--- Include para abrir archivo PDF enviando parámetros por POST --->                    
                    <cfinclude template="#vCarpetaRaizLogicaSistema#/comun/consulta_pdf_comun.cfm">
				</td>
				<!-- Columna derecha -->
				<td width="82%" valign="top">
					<div align="center"><span class="Sans12NeNe">ORDEN DEL DÍA</span></div>
                        
					<div id="ordendia_dynamic" width="100%" align="center">
						<!-- Liste de registros -->
                    </div>
				</td>
			</tr>
		</table>
	</body>
</html>
