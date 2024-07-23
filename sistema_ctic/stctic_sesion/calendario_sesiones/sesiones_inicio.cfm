<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 16/06/2015 --->
<!--- FECHA ULTIMA MOD.: 14/01/2016 --->
<!--- LISTA DE SESIONES DEL CTIC --->

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfparam name="PageNum_sesiones" default="1">
<cfparam name="vSesionesTipo" default="Anterior">

<cfset vMes = val(LsDateFormat(now(),"mm"))>
<cfset vAnio = val(LsDateFormat(now(),"yyyy"))>
<cfset vAnioPost = val(LsDateFormat(now(),"yyyy")) + 1>

<cfif NOT IsDefined('Session.sTipoSesionCel') OR #Session.sTipoSesionCel# EQ ''>
	<cfset Session.sTipoSesionCel = '1'>
</cfif>

<!--- Registrar la ruta del módulo actual --->
<cfset Session.sModulo = '#CGI.SCRIPT_NAME#'>

<!--- Crear un arreglo para guardar la información del filtro --->
<cfif NOT IsDefined('Session.CalendarioSesFiltro')>
	<!--- Crear un arreglo para guardar la información del filtro --->
	<cfscript>
		CalendarioSesFiltro = StructNew();
		CalendarioSesFiltro.TipoSesion = '1';
		CalendarioSesFiltro.Semestre1 = '';
		CalendarioSesFiltro.Semestre2 = '';
		CalendarioSesFiltro.vAnioConsulta = #LsDateFormat(now(),'YYYY')#;
		CalendarioSesFiltro.vPagina = '1';
		CalendarioSesFiltro.vRPP = '25';
	</cfscript>
	<cfset Session.CalendarioSesFiltro = '#CalendarioSesFiltro#'>

	<cfif #vMes# LT 7>
		<cfset Session.CalendarioSesFiltro.Semestre1 = 'checked'>
	<cfelse>
		<cfset Session.CalendarioSesFiltro.Semestre1 = ''>
	</cfif>
	<cfif #vMes# GT 6>
		<cfset Session.CalendarioSesFiltro.Semestre2 = 'checked'>
	<cfelse>
		<cfset Session.CalendarioSesFiltro.Semestre2 = ''>
	</cfif>
</cfif>

<cfquery name="tbCatalogoAnios" datasource="#vOrigenDatosSAMAA#">
	SELECT YEAR(ssn_fecha) as vAnios FROM sesiones
	GROUP BY YEAR(ssn_fecha)
	ORDER BY YEAR(ssn_fecha) DESC
