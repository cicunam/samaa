<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: JOSE ANTONIO ESTEVA --->
<!--- FECHA: 22/01/2010 --->
<!--- EDICION DE SESIONES ORDINARIAS --->


<cfset vTitulo = "">
	
<cfquery name="tbSesiones" datasource="#vOrigenDatosSAMAA#">
	SELECT 
	<cfif #vTipoComando# EQ "N">TOP 1</cfif>	
	*
	FROM sesiones 
	WHERE 1 = 1
	<cfif #vTipoComando# EQ "N" AND #vpSesionTipo# EQ 'O'>
		AND ssn_clave = 1
	<cfelseif #vTipoComando# EQ "N" AND #vpSesionTipo# EQ 'P'>
		AND ssn_id >= #Session.sSesion#
	<cfelseif #vTipoComando# EQ "E" OR #vTipoComando# EQ "C">
		AND ssn_id = #vpSsnId#
	</cfif>
	ORDER BY ssn_id DESC
</cfquery>	
	

<cfif #vTipoComando# EQ "N">
	<cfset vTitulo = "NUEVA ">
	<cfif #vpSesionTipo# EQ 'O'>
		<cfset vssn_id = #tbSesiones.ssn_id# + 1>
	<cfelse>
		<cfset vssn_id = ''>
	</cfif>
<cfelse>
	<cfset vssn_id = #tbSesiones.ssn_id#>	
</cfif>
	
<cfif #vpSesionTipo# EQ 'O' OR #vpSesionTipo# EQ 'E'>
	<cfset vTitulo = "#vTitulo# SESI&Oacute;N ">
	<cfif #vpSesionTipo# EQ 'O'>
		<cfset vTitulo = "#vTitulo#ORDINARIA">
	<cfelseif #vpSesionTipo# EQ 'E'>
		<cfset vTitulo = "#vTitulo#EXTRAORDIANRIA">
	</cfif>
<cfelse>
	<cfset vTitulo = "#vTitulo#COMISIÓN DE BECAS POSDOCTORALES">
</cfif>
		<script src="../comun/java_script/mascara_entrada.js"></script>
		<script src="../comun/java_script/valida_campo_lleno.js"></script>
		<script src="../comun/java_script/valida_formato_fecha.js"></script>
		<script src="../comun/java_script/limpia_validacion.js"></script>

<!---
		<cfinclude template="../../comun/java_script/valida_formato_fecha.js">
		<link href="#vHttpWebGlobal#/java/calendario/CalendarControl.css" rel="stylesheet" type="text/css">
		<script src="#vHttpWebGlobal#/java/calendario/CalendarControl.js"></script>
--->        
   		<script type="text/javascript">
			// FUNCIÓN PARA DIRECCIONAR LA ACCION DE LOS BOTONES:
			function fSubmitFormulario(vComandoSel)
			{
				var ValidaOK = true; // El valor predeterminado de la validación es VERDADERO;
				if (vComandoSel == 'EDITA')
				{
					for (c=0; c<document.forms[0].elements.length; c++)
					{
						if (document.forms[0].elements[c].type == 'text') alert('ENTRA');//document.forms[0].elements[c].disabled = '';
					}
				}
				if (vComandoSel == 'GUARDA')
				{
					if (fValidaCamposSesionOrd) ValidaOK = fValidaCamposSesionOrd();
					if (ValidaOK)
					{
                        $.ajax({
                            //async: false,
                            url: "calendario_sesiones/sesion_ordinaria_guarda.cfm",
                            type:'POST',
                            data: new FormData($('#frmSesion')[0]),
                            processData: false,
                            contentType: false,
                            success: function(data) {
								alert(data);
								//location.reload();	
															
                            },
                            error: function(data) {
                                alert('ERROR AL AGREGAR EL COMENTARIO');
            //					location.reload();
                            },
                        });						
					}
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
			function fComparaFechas()
			{
				
			}
		</script>

        <div class="modal-header">
			<button id="CierraModalArriba" type="button" class="close" data-dismiss="modal">&times;</button>
            <h4 class="modal-title">
				<cfoutput>#vTitulo# #vssn_id#</cfoutput>
			</h4>
        </div>
        <div class="modal-body">
			<cfform name="frmSesion" method="post" action="" class="form-horizontal">
				<cfinput type="hidden" name="vTipoComando" id="vTipoComando" value="#vTipoComando#">
				<cfinput type="hidden" name="vSsnId" id="vSsnId" value="#vssn_id#">
				<cfif #vpSesionTipo# EQ 'O'>
					<!-- Recepción de documentos -->
					<cfset vValor = 5>
					<h5><strong>Recepci&oacute;n de documentos</strong></h5>
					<cfinclude template="include_formulario.cfm"></cfinclude>

					<!-- Reunión de la Comisión de Asuntos Académico-Administrativos -->
					<cfset vValor = 4>
					<h5><strong>Reuni&oacute;n de la Comisi&oacute;n de Asuntos Acad&eacute;mico-Administrativos</strong></h5>
					<cfinclude template="include_formulario.cfm"></cfinclude>

					<!-- Entrega de correspondencia -->
					<cfset vValor = 3>
					<h5><strong>Entrega de correspondencia</strong></h5>
					<cfinclude template="include_formulario.cfm"></cfinclude>

					<!-- Sesión del pleno del CTIC -->
					<cfset vValor = 1>
					<h5><strong>Sesi&oacute;n del pleno del CTIC</strong></h5>
					<cfinclude template="include_formulario.cfm"></cfinclude>
				<cfelseif #vpSesionTipo# EQ 'E'>
					<!-- Sesión extroordianria del pleno del CTIC -->
					<cfset vValor = 2>
					<h5><strong></strong></h5>
					<cfinclude template="include_formulario.cfm"></cfinclude>
				<cfelseif #vpSesionTipo# EQ 'P'>
					<!-- Comisión de becas posdoctorales UNAM -->
					<cfset vValor = 7>
					<h5><strong></strong></h5>
					<cfinclude template="include_formulario.cfm"></cfinclude>
				</cfif>					
			</cfform>
		</div>
		<div class="modal-footer">
			<cfif #vssn_id# GTE #Session.sSesion# AND #Session.sTipoSistema# IS 'stctic' AND #vTipoComando# EQ "C">
				<button id="cmdEdita" type="button" class="btn btn-primary" onClick="fSubmitFormulario('EDITA')">Editar</button>
            </cfif>
			<cfif #vssn_id# GTE #Session.sSesion# AND #Session.sTipoSistema# IS 'stctic' AND #vTipoComando# EQ "N">
				<button id="cdmGuarda" type="button" class="btn btn-success" onClick="fSubmitFormulario('GUARDA')">Guardar</button>
			</cfif>
			<button id="CierraModalAbajo" type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
		</div>