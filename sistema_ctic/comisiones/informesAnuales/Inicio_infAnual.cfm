<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 10/06/2016 --->
<!--- FECHA ÚLTIMA MOD.: 29/04/2020 --->

<!--- PÁGINA DE INICIO PARA LA COMISIÓN DE BECAS POSDOCTORALES --->

<!--- Parámetros --->

<!--- Crear un arreglo para guardar la información del filtro --->
<cfif NOT IsDefined('Session.MiembrosCbpFiltro')>
	<!--- Crear un arreglo para guardar la información del filtro --->
	<cfscript>
		MiembrosCbpFiltro = StructNew();
//		ConsejerosFiltro.vDep = '';
//		ConsejerosFiltro.vAdmClave = '';
		MiembrosCbpFiltro.vActivosCaaa = 'checked';
		MiembrosCbpFiltro.vPagina = '1';
//		ConsejerosFiltro.vRPP = '25';
//		ConsejerosFiltro.vOrden = 'acd_apepat'; // 'asu_parte ASC, asu_numero'
//		ConsejerosFiltro.vOrdenDir = 'ASC';  //'ASC'
	</cfscript>
	<cfset Session.MiembrosCbpFiltro = '#MiembrosCbpFiltro#'>
</cfif>

<cfquery name="tbSesionCbp" datasource="#vOrigenDatosSAMAA#">
	SELECT TOP 1 ssn_id FROM sesiones 
    WHERE ssn_clave = 33 
    AND ssn_fecha >= '#vFechaHoy#'
    ORDER BY ssn_id
</cfquery>

<cfset vSesionActualCbp = #tbSesionCbp.ssn_id#>

<cfif #vSesionActualCbp# NEQ ''>
    <cfquery name="tbSolicitudComision" datasource="#vOrigenDatosSAMAA#">
        SELECT * FROM samaa_accesos_comisiones
        WHERE ssn_id = #vSesionActualCbp#
        AND asu_reunion = 'CBP'
    </cfquery>
</cfif>

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
		<!--- JQUERY --->
        <script language="JavaScript" type="text/JavaScript">
			// Ventana del diálogo (jQuery) para LIBERAR EL REGISTRO
			$(function() {
				$('#dialog:ui-dialog').dialog('destroy');
				$('#divEnviaCorreoCbp').dialog({
					autoOpen: false,
					height: 200,
					width: 450,
					modal: true,
					maxHeight: 700,
					title:'CORREO PARA LA COMISIÓN DE BECAS POSDOCTORALES',
					open: function() {
						$(this).load('cbp_genera_liga.cfm',{vSesionActualCbp:<cfoutput>#tbSesionCbp.ssn_id#</cfoutput>});
//						$(this).load('caaa_correo.cfm', {vpSesion:('dos'), vDepId:('uno')});
//						$(this).load('libera_registro.cfm', {vNumero:$('#vNumero').val(), vTipoRegistro:$('#vTipoRegistro').val(), vValorLibera:$('#cmdLibera').is(':checked') ? 1 : 0});
					}
				});
				$('#cmdGeneraLigaCbp').click(function(){
					$('#divEnviaCorreoCbp').dialog('open');
				});
			});				
		</script>
	</head>
	<body>
		<!-- Cintillo con nombre del módulo y filtro--> 
		<table class="Cintillo">
			<tr>
				<td><span class="Sans9GrNe">COMISIÓN DE BECAS POSDOCTORALES</span></td>
				<td align="right">
	                <cfinclude template="#vCarpetaINCLUDE#/sesion_vigente.cfm">
				</td>
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
						<tr><td height="18px;"></td></tr>
						<tr>
							<td><span class="Sans10NeNe">Liga para comisión de becas <cfoutput>(#vSesionActualCbp#)</cfoutput></span></td>
						</tr>
						<tr>
							<td valign="top"><input name="cmdGeneraLigaCbp" id="cmdGeneraLigaCbp" type="button" class="botones" value="Generar liga"></td>
						</tr>
						<!-- Contador de registros -->
						<tr><td valign="top"><br><div class="linea_menu"></div></td></tr>
					</table>
				</td>
				<!-- Columna derecha (listado) -->
				<td width="844" valign="top" align="center">
                	<div style="width:80%; padding-top:100px;">
						<cfif #vSesionActualCbp# NEQ ''>
                            <span class="Sans12ViNe">
                                <cfif #tbSolicitudComision.RecordCount# EQ 0>
                                    GENERAR LIGA
                                <cfelse>
                                    LIGA DISPONIBLE
                                </cfif>
                                PARA LA REUNIÓN DE LA COMISIÓN DE BECAS POSDOCTORALES <cfoutput>#vSesionActualCbp#</cfoutput>
                                </span>
                                <br/><br/>
                                <span class="Sans12Gr">
                                <cfif #tbSolicitudComision.RecordCount# GT 0>
                                    <cfoutput query="tbSolicitudComision">
                                    #Application.vCarpetaRaiz#/inicia_sesion.cfm?vChargesLt=#clave_acceso#&vDanFautsQb=#clave_alfanum#&vMiembro=CBP_#vSesionActualCbp#&vReunionTipo=CBP&vSesionActual=#vSesionActualCbp#
                                    </cfoutput>                                
                                </cfif>
							</span>
						<cfelse>
                            <span class="Sans12ViNe">
								NO HAY SESIÓN VIGENTE PARA LA COMISIÓN DE BECAS. <br>EN CASO DE HABER UNA PRÓXIMA REUNIÓN DEBE AGREGARSE EL REGISTRO EN:<br /><br />
                                <ul>
									<li style="text-align:left;">MENÚ PRINCIPAL - CALENDARIOS / ORDENES DEL DÍA</li>
									<li style="text-align:left;">CALENDARIO DE SESIONES - COMISIÓN DE BECAS POSDOCTORALES</li>
								</ul>
                            </span>							
						</cfif>
					</div>
<!---               	<div id="miembrosCbp_dynamic"><!-- Lista de miembros de la comisión de la CAAA --></div> --->
					<div id="divEnviaCorreoCbp" width="100%">
						<!-- JQUERY: DIV que para desplegar pantalla emergente para el envío de correos a los miembros de la CAAA -->
					</div>
				</td>
			</tr>
		</table>
	</body>
</html>
