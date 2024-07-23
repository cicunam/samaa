<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 30/09/2009 --->
<!--- FECHA ULTIMA MOD.: 26/02/2024 --->

<!--- Obtener la lista de movimientos disponibles --->
<cfquery name="ctMovimiento" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_movimiento 
    WHERE mov_status = 1
	<cfif #Session.sTipoSistema# IS 'sic'> <!--- SI ES ESNTIDAD DEL SUBSISTEMA NO PERMITE DESPLEGAR LA FT-35 RECURSO DE REVISION --->
		AND mov_clave <> 35
    </cfif>
    ORDER BY mov_orden
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
		</cfoutput>

        
        <script language="JavaScript" type="text/JavaScript">
			// El usuario selecciona una forma telegrámica:
			function fSeleccionForma(vFt)
			{
				document.getElementById('lstAcad_dynamic').innerHTML = ''
				document.getElementById('lstPlazas_dynamic').innerHTML = ''
				document.getElementById('lstSaba_dynamic').innerHTML = ''
				document.getElementById('lstAsuntos_dynamic').innerHTML = ''
				document.getElementById('lstPosdocVerifica_dynamic').innerHTML = ''

				// Se el usuario seleccionó una FT válida:
				if (vFt != 0) 
				{
					document.getElementById("seleccion_acad_1").style.display = 'none';
					document.getElementById("seleccion_acad_2").style.display = 'none';
					document.getElementById("lstPlazas_dynamic").style.display = 'none';
					document.getElementById("lstAsuntos_dynamic").style.display = 'none';
					document.getElementById("lstSaba_dynamic").style.display = 'none';
					document.getElementById("vSelAcad").value = '';
					document.getElementById("vAcadNom").style.display = 'none';
					document.getElementById("vAcadNom").value = '';
					document.getElementById("cmdSiguente").style.display = 'none';
					
					if (vFt == 15 || vFt == 16 || vFt==42)
					{
						fListarPlazas();
						document.getElementById("lstPlazas_dynamic").style.display = '';
					}
					else
					{
						document.getElementById("seleccion_acad_1").style.display = '';
						document.getElementById("seleccion_acad_2").style.display = '';
						document.getElementById("vAcadNom").style.display = '';
						document.getElementById("vAcadNom").value = '';
					}
				}
			}

			// Obtener la lista de académicos:
			function fListaSeleccionAcademico()
			{
				// Ocultar la lista si no hay datos:
				if (document.getElementById('vAcadNom').value.length == 0) document.getElementById('lstAcad_dynamic').innerHTML = '';
				// Empezar a buscar a partir de 3 letras:
				if (document.getElementById('vAcadNom').value.length <= 3) return;
				// Crear un objeto XmlHttpRequest:

				var xmlHttp = XmlHttpRequest();
				// Función de atención a las petición HTTP:
				xmlHttp.onreadystatechange = function(){
					if (xmlHttp.readyState == 4) {
						document.getElementById('lstAcad_dynamic').innerHTML = xmlHttp.responseText;
					}
				}
				// Generar una petición HTTP: (Cambié el charset de iso-8859-1 a utf-8 para que pasen las letras Ñ-ñ)))
				xmlHttp.open("POST", "lista_academicos.cfm", true);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=utf-8');
				// Crear la lista de parámetros:
				parametros = "vTexto=" + encodeURIComponent(document.getElementById('vAcadNom').value);
				parametros += "&vFt=" + encodeURIComponent(document.getElementById('vFt').value);
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);
			}

			<!--- ******* AJAX DE LOS DIFERENTES RUBROS EXTRAS A SELECCIONAR ******* --->
			// Obtener la lista de periodos sabáticos del académico:
			function fListarPlazas()
			{
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Función de atención a las petición HTTP:
				xmlHttp.onreadystatechange = function(){
					if (xmlHttp.readyState == 4) {
						document.getElementById('lstPlazas_dynamic').innerHTML = xmlHttp.responseText;
					}
				}
				// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
				xmlHttp.open("POST", "lista_plazas.cfm", true);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "vFt=" + encodeURIComponent(document.getElementById('vFt').value); // Para hacer algunos filtros
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);
			}
			// Obtener la lista de periodos sabáticos del académico:
			function fListarSabaticos()
			{
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Función de atención a las petición HTTP:
				xmlHttp.onreadystatechange = function(){
					if (xmlHttp.readyState == 4) {
						document.getElementById('lstSaba_dynamic').innerHTML = xmlHttp.responseText;
					}
				}
				// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
				xmlHttp.open("POST", "lista_sabaticos.cfm", true);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "vIdAcad=" + encodeURIComponent(document.getElementById('vSelAcad').value);
				parametros += "&vFt=" + encodeURIComponent(document.getElementById('vFt').value);
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);
			}

			// Obtener la lista de asuntos para recorsos de revisión, reconsideración y corrección a oficio:
			function fListarAsuntos(vTipo)
			{
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Función de atención a las petición HTTP:
				xmlHttp.onreadystatechange = function(){
					if (xmlHttp.readyState == 4) {
						document.getElementById('lstAsuntos_dynamic').innerHTML = xmlHttp.responseText;
					}
				}
				// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
				xmlHttp.open("POST", "lista_asuntos.cfm", true);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "vIdAcad=" + encodeURIComponent(document.getElementById('vSelAcad').value);
				parametros += "&vFt=" + encodeURIComponent(document.getElementById('vFt').value);
				parametros += "&vTipo=" + encodeURIComponent(vTipo);
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);
			}

			// Obtener la lista de solicitudes o asuntos duplicados:
			function fListarAsuntosDuplicados()
			{
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Función de atención a las petición HTTP:
				// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
				xmlHttp.open("POST", "lista_sol_duplicada.cfm", false);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "vIdAcad=" + encodeURIComponent(document.getElementById('vSelAcad').value);
				parametros += "&vFt=" + encodeURIComponent(document.getElementById('vFt').value);
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);
				document.getElementById('dinamico').innerHTML = xmlHttp.responseText

				if (document.getElementById('vResConf'))
				{
//					alert('SI ENCONTRE')
					if (confirm(document.getElementById('vResConf').value + '\n' + document.getElementById('vResConf2').value + '. ¿Desea continuar? En caso de aceptar, el registro se duplicará.'))
					{
						fSeleccionAcademico();
					}
				}	
				else
				{
//					alert('NO ENCONTRE')
					fSeleccionAcademico();
				}
			}


			// NOTA: Las siguientes 3 funciones hacen lo mismo y pueden reemplazarse por una sola, por ejemplo, fMostrarSiguiente().
			// El usuario ha ingresado todos los datos necesarios:
			function fSeleccionCompleta()
			{
				// Mostrar el botón "Siguiente":
				document.getElementById("cmdSiguente").style.display = '';
			}
			
			// Validar la selección de un académico:
			function fValidaIdAcad()
			{
				if (document.getElementById("vSelAcad").value == '' && (document.getElementById("vFt").value != 15 && document.getElementById("vFt").value != 16 && document.getElementById("vFt").value != 42)) 
				{
					alert('Por favor, seleccione una académico de la lista desplegada.');
					return false;
				}
				if (document.getElementById("vFt").value == 5 || document.getElementById("vFt").value == 15 || document.getElementById("vFt").value == 16 || document.getElementById("vFt").value == 17 || document.getElementById("vFt").value == 28 || document.getElementById("vFt").value == 42) 
				{
					if (!document.getElementById("vIdCoa")) 
					{
						alert('Espere, antes debe seleccionar un número de plaza.');
						return false;
					}
					else if (document.getElementById("vIdCoa").value == '')
					{
						alert('Por favor, seleccione un número de plaza.');
						return false;
					}
				}
				
				if (document.getElementById("vFt").value == 31 || document.getElementById("vFt").value == 35 || document.getElementById("vFt").value == 37) 
				{
					if (!document.getElementById("selAsunto")) 
					{
						alert('Espere, antes debe seleccionar un asunto.');
						return false;
					}
					else if (document.getElementById("selAsunto").value == '')
					{
						alert('Por favor, seleccione un asunto.');
						return false;
					} 
				}
				return true;
			}

			// Verifica que el solicitante a beca posdoctoral NO CUENTE con la asignasión de los dos periodos de BECA POSDOC DGAPA:
			function fVerificaPosdoc()
			{
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Función de atención a las petición HTTP:
				xmlHttp.onreadystatechange = function(){
					if (xmlHttp.readyState == 4) {
						document.getElementById('lstPosdocVerifica_dynamic').innerHTML = xmlHttp.responseText;
						if (document.getElementById('CuentaRegistrosBecas').value == 0 && document.getElementById('vFt').value == 38) document.getElementById("cmdSiguente").style.display = '';
						if (document.getElementById('CuentaRegistrosBecas').value == 0 && document.getElementById('vFt').value == 39) document.getElementById("cmdSiguente").style.display = '';						
						if (document.getElementById('CuentaRegistrosBecas').value > 2) document.getElementById("cmdSiguente").style.display = 'none';
					}
				}
				// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
				xmlHttp.open("POST", "posdoctoral_verifica_no_becas.cfm", true);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "vIdAcad=" + encodeURIComponent(document.getElementById('vSelAcad').value);
				parametros += "&vpFt=" + encodeURIComponent(document.getElementById('vFt').value);				
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);
			}			

			function fSiguientePaso()
			{
				if (document.getElementById("vSelAcad").value == '0')
				{
					document.getElementById("divNuevoAcademico").style.display = '';
					document.getElementById("divNuevoAcademico").click();
				}
				else
				{
					document.getElementById("frmSelFt").submit();
				}				
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
						if ($('#vFt').val() != 5) 
						$(this).load('<cfoutput>#vCarpetaRaizWebSistema#</cfoutput>/academicos/academico_nuevo/nuevo_academico.cfm',{vFt:$('#vFt').val()});
						if ($('#vFt').val() == 5) 
						$(this).load('<cfoutput>#vCarpetaRaizWebSistema#</cfoutput>/academicos/academico_nuevo/nuevo_academico.cfm',{vFt:$('#vFt').val(), vIdCoa:$('#vIdCoa').val()});
//						$(this).load('caaa_correo.cfm', {vpSesion:('dos'), vDepId:('uno')});
//						$(this).load('libera_registro.cfm', {vNumero:$('#vNumero').val(), vTipoRegistro:$('#vTipoRegistro').val(), vValorLibera:$('#cmdLibera').is(':checked') ? 1 : 0});
					}
				});
				$('#divNuevoAcademico').click(function(){
					$('#divNuevoAcademico').dialog('open');
				});
			});				
		</script>
	</head>
	<body>
		<!-- Cintillo con nombre del módulo --> 
		<table class="Cintillo">
			<tr>
				<td><span class="Sans9GrNe">SOLICITUDES &gt;&gt; </span><span class="Sans9Gr">INGRESAR NUEVA SOLICITUD</span></td>
			</tr>
		</table>
		<cfform name="form" id="frmSelFt" method="post" action="select_ft_n.cfm" enctype="multipart/form-data" onsubmit="return fValidaIdAcad();">
		<table width="1024" height="400" border="0">
			<tr>
				<!-- Parte izquierda -->
				<td width="180" height="240" valign="top">
					<!-- Menú lateral -->
					<table width="180" border="0" class="bordesmenu">
						<tr>
							<td><div class="linea_menu"></div></td>
						</tr>
						<!-- Menú de nueva solicitude -->
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">Men&uacute;:</div></td>
						</tr>
						<!-- Botón de comando "Restablecer" -->
						<tr>
							<td valign="top">
								<input type="button" class="botones" value="Restablecer" onClick="location.reload();">
							</td>
						</tr>
						<!-- Botón de comando "Cancelar" -->
						<tr>
							<td height="23" valign="top">
								<input onClick="window.location.replace('<cfoutput>#Session.sModulo#</cfoutput>');" type="button" class="botones" value="Cancelar">
							</td>
						</tr>
					</table>
				</td>
				<!-- Parte derecha -->
				<td width="844" valign="top">
					<!-- Selección de Forma, Académico y Plaza (en su caso) -->			    
					<table style="width: 814px; margin:5px 5px 2px 15px;" cellspacing="0">
						<!--Leyenda de selector de forma telegrámica -->    
						<tr>
							<td height="22" colspan="2" class="Sans10GrNe" style="padding: 5px; background-color: #9eb8d2">Seleccione el tipo de solicitud:</td>
						</tr>
						<!-- Selector de forma telegrámica -->    
						<tr>
							<td colspan="2" style="padding: 5px; background-color: #9eb8d2">
								<select name="vFt" id="vFt" class="datos" style="width:100%;" onChange="fSeleccionForma(this.value)">
									<option value="" selected>Seleccione forma telegr&aacute;mica</option>
									<cfoutput query="ctMovimiento">
										<option value="#mov_clave#"> #mov_noft#.-#mov_titulo# <cfif #mov_clase# NEQ ''>#mov_clase#</cfif></option>
									</cfoutput>
								</select>
							</td>
						</tr>
						<tr><td height="18" colspan="2"></td></tr>
						<!-- Leyenda selección del académico -->
						<tr id="seleccion_acad_1" style="display: none;">
							<td height="18" colspan="2">
								<span class="Sans10GrNe">Escriba el nombre del acad&eacute;mico:</span>
							</td>
						</tr>
						<!-- Selección del académico -->
						<tr id="seleccion_acad_2" style="display: none;">
							<td height="18" class="Sans9GrNe">
								<input name="vAcadNom" id="vAcadNom"  type="text" class="datos" maxlength="100" style="width: 550px;" autocomplete="off"> <!---  onKeyUp="fTeclas();"--->
                                <cfinput type="#vTipoInput#" name="vSelAcad" id="vSelAcad" value="">
								<!--- <cfinput type="#vTipoInput#" name="Tipo_contrato" id="Tipo_contrato" value=""> (NO SE UTILIZA (07/12/2021)) --->
						        <cfinput type="#vTipoInput#" name="vLigaAjax" id="vLigaAjax" value="lista_academicos.cfm">
                                <!--- INCLUDE ADICIONAL PARA LA BÚSQUEDA DE ACADÉMICOS (FECHA INCORPORA 12/11/2019) --->
                                <cfset vTipobusquedaValor = 'SelAcdSol'>
                                <cfinclude template="#vCarpetaCOMUN#/lista_academicos_teclas_contol.cfm"></cfinclude>
								<br>
								<div id="lstAcad_dynamic">
									<!-- AJAX: Lista desplegable de académicos -->
								</div>
							</td>
						</tr>
						<tr>
							<td height="18" colspan="2">
								<!--- ESPACIO PARA DESPLEGAR DIFERENTES AJAX --->
								<!-- Seleción de número de plaza -->                            
                            	<div id="lstPlazas_dynamic" style="text-align: left;display: none;"><!-- AJAX: Lista de PLAZAS --></div>
								<!-- Seleción de asunto ha realizar: Correción a Oficio; Recurso de Reconsideración; Recurso de Revisión -->
                            	<div id="lstAsuntos_dynamic" style="text-align: left;display: none;"><!-- AJAX: Lista de ASUNTOS --></div>
								<!-- Seleción de periodo sabático -->
                            	<div id="lstSaba_dynamic" style="text-align: left;display: none;"><!-- AJAX: En caso de contar con dos periodos de beca posdoc se lista, de lo contrario activa el botón siguiente --></div>
								<!-- Verifica Becarios Posdoc DGAPA (se agregó el 12/08/2015-->
                            	<div id="lstPosdocVerifica_dynamic" style="text-align: left;display: none;"><!-- AJAX: En caso de contar con dos periodos de beca posdoc se lista, de lo contrario activa el botón siguiente --></div>
								<!-- Div para ejecutar JQuery para agregar nuevo académico -->
                            	<div id="divNuevoAcademico" style="text-align: left;display: none;"><!-- DIV para dar de alta nuevo académico --></div>
							</td>
						</tr>
						<!-- Botón de comando "Siguiente" -->
						<tr>
							<td style="text-align: right;">
								<input name="cmdSiguente" id="cmdSiguente" type="button" class="botones" value="Siguiente &gt;&gt;" onClick="fSiguientePaso();" style="display:none; width:180px;">
							</td>
						</tr>
					</table>
                    <div id="dinamico"></div>
				</td>
			</tr>
		</table>
		</cfform>
	</body>
</html>

<!--- JAVA SCRIPT COMÚN PARA REALIZAR BÚSQUEDAD DE ACADÉMICOS (FECHA INCORPORA 12/11/2019) --->
<cfoutput>
    <script type="text/javascript" src="#vCarpetaRaizLogicaSistema#/comun/java_script/ajax_lista_academicos_teclas.js"></script>
</cfoutput>