<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 23/04/2009 --->
<!--- FECHA ÚLTIMA MOD.: 27/06/2016 --->
<!--- FT-CTIC-36.-Reingreso a la UNAM (Personal académico jubilado) --->

<!--- Incluir los siguientes archivos --->
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

<!---Obtener la fecha de retiro del académico --->
<cfif #vCampoPos21# EQ 'dd/mm/yyyy' OR #vCampoPos21# EQ ''>
	<cfset vCampoPos21=#LsdateFormat(tbMovimientosBaja.mov_fecha_inicio,'dd/mm/yyyy')#>
</cfif>

<html>
	<head>
		<!-- INCLUDE que agrega parte del contenido del encabezado -->
		<cfinclude template="ft_include_head_comun.cfm">
		<!-- JAVA SCRIT de uso local -->
		<script type="text/javascript">
			// Validar los datos ingresados por el usuario:
			function fValidaCamposFt()
			{
				var vMensaje = '';
				fLimpiaValida();
				vMensaje += fValidaCampoLleno('pos1_u','UBICACIÓN');
				vMensaje += fValidaFecha('pos21','JUBILACIÓN');
				vMensaje += fValidaFecha('pos14','INICIO');
				vMensaje += fValidaDuracionAMD();
				vMensaje += fValidaDuracion();
				vMensaje += fValidaCampoLleno('pos8','CATEGORÍA Y NIVEL');
				vMensaje += fValidaFechaPosterior('pos14','pos21') ? '': 'La fecha de REINGRESO debe ser posterior que la fecha de RETIRO.\n';
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
	<body>
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
                        <!-- Datos obtenidos por el sistema -->
                        <cfoutput>
                            <table width="620" height="76" border="0" class="cuadros">
                                <tr bgcolor="##CCCCCC">
                                    <td colspan="2">
                                        <span class="Sans9GrNe"><center>DATOS AL MOMENTO DE SU RETIRO</center></span>
                                    </td>
                                </tr>
                                <!-- Fecha de retiro (obtenida del sistema)-->
                                <tr>
                                    <td width="20%"><span class="Sans9GrNe">#ctMovimiento.mov_pos21#</span></td>
                                    <td width="80%">
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos21)#</span>
                                        <cfelse>
                                            <cfinput name="pos21" id="pos21" type="text" size="10" maxlength="10" class="datos" value="#vCampoPos21#" disabled='#vActivaCampos#' onkeypress="return MascaraEntrada(event, '99/99/9999');">
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Categoría y nivel al retirarse -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos3#</span></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoPos3_txt#</span>
                                        <cfelse>
                                            <cfinput name="pos3_txt" id="pos3_txt" type="text" class="datos" size="20" value="#vCampoPos3_txt#" disabled>
                                            <cfinput name="pos3" id="pos3" type="hidden" value="#vCampoPos3#">
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Tipo de contrato al retirarse -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos5# </span></td>
                                    <td>
                                        <span class="Sans9Gr">
                                            <cfinput type="radio" name="pos5" id="pos5_i" value="2" checked="#Iif(vCampoPos5 EQ "2",DE("yes"),DE("no"))#" disabled>Concurso Abierto&nbsp;
                                            <cfinput type="radio" name="pos5" id="pos5_d" value="1" checked="#Iif(vCampoPos5 EQ "1",DE("yes"),DE("no"))#" disabled>Definitivo&nbsp;
                                            <cfinput type="radio" name="pos5" id="pos5_o" value="3" checked="#Iif(vCampoPos5 EQ "3",DE("yes"),DE("no"))#" disabled>Obra determinada
                                        </span>
                                    </td>
                                </tr>
                                <!-- Antigëdad antes de retirarse -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos6#</span></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoPos6_txt#</span>
                                        <cfelse>
                                            <cfinput name="pos6_txt" id="pos6_txt" type="text" class="datos" size="30" value="#vCampoPos6_txt#" disabled>
                                            <cfinput name="pos6" id="pos6" type="hidden" value="#vCampoPos6#">
                                        </cfif>
                                    </td>
                                </tr>
                            </table>
                        </cfoutput>

                        <!-- Datos que deben ingresarse -->
                        <cfoutput>
                            <table border="0" class="cuadrosFormularios">
                                <!-- Duración -->
                                <tr>
                                    <td width="20%"><span class="Sans9GrNe">#ctMovimiento.mov_pos13#</span></td>
                                    <td width="80%">
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span
                                                <cfif #vCampoPos13_a# EQ 0>class="NoImprimir"</cfif>
                                                >
                                                <span class="Sans9Gr">
                                                    #vCampoPos13_a# #ctMovimiento.mov_pos13_a#&nbsp;
                                                </span>
                                            </span>
                                            <span
                                                <cfif #vCampoPos13_m# EQ 0>class="NoImprimir"</cfif>
                                                >
                                                <span class="Sans9Gr">
                                                    #vCampoPos13_m# #ctMovimiento.mov_pos13_m#&nbsp;
                                                </span>
                                            </span>
                                            <span
                                                <cfif #vCampoPos13_d# EQ 0>class="NoImprimir"</cfif>
                                                >
                                                <span class="Sans9Gr">
                                                    #vCampoPos13_d# #ctMovimiento.mov_pos13_d#&nbsp;
                                                </span>
                                            </span>
                                        <cfelse>
                                            <span
                                                <cfif #vCampoPos13_a# EQ 0>class="NoImprimir"</cfif>
                                                ><cfinput name="pos13_a" type="text" class="datos" id="pos13_a" size="1" maxlength="1" disabled='#vActivaCampos#' value="#vCampoPos13_a#" onChange="CalcularSiguienteFecha();" onkeypress="return MascaraEntrada(event, '9');">
                                                <span class="Sans9Gr">
                                                    #ctMovimiento.mov_pos13_a#
                                                </span>
                                            </span>
                                            <span
                                                <cfif #vCampoPos13_m# EQ 0>class="NoImprimir"</cfif>
                                                ><cfinput name="pos13_m" type="text" class="datos" id="pos13_m" size="2" maxlength="2" disabled='#vActivaCampos#' value="#vCampoPos13_m#" onChange="CalcularSiguienteFecha();" onkeypress="return MascaraEntrada(event, '99');">
                                                <span class="Sans9Gr">
                                                    #ctMovimiento.mov_pos13_m#
                                                </span>
                                            </span>
                                            <span
                                                <cfif #vCampoPos13_d# EQ 0>class="NoImprimir"</cfif>
                                                ><cfinput name="pos13_d" type="text" class="datos" id="pos13_d" size="2" maxlength="2" disabled='#vActivaCampos#'  value="#vCampoPos13_d#" onChange="CalcularSiguienteFecha();" onkeypress="return MascaraEntrada(event, '99');">
                                                <span class="Sans9Gr">
                                                    #ctMovimiento.mov_pos13_d#
                                                </span>
                                            </span>
                                        </cfif>
                                        <!-- Fechas -->
                                        <span class="Sans9Gr">#ctMovimiento.mov_pos14# </span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos14)#&nbsp;</span>
                                        <cfelse>
                                            <cfinput type="text" name="pos14" class="datos" id="pos14" size="10" maxlength="10" disabled='#vActivaCampos#' value="#vCampoPos14#" onChange="CalcularSiguienteFecha();" onkeypress="return MascaraEntrada(event, '99/99/9999');">
                                        </cfif>
                                        <span class="Sans9Gr">#ctMovimiento.mov_pos15# </span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos15)#&nbsp;</span>
                                        <cfelse>
                                            <cfinput name="pos15" id="pos15" type="text" class="datos" size="10" maxlength="10" value="#vCampoPos15#" disabled>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- CCN con que reingresa -->
                                <tr>
                                    <td colspan="2">
                                        <span class="Sans9GrNe">#ctMovimiento.mov_pos8#&nbsp;</span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoPos8_txt#</span>
