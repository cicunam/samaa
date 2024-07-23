<!--- CREADO: ARAM PICHARDO--->
<!--- EDITO: ARAM PICHARDO--->
<!--- FECHA CREA: 03/06/2009 --->
<!--- FECHA ÚLTIMA MOD.: 05/12/2022 --->
<!--- FT-CTIC-13.-Cambio de adscripción temporal o definitivo--->

<!--- Incluir los siguientes archivos --->
<cfif #vTipoComando# EQ 'IMPRIME_EJEMPLO'>
	<cfinclude template="ft_campos_blanco.cfm"> <!---PERIMITE IMPRIMIR LA FT EN BLANCO --->
	<cfset vTipoComando = 'IMPRIME'>
<cfelse>
	<cfinclude template="ft_campos.cfm">
</cfif>

<!--- Obtener la lista de ubicaciones de la dependencia (CATÁLOGOS GENERALES MYSQL) --->
<cfquery name="ctUbicacion" datasource="#vOrigenDatosCATALOGOS#">
	SELECT *, CONCAT(TRIM(ubica_nombre),  ', ', TRIM(ubica_lugar)) AS ubica_completa
    FROM catalogo_dependencias_ubica
	WHERE dep_clave = '#vCampoPos1#' 
    AND ubica_status = 1
	ORDER BY ubica_clave
</cfquery>

<!--- Obtener la lista de ubicaciones de la segunda dependencia (CATÁLOGOS GENERALES MYSQL) --->
<cfquery name="ctUbicacion2" datasource="#vOrigenDatosCATALOGOS#">
	SELECT *, CONCAT(TRIM(ubica_nombre),  ', ', TRIM(ubica_lugar)) AS ubica_completa
    FROM catalogo_dependencias_ubica
	WHERE dep_clave = '#vCampoPos11#'
    AND ubica_status = 1
	ORDER BY ubica_clave
</cfquery>

<!--- Obtener la lista de subsistemas de la UNAM (CATÁLOGOS GENERALES MYSQL) --->
<cfquery name="ctSubsistema" datasource="#vOrigenDatosCATALOGOS#">
	SELECT *, UPPER(sis_nombre) AS sis_nombre_1 
	FROM catalogo_subsistemas
	ORDER BY sis_orden
</cfquery>

