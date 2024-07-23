<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 17/11/2023 --->
<!--- FECHA ULTIMA MOD.: 17/11/2023 --->
<!--- INCLUDE QUE ACTIVAR LA VOTACIÓN, VOTAR Y VER RESULTADOS PARA LOS MIEMBROS DEL CTIC  --->

        <cfquery name="tbAsuntosVoto" datasource="#vOrigenDatosSAMAA#">
            SELECT *, 
                (
                    SELECT COUNT(*) FROM movimientos_sesion_voto
                    WHERE ssn_id = #vSesionMuestra#
                    AND sol_id = #sol_id#
                    AND acd_id = 123
                ) AS VotoEmite
            FROM sesion_asuntovoto
            WHERE ssn_id = #vSesionMuestra#
            AND sol_id = #sol_id#
        </cfquery>


        <cfif #tbAsuntosVoto.RecordCount# EQ 1>
            <cfif #tbAsuntosVoto.voto_status# EQ 1><!--- PENDIENTE DE ACTIVAR VOTO --->
                <cfset vVotoStatus = '##797979'>
                <cfset vVotoTitle = 'Pendiente por activar votaci&oacute;n'>
                <cfset vGlyphicon = 'glyphicon glyphicon-edit'>
            <cfelseif #tbAsuntosVoto.voto_status# EQ 2><!--- ACTIVO --->
                <cfif #tbAsuntosVoto.VotoEmite# EQ 0>
                    <cfset vVotoStatus = '##02F76A'>                    
                    <cfset vVotoTitle = 'Votar'>
                    <cfset vGlyphicon = 'glyphicon glyphicon-edit'>
                <cfelse>
                    <cfset vVotoStatus = '##0066CC'>
                    <cfset vVotoTitle = 'Voto emitido'>
                    <cfset vGlyphicon = 'glyphicon glyphicon-check'>
                </cfif>
            <cfelseif #tbAsuntosVoto.voto_status# EQ 3><!--- CERRADO --->
                <cfset vVotoStatus = '##FC0307'>
                <cfset vVotoTitle = 'Votaci&oacute;n cerrada'>
                <cfset vGlyphicon = 'glyphicon glyphicon-check'>
            <cfelseif #tbAsuntosVoto.voto_status# EQ 5><!--- RESULTADOS --->
                <cfset vVotoStatus = '##0066CC'>
                <cfset vVotoTitle = 'Consultar resultados votaci&oacute;n'>
                <cfset vGlyphicon = 'glyphicon glyphicon-signal'>
            </cfif>
            <cfoutput>
                <span class="#vGlyphicon#" style="color: #vVotoStatus#" title="#vVotoTitle#" data-toggle="modal" data-target="##Asunto#sol_id#"></span>
                <div id="Asunto#sol_id#" class="modal fade" role="dialog">
                    <div class="modal-dialog modal-sm">
                        <!-- Modal content-->
                        <div id"modalContent_#sol_id#" class="modal-content">
                            <div id"modalHeader_#sol_id#" class="modal-header">
                                <button type="button" class="close" data-dismiss="modal">&times;</button>
                                <h4 class="modal-title">#vVotoTitle# - #sol_id#</h4>
                            </div>
                            <div id"modalBody_#sol_id#" class="modal-body">
                                <cfform id="frmAsuntoVoto_#sol_id#" name="frmAsuntoVoto_#sol_id#">
                                    <p>
                                        #tbAsuntosVoto.asunto_descrip#
                                        <br/>
                                        <cfselect id="voto_id" name="voto_id" class="form-control input-sm">
                                            <option value="0">Seleccione</option>
                                            <option value="1">Aprobar</option>
                                            <option value="2">No aprobar</option>
                                            <option value="3">Abstención</option>
                                        </cfselect>
                                        <input type="text" id="sol_id" name="sol_id" value="#sol_id#">
                                        <input type="text" id="ssn_id" name="ssn_id" value="#tbSesion.ssn_id#">
                                    </p>
                                </cfform>
                            </div>
                            <div id"modalFooter_#sol_id#" class="modal-footer">
                                <button type="button"  id="cmdVotar_#sol_id#" name="cmdVotar_#sol_id#" class="btn btn-success" onClick="fModalVotar(#sol_id#);">Votar</button>                                
                                <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
                            </div>
                        </div>
                    </div>
                </div>
            </cfoutput>
        </cfif>
