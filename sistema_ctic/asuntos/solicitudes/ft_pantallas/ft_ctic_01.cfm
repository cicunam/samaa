<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 17/04/2009 --->
<!--- FECHA ÚLTIMA MOD.: 17/05/2024 --->
<!--- FT-CTIC-1.-Cátedras, trabajos o asesorías --->

<!--- Incluir los siguientes archivos --->
<cfif #vTipoComando# EQ 'IMPRIME_EJEMPLO'>
	<cfinclude template="ft_campos_blanco.cfm"> <!---PERIMITE IMPRIMIR LA FT EN BLANCO --->
	<cfset vTipoComando = 'IMPRIME'>
<cfelse>
	<cfinclude template="ft_campos.cfm">
</cfif>

<!--- Obtener datos del catálogo de estados de la república (CATÁLOGOS GENERALES MYSQL) --->
<cfquery name="ctEstados" datasource="#vOrigenDatosCATALOGOS#">
	SELECT * FROM catalogo_paises_edo 
    WHERE pais_clave = 'MEX' 
    ORDER BY edo_nombre
</cfquery>

<html>
	<head>
		<!-- INCLUDE que agrega parte del contenido del encabezado -->
		<cfinclude template="ft_include_head_comun.cfm">
		<!-- JAVA SCRIT de uso local -->
		<script language="JavaScript" type="text/JavaScript">
			// Validar los datos ingresados por el usuario:
			function fValidaCamposFt()
			{
				var vOk;
				var vMensaje = '';
				// Limpiar expresamente renglón:
				document.getElementById('pos12_row').style.background = '#FFFFFF';
				fLimpiaValida();
				// Validar:
				vMensaje = fValidaCampoLleno('pos11','INSTITUCIÓN');
				vMensaje += fValidaCampoLleno('pos11_e','ESTADO');
				vMensaje += fValidaCampoLleno('pos11_c','CIUDAD');
				vMensaje += fValidaDuracionAMD();
				vMensaje += fValidaFecha('pos14','INICIO');
				vMensaje += fValidaDuracion();
				vMensaje += fValidaActividadCatedra();
				vMensaje += parseFloat(document.getElementById("pos16").value) > 0 ? '': 'El campo HORAS A LA SEMANA debe ser mayor a cero.\n';
				vMensaje += fValidaHoras(8,'La suma de las horas a la semana no de ser mayor a 8.\n','F1');
				// Determinar su hubo error al validar:
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
    
                        <!-- INCLUDE para visualisar Información Académica -->
                        <cfinclude template="ft_include_datos_academicos.cfm">                    
    
                        <!-- Datos que deben ingresarse -->
                        <cfoutput>
                            <table border="0" class="cuadrosFormularios">
                                <!-- Actividad a desempeñar -->
                                <tr>
                                    <td width="20%"><span class="Sans9GrNe">#ctMovimiento.mov_pos12# </span></td>
                                    <td width="80%" id="pos12_row">
                                        <span class="Sans9Gr"><cfinput type="radio" name="pos12" id="pos12_c" value="32" disabled='#vActivaCampos#'  checked="#Iif(vCampoPos12 EQ "32",DE("yes"),DE("no"))#">C&aacute;tedras&nbsp;</span>
                                        <span class="Sans9Gr"><cfinput type="radio" name="pos12" id="pos12_t" value="29" disabled='#vActivaCampos#' checked="#Iif(vCampoPos12 EQ "29",DE("yes"),DE("no"))#">Trabajos&nbsp;</span>
                                        <span class="Sans9Gr"><cfinput type="radio" name="pos12" id="pos12_a" value="1" disabled='#vActivaCampos#' checked="#Iif(vCampoPos12 EQ "1",DE("yes"),DE("no"))#">Asesor&iacute;as&nbsp;</span>
                                    </td>
                                </tr>
                                <!-- Tipo de trabajo a realizar -->
                                <tr>
                                    <td colspan="2">
                                        <span class="Sans9GrNe">#ctMovimiento.mov_memo1#</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="20%">&nbsp;</td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoMemo1#</span>
                                        <cfelse>
                                            <cftextarea name="memo1" cols="70" rows="5" class="datos100" id="memo1" disabled='#vActivaCampos#' value="#vCampoMemo1#"></cftextarea>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Institución a la que asistirá -->
                                <tr>
                                    <td colspan="2"><span class="Sans9GrNe">#ctMovimiento.mov_pos11#</span></td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoPos11#</span>
                                        <cfelse>
                                            <cfinput name="pos11" type="text" class="datos100" id="pos11" size="70" maxlength="254" value="#vCampoPos11#" disabled='#vActivaCampos#'>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Estado -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos11_e#</span></td>
                                    <td>
                                        <span class="Sans9GrNe">
                                            <cfif #vTipoComando# IS 'IMPRIME'>
                                                <cfloop query="ctEstados">
                                                    <cfif #edo_clave# IS #vCampoPos11_e#>
                                                        <cfset vCampoPos11_e_txt = #edo_nombre#>
                                                        <cfbreak>
                                                    </cfif>
                                                </cfloop>
                                                <span class="Sans9Gr">#vCampoPos11_e_txt#</span>
                                            <cfelse>
                                                <cfselect name="pos11_e" class="datos" id="pos11_e" disabled='#vActivaCampos#' query="ctEstados" queryPosition="below" display="edo_nombre" value="edo_clave" selected="#vCampoPos11_e#" onchange="fDetectarDF(this.value);">
                                                    <option value="">SELECCIONE</option>
                                                </cfselect>
                                            </cfif>
                                        </span>
                                    </td>
                                </tr>
                                <!-- Ciudad -->
                                <tr>
                                    <td><span class="Sans9GrNe"><cfoutput>#ctMovimiento.mov_pos11_c#</cfoutput></span></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoPos11_c#</span>
                                        <cfelse>
                                            <cfinput name="pos11_c" id="pos11_c" type="text" class="datos" size="50" maxlength="254" value="#vCampoPos11_c#" disabled='#vActivaCampos#'>
                                        </cfif>
                                        <!--- Siempre guardar país=México --->
                                        <cfinput type="hidden" name="pos11_p" id="pos11_p" value="MX">
                                    </td>
                                </tr>
                                <!-- Duración -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos13# </span></td>
                                    <td>
                                        <!-- Desglose -->
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
                                                ><cfinput name="pos13_a" type="text" class="datos" id="pos13_a" size="1" maxlength="1" disabled='#vActivaCampos#' value="#vCampoPos13_a#" onChange="CalcularSiguienteFecha();" onkeypress="return MascaraEntrada(event, '99');">
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
                                        <span class="Sans9Gr">#ctMovimiento.mov_pos14#&nbsp;</span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos14)#&nbsp;</span>
                                        <cfelse>
                                            <cfinput type="text" name="pos14" disabled='#vActivaCampos#' class="datos" id="pos14" value="#vCampoPos14#" size="10" maxlength="10" onChange="CalcularSiguienteFecha();" onkeypress="return MascaraEntrada(event, '99/99/9999');">
                                        </cfif>
                                        <span class="Sans9Gr">#ctMovimiento.mov_pos15#&nbsp;</span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos15)#</span>
                                        <cfelse>
                                            <cfinput name="pos15" id="pos15" type="text" class="datos" size="10" maxlength="10" disabled value="#vCampoPos15#">
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Horas a la semana -->
                                <tr>
                                    <td height="27" colspan="2">
                                        <span class="Sans9GrNe">#ctMovimiento.mov_pos16#&nbsp;</span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoPos16#</span>
                                        <cfelse>
                                            <cfinput name="pos16" id="pos16" type="text" class="datos" size="3" maxlength="3" disabled='#vActivaCampos#' value="#vCampoPos16#" onkeypress="return MascaraEntrada(event, '9.9');">
                                        </cfif>
                                        <span class="Sans9Gr"> hrs.</span>
                                    </td>
                                </tr>
                                <!-- Otras labores -->
                                <tr>
                                    <td colspan="2"><span class="Sans9GrNe">#ctMovimiento.mov_memo2#</span></td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoMemo2#</span>
                                        <cfelse>
                                            <cftextarea name="memo2" cols="70" rows="5" class="datos100" id="memo2" disabled='#vActivaCampos#' value="#vCampoMemo2#"></cftextarea>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Horas dedicadas a otras labores -->
                                <tr>
                                    <td colspan="2">
                                        <span class="Sans9GrNe">#ctMovimiento.mov_pos19#&nbsp;</span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoPos19#</span>
                                        <cfelse>
                                            <cfinput name="pos19" id="pos19" type="text" class="datos" size="3" maxlength="3" disabled='#vActivaCampos#' value="#vCampoPos19#" onkeypress="return MascaraEntrada(event, '9.9');">
                                        </cfif>
                                        <span class="Sans9Gr"> hrs.</span>
                                    </td>
                                </tr>
                            </table>
                        </cfoutput>
                        <!-- Dictámenes -->
						<!--- Llamado a INCLUDE general de los dictámenes requeridos en la FT 17/05/2024 --->
						<cfinclude template="ft_include_anexoDictamen.cfm">
<!---											
                        <cfoutput>
                            <table width="100%" border="0" cellpadding="0" class="cuadrosFormularios">
                                <tr bgcolor="##CCCCCC">
                                    <td width="65%"></td>
                                    <td width="20%"><div align="center" class="Sans9GrNe">Aprobatoria</div></td>
                                    <td width="15%"><div align="center" class="Sans9GrNe">Se anexa</div></td>
                                </tr>
                                <!-- Opinión del consejo interno -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos26#</span></td>
                                    <td>
                                        <div align="center">
                                            <span class="Sans9GrNe">
                                                <cfinput type="radio" name="pos26" id="pos26_s" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos26 EQ "Si",DE("yes"),DE("no"))#">S&iacute;
                                                <cfinput type="radio" name="pos26" id="pos26_n" value="No" disabled='#vActivaCampos#' checked="#Iif(vCampoPos26 EQ "No",DE("yes"),DE("no"))#">No
                                            </span>
                                        </div>
                                    </td>
                                    <td>
                                        <div align="center">
                                            <cfinput name="pos27" type="checkbox" id="pos27" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos27 EQ "Si",DE("yes"),DE("no"))#">
                                        </div>
                                    </td>
                                </tr>
                                <!-- Carta del director -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos28#</span></td>
                                    <td>
                                        <div align="center">
                                            <span class="Sans9GrNe">
                                                <cfinput type="radio" name="pos28" id="pos28_s" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos28 EQ "Si",DE("yes"),DE("no"))#">S&iacute;
                                                <cfinput type="radio" name="pos28" id="pos28_n" value="No" disabled='#vActivaCampos#' checked="#Iif(vCampoPos28 EQ "No",DE("yes"),DE("no"))#">No
                                            </span>
                                        </div>
                                    </td>
                                    <td>
                                        <div align="center">
                                            <cfinput name="pos29" type="checkbox" id="pos29" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos29 EQ "Si",DE("yes"),DE("no"))#">
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </cfoutput>
--->											
                        <!-- Documentación -->
						<!--- Llamado a INCLUDE general de los anexos requeridos en la FT 17/05/2024 --->
						<cfinclude template="ft_include_anexoAnexos.cfm">
<!---							
                        <cfoutput>
                            <table width="100%" border="0" cellpadding="0" class="cuadrosFormularios">
                                <tr bgcolor="##CCCCCC">
                                    <td width="85%"></td>
                                    <td width="15%">
                                        <div align="center" class="Sans9GrNe">Se anexa</div>
                                    </td>
                                </tr>
                                <!-- Carta del interesado -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos32#</span></td>
                                    <td>
                                        <div align="center">
                                            <cfinput name="pos32" type="checkbox" id="pos32" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos32 EQ "Si",DE("yes"),DE("no"))#">
                                        </div>
                                    </td>
                                </tr>
                                <!-- Carta de la institución -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos33#</span></td>
                                    <td>
                                        <div align="center">
                                            <cfinput name="pos33" type="checkbox" id="pos33" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos33 EQ "Si",DE("yes"),DE("no"))#">
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </cfoutput>
--->
                        <cfif #Session.sTipoSistema# IS 'sic' AND #vSolStatus# GT 2 AND #vTipoComando# IS NOT 'NUEVO' AND #vTipoComando# IS NOT 'IMPRIME'>
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
