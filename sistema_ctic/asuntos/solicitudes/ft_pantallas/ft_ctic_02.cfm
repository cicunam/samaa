<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 05/05/2009 --->
<!--- FECHA ÚLTIMA MOD.: 17/05/2024 --->
<!--- FT-CTIC-2.-Comisión--->

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
			// Validar los datos ingresados por el usuario:
			function fValidaCamposFt()
			{
				var vOk;
				var vMensaje = '';
				fLimpiaValida();
				vMensaje = fValidaCampoLleno('memo1','OBJETO DE LA COMISIÓN');
				vMensaje += fValidaDestino();
				vMensaje += fValidaDuracionAMD();
				vMensaje += fValidaFecha('pos14','INICIO');
				vMensaje += fValidaDuracion();
				vMensaje += fValidaDuracionMinima(22)
				vMensaje += fValidaGoceSueldo();
				vMensaje += fValidaComisionPaspa();
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

/* ELIMINAR 24/06/2016
			// Función para habilitar/deshabilitar el formulario para agregar instituciones:
			function fMostrarFormulario(accion)
			{
				if (accion)
				{
					// Quitar color rojo:
					document.getElementById("pos11_u").style.backgroundColor = '#FFFFFF';
					document.getElementById("pos11_p").style.backgroundColor = '#FFFFFF';
					document.getElementById("pos11_e").style.backgroundColor = '#FFFFFF';
					document.getElementById("pos11_c").style.backgroundColor = '#FFFFFF';
					// Mostrar el formulario:
					document.getElementById('frmInstitucion').style.display= '';
					document.getElementById('frmPais').style.display= '';
					document.getElementById('frmEstado').style.display= '';
					document.getElementById('frmCiudad').style.display= '';
					document.getElementById('frmBotones').style.display= '';
					// Ocultar botón de agregar institución:
					document.getElementById('cmdMostrarFormulario').style.display= 'none';
				}
				else
				{
					// Es muy importante vaciar los campos del formulario al ocultaro:
					document.getElementById('pos11_u').value = '';
					document.getElementById('pos11_p').value = '';
					document.getElementById('pos11_e').value = '';
					document.getElementById('pos11_c').value = '';
					// Ocultar el formulario:
					document.getElementById('frmInstitucion').style.display= 'none';
					document.getElementById('frmPais').style.display= 'none';
					document.getElementById('frmEstado').style.display= 'none';
					document.getElementById('frmCiudad').style.display= 'none';
					document.getElementById('frmBotones').style.display= 'none';
					// Ocultar botón de agregar institución:
					document.getElementById('cmdMostrarFormulario').style.display= '';
				}
			}
*/			
		</script>
	</head>
	<body onLoad="fListaDestino();"><!---ObtenerEstados();--->
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
 
                         <!-- INCLUDE Campos ocultos GENERALES -->
                        <cfinclude template="ft_include_campos_ocultos.cfm">
                         <!-- Campos ocultos LOCALES -->
                        <cfinput name="posND" type="hidden" id="posND" value="">

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
                                <!-- Objeto de la comisión -->
                                <tr>
                                    <td colspan="2"><span class="Sans9GrNe">#ctMovimiento.mov_memo1#</span></td>
                                </tr>
                                <tr>
                                    <td width="20%"></td>
                                    <td width="80%">
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoMemo1#</span>
                                        <cfelse>
                                            <cftextarea name="memo1" cols="70" rows="5" class="datos100" id="memo1" disabled='#vActivaCampos#' value="#vCampoMemo1#"></cftextarea>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Duración -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos13#</span></td>
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
                                                ><cfinput name="pos13_a" type="text" class="datos" id="pos13_a" size="1" maxlength="1"  disabled='#vActivaCampos#' value="#vCampoPos13_a#" onChange="CalcularSiguienteFecha();" onkeypress="return MascaraEntrada(event, '9');">
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
                                                ><cfinput name="pos13_d" type="text" class="datos" id="pos13_d" size="2" maxlength="2" disabled='#vActivaCampos#' value="#vCampoPos13_d#" onChange="CalcularSiguienteFecha();" onkeypress="return MascaraEntrada(event, '99');">
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
                                            <cfinput name="pos14" type="text" class="datos" id="pos14" size="12" maxlength="10" disabled='#vActivaCampos#' value="#vCampoPos14#" onChange="CalcularSiguienteFecha();" onkeypress="return MascaraEntrada(event, '99/99/9999');">
                                        </cfif>
                                        <span class="Sans9Gr">#ctMovimiento.mov_pos15#&nbsp;</span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos15)#&nbsp;</span>
                                        <cfelse>
                                            <cfinput name="pos15" id="pos15" type="text" class="datos" size="12" maxlength="10" disabled value="#vCampoPos15#">
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Nota SOLO PARA STCTIC -->
                                <cfif #Session.sTipoSistema# IS 'stctic'>
                                    <tr>
                                        <td></td>
                                        <td>
                                            <span class="Sans9GrNe">#ctMovimiento.mov_pos12_o#&nbsp;</span>
                                            <cfif #vTipoComando# IS 'IMPRIME'>
                                                <span class="Sans9Gr">#vCampoPos12_o#</span>
                                            <cfelse>
                                                <cfinput name="pos12_o" type="text" class="datos" id="pos12_o" size="50" maxlength="50" disabled='#vActivaCampos#' value="#vCampoPos12_o#">
                                            </cfif>
                                        </td>
                                    </tr>
                                </cfif>
                                <!-- Goce de sueldo -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos17#</span></td>
                                    <td>
                                        <cfinput onclick="pos17.disabled=true;pos17.value='100'" name="pos18" id="pos18_t" type="radio" value="T" disabled='#vActivaCampos#' checked="#Iif(vCampoPos18 EQ "T",DE("yes"),DE("no"))#">
                                        <span class="Sans9Gr">Total&nbsp;</span>
                                        <cfinput onclick="pos17.disabled=false;pos17.value=''" name="pos18" id="pos18_p" type="radio" value="P" disabled='#vActivaCampos#' checked="#Iif(vCampoPos18 EQ "P",DE("yes"),DE("no"))#">
                                        <span class="Sans9Gr"> Parcial&nbsp;</span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoPos17#</span>
                                        <cfelse>
                                            <cfinput type="text" name="pos17" size="5" maxlength="5" disabled class="datos" value="#vCampoPos17#" onKeyPress="return MascaraEntrada(event, '99');">
                                            <span class="Sans9Gr"> (%)&nbsp;</span>
                                        </cfif>
                                        <cfinput onclick="pos17.disabled=true;pos17.value='0'" name="pos18" id="pos18_sgs" type="radio" value="X" disabled='#vActivaCampos#' checked="#Iif(vCampoPos18 EQ "X",DE("yes"),DE("no"))#">
                                        <span class="Sans9Gr">Sin goce de sueldo</span>
                                    </td>
                                </tr>
                                <!-- Erogación adinional -->
                                <tr>
                                    <td colspan="2">
                                        <span class="Sans9GrNe">#ctMovimiento.mov_pos19#&nbsp;</span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#NumberFormat(vCampoPos19,"_$_-.__")#</span>
                                        <cfelse>
                                            <cfinput name="pos19" type="text" class="datos" id="pos19" size="10" maxlength="12" disabled='#vActivaCampos#' value="#vCampoPos19#" onKeyPress="return MascaraEntrada(event, '999999');">
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Institución que la aporta -->
                                <tr>
                                    <td colspan="2"><span class="Sans9GrNe">#ctMovimiento.mov_pos11#</span></td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoPos11#</span>
                                        <cfelse>
                                            <cfinput name="pos11" id="pos11" type="text" class="datos100" size="50" maxlength="254" disabled='#vActivaCampos#' value="#vCampoPos11#">
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- PASPA -->
                                <tr>
                                    <td colspan="2">
                                        <span class="Sans9GrNe">#ctMovimiento.mov_pos20#&nbsp;</span>
                                        <cfinput name="pos20" id="pos20_s" type="radio" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos20 EQ "Si",DE("yes"),DE("no"))#"><span class="Sans9Gr">S&iacute;&nbsp;</span>
                                        <cfinput name="pos20" id="pos20_n" type="radio" value="No"  disabled='#vActivaCampos#' checked="#Iif(vCampoPos20 EQ "No",DE("yes"),DE("no"))#"><span class="Sans9Gr">No</span>
                                    </td>
                                </tr>
                            </table>
                        </cfoutput>

                         <!-- INCLUDE Destinos de la comisión -->
                        <cfinclude template="ft_include_destinos.cfm">
