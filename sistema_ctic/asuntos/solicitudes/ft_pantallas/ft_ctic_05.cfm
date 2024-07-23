<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 06/05/2009 --->
<!--- FECHA ÚLTIMA MOD.: 17/07/2024 --->
<!--- FT-CTIC-5.-Concurso de oposición para ingreso o Concurso Abierto (Contrato)--->

<!--- Incluir algunos archivos (Especificar con más detalle) --->
<cfif #vTipoComando# EQ 'IMPRIME_EJEMPLO'>
	<cfinclude template="ft_campos_blanco.cfm"> <!---PERIMITE IMPRIMIR LA FT EN BLANCO --->
	<cfset vTipoComando = 'IMPRIME'>
<cfelse>
	<cfinclude template="ft_campos.cfm">
</cfif>

<!--- Obtener la lista de ubicaciones de la dependencia  (CATÁLOGOS GENERALES MYSQL) --->
<cfquery name="ctUbicacion" datasource="#vOrigenDatosCATALOGOS#">
	SELECT *, CONCAT(TRIM(ubica_nombre),  ', ', TRIM(ubica_lugar)) AS ubica_completa
    FROM catalogo_dependencias_ubica
	WHERE dep_clave = '#vCampoPos1#'
    AND ubica_status = 1
	ORDER BY ubica_clave
</cfquery>

<!--- Obtener datos del catálogo de categorías y niveles (CATÁLOGOS GENERALES MYSQL) --->
<cfquery name="ctCategoria" datasource="#vOrigenDatosCATALOGOS#">
	SELECT * FROM catalogo_cn 
    WHERE 1 = 1
    AND cn_status = 1 
    ORDER BY cn_siglas
</cfquery>
    
