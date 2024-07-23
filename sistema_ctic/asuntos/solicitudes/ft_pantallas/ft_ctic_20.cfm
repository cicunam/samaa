<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 23/04/2009 --->
<!--- FECHA ÚLTIMA MOD.: 19/07/2024 --->
<!--- FT-CTIC-20.-Reincorporación a la UNAM (personal no jubilado) --->

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

<!--- Obtener datos del catálogo de nombramiento (CATÁLOGOS GENERALES MYSQL) --->
<cfquery name="ctCategoria" datasource="#vOrigenDatosCATALOGOS#">
	SELECT * FROM catalogo_cn 
    WHERE cn_status = 1 
    ORDER BY cn_orden DESC
</cfquery>

<!--- Obtener el último registro de BAJA del académico --->
<cfquery name="tbMovimientosBaja" datasource="#vOrigenDatosSAMAA#">
	SELECT TOP 1 * FROM movimientos
	WHERE acd_id = #vIdAcad#
	AND mov_clave = 14
	AND ISNULL(baja_clave,0) <> 2 <!--- Baja distinta de "jubilación" --->
	ORDER BY mov_fecha_inicio DESC
</cfquery>

<!--- Obtener la fecha de retiro del académico --->
<cfif #vCampoPos21# EQ ''>
	<cfset vCampoPos21=#LsdateFormat(tbMovimientosBaja.mov_fecha_inicio,'dd/mm/yyyy')#>
</cfif>