<!--- ELIMINA XXXXXXXXXXXXXX
                                            <cfloop query="ctCategoria">
                                                <cfif #cn_clave# IS #vCampoPos8#>
                                                    <cfset vCampoPos8_txt = #cn_siglas#>
                                                    <cfbreak>
                                                </cfif>
                                            </cfloop>
                                            <span class="Sans9Gr">#vCampoPos8_txt#</span>
--->
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
                                        <div align="center" class="Sans9GrNe">
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
                                <!-- Constancia de categoría y nivel a su retiro -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos35#</span></td>
                                    <td><div align="center"><cfinput name="pos35" type="checkbox" id="pos35" value="Si" checked="#Iif(vCampoPos35 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Copia de renuncia o baja -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos37#</span></td>
                                    <td><div align="center"><cfinput name="pos37" type="checkbox" id="pos37" value="Si" checked="#Iif(vCampoPos37 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Curriculum vitae -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos36#</span></td>
                                    <td><div align="center"><cfinput name="pos36" type="checkbox" id="pos36" value="Si" checked="#Iif(vCampoPos36 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Programa de actividades -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos34#</span></td>
                                    <td><div align="center"><cfinput name="pos34" type="checkbox" id="pos34" value="Si" checked="#Iif(vCampoPos34 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Constancia del último grado obtenido -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos38#</span></td>
                                    <td><div align="center"><cfinput name="pos38" type="checkbox" id="pos38" value="Si" checked="#Iif(vCampoPos38 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
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
