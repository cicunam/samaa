<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 17/04/2009 --->
<!--- FECHA ÚLTIMA MOD.: 20/05/2024 --->
<!--- FT-CTIC-41.-Licencia con goce de sueldo --->

<!--- Incluir los siguientes archivos --->
<cfif #vTipoComando# EQ 'IMPRIME_EJEMPLO'>
	<cfinclude template="ft_campos_blanco.cfm"> <!---PERIMITE IMPRIMIR LA FT EN BLANCO --->
	<cfset vTipoComando = 'IMPRIME'>
<cfelse>
	<cfinclude template="ft_campos.cfm">
</cfif>

<!--- Obtener datos del catálogo de actividades (CATÁLOGOS LOCAL SAMAA) --->
<cfquery name="ctActividad" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_actividad
	WHERE activ_clave <> 20 AND activ_clave <> 22
	ORDER BY activ_orden
</cfquery>

<!--- Obtener datos del catalogo de países  (CATÁLOGOS GENERALES MYSQL) --->
<cfquery name="ctPais" datasource="#vOrigenDatosCATALOGOS#">
	SELECT * FROM catalogo_paises
	ORDER BY pais_nombre
</cfquery>

<html>
	<head>
		<!-- INCLUDE que agrega parte del contenido del encabezado -->
		<cfinclude template="ft_include_head_comun.cfm">
		<!-- JAVA SCRIT de uso local -->
		<script type="text/javascript">
			// Actualizar el formulario según las opciones seleccionadas:
			function fActualizar()
			{
				<!---
				NOTA: Es mejor actualizar el catálogo cuando sea necesaria una actividad no incluida en la lista.
				// Visualizar el campo para capturar otra actividad:
				if (document.getElementById('pos12').value == "OTRA")
				{
					document.getElementById('otra_actividad').style.display ='';
				}
				else
				{
					document.getElementById('otra_actividad').value = '';
					document.getElementById('otra_actividad').style.display ='none';
				}
				--->
				// Ejecutar algunos AJAX:
				ObtenerDiasLicencia();
				ObtenerTraslapeLicencia();
				TieneContratoVigente();
				ObtenerEstados();
			}
			// Función que hace verificaciones la capturar la fecha de inicio de la durnación
			function fDuracionInicio()
			{
				CalcularSiguienteFecha();
				ObtenerDiasLicencia();
				ObtenerTraslapeLicencia();
				TieneContratoVigente();
				if (($('#vConClave').val() == 3 || $('#vConClave').val() == 2) && $('#pos14').val() != '')
				{
					fAniosMinimos();
					setTimeout(function(){
						if ($('#txtAniosMinimos').val() < 2)
						{
							alert('EL académico no cuenta con la antigüedad mínima requerida por el EPA, artículo 97');
							$('#cmdGuardarSol').attr('disabled','disabled');
						}
					}, 150);

				}
			}
			// Validación de los datos ingresados por el usuario:
			function fValidaCamposFt()
			{
				var vMensaje = '';
				fLimpiaValida();
				vMensaje += fValidaCampoLleno('pos12','ACTIVIDAD');
				vMensaje += fValidaCampoLleno('memo1','OBJETO');
				vMensaje += fValidaCampoLleno('pos13_d','DURACIÓN');
				vMensaje += fValidaFecha('pos14','INICIO');
				vMensaje += fValidaCampoLleno('pos11_p','PAÍS');
				// if (document.getElementById('pos11_p').value=='MEX' || document.getElementById('pos11_p').value=='USA') 
                vMensaje += fValidaCampoLleno('pos11_e','ESTADO');
				vMensaje += fValidaCampoLleno('pos11_c','CIUDAD');
				if (document.getElementById('pos14').value)
				{
					if (document.getElementById('traslape_licencia')) vMensaje += document.getElementById('traslape_licencia').value == 0 ? '' : 'La DURACIÓN y FECHA especificadas se traslapan con otra licencia y/o comisión.\n';
					if (document.getElementById('contrato_vigente')) vMensaje += document.getElementById('contrato_vigente').value > 0 ? '' : 'Campos: DURACIÓN y FECHA, el académico no tiene un contrato vigente es ese periodo.\n';
				}
				if (document.getElementById('pos13_d_temp')) 
                    vMensaje += parseInt(document.getElementById('pos13_d').value=='' ? "0" : document.getElementById('pos13_d').value) + parseInt(document.getElementById('pos13_d_temp').value=='' ? "0" : document.getElementById('pos13_d_temp').value) <= 45 ? '': 'Campo: DURACIÓN no puede exceder los 45 días al año.\n';
				
				// Función que llama a AJAX que calcula la antigüedad mínima requerida en un COD o COA de nuevo ingreso 07/05/2024
				// fAniosMinimos();
				
				// Valida la antigüedad mínima requerida en los COD y COA 
				if ($('#vConClave').val() == 3 || $('#vConClave').val() == 2)
				{
					//alert('COD O COA: ' + $('#txtAniosMinimos').val());
					if ($('#txtAniosMinimos').val() < 2)
					{
						vMensaje += 'EL académico no cuenta con la antigüedad mínima requerida por el EPA, artículo 97.\n';
						$('#cmdGuardarSol').attr('disabled','disabled');
					}
				}
				if (vMensaje.length > 0)
				{
					alert(vMensaje);
					return false;
				}
				else
				{
					return true;
				}
			}
		</script>
	</head>
	<body onLoad="fActualizar();">
		<!--- INCLUDE Cintillo con nombre y número de forma telegrámica / INCLUDE que contiene FORM para abrir archivo PDF (05/04/2019) --->
        <cfinclude template="ft_include_cintillo.cfm">
		<!--- FORMULARIO forma telegrámica --->
		<cfform nname="formFt" id="formFt" method="POST" enctype="multipart/form-data" action="#vRutaPagSig#">
            <!-- Forma telegrámica -->
            <table width="100%" border="0">
                <tr>
                    <!-- Menú lateral -->
                    <cfif #vTipoComando# IS NOT 'IMPRIME' AND #vHistoria# IS NOT 1>
                      <td class="menuformulario">
                            <!-- INCLUDE Ménu izquierdo -->
							<cfinclude template="ft_include_menu.cfm">
                        </td>
                    </cfif>
                    <!-- Formulario -->
                    <td class="formulario">
						<!-- INCLUDE Titulos de la forma telegrámica -->
                        <cfinclude template="ft_include_titulos.cfm">
                        <!-- INCLUDE Campos ocultos GENERALES-->
                        <cfinclude template="ft_include_campos_ocultos.cfm">
                        <span id="traslape_licencia_dynamic"><!-- AJAX: Traslape con otras licencias --></span>
                        <span id="contrato_vigente_dynamic"><!-- AJAX: Contrato vigente --></span>

                        <!-- Datos para ser llenados por la ST-CTIC -->
                        <cfif #Session.sTipoSistema# IS 'stctic' AND #vSolStatus# LT 3 AND #vTipoComando# IS NOT 'NUEVO' AND #vTipoComando# IS NOT 'IMPRIME' AND #vHistoria# IS NOT 1>
                            <cfinclude template="ft_control.cfm">
                        </cfif>

                        <!-- INCLUDE para visualisar Datos generales -->
                        <cfinclude template="ft_include_general.cfm">

                        <!-- INCLUDE para visualisar Información Académica -->
                        <cfinclude template="ft_include_datos_academicos.cfm">

						<!-- Datos ddebe ingresar -->
						<cfoutput>
                            <table border="0" class="cuadrosFormularios">
