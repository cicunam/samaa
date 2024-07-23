<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 21/01/2010 --->
<!--- FECHA ÚLTIMA MOD: 17/03/2017 --->
<!--- ORDEN DEL DÍA --->
<!--- Obtener datos de la sesión --->

<cfquery name="tbSesion" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM sesiones 
	WHERE ssn_id = #vSsnId# 
	AND 
	<cfif #Session.sTipoSesionCel# EQ "O">
		ssn_clave = 1
	<cfelseif #Session.sTipoSesionCel# EQ "E">
		ssn_clave = 2 
	</cfif> 
</cfquery>

<!--- Obtener la lista de punto resultante --->
<cfquery name="tbSesionOrden" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM sesiones_orden 
    WHERE ssn_id = #vSsnId# 
    ORDER BY punto_num
</cfquery>

<cfif #Session.sTipoSesionCel# EQ "O">
	<cfset vSesionAnt = #tbSesion.ssn_id# - 1>
	<cfset vSesionPost = #tbSesion.ssn_id# + 1>
<cfelseif #Session.sTipoSesionCel# EQ "E">
	<cfset vSesionAnt = 0>
	<cfset vSesionPost = 0>
</cfif> 

<cfset vWebArchivoOd = ''>
<cfset vCarpetaArchivoOd = ''>

<cfset vWebArchivoOd = #vWebSesionHistoria# & 'ORDENDIA_' & #tbSesion.ssn_id# & '.pdf'>
<cfset vCarpetaArchivoOd = #vCarpetaSesionHistoria# & 'ORDENDIA_' & #tbSesion.ssn_id# & '.pdf'>
    
