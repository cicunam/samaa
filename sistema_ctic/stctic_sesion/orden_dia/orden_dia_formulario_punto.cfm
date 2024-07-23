<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 21/04/2010 --->
<!--- FECHA ULTIMA MOD.: 14/06/2016 --->
<!--- ORDEN DEL DÍA --->

<!--- Obtener datos de la sesión --->
<cfparam name="vIdSsn" default=0>
<cfparam name="vTipoComando" default="N">
<cfparam name="vPunto" default=0>

<cfset vArchivoPdf = ''>
<cfset vArchivoPdf2 = ''>

<!--- Obtener la sesion a trabajar --->
<cfquery name="tbSesion" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM sesiones 
    WHERE ssn_id = #vIdSsn#
</cfquery>

<!--- Obtener la lista de punto resultante --->
<cfquery name="tbSesionOrden" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM sesiones_orden
    WHERE ssn_id = #vIdSsn#
    <cfif vTipoComando EQ 'E'>
		AND punto_num = #vPunto#
    </cfif>
	ORDER BY punto_num DESC
</cfquery>

<cfif #vTipoComando# EQ 'N'>
	<cfif #tbSesionOrden.recordcount# EQ 0>
		<cfset vPuntoNum = '1'>
	<cfelse>
		<cfset vPuntoNum = #tbSesionOrden.punto_num# + 1>
	</cfif>
	<cfset vPuntoClave = ''>
	<cfset vPuntoTexto = ''>
	<cfset vAcdId = ''>
	<cfset vPuntoPdf = ''>
	<cfset vPuntoPdf2 = ''>
	<cfset vPuntoNota = ''>
	<cfset vPuntoSatus = ''>
	<cfset vAcdNombre = ''>
<cfelseif #vTipoComando# EQ 'E'>
	<cfset vPuntoNum = #tbSesionOrden.punto_num#>
	<cfset vPuntoClave = #Rtrim(tbSesionOrden.punto_clave)#>
	<cfset vPuntoTexto = #tbSesionOrden.punto_texto#>
	<cfif #tbSesionOrden.acd_id# EQ ''>
		<cfset vAcdId = 0>
    <cfelse>
		<cfset vAcdId = #tbSesionOrden.acd_id#>
    </cfif>
	<cfset vPuntoPdf = #tbSesionOrden.punto_pdf#>
	<cfset vPuntoPdf2 = #tbSesionOrden.punto_pdf_2#>
	<cfset vPuntoNota = #tbSesionOrden.punto_nota#>
	<cfset vPuntoSatus = #tbSesionOrden.punto_status#>
	<cfset vAcdNombre = ''>
</cfif>

<cfif #vTipoComando# EQ 'E' AND (#vAcdId# NEQ '' OR #vAcdId# NEQ 0)>
	<!--- Obtener la lista de punto resultante --->
	<cfquery name="tbAcademicos" datasource="#vOrigenDatosSAMAA#">
		SELECT * FROM academicos 
        WHERE acd_id = #vAcdId#
	</cfquery>
	<cfif #tbAcademicos.RecordCount# GT 0>
		<cfif #tbAcademicos.acd_apepat# NEQ ''>
            <cfset vAcdNombre = #tbAcademicos.acd_apepat#>
        </cfif>
        <cfif #tbAcademicos.acd_apemat# NEQ ''>
            <cfif #tbAcademicos.acd_apepat# EQ ''>
                <cfset vAcdNombre = #tbAcademicos.acd_apemat#>
            <cfelse>
                <cfset vAcdNombre = #vAcdNombre# & ' ' & #tbAcademicos.acd_apemat#>
            </cfif>
        </cfif>
        <cfif #tbAcademicos.acd_nombres# NEQ ''>
            <cfif #tbAcademicos.acd_apepat# EQ '' AND #tbAcademicos.acd_apemat# EQ ''>
                <cfset vAcdNombre = #tbAcademicos.acd_nombres#>
            <cfelse>
                <cfset vAcdNombre = #vAcdNombre# & ' ' & #tbAcademicos.acd_nombres#>
            </cfif>
        </cfif>
	</cfif>