<!--- SE ELIMINÓ PARA HOMOLOGAR CON EL INCLUDE Y PORDER ACTUALIZAR LA CCN 03/10/2019
                                <!-- Categoría y nivel -->
                                <tr>
                                    <td width="20%"><span class="Sans9GrNe">#ctMovimiento.mov_pos3#</span></td>
                                    <td width="80%">
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoPos3_txt#</span>
                                        <cfelse>
                                            <cfinput name="pos3_txt" id="pos3_txt" type="text" class="datos" size="20" value="#vCampoPos3_txt#" disabled>
                                            <cfinput name="pos3" id="pos3" type="hidden" value="#vCampoPos3#">
                                        </cfif>
                                    </td>
                                </tr>
--->								
                                <!-- Actividades -->
                                <tr>
                                    <td width="20%"><span class="Sans9GrNe">#ctMovimiento.mov_pos12#</span></td>
                                    <td width="80%">
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <cfset vCampoPos12_txt = ''>
                                            <cfloop query="ctActividad">
                                                <cfif #activ_clave# IS #vCampoPos12#>
                                                    <cfset vCampoPos12_txt = '#activ_descrip#'>
                                                    <cfbreak>
                                                </cfif>
                                            </cfloop>
                                            <span class="Sans9Gr">#vCampoPos12_txt#</span>
                                        <cfelse>
                                            <cfselect name="pos12" id="pos12" class="datos" query="ctActividad" queryposition="below" value="activ_clave" display="activ_descrip" disabled='#vActivaCampos#' selected="#vCampoPos12#" onchange="fActualizar();">
                                                <option value="">SELECCIONE</option>
                                            </cfselect>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Otra actividad -->
                                <!---
                                NOTA: Es mejor actualizar el catálogo cuando sea necesaria una actividad no incluida en la lista.
                                <tr id="otra_actividad">
                                    <td><span class="Sans9GrNe">Otra actividad:</span></td>
                                    <td>
                                        <cfinput name="pos12_o" id="pos12_o" type="text" size="50" maxlength="254" class="datos" disabled='#vActivaCampos#' value="#vCampoPos12_o#">
                                    </td>
                                </tr>
                                --->
                                <!-- Objeto de la licencia -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_memo1#</span></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoMemo1#</span>
                                        <cfelse>
                                            <cftextarea name="memo1" id="memo1" rows="5" disabled='#vActivaCampos#' class="datos100" value="#vCampoMemo1#"></cftextarea>
                                        </cfif>
                                    </td>
                                </tr>
                            </table>
                        </cfoutput>
    
                        <cfoutput>
                            <table border="0" class="cuadrosFormularios">
                                <!-- Duración (años, meses, días) -->
                                <tr>
                                    <td width="20%"><span class="Sans9GrNe">#ctMovimiento.mov_pos13#</span></td>
                                    <td width="80%">
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoPos13_d# #ctMovimiento.mov_pos13_d#&nbsp;</span>
                                        <cfelse>
                                            <!---
                                            <input type="text" class="datos" size="1" maxlength="1" disabled>
                                            <span class="Sans9Gr">#ctMovimiento.mov_pos13_a#</span>
                                            <input type="text" class="datos" size="2" maxlength="2" disabled>
                                            <span class="Sans9Gr">#ctMovimiento.mov_pos13_m#</span>
                                            --->
                                            <cfinput name="pos13_d" type="text" class="datos" id="pos13_d" size="2" maxlength="2" disabled='#vActivaCampos#' value="#vCampoPos13_d#" onblur="CalcularSiguienteFecha(); ObtenerDiasLicencia(); ObtenerTraslapeLicencia(); TieneContratoVigente();" onkeypress="return MascaraEntrada(event, '99');">
                                            <span class="Sans9Gr">#ctMovimiento.mov_pos13_d#</span>
                                        </cfif>
                                        <!-- Fechas -->
                                        <span class="Sans9Gr">#ctMovimiento.mov_pos14#</span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos14)#&nbsp;</span>
                                        <cfelse>
                                            <cfinput name="pos14" type="text" class="datos" id="pos14" size="10" maxlength="10" disabled='#vActivaCampos#' value="#vCampoPos14#" onblur="fDuracionInicio();" onkeypress="return MascaraEntrada(event, '99/99/9999');">
                                        </cfif>
                                        <span class="Sans9Gr">#ctMovimiento.mov_pos15# </span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos15)#&nbsp;</span>
                                        <cfelse>
                                            <cfinput name="pos15" type="text" class="datos" id="pos15" size="10" maxlength="10" value="#vCampoPos15#" disabled>
                                        </cfif>
                                        <!-- Dias de licencia ocupados en el año -->
                                        <span class="Sans9Gr"><i>Día ocupados en el año</i></span>
                                        <span id="dias_licencia_dynamic">
                                            <!-- AJAX: Días de licencia ocupados en el año -->
                                            <input name="pos13_d_temp" id="pos13_d_temp" type="text" class="datos" size="2" value="0" disabled>
                                        </span>
										<span id="aniguedad_minima_dynamic">
										</span>
                                    </td>
                                </tr>
                                <!-- Lugar (país) -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos11_p#</span></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <cfloop query="ctPais">
                                                <cfif #pais_clave# IS #vCampoPos11_p#>
                                                    <cfset vCampoPos11_p_txt = #pais_nombre#>
                                                    <cfbreak>
                                                </cfif>
                                            </cfloop>
                                            <span class="Sans9Gr">#vCampoPos11_p_txt#</span>
                                        <cfelse>
                                            <cfselect name="pos11_p" id="pos11_p" class="datos" query="ctPais" value="pais_clave" display="pais_nombre" queryPosition="Below" disabled='#vActivaCampos#' selected="#vCampoPos11_p#" onchange="ObtenerEstados();">
                                                <option value="">SELECCIONE</option>
                                            </cfselect>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Estado -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos11_e#</span></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <cfif #vCampoPos11_p# EQ 'MEX' OR #vCampoPos11_p# EQ 'USA'>
                                                <cfquery name="ctEstados" datasource="#vOrigenDatosSAMAA#">
                                                    SELECT * FROM catalogo_pais_edo WHERE edo_clave = '#vCampoPos11_e#'
                                                </cfquery>
                                                <span class="Sans9Gr">#ctEstados.edo_nombre#</span>
                                            <cfelse>
                                                <span class="Sans9Gr">#vCampoPos11_e#</span>
                                            </cfif>
                                        <cfelse>
                                            <span id="estados_dynamic"><!-- AJAX: Lista de estados --></span>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Ciudad -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos11_c#</span></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoPos11_c#</span>
                                        <cfelse>
                                            <cfinput type="text" name="pos11_c" id="pos11_c" disabled='#vActivaCampos#' class="datos" value="#vCampoPos11_c#" size="50" maxlength="50">
                                        </cfif>
                                    </td>
                                </tr>
                            </table>
						</cfoutput>
											
                        <!-- Dictámenes -->
						<!--- Llamado a INCLUDE general de los dictámenes requeridos en la FT 20/05/2024 --->
						<cfinclude template="ft_include_anexoDictamen.cfm">
							
                        <!-- Documentación -->
						<!--- Llamado a INCLUDE general de los anexos requeridos en la FT 20/05/2024 --->
						<cfinclude template="ft_include_anexoAnexos.cfm">
