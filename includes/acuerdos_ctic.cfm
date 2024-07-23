		<!--- CREADO: ARAM PICHARDO --->
        <!--- EDITO: ARAM PICHARDO DURÁN --->
        <!--- FECHA CREA: 25/05/2017 --->
        <!--- FECHA ULTIMA MOD.: 25/05/2016 --->

        <!--- PÁGINA DE INICIO PARA LISTAR LOS ACUERDOS DEL CTIC --->

		<script type="text/javascript">
			function fListaAcuerdos(vPagina)
			{
				//alert('HOLA ACUERDOS');
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Función de atención a las petición HTTP:
				xmlHttp.onreadystatechange = function(){
					if (xmlHttp.readyState == 4) {
						document.getElementById('acuerdos_dynamic').innerHTML = xmlHttp.responseText;
						document.getElementById('vRegRan_dynamic').innerHTML = document.getElementById('vRegRan').value;
						document.getElementById('vRegTot_dynamic').innerHTML = document.getElementById('vRegTot').value;						
					}
				}
				// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
				xmlHttp.open("POST", "../includes/acuerdos_ctic_lista.cfm", true);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "vpTipoAcceso=PLENOCTIC";
				//parametros += "&vAcadNom=" + encodeURIComponent(document.getElementById('vAcadNom').value);
				parametros += "&vPagina=" + encodeURIComponent(vPagina);
				parametros += "&vRPP=" + encodeURIComponent(document.getElementById('vRPP').value);
				if (document.getElementById('txtBuscaTexto').value.length >= 5)
				{
					parametros += "&vpBuscaTexto=" +  encodeURIComponent(document.getElementById('txtBuscaTexto').value);
				}
				else {parametros += "&vpBuscaTexto="}
				if (document.getElementById('txtSsnId').value.length >= 2) 
				{
					parametros += "&vpSsnId=" +  encodeURIComponent(document.getElementById('txtSsnId').value);
				}
				else {parametros += "&vpSsnId="}
				//parametros += "&PageNum_tbConsejeros=" + encodeURIComponent(document.getElementById('NumPagina').value);
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);
			}
		</script>
		
		<div class="container-fluid text-center">    
			<div class="row content">
				<div class="col-sm-2 sidenav text-left visible-md visible-lg">
                    <div class="panel panel-default">
						<div class="panel-heading">
							<label>MEN&Uacute;</label>
						</div>
						<div class="panel-body">
                        	<cfoutput>
							<form class="form-inline">
								<label for="busqueda">B&uacute;squeda por texto:</label>
								<input id="txtBuscaTexto" type="text" class="form-control" onkeyup="fListaAcuerdos(1);">
							</form>
							</cfoutput>						
						</div>
						<div class="panel-body">
                        	<cfoutput>
							<form class="form-inline">
								<label for="busqueda">Filtrar por acta:</label>
								<input type="text" class="form-control" id="txtSsnId" onkeyup="fListaAcuerdos(1);" size="4">
							</form>
							</cfoutput>
						</div>
						<div class="panel-body text-left">
							<!--- Selección de número de registros por página --->
                            <cfmodule template="#vCarpetaINCLUDE#/registros_pagina_bs.cfm" filtro="AcuerdosCticFiltro" funcion="fListaAcuerdos" ordenable="no">
						</div>
						<div class="panel-footer">
							<!--- Contador de registros --->
                            <cfmodule template="#vCarpetaINCLUDE#/contador_registros_bs.cfm">
                            <input type="hidden" value="<cfoutput>#Session.AcuerdosCticFiltro.vRPP#</cfoutput>"  name="vRPP" id="vRPP">
						</div>
                    </div>
				</div>
				<div class="col-sm-10 text-left">
					<div id="acuerdos_dynamic" class="col-sm-12">
						<!-- DIV PARA DESPLEGAR EL AJAX CON EL LISTADO DE INFORMACIÓN -->						
                    </div>
				</div>
			</div>
		</div>        