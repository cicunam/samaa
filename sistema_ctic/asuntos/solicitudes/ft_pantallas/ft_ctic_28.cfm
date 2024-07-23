<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 21/04/2009 --->
<!--- FECHA ÚLTIMA MOD.: 30/06/2016 --->
<!--- FT-CTIC-28.-Concurso de oposición para ingreso o Concurso Abierto (Nombramiento Definitivo) --->

<!--- Incluir los siguientes archivos --->
<cfif #vTipoComando# EQ 'IMPRIME_EJEMPLO'>
	<cfinclude template="ft_campos_blanco.cfm"> <!---PERIMITE IMPRIMIR LA FT EN BLANCO --->
	<cfset vTipoComando = 'IMPRIME'>
<cfelse>
	<cfinclude template="ft_campos.cfm">
</cfif>

<!--- Asignar valor al campo pos23 (Concocatoria COA) --->
<cfif #vCampoPos23# EQ ''>
	<cfset vCampoPos23='#vIdCoa#'>
</cfif>

<!--- Obtener datos de las convocatorias publicadas --->
<cfquery name="tbConvocatorias" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM convocatorias_coa
	LEFT JOIN catalogo_cn ON convocatorias_coa.cn_clave = catalogo_cn.cn_clave
	WHERE coa_id = '#vCampoPos23#'
</cfquery>

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

<!--- 
	<!--- Obtener datos del catalogo de países  (CATÁLOGOS GENERALES MYSQL) --->
	<cfquery name="ctPais" datasource="#vOrigenDatosCATALOGOS#">
		SELECT * FROM catalogo_paises
		ORDER BY pais_nombre
	</cfquery>
	
	<!--- Obtener datos del catálogo de grados --->
	<cfquery name="ctGrado" datasource="#vOrigenDatosSAMAA#">
		SELECT * FROM catalogo_grado ORDER BY grado_clave ASC
	</cfquery>
---->
<!--- Obtener la fecha de definitividad en esa categoría (Técnico o Investigador) --->
<cfquery name="tbMovimientos" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM (movimientos
	LEFT JOIN movimientos_asunto ON movimientos.sol_id = movimientos_asunto.sol_id)
	LEFT JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave
	WHERE acd_id = #vIdAcad#
	<cfif LEFT('#vCampoPos3_txt#',3) IS 'TEC'>
		AND (mov_clave = 7 OR mov_clave = 18)
	<cfelse>
		AND (mov_clave = 8 OR mov_clave = 18)
	</cfif>
	AND asu_reunion = 'CTIC'
	AND dec_super = 'AP' <!--- Asuntos aprobados --->
	ORDER BY mov_fecha_inicio DESC
</cfquery>

<!--- Asignar valor a la variable vCampoPos22 --->
<cfif #vCampoPos22# EQ 'dd/mm/yyyy' OR #vCampoPos22# EQ ''>
	<cfset vCampoPos22=#LsdateFormat(tbMovimientos.mov_fecha_inicio,'dd/mm/yyyy')#>
</cfif>

<html>
	<head>
		<!-- INCLUDE que agrega parte del contenido del encabezado -->
		<cfinclude template="ft_include_head_comun.cfm">
		<!-- JAVA SCRIT de uso local -->
		<script type="text/javascript">
			// Registrar el académico seleccionado por el usuario:
			function fSeleccionaAcad(vRegreso)
			{
				// Registrar el académico seleccionado por el usuario:
				document.getElementById('filtraacademico').value = document.getElementById('selAcadLista').options[document.getElementById('selAcadLista').selectedIndex].text;
				document.getElementById('idOponente').value = document.getElementById('selAcadLista').value;
				// Si el usuario selecciona NUEVO OPONENTE entonces mostrar el formulario para agregarlo:
				if (document.getElementById('selAcadLista').value == 'NUEVO')
				{
					fMostrarFormulario(true);
				}
				document.getElementById('academico_dynamic').innerHTML = '';
			}
