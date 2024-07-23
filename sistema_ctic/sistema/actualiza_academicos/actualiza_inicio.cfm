<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM_PICHARDO --->
<!--- FECHA: 01/10/2010 --->

<cfquery name="tbAcademicos" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM academicos 
    ORDER BY acd_id DESC
</cfquery>

<html>
	<head>
		<title>STCTIC - Asuntos Acad&eacute;mico-Administrativos</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href="<cfoutput>#vCarpetaCSS#</cfoutput>/formularios.css" rel="stylesheet" type="text/css">
		<link href="<cfoutput>#vCarpetaCSS#</cfoutput>/general.css" rel="stylesheet" type="text/css">
		<link href="<cfoutput>#vCarpetaCSS#</cfoutput>/fuentes.css" rel="stylesheet" type="text/css">
		<style type="text/css">
			.emergente { 
				position: absolute;
				visibility: hidden;
				background-color: #EEEEEE;
				padding: 2px;
				border-style: solid;
				border-width: 1px;
				border-color: #AAAAAA;
				z-index:10; /* Esta propiedad es importante para que se mueste sobre el calendario! */
			} 
		</style>
		<script type="text/javascript" src="xmlHttpRequest.js"></script>
		<script language="JavaScript" type="text/JavaScript">
			// Listar las asuntos que pasan a la CAAA:
			function fIniciaActualiza()
			{
				if (document.getElementById('txtInicia').value != '' && document.getElementById('txtFinal').value != '')
				{
					// Crear un objeto XmlHttpRequest:
					var xmlHttp = XmlHttpRequest();
					// Funci�n de atenci�n a las petici�n HTTP:
					if (document.getElementById('chkCcn').checked == true)
					{
						// Icono de espera:
						document.getElementById('actualizacn_dynamic').innerHTML = "<img src=\"<cfoutput>#vCarpetaIMG#</cfoutput>/wait.gif\" style=\"display:block; margin:auto;\"><br>ACTUALIZANDO CATEGOR�A Y NIVEL DE LOS ACAD�MICOS<br>DEL ACAD�MICO " + document.getElementById('txtInicia').value + " AL " + document.getElementById('txtFinal').value;
						// Funci�n de atenci�n a las petici�n HTTP:
						xmlHttp.onreadystatechange = function(){
							if (xmlHttp.readyState == 4) {
								document.getElementById('actualizacn_dynamic').innerHTML = xmlHttp.responseText;
							}
						}
						// Generar una petici�n HTTP:
						xmlHttp.open("POST", "actualiza_cn.cfm", true);
						xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');					
						parametros = "vIdInicioAct=" + encodeURIComponent(document.getElementById('txtInicia').value); 
						parametros += "&vidFinalAct=" + encodeURIComponent(document.getElementById('txtFinal').value); 						
						xmlHttp.send(parametros);
					}
					if (document.getElementById('chkCod').checked == true)
					{
						// Icono de espera:
						document.getElementById('actualizacod_dynamic').innerHTML = "<img src=\"<cfoutput>#vCarpetaIMG#</cfoutput>/wait.gif\" style=\"display:block; margin:auto;\">";
						// Funci�n de atenci�n a las petici�n HTTP:
						xmlHttp.onreadystatechange = function(){
							if (xmlHttp.readyState == 4) {
								document.getElementById('actualizacod_dynamic').innerHTML = xmlHttp.responseText;
							}
						}
						// Generar una petici�n HTTP:
						xmlHttp.open("POST", "actualiza_cont_cod.cfm", true);
						xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');					
						xmlHttp.send('');
	//					document.getElementById('actualizacod_dynamic').innerHTML = xmlHttp.responseText;
					}
					if (document.getElementById('chkInt').checked == true)
					{
						// Icono de espera:
						document.getElementById('actualizaint_dynamic').innerHTML = "<img src=\"<cfoutput>#vCarpetaIMG#</cfoutput>/wait.gif\" style=\"display:block; margin:auto;\"><br>ACTUALIZANDO INFORMACI�N DE MOVIMIENTOS DE INTERINOS";
						// Funci�n de atenci�n a las petici�n HTTP:
						xmlHttp.onreadystatechange = function(){
							if (xmlHttp.readyState == 4) {
								document.getElementById('actualizaint_dynamic').innerHTML = xmlHttp.responseText;
							}
						}
						// Generar una petici�n HTTP:
						xmlHttp.open("POST", "actualiza_cont_int.cfm", true);
						xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');					
						xmlHttp.send('');
					}
				}
				else
				{
					var vMensaje = '';
					if (document.getElementById('txtInicia').value == '') vMensaje += 'El campo INICAR EN es requerido\n'
					if (document.getElementById('txtFinal').value == '') vMensaje += 'El campo FINALIZAR EN es requerido\n'
					if (vMensaje.length > 0) 
					{
						alert(vMensaje);
					}
				}
			}
			function fActivaDesInicio()
			{
				if (document.getElementById('chkCcn').checked == false && document.getElementById('chkCod').checked == false && document.getElementById('chkInt').checked == false)
				{
					document.getElementById('cmdInicia').disabled = true
				}
				else
				{
					document.getElementById('cmdInicia').disabled = false
				}
			}
		</script>
	</head>
	<body>
		<!-- Control para capturar una ota acerca del asunto -->
		<span id="ComisionNota" class="emergente"></span>
		<!-- Cintillo con nombre del m�dulo y Filtro --> 
		<table class="Cintillo">
			<tr>
				<td>
					<span class="Sans9GrNe">
						ACTUALIZACI�N DE MOVIMIENTOS DE LOS ACAD�MICOS
					</span>
				</td>
				<td align="right">
					<cfoutput>
					<span class="Sans9Gr"><b>SESI�N:#Session.sSesion#</b></span>
					</cfoutput>
				</td>
			</tr>
		</table>
		<!-- Cuerpo de la lista de solicitudes -->
		<table width="1024" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<!-- Columna izquierda (comandos) --> 
				<td width="180" valign="top" class="bordesmenu">
					<!-- Tabla de MMen� Principal -->
					<table width="180" border="0">
						<!-- Divisi�n -->
						<tr><td colspan="2"><div class="linea_menu"></div></td></tr>
						<!-- Men� de la lista de solicitudes -->
						<tr>
							<td colspan="2" valign="top"><div align="left" class="Sans10NeNe">Men&uacute;:</div></td>
						</tr>
						<!-- Opci�n: Imprimir listado -->
						<tr>
						  <td>&nbsp;</td>
						  <td>&nbsp;</td>
					  </tr>
						<tr>
						  <td><input name="vCcn" id="chkCcn" type="checkbox" value="Si" onClick="fActivaDesInicio();"></td>
						  <td><span class="Sans9GrNe">Categor�a y nivel</span></td>
					  </tr>
						<tr>
						  <td><input name="vCod" id="chkCod" type="checkbox" value="Si" onClick="fActivaDesInicio();"></td>
						  <td><span class="Sans9GrNe">No. contratos COD</span></td>
					  </tr>
						<tr>
							<td width="17"><input name="vInt" id="chkInt" type="checkbox" value="Si" onClick="fActivaDesInicio();"></td>
							<td width="133"><span class="Sans9GrNe">No. de Renovaciones</span></td>
						</tr>
						<!-- Opci�n: Genera Archivo para Fortel -->
						<tr>
						  <td colspan="2"><table width="140" border="0">
						    <tr>
						      <td width="65"><span class="Sans9GrNe">Iniciar en </span></td>
						      <td width="65"><input name="txtInicia" type="text" id="txtInicia" size="5" maxlength="5" class="datos" value="1"></td>
					        </tr>
						    <tr>
						      <td><span class="Sans9GrNe">Finalizar en</span></td>
						      <td><input name="txtFinal" type="text" id="txtFinal" size="5" maxlength="5" class="datos" value="<cfoutput>#tbAcademicos.acd_id#</cfoutput>"></td>
					        </tr>
					      </table></td>
					  </tr>
						<tr>
							<td colspan="2"><input name="cmdInicia" id="cmdInicia" type="button" value="Iniciar proceso" class="botones" onClick="fIniciaActualiza();" disabled></td>
						</tr>
    					<!-- Tipo de vista de la lista -->
						<tr><td colspan="2" valign="top"><br><div class="linea_menu"></div></td></tr>
					</table>
    </td>
				<!-- Columna derecha (listado) -->  
				<td width="844" valign="top">
                    <table width="400" border="0" align="center">
                        <tr>
                            <td id="actualizacn_dynamic" height="50" align="center"><!-- AJAX: Actualiza categor�a y nivel --></td>
                        </tr>
                        <tr>
                            <td id="actualizacod_dynamic" height="50" align="center"><!-- AJAX: Actualiza acad�micos --></td>
                        </tr>
                        <tr>
                            <td id="actualizaint_dynamic" height="50" align="center"><!-- AJAX: Actualiza acad�micos --></td>
                        </tr>
                    </table>
				</td>
			</tr>
		</table>
		<p>&nbsp;</p>
		<p>&nbsp;</p>
    </body>
</html>
