<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 21/10/2009 --->
<!--- FECHA ÚLTIMA MOD.: 10/06/2016 --->

<!--- LISTA DE MIEMBROS DE AL CAAA --->

<!--- Parámetros --->

<!--- Crear un arreglo para guardar la información del filtro --->
<cfif NOT IsDefined('Session.MiembrosCaaaFiltro')>
	<!--- Crear un arreglo para guardar la información del filtro --->
	<cfscript>
		MiembrosCaaaFiltro = StructNew();
//		ConsejerosFiltro.vDep = '';
//		ConsejerosFiltro.vAdmClave = '';
		MiembrosCaaaFiltro.vActivosCaaa = 'checked';
		MiembrosCaaaFiltro.vPagina = '1';
//		ConsejerosFiltro.vRPP = '25';
//		ConsejerosFiltro.vOrden = 'acd_apepat'; // 'asu_parte ASC, asu_numero'
//		ConsejerosFiltro.vOrdenDir = 'ASC';  //'ASC'
	</cfscript>
	<cfset Session.MiembrosCaaaFiltro = '#MiembrosCaaaFiltro#'>
</cfif>

<cfquery name="tbSesionCaaa" datasource="#vOrigenDatosSAMAA#">
	SELECT TOP 1 ssn_id FROM sesiones 
    WHERE ssn_clave = 4 
    AND ssn_fecha >= GETDATE() 
    ORDER BY ssn_id
</cfquery>

<cfset vSesionActualCaaa = #tbSesionCaaa.ssn_id#>

<cfquery name="tbCatalogoComision" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_comisiones
	ORDER BY comision_nombre
</cfquery>