<!---                                            
                        <!-- Dictámenes -->
                        <cfoutput>
                            <table border="0" class="cuadrosFormularios">
                                <!-- Encabezados -->
                                <tr bgcolor="##CCCCCC">
                                    <td width="65%"></td>
                                    <td width="20%"><div align="center" class="Sans10NeNe">Aprobatoria</div></td>
                                    <td width="15%"><div align="center" class="Sans10NeNe">Se anexa</div></td>
                                </tr>
                                <!-- Opinión del consejo interno -->
                                <tr>
                                    <!-- Si/No -->
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos26#</span></td>
                                    <td>
                                        <div align="center" class="Sans9GrNe">
                                            <cfinput name="pos26" type="radio" value="Si" checked="#Iif(vCampoPos26 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>S&iacute;&nbsp;
                                            <cfinput name="pos26" type="radio" value="No" checked="#Iif(vCampoPos26 EQ "No",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>No
                                        </div>
                                    </td>
                                    <!-- Se anexa -->
                                    <td>
                                        <div align="center">
                                            <cfinput name="pos27" type="checkbox" id="pos27" value="Si" checked="#Iif(vCampoPos27 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>
                                        </div>
                                    </td>
                                </tr>
                                <!-- Carta del director -->
                                <tr>
                                    <!-- Si/No -->
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos28#</span></td>
                                    <td>
                                        <div align="center" class="Sans9GrNe">
                                            <cfinput name="pos28" type="radio" value="Si" checked="#Iif(vCampoPos28 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>S&iacute;&nbsp;
                                            <cfinput name="pos28" type="radio" value="No" checked="#Iif(vCampoPos28 EQ "No",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>No
                                        </div>
                                    </td>
                                    <!-- Se anexa -->
                                    <td>
                                        <div align="center">
                                            <cfinput name="pos29" type="checkbox" id="pos29" value="Si" checked="#Iif(vCampoPos29 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </cfoutput>
--->                                
                    </td>
                </tr>
            </table>
		</cfform>
		<cfif #vTipoComando# NEQ 'IMPRIME'>
        	<cfinclude template="#vCarpetaRaizLogica#/include_pie.cfm">
		</cfif>
	</body>
</html>