</cfif>

<cfif vTipoComando EQ 'E'>
	<cfif #tbSesionOrden.punto_pdf# NEQ ''>
        <cfif #MID(tbSesionOrden.punto_clave,1,4)# EQ 'ACTA' OR #MID(tbSesionOrden.punto_clave,1,9)# EQ 'RECOMCAAA'>
            <cfset vArchivoPdf = #vCarpetaSesionHistoria# & #tbSesionOrden.punto_pdf#>
            <cfset vWebPdf = #vWebSesionHistoria# & #tbSesionOrden.punto_pdf#>
        <cfelseif #RTrim(tbSesionOrden.punto_clave)# EQ 'PNCA' OR #RTrim(tbSesionOrden.punto_clave)# EQ 'PNIE'>
            <cfset vArchivoPdf = #vCarpetaSesionHistoria# & #tbSesionOrden.punto_pdf#>
            <cfset vWebPdf = #vWebSesionHistoria# & #tbSesionOrden.punto_pdf#>
        <cfelse>			
            <!--- AGREGAR SI OTRO TIPO DE ASUNTOS --->
        </cfif>
    </cfif>
    
    <cfif #tbSesionOrden.punto_pdf_2# NEQ ''>
        <cfif #MID(tbSesionOrden.punto_clave,1,4)# EQ 'ACTA' OR #MID(tbSesionOrden.punto_clave,1,9)# EQ 'RECOMCAAA'>
            <cfset vArchivoPdf2 = #vCarpetaSesionHistoria# & #tbSesionOrden.punto_pdf_2#>
            <cfset vWebPdf2 = #vWebSesionHistoria# & #tbSesionOrden.punto_pdf_2#>
        <cfelseif #RTrim(tbSesionOrden.punto_clave)# EQ 'PNCA' OR #RTrim(tbSesionOrden.punto_clave)# EQ 'PNIE'>
            <cfset vArchivoPdf2 = #vCarpetaAcademicos# & #tbSesionOrden.punto_pdf_2#>
            <cfset vWebPdf2 = #vWebAcademicos# & #tbSesionOrden.punto_pdf_2#>
        <cfelse>		
            <!--- AGREGAR SI OTRO TIPO DE ASUNTOS --->
        </cfif>
    </cfif>
</cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
		<title>Documento sin t&iacute;tulo</title>
		<cfoutput>
			<link href="#vCarpetaCSS#/formularios.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/general.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/fuentes.css" rel="stylesheet" type="text/css">
		</cfoutput>

		<script language="JavaScript" type="text/JavaScript">
			// Función para direccionar la acción de los botones:
			function vHabDesControles()
			{
				//alert(document.getElementById('punto_clave').value);
				if (document.getElementById('punto_clave').value == 'PNCA' || document.getElementById('punto_clave').value == 'PNIE')
				{
//					alert('PROPUESTAS')
					document.getElementById('trSelAcad').style.display = ''
				}
				else if (document.getElementById('punto_clave').value.substring(0,4) == 'ACTA')
				{
//					alert('ACTA')
					if (document.getElementById('vAccion').value == 'N')
					{
						document.getElementById('punto_texto').value = document.getElementById('punto_clave').options[document.getElementById('punto_clave').selectedIndex].text;
					}
					document.getElementById('trSelAcad').style.display = 'none'
					if (document.getElementById('punto_clave').value == 'ACTA')
					{
						document.getElementById('trArchivo2').style.display = 'none';
					}
					else
					{
						document.getElementById('trArchivo2').style.display = '';
					}
				}
				else if (document.getElementById('punto_clave').value.substring(0,9) == 'RECOMCAAA')
				{
//					alert('RECOMCAAA')
					if (document.getElementById('vAccion').value == 'N')
					{
						document.getElementById('punto_texto').value = document.getElementById('punto_clave').options[document.getElementById('punto_clave').selectedIndex].text;
					}
					document.getElementById('trSelAcad').style.display = 'none';				
					if (document.getElementById('punto_clave').value == 'RECOMCAAA')
					{
						document.getElementById('trArchivo2').style.display = 'none';
					}
					else
					{
						document.getElementById('trArchivo2').style.display = '';
					}
				}
				else
				{
//					alert('OTRAS')
					document.getElementById('trSelAcad').style.display = 'none';
					if (document.getElementById('punto_clave').value.substring(0,4) == 'OTRO')
					{
						document.getElementById('trArchivo2').style.display = '';
					}
					else
					{
						document.getElementById('trArchivo2').style.display = 'none';
					}
					
				}
			}

			// FUNCIÓN PARA VALIDAR LOS CAMPOS DEL FORMULARIO	
			function fValidaCampos()
			{
				var vOk;
				var vMensaje = '';
				fLimpiaValida();
				vMensaje += fValidaCampoLleno('punto_clave','TIPO DE PUNTO');
				if (document.getElementById('punto_clave').value == 'PNCA' || document.getElementById('punto_clave').value == 'PNIE')
				{
					vMensaje += fValidaCampoLleno('vNomAcad','ACADÉMICO');					
				}
				vMensaje += fValidaCampoLleno('punto_num','NÚMERO DE PUNTO');
				vMensaje += fValidaCampoLleno('punto_texto','DESCRIPCIÓN DEL PUNTO');
				if (vMensaje.length > 0) 
				{
					alert(vMensaje);
				}
				else
				{
					document.getElementById('punto_num').disabled = '';
					document.getElementById('frmPuntoNc').submit()
//					return true;
				}
			}		

			// Obtener la lista de académicos:
			function fListaSeleccionAcademico(vTipoBusq)
			{
				// Solo obtener la lista de académicos si hay más de tres letras tecleadas:
				if (document.getElementById('vNomAcad').value.length <= 3) return;
			// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Función de atención a las petición HTTP:
				xmlHttp.onreadystatechange = function(){
					if (xmlHttp.readyState == 4) {
						document.getElementById('lstAcad_dynamic').innerHTML = xmlHttp.responseText;
					}
				}
				// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
				xmlHttp.open("POST", "../../comun/seleccion_academico.cfm", true);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "vTexto=" + encodeURIComponent(document.getElementById('vNomAcad').value);
				parametros += "&vTipoBusq=" + vTipoBusq;
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);
			}
			<!-- **** -->
			function fSeleccionAcademico()
			{
				// Registrar la clave y el nombre del académico seleccionado:
				document.getElementById('vSelAcad').value = document.getElementById('lstAcad').value;
				document.getElementById('vNomAcad').value = document.getElementById('lstAcad').options[document.getElementById('lstAcad').selectedIndex].text;
				document.getElementById('lstAcad_dynamic').innerHTML = '';
			}

			<!-- **** -->
			function fBorrarParametros()
			{
				// document.getElementById('vIdAcad').value = '';
				document.getElementById('vNomAcad').value = '';
				document.getElementById('vSelAcad').value = '';
				// document.getElementById('vRfcAcad').value = '';
			}	

			<!-- **** -->
			function fLimpiarLista()
			{
				fBorrarParametros();
				fListarMovimientos(1);
			}
		</script>
	</head>
	<body onload="vHabDesControles();">
        <!-- Formulario de captura de un punto de la orden del d&iacute;a -->
        <form id="frmPuntoNc" method="post" enctype="multipart/form-data" action="orden_dia_formulario_punto_guarda.cfm">
            <!-- Campos ocultos -->
			<cfoutput>
                <input name="vIdSsn" id="vIdSsn" type="hidden" value="#vIdSsn#" />
                <input name="vAccion" id="vAccion" type="hidden" value="#vTipoComando#">
                <input name="vPunto" id="vPunto" type="hidden" value="#vPuntoNum#">
			</cfoutput>
            <!-- Controles -->
            <table width="80%" align="center" bgcolor="#E4E4E4" class="cuadros" border="0">
                <tr bgcolor="#CCCCCC">
                    <td colspan="3" valign="top"><div align="center"><span class="Sans10NeNe">
                        <cfif #vTipoComando# EQ 'NUEVO'>NUEVO </cfif>
                        <cfif #vTipoComando# EQ 'EDITA'>EDITAR </cfif>
                        PUNTO EN LA ORDEN DEL D&Iacute;A</span></div>
                    </td>
                </tr>
                <tr>
                    <td width="99" valign="top" class="Sans10NeNe">PUNTO</td>
                    <td colspan="2" valign="top" class="Sans10NeNe">
                    <input name="punto_num_temp" id="punto_num_temp" type="text" size="2" maxlength="2" class="datos" value="<cfoutput>#vPuntoNum#</cfoutput>" disabled="disabled" />
                    <input name="punto_num" id="punto_num" type="hidden" size="2" maxlength="2" class="datos" value="<cfoutput>#vPuntoNum#</cfoutput>"></td>
                </tr>
                <cfif #Session.sTipoSesionCel# EQ "1">
                    <tr>
                        <td valign="top" class="Sans10NeNe">TIPO</span></td>
                        <td colspan="2" valign="top" class="Sans10NeNe">
                            <select name="punto_clave" id="punto_clave" class="datos100" onchange="vHabDesControles();">
                                <option value="">SELECCIONE</option>
                                    <cfif #vPuntoNum# EQ 1>
                                        <option value="ACTA" <cfif #vPuntoClave# EQ 'ACTA'>selected</cfif>>Aprobaci&oacute;n del acta <cfoutput>#vIdSsn-1#</cfoutput></option>
                                        <option value="ACTAS" <cfif #vPuntoClave# EQ 'ACTAS'>selected</cfif>>Aprobaci&oacute;n de las actas <cfoutput>#vIdSsn-1#</cfoutput> y <cfoutput>#vIdSsn-2#</cfoutput></option>
                                        <option value="ACTAE" <cfif #vPuntoClave# EQ 'ACTAE'>selected</cfif>>Aprobaci&oacute;n de las actas <cfoutput>#vIdSsn-1#</cfoutput> y de la sesi&oacute;n extraordinaria</option>
                                    </cfif>
                                    <cfif #vPuntoNum# EQ 2>
                                        <option value="RECOMCAAA" <cfif #vPuntoClave# EQ 'RECOMCAAA'>selected</cfif>>Informe de la Comisi&oacute;n de Asuntos Acad&eacute;mico-Administrativos</option>
                                        <option value="RECOMCAAAS" <cfif #vPuntoClave# EQ 'RECOMCAAAS'>selected</cfif>>Informe de la Comisi&oacute;n de Asuntos Acad&eacute;mico-Administrativos, correspondiente a los listados de recomendaciones <cfoutput>#vIdSsn-1#</cfoutput> y <cfoutput>#vIdSsn#</cfoutput></option>
                                    </cfif>
                                    <cfif #vPuntoNum# GTE 3>
                                        <option value="PNCA" <cfif #vPuntoClave# EQ 'PNCA'>selected</cfif>>Propuesta para nombramiento de Jefe del Departamento, Jefe de Unidad, etc&hellip;</option>
                                        <option value="PNIE" <cfif #vPuntoClave# EQ 'PNIE'>selected</cfif>>Propuesta para nombramiento de Investigador Em&eacute;rito</option>
                                        <option value="ICRI" <cfif #vPuntoClave# EQ 'ICRI'>selected</cfif>>Informe de la Comisi&oacute;n de Reglamentos Internos</option>
                                    </cfif>
                                <option value="OTRO" <cfif #vPuntoClave# EQ 'OTRO'>selected</cfif>>Otro</option>
                                    <cfif #vPuntoNum# GTE 3>
										<option value="9999" <cfif #vPuntoClave# EQ '9999'>selected</cfif>>Otros asuntos que se presentará al finalizar Asuntos Generales</option>                                    
									</cfif>
                            </select>
                        </td>
                    </tr>
                <cfelseif #Session.sTipoSesionCel# EQ "2">
                    <tr>
                        <td valign="top" class="Sans10NeNe"></td>
                        <td colspan="2" valign="top">
                            <input type="text" name="punto_clave" id="punto_clave" value="OTRO">
                        </td>
                    </tr>
                </cfif>
                <tr id="trSelAcad" style="display:none;">
                    <td valign="top" class="Sans10NeNe">ACAD&Eacute;MICO</span></td>
                    <td colspan="2" valign="top" class="Sans10NeNe">
                        <input name="vNomAcad" id="vNomAcad" type="text" class="datos" maxlength="100" value="<cfoutput>#vAcdNombre#</cfoutput>" style="width:350px" autocomplete="off"  onfocus="fBorrarParametros();" onkeyup="fListaSeleccionAcademico('NAME');">
                        <input name="vSelAcad" id="vSelAcad" type="hidden" value="<cfoutput>#vAcdId#</cfoutput>" />
                        <br>
                        <div id="lstAcad_dynamic" style="position:absolute;display:block;">
                            <!-- AJAX: Lista desplegable de acad&eacute;micos -->
                        </div>
                    </td>
                </tr>
                <tr>
                    <td valign="top" class="Sans10NeNe">DESCRIPCI&Oacute;N</td>
                    <td colspan="2" valign="top" class="Sans10NeNe"><textarea name="punto_texto" id="punto_texto" rows="5" class="datos100"><cfoutput>#vPuntoTexto#</cfoutput></textarea></td>
                </tr>
                <tr id="trArchivo1">
                    <td class="Sans10NeNe">PDF</td>
                    <td width="804">
                        <input id="punto_pdf" name="punto_pdf" type="file" class="datos100" width="100%" />
                    </td>
                    <td width="30" id="frmArchivoPDF">
                        <cfif FileExists(#vArchivoPdf#)>
                            <cfoutput>
                            <a href="#vWebPdf#" target="_blank"><img src="#vCarpetaIMG#/pdf.png" title="#tbSesionOrden.punto_pdf#" height="30" style="border:none;cursor:pointer;"></a>
                            </cfoutput>
                        </cfif>
                    </td>
                </tr>
                <tr id="trArchivo2" style="display:none;">
                    <td class="Sans10NeNe">PDF</td>
                    <td><input id="punto_pdf_2" name="punto_pdf_2" type="file" class="datos100" width="100%" />
                    </td>
                    <td id="frmArchivoPDF2">
                        <cfif FileExists(#vArchivoPdf2#)>
                            <cfoutput>
                            <a href="#vWebPdf2#" target="_blank"><img src="#vCarpetaIMG#/pdf.png" height="30" onclick="" style="border:none;cursor:pointer;" title="#tbSesionOrden.punto_pdf_2#"></a>
                            </cfoutput>
                        </cfif>
                    </td>
                </tr>
            </table>
            <br>
            <table width="600" align="center" bgcolor="#E4E4E4" class="cuadros" border="0">
                <tr>
                    <td align="center"><input type="button" name="cmdGuardar" id="cmdGuardar" value="Guardar" class="botones" onclick="fValidaCampos();"></td>
                    <td align="center"><input type="button" name="cmdCancelar" id="cmdCancelar" value="Cancelar" class="botones" onclick="cierraventanaPunto();"></td>
                </tr>
            </table>
        </form>
	</body>
</html>