<html>
	<head>
		<title>STCTIC - Miembros del CTIC</title>
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
		<!--- JAVA SCRIPT --->
		<script type="text/javascript">
			// Mostrar la lista de consejeros CTIC:
			function fListarMiedmbrosCaaa(vPagina, vOrden, vOrdenDir)
			{
				// Icono de espera:
				document.getElementById('miembrosCaaa_dynamic').innerHTML = "<img src=\"<cfoutput>#vCarpetaIMG#</cfoutput>/wait.gif\" style=\"display:block; margin:auto;\">";
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Función de atención a las petición HTTP:
				xmlHttp.onreadystatechange = function(){
					if (xmlHttp.readyState == 4) {
						document.getElementById('miembrosCaaa_dynamic').innerHTML = xmlHttp.responseText;
					}
				}
				// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones
				xmlHttp.open("POST", "lista_miembros_caaa.cfm", true);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = document.getElementById('vActivoCaaa').checked ? "vActivoCaaa=checked": "vActivoCaaa=";
//				parametros += "&vDepClave=" + encodeURIComponent(document.getElementById('vDepClave').value);
				parametros += "&vPagina=" + encodeURIComponent(vPagina);
//				parametros += "&vRPP=" + encodeURIComponent(document.getElementById('vRPP').value);

				// Enviar la petición HTTP:
				xmlHttp.send(parametros);
			}		
			function fNuevaComisionAcad()
			{
				window.location.replace('miembro_caaa.cfm?vTipoComando=NUEVO')
			}
		</script>
		<!--- JQUERY --->
        <script language="JavaScript" type="text/JavaScript">
			// Ventana del diálogo (jQuery) para LIBERAR EL REGISTRO
			$(function() {
				$('#dialog:ui-dialog').dialog('destroy');
				$('#divEnviaCorreoCaaa').dialog({
					autoOpen: false,
					height: 600,
					width: 750,
					modal: true,
					maxHeight: 700,
					title:'CORREO PARA LA COMISIÓN DE ASUNTOS ACADÉMICO-ADMINISTRATIVOS',
					open: function() {
						$(this).load('caaa_correo.cfm',{});
//						$(this).load('caaa_correo.cfm', {vpSesion:('dos'), vDepId:('uno')});
//						$(this).load('libera_registro.cfm', {vNumero:$('#vNumero').val(), vTipoRegistro:$('#vTipoRegistro').val(), vValorLibera:$('#cmdLibera').is(':checked') ? 1 : 0});
					}
				});
				$('#cmdEnvioCorreo').click(function(){
					$('#divEnviaCorreoCaaa').dialog('open');
				});
			});				
		</script>
		<script language="javascript" type="text/javascript">
			<!-- FUNCION QUE VALIDA LOS CAMPOS SELECCIONADO -->
			function vValidaCorreo()
			{
				var vAlertaCorreo = '';
				var vCamposChecados = '';				
				for (c=0; c<document.forms[0].elements.length; c++)
				{
					if (document.forms[0].elements[c].checked == true)
					{
						vCamposChecados = vCamposChecados + 1
//						alert(document.forms[0].elements[c].id)
					}
				}
//				if (document.getElementById('txtAsunto').value == '' ||  document.getElementById('txtDescripcion').value == '' || vCamposChecados == 0)
				if (document.getElementById('txtAsunto').value == '' || vCamposChecados == 0)
				{
					if (document.getElementById('txtAsunto').value == '') vAlertaCorreo = 'Campo: ASUNTO es obligarorio.\n';
//					if (document.getElementById('txtDescripcion').value == '') vAlertaCorreo += 'Campo: DESCRIPCIÓN es obligarorio.\n';
					if (vCamposChecados == 0)  vAlertaCorreo += 'Debe seleccionar al menos un DESTINATARIO.\n';
					alert(vAlertaCorreo);
				}
				else
				{
					document.forms['frmCorreo'].action = 'caaa_correo_envia.cfm'
					document.forms['frmCorreo'].submit()
				}
			}
			<!-- FUNCION QUE HABILITA O DESHABILITA LOS CAMPOS PARA INDICAR EL RANGO DE ASUNTOS -->
			function fDelAl(vControl, vCorreo)
			{
				var txtIni = 'txtIni' + vControl.value 
				var txtFin = 'txtFin' + vControl.value
				if (vCorreo == '')
				{
					document.getElementById('chk' + vControl.value).checked = false
					alert('El miembro de la CAAA no cuenta con correo electrónico')
				}
				if (vControl.checked == true)
				{
					document.getElementById(txtIni).disabled = ''
					document.getElementById(txtFin).disabled = ''
				}
				else
				{
					document.getElementById(txtIni).disabled = 'disabled'
					document.getElementById(txtFin).disabled = 'disabled'
				}
			}
			<!-- PRUEBA: FUNCION TEMPORAL ---->
			function vAlertElement(vControl)
			{
				alert(vControl.name)
			}
			<!-- CREADO: JOSE ANTONIO ESTEVA--->
			<!-- EDITO: JOSE ANTONIO ESTEVA--->
			<!-- FECHA: 24/03/2009--->
			<!-- FUNCION PARA APLICAR MASCASAR DE ENTRADA --->
			function MascaraEntrada(e, mascara) 
			{
				var codigo;
				var origen;
				var posicion;
				var filtro;
				// Acceso a objeto de evento:
				if (!e) var e = window.event;
				// Detectar el objeto que originó el evento: 
				if (e.target) origen= e.target;
				else if (e.srcElement) origen = e.srcElement;
				if (origen.nodeType == 3) origen = targ.parentNode;
				// Obtener el código de la tecla oprimida:
				if (e.keyCode) codigo = e.keyCode;
				else if (e.which) codigo = e.which;
				// Dejar pasar teclas para borrar y saltar al siguiente campo (pueden ser más):
				if (codigo == 8 || codigo == 9 || codigo == 46) return true;
				// Obtener la posición donde se está capturando y su máscara correspondiente: 
				posicion = origen.value.length;
				// Si en la posición actual hay un delimitador agregarlo a la cadena y pasar a la siguiente posición:
				filtro = mascara.charAt(posicion);
				if (filtro!='9' && filtro!='A')
				{
				   origen.value += filtro; 
				   posicion++;
				   filtro = mascara.charAt(posicion); 
				} 
				// Verificar si el carácter tecleado corresponde a la máscara:
				if (filtro == "9" && (codigo >= 48 && codigo <= 57)) return true; 										// Número
				if (filtro == "A" && ((codigo >= 65 && codigo <= 90) || (codigo >= 97 && codigo <= 122))) return true; 	// Letra
				// Sino, no pasa!
				return false;	 
			}
			function fSubmitFormulario(vComandoSel)
			{
				if (vComandoSel == 'REGRESA')	
				{
					window.location = 'miembros_caaa_lista.cfm';
				}
			}
		</script>

	</head>
	<body onLoad="fListarMiedmbrosCaaa(<cfoutput>#Session.MiembrosCaaaFiltro.vPagina#</cfoutput>);">
		<!-- Cintillo con nombre del módulo y filtro--> 
		<table class="Cintillo">
			<tr>
				<td><span class="Sans9GrNe">COMISIÓN DE ASUNTOS ACADÉMICO-ADMINISTRATIVOS</span></td>
				<td align="right"><cfinclude template="#vCarpetaINCLUDE#/sesion_vigente.cfm"></td>
			</tr>
		</table>
		<!-- Contenido -->
		<table width="1024" border="0">
			<tr>
				<!-- Columna izquierda (comandos) --> 
				<td width="180" valign="top">
					<!-- Controles -->
					<table width="155" border="0">
						<!-- Menú de la lista de sesiones -->
						<tr><td><div class="linea_menu"></div></td></tr>
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">Men&uacute;:</div></td>
						</tr>
						<!-- Opción: Nuevo cargo -->
						<tr>
							<td valign="top">
								<input name="cmdNuevoCaaa" type="button" class="botones" onClick="fNuevaComisionAcad();" value="Nuevo miembro CAAA">
							</td>
						</tr>
						<tr>
							<td valign="top">
								<cfoutput>
									<input name="cmdEnvioCorreo" id="cmdEnvioCorreo" type="button" class="botones" value="Envío correo CAAA (#tbSesionCaaa.ssn_id#)">
								</cfoutput>
							</td>
						</tr>						<tr>
							<td valign="top">
								<input name="button" type="button" class="botones" onClick="" value="Imprimir relación" disabled>
							</td>
						</tr>
						<!-- Contador de registros -->
						<tr><td valign="top"><br><div class="linea_menu"></div></td></tr>
						<tr>
                        	<td valign="middle">
								<div align="left" style="width:130px; position:absolute;"><span class="Sans10ViNe">SÓLO ACTIVO</span></div>
								<div align="left" style="width:20px; position:absolute; left:133px;">
                                <cfoutput>
	                                <input name="vActivoCaaa" id="vActivoCaaa" type="checkbox" class="datos" #Session.MiembrosCaaaFiltro.vActivosCaaa# onClick="fListarMiedmbrosCaaa(#Session.MiembrosCaaaFiltro.vPagina#);">
                                </cfoutput>
								</div>
                            </td>
                        </tr>

<!---
						<tr>
							<td valign="top">
								<span class="Sans9GrNe">Total: </span>
								<span class="Sans9Gr">
									<cfoutput>#tbComision.RecordCount#</cfoutput>
								</span>
							</td>
						</tr>
---->						
					</table>
				</td>
				<!-- Columna derecha (listado) -->
				<td width="844" valign="top">
                    <cfoutput>#Application.vCarpetaRaiz#</cfoutput>                    
                	<div id="miembrosCaaa_dynamic"><!-- Lista de miembros de la comisión de la CAAA --></div>
					<div id="divEnviaCorreoCaaa" width="100%">
						<!-- JQUERY: DIV que para desplegar pantalla emergente para el envío de correos a los miembros de la CAAA -->
					</div>
				</td>
			</tr>
		</table>
	</body>
</html>