<html>
	<head>
		<!-- INCLUDE que agrega parte del contenido del encabezado -->
		<cfinclude template="ft_include_head_comun.cfm">

		<!-- INCLUDE con JAVASCRIPT de uso común con FT 5, 15 Y 42  -->
		<cfinclude template="ft_scripts_coas.cfm">

		<!-- JAVASCRIPT de uso local -->
		<script type="text/javascript">

            // Validar los datos ingresados por el usuario:
			function fValidaCamposFt()
			{
				var vOk;
				var vMensaje = '';
				fLimpiaValida();
				vMensaje += fValidaCampoLleno('pos1_u','UBICACIÓN');
				if (vMensaje.length > 0)
				{
					alert(vMensaje);
					return false;
				}
				else
				{
                    //alert($('#NumConcursa').val());
                    $('#pos17').val($('#NumConcursa').val());
					return true;
				}
			}
            
			function fDatosPlaza()
			{
				if ($('#vTipoComando').val() == 'CONSULTA' && $('#pos9').val() != '00000-00')
					var posTop = $('#cmdMovHistoria').offset().top; //verifica_plaza_dynamic
					document.getElementById('informacion_plaza_dynamic').style.top = (posTop + 20) + 'px';				

					$.ajax({
						async: false,
						url: "ft_ajax/plaza_informacion.cfm",
						type:'POST',
						data: {vpNoPlaza: $('#pos9').val()},
						dataType: 'html',
						success: function(data, textStatus) {
							//alert(data);
							$('#informacion_plaza_dynamic').html(data);
						},
						error: function(data) {
							alert('ERROR AL CARGAR LA INFORMACION DE LA PLAZA');
							//location.reload();
						},
					});
			}
		</script>
	</head>
	<body onLoad="fOnloadPantalla();fDatosPlaza();">
        <!--- INCLUDE Cintillo con nombre y número de forma telegrámica / INCLUDE que contiene FORM para abrir archivo PDF (05/04/2019) --->
        <cfinclude template="ft_include_cintillo.cfm">
		<!--- FORMULARIO forma telegrámica --->
		<cfform name="formFt" id="formFt" method="POST" enctype="multipart/form-data" action="#vRutaPagSig#">
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
  
                        <!-- Datos para ser llenados por la ST-CTIC -->
                        <cfif #Session.sTipoSistema# IS 'stctic' AND #vSolStatus# LT 3 AND #vTipoComando# IS NOT 'NUEVO' AND #vTipoComando# IS NOT 'IMPRIME' AND #vHistoria# IS NOT 1>
                            <cfinclude template="ft_control.cfm">
                        </cfif>

                        <!-- INCLUDE para visualisar Datos generales -->
                        <cfinclude template="ft_include_general.cfm"> 

                        <!-- Datos que deben ingresarse -->
                        <cfoutput>
                            <table border="0" class="cuadrosFormularios">
                                <!-- El contrato inicia a partir del -->
                                <tr>
                                    <td width="20%"><span class="Sans9GrNe">#ctMovimiento.mov_pos14#</span></td>
                                    <td width="80%" colspan="2">
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos14)#&nbsp;</span>
                                        <cfelse>
                                            <!--- DIV ARCHIVO CONVOCATORIA --->
											<cfif FileExists('#vCarpetaGacetasCOA##tbConvocatorias.coa_gaceta_num#.pdf')>
												<cfif #vSolStatus# GTE 3><cfset vDivCssCoa = 'divPdfGaceta'>
												<cfelseif #vSolStatus# EQ 2><cfset vDivCssCoa = 'divPdfGacetaCaaa'>
												<cfelseif #vSolStatus# LTE 1><cfset vDivCssCoa = 'divPdfGacetaPleno'>
                                                </cfif>
                                                <div id="divGacetaPdf" class="#vDivCssCoa#" align="center"> <!--- float:left; top:10px; left:500px;--->
                                                    <a href="#vWebGacetasCOA##tbConvocatorias.coa_gaceta_num#.pdf" target="winGaceta"><img src="#vCarpetaICONO#/pdf_2015.png" width="40" title="Consultar Gaceta #tbConvocatorias.coa_gaceta_num#" ></a><br/>
                                                    <strong>Convocatoria publicada en<br/>Gaceta UNAM No. #tbConvocatorias.coa_gaceta_num#</strong>
                                                </div>
											</cfif>
                                            <!--- CONTROL DE CAPTURA DE FECHAS --->
                                            <cfinput type="text" name="pos14" disabled='#vActivaCampos#' class="datos" id="pos14" value="#vCampoPos14#" size="10" maxlength="10" onkeypress="return MascaraEntrada(event, '99/99/9999');">
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Número de plaza de la convocatoria -->
                                <tr>
                                    <td class="Sans9GrNe">#ctMovimiento.mov_pos9#</td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoPos9#</span>
                                        <cfelse>
                                            <cfinput name="pos9" id="pos9" type="text" class="datos" size="9" maxlength="8" value="#tbConvocatorias.coa_no_plaza#" disabled>
                                            <cfinput name="pos23" id="pos23" type="hidden" value="#vCampoPos23#">
											<cfif vTipoComando EQ 'CONSULTA' AND #vCampoPos9# NEQ '00000-00'>
												<div id="informacion_plaza_dynamic" class="divPlazaDgpo"></div>
											</cfif>                                            
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Área de adscripción plaza DGPo (12/03/2020) -->
								<cfif #vTipoComando# IS 'CONSULTA'>
									<cfinclude template="include_plaza_area_dgpo.cfm">
								</cfif>											
                                <!-- Categoría y nivel de la plaza de la convocatoria -->
                                <tr>
                                    <td class="Sans9GrNe">#ctMovimiento.mov_pos8#</td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoPos8_txt#</span>
                                        <cfelse>
                                            <cfselect name="pos8" class="datos" id="pos8" query="ctCategoria" queryPosition="below" value="cn_clave" display="cn_siglas" selected="#tbConvocatorias.cn_clave#" disabled>
                                                <option value="" selected>SELECCIONE</option>
                                            </cfselect>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Fecha de publicación en gaceta -->
                                <tr>
                                    <td class="Sans9GrNe">#ctMovimiento.mov_pos21#</td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos21)#</span>
                                        <cfelse>
                                            <cfinput name="pos21" id="pos21" type="text" class="datos" value="#LsDateFormat(tbConvocatorias.coa_gaceta_fecha,'dd/mm/yyyy')#" size="10" maxlength="10" disabled>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- En el área -->
                                <tr>
                                    <td valign="top" class="Sans9GrNe">#ctMovimiento.mov_memo1#</td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoMemo1#</span>
                                        <cfelse>
                                            <cftextarea name="memo1" class="datos100" id="memo1" maxlength="8" value="#Ucase(tbConvocatorias.coa_area)#" cols="62" rows="5" type="text" size="9" disabled></cftextarea>
                                        </cfif>
                                    </td>
                                </tr>
                            </table>
                        </cfoutput>
                        <!--- Tabla para listara los oponentes --->
                        <table border="0" class="cuadrosFormularios">
                            <!-- Titulo del recuadro -->
                            <tr bgcolor="#CCCCCC" width="25px"ss>
                                <td align="center">
                                    <span class="Sans9GrNe">OPONENTE(S)</span>
                                </td>
                            </tr>
                            <tr>
                                <td align="center">
                                    <cfif #vTipoComando# IS 'IMPRIME'>
                                        <cfset vpSolId = #vIdSol#>
                                        <cfset vpCoaId = #vCampoPos23#>
                                        <cfset vActivaCampos = 'disabled'>
                                        <cfinclude template="ft_ajax/coa_lista_oponentes.cfm">
                                    <cfelse>
                                        <div id="oponentes_dynamic"><!-- AJAX: Lista oponentes --></div>
                                    </cfif>
                                </td>                                
                            </tr>
                        </table>
                        <!--- Tabla para listara las solicitudes registradas en convocatoria COA --->
                        <cfif #vTipoComando# IS 'EDITA' OR #vTipoComando# IS 'NUEVO'>
                            <table border="0" class="cuadrosFormularios">
                                <!-- Titulo del recuadro -->
                                <tr bgcolor="#CCCCCC" width="25px"ss>
                                    <td align="center"><span class="Sans9GrNe">SOLICITUDES REGISTRADAS, RECIBIDAS EN LA ENTIDAD Y QUE SE ENVIÓ ACUSE DE RECIBO</span></td>
                                </tr>
                                <tr>
                                    <td align="center"><div id="solicitudescoa_dynamic"><!-- AJAX: Lista solicitudes COA --></div></td>
                                </tr>
                            </table>
                        </cfif>					
                        <!-- INCLUDE para visualisar Información Académica -->
                        <cfinclude template="ft_include_datos_academicos.cfm">
                        <!-- Número de concursantes -->
                        <cfoutput>
                            <table border="0" class="cuadrosFormularios">
                                <tr>
                                    <td width="30%"class="Sans9GrNe">#ctMovimiento.mov_pos17#</td>
                                    <td width="70%">
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#NumberFormat(vCampoPos17,"99")#</span>
                                        <cfelse>
                                            <cfinput name="pos17" id="pos17" type="text" class="datos" value="#LsNumberFormat(vCampopos17,99)#" size="2" maxlength="2" disabled>
                                        </cfif>
                                    </td>
                                </tr>
                            </table>
                        </cfoutput>
							
						<!-- Dictámenes -->
						<!--- Llamado a INCLUDE general de los dictámenes requeridos en la FT 17/05/2024 --->
						<cfinclude template="ft_include_anexoDictamen.cfm">
