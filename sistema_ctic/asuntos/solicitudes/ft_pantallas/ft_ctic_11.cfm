<!--- CREADO: ARAM PICHARDO--->
<!--- EDITO: ARAM PICHARDO--->
<!--- FECHA CREA: 05/06/2009--->
<!--- FECHA ÚLTIMA MOD.: 15/05/2024 --->
<!--- FT-CTIC-11.-Licencia sin goce de sueldo--->

<!--- Incluir los siguientes archivos --->
<cfif #vTipoComando# EQ 'IMPRIME_EJEMPLO'>
	<cfinclude template="ft_campos_blanco.cfm"> <!---PERIMITE IMPRIMIR LA FT EN BLANCO --->
	<cfset vTipoComando = 'IMPRIME'>
<cfelse>
	<cfinclude template="ft_campos.cfm">
</cfif>
<html>
	<head>
		<!-- INCLUDE que agrega parte del contenido del encabezado -->
		<cfinclude template="ft_include_head_comun.cfm">
		<!-- JAVA SCRIT de uso local -->
		<script language="JavaScript" type="text/JavaScript">
			// AAPAUNAM activa o desactiva campos formulario
			function fAapaunam()
			{
				//alert('funcion');				
				if (document.getElementById("pos35_s").checked == true) //$('#pos35_s').is('checked')
				{
					//alert('SI AAPAUNAM');
					hide('trOpinionCI');
					show('trAapaunam');	
					show('trClausulasAapaunam');	
				}
				if (document.getElementById("pos35_n").checked == true) //$('#pos35_s').is('checked')
				{
					//alert('NO AAPAUNAM');
					show('trOpinionCI');
					hide('trAapaunam');
					hide('trClausulasAapaunam');
				}
			}
			// Validar los datos ingresados por el usuario:
			function fValidaCamposFt()
			{
				var vOk;
				var vMensaje = '';
				fLimpiaValida();
				if (document.getElementById('pos20_n').checked) vMensaje = fValidaCampoLleno('memo1','MOTIVO DE LA LICENCIA');
				vMensaje += fValidaDuracionAMD();
				vMensaje += fValidaFecha('pos14','INICIO');
				vMensaje += fValidaDuracion();
				if (document.getElementById("pos20_s").checked == true && document.getElementById("pos35_n").checked == true)  vMensaje += fValidaDuracionMaximo(30, 'POR MOTIVO PERSONALES');

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
	<body onLoad="fAapaunam();">
		<!--- INCLUDE Cintillo con nombre y número de forma telegrámica / INCLUDE que contiene FORM para abrir archivo PDF (05/04/2019) --->
        <cfinclude template="ft_include_cintillo.cfm">
		<!--- FORMULARIO forma telegrámica --->
		<cfform name="formFt" id="formFt" method="POST" action="#vRutaPagSig#">
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
                                <!-- La licencia es por motivos personales -->
                                <tr>
                                    <td colspan="2">
                                        <span class="Sans9GrNe">#ctMovimiento.mov_pos20#&nbsp;</span>
                                        <span class="Sans9Gr">
                                            <cfinput type="radio" name="pos20" value="Si" id="pos20_s" disabled='#vActivaCampos#' checked="#Iif(vCampoPos20 EQ 'Si',DE("yes"),DE("no"))#">S&iacute;&nbsp;
                                            <cfinput type="radio" name="pos20" value="No" id="pos20_n" disabled='#vActivaCampos#' checked="#Iif(vCampoPos20 EQ 'No',DE("yes"),DE("no"))#">No
                                        </span>
                                    </td>
                                </tr>
								<cfif #LsDateFormat(now(),'yyyy')# GTE 2024>
									<!-- Licencia solicitada atravez del AAPAUNAM (SE AGREGÓ EL 21/02/2024) -->
									<tr>
										<td colspan="2">
											<span class="Sans9GrNe">#ctMovimiento.mov_pos35#</span> <span class="Sans12ViNe"><strong>*</strong></span>
											<cfinput name="pos35" id="pos35_s" type="radio" value="Si" disabled='#vActivaCampos#' onClick="fAapaunam();" checked="#Iif(vCampoPos35 EQ 'Si',DE("yes"),DE("no"))#">S&iacute;&nbsp;
											<cfinput name="pos35" id="pos35_n" type="radio" value="No" disabled='#vActivaCampos#' onClick="fAapaunam();" checked="#Iif(vCampoPos35 EQ 'No',DE("yes"),DE("no"))#">No
										</td>
									</tr>
								</cfif>
                                <!-- Motivo de la licencia -->
                                <tr>
                                    <td width="20%"><div align="left"><span class="Sans9GrNe">#ctMovimiento.mov_memo1#</span></div></td>
                                    <td width="80%">
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoMemo1#</span>
                                        <cfelse>
                                            <cftextarea name="memo1" cols="85" rows="5" class="datos100" id="memo1" disabled='#vActivaCampos#' value="#vCampoMemo1#"></cftextarea>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Duración de la licencia -->
                                <tr>
                                    <td colspan="2">
                                        <span class="Sans9GrNe">#ctMovimiento.mov_pos13#&nbsp;</span>
                                        <!-- Desglose -->
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span <cfif #vCampoPos13_a# EQ 0>class="NoImprimir"</cfif>>
                                                <span class="Sans9Gr">
                                                    #vCampoPos13_a# #ctMovimiento.mov_pos13_a#&nbsp;
                                                </span>
                                            </span>
                                            <span <cfif #vCampoPos13_m# EQ 0>class="NoImprimir"</cfif>>
                                                <span class="Sans9Gr">
                                                    #vCampoPos13_m# #ctMovimiento.mov_pos13_m#&nbsp;
                                                </span>
                                            </span>
                                            <span <cfif #vCampoPos13_d# EQ 0>class="NoImprimir"</cfif>>
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
                                        <span class="Sans9Gr">#ctMovimiento.mov_pos14#</span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos14)#&nbsp;</span>
                                        <cfelse>
                                            <cfinput type="text" name="pos14" disabled='#vActivaCampos#' class="datos" id="pos14" value="#vCampoPos14#" size="10" maxlength="10" onChange="CalcularSiguienteFecha();" onkeypress="return MascaraEntrada(event, '99/99/9999');">
                                        </cfif>
                                        <span class="Sans9Gr">#ctMovimiento.mov_pos15# </span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos15)#</span>
                                        <cfelse>
                                            <cfinput name="pos15" id="pos15" type="text" class="datos" size="10" maxlength="10" disabled value="#vCampoPos15#">
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
                                    <td width="20%"> <div align="center" class="Sans9GrNe"><b>Aprobatoria</b></div></td>
                                    <td width="15%"> <div align="center" class="Sans9GrNe"><b>Se anexa</b></div></td>
                                </tr>
                                <!-- Opinión del Consejo Interno -->
                                <tr id="trOpinionCI" <cfif #vTipoComando# EQ 'IMPRIME' AND #vCampoPos35# EQ 'Si'>style="display: none"</cfif>>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos26#</span></td>
                                    <td>
                                        <div align="center">
                                            <span class="Sans9GrNe">
                                                <cfinput name="pos26" id="pos26_s" type="radio" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos26 EQ 'Si',DE("yes"),DE("no"))#">S&iacute;&nbsp;
                                                <cfinput name="pos26" id="pos26_n" type="radio" value="No" disabled='#vActivaCampos#' checked="#Iif(vCampoPos26 EQ 'No',DE("yes"),DE("no"))#">No
                                            </span>
                                        </div>
                                    </td>
                                    <td>
                                        <div align="center"><cfinput name="pos27" type="checkbox" id="pos27" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos27 EQ 'Si',DE("yes"),DE("no"))#"></div>
                                    </td>
                                </tr>
                                <!-- Opinión del director -->
                                <tr id="trOpinionDirector">
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos28#</span></td>
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
                                            <cfinput name="pos29" type="checkbox" id="pos29" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos29 EQ 'Si',DE("yes"),DE("no"))#">
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
                            <table border="0" class="cuadrosFormularios">
                                <tr bgcolor="##CCCCCC">
                                    <td width="85%"></td>
                                    <td width="15%"><div align="center" class="Sans9GrNe"><b>Se anexa</b></div></td>
                                </tr>
                                <!-- Carta del interesado dirigida al director -->
                                <tr id="trCartaDirector">
                                    <td><b><span class="Sans9GrNe">#ctMovimiento.mov_pos32#</span></b></td>
                                    <td>
                                        <div align="center">
                                            <b>
                                            <cfinput name="pos32" id="pos32" type="checkbox" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos32 EQ 'Si',DE("yes"),DE("no"))#">
                                            </b>
                                        </div>
                                    </td>
                                </tr>
                                <!-- Documento AAPAUNAM -->
                                <tr id="trAapaunam" <cfif #vTipoComando# EQ 'IMPRIME' AND #vCampoPos35# EQ 'No'>style="display: none;"</cfif>>
                                    <td><b><span class="Sans9GrNe">#ctMovimiento.mov_pos33#</span></b></td>
                                    <td>
                                        <div align="center">
                                            <b>
                                            <cfinput name="pos33" id="pos33" type="checkbox" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos33 EQ 'Si',DE("yes"),DE("no"))#">
                                            </b>
                                        </div>
                                    </td>
                                </tr>
                            </table>
							<div id="trClausulasAapaunam" <cfif #vTipoComando# EQ 'IMPRIME' AND #vCampoPos35# EQ 'No'>style="display: none;"</cfif>>
								<span class="Sans9ViNe"><strong>*</strong> De acuerdo con lo convenido en las cláusulas 2, fracción XIV, inciso a) y 69, fracción VII del Contrato Colectivo de Trabajo del Personal Académico.</span>
							</div>
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
