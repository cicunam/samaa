<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 05/05/2009 --->
<!--- FECHA ÚLTIMA MOD.: 17/07/2024 --->
<!--- FT-CTIC-4.-Comisión encomendada por las autoridades de la dependencia o por el Rector--->

<!--- Incluir los siguientes archivos --->
<cfif #vTipoComando# EQ 'IMPRIME_EJEMPLO'>
	<cfinclude template="ft_campos_blanco.cfm"> <!---PERIMITE IMPRIMIR LA FT EN BLANCO --->
	<cfset vTipoComando = 'IMPRIME'>
<cfelse>
	<cfinclude template="ft_campos.cfm">
</cfif>

<!--- Obtener datos del catálogo de países (CATÁLOGOS GENERALES MYSQL) --->
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
			// Validar los datos ingresados por el usuario:
			function fValidaCamposFt()
			{
				var vOk;
				var vMensaje = '';
				fLimpiaValida();
				vMensaje = fValidaTipoRegComision();
				vMensaje += fValidaCampoLleno('memo1','FINALIDAD DE LA COMISIÓN');
				vMensaje += fValidaCampoLleno('pos11','INSTITUCIÓN');
				vMensaje += fValidaCampoLleno('pos11_p','PAÍS');
				if (document.getElementById('pos11_p').value=='MEX' || document.getElementById('pos11_p').value=='USA') vMensaje += fValidaCampoLleno('pos11_e','ESTADO');
				vMensaje += fValidaCampoLleno('pos11_c','CIUDAD');
				vMensaje += fValidaDuracionAMD();
				vMensaje += fValidaFecha('pos14','INICIO');
				vMensaje += fValidaDuracion();
				vMensaje += fValidaGoceSueldo();
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
	<body onLoad="ObtenerEstados();">
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
                                <!-- Tipo de solicitud -->
                                <tr>
                                    <td width="20%"><span class="Sans9GrNe">#ctMovimiento.mov_pos12#</span></td>
                                    <td width="80%">
                                        <cfinput type="radio" name="pos12" id="pos12_c" value="COMISION" disabled='#vActivaCampos#' checked="#Iif(vCampoPos12 EQ "COMISION",DE("yes"),DE("no"))#">
                                        <span class="Sans9Gr">Primer periodo de comis&oacute;n &nbsp;</span>
                                        <cfinput type="radio" name="pos12" id="pos12_p" value="PRORROGA"  disabled='#vActivaCampos#' checked="#Iif(vCampoPos12 EQ "PRORROGA",DE("yes"),DE("no"))#">
                                        <span class="Sans9Gr">Pr&oacute;rroga</span>
                                    </td>
                                </tr>
                                <!-- Comisionado por -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos12_o#</span></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoPos12_o#</span>
                                        <cfelse>
                                            <cfinput name="pos12_o" type="text" class="datos100" id="pos12_o" maxlength="254" disabled='#vActivaCampos#' value="#vCampoPos12_o#">
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Finalidad de la comisión -->
                                <tr>
                                    <td colspan="2"><span class="Sans9GrNe">#ctMovimiento.mov_memo1#</span></td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoMemo1#</span>
                                        <cfelse>
                                            <cftextarea name="memo1" cols="70" rows="5" class="datos100" id="memo1" disabled='#vActivaCampos#' value="#vCampoMemo1#"></cftextarea>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Institución a la que se le comisiona -->
                                <tr>
                                    <td colspan="2"><span class="Sans9GrNe"><cfoutput>#ctMovimiento.mov_pos11#</cfoutput></span></td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoPos11#</span>
                                        <cfelse>
                                            <cfinput name="pos11" type="text" class="datos100" id="pos11" maxlength="254" value="#vCampoPos11#" disabled='#vActivaCampos#'>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- País -->
                                <tr>
                                    <td><span class="Sans9GrNe"><cfoutput>#ctMovimiento.mov_pos11_p#</cfoutput></span></td>
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
                                            <cfselect name="pos11_p" class="datos" id="pos11_p" disabled='#vActivaCampos#' query="ctPais" queryPosition="below" display="pais_nombre" value="pais_clave" selected="#vCampoPos11_p#" onchange="ObtenerEstados();">
                                            <option value="">SELECCIONE</option>
                                            </cfselect>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Estado -->
                                <tr>
                                    <td><span class="Sans9GrNe"><cfoutput>#ctMovimiento.mov_pos11_e#</cfoutput></span></td>
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
                                    <td><span class="Sans9GrNe"><cfoutput>#ctMovimiento.mov_pos11_c#</cfoutput></span></td>
                                    <td><cfinput name="pos11_c" id="pos11_c" type="text" class="datos" size="50" maxlength="254" value="#vCampoPos11_c#" disabled='#vActivaCampos#'></td>
                                </tr>
                                <!-- Duración -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos13#</span></td>
                                    <td id="pos13_row">
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
                                                ><cfinput type="text" name="pos13_a" disabled='#vActivaCampos#' class="datos" id="pos13_a" onChange="CalcularSiguienteFecha();" value="#vCampoPos13_a#" size="1" maxlength="1" onkeypress="return MascaraEntrada(event, '9');">
                                                <span class="Sans9Gr">
                                                    #ctMovimiento.mov_pos13_a#
                                                </span>
                                            </span>
                                            <span
                                                <cfif #vCampoPos13_m# EQ 0>class="NoImprimir"</cfif>
                                                ><cfinput type="text" name="pos13_m" disabled='#vActivaCampos#' class="datos" id="pos13_m" onChange="CalcularSiguienteFecha();" value="#vCampoPos13_m#" size="2" maxlength="2" onkeypress="return MascaraEntrada(event, '99');">
                                                <span class="Sans9Gr">
                                                    #ctMovimiento.mov_pos13_m#
                                                </span>
                                            </span>
                                            <span
                                                <cfif #vCampoPos13_d# EQ 0>class="NoImprimir"</cfif>
                                                ><cfinput type="text" name="pos13_d" disabled='#vActivaCampos#' class="datos" id="pos13_d" onChange="CalcularSiguienteFecha();" value="#vCampoPos13_d#" size="2" maxlength="2" onkeypress="return MascaraEntrada(event, '99');">
                                                <span class="Sans9Gr">
                                                    #ctMovimiento.mov_pos13_d#
                                                </span>
                                            </span>
                                        </cfif>
                                        <!-- Fechas -->
                                        <span class="Sans9Gr">#ctMovimiento.mov_pos14#</span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos14)#&nbsp;</span>
                                        <cfelse>
                                            <cfinput type="text" name="pos14" disabled='#vActivaCampos#' class="datos" id="pos14" onChange="CalcularSiguienteFecha();" value="#vCampoPos14#" size="10" maxlength="10" onkeypress="return MascaraEntrada(event, '99/99/9999');">
                                        </cfif>
                                        <span class="Sans9Gr">#ctMovimiento.mov_pos15#</span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos15)#</span>
                                        <cfelse>
                                            <cfinput onclick="pos15.value=''" name="pos15" type="text" class="datos" id="pos15" size="10" maxlength="10"  disabled value="#vCampoPos15#">
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Con goce de sueldo -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos17#</span></td>
                                    <td>
                                        <cfinput onclick="pos17.disabled=true;pos17.value='100'" name="pos18" id="pos18_t" type="radio" value="T" disabled='#vActivaCampos#' checked="#Iif(vCampoPos18 EQ "T",DE("yes"),DE("no"))#">
                                        <span class="Sans9Gr"> Total&nbsp;</span>
                                        <cfinput onclick="pos17.disabled=false;pos17.value=''" name="pos18" id="pos18_p" type="radio" value="P" disabled='#vActivaCampos#'  checked="#Iif(vCampoPos18 EQ "P",DE("yes"),DE("no"))#">
                                        <span class="Sans9Gr"> Parcial&nbsp;</span>
                                        <cfinput type="text" name="pos17" disabled class="datos" value="#vCampoPos17#" size="4" maxlength="4" onkeypress="return MascaraEntrada(event, '99');">
                                        <span class="Sans9Gr">(%)&nbsp;</span>
                                        <cfinput onclick="pos17.disabled=true;pos17.value='0'" name="pos18" id="pos18_sgs" type="radio" value="X" disabled='#vActivaCampos#' checked="#Iif(vCampoPos18 EQ "X",DE("yes"),DE("no"))#">
                                        <span class="Sans9Gr"> Sin goce de sueldo</span>
                                    </td>
                                </tr>
                                <!-- Erogación adicional -->
                                <tr>
                                    <td colspan="2">
                                        <span class="Sans9GrNe">#ctMovimiento.mov_pos19#&nbsp;</span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#NumberFormat(vCampoPos19,"_$_-.__")#</span>
                                        <cfelse>
                                            <cfinput type="text" name="pos19" disabled='#vActivaCampos#' class="datos" id="pos19" value="#vCampopos19#" size="10" maxlength="10" onKeyPress="return MascaraEntrada(event, '9999999');">
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
                            <table border="0" class="cuadrosFormularios">
                                <tr bgcolor="##CCCCCC">
                                    <td width="65%"></td>
                                    <td width="20%"><div align="center"><span class="Sans9GrNe">Aprobatoria</span></div></td>
                                    <td width="15%"><div align="center"><span class="Sans9GrNe">Se anexa</span></div></td>
                                </tr>
                                <!-- Carta del director o el rector -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos28#</span></td>
                                    <td>
                                        <div align="center">
                                            <span class="Sans9GrNe">
                                                <cfinput name="pos28" id="pos28_s" type="radio" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos28 EQ "Si",DE("yes"),DE("no"))#">S&iacute;
                                                <cfinput name="pos28" id="pos28_n" type="radio" value="No" disabled='#vActivaCampos#' checked="#Iif(vCampoPos28 EQ "No",DE("yes"),DE("no"))#">No
                                            </span>
                                        </div>
                                    </td>
                                    <td>
                                        <div align="center">
                                            <span class="Sans9GrNe">
                                                <cfinput name="pos29" type="checkbox" id="pos29" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos29 EQ "Si",DE("yes"),DE("no"))#">
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                                <!-- Opinión del consejo interno -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos26#</span></td>
                                    <td>
                                        <div align="center">
                                            <span class="Sans9GrNe">
                                                <cfinput name="pos26" id="pos26_s" type="radio" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos26 EQ "Si",DE("yes"),DE("no"))#">S&iacute;
                                                <cfinput name="pos26" id="pos26_n" type="radio" value="No" disabled='#vActivaCampos#' checked="#Iif(vCampoPos26 EQ "No",DE("yes"),DE("no"))#">No
                                            </span>
                                        </div>
                                    </td>
                                    <td><div align="center"><cfinput name="pos27" type="checkbox" id="pos27" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos27 EQ "Si",DE("yes"),DE("no"))#"></div></td>
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
                                    <td width="85%"></td>
                                    <td width="15%"><div align="center"><span class="Sans9GrNe">Se anexa</span></div></td>
                                </tr>
                                <!-- Carta del interesado -->
                                <tr>
                                    <td><b class="Sans9GrNe">#ctMovimiento.mov_pos32#</b></td>
                                    <td>
                                        <div align="center">
                                            <span class="Sans9GrNe">
                                                <cfinput name="pos32" type="checkbox" id="pos32" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos32 EQ "Si",DE("yes"),DE("no"))#">
                                            </span>
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