<!---
                        <cfoutput>
                            <!-- Dictámentes -->
                            <table border="0" class="cuadrosFormularios">
                                <tr bgcolor="##CCCCCC">
                                    <td width="65%"></td>
                                    <td width="20%"><div align="center" class="Sans9GrNe"> Aprobatorio</div></td>
                                    <td width="15%"> <div align="center" class="Sans9GrNe">Se anexa</div></td>
                                </tr>
                                <!-- Dictamen de la Comisión Dictaminadora -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos30#</span> </td>
                                    <td>
                                        <div align="center">
                                            <span class="Sans9GrNe">
                                                <cfinput name="pos30" id="pos30_s" type="radio" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos30 EQ "Si",DE("yes"),DE("no"))#">S&iacute;
                                                <cfinput name="pos30" id="pos30_n" type="radio" value="No" disabled='#vActivaCampos#' checked="#Iif(vCampoPos30 EQ "No",DE("yes"),DE("no"))#">No
                                            </span>
                                        </div>
                                    </td>
                                    <td>
                                        <div align="center">
                                            <cfinput name="pos31" type="checkbox" id="pos31" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos31 EQ "Si",DE("yes"),DE("no"))#">
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </cfoutput>
--->
                        <!-- Documentación -->
						<!--- Llamado a INCLUDE general de los anexos requeridos en la FT 17/07/2024 --->
						<cfinclude template="ft_include_anexoAnexos.cfm">