<html>
	<head>
		<!-- INCLUDE que agrega parte del contenido del encabezado -->
		<cfinclude template="ft_include_head_comun.cfm">
		<!-- JAVA SCRIT de uso local -->
		<script type="text/javascript">
			// Actualizar el formulario:
			function actualizar()
			{
				if (document.getElementById('pos10_t').checked || document.getElementById('pos10_c').checked)
				{
					show('pos13_a');
					show('pos13_m');
					show('pos13_d');
					show('pos13_a_txt');
					show('pos13_m_txt');
					show('pos13_d_txt');
					show('pos14_txt');
					show('pos15_txt');
					show('pos15');
					changeText('pos13_txt','Duración');
				}
				else
				{
					hide('pos13_a');
					hide('pos13_m');
					hide('pos13_d');
					hide('pos13_a_txt');
					hide('pos13_m_txt');
					hide('pos13_d_txt');
					hide('pos14_txt');
					hide('pos15_txt');
					hide('pos15');
					changeText('pos13_txt','A partir del');
					document.getElementById('pos13_a').value = '';
					document.getElementById('pos13_m').value = '';
					document.getElementById('pos13_d').value = '';
					document.getElementById('pos15').value = '';
				}
				if (document.getElementById('pos5_d').checked)
				{
					if (document.getElementById('pos10_d').checked)
					{
						show('trDefinitivo');
					}
					else
					{
						hide('trDefinitivo');
					}
				}
				// Si el usuario elige, "Por cargo/nombramiento":
				if (document.getElementById('pos10_c').checked)
				{
					show('pos12_fila')
				}
				else
				{
					hide('pos12_fila')
					document.getElementById('pos12').value = '';
				}

			}
			// Validar los datos ingresados por el usuario:
			function fValidaCamposFt()
			{
				var vMensaje = '';
				fLimpiaValida();
				vMensaje += fValidaCampoLleno('pos1_u','UBICACIÓN');
				vMensaje = fValidaCampoLleno('pos12_o','SUBSISTEMA AL QUE ASPIRA');
				if (!document.getElementById('pos12_o').value == '') vMensaje += fValidaCampoLleno('pos11','DEPENDENCIA A LA QUE ASPIRA');
				vMensaje += fValidaDuracion();
				// Desplegar los mensajes de error encontrados en la forma, si existen:
				if (vMensaje.length > 0)
				{
					//alert(vMensaje);
					return false;
				}
				else
				{
					return true;
				}
			}
			function fPosAdscrip(vPos20)
			{
                $.ajax({
                    async: false,
                    url: "ft_ajax/cambio_adscripcion.cfm",
                    type:'POST',
                    data: {vpPos20: vPos20, vpAdsc: 'AA', vpActivaCampos: '<cfoutput>#vActivaCampos#</cfoutput>'}, 
                    dataType: 'html',
                    success: function(data, textStatus) {
                        //alert(data);
                        $('#adscrip_actual_dynamic').html(data);
                    },
                    error: function(data) {
                        alert('ERROR AL CARGAR EL PERIODO A INFORMAR');
                        //location.reload();
                    },
                });
                
                $.ajax({
                    async: false,
                    url: "ft_ajax/cambio_adscripcion.cfm",
                    type:'POST',
                    data: {vpPos20: vPos20, vpAdsc: 'EA', vpActivaCampos: '<cfoutput>#vActivaCampos#</cfoutput>'}, 
                    dataType: 'html',
                    success: function(data, textStatus) {
                        //alert(data);
                        $('#entidad_aspita_dynamic').html(data);
                    },
                    error: function(data) {
                        alert('ERROR AL CARGAR EL PERIODO A INFORMAR');
                        //location.reload();
                    },
                });                  

			}
		</script>
	</head>
	<body onLoad="fPosAdscrip('<cfoutput>#vCampoPos20#</cfoutput>');"><!--- actualizar(); fObtenerDepUnam();  --->
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
                        <!-- INCLUDE para visualisar Información Académica -->
                        <cfinclude template="ft_include_datos_academicos.cfm">
                        <!-- Datos que deben ingresarse -->
                        <cfoutput>
                            
							<cfif #vTipoComando# IS 'IMPRIME'>
                            <cfelse>
                                <table border="0" class="cuadrosFormularios">
                                    <tbody id="DatosSolFt13">
                                    <!-- Titulo del recuadro -->
                                    <tr>
                                        <td><span class="Sans9GrNe">El cambio es</span></td>
                                        <td>
                                            <cfinput name="pos20" id="pos20_s" type="radio" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos20 EQ 'Si',DE("yes"),DE("no"))#" onClick="fPosAdscrip('Si');"><span class="Sans9GrNe">Del #vCampoPos1_txt# a OTRA Entidad</span><br/><!---De la Entidad (#vCampoPos1_Siglas#) a otra Entidad--->
                                            <cfinput name="pos20" id="pos20_n" type="radio" value="No" disabled='#vActivaCampos#' checked="#Iif(vCampoPos20 EQ 'No',DE("yes"),DE("no"))#" onClick="fPosAdscrip('No');"><span class="Sans9GrNe">De OTRA Entidad al #vCampoPos1_txt#</span><!---De Otra Entidad a la Entidad (#vCampoPos1_Siglas#)--->
                                        </td>
                                    </tr>

                                    <tr id="trLinea_1">
                                        <td colspan="2" bgcolor="##CCCCCC">
                                            <span class="Sans9GrNe"><center>ADSCRIPCI&Oacute;N ACTUAL</center></span>
                                        </td>
                                    </tr>
                                    <!-- Dependencia actual (solo se muestra) -->
                                    <tr id="trLinea_AA">
                                        <td colspan="2">
                                            <div id="adscrip_actual_dynamic"><!--- DIV PARA INSERTAR AJAX ---></div>
                                        </td>
                                    </tr>
                                    <!-- Titulo del recuadro -->
                                    <tr id="trLinea_4">
                                        <td colspan="2" bgcolor="##CCCCCC">
                                            <span class="Sans9GrNe"><center>ENTIDAD A LA QUE ASPIRA</center></span>
                                        </td>
                                    </tr>
                                    <!-- Subsistema al que asíra -->
                                    <tr id="trLinea_5">
                                        <td colspan="2">
                                            <div id="entidad_aspita_dynamic"><!--- DIV PARA INSERTAR AJAX ---></div>
                                        </td>
                                    </tr>
                                    <tr id="trLinea_9">
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    </tbody>
                                </table>
                            </cfif>
                        </cfoutput>
                        <!-- Datos que deben ingresarse (continuación) -->
                        <cfoutput>
                            <table border="0" class="cuadrosFormularios">
                                <!-- Tipo de cambio -->
                                <tr>
                                    <td width="20%"><span class="Sans9GrNe">#ctMovimiento.mov_pos10#</span></td>
                                    <td width="80%">
                                        <cfif #vCampoPos5# EQ 1>
                                        <cfinput name="pos10" id="pos10_d" type="radio" value="1" disabled='#vActivaCampos#' checked="#Iif(vCampoPos10 EQ '1',DE("yes"),DE("no"))#" onclick="actualizar();">
                                        <span class="Sans9Gr">Definitivo&nbsp;</span>
                                        </cfif>
                                        <cfinput name="pos10" id="pos10_c" type="radio" value="3" disabled='#vActivaCampos#' checked="#Iif(vCampoPos10 EQ '3',DE("yes"),DE("no"))#" onclick="actualizar();">
                                        <span class="Sans9Gr">Por cargo o nombramiento</span>
                                        <cfif #vCampoPos5# EQ 1>
                                            <br>
                                        </cfif>
                                        <cfinput name="pos10" id="pos10_t" type="radio" value="2" disabled='#vActivaCampos#' checked="#Iif(vCampoPos10 EQ '2',DE("yes"),DE("no"))#" onclick="actualizar();">
                                        <span class="Sans9Gr">Temporal&nbsp;</span>
                                        <cfinput name="pos10" id="pos10_tp" type="radio" value="4" disabled='#vActivaCampos#' checked="#Iif(vCampoPos10 EQ '4',DE("yes"),DE("no"))#" onclick="actualizar();">
                                        <span class="Sans9Gr">Transferencia de plaza</span>
                                        <cfif #vCampoPos2# EQ '7198'>
                                            <br>
                                            <cfinput name="pos10" id="pos10_tp" type="radio" value="5" disabled='#vActivaCampos#' checked="#Iif(vCampoPos10 EQ '5',DE("yes"),DE("no"))#" onclick="actualizar();">
                                            <span class="Sans9Gr">Transferencia de plaza definitiva</span>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Cargo o nombramiento -->
                                <cfif #vTipoComando# IS 'IMPRIME'>
                                    <cfif #vCampoPos12# IS NOT ''>
                                        <tr>
                                            <td><span class="Sans9GrNe">#ctMovimiento.mov_pos12#</span></td>
                                            <td><span class="Sans9Gr">#vCampoPos12#</span></td>
                                        </tr>
                                    </cfif>
                                <cfelse>
                                    <tr id="pos12_fila">
                                        <td><span class="Sans9GrNe">#ctMovimiento.mov_pos12#</span></td>
                                        <td>
                                            <cfinput type="text" name="pos12" value="#vCampoPos12#" size="50" maxlength="254" id="pos12" class="datos" disabled='#vActivaCampos#'>
                                        </td>
                                    </tr>
                                </cfif>
                                <!-- Duración (años, meses, días) -->
                                <cfif #vTipoComando# IS 'IMPRIME'>
                                    <tr>
                                        <td>
                                            <span class="Sans9GrNe" id="pos13_txt">
                                                <cfif #vCampoPos10# IS 2  OR #vCampoPos10# IS 3>
                                                    Duraci&oacute;n
                                                <cfelse>
                                                    A partir de
                                                </cfif>
                                            </span>
                                        </td>
                                        <td>
                                            <span class="Sans9Gr">
                                                <cfif #vCampoPos10# IS 2 OR #vCampoPos10# IS 3>
                                                    <span
                                                        <cfif #vCampoPos13_a# EQ 0>class="NoImprimir"</cfif>
                                                        >#vCampoPos13_a# #ctMovimiento.mov_pos13_a#&nbsp;
                                              </span>
                                                    <span
                                                        <cfif #vCampoPos13_m# EQ 0>class="NoImprimir"</cfif>
                                                        >#vCampoPos13_m# #ctMovimiento.mov_pos13_m#&nbsp;
                                              </span>
                                                    <span
                                                        <cfif #vCampoPos13_d# EQ 0>class="NoImprimir"</cfif>
                                                        >#vCampoPos13_d# #ctMovimiento.mov_pos13_d#&nbsp;
                                                  </span>
                                                </cfif>
                                                <cfif #vCampoPos10# IS 2 OR #vCampoPos10# IS 3>del&nbsp;</cfif>
                                                #FechaCompleta(vCampoPos14)#&nbsp;
                                            <cfif #vCampoPos10# IS 2 OR #vCampoPos10# IS 3> al #FechaCompleta(vCampoPos15)#&nbsp; </cfif>
                                            </span>
                                        </td>
                                    </tr>
                                <cfelse>
                                    <tr>
                                        <td><span class="Sans9GrNe" id="pos13_txt">#ctMovimiento.mov_pos13#</span></td>
                                        <td>
                                            <span
                                                <cfif #vCampoPos13_a# EQ 0>class="NoImprimir"</cfif>
                                                ><cfinput name="pos13_a" type="text" class="datos" id="pos13_a" size="1" maxlength="1" disabled='#vActivaCampos#' value="#vCampoPos13_a#" onChange="CalcularSiguienteFecha();" onkeypress="return MascaraEntrada(event, '9');">
                                                <span class="Sans9Gr" id="pos13_a_txt">
                                                    #ctMovimiento.mov_pos13_a#
                                            </span>
                                            </span>
                                            <span
                                                <cfif #vCampoPos13_m# EQ 0>class="NoImprimir"</cfif>
                                                ><cfinput name="pos13_m" type="text" class="datos" id="pos13_m" size="2" maxlength="2" disabled='#vActivaCampos#' value="#vCampoPos13_m#" onChange="CalcularSiguienteFecha();" onkeypress="return MascaraEntrada(event, '99');">
                                                <span class="Sans9Gr" id="pos13_m_txt">
                                                    #ctMovimiento.mov_pos13_m#
                                            </span>
                                            </span>
                                            <span
                                                <cfif #vCampoPos13_d# EQ 0>class="NoImprimir"</cfif>
                                                ><cfinput name="pos13_d" type="text" class="datos" id="pos13_d" size="2" maxlength="2" disabled='#vActivaCampos#' value="#vCampoPos13_d#" onChange="CalcularSiguienteFecha();" onkeypress="return MascaraEntrada(event, '99');">
                                                <span class="Sans9Gr" id="pos13_d_txt">
                                                    #ctMovimiento.mov_pos13_d#
                                            </span>
                                            </span>
                                            <!-- Fechas -->
                                            <span class="Sans9Gr" id="pos14_txt">#ctMovimiento.mov_pos14#</span>
                                            <cfinput type="text" name="pos14" class="datos" id="pos14" size="10" maxlength="10" disabled='#vActivaCampos#' value="#vCampoPos14#" onChange="if (document.getElementById('pos10_t').checked) CalcularSiguienteFecha();" onkeypress="return MascaraEntrada(event, '99/99/9999');">
                                            <span class="Sans9Gr" id="pos15_txt">#ctMovimiento.mov_pos15#</span>
                                            <cfinput name="pos15" id="pos15" type="text" class="datos" size="10" maxlength="10" disabled value="#vCampoPos15#">
                                        </td>
                                    </tr>
                                </cfif>
                            </table>
                        </cfoutput>
                        <!-- Dictámenes -->
                        <cfoutput>
                            <table border="0" class="cuadrosFormularios">
                                <tr bgcolor="##CCCCCC">
                                    <td width="65%"></td>
                                    <td width="20%" class="Sans9GrNe"><div align="center">Aprobatorio</b></div></td>
                                    <td width="15%" class="Sans9GrNe"><div align="center"><b>Se anexa</div></td>
                                </tr>
                                <cfif #vTipoComando# NEQ 'IMPRIME'>
                                <!-- Dictamen de la Comisión Dictaminadora -->
                                <tr id="trDefinitivo">
                                    <td class="Sans9GrNe">#ctMovimiento.mov_pos30#</td>
                                    <td>
                                        <div align="center">
                                            <span class="Sans9GrNe">
                                                <cfinput name="pos30" id="pos30_s" type="radio" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos30 EQ 'Si',DE("yes"),DE("no"))#">S&iacute;&nbsp;
                                                <cfinput name="pos30" id="pos30_n" type="radio" value="No" disabled='#vActivaCampos#' checked="#Iif(vCampoPos30 EQ 'No',DE("yes"),DE("no"))#">No
                                            </span>
                                        </div>
                                    </td>
                                    <td>
                                        <div align="center">
                                            <span class="Sans9GrNe">
                                                <cfinput name="pos31" type="checkbox" id="pos31" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos31 EQ 'Si',DE("yes"),DE("no"))#">
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                                <cfelseif #vTipoComando# EQ 'IMPRIME' AND (#vCampoPos10# EQ "1" OR #vCampoPos10# EQ "4")><!--- SE AGREGÓ 4 A SOLICITUD DE SILVIA VENCES 05/12/2022 --->
                                <!-- Dictamen de la Comisión Dictaminadora -->
                                <tr>
                                    <td class="Sans9GrNe">#ctMovimiento.mov_pos30#</td>
                                    <td>
                                        <div align="center">
                                            <span class="Sans9GrNe">
                                                <cfinput name="pos30_imp" id="pos30_s_imp" type="radio" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos30 EQ 'Si',DE("yes"),DE("no"))#">S&iacute;&nbsp;
                                                <cfinput name="pos30_imp" id="pos30_n_imp" type="radio" value="No" disabled='#vActivaCampos#' checked="#Iif(vCampoPos30 EQ 'No',DE("yes"),DE("no"))#">No
                                            </span>
                                        </div>
                                    </td>
                                    <td>
                                        <div align="center">
                                            <span class="Sans9GrNe">
                                                <cfinput name="pos31_imp" type="checkbox" id="pos31_imp" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos31 EQ 'Si',DE("yes"),DE("no"))#">
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                                </cfif>
                                <!-- Opinión del Consejo Interno de la dependencia de adscripción -->
                                <tr>
                                    <td class="Sans9GrNe">#ctMovimiento.mov_pos26#</td>
                                    <td>
                                        <div align="center">
                                            <span class="Sans9GrNe">
                                                <cfinput name="pos26" id="pos26_s" type="radio" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos26 EQ 'Si',DE("yes"),DE("no"))#">S&iacute;&nbsp;
                                                <cfinput name="pos26" id="pos26_n" type="radio" value="No" disabled='#vActivaCampos#' checked="#Iif(vCampoPos26 EQ 'No',DE("yes"),DE("no"))#">No
                                            </span>
                                        </div>
                                    </td>
                                    <td>
                                        <div align="center">
                                            <span class="Sans9GrNe">
                                                <cfinput name="pos27" id="pos27" type="checkbox" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos27 EQ 'Si',DE("yes"),DE("no"))#">
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                                <!-- Opinión de los directores -->
                                <tr>
                                    <td class="Sans9GrNe">#ctMovimiento.mov_pos28#</td>
                                    <td>
                                        <div align="center">
                                            <span class="Sans9GrNe">
                                                <cfinput name="pos28" id="pos28_s" type="radio" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos28 EQ 'Si',DE("yes"),DE("no"))#">S&iacute;&nbsp;
                                                <cfinput name="pos28" id="pos28_n" type="radio" value="No" disabled='#vActivaCampos#' checked="#Iif(vCampoPos28 EQ 'No',DE("yes"),DE("no"))#">No
                                            </span>
                                        </div>
                                    </td>
                                    <td>
                                        <div align="center">
                                            <span class="Sans9GrNe">
                                                <cfinput name="pos29" type="checkbox" id="pos29" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos29 EQ 'Si',DE("yes"),DE("no"))#">
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </cfoutput>
                        <!-- Documentación -->
                        <cfoutput>
                            <table border="0" class="cuadrosFormularios">
                                <tr bgcolor="##CCCCCC">
                                    <td width="85%"></td>
                                    <td width="15%"><div align="center" class="Sans9GrNe"><b>Se anexa</b></div></td>
                                </tr>
                                <!-- Carta del interesado dirigida al director -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos32#</span></td>
                                    <td>
                                        <div align="center">
                                            <cfinput name="pos32" type="checkbox" id="pos32" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos32 EQ 'Si',DE("yes"),DE("no"))#">
                                        </div>
                                    </td>
                                </tr>
                                <!-- Programa de actividades e informe (avalados para el caso de técnicos académicos) -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos34#</span></td>
                                    <td>
                                        <div align="center">
                                            <cfinput name="pos34" type="checkbox" id="pos34" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos34 EQ 'Si',DE("yes"),DE("no"))#">
                                        </div>
                                    </td>
                                </tr>
                                <!-- Curriculum vitae -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos36#</span></td>
                                    <td>
                                        <div align="center">
                                            <cfinput name="pos36" type="checkbox" id="pos36" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos36 EQ 'Si',DE("yes"),DE("no"))#">
                                        </div>
                                    </td>
                                </tr>
                                <!-- Aprobación del consejo técnico correspondiente, cuando proceda de fuera del subsistema -->
                                <tr>
                                    <td> <p><span class="Sans9GrNe">#ctMovimiento.mov_pos38#</span></p></td>
                                    <td>
                                        <div align="center">
                                            <cfinput name="pos38" type="checkbox" id="pos38" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos38 EQ 'Si',DE("yes"),DE("no"))#">
                                        </div>
                                    </td>
                                </tr>
                                <!-- Copia de nombramiento cuando proceda de otro subsistema -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos39#</span></td>
                                    <td>
                                        <div align="center">
                                            <cfinput name="pos39" type="checkbox" id="pos39" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos39 EQ 'Si',DE("yes"),DE("no"))#">
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </cfoutput>
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
<!--- VERIFICA QUE EL ACADÉMICO TENGA CONTRATO VIGENTE --->
<cfif #vTipoComando# EQ 'NUEVO' AND (#tbAcademico.con_clave# EQ 2 OR #tbAcademico.con_clave# EQ 3)>
	<cfquery name="tbMovimientosVigencia" datasource="#vOrigenDatosSAMAA#">
		SELECT * FROM ((movimientos
		LEFT JOIN catalogo_movimiento ON movimientos.mov_clave = catalogo_movimiento.mov_clave)
		LEFT JOIN movimientos_asunto ON movimientos.sol_id = movimientos_asunto.sol_id)
		LEFT JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave
		WHERE acd_id = #vIdAcad#
		AND (movimientos.mov_clave = 5 OR movimientos.mov_clave = 6 OR movimientos.mov_clave = 9 OR movimientos.mov_clave = 10 OR movimientos.mov_clave = 17 OR movimientos.mov_clave = 19 OR movimientos.mov_clave = 25)
		AND (GETDATE() BETWEEN mov_fecha_inicio AND mov_fecha_final)
		AND asu_reunion = 'CTIC'
		AND dec_super = 'AP' <!--- Asuntos aprobados --->
	</cfquery>
	<cfif #tbMovimientosVigencia.RecordCount# EQ 0>
		<script type="text/javascript">
			alert('AVISO: El académico no tiene un contrato vigente. Si prosigue con la captura la solicitud será rechazada.');
		</script>
	</cfif>
</cfif>
