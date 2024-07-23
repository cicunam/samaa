<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 08/05/2017 --->
<!--- FECHA ÚLTIMA MOD.: 08/05/2017 --->
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
	SELECT * FROM movimientos_solicitud AS T1
	LEFT JOIN academicos AS T2 ON T1.sol_pos2 = T2.acd_id
	LEFT JOIN catalogo_movimiento AS C1 ON T1.mov_clave = C1.mov_clave
	LEFT JOIN catalogo_dependencia AS C2 ON T1.sol_pos1 = C2.dep_clave	
	WHERE sol_id = #vSolId#
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
				url: "asunto_comentario_guarda.cfm",
				type:'POST',
				async: false,
				data: new FormData($('#frmGuardaComentario')[0]),
				processData: false,
				contentType: false,
				error: function(data) {
					alert('ERROR AL AGREGAR EL COMENTARIO');
//					location.reload();
				},
			});
		});
	});
	
	$("#CierraModalAbajo").click(function (e) { 
		fListarSolicitudes(<cfoutput>#Session.CBPFiltro.vPagina#</cfoutput>);
	});	
	$("#CierraModalArriba").click(function (e) { 
		fListarSolicitudes(<cfoutput>#Session.CBPFiltro.vPagina#</cfoutput>);
	});	
</script>


   <!-- Modal content-->
		<cfoutput query="tbSolicitudes">
			<div class="modal-header">
				<button id="CierraModalArriba" type="button" class="close" data-dismiss="modal">&times;</button>
				<h4 class="modal-title">#tbSolicitudes.mov_titulo#</h4>
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
	                <textarea name="vComentario" id="vComentario" cols="100" rows="5" class="form-control">#vComentario#</textarea>
					<input name="vSolId" id="vSolId" type="hidden" value="#sol_id#" />
                </form>
			</div>
			<div class="modal-footer">
				<button id="CierraModalAbajo" type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
			</div>
		</cfoutput>