</cfquery>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <title>SAMAA - Asuntos Acad&eacute;mico-Administrativos</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<cfoutput>
            <link href="#vCarpetaCSS#/formularios.css" rel="stylesheet" type="text/css">
            <link href="#vCarpetaCSS#/general.css" rel="stylesheet" type="text/css">
            <link href="#vCarpetaCSS#/fuentes.css" rel="stylesheet" type="text/css">
			<script type="text/javascript" src="#vHttpWebGlobal#/xmlHttpRequest.js"></script>
		</cfoutput>
		<script type="text/javascript">
			function fSesionFiltro()
			{
				// Icono de espera:
				document.getElementById('sesiones_dynamic').innerHTML = "<img src=\"<cfoutput>#vCarpetaIMG#</cfoutput>/wait.gif\" style=\"display:block; margin:auto;\">";
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Función de atención a las petición HTTP:
				xmlHttp.onreadystatechange = function(){
					if (xmlHttp.readyState == 4) {
						document.getElementById('sesiones_dynamic').innerHTML = xmlHttp.responseText;
					}
				}
				// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
				xmlHttp.open("POST", "sesiones_lista.cfm", true);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "vpAnio=" + encodeURIComponent(document.getElementById('vAnio').value);
				if (document.getElementById('vTipoSesionO').checked) parametros += "&vpSesionTipo=1";
				if (document.getElementById('vTipoSesionE').checked) parametros += "&vpSesionTipo=2";
				if (document.getElementById('vTipoSesionP'))
				{
					if (document.getElementById('vTipoSesionP').checked) parametros += "&vpSesionTipo=7";
				}
				
				if (document.getElementById('vSemestre1').checked) parametros += "&vpSemestre1=checked";
				if (document.getElementById('vSemestre2').checked) parametros += "&vpSemestre2=checked";
				//parametros += "&PageNum_tbConsejeros=" + encodeURIComponent(document.getElementById('NumPagina').value);
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);
			}

			function fListaSesionesAnio()
			{
				var xmlHttp = XmlHttpRequest();
				// Función de atención a las petición HTTP:
				xmlHttp.onreadystatechange = function(){
					if (xmlHttp.readyState == 4) {
						document.getElementById('anios_sesiones_dynamic').innerHTML = xmlHttp.responseText;
						fSesionFiltro();						
					}
				}
				// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
				xmlHttp.open("POST", "../../comun/seleccion_anio_sesiones.cfm", true);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				if (document.getElementById('vTipoSesionO').checked) parametros = "vSsnClave=1";
				if (document.getElementById('vTipoSesionE').checked) parametros = "vSsnClave=2";
				if (document.getElementById('vTipoSesionP'))
				{				
					if (document.getElementById('vTipoSesionP').checked) parametros = "vSsnClave=7";
				}
				parametros += "&vSesionAnioConsulta=" + <cfoutput>#Session.CalendarioSesFiltro.vAnioConsulta#</cfoutput>;

				xmlHttp.send(parametros);
			}

			function fDespliegaMenus()
			{
				if (document.getElementById('vTipoSesionO').checked)
				{
					document.getElementById('trSemestre').style.display = '';
					document.getElementById('trOrdinariaImp').style.display = '';
					if (document.getElementById('trOrdinaria')) document.getElementById('trOrdinaria').style.display = '';
					if (document.getElementById('trExtraOrdinaria'))document.getElementById('trExtraOrdinaria').style.display = 'none';
					if (document.getElementById('trPosdoc'))document.getElementById('trPosdoc').style.display = 'none';
				}
				if (document.getElementById('vTipoSesionE').checked) 
				{
					document.getElementById('trSemestre').style.display = 'none';
					document.getElementById('trOrdinariaImp').style.display = 'none';
					if (document.getElementById('trOrdinaria')) document.getElementById('trOrdinaria').style.display = 'none';
					if (document.getElementById('trExtraOrdinaria'))document.getElementById('trExtraOrdinaria').style.display = '';
					if (document.getElementById('trPosdoc'))document.getElementById('trPosdoc').style.display = 'none';
				}
				if (document.getElementById('trPosdoc')) 
				{
					if (document.getElementById('vTipoSesionP').checked) 
					{
						document.getElementById('trSemestre').style.display = 'none';				
						document.getElementById('trOrdinariaImp').style.display = 'none';
						if (document.getElementById('trOrdinaria')) document.getElementById('trOrdinaria').style.display = 'none';
						if (document.getElementById('trExtraOrdinaria'))document.getElementById('trExtraOrdinaria').style.display = 'none';
						if (document.getElementById('trPosdoc'))document.getElementById('trPosdoc').style.display = '';
					}
				}
				fListaSesionesAnio();
			}
			// Mostrar la lista de asuntos en formato PDF:
			function fImprimeCalendario()
			{
				if (document.getElementById('vSemestre1').checked && document.getElementById('vSemestre2').checked)
				{
					alert('Para imprimir el calendario de sesiones debe seleccionar sólo un SEMESTRE');
				}
				else
				{
					window.open("sesiones_lista_imprime.cfm", "_blank", "modal=yes,location=no,menubar=no,titlebar=no,width=800,height=600,resizable=yes,scrollbars=yes,status=no");
				}
			}
		</script>
    </head>

    <body onload="fDespliegaMenus();">
		<table class="Cintillo">
			<tr>
				<td><span class="Sans9GrNe">ADMINISTRACI&Oacute;N DE SESIONES &gt;&gt; </span><span class="Sans9Gr">CALENDARIO DE SESIONES</span>
					<cfif #vSesionesTipo# IS "Posterior"><cfoutput>#vAnioPost#</cfoutput></cfif></td>
				<td align="right"><cfinclude template="#vCarpetaINCLUDE#/sesion_vigente.cfm"></td>
			</tr>
		</table>
		<table width="100%" border="0">
			<tr>
				<!-- Columna izquierda (comandos) --> 
				<td width="18%" valign="top" class="bordesmenu">
					<!-- Comandos -->
					<table width="95%" border="0">
						<!-- Menú de la lista de sesiones -->
						<tr>
                        	<td><div class="linea_menu"></div></td></tr>
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">Men&uacute;:</div></td>
						</tr>
                        <!-- Opción: Imprimir -->
                        <tr id="trOrdinariaImp">
                            <td valign="top"><input onClick="fImprimeCalendario();" name="Submit" type="button" class="botones" value="Imprimir calendario" <cfif #Session.sTipoSesionCel# IS '2'>disabled</cfif>></td>
                        </tr>
						<!-- Filtrar por -->
						<tr><td valign="top"><br><div class="linea_menu"></div></td></tr>
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">Ver sesiones:<input type="hidden" name="" id="" value="1"></div></td>
						</tr>
						<tr id="trTipoSesion">
							<td valign="top">
								<input type="radio" name="vTipoSesion" id="vTipoSesionO" value="1" onClick="fDespliegaMenus(this);" <cfif #Session.CalendarioSesFiltro.TipoSesion# EQ "1">checked="checked"</cfif>><span class="Sans10Ne">Ordinarias</span><br>
								<input type="radio" name="vTipoSesion" id="vTipoSesionE" value="2" onClick="fDespliegaMenus(this);" <cfif #Session.CalendarioSesFiltro.TipoSesion# EQ "2">checked="checked"</cfif>><span class="Sans10Ne">Extraordinarias</span><br>
								<cfif #Session.sTipoSistema# IS 'stctic'>
									<input type="radio" name="vTipoSesion" id="vTipoSesionP" value="7" onClick="fDespliegaMenus(this);" <cfif #Session.CalendarioSesFiltro.TipoSesion# EQ "7">checked="checked"</cfif>><span class="Sans10Ne">Comisión Posdoc</span>
								</cfif>
							</td>
						</tr>
						<tr><td valign="top"><br><div class="linea_menu"></div></td></tr>
						<tr id="trSemestre">
							<td valign="top">
								<cfoutput>
                                    <input type="checkbox" name="vSemestre" id="vSemestre1" value="1" onClick="fSesionFiltro();" #Session.CalendarioSesFiltro.Semestre1#><span class="Sans10Ne">1er semestre</span><br>
                                    <input type="checkbox" name="vSemestre" id="vSemestre2" value="2" onClick="fSesionFiltro();" #Session.CalendarioSesFiltro.Semestre2#><span class="Sans10Ne">2º semestre</span>
								</cfoutput>
							</td>
						</tr>
						<!-- Contador de registros -->
						<tr><td valign="top"><br><div class="linea_menu"></div></td></tr>
						<tr>
							<td>
                                <div style="padding-top:10px;" id="anios_sesiones_dynamic" width="98%">
                                    <!-- AJAX: Lista de consejeros CTIC -->
                                </div>
<!---
                                <br />
								<cfform name="frmAnio">
									<span class="Sans10Ne">Año: </span>
									<cfselect name="vAnio" id="vAnio" query="tbCatalogoAnios" queryPosition="below" selected="#Session.CalendarioSesFiltro.vAnioConsulta#" display="vAnios" label="vAnios" onChange="fSesionFiltro();" class="datos">
									</cfselect>
								</cfform>
--->								
							</td>
						</tr>
						<!-- Contador de registros -->
						<tr><td valign="top"><br><div class="linea_menu"></div></td></tr>
					</table>
		    	</td>
				<!-- Columna derecha (listado) -->
				<td width="82%" valign="top">
					<div id="sesiones_dynamic" width="98%" align="center">
						<!-- AJAX: Lista de consejeros CTIC -->
					</div>
				</td>
			</tr>
		</table>
    </body>
</html>
