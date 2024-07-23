<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 27/10/2017 --->
<!--- FECHA ÚLTIMA MOD.: 27/10/2017 --->

<script language="JavaScript" type="text/JavaScript">
	function fValidaCamposCancela()
	{
		var vOk;
		var vMensaje = '';
		fLimpiaValida();
		if ($('#mov_cancelado').val() == 1) vMensaje = fValidaCampoLleno('fecha_cancelacion', 'FECHA DE CANCELACIÓN ES OBLIGATORIO');
		if (vMensaje.length > 0) 
		{
			alert(vMensaje);
			return false;
		}
		else
		{
			$.ajax({
				url: "mov_ajax/cancela_movimiento_guarda.cfm",
				type:'POST',
				async: false,
				data: new FormData($('#frmCancelaMov')[0]),
				processData: false,
				contentType: false,
				success: function(data) {
					alert(data);
					$('#divCancelaMov_jquery').dialog('close');
				},
				error: function(data) {
					alert('ERROR AL CANCELAR EL MOVIMIENTO');
					$('#divCancelaMov_jquery').dialog('close');
				},
			});
		}				
	}
</script>


<cfform id="frmCancelaMov" name="frmCancelaMov">
	<p>
		<cfinput type="hidden" id="sol_id" name="sol_id" value="#vSolId#">
		<cfinput type="hidden" id="mov_cancelado" name="mov_cancelado" value="#vValorChk#">
	</p>
	<cfif #vValorChk# EQ 1>
		<p>
			<div style="width:25%; float:left;">Fecha de cancelaci&oacute;n</div>
			<div style="width:75%;"><cfinput type="text" name="fecha_cancelacion" id="fecha_cancelacion" value="" size="10" maxlength="10" onkeypress="return MascaraEntrada(event, '99/99/9999');"></div>
		</p>
		<p>
			<div style="width:25%; float:left;">N&uacute;mero de oficio</div>
			<div style="width:75%; float:left;"><cfinput name="mov_cancelado_oficio"  id="mov_cancelado_oficio" value="" size="50" maxlength="150"></div>
<!---
			<div style="width:25%; float:left;">Observaciones</div>
			<div style="width:75%;"><cftextarea name="mov_observaciones" cols="60" rows="3" id="mov_observaciones" value=""></cftextarea></div>
--->
		</p>
	<cfelseif #vValorChk# EQ 0>
		<p>&nbsp;</p>
       	<p>
			<div style="width:100%;" align="center">El movimiento cambiar&aacute; el starus de <strong>CANCELADO</strong> a <strong>ACTIVO</strong> nuevamente</div>
		</p>
		<p>&nbsp;</p>
	</cfif>
	<br /><br />
	<p align="center">
		<cfinput type="button" id="cmdCancelar" name="cmdCancelar" value="Enviar" onClick="fValidaCamposCancela();">
	</p>
</cfform>
