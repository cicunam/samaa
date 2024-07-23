<!--- CREADO: ARAM PICHARDO--->
<!--- EDITO: ARAM PICHARDO--->
<!--- FECHA CREA: 03/06/2009 --->
<!--- FECHA ÚLTIMA MOD.: 18/07/2024 --->
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
				//vMensaje += fValidaCampoLleno('pos11_u','UBICACIÓN');
				vMensaje = fValidaCampoLleno('pos12_o','SUBSISTEMA AL QUE ASPIRA');
				if (!document.getElementById('pos12_o').value == '') vMensaje += fValidaCampoLleno('pos11','DEPENDENCIA A LA QUE ASPIRA');
				//if (document.getElementById('pos12_o').value == 03) vMensaje += fValidaCampoLleno('pos11','UBICACIÓN DE LA DEPENDENCIA QUE ASPIRA');	// El if es necesario porque falla cuando la dependencia no es del SIC.
				//vMensaje += fValidaFecha('pos14','INICIO');
				//if (!document.getElementById('pos20_s').checked && !document.getElementById('pos20_n').checked) vMensaje += "Campo: EL CAMBIO ES DE debe seleccionar una opción.\n";
				//if (!document.getElementById('pos10_t').checked && !document.getElementById('pos10_d').checked && !document.getElementById('pos10_c').checked && !document.getElementById('pos10_tp').checked) vMensaje += "Campo: TIPO DE CAMBIO debe seleccionar una opción.\n";
				//if (document.getElementById('pos10_t').checked) vMensaje += fValidaDuracionAMD();
				//if (document.getElementById('pos10_d').checked && !document.getElementById('pos5_d').checked) vMensaje += "Solo se puede conceder un cambio DEFINITIVO a personal definitivo.\n";
				//if (document.getElementById('pos11').value == document.getElementById('pos1').value) vMensaje += "Las adscipción ACTUAL y A LA QUE ASPIRA no pueden ser iguales.\n";
				vMensaje += fValidaDuracion();
				<!---vMensaje += <cfoutput>#tbMovimientosVigencia.RecordCount#</cfoutput> > 0 ? '' : 'El académico no tiene un contrato vigente.\n';--->
				// Desplegar los mensajes de error encontrados en la forma, si existen:
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
			function fPosAdscrip()
			{
				// CREA LAS VARIABLES DE PARA CARGAR LOS OBJETOS
				var linea_1, linea_2, linea_3, linea_4, linea_5, linea_6, linea_7, linea_8, linea_9

				if (document.getElementById('trLinea_1')) linea_1 = document.getElementById('trLinea_1');		// Titulo Adscripción actual
				if (document.getElementById('trLinea_2')) linea_2 = document.getElementById('trLinea_2');		// Entidad Actual
				if (document.getElementById('trLinea_3')) linea_3 = document.getElementById('trLinea_3');		// Ubicación Actual
				if (document.getElementById('trLinea_4')) linea_4 = document.getElementById('trLinea_4');		// Titulo Aspira
				if (document.getElementById('trLinea_5')) linea_5 = document.getElementById('trLinea_5');		// Subsistema Aspira
				if (document.getElementById('trLinea_6')) linea_6 = document.getElementById('trLinea_6');		// Entidad Aspira
				if (document.getElementById('trLinea_7')) linea_7 = document.getElementById('trLinea_7');		// Dependencia (movimiento)
				if (document.getElementById('trUbicaDepAspira')) linea_8 = document.getElementById('trUbicaDepAspira');		// Ubicación (movimiento)
				if (document.getElementById('trLinea_9')) linea_9 = document.getElementById('trLinea_9');		// Tr Final

				if (document.getElementById('pos20_s').checked == false && document.getElementById('pos20_n').checked == false)
				{
					//alert('SIN OPCION')
				}
				if (document.getElementById('pos20_s').checked == true)
				{
					//alert('DE LA ENTIDAD A OTRA')
					DatosSolFt13.insertBefore(linea_5,linea_9);
					DatosSolFt13.insertBefore(linea_6,linea_9);
					if (document.getElementById('trLinea_7')) DatosSolFt13.insertBefore(linea_7,linea_4);
					if (document.getElementById('trUbicaDepAspira')) DatosSolFt13.insertBefore(linea_8,linea_9);
					DatosSolFt13.insertBefore(linea_2,linea_4);
					DatosSolFt13.insertBefore(linea_3,linea_4);
				}
				if(document.getElementById('pos20_n').checked == true)
				{
					//alert('DE OTRA ENTIDAD A LA ENTIDAD')
					DatosSolFt13.insertBefore(linea_5,linea_4);
					DatosSolFt13.insertBefore(linea_6,linea_4);
					if (document.getElementById('trLinea_7')) DatosSolFt13.insertBefore(linea_7,linea_4);
					if (document.getElementById('trUbicaDepAspira')) DatosSolFt13.insertBefore(linea_8,linea_4);
					DatosSolFt13.insertBefore(linea_2,linea_9);
					DatosSolFt13.insertBefore(linea_3,linea_9);
				}
			}
		</script>
	</head>
	<body onLoad="actualizar(); fObtenerDepUnam(); fPosAdscrip();">
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
                                <cfquery name="ctDependencia" datasource="#vOrigenDatosCATALOGOS#">
                                    SELECT * FROM catalogo_dependencias
                                    WHERE dep_clave = '#vCampoPos11#'
                                </cfquery>
        
                                <cfset vCampoPos12_o_txt = ''>
                                <cfloop query="ctSubsistema">
                                    <cfif #sis_clave# IS #vCampoPos12_o#>
                                        <cfset vCampoPos12_o_txt = '#sis_nombre_1#'>
                                        <cfbreak>
                                    </cfif>
                                </cfloop>
        
                                <cfset vCampoPos1_u_txt = ''>
                                <cfloop query="ctUbicacion">
                                    <cfif #ubica_clave# IS #vCampopos1_u#>
                                        <cfset vCampoPos1_u_txt = '#ubica_completa#'>
                                        <cfbreak>
                                    </cfif>
                                </cfloop>
        
                                <cfset vCampoPos11_u_txt = ''>
                                <cfloop query="ctUbicacion2">
                                    <cfif #ubica_clave# IS #vCampopos11_u#>
                                        <cfset vCampoPos11_u_txt = '#ubica_completa#'>
                                        <cfbreak>
                                    </cfif>
                                </cfloop>
        
                                <table border="0" class="cuadrosFormularios">
                                    <!-- Subsistema al que asíra -->
                                    <tr>
                                        <td colspan="2" bgcolor="##CCCCCC">
                                            <span class="Sans9GrNe"><center>ADSCRIPCI&Oacute;N ACTUAL</center></span>
                                        </td>
                                    </tr>
                                    <cfif #vCampoPos20# EQ 'No'>
                                    <tr>
                                        <td><span class="Sans9GrNe">Subsistema</span></td>
                                        <td><span class="Sans9Gr">#vCampoPos12_o_txt#</span></td>
                                    </tr>
                                    </cfif>
                                    <!-- Dependencia actual (solo se muestra) -->
                                    <tr>
                                        <td width="20%">
                                            <span class="Sans9GrNe">
                                            <cfif #vCampoPos20# EQ 'Si'>#ctMovimiento.mov_pos11_e#
                                              <cfelse>#ctMovimiento.mov_pos11#
                                            </cfif>
                                            </span>
                                            </td>
                                        <td width="80%">
                                            <span class="Sans9Gr">
                                            <cfif #vCampoPos20# EQ 'Si'>#vCampoPos1_txt#
                                            <cfelse>#ctDependencia.dep_nombre#
                                            </cfif>
                                            </span>
                                        </td>
                                    </tr>
                                    <cfif (#vCampoPos20# EQ 'Si' AND #Mid(vCampoPos1,1,2)# EQ '03') OR (#vCampoPos20# EQ 'No' AND #Mid(vCampoPos11,1,2)# EQ '03')>
                                    <!-- Ubicación actual (solo se muestra) -->
                                    <tr>
                                        <td>
                                            <span class="Sans9GrNe">
                                            <cfif #vCampoPos20# EQ 'Si'>#ctMovimiento.mov_pos11_c#
                                            <cfelse>#ctMovimiento.mov_pos11_u#
                                            </cfif>
                                            </span>
                                            </td>
                                        <td>
                                            <span class="Sans9Gr">
                                            <cfif #vCampoPos20# EQ 'Si'>#vCampoPos1_u_txt#
                                            <cfelse>#vCampoPos11_u_txt#
                                            </cfif>
                                            </span>
                                        </td>
                                    </tr>
                                    </cfif>
                                    <!-- Titulo del recuadro -->
                                    <tr>
                                        <td colspan="2" bgcolor="##CCCCCC">
                                            <span class="Sans9GrNe"><center>ENTIDAD A LA QUE ASPIRA</center></span>
                                        </td>
                                    </tr>
                                    <!-- Subsistema al que asíra -->
                                    <cfif #vCampoPos20# EQ 'Si'>
                                    <tr>
                                        <td><span class="Sans9GrNe">Subsistema</span></td>
                                        <td>
                                            <span class="Sans9Gr">
                                                #vCampoPos12_o_txt#
                                          </span>
                                        </td>
                                    </tr>
                                    </cfif>
                                    <!-- Dependencia ala que aspira -->
                                    <tr>
                                        <td>
                                            <span class="Sans9GrNe">
                                            <cfif #vCampoPos20# EQ 'Si'>#ctMovimiento.mov_pos11#
                                            <cfelse>#ctMovimiento.mov_pos11_e#
                                            </cfif>
                                            </span>
                                        </td>
                                        <td>
                                            <span class="Sans9Gr">
                                            <cfif #vCampoPos20# EQ 'Si'>#ctDependencia.dep_nombre#
                                            <cfelse>#vCampoPos1_txt#
                                            </cfif>
                                            </span>
                                        </td>
                                    </tr>
                                    <!-- Ubicación a la que aspira -->
                                    <cfif (#vCampoPos20# EQ 'No' AND #Mid(vCampoPos1,1,2)# EQ '03') OR (#vCampoPos20# EQ 'Si' AND #Mid(vCampoPos11,1,2)# EQ '03')>
                                    <tr>
                                        <td>
                                            <span class="Sans9GrNe">
                                            <cfif #vCampoPos20# EQ 'Si'>#ctMovimiento.mov_pos11_u#
                                            <cfelse>#ctMovimiento.mov_pos11_c#
                                            </cfif>
                                            </span>
                                        </td>
                                        <td>
                                            <span class="Sans9Gr">
                                            <cfif #vCampoPos20# EQ 'Si'>#vCampoPos11_u_txt#
                                            <cfelse>#vCampoPos1_u_txt#
                                            </cfif>
                                            </span>
                                        </td>
                                    </tr>
                                    </cfif>
                                    <tr>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    </tbody>
                                </table>
                          <cfelse>
                                <table border="0" class="cuadrosFormularios">
                                    <tbody id="DatosSolFt13">
                                    <!-- Titulo del recuadro -->
                                    <tr>
                                        <td>El cambio es </td>
                                        <td>
                                            <cfinput name="pos20" id="pos20_s" type="radio" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos20 EQ 'Si',DE("yes"),DE("no"))#" onClick="fPosAdscrip();"><span class="Sans9GrNe">Del #vCampoPos1_txt# a OTRA Entidad</span><br/><!---De la Entidad (#vCampoPos1_Siglas#) a otra Entidad--->
                                            <cfinput name="pos20" id="pos20_n" type="radio" value="No" disabled='#vActivaCampos#' checked="#Iif(vCampoPos20 EQ 'No',DE("yes"),DE("no"))#" onClick="fPosAdscrip();"><span class="Sans9GrNe">De OTRA Entidad al #vCampoPos1_txt#</span><!---De Otra Entidad a la Entidad (#vCampoPos1_Siglas#)--->
                                        </td>
                                    </tr>
                                    <tr id="trLinea_1">
                                        <td colspan="2" bgcolor="##CCCCCC">
                                            <span class="Sans9GrNe"><center>ADSCRIPCI&Oacute;N ACTUAL</center></span>
                                        </td>
                                    </tr>
                                    <!-- Dependencia actual (solo se muestra) -->
                                    <tr id="trLinea_2">
                                        <td width="20%"><span class="Sans9GrNe">#ctMovimiento.mov_pos11_e#</span></td>
                                        <td width="80%">
                                            <cfinput name="dep_txt" type="text" class="datos100" value="#vCampoPos1_txt#" disabled>
                                        </td>
                                    </tr>
                                    <!-- Ubicación actual (solo se muestra) -->
                                    <tr id="trLinea_3">
                                        <td><span class="Sans9GrNe">#ctMovimiento.mov_pos11_c#</span></td>
                                        <td>
                                            <cfselect name="pos1_u" id="pos1_u" class="datos" query="ctUbicacion" value="ubica_clave" display="ubica_completa" queryPosition="below" selected="#vCampoPos1_u#" style="width:480px;" disabled='#vActivaCampos#'>
                                            <cfif #ctUbicacion.RecordCount# GT 1>
                                                <option value="">SELECCIONE</option>
                                            </cfif>
                                            </cfselect>
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
                                        <td><span class="Sans9GrNe">Subsistema</span></td>
                                        <td>
                                            <cfselect name="pos12_o" class="datos" id="pos12_o" query="ctSubsistema" value="sis_clave" display="sis_nombre_1" queryPosition="below" disabled='#vActivaCampos#' selected="#vCampoPos12_o#" onChange="fObtenerDepUnam();">
                                                <option value="">SELECCIONE</option>
                                            </cfselect>
                                        </td>
                                    </tr>
                                    <!-- Dependencia ala que aspira -->
                                    <tr id="trLinea_6">
                                        <td><span class="Sans9GrNe">#ctMovimiento.mov_pos11#</span></td>
                                        <td>
                                            <div id="depunam_dynamic"><!-- AJAX: Dependencias del SS seleccionado --></div>
                                        </td>
                                    </tr>
                                    <!-- Ubicación a la que aspira -->
                                    <tr id="trUbicaDepAspira">
                                        <td><span class="Sans9GrNe">#ctMovimiento.mov_pos11_u#</span></td>
                                        <td><div id="ubicasic_dynamic"><!-- AJAX: Ubicaciones de la dependencia seleccionada --></div></td>
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
						<!--- Llamado a INCLUDE general de los dictámenes requeridos en la FT 18/07/2024 --->
						<cfinclude template="ft_include_anexoDictamen.cfm">
<!---
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
--->
						<!-- Documentación -->
						<!--- Llamado a INCLUDE general de los anexos requeridos en la FT 18/07/2024 --->
						<cfinclude template="ft_include_anexoAnexos.cfm">
<!---
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
