<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 28/04/2017 --->
<!--- FECHA ÚLTIMA MOD.: 28/04/2017 --->
<!--- ESCRIBIR O CONSULTAR COMENTARIOS A UN ASUNTO --->
<!--------------------------------------------------->

<cfparam name="vSolId" default="103145">


<!--- Obtener datos de la solicitud --->
<cfquery name="tbAsuntosEvalua" datasource="#vOrigenDatosSAMAA#">
	SELECT
	T1.*,
	T2.acd_apepat, T2.acd_apemat, T2.acd_nombres,
	C1.*,
	C2.*
    FROM ((evaluaciones_comision_upeid AS T1
	LEFT JOIN academicos AS T2 ON T1.acd_id = T2.acd_id)
	LEFT JOIN catalogo_movimiento AS C1 ON T1.mov_clave = C1.mov_clave)
	LEFT JOIN catalogo_dependencia AS C2 ON T1.dep_clave = c2.dep_clave	
	WHERE asunto_id = #vAsuId#
</cfquery>

<link href="/comun_cic/css/jquery/jquery-ui-1.8.16.custom.css" type="text/css" rel="Stylesheet">
<script type="text/javascript" src="/comun_cic/jquery/jquery-1.6.2.min.js"></script>
<script type="text/javascript" src="/comun_cic/jquery/jquery-ui-1.8.16.custom.min.js"></script>

<!--- JQUERY --->
<script language="JavaScript" type="text/JavaScript">
	$(function() {
	   $('#vComentario').focusout(function(){
			$.ajax({
				//async: false,
				url: "asunto_comentario_guarda.cfm",
				type:'POST',
				data: new FormData($('#frmGuardaComentario')[0]),
				processData: false,
				contentType: false,
				success: function(data) {
/*
					if (data == 0) //alert('IGUAL');
						$('#sp_148853').removeClass("glyphicon glyphicon-comment").addClass("glyphicon glyphicon-pencil");
						//$('#sp_' & <cfoutput>#vSolId#</cfoutput>).toggleClass('glyphicon glyphicon-pencil');
					if (data > 0) //alert('MÁS');
						$('#sp_148853').removeClass("glyphicon glyphicon-pencil").addClass("glyphicon glyphicon-comment");
						//$('#sp_' & <cfoutput>#vSolId#</cfoutput>).toggleClass('glyphicon glyphicon-comment');
*/						
				},
				error: function(data) {
					alert('ERROR AL AGREGAR EL COMENTARIO');
//					location.reload();
				},
			});
		});
	});
	$("#CierraModalAbajo").click(function (e) { 
		fListarAsuntos(<cfoutput>#Session.ComisionUPEIDFiltro.vPagina#</cfoutput>);
	});	
	$("#CierraModalArriba").click(function (e) { 
		fListarAsuntos(<cfoutput>#Session.ComisionUPEIDFiltro.vPagina#</cfoutput>);
	});
</script>


   <!-- Modal content-->
		<cfoutput query="tbAsuntosEvalua">
			<div class="modal-header">
            	<cfif #vTipoVistaComentario# EQ 'T'>
					<button id="CierraModalArriba" type="button" class="close" data-dismiss="modal">&times;</button>
				</cfif>
				<h4 class="modal-title">#mov_titulo#</h4>
			</div>
			<div class="modal-body">
				<h5>
					<strong>#Trim(acd_apepat)# #Trim(acd_apemat)# #Trim(acd_nombres)#</strong><br/>
					#Trim(dep_nombre)#<br/>
					#Ucase(mov_titulo_corto)#
				</h5>
				<hr />
                <h5><strong>ESCRIBIR COMENTARIO</strong></h5>
                <form id="frmGuardaComentario">
	                <textarea name="vComentario" id="vComentario" cols="100" rows="5" class="form-control">#comision_nota#</textarea>
					<input name="vAsuId" id="vAsuId" type="hidden" value="#asunto_id#" />
					<input name="vTipoGuarda" id="vTipoGuarda" type="hidden" value="ASU" />                    
                </form>
<!----
				<cfif #tbComentarioCaaa.RecordCount# GT 0>
					<hr />
                    <div style="background-color:##FF9; height:25px; padding-top:5px;"><h5 class="modal-title" align="center"><strong>COMENTARIOS ANTERIORES</strong></h4></div>
                    <table width="100%" class="table table-striped">
                        <thead>
                            <tr class="header">
                                <td class="small" width="15%"><strong>SESIÓN</strong></td>
                                <td class="small" width="5%"><strong >No. CONTRATO</strong></td>
                                <td class="small" width="10%"><strong>A PARTIR</strong></td>
                                <td class="small" width="30%"><strong>COMENTARIO</strong></td>
	                        </tr>
						</thead>
                        <cfloop query="tbComentarioCaaa">
                            <tr>
                                <td class="small" valign="top">#tbComentarioCaaa.ssn_id# del #LsDateFormat(tbComentarioCaaa.ssn_fecha, 'dd/mm/yyyy')#</td>
                                <td class="small" valign="top">#tbComentarioCaaa.mov_numero#</td>
                                <td class="small" valign="top">#LsDateFormat(tbComentarioCaaa.mov_fecha_inicio, 'dd/mm/yyyy')#</td>
                                <td class="small" valign="top">#tbComentarioCaaa.asu_notas#</td>
                            </tr>
                        </cfloop>
                    </table>
				</cfif>
---->				
			</div>
			<div class="modal-footer">
            	<cfif #vTipoVistaComentario# EQ 'T'>            
					<button id="CierraModalAbajo" type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
				</cfif>
			</div>
		</cfoutput>
