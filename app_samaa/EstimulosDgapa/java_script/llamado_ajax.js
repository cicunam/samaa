/* CREADO: ARAM PICHARDO DURÁN */
/* EDITO: ARAM PICHARDO DURÁN */
/* FECHA CREA: 20/05/2019 */
/* FECHA ÚLTIMA MOD.: 04/06/2019 */
/* AJAX CON JQUERY */

	/*  ********** AJAX ********** */
	function fListarRegistros(vPagina)
	{
		// Icono de espera:
		document.getElementById("loader").style.display = "block";
		document.getElementById('registros_dynamic').innerHTML = ''
		// Crear un objeto XmlHttpRequest:
		var xmlHttp = XmlHttpRequest();
		// Función de atención a las petición HTTP:
		xmlHttp.onreadystatechange = function(){
//			alert(xmlHttp.readyState);
			if (xmlHttp.readyState == 4) {
				document.getElementById('registros_dynamic').innerHTML = xmlHttp.responseText;
				document.getElementById("loader").style.display = "none";
				document.getElementById('vRegRan_dynamic').innerHTML = document.getElementById('vRegRan').value;
				document.getElementById('vRegTot_dynamic').innerHTML = document.getElementById('vRegTot').value;
				if ($('#vAppEstDgapaMenu').val() != 'subAgSesVig')				
					fMarcaFiltros();
					if (parseInt($('#vRegTot').val()) == '0')
					{
						$('#cmdAsignaNoAcdEst').attr('disabled','disabled'); 
						$('#cmdGenerarListadoPdf').attr('disabled','disabled');
						$('#chkFirmaCoord').attr('disabled','disabled');						
					}
					else
					{
						$('#cmdAsignaNoAcdEst').attr('disabled');
						$('#cmdGenerarListadoPdf').attr('disabled');
						$('#chkFirmaCoord').attr('disabled');						
					}
			}
		}
		// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
		xmlHttp.open("POST", "estimulos_lista.cfm", true);
		xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
		// Crear la lista de parámetros:
		parametros = "vpAppEstDgapaMenu=" + encodeURIComponent($('#vAppEstDgapaMenu').val()); //document.getElementById('vAppConCoaMenu').value
		parametros += "&vpSsnId=" + encodeURIComponent($('#txtBuscaSsnId').val()); //document.getElementById('txtBuscaSsnId').value
		parametros += "&vRPP=" + encodeURIComponent($('#vRPP').val()); //document.getElementById('vRPP').value
		parametros += "&vPagina=" + encodeURIComponent(vPagina);
/*
		parametros += "&vpDepClave=" + encodeURIComponent(document.getElementById('selDepClave').value);
		parametros += "&vpBuscaTexto=" + encodeURIComponent(document.getElementById('txtBuscaTexto').value);
		parametros += "&vpBuscaPalabraClave=" + encodeURIComponent(document.getElementById('txtBuscaPalabraClave').value);		
		parametros += "&vpTipoPublicaClave=" + encodeURIComponent(document.getElementById('vPublicaBoletinClave').value);

*/			
		// Enviar la petición HTTP:
		xmlHttp.send(parametros);
	}

	function fAgregaAcdEst()
	{
		// Icono de espera:
		document.getElementById('agrega_acdest_dynamic').innerHTML = ''
		// Crear un objeto XmlHttpRequest:
		var xmlHttp = XmlHttpRequest();
		// Función de atención a las petición HTTP:
		xmlHttp.onreadystatechange = function(){
//			alert(xmlHttp.readyState);
			if (xmlHttp.readyState == 4) {
				document.getElementById('agrega_acdest_dynamic').innerHTML = xmlHttp.responseText;
			}
		}
		// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
		xmlHttp.open("POST", "ajax/ajax_agrega_acdest.cfm", true);
		xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
		// Crear la lista de parámetros:
		parametros = "vpAcdId=" + encodeURIComponent(document.getElementById('vSelAcad').value);
		parametros += "&vpSsnId=" + encodeURIComponent(document.getElementById('txtBuscaSsnId').value);		
		// Enviar la petición HTTP:
		xmlHttp.send(parametros);
	}
	
	function fAsignaNoOficioAcdEst()
	{
		if ($('#asigna_no_oficio').val().length != 0)
		{
			$.ajax({
				async: false,
				type:'POST',
				url: "ajax/asigna_no_oficio.cfm",
				data: {vpSsnId: $('#txtBuscaSsnId').val(), vpAsignaNoOficio: $('#asigna_no_oficio').val()},
				success: function(data) {
					if (data == '')
						window.location.reload();								
					if (data != '')
						alert('OCURRI&Oacute; UN ERROR AL ASIGNAR EL NUMERO DE OFICIO' + data);
					//fSesionLista();
				},
				error: function(data) {
					alert('ERROR AL ASIGNAR EL NUMERO DE OFICIO' + data);
					//location.reload();
				},
			});
		}
		else
		{alert('INDIQUE EL NúMERO DE OFICIO');}
	}
	
	function fEliminaEstimuloId(vEstimuloId,vNombreAcd)
	{
		$.confirm({
			title: 'Eliminar',
			content: 'Se eliminará el registro de:<br>' + vNombreAcd,
			buttons: {
				confirm: function () {
					$.ajax({
						async: false,
						type:'POST',
						url: "ajax/estimulo_elimina.cfm",
						data: {vpEstimuloId: vEstimuloId},
						success: function(data) {
							if (data == '')
								fListarRegistros(1);
								//window.location.reload();								
							if (data != '')
								alert('OCURRI&Oacute; UN ERROR AL ELIMINAR EL REGISTRO' + data);
						},
						error: function(data) {
							alert('ERROR AL ELIMINAR EL REGISTRO' + data);
						},
					});
				},
				cancel: function () {
				}
			}
		});
	}
	function fGeneraOficiosMsWord()
	{
        //alert($('#selTipoOficios').val());
        if ($('#selTipoOficios').val() != 0)
        {
		  window.open('impresion/estimulos_dgapa_oficios.cfm?vSsnId=' + $('#txtBuscaSsnId').val() + '&vTipoOficio=' + $('#selTipoOficios').val(),'WinOficiosDgapaMsWord')
        }
        else
        {alert('Seleccione que tipo de oficios desea que se generen');}
	}

	function fGeneraListadoXls()
	{
//		alert($('#chkFirmaCoord').is(':checked'))
		window.open('impresion/tabla_pleno_estimulos_xls.cfm?vpSsnId=' + $('#txtBuscaSsnId').val() + '&vFirmaCoord=' + $('#chkFirmaCoord').is(':checked'),'WinListadoDgapa')
	}
	function fGeneraListadoPdf()
	{
//		alert($('#chkFirmaCoord').is(':checked'))
		window.open('impresion/tabla_pleno_estimulos_pdf.cfm?vpSsnId=' + $('#txtBuscaSsnId').val() + '&vFirmaCoord=' + $('#chkFirmaCoord').is(':checked'),'WinListadoDgapa')
	}