<!--- ELIMINA XXXXXXXXXXXXXX
                        <!--- HOMOLOGAR CON LAS DEMÁS FT --->                        
                        <!-- Destinos de la comisión -->
                        <cfoutput>
                            <table id="lista_instituciones" width="100%" border="0" align="center" class="cuadrosFormularios">
                                <tr bgcolor="##CCCCCC">
                                    <td colspan="2">
                                        <span class="Sans9GrNe"><center>DESTINO(S) DE LA COMISI&Oacute;N</center></span>
                                    </td>
                                </tr>
                                <!-- Lista de instituciones -->
                                <tr>
                                    <td colspan="2" id="destino_dynamic">
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <cfinclude template="ft_ajax/lista_destinos.cfm">
                                        <cfelse>
                                            <!-- AJAX: Lista de instituciones -->
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Botón que habilita el formulario para agregar instituciones -->
                                <tr>
                                    <td class="NoImprimir" colspan="2" align="center">
                                        <cfinput name="cmdMostrarFormulario" id="cmdMostrarFormulario" type="button" class="botonesStandar" value="AGREGAR DESTINO" onclick="fMostrarFormulario(true);" disabled='#vActivaCampos#'>
                                    </td>
                                </tr>
                                <!-- FORMULARIO PARA AGREGAR INSTITUCIONES (INICIA) -->
                                <!-- Institución -->
                                <tr id="frmInstitucion" style="display: none;">
                                    <td width="130"><span class="Sans9GrNe">Institución</span></td>
                                    <td><cfinput name="pos11_u" type="text" class="datos" id="pos11_u" size="60" maxlength="254"></td>
                                </tr>
                                <!-- País -->
                                <tr id="frmPais" style="display: none;">
                                    <td><span class="Sans9GrNe">País</span></td>
                                    <td>
                                        <cfselect name="pos11_p" class="datos" id="pos11_p" query="ctPais" queryPosition="below" display="pais_nombre" value="pais_clave" onchange="ObtenerEstados();">
                                        <option value="">SELECCIONE</option>
                                        </cfselect>
                                    </td>
                                </tr>
                                <!-- Estado -->
                                <tr id="frmEstado" style="display: none;">
                                    <td><span class="Sans9GrNe">Estado</span></td>
                                    <td id="estados_dynamic">
                                        <cfinput name="pos11_e" id="pos11_e" type="text" class="datos" size="50" maxlength="254">
                                    </td>
                                </tr>
                                <!-- Ciudad -->
                                <tr id="frmCiudad" style="display: none;">
                                    <td><span class="Sans9GrNe">Ciudad</span></td>
                                    <td><cfinput name="pos11_c" id="pos11_c" type="text" class="datos" size="50" maxlength="254"></td>
                                </tr>
                                <!-- Botones -->
                                <tr id="frmBotones" style="display: none;">
                                    <td colspan="2" align="center">
                                        <cfinput name="cmdAgregaDestino_1" type="button" class="botonesStandar" id="cmdAgregaDestino_1" value="ACEPTAR" onclick="if (fValidaCamposDestino()) fMostrarFormulario(false);">
                                        <cfinput name="cmdAgregaDestino_2" type="button" class="botonesStandar" id="cmdAgregaDestino_2" value="CANCELAR" onclick="fMostrarFormulario(false);">
                                    </td>
                                </tr>
                                <!-- FORMULARIO PARA AGREGAR INSTITUCIONES (TERMINA) -->
                            </table>
                        </cfoutput>
