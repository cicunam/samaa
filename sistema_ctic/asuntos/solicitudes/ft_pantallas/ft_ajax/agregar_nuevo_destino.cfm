<!--- CREADO: ARAM PICHARDO--->
<!--- EDITO: ARAM PICHARDO--24/06/2016 --->
<!--- FECHA ÚLTIMA MOD.: 24/06/2016 --->
<!--- COMPLEMENTO DE FORMA TELEGRAMICA CON UN JQUERY PARA AGREGAR NUEVOS DESTINOS EN DIFERENTES FT'S --->
		<cfparam name="vIdSol" default="">
		<cfparam name="vIdAcad" default="">
		<cfparam name="vComandoDestino" default="">

		<!--- Obtener datos del catalogo de países  (CATÁLOGOS GENERALES MYSQL) --->
        <cfquery name="ctPais" datasource="#vOrigenDatosCATALOGOS#">
            SELECT * FROM catalogo_paises
            ORDER BY pais_nombre
        </cfquery>
		
		<script language="JavaScript" type="text/JavaScript">        
            // Obtener la lista de estados de un país:
            function ObtenerEstadosDestino()
            {
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Función de atención a las petición HTTP:
				xmlHttp.onreadystatechange = function(){
					if (xmlHttp.readyState == 4) {
						document.getElementById('estados_dynamic').innerHTML = xmlHttp.responseText;
					}
				}
				// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
				xmlHttp.open("POST", "ft_ajax/lista_estados.cfm", true);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "vPais=" + encodeURIComponent(document.getElementById('pais_clave').value); 
				parametros += "&vActivaCampos=";
				parametros += "&vCampoPos11_e=";
				parametros += "&vFt=";
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);
            }
			
			<!-- CREADO: ARAM PICHARDO -->
			<!-- EDITO: ARAM PICHARDO -->
			<!-- FECHA: 24/06/2016 -->
			<!-- FUNCION QUE VALIDA LOS CAMPOS DE DESTINO Y QUE SEAN OBLIGATORIOS  -->
		
			function fValidaCamposDestinoForm()
			{
				// No es necesario para las FT-CTIC-21 y FT-CTIC-30:
				document.getElementById("des_institucion").style.backgroundColor = '#FFFFFF';
				document.getElementById("pais_clave").style.backgroundColor = '#FFFFFF';			
				document.getElementById("edo_clave").style.backgroundColor = '#FFFFFF';
				document.getElementById("des_ciudad").style.backgroundColor = '#FFFFFF';
				// Validación:	
				var vSumaError = '';
				if (document.getElementById('des_institucion').value == '')
				{
					document.getElementById("des_institucion").style.backgroundColor = '#FC8C8B';
					vSumaError += 'Campo: INSTITUCIÓN es obligarorio.\n';
				}
				if (document.getElementById('pais_clave').value == '')
				{
					document.getElementById("pais_clave").style.backgroundColor = '#FC8C8B';
					vSumaError += 'Campo: PAÍS es obligarorio.\n';
				}
				if ((document.getElementById('pais_clave').value == 'MEX' || document.getElementById('pais_clave').value == 'USA') &&  document.getElementById('edo_clave').value == '')
				{
					document.getElementById("edo_clave").style.backgroundColor = '#FC8C8B';
					 vSumaError += 'Campo: ESTADO / PROVINCIA es obligarorio.\n';
				}
				if (document.getElementById('des_ciudad').value == '')
				{
					document.getElementById("des_ciudad").style.backgroundColor = '#FC8C8B';
					 vSumaError += 'Campo: CIUDAD es obligarorio.\n';
				}
				// Realizar la acción correspondeitne:			
				if (vSumaError.length > 0)
				{	
					alert(vSumaError);
					return false; 	// Necesario para las FT-CTIC-21 y FT-CTIC-30
				}	
				else
				{
				document.getElementById('vComandoDestino').click();
//					alert('GUARDA REGISTRO');
				}
			}			
		</script>
		<!-- JQUERY -->
		<script language="JavaScript" type="text/JavaScript">
            $(function() {
               $('#vComandoDestino').click(function(){
					$.ajax({
						url: "ft_ajax/lista_destinos.cfm",
						type:'POST',
						async: false,
						data: new FormData($('#frmNuevoDestino')[0]),
						processData: false,
						contentType: false,
						success: function(data) {
//							alert(data);
							window.self.fListaDestino();
							alert('EL DESTINO SE AGRAGÓ CORRECTAMENTE');
		                    $('#formularioDestino_jquery').dialog('close');
						},
						error: function(data) {
							alert('ERROR AL AGREGAR EL DESTINO');
		                    $('#formularioDestino_jquery').dialog('close');
//							location.reload();
						},
					});
				});
            });
        </script>
    </head>
    <body>
		<!-- FORMULARIO PARA AGREGAR INSTITUCIONES (INICIA) -->
		<cfform id="frmNuevoDestino" name="frmNuevoDestino">
            <table width="100%" border="0">
                <!-- País -->
                <tr id="frmPais">
					<td width="30%"><span class="Sans9GrNe">País</span></td>
					<td width="70%">
						<cfselect name="pais_clave" id="pais_clave" class="datos" query="ctPais" queryPosition="below" display="pais_nombre" value="pais_clave" onchange="ObtenerEstadosDestino();">
							<option value="">SELECCIONE</option>
						</cfselect>
					</td>
                </tr>
                <!-- Estado -->
                <tr id="frmEstado">
					<td><span class="Sans9GrNe">Estado / Provincia</span></td>
					<td>
                    	<div id="estados_dynamic"><!-- AJAX PARA DESPLEGAR CIUDADES DE MÉXICO Y USA --></div>
					</td>
                </tr>
                <!-- Ciudad -->
				<tr id="frmCiudad">
					<td><span class="Sans9GrNe">Ciudad</span></td>
					<td><cfinput name="des_ciudad" id="des_ciudad" type="text" class="datos" size="50" maxlength="254"></td>
				</tr>
                <!-- Institución -->
                <tr id="frmInstitucion">
					<td><span class="Sans9GrNe">Institución</span></td>
					<td>
						<cfinput name="des_institucion" id="des_institucion" type="text" class="datos" size="80" maxlength="254">
                        <div id="ListaInstitucion_jquery"></div>
					</td>
                </tr>                
                <!-- Botones -->
				<tr id="frmBotones">
					<td colspan="2" align="center">
						<cfinput name="cmdAgregaDestino" type="button" class="botonesStandar" id="cmdAgregaDestino" value="AGREGAR" onclick="fValidaCamposDestinoForm();">
						<cfinput name="vIdSol" id="vIdSol" type="hidden" value="#vIdSol#">
						<cfinput name="vIdAcad" id="vIdAcad" type="hidden" value="#vIdAcad#">
						<cfinput name="vComandoDestino" id="vComandoDestino" type="hidden" value="INSERTA">
					</td>
				</tr>
            </table>
		</cfform>
