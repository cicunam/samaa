<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 12/05/2022 --->
<!--- FECHA ÚLTIMA MOD.: 12/05/2022 --->
<!--- ESCRIBIR O CONSULTAR COMENTARIOS A UN INFORME ANUAL --->
<!--------------------------------------------------->

<cfparam name="vInfAnId" default="103145">

<!--- Obtener datos del Informe Anual y la nota de la comisión --->
<cfquery name="tbInforme" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM movimientos_informes_anuales AS T1
	LEFT JOIN movimientos_informes_asunto AS T2 ON T1.informe_anual_id = T2.informe_anual_id AND T2.informe_reunion = 'CAAA'
	LEFT JOIN academicos AS T3 ON T1.acd_id = T3.acd_id
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C2 ON T1.dep_clave = C2.dep_clave <!---CATALOGOS GENERALES MYSQL --->
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_cn')# AS C3 ON T1.cn_clave = C3.cn_clave <!---CATALOGOS GENERALES MYSQL --->
    LEFT JOIN catalogo_decision AS C4 ON T1.dec_clave_ci = C4.dec_clave
	LEFT JOIN catalogo_decs_informes_comenta AS C5 ON T1.comentario_clave_ci = C5.comentario_clave    
	WHERE T1.informe_anual_id = #vInfAnId#
	AND T2.informe_reunion = 'CAAA'
</cfquery>

<!--- Obtiene los movimientos anteriores del mismo tipo de asunto para sacar los comentarios de la CAAA--->
<cfquery name="tbInformesHistoria" datasource="#vOrigenDatosSAMAA#">
	SELECT T1.informe_anio, C2.dep_siglas, C1.dec_descrip
    FROM movimientos_informes_anuales AS T1
	LEFT JOIN movimientos_informes_asunto AS T2 ON T1.informe_anual_id = T2.informe_anual_id AND T2.informe_reunion = 'CTIC'
	LEFT JOIN catalogo_decision AS C1 ON T2.dec_clave = C1.dec_clave
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C2 ON T1.dep_clave = C2.dep_clave <!---CATALOGOS GENERALES MYSQL --->    
	WHERE T1.acd_id = #tbInforme.acd_id#
    AND T1.informe_anio < #tbInforme.informe_anio#
	ORDER BY T1.informe_anio DESC
</cfquery>

<link href="/comun_cic/css/jquery/jquery-ui-1.8.16.custom.css" type="text/css" rel="Stylesheet">
<script type="text/javascript" src="/comun_cic/jquery/jquery-1.6.2.min.js"></script>
<script type="text/javascript" src="/comun_cic/jquery/jquery-ui-1.8.16.custom.min.js"></script>

<!--- JQUERY --->
<script language="JavaScript" type="text/JavaScript">
	$(function() {
	   $('#vComentario').focusout(function(){
			$.ajax({
				url: "asunto_comentario_guarda.cfm",
				type:'POST',
				async: false,
				data: new FormData($('#frmGuardaComentario')[0]),
				processData: false,
				contentType: false,
				success: function(data) {
				},				
				error: function(data) {
					alert('ERROR AL AGREGAR EL COMENTARIO');
//					location.reload();
				},
			});
		});
	});
	$("#CierraModalAbajo").click(function (e) { 
		fListarSolicitudes(<cfoutput>#Session.ReunionCAAAFiltro.vPagina#</cfoutput>);
	});	
	$("#CierraModalArriba").click(function (e) { 
		fListarSolicitudes(<cfoutput>#Session.ReunionCAAAFiltro.vPagina#</cfoutput>);
	});	
</script>


   <!-- Modal content-->
		<cfoutput query="tbInforme">
			<div class="modal-header">
				<button id="CierraModalArriba" type="button" class="close" data-dismiss="modal">&times;</button>
				<h4 class="modal-title">INFORME ANUAL</h4>
			</div>
			<div class="modal-body">
				<h5>
					<strong>#Trim(acd_apepat)# #Trim(acd_apemat)# #Trim(acd_nombres)#</strong><br/>
					#Trim(dep_nombre)#<br/>
				</h5>
				<hr />
                <h5><strong>ESCRIBIR COMENTARIO</strong></h5>
                <form id="frmGuardaComentario">
	                <textarea name="vComentario" id="vComentario" cols="100" rows="5" class="form-control">#tbInforme.comision_nota#</textarea>
					<input name="vInfAnId" id="vInfAnId" type="hidden" value="#vInfAnId#" />
					<input name="vTipoGuarda" id="vTipoGuarda" type="hidden" value="INF" />
                </form>
				<h5><strong>CONSEJO INTERNO</strong></h5>
				<h5>
					<strong>Decisión: </strong>#tbInforme.dec_descrip#<br />
                    <strong>Comentario: </strong>
                    <br />#tbInforme.comentario_texto_ci#
				</h5>				
				<cfif #tbInformesHistoria.RecordCount# GT 0>
					<hr />
                    <div style="background-color:##FF9; height:25px; padding-top:5px;"><h5 class="modal-title" align="center"><strong>INFORMES ANUALES ANTERIORES</strong></h4></div>
                    <table width="100%" class="table table-striped">
                        <thead>
                            <tr class="header">
                                <td class="small" width="10%"><strong>AÑO</strong></td>
                                <td class="small" width="10%"><strong >ENTIDAD</strong></td>
                                <td class="small" width="40%"><strong>DECISIÓN</strong></td>
                                <td class="small" width="40%"><strong>COMENTARIO</strong></td>
	                        </tr>
						</thead>
                        <cfloop query="tbInformesHistoria">
                            <tr>
                                <td class="small" valign="top">#informe_anio#</td>
                                <td class="small" valign="top">#dep_siglas#</td>
                                <td class="small" valign="top">#dec_descrip#</td>
                                <td class="small" valign="top"></td>
                            </tr>
                        </cfloop>
                    </table>
				</cfif>
			</div>
			<div class="modal-footer">
				<button id="CierraModalAbajo" type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
			</div>
		</cfoutput>
