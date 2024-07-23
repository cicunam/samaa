<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 16/06/2015 --->
<!--- FECHA ULTIMA MOD.: 14/01/2016 --->
<!--- LISTA DE SESIONES DEL CTIC --->

		<cfset vMes = val(LsDateFormat(now(),"mm"))>
		<cfset vAnio = val(LsDateFormat(now(),"yyyy"))>
        
		<!--- Crear un arreglo para guardar la información del filtro --->
        <cfif NOT IsDefined('Session.CalendarioSesFiltro')>
            <!--- Crear un arreglo para guardar la información del filtro --->
            <cfscript>
                CalendarioSesFiltro = StructNew();
                CalendarioSesFiltro.TipoSesion = 'O';
                CalendarioSesFiltro.Semestre1 = '';
                CalendarioSesFiltro.Semestre2 = '';
                CalendarioSesFiltro.vAnioConsulta = #LsDateFormat(now(),'YYYY')#;
                CalendarioSesFiltro.vPagina = '1';
                CalendarioSesFiltro.vRPP = '25';
            </cfscript>
            <cfset Session.CalendarioSesFiltro = '#CalendarioSesFiltro#'>
        
            <cfif #vMes# LT 7>
                <cfset Session.CalendarioSesFiltro.Semestre1 = 'checked'>
            <cfelse>
                <cfset Session.CalendarioSesFiltro.Semestre1 = ''>
            </cfif>
            <cfif #vMes# GT 6>
                <cfset Session.CalendarioSesFiltro.Semestre2 = 'checked'>
            <cfelse>
                <cfset Session.CalendarioSesFiltro.Semestre2 = ''>
            </cfif>
        </cfif>

		<script type="text/javascript">
			function fListaCalendario()
			{
				if (document.getElementById('vTipoSesionE').checked || document.getElementById('vTipoSesionP').checked)
				{
					document.getElementById('divImpCalendario').style.display = 'none';
					document.getElementById('divTipoPeriodo').style.display = 'none';
					document.getElementById('divFiltroAnio').style.display = 'none';
				}
				if (document.getElementById('vTipoSesionO').checked)
				{
					document.getElementById('divImpCalendario').style.display = '';
					document.getElementById('divTipoPeriodo').style.display = '';
					document.getElementById('divFiltroAnio').style.display = '';
				}
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
				xmlHttp.open("POST", "calendario_sesiones_lista.cfm", true);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "vpAnio=" + encodeURIComponent(document.getElementById('vAnio').value);

				if (document.getElementById('vTipoSesionO').checked) parametros += "&vpSesionTipo=O";
				if (document.getElementById('vTipoSesionE').checked) parametros += "&vpSesionTipo=E";
				if (document.getElementById('vTipoSesionP').checked) parametros += "&vpSesionTipo=P";
								
				if (document.getElementById('vSemestre1').checked) parametros += "&vpSemestre1=checked";
				if (document.getElementById('vSemestre2').checked) parametros += "&vpSemestre2=checked";
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
                            <div class="panel-body" id="divTipoSes">
                                <label class="control-label text-left" for="lblVerSes">TIPO DE SESI&Oacute;N:</label><br>
                                <input type="radio" name="vTipoSesion" id="vTipoSesionO" value="O" onClick="fListaCalendario();" <cfif #Session.CalendarioSesFiltro.TipoSesion# EQ "O">checked="checked"</cfif>><span class="Sans10Ne"> Ordinarias</span><br>
                                <input type="radio" name="vTipoSesion" id="vTipoSesionE" value="E" onClick="fListaCalendario();" <cfif #Session.CalendarioSesFiltro.TipoSesion# EQ "E">checked="checked"</cfif>><span class="Sans10Ne"> Extraordinarias</span><br>
                                <input type="radio" name="vTipoSesion" id="vTipoSesionP" value="P" onClick="fListaCalendario();" <cfif #Session.CalendarioSesFiltro.TipoSesion# EQ "P">checked="checked"</cfif>><span class="Sans10Ne"> Comisi&oacute;n Posdoc</span>
                            </div>
                            <div class="panel-body" id="divTipoPeriodo">
                                <cfoutput>
									<label>VER CALENDARIO DEL:</label><br>
                                    <input type="checkbox" name="vSemestre" id="vSemestre1" value="1" onClick="fListaCalendario();" #Session.CalendarioSesFiltro.Semestre1#><span class="Sans10Ne"> Primer semestre</span><br>
                                    <input type="checkbox" name="vSemestre" id="vSemestre2" value="2" onClick="fListaCalendario();" #Session.CalendarioSesFiltro.Semestre2#><span class="Sans10Ne"> Segundo semestre</span>
                                </cfoutput>
                            </div>
                            <div class="panel-body" id="divImpCalendario">
								<!--- <label class="control-label text-left" for="lblImpCal">Imprimir calendario:</label> --->
								<button type="button" class="btn btn-default"><span class="glyphicon glyphicon-print"></span> Imprimir calendario</button>
                            </div>
                        </div>
                        <div class="panel panel-info">
                            <div class="panel-heading">
                                <label>FILTROS</label>
                            </div>
                            <div class="panel-body" id="divFiltroAnio">
                                <cfform name="frmAnio">
                                    <span class="Sans10Ne">A&ntilde;o:</span>
                                    <cfselect name="vAnio" id="vAnio" query="tbCatalogoAnios" queryPosition="below" selected="#Session.CalendarioSesFiltro.vAnioConsulta#" display="vAnios" label="vAnios" onChange="fListaCalendario();" class="form-control">
                                    </cfselect>
                                </cfform>
                            </div>
                            <div class="panel-body">
                            </div>
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