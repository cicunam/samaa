<!--- CREADO: ARAM PICHARDO--->
<!--- EDITO: ARAM PICHARDO--->
<!--- FECHA CREA: 05/06/2009--->
<!--- FECHA ÚLTIMA MOD.: 19/07/2024 --->
<!--- FT-CTIC-17.-Nuevo dictamen de Concurso Abierto (Contrato) o Nombramiento Definitivo--->

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
	<body <cfif #vTipoComando# EQ 'NUEVO'> onLoad="fAgregarOponente('GANADOR', 0);"<cfelse>onLoad="fAgregarOponente('CONSULTA', 0);"</cfif>>
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
                        <!-- INCLUDE para la información de los oponentes LISTA, AGREGAR Y BAJAS -->
                        <cfinclude template="ft_include_oponentes_coa.cfm">
                        <!-- Datos que deben ingresarse -->
                        <cfoutput>
                            <table border="0" class="cuadrosFormularios">
                                <tr>
                                    <!-- El contrato inicia a partir del (Se agregó el 30/06/2022) -->
                                    <td width="20%"><span class="Sans9GrNe">#ctMovimiento.mov_pos14#</span></td>
                                    <td width="80%" colspan="2">
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos14)#&nbsp;</span>
                                        <cfelse>
                                            <!--- CONTROL DE CAPTURA DE FECHAS --->
                                            <cfinput type="text" name="pos14" disabled='#vActivaCampos#' class="datos" id="pos14" value="#vCampoPos14#" size="10" maxlength="10" onkeypress="return MascaraEntrada(event, '99/99/9999');">
                                        </cfif>
                                    </td>
                                </tr>
                                
                                <!-- Número de plaza -->
                                <tr>
                                    <td width="35%"><span class="Sans9GrNe">#ctMovimiento.mov_pos9#</span></td>
                                    <td width="65%">
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#tbConvocatorias.coa_no_plaza#</span>
                                        <cfelse>
                                            <cfinput type="text" name="pos9" value="#tbConvocatorias.coa_no_plaza#" size="9" maxlength="8" class="datos" id="pos3" disabled>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Categoría y nivel de la plaza -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos8#</span></td>
                                    <td>
                                        <cfinput name="pos23" id="pos23" type="hidden" value="#vCampoPos23#">
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoPos8_txt#</span>
                                        <cfelse>
                                            <cfselect name="pos8" class="datos" id="pos8" query="ctCategoria" queryPosition="below" value="cn_clave" display="cn_siglas" selected="#tbConvocatorias.cn_clave#" disabled>
                                                <option value="" selected>SELECCIONE</option>
                                            </cfselect>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Fecha de publicación en gaceta -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos21# </span></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos21)#</span>
                                        <cfelse>
                                            <cfinput name="pos21" type="text" class="datos" id="pos21" value="#LsdateFormat(tbConvocatorias.coa_gaceta_fecha,'dd/mm/yyyy')#" size="10" maxlength="10" disabled>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- En el área -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_memo1#</span></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#Ucase(tbConvocatorias.coa_area)#</span>
                                        <cfelse>
                                            <cftextarea name="memo1" rows="5" class="datos100" id="memo1" value="#Ucase(tbConvocatorias.coa_area)#" disabled></cftextarea>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Número de concursantes que se presentaron -->
                                <tr>
                                    <td colspan="2">
                                        <span class="Sans9GrNe">#ctMovimiento.mov_pos17#&nbsp;</span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#NumberFormat(vCampoPos17,"99")#</span>
                                        <cfelse>
                                            <cfinput name="pos17" type="text" class="datos" id="pos17" size="3" maxlength="2" disabled>
                                        </cfif>
                                    </td>
                                </tr>
                            </table>
                        </cfoutput>
                        <!-- Datos obtenidos por el sistema -->
                        <cfoutput>
                            <table border="0" class="cuadrosFormularios">
                                <!-- Categor&iacute;a y nivel -->
                                <tr>
                                  <td width="35%"><span class="Sans9GrNe">#ctMovimiento.mov_pos3#</span></td>
                                  <td width="65%"><cfif #vTipoComando# IS 'IMPRIME'>
                                    <span class="Sans9Gr">#vCampoPos3_txt#</span>
                                    <cfelse>
                                    <cfinput name="pos3_txt" id="pos3_txt" type="text" class="datos" size="20" value="#vCampoPos3_txt#" disabled>
                                    <cfinput name="pos3" id="pos4" type="hidden" value="#vCampoPos3#">
                                  </cfif></td>
                                </tr>
                                <!-- Antig&uuml;edad en esa categor&iacute;a y nivel -->
                                <tr>
                                  <td><span class="Sans9GrNe">#ctMovimiento.mov_pos4#</span></td>
                                  <td><cfif #vTipoComando# IS 'IMPRIME'>
                                    <span class="Sans9Gr">#vCampoPos4_txt#</span>
                                    <cfelse>
                                    <cfinput name="pos4_txt" id="pos4_txt" type="text" value="#vCampoPos4_txt#" size="30" maxlength="100" disabled class="datos">
                                    <cfinput name="pos4" id="pos5" type="hidden" value="#vCampoPos4#">
                                  </cfif></td>
                                </tr>
                                <!-- Tipo de contrato -->
                                <tr>
                                  <td><span class="Sans9GrNe">#ctMovimiento.mov_pos5#</span></td>
                                  <td><span class="Sans9Gr">
                                    <cfinput type="radio" name="pos5" id="pos5_i" value="2" checked="#Iif(vCampoPos5 EQ "2",DE("yes"),DE("no"))#" disabled>
                                    Concurso Abierto&nbsp;
                                    <cfinput type="radio" name="pos5" id="pos5_d" value="1" checked="#Iif(vCampoPos5 EQ "1",DE("yes"),DE("no"))#" disabled>
                                    Definitivo&nbsp;
                                    <cfinput type="radio" name="pos5" id="pos5_o" value="3" checked="#Iif(vCampoPos5 EQ "3",DE("yes"),DE("no"))#" disabled>
                                    Obra determinada </span></td>
                                </tr>
                                <!-- Antig&uuml;edad acad&eacute;mica -->
                                <tr>
                                  <td><span class="Sans9GrNe">#ctMovimiento.mov_pos6#</span></td>
                                  <td><cfif #vTipoComando# IS 'IMPRIME'>
                                    <span class="Sans9Gr">#vCampoPos6_txt#</span>
                                    <cfelse>
                                    <cfinput name="pos6_txt" id="pos6_txt" type="text" class="datos" size="30" value="#vCampoPos6_txt#" disabled>
                                    <cfinput name="pos6" id="pos6" type="hidden" value="#vCampoPos6#">
                                  </cfif></td>
                                </tr>
                                <!-- Fecha de primer contrato -->
                                <tr>
                                  <td><span class="Sans9GrNe">#ctMovimiento.mov_pos7#</span></td>
                                  <td><cfif #vTipoComando# IS 'IMPRIME'>
                                    <span class="Sans9Gr">#FechaCompleta(vCampoPos7)#</span>
                                    <cfelse>
                                    <cfinput name="pos7" id="pos7" type="text" class="datos" size="10" value="#vCampoPos7#" disabled>
                                  </cfif></td>
                                </tr>
							</table>
                        </cfoutput>
  						<!-- Dictámenes -->
						<!--- Llamado a INCLUDE general de los dictámenes requeridos en la FT 18/07/2024 --->
						<cfinclude template="ft_include_anexoDictamen.cfm">
