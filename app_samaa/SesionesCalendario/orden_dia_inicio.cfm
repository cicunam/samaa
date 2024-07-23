		<cfset vNuevoRegistro = 0>
        <cfset vAnio = 0>
        
        <cfif NOT IsDefined('Session.sTipoSesionCel') OR #Session.sTipoSesionCel# EQ '' OR #Session.sTipoSesionCel# EQ 'P'>
            <cfset Session.sTipoSesionCel = 'O'>
        </cfif>

		<cfif NOT IsDefined('Session.OrdenDiaFiltro')>
            <!--- Crear un arreglo para guardar la información del filtro --->
            <cfscript>
                OrdenDiaFiltro = StructNew();
                OrdenDiaFiltro.vOrden = 'ssn_id';
                OrdenDiaFiltro.vAnioConsulta = 0;
                OrdenDiaFiltro.vOrdenDir = 'ASC';
                OrdenDiaFiltro.vPagina = '1';
                OrdenDiaFiltro.vRPP = '25';
            </cfscript>
            <cfset Session.OrdenDiaFiltro = '#OrdenDiaFiltro#'>
        </cfif>

		<!--- JAVA SCRIPT --->
		<script type="text/javascript">
			function fListarOrdenDia(vPagina)
			{
				//window.location = 'sesiones_lista.cfm?vTipoSesionCel=' + vValorTipoSes
				//if (document.getElementById('vTipoSesionO').checked) document.getElementById('trSemestre').style.display = '';
				//if (document.getElementById('vTipoSesionE').checked) document.getElementById('trSemestre').style.display = 'none';
				// Icono de espera:
				document.getElementById('ordendia_dynamic').innerHTML = "<img src=\"<cfoutput>#vCarpetaIMG#</cfoutput>/wait.gif\" style=\"display:block; margin:auto;\">";
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Función de atención a las petición HTTP:
				xmlHttp.onreadystatechange = function(){
					if (xmlHttp.readyState == 4) {
						document.getElementById('ordendia_dynamic').innerHTML = xmlHttp.responseText;
						document.getElementById('vRegRan_dynamic').innerHTML = document.getElementById('vRegRan').value;
						document.getElementById('vRegTot_dynamic').innerHTML = document.getElementById('vRegTot').value;
					}
				}
				// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
				xmlHttp.open("POST", "orden_dia_lista.cfm", true);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "vpAnio=" + encodeURIComponent(document.getElementById('vAnio').value);
				parametros += "&vRPP=" + encodeURIComponent(document.getElementById('vRPP').value);
				if (document.getElementById('vTipoSesionO').checked) parametros += "&vpSesionTipo=O";
				if (document.getElementById('vTipoSesionE').checked) parametros += "&vpSesionTipo=E";
				parametros += "&vPagina=" + encodeURIComponent(vPagina);
				//parametros += "&PageNum_tbConsejeros=" + encodeURIComponent(document.getElementById('NumPagina').value);
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);
			}
		</script>

		<div class="container-fluid text-center" style="margin:5px;">    
			<div class="row content">
				<div class="col-sm-2 sidenav text-left visible-md visible-lg">
					<div class="panel-group">
                        <div class="panel panel-primary">
                            <div class="panel-heading">
                                <label>MEN&Uacute;</label>
                            </div>
                            <div class="panel-body">
                                <label class="control-label text-left" for="lblVerSes">Ver sesiones:</label><br>                                
                                <cfoutput>
                                    <input type="radio" name="vTipoSesion" id="vTipoSesionO" value="O" onClick="fListarOrdenDia(#Session.OrdenDiaFiltro.vPagina#);" <cfif #Session.sTipoSesionCel# EQ "O">checked="checked"</cfif>> <span class="Sans10Ne">Ordinarias</span><br>
                                    <input type="radio" name="vTipoSesion" id="vTipoSesionE" value="E" onClick="fListarOrdenDia(#Session.OrdenDiaFiltro.vPagina#);" <cfif #Session.sTipoSesionCel# EQ "E">checked="checked"</cfif>> <span class="Sans10Ne">Extraordinarias</span><br>
                                </cfoutput>
							</div>
                        </div>
                        <div class="panel panel-info">
                            <div class="panel-heading">
                                <label>FILTROS</label>
                            </div>
                            <div class="panel-body">
                                <cfform name="frmAnio">
                                    <label class="control-label text-left" for="lblAnio">A&ntilde;o:</label>
                                    <cfselect name="vAnio" id="vAnio" query="tbCatalogoAnios" queryPosition="below" selected="#Session.OrdenDiaFiltro.vAnioConsulta#" display="vAnios" label="vAnios" onChange="fListarOrdenDia(#Session.OrdenDiaFiltro.vPagina#);" class="form-control">
                                        <option value="0">TODOS</option>
                                    </cfselect>
                                </cfform>
                            </div>
                            <div class="panel-body">
                                <!--- Selección de número de registros por página --->
                                <cfmodule template="#Application.vCarpetaRaizLogica#/includes/registros_pagina_bs.cfm" filtro="OrdenDiaFiltro" funcion="fListarOrdenDia" ordenable="no">
                                <!--- Contador de registros --->
                                <cfmodule template="#Application.vCarpetaRaizLogica#/includes/contador_registros_bs.cfm">
                            </div>
                        </div>
                    </div>
				</div>
				<div class="col-sm-10 text-left">
					<div id="ordendia_dynamic" class="col-sm-12">
						<!-- DIV PARA DESPLEGAR EL AJAX CON EL LISTADO DE INFORMACIÓN -->						
                    </div>
				</div>
			</div>
		</div> 