<!---
                        <!-- Documentación -->
                        <cfoutput>
                            <table border="0" class="cuadrosFormularios">
                                <tr bgcolor="##CCCCCC">
                                    <td></td>
                                    <td width="100"> <div align="center" class="Sans9GrNe">Se anexa</div></td>
                                </tr>
                                <!-- Convocatoria publicada en Gaceta UNAM --><!--- SE CAMBIÓ DE POSICIÓN A SOLITUD DE LA LIC. BEATRIZ CRUZ 12/09/2017 (SE ENCONTRABA POSTERIOR A LA CARTA DEL INTERESADO---> 
                                <tr>
                                    <td class="Sans9GrNe">#ctMovimiento.mov_pos35#</td>
                                    <td>
                                        <div align="center">
                                            <span class="Sans9ViNe">
                                                <cfinput name="pos35" type="checkbox" id="pos35" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos35 EQ "Si",DE("yes"),DE("no"))#">
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                                <!-- Carta del interesado dirigida al director -->
                                <tr>
                                    <td class="Sans9GrNe">#ctMovimiento.mov_pos32#</td>
                                    <td>
                                        <div align="center">
                                            <span class="Sans9ViNe">
                                                <cfinput name="pos32" type="checkbox" id="pos32" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos32 EQ "Si",DE("yes"),DE("no"))#">
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                                <!-- Curriculum vitae del ganador y oponentes -->
                                <tr>
                                    <td class="Sans9GrNe">#ctMovimiento.mov_pos36#</td>
                                    <td>
                                        <div align="center">
                                            <span class="Sans9ViNe">
                                                <cfinput name="pos36" type="checkbox" id="pos36" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos36 EQ "Si",DE("yes"),DE("no"))#">
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                                <!-- Examen o proyecto del ganador y oponentes -->
                                <tr>
                                    <td class="Sans9GrNe">#ctMovimiento.mov_pos37#</td>
                                    <td>
                                        <div align="center">
                                            <span class="Sans9ViNe">
                                                <cfinput name="pos37" type="checkbox" id="pos37" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos37 EQ "Si",DE("yes"),DE("no"))#">
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                                <!-- Constancia de último grado obtenido -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos38#</span> </td>
                                    <td>
                                        <div align="center">
                                            <span class="Sans9ViNe">
                                                <cfinput name="pos38" type="checkbox" id="pos38" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos38 EQ "Si",DE("yes"),DE("no"))#">
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                                <!-- Trabajos publicados -->
                                <tr>
                                    <td class="Sans9GrNe">#ctMovimiento.mov_pos39#</td>
                                    <td>
                                        <div align="center">
                                            <cfinput name="pos39" type="checkbox" id="pos39" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos39 EQ "Si",DE("yes"),DE("no"))#">
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </cfoutput>
--->
                        <cfif #Session.sTipoSistema# IS 'sic' AND #vSolStatus# EQ 3 AND #vTipoComando# IS NOT 'NUEVO' AND #vTipoComando# IS NOT 'IMPRIME'>
                            <cfinclude template="ft_firma.cfm">
                        </cfif>
                    </td>
                </tr>
            </table>
		</cfform>
		<cfif #vTipoComando# NEQ 'IMPRIME'>
        	<cfinclude template="#vCarpetaRaizLogica#/include_pie.cfm">
		</cfif>
	</body>
</html>