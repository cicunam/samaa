

        <cfquery name="tbAcuerdosDetalle" datasource="#vOrigenDatosSAMAA#">
            SELECT * FROM acuerdos_ctic 
            WHERE acuerdo_id = #vAcuerdoId#
		</cfquery>        

		<cfoutput query="tbAcuerdosDetalle">
            <div class="modal-header">
                <button id="CierraModalArriba" type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">#acuerdo_titulo#</h4>
            </div>
            <div class="modal-body">
            	<h6 class="small text-justify">#acuerdo_texto_1##acuerdo_texto_2#</h6>
            	<h6 class="small text-justify">#acuerdo_texto_1_decision#</h6>                
            </div>
            <div class="modal-footer">
                <button id="CierraModalAbajo" type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
            </div>
		</cfoutput>