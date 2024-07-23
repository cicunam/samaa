<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 20/04/2009 --->
<!--- FECHA ÚLTIMA MOD.: 27/06/2016 --->
<!--- FT-CTIC-34.-Reconocimiento de antigüedad para académicos de nuevo ingreso --->

<!--- Incluir los siguientes archivos --->
<cfif #vTipoComando# EQ 'IMPRIME_EJEMPLO'>
	<cfinclude template="ft_campos_blanco.cfm"> <!---PERIMITE IMPRIMIR LA FT EN BLANCO --->
	<cfset vTipoComando = 'IMPRIME'>
<cfelse>
	<cfinclude template="ft_campos.cfm">
</cfif>

<!--- Obtener datos del catálogo de nombramiento (CATÁLOGOS GENERALES MYSQL) --->
<cfquery name="ctCategoria" datasource="#vOrigenDatosCATALOGOS#">
	SELECT * FROM catalogo_cn 
	WHERE cn_status = 1 
	ORDER BY cn_orden DESC
</cfquery>

<html>
	<head>
		<!-- INCLUDE que agrega parte del contenido del encabezado -->
		<cfinclude template="ft_include_head_comun.cfm">
		<!-- JAVA SCRIT de uso local -->
		<script type="text/javascript">
			// Función para habilitar/deshabilitar el formulario para agregar instituciones:
			function fMostrarFormulario(accion)
			{
				if (accion)
				{
					// Quitar color rojo:
					document.getElementById("antig_institucion").style.backgroundColor = '#FFFFFF';
					document.getElementById("antig_fecha_ini").style.backgroundColor = '#FFFFFF';
					document.getElementById("antig_fecha_fin").style.backgroundColor = '#FFFFFF';
					// Mostrar el formulario:
					document.getElementById('frmInstitucion').style.display= '';
					document.getElementById('frmFechas').style.display= '';
					document.getElementById('frmBotones').style.display= '';
					// Ocultar botón de agregar institución:
					document.getElementById('cmdMostrarFormulario').style.display= 'none';
				}
				else
				{
					// Es muy importante vaciar los campos del formulario al ocultaro:
					document.getElementById('antig_institucion').value = '';
					document.getElementById('antig_fecha_ini').value = '';
					document.getElementById('antig_fecha_fin').value = '';
					// Ocultar el formulario:
					document.getElementById('frmInstitucion').style.display= 'none';
					document.getElementById('frmFechas').style.display= 'none';
					document.getElementById('frmBotones').style.display= 'none';
					// Ocultar botón de agregar institución:
					document.getElementById('cmdMostrarFormulario').style.display= '';
				}
			}
			// Validación de los datos ingresados por el usuario:
			function fValidaCamposFt()
			{
				var vMensaje = '';
				fLimpiaValida();
				vMensaje += fValidaAntig();
				vMensaje += fValidaCampoLleno('pos3','CATEGORÍA Y NIVEL');
				vMensaje += fValidaFecha('pos21','INGERSO A LA UNAM');
				if (document.getElementById('antig_fecha_fin')) vMensaje += fComparaFechas("pos21", "antig_ultima_fecha") == 1 ? '': 'Los periodos de antigüedad a reconocer deben ser anteriores a la fecha de ingreso a la UNAM.\n';
				// ...
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
	<body onLoad="fAgregarAntiguedad('CONSULTA', 0);">
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
                        <cfoutput>
                            <!-- Datos obtenidos por el sistema -->
                            <table border="0" class="cuadrosFormularios">
                                <tr>
                                    <!-- Categorí­a y nivel -->
                                    <td width="50%">
                                        <span class="Sans9GrNe">#ctMovimiento.mov_pos3#&nbsp;</span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <cfloop query="ctCategoria">
                                                <cfif #cn_clave# IS #vCampoPos3#>
                                                    <cfset vCampoPos3_txt = #cn_siglas#>
                                                    <cfbreak>
                                                </cfif>
                                            </cfloop>
                                            <span class="Sans9Gr">#vCampoPos3_txt#</span>
                                        <cfelse>
                                            <cfselect name="pos3" id="pos3" class="datos" query="ctCategoria" queryPosition="below" value="cn_clave" display="cn_siglas" selected="#vCampoPos3#" disabled='#vActivaCampos#'>
                                            <option value="" selected>SELECCIONE</option>
                                            </cfselect>
                                        </cfif>
                                    </td>
                                    <!-- Fecha de ingreso a la UNAM -->
                                    <td width="50%" align="right">
                                        <span class="Sans9GrNe">#ctMovimiento.mov_pos21#&nbsp;</span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos21)#</span>
                                        <cfelse>
                                            <cfinput name="pos21" id="pos21" type="text" class="datos" size="10" maxlength="10" value="#vCampoPos21#" disabled='#vActivaCampos#' onkeypress="return MascaraEntrada(event, '99/99/9999');">
                                        </cfif>
                                    </td>
                                </tr>
                            </table>
                        </cfoutput>
                        <!-- Periodos de antigüedad que solicita ser reconocidos -->
                        <cfoutput>
                            <cfinput type="hidden" name="posND" id="posND" value=""> <!-- Importante para validar después -->
                            <table border="0" class="cuadrosFormularios">
                                <tr bgcolor="##CCCCCC">
                                    <td colspan="2">
                                        <span class="Sans9GrNe"><center>Solicita reconocer los siguientes periodos de antig&uuml;edad</center></span>								</td>
                                </tr>
                                <!-- Lista de periodos -->
                                <tr>
                                    <td colspan="2" id="antiguedad_dynamic">
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <cfinclude template="ft_ajax/lista_periodos.cfm">
                                        <cfelse>
                                            <!-- AJAX: Lista de periodos de antiguedad -->
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Botón que habilita el formulario para agregar antigüedad -->
                                <tr class="NoImprimir">
                                    <td colspan="2" align="center">
                                        <cfinput name="cmdMostrarFormulario" id="cmdMostrarFormulario" type="button" class="botonesStandar" value="AGREGAR PERIODO" onclick="fMostrarFormulario(true);" disabled='#vActivaCampos#'>
                                    </td>
                                </tr>
                                <!-- FORMULARIO PARA AGREGAR ANTIGËDAD (INICIA) -->
                                <!-- Institución -->
                                <tr id="frmInstitucion" style="display: none;">
                                    <td width="207"><span class="Sans9GrNe">Instituci&oacute;n de procedencia</span></td>
                                    <td width="931">
                                      <cfinput name="antig_institucion" id="antig_institucion" type="text" class="datos100" maxlength="254">
                                    </td>
                                </tr>
                                <!-- Fechas -->
                                <tr id="frmFechas" style="display: none;">
                                    <td colspan="2">
                                        <span class="Sans9GrNe">Solicita el reconocimiento desde</span>
                                        <cfinput name="antig_fecha_ini" id="antig_fecha_ini" type="text" class="datos" size="10" maxlength="10" onkeypress="return MascaraEntrada(event, '99/99/9999');">
                                        <span class="Sans9GrNe"> hasta</span>
                                        <cfinput name="antig_fecha_fin" id="antig_fecha_fin" type="text" class="datos" size="10" maxlength="10" onkeypress="return MascaraEntrada(event, '99/99/9999');">
                                    </td>
                                </tr>
                                <!-- Botones -->
                                <tr id="frmBotones" style="display: none;">
                                    <td colspan="2" align="center">
                                        <cfinput name="cmdAgregaAntig_1" id="cmdAgregaAntig_1" type="button" class="botonesStandar" value="ACEPTAR" onclick="if (fValidaCamposAntig()) fMostrarFormulario(false);">
                                        <cfinput name="cmdAgregaAntig_2" id="cmdAgregaAntig_2" type="button" class="botonesStandar" value="CANCELAR" onclick="fMostrarFormulario(false);">
                                    </td>
                                </tr>
                                <!-- FORMULARIO PARA AGREGAR ANTIGËDAD (TERMINA) -->
                            </table>
                        </cfoutput>
                        <!-- Total de antigüedad a ser reconocida -->
                        <cfoutput>
                            <table border="0" class="cuadrosFormularios">
                                <!-- Total de antiüedad reconocida -->
                                <tr>
                                    <td>
                                        <span class="Sans9GrNe">#ctMovimiento.mov_pos13#&nbsp;</span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <cfif #vCampoPos13_a# NEQ 0><span class="Sans9Gr">#vCampoPos13_a# #ctMovimiento.mov_pos13_a#&nbsp;</span></cfif>
                                            <cfif #vCampoPos13_m# NEQ 0><span class="Sans9Gr">#vCampoPos13_m# #ctMovimiento.mov_pos13_m#&nbsp;</span></cfif>
                                            <cfif #vCampoPos13_d# NEQ 0><span class="Sans9Gr">#vCampoPos13_d# #ctMovimiento.mov_pos13_d#&nbsp;</span></cfif>
                                        <cfelse>
                                            <span
                                                <cfif #vCampoPos13_a# EQ 0>class="NoImprimir"</cfif>
                                                ><cfinput name="pos13_a" type="text" class="datos" id="pos13_a" size="1" maxlength="1" disabled value="#vCampoPos13_a#">
                                                <span class="Sans9Gr">
                                                    #ctMovimiento.mov_pos13_a#
                                                </span>
                                            </span>
                                            <span
                                                <cfif #vCampoPos13_m# EQ 0>class="NoImprimir"</cfif>
                                                ><cfinput name="pos13_m" type="text" class="datos" id="pos13_m" size="2" maxlength="2" disabled value="#vCampoPos13_m#">
                                                <span class="Sans9Gr">
                                                    #ctMovimiento.mov_pos13_m#
                                                </span>
                                            </span>
                                            <span
                                                <cfif #vCampoPos13_d# EQ 0>class="NoImprimir"</cfif>
                                                ><cfinput name="pos13_d" type="text" class="datos" id="pos13_d" size="2" maxlength="2" disabled value="#vCampoPos13_d#">
                                                <span class="Sans9Gr">
                                                    #ctMovimiento.mov_pos13_d#
                                                </span>
                                            </span>
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
                                    <td width="20%"><div align="center" class="Sans10NeNe">Aprobatoria</div></td>
                                    <td width="15%"> <div align="center" class="Sans10NeNe">Se anexa</div></td>
                                </tr>
                                <!-- Opinión del consejo interno -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos26#</span></td>
                                    <!-- Si/No -->
                                    <td>
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
                        <!-- Documentación -->
                        <cfoutput>
                            <table border="0" class="cuadrosFormularios">
                                <!-- Encabezado -->
                                <tr bgcolor="##CCCCCC">
                                    <td width="85%"></td>
                                    <td width="15%"><div align="center" class="Sans10NeNe">Se anexa</div></td>
                                </tr>
                                <!-- Carta de presentación del director -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos29#</span></td>
                                    <td><div align="center"><cfinput name="pos29" type="checkbox" id="pos29" value="Si" checked="#Iif(vCampoPos29 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Curriculum vitae -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos36#</span></td>
                                    <td><div align="center"><cfinput name="pos36" type="checkbox" id="pos36" value="Si" checked="#Iif(vCampoPos36 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Documentos que acrediten la antigüedad -->
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
