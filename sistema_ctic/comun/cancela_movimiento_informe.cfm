<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 06/09/2023 --->
<!--- FECHA ÚLTIMA MOD.: 06/09/2023 --->
<!--- PANTALLA PARA CANCELAR MOVIMINIENTOS DE SOLICITUDES / INFORMES ANUALES --->

<script language="JavaScript" type="text/JavaScript">
	function fValidaCamposCancela()
	{
		var vOk;
		var vMensaje = '';
		//fLimpiaValida();
		if ($('#mov_cancelado').val() == 1) vMensaje = fValidaCampoLleno('fecha_cancelacion', 'FECHA DE CANCELACIÓN ES OBLIGATORIO');
		if (vMensaje.length > 0) 
		{
			alert(vMensaje);
			return false;
		}
		else
		{
			$.ajax({
				url: "../../comun/cancela_movimiento_informe_guarda.cfm",
				type:'POST',
				async: false,
				data: new FormData($('#frmCancelaMov')[0]),
				processData: false,
				contentType: false,
				success: function(data) {
					alert(data);
					$('#divCancelaMovInf_jquery').dialog('close');
				},
				error: function(data) {
					alert('ERROR AL CANCELAR EL REGISTRO');
					$('#divCancelaMovInf_jquery').dialog('close');
				},
			});
		}				
	}
    
    
	/* CREADO: JOSE ANTONIO ESTEVA */
	/* EDITO: JOSE ANTONIO ESTEVA */
	/* FECHA: 24/03/2009*/
	/* FUNCION PARA APLICAR MASCASAR DE ENTRADA */
	/* ****** OJO, REEMPLAZAR POR EL CÓDIGO COMÚN  ***** */
	function MascaraEntrada(e, mascara) 
	{
		var codigo;
		var origen;
		var posicion;
		var filtro;
		// Acceso a objeto de evento:
		if (!e) var e = window.event;
		// Detectar el objeto que originó el evento: 
		if (e.target) origen= e.target;
		else if (e.srcElement) origen = e.srcElement;
		if (origen.nodeType == 3) origen = targ.parentNode;
		// Obtener el código de la tecla oprimida:
		if (e.keyCode) codigo = e.keyCode;
		else if (e.which) codigo = e.which;
		// Dejar pasar teclas para borrar y saltar al siguiente campo (pueden ser más):
		if (codigo == 8 || codigo == 9 || codigo == 46) return true;
		// Obtener la posición donde se está capturando y su máscara correspondiente: 
		posicion = origen.value.length;
		// Si en la posición actual hay un delimitador agregarlo a la cadena y pasar a la siguiente posición:
		filtro = mascara.charAt(posicion);
		if (filtro!='9' && filtro!='A')
		{
		   origen.value += filtro; 
		   posicion++;
		   filtro = mascara.charAt(posicion); 
		} 
		// Verificar si el carácter tecleado corresponde a la máscara:
		if (filtro == "9" && (codigo >= 48 && codigo <= 57)) return true; 										// Número
		if (filtro == "A" && ((codigo >= 65 && codigo <= 90) || (codigo >= 97 && codigo <= 122))) return true; 	// Letra
		// Sino, no pasa!
		return false;	 
	}    
</script>


<cfform id="frmCancelaMov" name="frmCancelaMov">
	<p>
		<cfinput type="#vTipoInput#" id="registro_id" name="registro_id" value="#vRegistroId#">
		<cfinput type="#vTipoInput#" id="mov_cancelado" name="mov_cancelado" value="#vValorChk#">
		<cfinput type="#vTipoInput#" id="tipo_asunto" name="tipo_asunto" value="#vTipoAsunto#">            
	</p>
	<cfif #vValorChk# EQ 1>
		<p>
			<div style="width:25%; float:left;">Fecha de cancelaci&oacute;n</div>
			<div style="width:75%;"><cfinput type="text" name="fecha_cancelacion" id="fecha_cancelacion" value="" size="10" maxlength="10" onkeypress="return MascaraEntrada(event, '99/99/9999');"></div>
		</p>
		<p>
			<div style="width:25%; float:left;">N&uacute;mero de oficio</div>
			<div style="width:75%; float:left;"><cfinput name="num_cancelado_oficio"  id="num_cancelado_oficio" value="" size="50" maxlength="150"></div>
<!---
			<div style="width:25%; float:left;">Observaciones</div>
			<div style="width:75%;"><cftextarea name="mov_observaciones" cols="60" rows="3" id="mov_observaciones" value=""></cftextarea></div>
--->
		</p>
	<cfelseif #vValorChk# EQ 0>
		<p>&nbsp;</p>
       	<p>
			<div style="width:100%;" align="center">El <cfif #vTipoAsunto# EQ 'MOV'>movimiento<cfelseif #vTipoAsunto# EQ 'INF'>informe anual</cfif> cambiar&aacute; el situaci&oacute;n de <strong>CANCELADO</strong> a <strong>ACTIVO</strong> nuevamente</div>
		</p>
		<p>&nbsp;</p>
	</cfif>
	<br /><br />
	<p align="center">
		<cfinput type="button" id="cmdCancelar" name="cmdCancelar" value="Guardar" onClick="fValidaCamposCancela();">
	</p>
</cfform>
