<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: JOSE ANTONIO ESTEVA --->
<!--- FECHA CREA: 22/01/2010 --->
<!--- FECHA ÚLTIMA MOD.: 22/01/2010 --->
<!--- FORMULARIO PARA SESIONES ORDINARIAS --->

<cfinclude template="../javascript/sesion_scripts_valida.cfm">

<cfquery name="tbCalRecDoc" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM sesiones WHERE ssn_clave = 5
	<cfif #vTipoComando# EQ "EDITA" OR #vTipoComando# EQ "CONSULTA">AND ssn_id = #vSesionId#</cfif>
	ORDER BY ssn_id DESC
</cfquery>
<cfquery name="tbCalCaaa" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM sesiones WHERE ssn_clave = 4
	<cfif #vTipoComando# EQ "EDITA" OR #vTipoComando# EQ "CONSULTA">AND ssn_id = #vSesionId#</cfif>
	ORDER BY ssn_id DESC
</cfquery>
<cfquery name="tbCalCorrespondencia" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM sesiones WHERE ssn_clave = 3
	<cfif #vTipoComando# EQ "EDITA" OR #vTipoComando# EQ "CONSULTA">AND ssn_id = #vSesionId#</cfif>
	ORDER BY ssn_id DESC
</cfquery>
<cfquery name="tbCalPleno" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM sesiones WHERE ssn_clave = 1
	<cfif #vTipoComando# EQ "EDITA" OR #vTipoComando# EQ "CONSULTA">AND ssn_id = #vSesionId#</cfif>
	ORDER BY ssn_id DESC
</cfquery>

<cfif #vTipoComando# EQ "NUEVO">
	<cfset vActivaCampos = "">
	<cfset vssn_id = #tbCalPleno.ssn_id# + 1>
	<cfset vssn_fechaRecDoc = #LsDateFormat(tbCalRecDoc.ssn_fecha + 14,'dd/mm/yyyy')#>
	<cfset vssn_horaRecDoc = "14:00">
	<cfset vssn_sedeRecDoc = "">
	<cfset vssn_notaRecDoc = "">
	<cfset vssn_fechaCaaa = #LsDateFormat(tbCalCaaa.ssn_fecha + 14,'dd/mm/yyyy')#>
	<cfset vssn_horaCaaa = "09:45">
	<cfset vssn_sedeCaaa = "en la sala de ex-coordinadores del CTIC">	
	<cfset vssn_notaCaaa = "">
	<cfset vssn_fechaCorresp = #LsDateFormat(tbCalCorrespondencia.ssn_fecha + 14,'dd/mm/yyyy')#>
	<cfset vssn_sedeCorresp = "">	
	<cfset vssn_notaCorresp = "">
	<cfset vssn_fechaPleno = #LsDateFormat(tbCalPleno.ssn_fecha + 14,'dd/mm/yyyy')#>
	<cfset vssn_horaPleno = "09:45">
	<cfset vssn_sedePleno = "en la sala de Juntas del CTIC">
	<cfset vssn_notaPleno = "">
<cfelseif #vTipoComando# EQ "EDITA" OR #vTipoComando# EQ "CONSULTA">
	<cfif #vTipoComando# EQ "EDITA">
		<cfset vActivaCampos = "">
	<cfelseif #vTipoComando# EQ "CONSULTA">
		<cfset vActivaCampos = "disabled">
	</cfif>
	<cfset vssn_id = #tbCalPleno.ssn_id#>
	<cfset vssn_fechaRecDoc = #LsDateFormat(tbCalRecDoc.ssn_fecha,'dd/mm/yyyy')#>
	<cfset vssn_horaRecDoc = #LsTimeFormat(tbCalRecDoc.ssn_fecha,'HH:mm')#>
	<cfset vssn_sedeRecDoc = #tbCalRecDoc.ssn_sede#>
	<cfset vssn_notaRecDoc = #tbCalRecDoc.ssn_nota#>
	<cfset vssn_fechaCaaa = #LsDateFormat(tbCalCaaa.ssn_fecha,'dd/mm/yyyy')#>
	<cfset vssn_horaCaaa = #LsTimeFormat(tbCalCaaa.ssn_fecha,'HH:mm')#>
	<cfset vssn_sedeCaaa = #tbCalCaaa.ssn_sede#>	
	<cfset vssn_notaCaaa = #tbCalCaaa.ssn_nota#>
	<cfset vssn_fechaCorresp = #LsDateFormat(tbCalCorrespondencia.ssn_fecha,'dd/mm/yyyy')#>
	<cfset vssn_sedeCorresp = #tbCalCorrespondencia.ssn_sede#>	
	<cfset vssn_notaCorresp = #tbCalCorrespondencia.ssn_nota#>
	<cfset vssn_fechaPleno = #LsDateFormat(tbCalPleno.ssn_fecha,'dd/mm/yyyy')#>
	<cfset vssn_horaPleno = #LsTimeFormat(tbCalPleno.ssn_fecha,'HH:mm')#>
	<cfset vssn_sedePleno = #tbCalPleno.ssn_sede#>	
	<cfset vssn_notaPleno = #tbCalPleno.ssn_nota#>
