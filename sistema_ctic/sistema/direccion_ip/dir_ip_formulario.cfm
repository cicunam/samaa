
        <script language="JavaScript" type="text/JavaScript">
			function fValidaCampos()
			{
				var vOk;
				var vMensaje = '';
				fLimpiaValida();
				vMensaje = fValidaCampoLleno('ip_g_1', 'GRUPO 1');
				vMensaje += fValidaCampoLleno('ip_g_2', 'GRUPO 2');
				vMensaje += fValidaCampoLleno('ip_g_3', 'GRUPO 3');
				vMensaje += fValidaCampoLleno('ip_g_4', 'GRUPO 4');
				if (vMensaje.length > 0) 
				{
					alert(vMensaje);
					return false;
				}
				else
				{
					$.ajax({
						url: "dir_ip_formulario_guarda.cfm",
						type:'POST',
						async: false,
						data: new FormData($('#frmDireccionIp')[0]),
						processData: false,
						contentType: false,
						success: function(data) {
							alert(data);
							if (data != '')
							{
								alert('HA OCURRIDO UN ERROR INESPERADO, FAVOR DE INTENTAR MÁS TARDE');
								$('#divIpFormulario_jquery').dialog('close');
							}
							else
							{
								alert('LA DIRECCIÓN IP SE GUARDO CORRECTAMENTE');
								window.self.fListarDirIp(1);
								$('#divIpFormulario_jquery').dialog('close');
							}
						},
						error: function(data) {
							alert('ERROR AL AGREGAR LA DIRECCIÓN IP');
							$('#divIpFormulario_jquery').dialog('close');
//								location.reload();
						},
					});
				}				
			}
		</script>


    	<cfform id="frmDireccionIp">
			<div style="margin-top:10px;">
                <span class="Sans10NeNe">DIRECCIÓN IP A AGREGAR:</span>
                <cfinput type="text" name="ip_g_1" id="ip_g_1" value="" size="3" maxlength="3" onkeypress="return MascaraEntrada(event, '999');">.
                <cfinput type="text" name="ip_g_2" id="ip_g_2" value="" size="3" maxlength="3" onkeypress="return MascaraEntrada(event, '999');">.
                <cfinput type="text" name="ip_g_3" id="ip_g_3" value="" size="3" maxlength="3" onkeypress="return MascaraEntrada(event, '999');">.
                <cfinput type="text" name="ip_g_4" id="ip_g_4" value="" size="3" maxlength="3" onkeypress="return MascaraEntrada(event, '999');">
                <br />
			</div>
			<div style="margin-top:10px;">
                <span class="Sans10NeNe" style="height:50px">UBICACIÓN:</span>
                <cfinput type="text" name="ubicacion_ip" id="ubicacion_ip" value="" size="60" maxlength="254">
                <br />
			</div>            
			<div align="center" style="margin-top:10px; margin-left:80px; margin-right:80px;">
				<cfinput type="button" value="AGREGAR" name="cmdAgregaIp" id="cmdAgregaIp" onClick="fValidaCampos();" class="botones">
                <cfinput type="hidden" value="N" name="keyGuardaReg" id="keyGuardaReg">
			</div>            
		</cfform>
        <div id=""></div>