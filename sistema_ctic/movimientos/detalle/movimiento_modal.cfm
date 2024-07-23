<!-- Trigger the modal with a button 
<button type="button" class="btn btn-info btn-lg" data-toggle="modal" data-target="#myModal">Open Modal</button>
-->
<!-- Modal -->
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal">&times;</button>
            <h4 class="modal-title">CONSULTA DE FORMA TELEGRAMICA</h4>
        </div>
        <div class="modal-body">
<!---            
            <cfoutput>
                #vCarpetaRaizLogicaSistema#<br/>
                #vIdAcad#<br/>
                #vIdMov#<br/>
                #vTipoComando#<br/>
                #vMenuHidden#<br/>                
            </cfoutput>
--->
            <cfinclude template="#vCarpetaRaizLogicaSistema#/movimientos/detalle/movimiento.cfm">
<!---                                
            <cfhttp url="#vCarpetaRaizLogicaSistema#/movimientos/detalle/movimiento.cfm" method="get" resolveurl="true">

                <cfhttpparam type="COOKIE" name="CFID" value="#cookie.cfid#">
                <cfhttpparam type="COOKIE" name="CFTOKEN" value="#cookie.cftoken#">
                <cfhttpparam type="COOKIE" name="vIdAcad" value="#vIdAcad#">
                <cfhttpparam type="COOKIE" name="vIdMov" value="#vIdMov#">
                <cfhttpparam type="COOKIE" name="vTipoComando" value="#vTipoComando#">
                <cfhttpparam type="COOKIE" name="vMenuHidden" value="#vMenuHidden#">
                vIdAcad=#tbMovimientos.acd_id#&vIdMov=#tbMovimientos.mov_id#&vTipoComando=CONSULTA                    

            </cfhttp>
            <cfoutput>#cfhttp.fileContent#</cfoutput>
--->
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar ventana</button>
        </div>