<html>
	<head>
		<!-- INCLUDE que agrega parte del contenido del encabezado -->
		<cfinclude template="ft_include_head_comun.cfm">
		<!-- JAVA SCRIT de uso local -->
		<script type="text/javascript">
			// Actualizar el formulario:
			function fActualizar()
			{
				if (document.getElementById('pos10_t').checked)
				{
					show('duracion_dynamic');
					show('pos14_txt'); show('pos15'); show('pos15_txt');
					changeText('Duracion_txt','Duración');
				}
				else
				{
					hide('duracion_dynamic');
					hide('pos14_txt'); hide('pos15'); hide('pos15_txt');
					document.getElementById('pos13_a').value = '';	// Blanquear el campo (!)
					document.getElementById('pos13_m').value = '';	// Blanquear el campo (!)
					document.getElementById('pos13_d').value = '';	// Blanquear el campo (!)
					document.getElementById('pos15').value = '';	// Blanquear el campo (!)
					changeText('Duracion_txt','A partir del');
				}
			}
			// Validar los datos ingresados por el usuario:
			function fValidaCamposFt()
			{
				var vMensaje = '';
				fLimpiaValida();
				vMensaje += fValidaCampoLleno('pos1_u','UBICACIÓN');
				vMensaje += fValidaFecha('pos21','RETIRO');
				vMensaje += fValidaFecha('pos14','REINCORPORACIÓN');
				if (document.getElementById('pos10_t').checked) vMensaje += fValidaDuracionAMD();
				vMensaje += fValidaDuracion();
				vMensaje += fValidaCampoLleno('pos8','CATEGORÍA Y NIVEL');
				vMensaje += fValidaFechaPosterior('pos14','pos21') ? '': 'La fecha de REINCORPORACIÓN debe ser posterior que la fecha de RETIRO.\n';
				// Desplegar los mensajes de rror encontrados en la forma, si existen:
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
                                <tr>
                                    <!-- Tipo de reincorporación -->
                                    <td width="20%"><span class="Sans9GrNe">#ctMovimiento.mov_pos10#</span></td>
                                    <td width="80%">
                                        <span class="Sans9Gr">
                                            <cfinput name="pos10" id="pos10_d" type="radio" value="1" disabled='#vActivaCampos#' checked="#Iif(vCampoPos10 EQ '1',DE("yes"),DE("no"))#" onclick="fActualizar();">Definitiva
                                            <cfinput name="pos10" id="pos10_t" type="radio" value="2" disabled='#vActivaCampos#' checked="#Iif(vCampoPos10 EQ '2',DE("yes"),DE("no"))#" onclick="fActualizar();">Temporal
                                        </span>
                                    </td>
                                </tr>
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
                                        <td><span class="Sans9GrNe" id="Duracion_txt">#ctMovimiento.mov_pos13#</span></td>
                                        <td>
                                            <!-- Años, meses y días -->
                                            <span id="duracion_dynamic">
                                                <span <cfif #vCampoPos13_a# EQ 0>class="NoImprimir"</cfif>><cfinput name="pos13_a" type="text" class="datos" id="pos13_a" size="1" maxlength="1" disabled='#vActivaCampos#' value="#vCampoPos13_a#" onChange="CalcularSiguienteFecha();" onkeypress="return MascaraEntrada(event, '9');">
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
                                            </span>
                                            <!-- Fechas -->
                                            <span class="Sans9Gr" id="pos14_txt">#ctMovimiento.mov_pos14#</span>
                                            <cfinput type="text" name="pos14" class="datos" id="pos14" size="10" maxlength="10" disabled='#vActivaCampos#' value="#vCampoPos14#" onChange="if (document.getElementById('pos10_t').checked) CalcularSiguienteFecha();" onkeypress="return MascaraEntrada(event, '99/99/9999');">
                                            <span class="Sans9Gr" id="pos15_txt">#ctMovimiento.mov_pos15#</span>
                                            <cfinput name="pos15" id="pos15" type="text" class="datos" size="10" maxlength="10" disabled value="#vCampoPos15#">
                                        </td>
                                    </tr>
                                </cfif>
                                <!-- Número de plaza -->
                                <tr>
                                    <td><span class="Sans9GrNe" id="pos9_txt">#ctMovimiento.mov_pos9#</span></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoPos9#</span>
                                        <cfelse>
                                            <cfinput name="pos9" id="pos9" type="text" class="datos" size="8" maxlength="8" disabled='#vActivaCampos#' value="#vCampoPos9#" onkeypress="return MascaraEntrada(event, '99999-99');">
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- CYN con que se reincorpora -->
                                <tr>
                                    <td colspan="2">
                                        <span class="Sans9GrNe">#ctMovimiento.mov_pos8#</span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoPos8_txt#</span>
                                        <cfelse>
                                            <cfselect name="pos8" id="pos8" class="datos" query="ctCategoria" queryposition="below" value="cn_clave" display="cn_siglas" disabled='#vActivaCampos#' selected="#vCampoPos8#">
                                            <option value="" selected>SELECCIONE</option>
                                            </cfselect>
                                        </cfif>
                                    </td>
                                </tr>
                            </table>
                        </cfoutput>
  						<!-- Dictámenes -->
						<!--- Llamado a INCLUDE general de los dictámenes requeridos en la FT 19/07/2024 --->
						<cfinclude template="ft_include_anexoDictamen.cfm">
<!---
                        <cfoutput>
                            <table border="0" class="cuadrosFormularios">
                                <!-- Encabezados -->
                                <tr bgcolor="##CCCCCC">
                                    <td width="65%"></td>
                                    <td width="20%"><div align="center" class="Sans10NeNe">Aprobatorio</div></td>
                                    <td width="15%"><div align="center" class="Sans10NeNe">Se anexa</div></td>
                                </tr>
                                <!-- Opinión del consejo interno -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos26#</span></td>
                                    <td>
                                        <div align="center"class="Sans9GrNe">
                                            <cfinput name="pos26" type="radio" value="Si" checked="#Iif(vCampoPos26 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>S&iacute;&nbsp;
                                            <cfinput name="pos26" type="radio" value="No" checked="#Iif(vCampoPos26 EQ "No",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>No
                                        </div>
                                    </td>
                                    <td>
                                        <div align="center">
                                            <cfinput name="pos27" type="checkbox" id="pos27" value="Si" checked="#Iif(vCampoPos27 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>
                                        </div>
                                    </td>
                                </tr>
                                <!-- Carta del director -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos28#</span></td>
                                    <td>
                                        <div align="center" class="Sans9GrNe">
                                            <cfinput name="pos28" type="radio" value="Si" checked="#Iif(vCampoPos28 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>S&iacute;&nbsp;
                                            <cfinput name="pos28" type="radio" value="No" checked="#Iif(vCampoPos28 EQ "No",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>No
                                        </div>
                                    </td>
                                    <td>
                                        <div align="center">
                                            <cfinput name="pos29" type="checkbox" id="pos29" value="Si" checked="#Iif(vCampoPos29 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </cfoutput>
--->
						<!-- Documentación -->
						<!--- Llamado a INCLUDE general de los anexos requeridos en la FT 19/07/2024 --->
						<cfinclude template="ft_include_anexoAnexos.cfm">
<!---
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
                                <!-- Constancia de categoría y nivel a su retiro -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos33#</span></td>
                                    <td><div align="center"><cfinput name="pos33" type="checkbox" id="pos33" value="Si" checked="#Iif(vCampoPos33 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Copia de renuncia o baja -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos34#</span></td>
                                    <td><div align="center"><cfinput name="pos34" type="checkbox" id="pos34" value="Si" checked="#Iif(vCampoPos34 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Curriculum vitae -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos36#</span></td>
                                    <td><div align="center"><cfinput name="pos36" type="checkbox" id="pos36" value="Si" checked="#Iif(vCampoPos36 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Programa de actividades (avalado para el caso de técnicos académicos) -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos37#</span></td>
                                    <td><div align="center"><cfinput name="pos37" type="checkbox" id="pos37" value="Si" checked="#Iif(vCampoPos37 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Constancia de último grado obtenido -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos38#</span></td>
                                    <td><div align="center"><cfinput name="pos38" type="checkbox" id="pos38" value="Si" checked="#Iif(vCampoPos38 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
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