<cfif FileExists(#vCarpetaArchivoOd#)>
	<cfset vTextoArchivo = "Reenviar archivo">
<cfelse>
	<cfset vTextoArchivo = "Enviar archivo">
</cfif>

		<!--- JAVA SCRIPT
		<cfinclude template="../javascript/sesion_scripts_valida.cfm">
		  --->

		<script language="JavaScript" type="text/JavaScript">

			// Función para direccionar la acción de los botones:
			function fEnviarComando() // Argumentos variables: vComando, vPunto, punto_numero, punto_texto, punto_pdf
			{
				var ValidaOK = true; // El valor predeterminado de la validación es VERDADERO;
				
				vComando = arguments[0];

				if (vComando == 'SUBE')
				{
					// Ejecutar comando:
					document.getElementById('vAccion').value = "S";
					document.getElementById('vPunto').value = arguments[1];
					fAcualizaPunto();
				}
				else if (vComando == 'BAJA')
				{
					// Ejecutar comando:
					document.getElementById('vAccion').value = "B";
					document.getElementById('vPunto').value = arguments[1];
					fAcualizaPunto();
				}
				else if (vComando == 'ELIMINA')
				{
					// Ejecutar comando:
					if (confirm('Si elimina este registro y existe algún archivo que esté relacionado con el mismo, éste será borrado del servidor. ¿Desea continuar?'))
					{
						document.getElementById('vAccion').value = "D";
						document.getElementById('vPunto').value = arguments[1];
						document.getElementById('vPuntoClave').value = arguments[2];
						fAcualizaPunto();
					}
				}
			}

			// FUNCIÓN PARA LLAMAR LOS PUNTOS DEL ORDEN DEL DÍA			
			function fAcualizaPunto()
			{
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Función de atención a las petición HTTP:
				xmlHttp.onreadystatechange = function(){
					if (xmlHttp.readyState == 4) {
						document.getElementById('ActualizaPunto_dynamic').innerHTML = xmlHttp.responseText;
						window.location.reload();
					}
				}
				// Generar una petición HTTP:
				xmlHttp.open("POST", "orden_dia/orden_dia_formulario_punto_guarda.cfm", true);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "vSsnId=" + encodeURIComponent(document.getElementById('ssn_id').value);
				parametros += "&vAccion=" + encodeURIComponent(document.getElementById('vAccion').value);
				parametros += "&vPunto=" + encodeURIComponent(document.getElementById('vPunto').value);
				parametros += "&punto_clave=" + encodeURIComponent(document.getElementById('vPuntoClave').value);
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);
			}
		</script>
		<div class="container-fluid text-center" style="margin:5px;">    
			<div class="row content">
				<div class="col-sm-2 sidenav text-left visible-md visible-lg">
					<div class="panel-group">
                        <div class="panel panel-primary">
                            <div class="panel-heading">
                                <label>MEN&Uacute;</label>
                            </div>
                            <div class="panel-body">
                                <button type="button" class="btn btn-default btn-block"><span class="glyphicon glyphicon-print"></span> Imprimir calendario</button>
                            </div>                                    
                            <div class="panel-body">
                                <button type="button" class="btn btn-warning btn-block" onclick="window.location='?vMenuActivoM8=2&vSsnId=0'"><span class="glyphicon glyphicon-repeat"></span> Regresar</button>
                            </div>
                            <div class="panel-body">
                                <label>Ir al orden del día de la sesión:</label><br>
                                <cfoutput>
                                <button type="button" class="btn btn-basic btn-block btn-sm" onclick="window.location='?vMenuActivoM8=2&vSsnId=#vSesionAnt#&vTipoComando=C'"><span class="glyphicon glyphicon-arrow-left"></span> <strong>#vSesionAnt#</strong></button>
                                <cfif #vSesionPost# LTE #Session.sSesion#> 
                                    <button type="button" class="btn btn-basic btn-block btn-sm" onclick="window.location='?vMenuActivoM8=2&vSsnId=#vSesionPost#&vTipoComando=C'"><span class="glyphicon glyphicon-arrow-right"></span> <strong>#vSesionPost#</strong></button>
                                <cfelse>
                                    <p style="height:25px;"></p>
                                </cfif>
                                </cfoutput>
                            </div>
                        </div>
                        <div class="panel panel-warning">
                            <div class="panel-heading">
                                <label>ARCHIVOS ADJUNTOS</label>
                            </div>
                            <div class="panel-body text-center">
								<!--- Include para consutar o anexar documento(s) en PDF (ORDEN DEL DÍA) --->
                                <cfmodule template="#vCarpetaRaizLogica#/includes/archivopdf_vista_carga_bs.cfm" ModuloConsulta="ORDENDIA" AcdId="" NumRegistro="" SsnId="#vSsnId#" DepClave="" SolStatus="" SolDevolucionSatus="" vCarpetaINCLUDE= "#vCarpetaINCLUDE#">
                            </div>
                            <div class="panel-body text-center">
								<!--- Include para consutar o anexar documento(s) en PDF (ESTIMULOS DGAPA) --->
                                <cfmodule template="#vCarpetaRaizLogica#/includes/archivopdf_vista_carga_bs.cfm" ModuloConsulta="ESTDGAPA" AcdId="" NumRegistro="" SsnId="#vSsnId#" DepClave="" SolStatus="" SolDevolucionSatus="" vCarpetaINCLUDE= "#vCarpetaINCLUDE#">
                            </div>
                        </div>
                    </div>
				</div>
				<div class="col-sm-10 text-left">
					<cfoutput>
	                    <br>
                        <!-- Número de sesión -->
						<div class="row">
                            <div class="col-sm-12 text-center">
                                <h4>
									<strong>SESIÓN <cfif #Session.sTipoSesionCel# EQ "O">ORDINARIA #tbSesion.SSN_ID#<cfelseif #Session.sTipoSesionCel# EQ "E">EXTRAORDINARIA</cfif></strong>
								</h4>
                            </div>
						</div>
	                    <br>
                        <!-- Introducción -->
						<div class="row">
                            <div class="col-sm-1 col-md-1 text-center"></div>
                            <div class="col-sm-10 col-md-10 text-justify">
                                <h5>
                                    Agradecer&eacute; a ustedes su asistencia a la sesi&oacute;n ordinaria del Consejo T&eacute;cnico de la Investigaci&oacute;n Cient&iacute;fica, que se llevar&aacute; a cabo el <strong><strong>#LsDateFormat(tbSesion.ssn_fecha,'dddd')#</strong> #LsDateFormat(tbSesion.ssn_fecha,'dd')# de #LsDateFormat(tbSesion.ssn_fecha,'mmmm')#</strong>, a partir de las <strong>#LsTimeFormat(tbSesion.ssn_fecha,'hh:mm')# horas</strong>, <strong>#tbSesion.ssn_sede#</strong>, de acuerdo con el siguiente:
                                </h5>	                                    
                            </div>
                            <div class="col-sm-1 col-md-1 text-center"></div>
						</div>
                        <br><br>
						<div class="row">
                            <div class="col-sm-1 col-md-1 text-center"></div>
                            <div class="col-sm-10 col-md-10 text-center">
								<ol class="breadcrumb" style="background-color:##FF9;">
									<li><h5><strong>ORDEN DEL D&Iacute;A</strong></h5></li>
                                </ol>
                            </div>
                            <div class="col-sm-1 col-md-1 text-center"></div>
						</div>
					</cfoutput>
                    <div class="row">
						<div class="col-sm-1 col-md-1 text-center"></div>
						<div class="col-sm-10 col-md-10 text-justify">
							<table class="table table-striped table-hover">
                                <thead>
                                    <tr><td colspan="7"></td></tr>
								</thead>
								<tbody>                                
									<cfoutput query="tbSesionOrden">
										<!--- Aquí se deben mostrar los archivos históricos del campo PUNTO_PDF --->
                                        <cfset vArchivoPdfPuntoOd = ''>
                                        <cfif #punto_pdf# NEQ ''>
                                            <cfif #MID(punto_clave,1,4)# EQ 'ACTA' OR #MID(punto_clave,1,9)# EQ 'RECOMCAAA'>
                                                <cfset vArchivoPdfPuntoOd = #vCarpetaSesionHistoria# & #punto_pdf#>
                                                <cfset vWebPdf = #vWebSesionHistoria# & #punto_pdf#>
                                            <cfelseif #RTrim(punto_clave)# EQ 'PNCA' OR #RTrim(punto_clave)# EQ 'PNIE'>
                                                <cfset vArchivoPdfPuntoOd = #vCarpetaAcademicos# & #punto_pdf#>
                                                <cfset vWebPdf = #vWebAcademicos# & #punto_pdf#>
                                            <cfelseif #RTrim(punto_clave)# EQ 'OTRO'>
                                                <cfset vArchivoPdfPuntoOd = #vCarpetaSesionOtros# & #punto_pdf#>
                                                <cfset vWebPdf = #vWebSesionOtros# & #punto_pdf#>
                                            </cfif>
                                        </cfif>
                                        <!--- Aquí se deben mostrar los archivos históricos del campo PUNTO_PDF_2 --->
                                        <cfset vArchivoPdfPuntoOd2 = ''>
                                        <cfif #punto_pdf_2# NEQ ''>
                                            <cfif #MID(punto_clave,1,4)# EQ 'ACTA' OR #MID(punto_clave,1,9)# EQ 'RECOMCAAA'>
                                                <cfset vArchivoPdfPuntoOd2 = #vCarpetaSesionHistoria# & #punto_pdf_2#>
                                                <cfset vWebPdf2 = #vWebSesionHistoria# & #punto_pdf_2#>
                                            <cfelseif #RTrim(punto_clave)# EQ 'PNCA' OR #RTrim(punto_clave)# EQ 'PNIE'>
                                                <cfset vArchivoPdfPuntoOd2 = #vCarpetaAcademicos# & #punto_pdf_2#>
                                                <cfset vWebPdf2 = #vWebAcademicos# & #punto_pdf_2#>
                                            <cfelse>		
                                                <cfset vArchivoPdfPuntoOd2 = #vCarpetaSesionOtros# & #punto_pdf_2#>
                                                <cfset vWebPdf2 = #vWebSesionOtros# & #punto_pdf_2#>
                                            </cfif>
                                        </cfif>
                                        <tr>
                                            <td width="4%" valign="top"><strong>#punto_num#</strong></td>
                                            <td width="80%" valign="top" align="justify">#punto_texto#</td>
                                            <cfif #Session.sTipoSistema# IS 'stctic' AND (#vSsnId# GTE #Session.sSesion# AND #tbSesion.ssn_clave# EQ 1) OR (#tbSesion.ssn_fecha# GTE #NOW()# AND #tbSesion.ssn_clave# EQ 2) OR (#Session.sTipoSistema# IS 'stctic' AND #Session.sUsuario# EQ 'aram_st')>
                                                <td width="2%">
                                                    <span class="glyphicon glyphicon-arrow-up" style="cursor:pointer;" onClick="fEnviarComando('SUBE','#punto_num#');" title="Subir posición"></span>
                                                </td>
                                                <td width="2%">
                                                    <span class="glyphicon glyphicon-arrow-down" style="cursor:pointer;" onClick="fEnviarComando('BAJA','#punto_num#');" title="Bajar posición"></span>
                                                </td>
                                                <td width="2%">
                                                    <a href="orden_dia/orden_dia_formulario_punto.cfm?vTipoComando=E&vSsnId=#ssn_id#&vPunto=#punto_num#" data-toggle="modal" data-target="###ssn_id#_#punto_num#">
                                                        <span class="glyphicon glyphicon-open" title="Editar punto"></span>
                                                    </a>
                                                    <div id="#ssn_id#_#punto_num#" class="modal fade" role="dialog">
                                                        <div class="modal-dialog modal-lg">
                                                            <div class="modal-content">
                                                                <!-- DIV PARA DESPLEGAR MÓDULO EMERGENTE O VENTANA DE DIÁLOGO -->
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <!--- <img src="#vCarpetaIMG#/detalle_15.jpg" onclick="fRempValoresPunto('E','#punto_num#');" style="cursor:pointer;" title="Editar punto"> --->
                                                </td>
                                                <td width="2%">
                                                    <span class="glyphicon glyphicon-trash" style="cursor:pointer;" onClick="EnviarComando('ELIMINA','#punto_num#','#punto_clave#');" title="Editar punto"></span>
                                                    <!--- <img src="#vCarpetaIMG#/elimina_15.jpg" onclick="fEnviarComando('ELIMINA','#punto_num#','#punto_clave#');" style="cursor:pointer;" title="Eliminar punto"> --->
                                                </td>
                                            <cfelse>
                                                <td colspan="4" width="8%"></td>
                                                
                                            </cfif>
                                            <td width="8%" align="right" <cfif #Session.sTipoSistema# IS 'stctic' AND (#vSsnId# GTE #Session.sSesion# AND #tbSesion.ssn_clave# EQ 1) OR (#tbSesion.ssn_fecha# GTE #NOW()# AND #tbSesion.ssn_clave# EQ 2)>width="15"<cfelse>width="40"</cfif>>
                                                <cfif FileExists(#vArchivoPdfPuntoOd#)>
                                                    <a href="#vWebPdf#" target="_blank">
                                                        <span class="glyphicon glyphicon-open-file" title="#punto_pdf#"></span>
                                                        <!--- <img src="#vCarpetaIMG#/pdf.png" width="20" onclick="" style="border:none;cursor:pointer;" title="#punto_pdf#"> --->
                                                    </a>
                                                </cfif>
                                                <cfif FileExists(#vArchivoPdfPuntoOd2#)>
                                                    <a href="#vWebPdf2#" target="_blank">
                                                        <span class="glyphicon glyphicon-open-file" title="#punto_pdf_2#"></span>
                                                        <!--- <img src="#vCarpetaIMG#/pdf.png" width="20" onclick="" style="border:none;cursor:pointer;" title="#punto_pdf_2#"> --->
                                                    </a>
                                                </cfif>
                                            </td>
                                        </tr>
                                    </cfoutput>
									<cfif (#tbSesion.ssn_fecha# LTE #NOW()# AND #Session.sTipoSistema# IS 'stctic' AND #Session.sUsuarioNivel# EQ 1)OR (#tbSesion.ssn_fecha# GTE #NOW()# AND #tbSesion.ssn_clave# EQ 2) OR (#Session.sTipoSistema# IS 'stctic' AND #Session.sUsuario# EQ 'aram_st')>
                                        <tr class="success">
                                            <td colspan="6"><strong class="small">AGREGAR NUEVO PUNTO AL ORDEN DEL DÍA...</strong></td>
                                            <td align="right">
                                                <a href="orden_dia/orden_dia_formulario_punto.cfm?vTipoComando=N&vSsnId=<cfoutput>#vSsnId#</cfoutput>" data-toggle="modal" data-target="#divPuntoN">
                                                    <span class="glyphicon glyphicon-plus-sign" style="font-size:18px;" title="Agregar punto"></span>
                                                </a>
                                                <div id="divPuntoN" class="modal fade" role="dialog">
                                                    <div class="modal-dialog modal-lg">
                                                        <div class="modal-content">
                                                            <!-- DIV PARA DESPLEGAR MÓDULO EMERGENTE O VENTANA DE DIÁLOGO -->
                                                        </div>
                                                    </div>
                                                </div>
                                                <!--- <img src="<cfoutput>#vCarpetaICONO#</cfoutput>/agregar_15.jpg" width="15" onclick="fRempValoresPunto('N','');" style="border:none;cursor:pointer;" title="AGREGAR PUNTO"> --->
                                            </td>
                                        </tr>
                                    </cfif>
                                </tbody>
							</table>
						</div>
						<!--- <div id="divPunto"><!-- INSETA AJAX PARA ACTIVAR EL FORMULARIO DE CAPTURA DE PUNTOS DEL ORDEN DEL DÍA --></div> --->
						<div id="ActualizaPunto_dynamic"><!-- INSETA AJAX PARA ACTIVAR EL FORMULARIO DE CAPTURA DE PUNTOS DEL ORDEN DEL DÍA --></div>
					</div>
					<div class="col-sm-1 col-md-1 text-center"></div>
				</div>
			</div>
		</div> 
        <!-- Campos ocultos -->
        <cfoutput>
            <input type="hidden" name="ssn_id" id="ssn_id" value="#vSsnId#">
            <input type="hidden" name="vAccion" id="vAccion" value="">
            <input type="hidden" name="vPunto" id="vPunto" value="">
            <input type="hidden" name="vPuntoClave" id="vPuntoClave" value="">
        </cfoutput>
        