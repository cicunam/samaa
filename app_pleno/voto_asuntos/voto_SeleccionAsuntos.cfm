<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 17/11/2023 --->
<!--- FECHA ULTIMA MOD.: 17/11/2023 --->
<!--- INCLUDE QUE PERMITE AL COORDINADOR ACTIVAR EL O LOS ASUNTOS QUE SE VOTARÁN --->

<cfquery name="tbAsuntosVoto" datasource="#vOrigenDatosSAMAA#">
    SELECT * FROM sesion_asuntovoto
    WHERE ssn_id = #vSesionMuestra#
    AND sol_id = #sol_id#
</cfquery>

<cfif #tbAsuntosVoto.RecordCount# EQ 0>
    <cfset vVotoStatus = '##00000'>
    <cfset vVotoTitle = 'Activar votaci&oacute;n'>
    <cfset vGlyphicon = 'glyphicon glyphicon-edit'>
<cfelse>
    <cfif #tbAsuntosVoto.RecordCount# EQ 1>
        <cfif #tbAsuntosVoto.voto_status# EQ 1><!--- PENDIENTE DE ACTIVAR VOTO --->
            <cfset vVotoStatus = '##FC0307'><!--- ##797979 --->
            <cfset vVotoTitle = 'Pendiente por activar votaci&oacute;n'>
            <cfset vGlyphicon = 'glyphicon glyphicon-edit'>
        <cfelseif #tbAsuntosVoto.voto_status# EQ 2><!--- ACTIVO --->
            <cfset vVotoStatus = '##02F76A'>
            <cfset vVotoTitle = 'En poroceso de votaci&oacute;n'>
            <cfset vGlyphicon = 'glyphicon glyphicon-check'>
        <cfelseif #tbAsuntosVoto.voto_status# EQ 4><!--- CERRADO --->
            <cfset vVotoStatus = '##0066CC'><!--- ##FC0307 --->
            <cfset vVotoTitle = 'Voto emitido'>
            <cfset vGlyphicon = 'glyphicon glyphicon-check'>
        <cfelseif #tbAsuntosVoto.voto_status# EQ 5><!--- PUBLICAR RESULTADOS --->
            <cfset vVotoStatus = '##0066CC'>
            <cfset vVotoTitle = 'Consultar resultados votaci&oacute;n'>
            <cfset vGlyphicon = 'glyphicon glyphicon-signal'>
        </cfif>
    </cfif>    
</cfif>
                
            
<cfoutput>
    <span class="#vGlyphicon#" style="color: #vVotoStatus#;" title="#vVotoTitle#"  data-toggle="modal" data-target="##modalAsunto#sol_id#"></span>
    <div id="modalAsunto#sol_id#" class="modal fade" role="dialog">
        <div id="modalAsuntoDiv1_#sol_id#" class="modal-dialog modal-sm">
            <!-- Modal content-->
            <div id"modalContent_#sol_id#" class="modal-content">
                <div id"modalHeader_#sol_id#" class="modal-header">
                    <button type="button" id="cmdCancelaVotoSup_#sol_id#" name="cmdCancelaVotoSup_#sol_id#" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title">#vVotoTitle# - #sol_id#</h4>
                </div>
                <div id"modalBody_#sol_id#" class="modal-body">
                    <cfform id="frmAsuntoVoto_#sol_id#" name="frmAsuntoVoto_#sol_id#">
                        <p>
                            Descripci&oacute;n sobre la votaci&oacute;n:
                            <textarea id="asunto_descrip" name="asunto_descrip" rows="5" class="form-control input-sm">#tbAsuntosVoto.asunto_descrip#</textarea>
                            <br/>
                            <cfinput type="Checkbox" id="" name=""> Voto secreto
                            <hr/>
                            Situaci&oacute;n de la votaci&oacute;n: #tbAsuntosVoto.voto_status#<br/> 
                            <cfselect id="voto_status" name="voto_status" class="form-control input-sm">
                                <option value="0" <cfif #tbAsuntosVoto.voto_status# EQ 0>Selected</cfif>>Seleccione</option>                                
                                <option value="1" <cfif #tbAsuntosVoto.voto_status# EQ 1>Selected</cfif>>Seleccionar asunto para votaci&oacute;n</option>
                                <option value="2" <cfif #tbAsuntosVoto.voto_status# EQ 2>Selected</cfif>>Activar votaci&oacute;n</option>
                                <option value="4" <cfif #tbAsuntosVoto.voto_status# EQ 4>Selected</cfif>>Cerrar votaci&oacute;n</option>
                                <option value="5" <cfif #tbAsuntosVoto.voto_status# EQ 5>Selected</cfif>>Publicar resultados</option>
                            </cfselect>
                            <br/>
                            <input type="text" id="id" name="id" value="#tbAsuntosVoto.id#">
                            <input type="text" id="sol_id" name="sol_id" value="#sol_id#">
                            <input type="text" id="ssn_id" name="ssn_id" value="#tbSesion.ssn_id#">
                        </p>
                    </cfform>
                </div>
                <div id"modalFooter_#sol_id#" class="modal-footer">
                    <button type="button" id="cmdActivarVoto_#sol_id#" name="cmdActivarVoto_#sol_id#" class="btn btn-primary btn-sm" onClick="fModalActivaVoto(#sol_id#);">Aplicar</button> <!--- onClick="alert('VOTACION ACTIVADA');" --->
                    <button type="button" id="cmdCancelaVotoInf_#sol_id#" name="cmdCancelaVotoInf_#sol_id#" class="btn btn-default btn-sm" data-dismiss="modal">Cancelar</button>
                </div>
            </div>
        </div>
    </div>
</cfoutput>