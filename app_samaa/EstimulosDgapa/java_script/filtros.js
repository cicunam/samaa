/* CREADO: ARAM PICHARDO DURÁN */
/* EDITO: ARAM PICHARDO DURÁN */
/* FECHA CREA: 29/05/2019 */
/* FECHA ÚLTIMA MOD.: 29/05/2019 */
/* AJAX CON JQUERY */

	function fBuscaTexto()
	{
		if (event.keyCode == 13 && ($('#txtBuscaAcad').val() != '' || $('#txtBuscaSsnId').val() != '' || $('#txtBuscaOficio').val() != ''))
		{
			//alert($('#txtBuscaTexto').val());
			event.preventDefault();
			//event.stopImmediatePropagation();
			fListarRegistros(1);
		}
	}
		
	function fMarcaFiltros()
	{
		if ($('#selDepClave').val() != '')
			{$('#spanFiltroEntidad').css("color", "#FF6600");}
		else
			{$('#spanFiltroEntidad').css("color", "");}

		if ($('#txtNoPlaza').val() != '')
			{$('#spanFiltroNoPlaza').css("color", "#FF6600");}
		else
			{$('#spanFiltroNoPlaza').css("color", "");}
        
		if ($('#txtSsnId').val() != '')
			{$('#spanFiltroSsn').css("color", "#FF6600");}
		else
			{$('#spanFiltroSsn').css("color", "");}
        
		if ($('#txtNoGaceta').val() != '')
			{$('#spanFiltroGaceta').css("color", "#FF6600");}
		else
			{$('#spanFiltroGaceta').css("color", "");}
/*        
		if ($('#selCnClave').val() != '')
			{$('#selCnClave').css("color", "#FF6600");}
		else
			{$('#selCnClave').css("color", "");}
*/            
	}
	
	function fLimpiaFiltros()
	{
		$('#selDepClave').val('');
		$('#txtNoPlaza').val('');
		$('#txtSsnId').val('');
		$('#txtNoGaceta').val('');        
		// $('#selCnClave').val('');
		fListarRegistros(1);		
	}