</cfif>
<cfif #vssn_id# LT #session.sSesion#>
	<cfset vDisabledEdita = "disabled">
<cfelse>
	<cfset vDisabledEdita = "">
</cfif>
<html>
	<head>
		<title>STCTIC - Asuntos Acad&eacute;mico-Administrativos</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<cfoutput>
			<link href="#vCarpetaCSS#/formularios.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/general.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/fuentes.css" rel="stylesheet" type="text/css">
			<link href="#vHttpWebGlobal#/java/calendario/CalendarControl.css" rel="stylesheet" type="text/css">
			<script src="#vHttpWebGlobal#/java/calendario/CalendarControl.js"></script>
		</cfoutput>
   		<script type="text/javascript">
			// FUNCIÓN PARA DIRECCIONAR LA ACCION DE LOS BOTONES:
			function fSubmitFormulario(vComandoSel)
			{
				var ValidaOK = true; // El valor predeterminado de la validación es VERDADERO;
				if (vComandoSel == 'EDITA')
				{
					document.getElementById('vTipoComando').value = 'EDITA'
					document.forms[0].method = 'get';	
					document.forms[0].action = 'sesion_ordinaria.cfm';
					document.forms[0].submit();
				}
				if (vComandoSel == 'GUARDA')
				{
					if (fValidaCamposSesionOrd) ValidaOK = fValidaCamposSesionOrd();
					if (ValidaOK)
					{
						document.forms[0].action = 'sesion_ordinaria_guarda.cfm';
						document.forms[0].submit();
					}
				}
				if (vComandoSel == 'CANCELA')
				{
					window.history.go(-1);
				}
				if (vComandoSel == 'REGRESA')	
				{
					window.location = 'sesiones_inicio.cfm?vTipoSesionCal=O';
				}
				if (vComandoSel == 'NUEVO')	
				{
					window.location = 'sesion_ordinaria.cfm?vTipoComando=NUEVO';
				}
			}
			// FUNCIÓN PARA VALIDAR LOS CAMPOS DEL FORMULARIO:
			function fValidaCamposSesionOrd()
			{
				var vOk;
				var vMensaje = '';
				fLimpiaValida();
				vMensaje += fValidaFecha('ssn_fechaRecDoc','RECEPCIÓN DE DOCUMENTOS');
				vMensaje += fValidaFecha('ssn_fechaCaaa','COMISIÓN DE ASUNTOS ACADÉMICO-ADMINISTRATIVOS');
				vMensaje += fValidaFecha('ssn_fechaCorresp','ENTREGA DE CORRESPONDENCIA');			
				vMensaje += fValidaFecha('ssn_fechaPleno','SESIÓN DEL PLENO');			
				vMensaje += fValidaCampoLleno('ssn_horaRecDoc','HORA DE RECEPCIÓN DE DOCUMENTOS');
				vMensaje += fValidaCampoLleno('ssn_horaCaaa','HORA DE COMISIÓN DE ASUNTOS ACADÉMICO-ADMINISTRATIVOS');
				vMensaje += fValidaCampoLleno('ssn_horaPleno','HORA DE SESIÓN DEL PLENO');			
				if (vMensaje.length > 0) 
				{
					alert(vMensaje);
					return false;
				}
				else
				{
					return true;
				}
			}
		</script>
	</head>
	<body>
		<!-- Cintillo con nombre del módulo y filtro--> 
		<table class="Cintillo">
			<tr>
				<td>
					<span class="Sans9GrNe">CALENARIO DE SESIONES &gt;&gt; </span>
					<span class="Sans9Gr">
						<cfif #vTipoComando# EQ "NUEVO">NUEVA</cfif> SESI&Oacute;N ORDINARIA
					</span>
				</td>
				<td align="right"><cfinclude template="#vCarpetaINCLUDE#/sesion_vigente.cfm"></td>
			</tr>
		</table>
		<!-- Contenido -->
		<cfform name="Form_sesion" method="post" action="">
		<!-- Campos ocultos -->	
		<cfinput type="hidden" name="vTipoComando" id="vTipoComando" value="#vTipoComando#">
		<cfinput type="hidden" name="vSesionId" id="vSesionId" value="#vssn_id#">
		<!-- Formulario -->
		<table width="100%" border="0">
			<tr>
				<!-- Columna izquierda (comandos) --> 
				<td width="17%" valign="top">
					<!--- INCLUDES DE MENÚS --->
					<cfinclude template="includes_menus.cfm">
				</td>
				<!-- Columna derecha (formulario de captura) -->
				<td width="83%" valign="top">
					<table width="80%" border="0" align="center" cellspacing="0" cellpadding="1">
						<!-- División -->
						<tr><td colspan="4">&nbsp;</td></tr>
						<!-- Recepción de documentos -->
						<tr>
                        	<td colspan="4">
								<span class="Sans12NeNe">
								<cfif #vTipoComando# EQ "NUEVO">
									SESIÓN A CAPTURAR: 
								<cfelseif #vTipoComando# EQ "EDITA" OR #vTipoComando# EQ "CONSULTA">
                                	SESIÓN:
								</cfif>
                                </span>
                                <span class="Sans12Ne">
									<cfoutput>#vssn_id#</cfoutput>
								</span>
                                <br /><br />
							</td>
						</tr>
					</table>
				  <table border="0" align="center" class="cuadrosFormularios">
						<!-- Recepción de documentos -->
						<tr>
						  <td colspan="3" bgcolor="#E6E6E6" height="20px" align="center"><span class="Sans11NeNe">Recepci&oacute;n de documentos</span></td>
						</tr>
						<!-- Fecha -->
						<tr>
							<td width="10%"><span class="Sans9GrNe">Fecha:</span></td>
							<td width="90%"><cfinput name="ssn_fechaRecDoc" id="ssn_fechaRecDoc" value="#LsDateFormat(vssn_fechaRecDoc,'dd/mm/yyyy')#" type="text" disabled='#vActivaCampos#' class="datos" size="11" maxlength="10" onfocus="showCalendarControl(this);"></td>
						</tr>
						<!-- Hora -->
						<tr>
							<td valign="top"><span class="Sans9GrNe">Hora:</span></td>
							<td><cfinput name="ssn_horaRecDoc" id="ssn_horaRecDoc" value="#vssn_horaRecDoc#" disabled='#vActivaCampos#' type="text" class="datos" size="7" maxlength="5"></td>
						</tr>
						<!-- Nota -->
						<tr>
							<td valign="top"><span class="Sans9GrNe">Nota</span></td>
							<td><cftextarea name="ssn_notaRecDoc" id="ssn_notaRecDoc" value="#vssn_notaRecDoc#" disabled='#vActivaCampos#' cols="75" rows="5" class="datos"></cftextarea></td>
						</tr>
					</table>
					<table border="0" align="center" class="cuadrosFormularios">                        
						<!-- Reunión de la Comisión de Asuntos Académico-Administrativos -->
						<tr>
							<td colspan="3" bgcolor="#E6E6E6" height="20px" align="center"><span class="Sans11NeNe">Reuni&oacute;n de la Comisi&oacute;n de Asuntos Acad&eacute;mico-Administrativos</span></td>
						</tr>
						<!-- Fecha -->
						<tr>
							<td width="10%"><span class="Sans9GrNe">Fecha:</span></td>
							<td width="90%"><cfinput name="ssn_fechaCaaa" id="ssn_fechaCaaa" value="#vssn_fechaCaaa#" type="text" disabled='#vActivaCampos#' class="datos" size="11" maxlength="10" onfocus="showCalendarControl(this);"></td>
						</tr>
						<!-- Hora -->
						<tr>
							<td><span class="Sans9GrNe">Hora:</span></td>
							<td><cfinput name="ssn_Horacaaa" id="ssn_horaCaaa" value="#vssn_horaCaaa#" type="text" disabled='#vActivaCampos#' class="datos" size="7" maxlength="5"></td>
						</tr>
						<!-- Lugar -->
						<tr>
							<td valign="top"><span class="Sans9GrNe">Lugar:</span></td>
							<td><cftextarea name="ssn_sedeCaaa" id="ssn_sedeCaaa" value="#vssn_sedeCaaa#" cols="75" rows="3" class="datos" disabled='#vActivaCampos#'></cftextarea></td>
						</tr>
						<!-- Nota -->
						<tr>
							<td valign="top"><span class="Sans9GrNe">Nota:</span></td>
							<td><cftextarea name="ssn_notaCaaa" id="ssn_notaCaaa" value="#vssn_notaCaaa#" cols="75" rows="5" class="datos" disabled='#vActivaCampos#'></cftextarea></td>
						</tr>
					</table>                        
					<table border="0" align="center" class="cuadrosFormularios">
						<!-- Entrega de correspondencia -->
						<tr>
							<td colspan="2" bgcolor="#E6E6E6" height="20px" align="center"><span class="Sans11NeNe">Entrega de correspondencia</span></td>
						</tr>
						<!-- Fecha y hora -->
						<tr>
							<td width="10%"><span class="Sans9GrNe">Fecha:</span></td>
							<td width="90%"><cfinput name="ssn_fechaCorresp" id="ssn_fechaCorresp" value="#vssn_fechaCorresp#" type="text" class="datos" size="11" maxlength="10" disabled='#vActivaCampos#' onfocus="showCalendarControl(this);"></td>
						</tr>
						<!-- Nota -->
						<tr>
							<td valign="top"><span class="Sans9GrNe">Nota:</span></td>
							<td><cftextarea name="ssn_notaCorresp" id="ssn_notaCorresp" value="#vssn_notaCorresp#" cols="75" rows="5" class="datos" disabled='#vActivaCampos#'></cftextarea></td>
						</tr>
				  </table>                        
					<table border="0" align="center" class="cuadrosFormularios">
						<!-- Sesión del pleno del CTIC -->
						<tr>
						  <td colspan="2" bgcolor="#E6E6E6" height="20px" align="center"><span class="Sans11NeNe">Sesi&oacute;n del pleno del CTIC</span></td>
						</tr>
						<!-- Fecha -->
						<tr>
							<td width="10%"><span class="Sans9GrNe">Fecha:</span></td>
							<td width="90%"><cfinput name="ssn_fechaPleno" id="ssn_fechaPleno" value="#vssn_fechaPleno#" type="text" class="datos" size="11" maxlength="10" disabled='#vActivaCampos#' onfocus="showCalendarControl(this);"></td>
						</tr>
						<!-- Hora -->
						<tr>
							<td><span class="Sans9GrNe">Hora:</span></td>
							<td><cfinput name="ssn_horaPleno" id="ssn_horaPleno" value="#vssn_horaPleno#" type="text" class="datos" size="7" maxlength="5" disabled='#vActivaCampos#'></td>
						</tr>

						<!-- Lugar -->
						<tr>
							<td valign="top"><span class="Sans9GrNe">Lugar:</span></td>
							<td colspan="2"><cftextarea name="ssn_sedePleno" id="ssn_sedePleno" value="#vssn_sedePleno#" cols="75" rows="3" class="datos" disabled='#vActivaCampos#'></cftextarea></td>
						</tr>
						<!-- Nota -->
						<tr>
							<td valign="top"><span class="Sans9GrNe">Nota:</span></td>
							<td colspan="2"><cftextarea name="ssn_notaPleno" id="ssn_notaPleno" value="#vssn_notaPleno#" cols="75" rows="5" class="datos" disabled='#vActivaCampos#'></cftextarea></td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		</cfform>
	</body>
</html>