/*			
			// Función para habilitar/deshabilitar el formulario para agregar académicos:
			function fMostrarFormulario(accion)
			{
				if (accion)
				{
					// Limpiar todos los campos del formulario:
					document.getElementById('frmPaterno').value = '';
					document.getElementById('frmMaterno').value = '';
					document.getElementById('frmNombres').value = '';
					document.getElementById('frmGrado').value = '';
					document.getElementById('frmSexoF').checked = false;
					document.getElementById('frmSexoM').checked = false;
					document.getElementById('frmNacionalidad').value = '';
					// Mostrar el formulario:
					document.getElementById('frmNuevoAcademico').style.display= '';
					// Ocultar los controles anteriores:
					document.getElementById('cmdAgregarOponente').style.display= 'none';
				}
				else
				{
					// Ocultar el formulario:
					document.getElementById('frmNuevoAcademico').style.display= 'none';
					// Mostrar los controles anteriores:
					document.getElementById('cmdAgregarOponente').style.display= '';
				}
			}
*/			
			// Validar los datos ingresados por el usuario:
			function fValidaCamposFt()
			{
				var vOk;
				var vMensaje = '';
				fLimpiaValida();
				vMensaje += fValidaCampoLleno('pos1_u','UBICACIÓN');
				vMensaje += fValidaMismoTipoAcademico(document.getElementById('pos3_txt').value,document.getElementById('pos8').options[document.getElementById('pos8').selectedIndex].text);
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
	<body <cfif #vTipoComando# EQ 'NUEVO'>onLoad="fAgregarOponente('GANADOR', 0);"<cfelse>onLoad="fAgregarOponente('CONSULTA', 0);"</cfif>>
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
                        <!-- Espacio para el encabezado de impresión -->
                        <div id="EncabezadoImpresion" align="center"></div>

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
                        <!-- INCLUDE para la información de los oponentes LISTA, AGREGAR Y BAJAS -->
                        <cfinclude template="ft_include_oponentes_coa.cfm">
                        <!-- Datos obtenidos por el sistema -->
                        <cfoutput>
                            <table border="0" class="cuadrosFormularios">
                                <!-- Categoría y nivel -->
                                <tr>
                                    <td width="35%"><span class="Sans9GrNe">#ctMovimiento.mov_pos3#</span></td>
                                    <td width="65%">
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoPos3_txt#</span>
                                        <cfelse>
                                            <cfinput name="pos3_txt" id="pos3_txt" type="text" class="datos" size="20" value="#vCampoPos3_txt#" disabled>
                                            <cfinput name="pos3" id="pos3" type="hidden" value="#vCampoPos3#">
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Desde (categoría y nivel) -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos4_f#</span></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos4_f)#</span>
                                        <cfelse>
                                            <cfinput name="pos4_f" id="pos4_f" type="text" class="datos" size="10" value="#vCampoPos4_f#" disabled>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Fecha en la que obtuvo la definitividad en esta categoría y nivel -->
                                <tr>
                                    <td colspan="2">
                                        <span class="Sans9GrNe">
                                            #ctMovimiento.mov_pos22#
                                            <cfif LEFT('#vCampoPos3#',3) IS 'TEC'>
                                                como T&eacute;cnico Acad&eacute;mico&nbsp;
                                            <cfelse>
                                                como Investigador&nbsp;
                                            </cfif>
                                        </span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos22)#&nbsp;</span>
                                        <cfelse>
                                            <cfinput name="pos22" id="pos22" type="text" class="datos" size="10" value="#vCampoPos22#" disabled>
                                        </cfif>
                                    </td>
                                </tr>
                                <!---
                                <!-- Tipo de contrato -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos5#</span></td>
                                    <td>
                                        <span class="Sans9Gr">
                                            <cfinput type="radio" name="pos5" id="pos5_i" value="2" checked="#Iif(vCampoPos5 EQ "2",DE("yes"),DE("no"))#" disabled>Concurso Abierto
                                            <cfinput type="radio" name="pos5" id="pos5_d" value="1" checked="#Iif(vCampoPos5 EQ "1",DE("yes"),DE("no"))#" disabled>Definitivo
                                            <cfinput type="radio" name="pos5" id="pos5_o" value="3" checked="#Iif(vCampoPos5 EQ "3",DE("yes"),DE("no"))#" disabled>Obra determinada
                                        </span>
                                    </td>
                                </tr>
                                --->
                                <!-- Antigüedad académica -->
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
                                <!-- Fecha de primer contrato -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos7#&nbsp;</span></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos7)#</span>
                                        <cfelse>
                                            <cfinput name="pos7" id="pos7" type="text" class="datos" size="10" value="#vCampoPos7#" disabled>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Número de plaza -->
                                <tr>
                                    <td class="Sans9GrNe">#ctMovimiento.mov_pos9#</td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#tbConvocatorias.coa_no_plaza#</span>
                                        <cfelse>
                                            <cfinput name="pos9" type="text" class="datos" id="pos10" value="#tbConvocatorias.coa_no_plaza#" size="9" maxlength="8" disabled>
                                            <cfinput name="pos23" id="pos23" type="hidden" value="#vCampoPos23#">
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Categoría y nivel de la plaza -->
                                <tr>
                                    <td class="Sans9GrNe"><cfoutput>#ctMovimiento.mov_pos8#</cfoutput></td>
                                    <td>
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
                                            <cfselect name="pos8" class="datos" id="pos8" query="ctCategoria" queryPosition="below" value="cn_clave" display="cn_siglas" selected="#tbConvocatorias.cn_clave#" disabled>
                                            <option value="" selected>SELECCIONE</option>
                                            </cfselect>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Fecha de publicación en gaceta -->
                                <tr>
                                    <td class="Sans9GrNe"><cfoutput>#ctMovimiento.mov_pos21#</cfoutput></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos21)#</span>
                                        <cfelse>
                                            <cfinput name="pos21" type="text" class="datos" id="pos21" value="#LsDateFormat(tbConvocatorias.coa_gaceta_fecha,'dd/mm/yyyy')#" size="10" maxlength="10" disabled>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- En el área -->
                                <tr>
                                    <td valign="top" class="Sans9GrNe"><cfoutput>#ctMovimiento.mov_memo1#</cfoutput></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoMemo1#</span>
                                        <cfelse>
                                            <cftextarea name="memo1" disabled class="datos100" id="memo1" maxlength="8" value="#Ucase(tbConvocatorias.coa_area)#" cols="72" rows="5" type="text" size="9"></cftextarea>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Número de concursantes -->
                                <tr>
                                    <td class="Sans9GrNe"><cfoutput>#ctMovimiento.mov_pos17#</cfoutput></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#NumberFormat(vCampoPos17,"99")#</span>
                                        <cfelse>
                                            <cfinput name="pos17" type="text" class="datos" id="pos17" value="#vCampoPos17#" size="2" maxlength="2" disabled>
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
                                    <td width="20%"><div align="center" class="Sans9GrNe">Aprobatorio</div></td>
                                    <td width="15%"><div align="center" class="Sans9GrNe">Se anexa</div></td>
                                </tr>
                                <!-- Dictámen de la comisión dictaminadora -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos30#</span></td>
                                    <!-- Si/No -->
                                    <td>
                                        <div align="center" class="Sans9GrNe">
                                            <cfinput name="pos30" type="radio" value="Si" checked="#Iif(vCampoPos30 EQ 'Si',DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>S&iacute;&nbsp;
                                            <cfinput name="pos30" type="radio" value="No" checked="#Iif(vCampoPos30 EQ 'No',DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>No
                                        </div>
                                    </td>
                                    <td>
                                        <div align="center">
                                            <cfinput name="pos31" type="checkbox" id="pos31" value="Si" checked="#Iif(vCampoPos31 EQ 'Si',DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>
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
                                    <td width="15%"><div align="center" class="Sans9GrNe">Se anexa</div></td>
                                </tr>
                                <!-- Carta del interesado dirigida al director -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos32#</span></td>
                                    <td><div align="center"><cfinput name="pos32" type="checkbox" id="pos32" value="Si" checked="#Iif(vCampoPos32 EQ 'Si',DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Convocatoria publicada en Gaceta UNAM -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos35#</span></td>
                                    <td><div align="center"><cfinput name="pos35" type="checkbox" id="pos35" value="Si" checked="#Iif(vCampoPos35 EQ 'Si',DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Curriculum vitae del ganador y oponentes -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos36#</span></td>
                                    <td><div align="center"><cfinput name="pos36" type="checkbox" id="pos36" value="Si" checked="#Iif(vCampoPos36 EQ 'Si',DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Examen o proyecto del ganador y oponentes -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos37#</span></td>
                                    <td><div align="center"><cfinput name="pos37" type="checkbox" id="pos37" value="Si" checked="#Iif(vCampoPos37 EQ 'Si',DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Constancia de último grado obtenido -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos38#</span></td>
                                    <td><div align="center"><cfinput name="pos38" type="checkbox" id="pos38" value="Si" checked="#Iif(vCampoPos38 EQ 'Si',DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Trabajos publicados -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos39#</span></td>
                                    <td><div align="center"><cfinput name="pos39" type="checkbox" id="pos39" value="Si" checked="#Iif(vCampoPos39 EQ 'Si',DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
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
<!-- Si de entrada el movimiento no procede, avisar al usuario para evitarle la captura -->
<script type="text/javascript">
	<cfif #vTipoComando# EQ 'NUEVO' AND #LEFT(vCampoPos3_txt, 3)# NEQ #LEFT(tbConvocatorias.cn_siglas, 3)#>
		<cfif #LEFT(vCampoPos3_txt,3)# EQ 'TEC'>
			alert('AVISO: Un Técnico Académico no puede concursar por una plaza de Investigador. Si prosigue con la captura la solicitud será rechazada.');
		<cfelse>
			alert('AVISO: Un Investigador no puede concursar por una plaza de Técnico Académico. Si prosigue con la captura la solicitud será rechazada.');
		</cfif>
	</cfif>
</script>
