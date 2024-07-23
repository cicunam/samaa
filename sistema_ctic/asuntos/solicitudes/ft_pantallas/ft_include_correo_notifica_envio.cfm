<!--- CREADO: ARAM PICHARDO--->
<!--- EDITO: ARAM PICHARDO--->
<!--- FECHA CREA: 11/09/2017 --->
<!--- FECHA ÚLTIMA MOD.: 11/09/2017 --->
<!--- INCLUDE: CÓDIGO DESPLEGAR MENSAJE DE NOTIFICACIÓN DE RENUNCIA A BECAS POSDOCTORAL --->


                            <!--- Obtener información del catálogo de bajas --->
                            <cfquery name="tbNotificaCorreo" datasource="#vOrigenDatosSAMAA#">
                                SELECT * FROM samaa_notifica_correos
                                WHERE sol_id = #vIdSol#
                            </cfquery>
    
                            <cfset trimDepClave = mid(#vCampoPos1#,1,4)>
                            <cfif #vSolStatus# EQ 3>
                                <cfset vArchivoSolicitudPdf = '#vCarpetaENTIDAD##trimDepClave#\#vIdAcad#_#vIdSol#.pdf'>
                            <cfelseif #vSolStatus# LTE 2>
                                <cfset vArchivoSolicitudPdf = '#vCarpetaCAAA##vIdAcad#_#vIdSol#.pdf'>
                            </cfif>
                            <div id="divMensajeRenunciaBeca" style="padding:30px; background-color:#FFFFCC" class="cuadros">
                                <span class="Sans10NeNe">
                                    Para agilizar la cancelaci&oacute;n de la beca y evitar pagos indebidos posteriores a la renuncia del becario, es importante notificar a las &aacute;reas pertinentes de la Coordinaci&oacute;n de la Investigaci&oacute;n Cient&iacute;fica.
                                </span>
                                <br>
                                <br>
								<cfif #tbNotificaCorreo.RecordCount# EQ 0>
	                                <span class="Sans10NeNe">
                                        Para realizar la notificaci&oacute;n de forma electr&oacute;nica es necesario:
                                        <ul>
                                            <li>Dar enviar a la forma telegr&aacute;mica</li>
                                            <li>Anexar y enviar los documentos digitalizados</li>
                                        </ul>
                                        Una vez hecho esto, aparecer&aacute; un bot&oacute;n de env&iacute;o de notificaci&oacute;n.
									</span>
                                    <cfif FileExists(#vArchivoSolicitudPdf#)>
                                        <cfinput name="cmdNotificaBaja" id="cmdNotificaBaja" type="button" value="Enviar notificaci&oacute;n" class="botones" onClick="fEnviaNotificaBaja();">
                                    </cfif>
                                <cfelseif #tbNotificaCorreo.RecordCount# GT 0>
									<span class="Sans12ViNe">LA RENUNCIA YA FUE NOTIFICADA A CADA UNA DE LAS &Aacute;REA DE LA COORDINACI&Oacute;N.</span>
                                </cfif>
								<div id="ajax_envia_notifica_baja"><!--AJAX PARA ENVIO DE NOTIFICACIÓN ---></div>
                            </div>