<!---
                        <cfoutput>
                            <table border="0" class="cuadrosFormularios">
                                <tr bgcolor="##CCCCCC">
                                    <td width="65%"></td>
                                    <td width="20%"><div align="center" class="Sans10NeNe">Aprobatorio</div></td>
                                    <td width="15%"><div align="center" class="Sans10NeNe">Se anexa </div></td>
                                </tr>
                                <!-- Nuevo Dictamen de la Comisión Dictaminadora -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos30#</span></td>
                                    <td>
                                        <div align="center">
                                            <span class="Sans9GrNe">
                                                <cfinput name="pos30" type="radio" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos30 EQ 'Si',DE("yes"),DE("no"))#">S&iacute;&nbsp;
                                                <cfinput name="pos30" type="radio" value="No" disabled='#vActivaCampos#' checked="#Iif(vCampoPos30 EQ 'No',DE("yes"),DE("no"))#">No
                                            </span>
                                        </div>
                                    </td>
                                    <td>
                                        <div align="center">
                                            <cfinput name="pos31" type="checkbox" id="pos31" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos31 EQ 'Si',DE("yes"),DE("no"))#">
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
                                <tr bgcolor="##CCCCCC">
                                    <td width="85%"></td>
                                    <td width="15%"> <div align="center" class="Sans10NeNe">Se anexa</div></td>
                                </tr>
                                <!-- Copia del oficio enviado por el CTIC a la Comisión Dictaminadora -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos33#</span></td>
                                    <td>
                                        <div align="center">
                                            <cfinput name="pos33" type="checkbox" id="pos33" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos33 EQ 'Si',DE("yes"),DE("no"))#">
                                        </div>
                                    </td>
                                </tr>
                                <!-- Curriculum vitae del (los) concursante(s) -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos36#</span></td>
                                    <td>
                                        <div align="center">
                                            <cfinput name="pos36" type="checkbox" id="pos36" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos36 EQ 'Si',DE("yes"),DE("no"))#">
                                        </div>
                                    </td>
                                </tr>
                                <!-- Trabajos publicados -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos37#</span></td>
                                    <td>
                                        <div align="center">
                                            <cfinput name="pos37" type="checkbox" id="pos37" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos37 EQ 'Si',DE("yes"),DE("no"))#">
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
