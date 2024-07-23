<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 05/09/2017 --->
<!--- FECHA ÚLTIMA MOD.: 03/05/2023 --->
<!--- FORMULARIO PARA COMISIONES DE BECAS POSDOCTORALES --->

<cfinclude template="../javascript/sesion_scripts_valida.cfm">

<cfquery name="tbSesiones" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM sesiones WHERE ssn_clave = 7
	<cfif #vTipoComando# EQ "EDITA" OR #vTipoComando# EQ "CONSULTA">
		AND ssn_id = #vSesionId#
	</cfif>
	ORDER BY ssn_id DESC
</cfquery>

<cfquery name="ctSesiones" datasource="#vOrigenDatosSAMAA#">
	SELECT TOP 5 ssn_id FROM sesiones
	WHERE ssn_clave = 1
	AND ssn_id >= #Session.sSesion#
	ORDER BY ssn_id
</cfquery>

<!--- BASE DE DATOS: BECAS-POSDOC; TABLA: convocatorias_periodos --->	
<cfquery name="ctPosdocConvPer" datasource="#vOrigenDatosPOSDOC#">
	SELECT periodo_convocatoria, periodo_conv_id, ssn_id 
	FROM convocatorias_periodos
	<cfif #vTipoComando# EQ "NUEVO">	
		WHERE ssn_id IS NULL
	</cfif>
    ORDER BY periodo_convocatoria <cfif #vTipoComando# EQ "NUEVO">ASC<cfelse>DESC</cfif>
</cfquery>

<cfif #vTipoComando# EQ "NUEVO">
	<cfset vActivaCampos = "">
	<cfset vid = ''>        
	<cfset vssn_id = ''>
	<cfset vssn_fechaExtra = #LsDateFormat(now(),"dd/mm/yyyy")#>
	<cfset vssn_horaExtra = "09:45">
	<cfset vssn_sedeExtra = "en la sala de ex-coordinadores del CTIC">	
	<cfset vssn_notaExtra = "">
	<cfset vperiodo_conv_id = "">
<cfelseif #vTipoComando# EQ "EDITA" OR #vTipoComando# EQ "CONSULTA">
	<cfif #vTipoComando# EQ "EDITA">
		<cfset vActivaCampos = "">
	<cfelseif #vTipoComando# EQ "CONSULTA">
		<cfset vActivaCampos = "disabled">
	</cfif>
	<cfset vid = #tbSesiones.id#>
	<cfset vssn_id = #tbSesiones.ssn_id#>
	<cfset vssn_fechaExtra = #LsDateFormat(tbSesiones.ssn_fecha,'dd/mm/yyyy')#>
	<cfset vssn_horaExtra = #LsTimeFormat(tbSesiones.ssn_fecha,'HH:mm')#>
	<cfset vssn_sedeExtra = #tbSesiones.ssn_sede#>	
	<cfset vssn_notaExtra = #tbSesiones.ssn_nota#>
	<cfquery name="ctPeriodoConv" datasource="#vOrigenDatosPOSDOC#">
		SELECT periodo_conv_id 
		FROM convocatorias_periodos
		WHERE ssn_id = #tbSesiones.ssn_id#
	</cfquery>
	<cfset vperiodo_conv_id = #ctPeriodoConv.periodo_conv_id#>
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
					document.forms[0].method = 'post';	
					document.forms[0].action = 'comision_becas.cfm';
					document.forms[0].submit();
				}
				if (vComandoSel == 'GUARDA')
				{
					if (fValidaCamposSesionExtra) ValidaOK = fValidaCamposSesionExtra();
					if (ValidaOK)
					{
						document.forms[0].action = 'comision_becas_guarda.cfm';
						document.forms[0].submit();
					}
				}
				if (vComandoSel == 'CANCELA')
				{
					window.history.go(-1);
				}
				if (vComandoSel == 'REGRESA')	
				{
					window.location = 'sesiones_inicio.cfm?vTipoSesionCal=P';
				}
				if (vComandoSel == 'NUEVO')	
				{
					window.location = 'comision_becas.cfm?vTipoComando=NUEVO';
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
            <cfinput type="hidden" name="vIdSesion" id="vIdSesion" value="#vssn_id#">
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
                                <td colspan="2" bgcolor="#E6E6E6" height="20px" align="center"><span class="Sans11NeNe">Reuni&oacute;n de la Comisión de Becas Posdoctorales</span></td>
                            </tr>
                            <!-- Fecha y hora -->
                            <tr>
                                <td width="20%"><span class="Sans9GrNe">Sesión:</span></td>
                                <td width="80%">
		                            <cfif #vTipoComando# EQ "EDITA" OR #vTipoComando# EQ "CONSULTA">
										<cfinput name="ssn_id" id="ssn_id" value="#vssn_id#" type="text" class="datos" size="4" maxlength="4" disabled='#vActivaCampos#'>
										<cfinput name="vSesionId" id="vSesionId" value="#vssn_id#" type="hidden">
									<cfelse>
                                        <cfselect name="ssn_id" id="ssn_id" query="ctSesiones" queryPosition="below" display="ssn_id" label="ssn_id" class="datos">
                                        </cfselect>
									</cfif>
								<cfinput name="vId" id="vId" value="#vid#" type="hidden">
								</td>
                            </tr>
                            <tr>
                                <td><span class="Sans9GrNe">Fecha:</span></td>
                                <td><cfinput name="ssn_fechaExtra" id="ssn_fechaExtra" value="#vssn_fechaExtra#" type="text" class="datos" size="10" maxlength="10" disabled='#vActivaCampos#' onfocus="showCalendarControl(this);"></td>
                            </tr>
							<tr>
                                <td><span class="Sans9GrNe">Hora:</span></td>
                                <td><cfinput name="ssn_HoraExtra" id="ssn_HoraExtra" value="#vssn_horaExtra#" type="text" class="datos" size="5" maxlength="5" disabled='#vActivaCampos#'></td>

							</tr>
							<!--- Periodos de las convocatorias que no han sido asignados a una sesión del pleno del CTIC --->
							<tr>
                                <td><span class="Sans9GrNe">Periodo de la convocatoria:</span></td>
                                <td>
									<cfselect name="periodo_conv_id" id="periodo_conv_id" class="datos" query="ctPosdocConvPer" queryPosition="below" display="periodo_convocatoria" value="periodo_conv_id" selected="#vperiodo_conv_id#" disabled='#vActivaCampos#'>
										<option value="">SELECCIONE</option>
                                    </cfselect>
								</td>
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
