		<!--- CREADO: ARAM PICHARDO --->
        <!--- EDITO: ARAM PICHARDO DURÁN --->
        <!--- FECHA CREA: 16/05/2017 --->
        <!--- FECHA ULTIMA MOD.: 16/05/2016 --->

        <!--- PÁGINA DE INICIO DE CALENDARIO DE SESIONES --->

		<cfset vMes = val(LsDateFormat(now(),"mm"))>
		<cfset vAnio = val(LsDateFormat(now(),"yyyy"))>
        
		<script type="text/javascript">
			function fSesionFiltro()
			{
				//alert('HOLA CALENDARIO');
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Función de atención a las petición HTTP:
				xmlHttp.onreadystatechange = function(){
					if (xmlHttp.readyState == 4) {
						document.getElementById('calendario_dynamic').innerHTML = xmlHttp.responseText;
					}
				}
				// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
				xmlHttp.open("POST", "calendario_lista.cfm", true);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "vpAnio=" + encodeURIComponent(document.getElementById('vAnio').value);
				if (document.getElementById('vSemestre1').checked) parametros += "&vpSemestre=1";
				if (document.getElementById('vSemestre2').checked) parametros += "&vpSemestre=2";
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

						</div>
						<div class="panel-body">
                        	<cfoutput>
							<label>VER CALENDARIO DEL:</label><br>
							<input type="checkbox" name="vSemestre" id="vSemestre1" value="1" onClick="fSesionFiltro();" <cfif #vMes# LT 7>checked</cfif>> Primer semestre<br>
							<input type="checkbox" name="vSemestre" id="vSemestre2" value="2" onClick="fSesionFiltro();" <cfif #vMes# GT 6>checked</cfif>> Segundo semestre
                            <input type="hidden" name="vAnio" id="vAnio" value="#vAnio#">
							</cfoutput>
						</div>
                    </div>
				</div>
				<div class="col-sm-10 text-left">
					<div id="calendario_dynamic" class="col-sm-12">
						<!-- DIV PARA DESPLEGAR EL AJAX CON EL LISTADO DE INFORMACIÓN -->						
                    </div>
				</div>
			</div>
		</div>