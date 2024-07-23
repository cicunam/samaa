<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 21/04/2009 --->
<!--- FECHA ULTIMA MOD.: 23/06/2016 --->
<!--- FT-CTIC-26.-Personal Académico Visitante --->

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
				ObtenerEstados();
			}
			// Validación de los datos ingresados por el usuario:
			function fValidaCamposFt()
			{
				var vMensaje = '';
				fLimpiaValida();
				vMensaje += fValidaCampoLleno('pos1_u','UBICACIÓN');
				vMensaje += fValidaCampoLleno('pos11','INSTITUCIÓN');
				vMensaje += fValidaCampoLleno('pos11_p','PAÍS');
				if (document.getElementById('pos11_p').value=='MEX' || document.getElementById('pos11_p').value=='USA') vMensaje += fValidaCampoLleno('pos11_e','ESTADO');
				vMensaje += fValidaCampoLleno('pos11_c','CIUDAD');
				vMensaje += fValidaFecha('pos14','INICIO');
				vMensaje += fValidaDuracionAMD();
				vMensaje += fValidaDuracionMinima(30);
				vMensaje += fValidaDuracion();
				vMensaje += fValidaCampoLleno('memo1','LABOR');
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
                        <!-- Datos que deben ingresarse -->
                        <cfoutput>
                            <table border="0" class="cuadrosFormularios">
                                <!-- Institución de procedencia -->
                                <tr>
                                    <td width="25%"><span class="Sans9GrNe">#ctMovimiento.mov_pos11#</span></td>
                                    <td width="75%">
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoPos11#</span>
                                        <cfelse>
                                            <cfinput type="text" name="pos11" id="pos11" class="datos" size="60" maxlength="254" value="#vCampoPos11#" disabled='#vActivaCampos#'>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- País -->
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
                                    <td id="estados_dynamic">
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
                                            <!-- AJAX: Lista de estados -->
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
                                            <cfinput type="text" name="pos11_c" id="pos11_c" disabled='#vActivaCampos#' class="datos" value="#vCampoPos11_c#" size="35" maxlength="50">
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Duración -->
                                <tr>
                                    <td><span class="Sans9GrNe" id="pos13_a_txt">#ctMovimiento.mov_pos13#</span></td>
                                    <td>
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
                                                ><cfinput name="pos13_a" type="text" class="datos" id="pos13_a" size="1" maxlength="1" disabled='#vActivaCampos#' value="#vCampoPos13_a#" onchange="CalcularSiguienteFecha();" onkeypress="return MascaraEntrada(event, '9');">
                                                <span class="Sans9Gr" id="pos13_a_txt">
                                                    #ctMovimiento.mov_pos13_a#
                                                </span>
                                            </span>
                                            <span
                                                <cfif #vCampoPos13_m# EQ 0>class="NoImprimir"</cfif>
                                                ><cfinput name="pos13_m" type="text" class="datos" id="pos13_m" size="2" maxlength="2" disabled='#vActivaCampos#' value="#vCampoPos13_m#" onchange="CalcularSiguienteFecha();" onkeypress="return MascaraEntrada(event, '99');">
                                                <span class="Sans9Gr" id="pos13_m_txt">
                                                    #ctMovimiento.mov_pos13_m#
                                                </span>
                                            </span>
                                            <span
                                                <cfif #vCampoPos13_d# EQ 0>class="NoImprimir"</cfif>
                                                ><cfinput name="pos13_d" type="text" class="datos" id="pos13_d" size="2" maxlength="2" disabled='#vActivaCampos#' value="#vCampoPos13_d#" onchange="CalcularSiguienteFecha();" onkeypress="return MascaraEntrada(event, '99');">
                                                <span class="Sans9Gr" id="pos13_d_txt">
                                                    #ctMovimiento.mov_pos13_d#
                                                </span>
                                            </span>
                                        </cfif>
                                        <!-- Fechas -->
                                        <span class="Sans9Gr" id="pos14_txt">#ctMovimiento.mov_pos14#</span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos14)#&nbsp;</span>
                                        <cfelse>
                                            <cfinput type="text" name="pos14" class="datos" id="pos14" size="10" maxlength="10" disabled='#vActivaCampos#' value="#vCampoPos14#" onChange="CalcularSiguienteFecha();" onkeypress="return MascaraEntrada(event, '99/99/9999');">
                                        </cfif>
                                        <span class="Sans9Gr" id="pos15_txt">#ctMovimiento.mov_pos15#</span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos15)#</span>
                                        <cfelse>
                                            <cfinput name="pos15" id="pos15" type="text" class="datos" size="10" maxlength="10" disabled value="#vCampoPos15#">
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Labor que realizará -->
                                <tr>
                                    <td colspan="2"><span class="Sans9GrNe">#ctMovimiento.mov_memo1#</span><br></td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoMemo1#</span>
                                        <cfelse>
                                            <cftextarea name="memo1" cols="80" rows="5" class="datos100" id="memo1" value="#vCampoMemo1#" disabled='#vActivaCampos#'></cftextarea>
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
                                    <td width="20%"> <div align="center" class="Sans10NeNe">Aprobatoria</div></td>
                                    <td width="15%"> <div align="center" class="Sans10NeNe">Se anexa</div></td>
                                </tr>
                                <!-- Opinión del consejo interno -->
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
