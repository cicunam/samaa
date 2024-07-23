<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: JOSE ANTONIO ESTEVA --->
<!--- FECHA: 22/01/2010 --->
<!--- EDICION DE SESIONES EXTRAORDINARIAS --->
<cfinclude template="../javascript/sesion_scripts_valida.cfm">
<cfquery name="tbSesiones" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM sesiones WHERE ssn_clave = 2
	<cfif #vTipoComando# EQ "EDITA" OR #vTipoComando# EQ "CONSULTA">AND ssn_id = #vSesionId#</cfif>
	ORDER BY ssn_id DESC
</cfquery
>
<cfif #vTipoComando# EQ "NUEVO">
	<cfset vActivaCampos = "">
	<cfset vssn_id = 0>
	<cfset vssn_fechaExtra = #LsDateFormat(now(),"dd/mm/yyyy")#>
	<cfset vssn_horaExtra = "09:45">
	<cfset vssn_sedeExtra = "en la sala de Juntas del CTIC">	
	<cfset vssn_notaExtra = "">
<cfelseif #vTipoComando# EQ "EDITA" OR #vTipoComando# EQ "CONSULTA">
	<cfif #vTipoComando# EQ "EDITA">
		<cfset vActivaCampos = "">
	<cfelseif #vTipoComando# EQ "CONSULTA">
		<cfset vActivaCampos = "disabled">
	</cfif>
	<cfset vssn_id = #tbSesiones.ssn_id#>
	<cfset vssn_fechaExtra = #LsDateFormat(tbSesiones.ssn_fecha,'dd/mm/yyyy')#>
	<cfset vssn_horaExtra = #LsTimeFormat(tbSesiones.ssn_fecha,'HH:mm')#>
	<cfset vssn_sedeExtra = #tbSesiones.ssn_sede#>	
	<cfset vssn_notaExtra = #tbSesiones.ssn_nota#>
</cfif>
<cfif #tbSesiones.ssn_fecha# LT #now()#>
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
			// FUNCIÓN PARA DIRECCIONAR LA ACCION DE LOS BOTONES
			function fSubmitFormulario(vComandoSel)
			{
				var ValidaOK = true; // El valor predeterminado de la validación es VERDADERO;
				if (vComandoSel == 'EDITA')
				{
					document.getElementById('vTipoComando').value = 'EDITA'
					document.forms[0].method = 'get';	
					document.forms[0].action = 'sesion_extraordinaria.cfm';
					document.forms[0].submit();
				}
				if (vComandoSel == 'GUARDA')
				{
					if (fValidaCamposSesionExtra) ValidaOK = fValidaCamposSesionExtra();
					if (ValidaOK)
					{
						document.forms[0].action = 'sesion_extraordinaria_guarda.cfm';
						document.forms[0].submit();
					}
				}
				if (vComandoSel == 'CANCELA')
				{
					window.history.go(-1);
				}
				if (vComandoSel == 'REGRESA')	
				{
					window.location = 'sesiones_inicio.cfm?vTipoSesionCal=E';
				}
				if (vComandoSel == 'NUEVO')	
				{
					window.location = 'sesion_extraordinaria.cfm?vTipoComando=NUEVO';
				}
			}
			// FUNCIÓN PARA VALIDAR LOS CAMPOS DEL FORMULARIO	
			function fValidaCamposSesionExtra()
			{
				var vOk;
				var vMensaje = '';
				fLimpiaValida();
				vMensaje += fValidaFecha('ssn_fechaExtra','SESIÓN EXTRAORDINARIA');
				vMensaje += fValidaCampoLleno('ssn_HoraExtra','HORA SESIÓN EXTRAORDINARIA');
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
						<cfif #vTipoComando# EQ "NUEVO">NUEVA</cfif> SESI&Oacute;N EXTRAORDINARIA
					</span>
				</td>
				<td align="right"><cfinclude template="#vCarpetaINCLUDE#/sesion_vigente.cfm"></td>
			</tr>
		</table>
		<!-- Contenido -->
		<cfform name="Form_sesion" method="post" action="">
		<!-- Campos ocultos -->
		<cfinput type="hidden" name="vSesionId" id="vSesionId" value="#vssn_id#">
		<cfinput type="hidden" name="vTipoComando" id="vTipoComando" value="#vTipoComando#">
		<!-- Formulario -->
		<table width="100%" border="0">
			<tr>
				<td width="17%" valign="top">
					<!--- INCLUDES DE MENÚS --->
					<cfinclude template="includes_menus.cfm">
				</td>
				<!-- Columna derecha (formulario de captura) -->
				<td width="83%" valign="top" align="center" style="padding-top:20px;">
					<table border="0" class="cuadrosFormularios">	
						<!-- Reunión del pleno para sesión extraordinaria -->
						<tr>
							<td colspan="2" bgcolor="#E6E6E6" height="20px" align="center"><span class="Sans11NeNe">Reuni&oacute;n del pleno para sesi&oacute;n extraordinaria</span></td>
						</tr>
						<!-- Fecha y hora -->
						<tr>
							<td width="10%"><span class="Sans9GrNe">Fecha:</span></td>
							<td width="90%"><cfinput name="ssn_fechaExtra" id="ssn_fechaExtra" value="#vssn_fechaExtra#" type="text" class="datos" size="10" maxlength="10" disabled='#vActivaCampos#' onfocus="showCalendarControl(this);"></td>
						</tr>
						<tr>
							<td><span class="Sans9GrNe">Hora:</span></td>
							<td><cfinput name="ssn_HoraExtra" id="ssn_HoraExtra" value="#vssn_horaExtra#" type="text" class="datos" size="5" maxlength="5" disabled='#vActivaCampos#'></td>
						</tr>
						<!-- Lugar -->
						<tr>
							<td valign="top"><span class="Sans9GrNe">Lugar:</span></td>
							<td><cftextarea name="ssn_sedeExtra" id="ssn_sedeExtra" value="#vssn_sedeExtra#" cols="75" rows="3" class="datos" disabled='#vActivaCampos#'></cftextarea></td>
						</tr>
						<!-- Nota -->
						<tr>
							<td valign="top"><span class="Sans9GrNe">Nota:</span></td>
							<td><cftextarea name="ssn_notaExtra" id="ssn_notaExtra" value="#vssn_notaExtra#" cols="75" rows="5" class="datos" disabled='#vActivaCampos#'></cftextarea></td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		</cfform>
	</body>
</html>
