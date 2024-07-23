/* CREADO: ARAM PICHARDO DURÁN */
/* EDITO: ARAM PICHARDO DURÁN */
/* FECHA CREA: 20/05/2019 */
/* FECHA ÚLTIMA MOD.: 30/08/2022 */
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
/*
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
*/                    
            }
		}
		// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
		xmlHttp.open("POST", "coa_lista.cfm", true);
		xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
		// Crear la lista de parámetros:
		parametros = "vAppConCoaMenu=" + $('#vAppConCoaMenu').val();
        parametros += "&vpDepClave=" + $('#selDepClave').val();
		parametros += "&vpNoPlaza=" + $('#txtBuscaNoPlaza').val();
		parametros += "&vpSsnId=" + $('#txtBuscaSsnId').val();
        parametros += "&vpNoGaceta=" + $('#txtBuscaNoGaceta').val();
		parametros += "&vRPP=" + $('#vRPP').val();
		parametros += "&vPagina=" + encodeURIComponent(vPagina);
		// Enviar la petición HTTP:
		xmlHttp.send(parametros);
	}

    // AJAX para limpiar los filtros (30/08/2022)
	function fLimpiafiltros()
	{
        //window.location = 'java_script/ajax_limpiafiltros.cfm';
		var xmlHttp = XmlHttpRequest();
		// Función de atención a las petición HTTP:
		xmlHttp.onreadystatechange = function(){
			//alert(xmlHttp.readyState);
			if (xmlHttp.readyState == 4) {
                window.location.reload();
            }
		}
		// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
		xmlHttp.open("POST", "java_script/ajax_limpiafiltros.cfm", true);
		xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
		parametros = "";
		// Enviar la petición HTTP:
		xmlHttp.send(parametros);
	}
    

