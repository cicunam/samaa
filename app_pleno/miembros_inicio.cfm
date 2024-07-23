		<!--- CREADO: ARAM PICHARDO --->
        <!--- EDITO: ARAM PICHARDO DURÁN --->
        <!--- FECHA CREA: 16/05/2017 --->
        <!--- FECHA ULTIMA MOD.: 06/12/2023 --->

        <!--- PÁGINA DE INICIO DE MIEMBROS DEL CTIC --->
        

		<!--- Obtener información del catálogo de categoría y nivel (CATÁLOGOS GENERALES MYSQL) --->
        <cfquery name="ctEntidad" datasource="#vOrigenDatosCATALOGOS#">
            SELECT dep_clave, dep_nombre 
            FROM catalogo_dependencias
            WHERE dep_clave LIKE '03%' 
            AND (dep_tipo = 'CEN' OR dep_tipo = 'INS')
            AND dep_status = 1 
            ORDER BY dep_orden
        </cfquery>
        
        <cfquery name="tbPresidente" datasource="#vOrigenDatosSAMAA#">
            SELECT 
            T2.acd_prefijo, 
            (
                ISNULL(dbo.SINACENTOS(acd_nombres),'') + 
                CASE WHEN acd_nombres IS NULL THEN '' ELSE ' ' END + 
                ISNULL(dbo.SINACENTOS(acd_apepat),'') + 
                CASE WHEN acd_apepat IS NULL THEN '' ELSE ' ' END + 
                ISNULL(dbo.SINACENTOS(acd_apemat),'')
            ) AS nombre ,
            T1.caa_email,
            T2.acd_sexo
            FROM academicos_cargos AS T1
            LEFT JOIN academicos AS T2 ON T1.acd_id = T2.acd_id
            WHERE T1.caa_status = 'A'
            AND T1.adm_clave = '84'
        </cfquery>
        
        <cfquery name="tbConsejerosTec" datasource="#vOrigenDatosSAMAA#">
            SELECT 
            T2.acd_prefijo, 
            (
                ISNULL(dbo.SINACENTOS(acd_nombres),'') + 
                CASE WHEN acd_nombres IS NULL THEN '' ELSE ' ' END + 
                ISNULL(dbo.SINACENTOS(acd_apepat),'') + 
                CASE WHEN acd_apepat IS NULL THEN '' ELSE ' ' END + 
                ISNULL(dbo.SINACENTOS(acd_apemat),'')
            ) AS nombre ,
            T1.caa_email
            FROM academicos_cargos AS T1
            LEFT JOIN academicos AS T2 ON T1.acd_id = T2.acd_id
            WHERE T1.caa_status = 'A'
            AND T1.adm_clave = '13'
            ORDER BY T1.adm_clave DESC
        </cfquery>

		<script type="text/javascript">
			function fSesionFiltro()
			{
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Función de atención a las petición HTTP:
				xmlHttp.onreadystatechange = function(){
					if (xmlHttp.readyState == 4) {
						document.getElementById('miembros_dynamic').innerHTML = xmlHttp.responseText;
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
<!---
                        	<cfoutput>
							<label>VER CALENDARIO DEL:</label><br>
							</cfoutput>
--->
						</div>
                    </div>
				</div>
				<div class="col-sm-10 text-left">
					<div id="miembros_dynamic" class="col-sm-12">
						<h4><strong>PRESIDENT<cfif #tbPresidente.acd_sexo# EQ 'F'>A<cfelse>E</cfif></strong></h4>
						<h4>
							<cfoutput query="tbPresidente">
								#acd_prefijo# #nombre#<br />
                                #caa_email#
							</cfoutput>
						</h4>
						<hr>
						<div class="row content text-center small">
							<ol class="breadcrumb" style="background-color:#FF9;">
								<li><h4><strong>CONSEJEROS</strong></h4></li>
							</ol>
						</div>                        
						
						<!-- DIV PARA DESPLEGAR EL AJAX CON EL LISTADO DE INFORMACIÓN -->
                        <table class="table table-striped table-hover">
                            <thead>
                                <tr class="header">
                                    <td width="34%"><strong>Entidad acad&eacute;mica</strong></td>
                                    <td width="33%"><strong>Consejera directora / Consejero director</strong></td>
                                    <td width="33%"><strong>Consejera representante / Consejero representante</strong></td>
                                </tr>
                            </thead>
                            <tbody>
								<cfoutput query="ctEntidad">                            
                                    <!--- QUERY PARA DESPLEGAR INFORMACIÓN --->
                                    <cfquery name="tbConsejeros" datasource="#vOrigenDatosSAMAA#">
                                        SELECT 
                                        T2.acd_prefijo, 
										(
                                            ISNULL(dbo.SINACENTOS(acd_nombres),'') + 
                                            CASE WHEN acd_nombres IS NULL THEN '' ELSE ' ' END + 
                                            ISNULL(dbo.SINACENTOS(acd_apepat),'') + 
                                            CASE WHEN acd_apepat IS NULL THEN '' ELSE ' ' END + 
                                            ISNULL(dbo.SINACENTOS(acd_apemat),'')
										) AS nombre ,
                                        T1.caa_email
                                        FROM academicos_cargos AS T1
                                        LEFT JOIN academicos AS T2 ON T1.acd_id = T2.acd_id
                                        WHERE T1.caa_status = 'A'
                                        AND (T1.adm_clave = '32' OR T1.adm_clave = '01')
                                        AND T1.dep_clave = '#ctEntidad.dep_clave#'
                                        ORDER BY T1.adm_clave DESC
                                    </cfquery>
									 
                                    <tr>
                                        <td class="small">#dep_nombre#</td>
                                        <td class="small">
											#tbConsejeros.acd_prefijo# #tbConsejeros.nombre#<br />
                                            #tbConsejeros.caa_email#
										</td>
										<td class="small">
                                        	<cfloop query="tbConsejeros" startrow="2" endrow="2">
												#tbConsejeros.acd_prefijo# #tbConsejeros.nombre#<br />
	                                            #tbConsejeros.caa_email#
                                            </cfloop>
										</td>
                                    </tr>
								</cfoutput>
							</tbody>
						</table>
						<hr />
						<div class="row content text-center">
							<ol class="breadcrumb" style="background-color:#FF9;">
								<li><h4><strong>CONSEJEROS REPRESENTANTES DE LOS T&Eacute;CNICOS ACAD&Eacute;MICOS DEL SIC</strong></h4></li>
							</ol>
						</div>
                        <table class="table table-striped table-hover">
                            <thead>
                                <tr class="header">
                                    <td width="34%"align="center"></td>
                                    <td width="33%"align="center"></td>
                                    <td width="33%"align="center"></td>                                                                        
                                </tr>
                            </thead>
                            <tbody>
    							<cfoutput query="tbConsejerosTec">
								<tr>
                                    <td align="center"></td>
									<td class="small">
                                        #acd_prefijo# #nombre#<br />
                                        #caa_email#
									</td>
                                    <td align="center"></td>
								</tr>
							</cfoutput>
							</tbody>
						</table>
						<hr />
						<div class="row content text-center">
							<ol class="breadcrumb" style="background-color:#FF9;">
								<li><h4><strong>INVITADOS</strong></h4></li>
							</ol>
						</div>
						<!--- QUERY PARA DESPLEGAR INFORMACIÓN --->
                        <cfquery name="tbInvitados" datasource="#vOrigenDatosSAMAA#">
							SELECT 
							T2.acd_prefijo, 
							(
                                ISNULL(dbo.SINACENTOS(acd_nombres),'') + 
                                CASE WHEN acd_nombres IS NULL THEN '' ELSE ' ' END + 
                                ISNULL(dbo.SINACENTOS(acd_apepat),'') + 
                                CASE WHEN acd_apepat IS NULL THEN '' ELSE ' ' END + 
                                ISNULL(dbo.SINACENTOS(acd_apemat),'')
							) AS nombre ,
							T1.caa_email,
							'DIRECCI&Oacute;N GENERAL DE DIVULGACI&Oacute;N DE LA CIENCIA' AS dep_nombre
							FROM academicos_cargos AS T1
							LEFT JOIN academicos AS T2 ON T1.acd_id = T2.acd_id
							WHERE T1.caa_status = 'A'
							AND T1.adm_clave = '32'
							AND T1.dep_clave = '032602'
							ORDER BY T1.adm_clave DESC
                        </cfquery>

                        <table class="table table-striped table-hover">
                            <thead>
                                <tr class="header">
                                    <td width="34%"><strong>Entidad</strong></td>
                                    <td width="66%"><strong>Director</strong></td>
                                </tr>
                            </thead>
                            <tbody>
								<cfoutput query="tbInvitados">                            
                                    <tr>
                                        <td class="small">#dep_nombre#</td>
                                        <td class="small">
											#acd_prefijo# #nombre#<br />
                                            #caa_email#
										</td>
                                    </tr>
								</cfoutput>
							</tbody>
						</table>                        
                    </div>
				</div>
			</div>
		</div>