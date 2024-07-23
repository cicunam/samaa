<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 25/05/2017 --->
<!--- FECHA ÚLTIMA MOD.: 02/03/2022 --->
<!--- CONTACTO  --->


                <div class="modal-header">
                    <button id="CierraModalArriba" type="button" class="close" data-dismiss="modal">&times;</button>
                    <cfif #vArea# EQ 'STCTIC'>
                        <h4 class="modal-title">Secretar&iacute;a T&eacute;cnica del Consejo T&eacute;cnico</h4>
                    <cfelseif #vArea# EQ 'STS'>
                        <h4><strong>Secretar&iacute;a T&eacute;cnica de Seguimiento de la Informaci&oacute;n</strong></h4>
                    </cfif>
                </div>
                <div class="modal-body">
                    <cfif #vArea# EQ 'STCTIC'>
                        <cfquery name="tbDirectorio" datasource="#vOrigenDatosSAMAA#">
                            SELECT *
                            FROM samaa_stctic_dir
                            WHERE #now()# BETWEEN fecha_inicio AND fecha_final
                            AND nivel_id > 1
                            ORDER BY nivel_id, nombre_comp
                        </cfquery>
                        <cfoutput query="tbDirectorio">
                            <div class="row" align="center">
                                <h6><strong>#puesto#</strong></h6>
                                <div style="width:65%;">
                                    <div style="width:20%; float:left;"><span class="glyphicon glyphicon-user"></span></div>
                                    <div style="width:80%; float:left;" align="left"><h6 style="margin:5px;">#nombre_comp#</h6></div>
                                </div>
                                <div style="width:65%;">
                                    <div style="width:20%; float:left;"><span class="glyphicon glyphicon-envelope"></span></div>
                                    <div style="width:80%; float:left;" align="left"><h6 style="margin:5px;"><a href="mailto:#email#">#email#</a></h6></div>
                                </div>
                                <div style="width:65%;">
                                    <div style="width:20%; float:left;"><span class="glyphicon glyphicon-phone-alt"></span></div>
                                    <div style="width:80%; float:left;" align="left"><h6 style="margin:5px;">#telefonof#</h6></div>
                                </div>
                            </div>
                            <hr style="width:70%;" />
                        </cfoutput>
					<cfelseif #vArea# EQ 'STS'>
						<div class="row" align="center">
                            <h6><strong>Secretaria</strong></h6>
                            <div style="width:65%;">
                                <div style="width:20%; float:left;"><span class="glyphicon glyphicon-user"></span></div>
                                <div style="width:80%; float:left;" align="left"><h6 style="margin:5px;">Sra. Patricia Cortes P&eacute;rez</h6></div>
                            </div>
                            <div style="width:65%;">
                                <div style="width:20%; float:left;"><span class="glyphicon glyphicon-envelope"></span></div>
                                <div style="width:80%; float:left;" align="left"><h6 style="margin:5px;"><a href="mailto:paty@unam.mx">paty@cic.unam.mx</a></h6></div>
                            </div>
                            <div style="width:65%;">
                                <div style="width:20%; float:left;"><span class="glyphicon glyphicon-phone-alt"></span></div>
                                <div style="width:80%; float:left;" align="left"><h6 style="margin:5px;">55562-24168 y 55562-24170</h6></div>
                            </div>
						</div>
<!---
						<hr style="width:70%;" />
                            <h6><strong>Secretaria</strong></h6>
                            <div style="width:65%;">
                                <div style="width:20%; float:left;"><span class="glyphicon glyphicon-user"></span></div>
                                <div style="width:80%; float:left;" align="left"><h6 style="margin:5px;">Pas. Mar&iacute;a Esther >Mora</h6></div>
                            </div>
                            <div style="width:65%;">
                                <div style="width:20%; float:left;"><span class="glyphicon glyphicon-envelope"></span></div>
                                <div style="width:80%; float:left;" align="left"><h6 style="margin:5px;"><a href="mailto:paty@unam.mx">paty@cic.unam.mx</a></h6></div>
                            </div>
                            <div style="width:65%;">
                                <div style="width:20%; float:left;"><span class="glyphicon glyphicon-phone-alt"></span></div>
                                <div style="width:80%; float:left;" align="left"><h6 style="margin:5px;">5622-4168 y 5622-4170</h6></div>
                            </div>
						</div>
--->
					</cfif>
				</div>
				<div class="modal-footer">
					<button id="CierraModalAbajo" type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
				</div>
