<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 15/03/2017 --->
<!--- FECHA ULTIMA MOD.: 15/03/2017 --->

<!--- DESPLEGA INFORMACIÓN SOBRE SOLICITUDES QUE SE ENCUANTRAN EN PROCESO DEL ACADÉMICO SELECCIONADO --->

<cfif IsDefined('vpAcadId') AND #vpAcadId# GT 0>
	<!--- JQUERY LOCAL --->
    <script type="text/javascript" language="JavaScript">
        // Ventana de dialogo para mostrar la lista de solicitudes en trámite:
        $(function() {
            $('#dialog:ui-dialog').dialog('destroy');
            $('#ListaSolCons_jQuery').dialog({
                autoOpen: false,
                height: 300,
                width: 750,
                show: 'slow',
                modal: true,
                title: 'SOLICITUDES EN TRÁMITE',
                open: function() {
                    $(this).load('<cfoutput>#Application.vCarpetaRaizLogica#</cfoutput>/sistema_ctic/asuntos/solicitudes/consulta_solicitudes_tramite_emergente.cfm',
                    {
                        vIdAcad:<cfoutput>#vpAcadId#</cfoutput>,
                    });
    //	        	fListarMovimientos(1,'mov_fecha_inicio','DESC');
                }
            });
            $('#imgDetalleSolProceso').click(function(){
                $('#ListaSolCons_jQuery').dialog('open');
            });		
        });
    </script>
    
    <!--- Abre tabla de solicitudes para indicar si esxiete solicitud en trámite--->
    <cfquery name="tbSoliciudes" datasource="#vOrigenDatosSAMAA#">
        SELECT COUNT(*) AS vCuentaSol
        FROM movimientos_solicitud
        WHERE sol_pos2 = #vpAcadId# 
    </cfquery>

    <br/>
    <cfoutput>
        <div style="height:35px; width:95%; background-color:##FFC">
            <div style="height:20px; width:80%; padding-top:12px; position:fixed;">
                <span class="Sans10ViNe">Solicitudes en trámite: </span>
                <span class="Sans10NeNe">#tbSoliciudes.vCuentaSol#</span>
            </div>
            <div style="height:20px; width:10%; left:130px; padding-top:10px; position:fixed;">
                <img id="imgDetalleSolProceso" src="#vCarpetaICONO#/detalle_15.jpg" style="border:none; cursor:pointer;" title="Consultar solicitudes en trámite">
            </div>
        </div>
    </cfoutput>
	<div id="ListaSolCons_jQuery"><!-- JQUERY: Formulario de captura de nuevo oponente --></div>    
</cfif>