--->
                        <!-- Dictámenes -->
						<!--- Llamado a INCLUDE general de los dictámenes requeridos en la FT 17/05/2024 --->
						<cfinclude template="ft_include_anexoDictamen.cfm">
<!---								
                        <cfoutput>
							<table border="0" class="cuadrosFormularios">
                                <tr bgcolor="##CCCCCC">
                                    <td width="65%"></td>
                                    <td width="20%"><div align="center" class="Sans9GrNe">Aprobatoria</div></td>
                                    <td width="15%"><div align="center" class="Sans9GrNe">Se anexa</div></td>
                                </tr>
                                <!-- Opinión del consejo interno -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos26# </span></td>
                                    <td>
                                        <div align="center">
                                            <span class="Sans9GrNe">
                                                <cfinput name="pos26" id="pos26_s" type="radio" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos26 EQ "Si",DE("yes"),DE("no"))#">S&iacute;&nbsp;
                                                <cfinput name="pos26" id="pos26_n" type="radio" value="No" disabled='#vActivaCampos#' checked="#Iif(vCampoPos26 EQ "No",DE("yes"),DE("no"))#">No
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
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos28# </span></td>
                                    <td>
                                        <div align="center">
                                            <span class="Sans9GrNe">
                                                <cfinput name="pos28" id="pos28_s" type="radio" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos28 EQ "Si",DE("yes"),DE("no"))#">S&iacute;&nbsp;
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
                                    <td width="15%"> <div align="center" class="Sans9GrNe">Se anexa</div></td>
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
                                <!-- Carta de aceptación de la institución a donde va -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos33#</span></td>
                                    <td>
                                        <div align="center">
                                            <cfinput name="pos33" type="checkbox" id="pos33" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos33 EQ "Si",DE("yes"),DE("no"))#">
                                        </div>
                                    </td>
                                </tr>
                                <!-- Programa de actividades (avalado para el caso de técnicos académicos) -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos34#</span></td>
                                    <td>
                                        <div align="center">
                                            <cfinput name="pos34" type="checkbox" id="pos34" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos34 EQ "Si",DE("yes"),DE("no"))#">
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
