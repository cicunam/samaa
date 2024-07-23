<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 28/04/2017 --->
<!--- FECHA ÚLTIMA MOD.: 28/04/2017 --->
<!--- ESCRIBIR O CONSULTAR COMENTARIOS A UN ASUNTO --->
<!--------------------------------------------------->

<cfparam name="vSolId" default="103145">


<!--- Obtener datos de la tabla de comisiones --->
<cfquery name="tbComisiones" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM movimientos_solicitud_comision
	WHERE sol_id = #vSolId#
    AND ssn_id = #Session.sSesion#
</cfquery>

<!--- Obtener datos de la solicitud --->
<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM ((movimientos_solicitud
	LEFT JOIN academicos ON movimientos_solicitud.sol_pos2 = academicos.acd_id)
	LEFT JOIN catalogo_movimiento ON movimientos_solicitud.mov_clave = catalogo_movimiento.mov_clave)
	LEFT JOIN catalogo_dependencia ON movimientos_solicitud.sol_pos1 = catalogo_dependencia.dep_clave	
	WHERE sol_id = #vSolId#
</cfquery>

<cfset vAcdId = #tbSolicitudes.sol_pos2#>
<cfset vMovClave = #tbSolicitudes.mov_clave#>

<!--- Obtiene los movimientos anteriores del mismo tipo de asunto para sacar los comentarios de la CAAA--->
<cfquery name="tbComentarioCaaa" datasource="#vOrigenDatosSAMAA#">
	SELECT
    T2.ssn_id, T3.ssn_fecha, 
    T1.mov_numero, T1.mov_fecha_inicio,
    T2.asu_notas
    FROM movimientos AS T1
	LEFT JOIN movimientos_asunto AS T2 ON T1.sol_id = T2.sol_id AND T2.asu_reunion = 'CAAA'
    LEFT JOIN sesiones AS T3 ON T2.ssn_id = T3.ssn_id AND T3.ssn_clave = 1
	WHERE T1.mov_clave = #vMovClave#
	AND T1.acd_id = #vAcdId#
	AND T2.asu_comentario IS NOT NULL
	ORDER BY T2.ssn_id DESC
</cfquery>

<!--- Verifica si esxiste el registro de la nota, en caso de que no manda la variable en blanco, de lo contrario le agrega el valor del registro --->
<cfif #tbComisiones.RecordCount# EQ 0>
	<cfset vComentario = "">
<cfelseif #tbComisiones.RecordCount# EQ 1>
	<cfset vComentario = #tbComisiones.comision_nota#>
<cfelse>
	<cfset vComentario = "">
</cfif>

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
		fListarSolicitudes(<cfoutput>#Session.ReunionCAAAFiltro.vPagina#</cfoutput>);
	});	
	$("#CierraModalArriba").click(function (e) { 
		fListarSolicitudes(<cfoutput>#Session.ReunionCAAAFiltro.vPagina#</cfoutput>);
	});
</script>


   <!-- Modal content-->
		<cfoutput query="tbSolicitudes">
			<div class="modal-header">
            	<cfif #vTipoVistaComentario# EQ 'T'>
					<button id="CierraModalArriba" type="button" class="close" data-dismiss="modal">&times;</button>
				</cfif>
				<h4 class="modal-title">#tbSolicitudes.mov_titulo#</h4>
			</div>
			<div class="modal-body">
				<h5>
					<strong>#Trim(acd_apepat)# #Trim(acd_apemat)# #Trim(acd_nombres)#</strong><br/>
					#Trim(dep_nombre)#<br/>
					#Ucase(mov_titulo_corto)#
				</h5>
                <cfif #Session.sAcadIdCaaa# GT 0>
	                <hr />
                    <h5><strong>ESCRIBIR COMENTARIO</strong></h5>
                    <form id="frmGuardaComentario">
                        <textarea name="vComentario" id="vComentario" cols="100" rows="5" class="form-control">#vComentario#</textarea>
                        <input name="vSolId" id="vSolId" type="hidden" value="#sol_id#" />
                        <input name="vTipoGuarda" id="vTipoGuarda" type="hidden" value="SOL" />                    
                    </form>
                <cfelse>
                    <cfif LEN(#vComentario#) GT 1>
		                <hr />
                        <h5><strong>COMENTARIO(S) DE LOS MIEMBROS DE LA CAAA</strong></h5>
                        <br />
                        #vComentario#
                    </cfif>
                </cfif>
				<cfif #tbComentarioCaaa.RecordCount# GT 0>
					<hr />
                    <div style="background-color:##FF9; height:25px; padding-top:5px;"><h5 class="modal-title" align="center"><strong>COMENTARIOS ANTERIORES</strong></h5></div>
                    <table width="100%" class="table table-striped">
                        <thead>
                            <tr class="header">
                                <td class="small" width="45%"><strong>SESIÓN</strong></td>
                                <td class="small" width="30%"><strong >No. CONTRATO</strong></td>
                                <td class="small" width="25%"><strong>A PARTIR</strong></td>
	                        </tr>
						</thead>
                        <cfloop query="tbComentarioCaaa">
							<tbody>                        
                                <tr>
                                    <td class="small" valign="top">#tbComentarioCaaa.ssn_id# del #LsDateFormat(tbComentarioCaaa.ssn_fecha, 'dd/mm/yyyy')#</td>
                                    <td class="small" valign="top">#tbComentarioCaaa.mov_numero#</td>
                                    <td class="small" valign="top">#LsDateFormat(tbComentarioCaaa.mov_fecha_inicio, 'dd/mm/yyyy')#</td>
                                </tr>
                                <tr>
                                    <td colspan="3"><strong>COMENTARIO:</strong><br />#tbComentarioCaaa.asu_notas#</td>
                                </tr>
							</tbody>
                        </cfloop>
                    </table>
				</cfif>
			</div>
			<div class="modal-footer">
            	<cfif #vTipoVistaComentario# EQ 'T'>            
					<button id="CierraModalAbajo" type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
				</cfif>
			</div>
		</cfoutput>
