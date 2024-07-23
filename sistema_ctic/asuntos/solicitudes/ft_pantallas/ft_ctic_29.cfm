<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 21/04/2009 --->
<!--- FECHA ÚLTIMA MOD.: 25/11/2021 --->
<!--- FT-CTIC-29.-Cambio de ubicación Temporal o Definitivo --->

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

<html>
	<head>
		<!-- INCLUDE que agrega parte del contenido del encabezado -->
		<cfinclude template="ft_include_head_comun.cfm">
		<!-- JAVA SCRIT de uso local -->
		<script type="text/javascript">
			function actualizar()
			{
				if (document.getElementById('pos10_t').checked)
				{
					//show('pos13_txt')
					show('pos13_a');
					show('pos13_m');
					show('pos13_d');
					show('pos15');
					show('pos13_a_txt');
					show('pos13_m_txt');
					show('pos13_d_txt');
					show('pos14_txt');
					show('pos15_txt');
					changeText('pos13_txt','Duración');
				}
				else
				{
					//hide('pos13_txt');
					hide('pos13_a');
					hide('pos13_m');
					hide('pos13_d');
					hide('pos15');
					hide('pos13_a_txt');
					hide('pos13_m_txt');
					hide('pos13_d_txt');
					hide('pos14_txt');
					hide('pos15_txt');
					changeText('pos13_txt','A partir del');
					document.getElementById('pos13_a').value = '';
					document.getElementById('pos13_m').value = '';
					document.getElementById('pos13_d').value = '';
					document.getElementById('pos15').value = '';
				}
				// Si el usuario elige, "Por nombramiento":
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
				vMensaje += fValidaCampoLleno('pos1_u','UBICACIÓN ACTUAL');
				vMensaje += fValidaCampoLleno('pos11_u','UBICACIÓN A LA QUE CAMBIA');
				if (document.getElementById('pos10_c').checked) vMensaje += fValidaCampoLleno('pos12','TIPO DE NOMBRAMIENTO');
				vMensaje += fValidaFecha('pos14','INICIO');
				if (document.getElementById('pos10_t').checked) vMensaje += fValidaDuracionAMD();
				if (document.getElementById('pos10_d').checked && !document.getElementById('pos5_d').checked) vMensaje += "Solo se puede conceder un cambio DEFINITIVO a personal definitivo.\n";
				if (document.getElementById('pos11_u').value == document.getElementById('pos1_u').value) vMensaje += "Las ubicaciones ACTUAL y A LA QUE CAMBIA no pueden ser iguales.\n";
				vMensaje += fValidaDuracion();
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
		</script>
	</head>
	<body onLoad="actualizar();">
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
                            <table border="0" class="cuadrosFormularios">
                                <!-- Ubicación actual actual (obtenida por el sistema) -->
                                <tr>
                                    <td width="20%"><span class="Sans9GrNe"><cfoutput>#ctMovimiento.mov_pos1_u#</cfoutput></span></td>
                                    <td width="80%">
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <cfset vCampoPos1_u_txt = ''>
                                            <cfloop query="ctUbicacion">
                                                <cfif #ubica_clave# IS #vCampoPos1_u#>
                                                    <cfset vCampoPos1_u_txt = '#ubica_completa#'>
                                                    <cfbreak>
                                                </cfif>
                                            </cfloop>
                                            <span class="Sans9Gr">#vCampoPos1_u_txt#</span>
                                        <cfelse>adasdas
                                            <cfselect name="pos1_u" id="pos1_u" class="datos100" query="ctUbicacion" value="ubica_clave" display="ubica_completa" queryPosition="Below" disabled selected="#vCampoPos1_u#">
                                                <option value="">SELECCIONE</option>
                                            </cfselect>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Ubicación a la que apspira -->
                                <tr>
                                    <td><span class="Sans9GrNe"><cfoutput>#ctMovimiento.mov_pos11_u#</cfoutput></span></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <cfset vCampoPos1_u_txt = ''>
                                            <cfloop query="ctUbicacion">
                                                <cfif #ubica_clave# IS #vCampopos11_u#>
                                                    <cfset vCampoPos1_i_txt = '#ubica_completa#'>
                                                    <cfbreak>
                                                </cfif>
                                            </cfloop>
                                            <span class="Sans9Gr">#vCampoPos1_i_txt#</span>
                                        <cfelse>
                                            <cfselect name="pos11_u" id="pos11_u" class="datos100" query="ctUbicacion" value="ubica_clave" display="ubica_completa" queryPosition="Below" disabled='#vActivaCampos#' selected="#vCampopos11_u#">
                                                <option value="">SELECCIONE</option>
                                            </cfselect>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Temporal o definitivo -->
                                <tr>
                                    <td><span class="Sans9GrNe">Tipo de cambio</span></td>
                                    <td>
                                        <cfinput name="pos10" id="pos10_d" type="radio" value="1" disabled='#vActivaCampos#' checked="#Iif(vCampoPos10 EQ '1',DE("yes"),DE("no"))#" onclick="actualizar();">
                                        <span class="Sans9Gr">Definitivo&nbsp;</span>
                                        <cfinput name="pos10" id="pos10_t" type="radio" value="2" disabled='#vActivaCampos#' checked="#Iif(vCampoPos10 EQ '2',DE("yes"),DE("no"))#" onclick="actualizar();">
                                        <span class="Sans9Gr">Temporal&nbsp;</span>
                                        <cfinput name="pos10" id="pos10_c" type="radio" value="3" disabled='#vActivaCampos#' checked="#Iif(vCampoPos10 EQ '3',DE("yes"),DE("no"))#" onclick="actualizar();">
                                        <span class="Sans9Gr">Por cargo o nombramiento</span>
                                    </td>
                                </tr>
                                <!-- Tipo de nombramiento -->
                                <cfif #vTipoComando# IS 'IMPRIME'>
                                    <cfif #vCampoPos12# IS NOT ''>
                                        <tr>
                                            <td><span class="Sans9GrNe">#ctMovimiento.mov_pos12#</span></td>
                                            <td><span class="Sans9Gr">#vCampoPos12#</span></td>
                                        </tr>
                                    </cfif>
                                <cfelse>
                                    <tr id="pos12_fila">
                                        <td><span class="Sans9GrNe"><cfoutput>#ctMovimiento.mov_pos12#</cfoutput></span></td>
                                        <td>
                                            <cfinput name="pos12" id="pos12" type="text" maxlength="254" class="datos100" disabled='#vActivaCampos#' value="#vCampoPos12#">
                                        </td>
                                    </tr>
                                </cfif>
                                <!-- Duración -->
                                <cfif #vTipoComando# IS 'IMPRIME'>
                                    <tr>
                                        <td>
                                            <span class="Sans9GrNe" id="pos13_txt">
                                                <cfif #vCampoPos10# IS 2>
                                                    Duraci&oacute;n
                                                <cfelse>
                                                    A partir de
                                                </cfif>
                                            </span>
                                        </td>
                                        <td>
                                            <span class="Sans9Gr">
                                                <cfif #vCampoPos10# IS 2>
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
                                                <cfif #vCampoPos10# IS 2>del&nbsp;</cfif>
                                                #FechaCompleta(vCampoPos14)#&nbsp;
                                                <cfif #vCampoPos10# IS 2> al #FechaCompleta(vCampoPos15)#&nbsp; </cfif>
                                            </span>
                                        </td>
                                    </tr>
                                <cfelse>
                                    <tr>
                                        <td><span class="Sans9GrNe"id="pos13_txt">#ctMovimiento.mov_pos13#</span></td>
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
                                            <!-- Fehas -->
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
                                <!-- Encabezados -->
                                <tr bgcolor="##CCCCCC">
                                    <td width="65%"></td>
                                    <td width="20%"> <div align="center" class="Sans10NeNe">Aprobatoria</div></td>
                                    <td width="15%"> <div align="center" class="Sans10NeNe">Se anexa</div></td>
                                </tr>
                                <!-- Opición del consejo interno -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos26#</span></td>
                                    <td>
                                        <!-- Si/no -->
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
                        <!-- Documentación -->
                        <cfoutput>
                            <table border="0" class="cuadrosFormularios">
                                <!-- Encabezados -->
                                <tr bgcolor="##CCCCCC">
                                    <td width="85%"></td>
                                    <td width="15%"><div align="center" class="Sans10NeNe">Se anexa</div></td>
                                </tr>
                                <!-- Carta del interesado -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos32#</span></td>
                                    <td><div align="center"><cfinput name="pos32" type="checkbox" id="pos32" value="Si" checked="#Iif(vCampoPos32 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Programa e informe de actividades (avalado para el caso de técnicos académicos) -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos34#</span></td>
                                    <td><div align="center"><cfinput name="pos34" type="checkbox" id="pos34" value="Si" checked="#Iif(vCampoPos34 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
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
