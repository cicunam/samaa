// CREADO: ARAM PICHARDO DURÁN
// EDITO: ARAM PICHARDO DURÁN
// FECHA CREA: 11/08/2021
// FECHA ÚLTIMA MOD.: 30/08/2022
// AJAX CON JQUERY


	function fBuscaTexto()
	{
		if (event.keyCode == 13 && ($('#txtBuscaNoPlaza').val() != '' || $('#txtBuscaSsnId').val() != '' || $('#txtBuscaNoGaceta').val() != ''))
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

        if ($('#txtBuscaNoPlaza').val() != '')
			{$('#spanFiltroNoPlaza').css("color", "#FF6600");}
		else
			{$('#spanFiltroNoPlaza').css("color", "");}
        
        if ($('#txtBuscaSsnId').val() != '')
			{$('#spanFiltroSsn').css("color", "#FF6600");}
		else
			{$('#spanFiltroSsn').css("color", "");}
        
        if ($('#txtBuscaNoGaceta').val() != '')
			{$('#spanFiltroGaceta').css("color", "#FF6600");}
		else
			{$('#spanFiltroGaceta').css("color", "");}        
	}
	
	function fLimpiaFiltros()
	{
		$('#selDepClave').val('');
		$('#txtBuscaAcad').val('');
		$('#selCnClave').val('');
		$('#selPrideClave').val('');
		$('#txtBuscaSsnId').val('');
		$('#txtBuscaOficio').val('');
		fListarRegistros(1);		
	}
