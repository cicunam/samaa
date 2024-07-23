<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 21/04/2010 --->
<!--- FECHA ULTIMA MOD.: 14/06/2016 --->
<!--- ORDEN DEL DÍA --->

<!--- Obtener datos de la sesión --->
<cfparam name="vTipoComando" default="N">
<cfparam name="vSsnId" default=0>
<cfparam name="vPunto" default=0>

<cfset vArchivoPdf = ''>
<cfset vArchivoPdf2 = ''>

<!--- Obtener la sesion a trabajar --->
<cfquery name="tbSesion" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM sesiones 
    WHERE ssn_id = #vSsnId#
</cfquery>

<!--- Obtener la lista de punto resultante --->
<cfquery name="tbSesionOrden" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM sesiones_orden
    WHERE ssn_id = #vSsnId#
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

<cfif #vTipoComando# EQ 'E' AND (#vAcdId# NEQ '' OR #vAcdId# GT 0)>
	<!--- Obtener la lista de punto resultante --->
	<cfquery name="tbAcademicos" datasource="#vOrigenDatosSAMAA#">
		SELECT 
		ISNULL(dbo.SINACENTOS(acd_apepat),'') + 
		CASE WHEN acd_apepat IS NULL THEN '' ELSE ' ' END + 
		ISNULL(dbo.SINACENTOS(acd_apemat),'') + 
		CASE WHEN acd_apemat IS NULL THEN '' ELSE ' ' END + 
		ISNULL(dbo.SINACENTOS(acd_nombres),'') AS vNombre
        FROM academicos 
        WHERE acd_id = #vAcdId#
	</cfquery>
	
	<cfset vAcdNombre = #tbAcademicos.vNombre#>    
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

		<script src="../comun/java_script/mascara_entrada.js"></script>
		<script src="../comun/java_script/valida_campo_lleno.js"></script>
		<script src="../comun/java_script/valida_formato_fecha.js"></script>
		<script src="../comun/java_script/limpia_validacion.js"></script>

		<script language="JavaScript" type="text/JavaScript">
			// Función para direccionar la acción de los botones:
			function vHabDesControles()
			{
				//alert(document.getElementById('punto_clave').value);
				if (document.getElementById('punto_clave').value == 'PNCA' || document.getElementById('punto_clave').value == 'PNIE')
				{
					//alert('PROPUESTAS')
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
				//fLimpiaValida();
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
					$(function() {
						$.ajax({
							url: "orden_dia/orden_dia_Formulario_punto_guarda.cfm",
							type:'POST',
							async: 'false',
							data: new FormData($('#formPuntoOrdenDia')[0]),
							processData: false,
							contentType: false,
							success: function(data) {
								//location.reload();
								alert(data);
								//alert('EL ARCHIVO SE CARGO CORRECTAMENTE');
							},
							error: function(data) {
								alert('ERROR AL AGREGAR PUNTO');
								location.reload();
							},
						});
					});
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
				xmlHttp.open("POST", "../comun/seleccion_academico.cfm", true);
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
		<!--- SCRIPT PARA CARGAR LOS CAMPOS NECESARIOS SEGÚN EL TIPO DE PUNTO --->
	    <script>
			window.onload = vHabDesControles();
		</script>

        <!-- Formulario de captura de un punto de la orden del d&iacute;a -->
        <cfform id="formPuntoOrdenDia" enctype="multipart/form-data">
            <!-- Campos ocultos -->
			<cfoutput>
                <input name="vAccion" id="vAccion" type="hidden" value="#vTipoComando#">
                <input name="vSsnId" id="vSsnId" type="hidden" value="#vSsnId#" />
                <input name="vPunto" id="vPunto" type="hidden" value="#vPuntoNum#">
			</cfoutput>
            
	        <div class="modal-header">
				<h4 class="modal-title">
					<cfif #vTipoComando# EQ 'N'>NUEVO </cfif>
                    <cfif #vTipoComando# EQ 'E'>EDITAR </cfif>
                    PUNTO DEL ORDEN DEL D&Iacute;A
				</h4>
			</div>
            <div class="modal-body">
				<div class="form-group">
					<div class="row">
                        <label class="control-label col-sm-2" for="lblPunto">Punto:</label>
                        <div class="col-sm-10 text-left">
                            <cfoutput>
                                <input name="punto_num_temp" id="punto_num_temp" type="text" size="2" maxlength="2" value="#vPuntoNum#" disabled="disabled" class="form-control" style="width:10%;" />
                                <input name="punto_num" id="punto_num" type="hidden" size="2" maxlength="2" value="#vPuntoNum#">
                            </cfoutput>
                        </div>
					</div>
				</div>
	                <cfif #Session.sTipoSesionCel# EQ "O">
						<div class="form-group">                    
                            <div class="row">
                                <label class="control-label col-sm-2" for="lblPunto">Tipo:</label>
                                <div class="col-sm-10 text-left">
                                    <select name="punto_clave" id="punto_clave" onChange="vHabDesControles();" class="form-control">
                                        <option value="">SELECCIONE</option>
                                            <cfif #vPuntoNum# EQ 1>
                                                <option value="ACTA" <cfif #vPuntoClave# EQ 'ACTA'>selected</cfif>>Aprobaci&oacute;n del acta <cfoutput>#vSsnId-1#</cfoutput></option>
                                                <option value="ACTAS" <cfif #vPuntoClave# EQ 'ACTAS'>selected</cfif>>Aprobaci&oacute;n de las actas <cfoutput>#vSsnId-1#</cfoutput> y <cfoutput>#vSsnId-2#</cfoutput></option>
                                                <option value="ACTAE" <cfif #vPuntoClave# EQ 'ACTAE'>selected</cfif>>Aprobaci&oacute;n de las actas <cfoutput>#vSsnId-1#</cfoutput> y de la sesi&oacute;n extraordinaria</option>
                                            </cfif>
                                            <cfif #vPuntoNum# EQ 2>
                                                <option value="RECOMCAAA" <cfif #vPuntoClave# EQ 'RECOMCAAA'>selected</cfif>>Informe de la Comisi&oacute;n de Asuntos Acad&eacute;mico-Administrativos</option>
                                                <option value="RECOMCAAAS" <cfif #vPuntoClave# EQ 'RECOMCAAAS'>selected</cfif>>Informe de la Comisi&oacute;n de Asuntos Acad&eacute;mico-Administrativos, correspondiente a los listados de recomendaciones <cfoutput>#vSsnId-1#</cfoutput> y <cfoutput>#vSsnId#</cfoutput></option>
                                            </cfif>
                                            <cfif #vPuntoNum# GTE 3>
                                                <option value="PNCA" <cfif #vPuntoClave# EQ 'PNCA'>selected</cfif>>Propuesta para nombramiento de Jefe del Departamento, Jefe de Unidad, etc&hellip;</option>
                                                <option value="PNIE" <cfif #vPuntoClave# EQ 'PNIE'>selected</cfif>>Propuesta para nombramiento de Investigador Em&eacute;rito</option>
                                                <option value="ICRI" <cfif #vPuntoClave# EQ 'ICRI'>selected</cfif>>Informe de la Comisi&oacute;n de Reglamentos Internos</option>
                                            </cfif>
                                        <option value="OTRO" <cfif #vPuntoClave# EQ 'OTRO'>selected</cfif>>Otro</option>
                                    </select>
                                </div>
                            </div>
						</div>
	                <cfelseif #Session.sTipoSesionCel# EQ "E">
                        <div class="row">
                            <div class="col-sm-12 text-left">
								<input type="hidden" name="punto_clave" id="punto_clave" value="OTRO">                            
                            </div>
                        </div>
					</cfif>
				<div id="trSelAcad" class="form-group" style="display:none;">
					<div class="row">
                        <label class="control-label col-sm-2" for="lblAcademico">Acad&eacute;mico</label>
                        <div class="col-sm-10 text-left">
							<cfoutput>                        
                            	<input name="vNomAcad" id="vNomAcad" type="text" class="form-control" maxlength="100" value="#vAcdNombre#" style="width:400px" autocomplete="off"  onfocus="fBorrarParametros();" onKeyUp="fListaSeleccionAcademico('NAME');">
	                            <input name="vSelAcad" id="vSelAcad" type="hidden" value="#vAcdId#" />
							</cfoutput>
                            <div id="lstAcad_dynamic" style="position:absolute; z-index:1;"><!---  display:block; --->
                                <!-- AJAX: Lista desplegable de acad&eacute;micos -->
                            </div>
						</div>
					</div>
				</div>
				<div class="form-group">                
					<div class="row">
                        <label class="control-label col-sm-2" for="lblPunto">Descripc&oacute;n:</label>
                        <div class="col-sm-10 text-left">
							<textarea name="punto_texto" id="punto_texto" rows="3" class="form-control"><cfoutput>#vPuntoTexto#</cfoutput></textarea>
						</div>
					</div>
				</div>
				<div id="trArchivo1" class="form-group">
					<div class="row">
                        <label class="control-label col-sm-2" for="lblPunto">Archivo 1:</label>
                        <div class="col-sm-8 text-left">
							<input id="punto_pdf" name="punto_pdf" type="file" class="form-control"/>
						</div>
						<div class="col-sm-2 text-left">
							<cfif FileExists(#vArchivoPdf#)>
								<cfoutput>
									<a href="#vWebPdf#" target="_blank"><img src="#vCarpetaIMG#/pdf.png" title="#tbSesionOrden.punto_pdf#" height="30" style="border:none;cursor:pointer;"></a>
								</cfoutput>
							</cfif>
						</div>
					</div>
				</div>
				<div id="trArchivo2" class="form-group">
					<div id="frmArchivoPDF2" class="row">
                        <label class="control-label col-sm-2" for="lblPunto">Archivo 2:</label>
                        <div class="col-sm-8 text-left">
							<input id="punto_pdf_2" name="punto_pdf_2" type="file" class="form-control"/>
						</div>
						<div class="col-sm-2 text-left">
							<cfif FileExists(#vArchivoPdf2#)>
								<cfoutput>
									<a href="#vWebPdf2#" target="_blank"><img src="#vCarpetaIMG#/pdf.png" height="30" onClick="" style="border:none;cursor:pointer;" title="#tbSesionOrden.punto_pdf_2#"></a>
								</cfoutput>
							</cfif>
						</div>
					</div>
				</div>
            </div>
            <div class="modal-footer">
                <button id="cmdGuardaPunto" type="button" class="btn btn-success" onClick="fValidaCampos();">Guardar</button>
                <button id="CierraModalAbajo" type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
            </div>
		</cfform>
