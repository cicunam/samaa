<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 17/04/2009 --->
<!--- FECHA ÚLTIMA MOD.: 29/07/2022 --->
<!--- FT-CTIC-38.-Beca posdoctoral --->

<!--- Incluir los siguientes archivos --->
<cfif #vTipoComando# EQ 'IMPRIME_EJEMPLO'>
	<cfinclude template="ft_campos_blanco.cfm"> <!---PERIMITE IMPRIMIR LA FT EN BLANCO --->
	<cfset vTipoComando = 'IMPRIME'>
<cfelse>
	<cfinclude template="ft_campos.cfm">
</cfif>

<!--- Obtener la lista de ubicaciones de la entidad  (CATÁLOGOS GENERALES MYSQL) --->
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

<!--- Obtener la fecha límite de recepción de becas (SE DECIDIÓ INCORPORAR EN LA BD DE BECARIOS POSDOC LA FECHA LÍMITE Y DEMÁS DATOS REFERENTE A LA CONVOCATORIA 11/12/2017)--->
<cfquery name="tbConvocatoriaBp" datasource="#vOrigenDatosPOSDOC#">
	SELECT TOP 1 * FROM convocatorias_periodos
    WHERE fecha_limite >= '#vFechaHoy#'
    ORDER BY fecha_limite
</cfquery>

<!--- Obtener la fecha límite de recepción de becas ELIMINAR
<cfquery name="tbSesionesLimite" datasource="#vOrigenDatosSAMAA#">
	SELECT TOP 1 * FROM sesiones
	WHERE ssn_clave = 6
	AND ssn_fecha >= '#vFechaHoy#'
	ORDER BY ssn_fecha
</cfquery>
 --->

<!--- ELIMINA XXXXXXXXXXXXXX
	<!--- Obtener datos del catálogo de categorías y niveles del asesor (CATÁLOGOS GENERALES MYSQL) --->
	<cfif #vCampoPos8# NEQ ''>
		<cfquery name="ctCategoria" datasource="#vOrigenDatosCATALOGOS#">
			SELECT * FROM catalogo_cn 
			WHERE cn_clave = '#vCampoPos8#'
			ORDER BY cn_siglas
		</cfquery>
		<cfset vCampoPos8_txt='#ctCategoria.cn_siglas#'>
	<cfelse>
		<cfset vCampoPos8_txt=''>
	</cfif>
--->

<!--- Obtener el nombre del asesor --->
<cfif #vCampoPos12# NEQ ''>
	<cfquery name="tbAcademicoAsesor" datasource="#vOrigenDatosSAMAA#">
	   	SELECT * FROM academicos 
        WHERE acd_id = #vCampoPos12#
	</cfquery>
	<cfset vCampoPos12_txt = '#Trim(tbAcademicoAsesor.acd_prefijo)# #Trim(tbAcademicoAsesor.acd_nombres)# #Trim(tbAcademicoAsesor.acd_apepat)# #Trim(tbAcademicoAsesor.acd_apemat)# '>
<cfelse>
	<cfset vCampoPos12_txt=''>
</cfif>

<!--- Obtener el nombre del becario que declinó, si existe --->
<cfif #vCampoPos12_o# NEQ ''>
	<cfquery name="tbAcademicoAsesor" datasource="#vOrigenDatosSAMAA#">
	   	SELECT * FROM academicos WHERE acd_id = #vCampoPos12_o#
	</cfquery>
	<cfset vCampoPos12_o_txt = '#Trim(tbAcademicoAsesor.acd_apepat)# #Trim(tbAcademicoAsesor.acd_apemat)# #Trim(tbAcademicoAsesor.acd_nombres)#'>
<cfelse>
	<cfset vCampoPos12_o_txt=''>
</cfif>
<!--- Prellenar el campo número de horas --->
<cfif #vCampoPos16# IS ''>
	<cfset vCampoPos16='40'>
</cfif>

<!--- Buscar otro registro de Beca Posdoctoral del mismo académico --->
<cfquery name="tbMovimientosBecas" datasource="#vOrigenDatosSAMAA#">
	SELECT COUNT(*) AS numero_becas
	FROM (movimientos
	LEFT JOIN movimientos_asunto ON movimientos.sol_id = movimientos_asunto.sol_id)
	LEFT JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave
	WHERE acd_id = #vIdAcad#
	AND mov_clave = 38 <!--- Beca posdoctoral --->
	AND asu_reunion = 'CTIC'
	AND dec_super = 'AP' <!--- Asuntos aprobados --->
	AND mov_cancelado = 0
</cfquery>

<html>
	<head>
		<!-- INCLUDE que agrega parte del contenido del encabezado -->
		<cfinclude template="ft_include_head_comun.cfm">
		<!-- JAVA SCRIT de uso local -->
		<script type="text/javascript">
			// Actualizar el formulario:
			function fActualizar()
			{
				if (document.getElementById('pos20_s').checked)
				{
					show('pos12_o_row');
				}
				else
				{
					hide('pos12_o_row');
					document.getElementById('pos12_o').value = '';
					document.getElementById('pos12_o_txt').value = '';
				}
			}
			// Validación de los datos ingresados por el usuario:
			function fValidaCamposFt()
			{
				var vMensaje = '';
				fLimpiaValida();
				vMensaje += fValidaCampoLleno('pos1_u','UBICACIÓN');
				vMensaje += fValidaFecha('pos21','FECHA OBTIENCION GRADO');                
				vMensaje += fValidaFecha('pos14','INICIAL');
				vMensaje += fValidaCampoLleno('pos11_p','PAÍS');
				vMensaje += fValidaCampoLleno('pos16','HORAS');
				vMensaje += fValidaCampoLleno('pos12','ASESOR');
				vMensaje += fValidaCampoLleno('memo1','PROYECTO');
				vMensaje += <cfoutput>#tbMovimientosBecas.numero_becas#</cfoutput> == 0 ? '': 'El académico ya recibió una BECA POSDOCTORAL debe solicitar una renovación.\n';
				if (vMensaje.length > 0)
				{
					alert(vMensaje);
					return false;
				}
				else
				{
					// Advertencias (warnings):
					if (fValidaCampoLleno('static_FechaNacimiento','') != '' || fValidaCampoLleno('static_PaisNacimiento','') != '') alert('ADVERTENCIA: Los datos del becario están incompletos, aunque podrá guardarse el registro ahora será necesario actualizar los datos del becario para imprimir la FT.');
					return true;
				}
			}
			// El usuario selecciona un académico de la lista:
			function fSeleccionaAcad(vRegreso)
			{
				vRegreso

				if (vRegreso == 'pos12')
				{
					// Mostrar el nombre del académico asesor:
					document.getElementById('pos12').value = document.getElementById('selAcadLista').options[document.getElementById('selAcadLista').selectedIndex].value
					document.getElementById('pos12_txt').value = document.getElementById('selAcadLista').options[document.getElementById('selAcadLista').selectedIndex].text;
					// Actualizar el campo CCN del asesor:
					ObtenerCcnAsesor(document.getElementById('selAcadLista').options[document.getElementById('selAcadLista').selectedIndex].value);
					// Ocultar la lista de académicos:
					document.getElementById('academico_dynamic').innerHTML = '';
					document.getElementById('academico_dynamic').style.display = 'none';
				}
				else if (vRegreso == 'pos12_o')
				{
					// Mostrar el nombre del académico asesor:
					document.getElementById('pos12_o').value = document.getElementById('selAcadLista').options[document.getElementById('selAcadLista').selectedIndex].value
					document.getElementById('pos12_o_txt').value = document.getElementById('selAcadLista').options[document.getElementById('selAcadLista').selectedIndex].text;
					// Ocultar la lista de académicos:
					document.getElementById('becario_dynamic').innerHTML = '';
					document.getElementById('becario_dynamic').style.display = 'none';
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
                        <p align="center">	                        
                            <cfif #vTipoComando# IS 'IMPRIME'><br><br></cfif>
                            <cfif #vTipoComando# NEQ 'IMPRIME' AND #Session.sTipoSistema# IS 'sic' AND #tbConvocatoriaBp.RecordCount# EQ 1>
                                <cfoutput query="tbConvocatoriaBp">
                                    <br>
                                    <br>
                                    <span class="Sans11ViNe">LA FECHA LÍMITE DE RECEPCIÓN DE BECAS POSDOCTORALES</span><br>
                                    <span class="Sans12ViNe">PARA EL PERIODO #periodo_convocatoria# ES EL #LsDateFormat(fecha_limite, 'dd')# DE #UCASE(LsDateFormat(fecha_limite, 'mmmm'))# DE #LsDateFormat(fecha_limite, 'yyyy')#</span><br>
                                </cfoutput>
                            </cfif>
                        </p>

                        <!-- INCLUDE Campos ocultos GENERALES-->
                        <cfinclude template="ft_include_campos_ocultos.cfm">
                        <!-- Datos para ser llenados por la ST-CTIC -->
						<cfif #Session.sTipoSistema# IS 'stctic' AND #vSolStatus# LT 3 AND #vTipoComando# IS NOT 'NUEVO' AND #vTipoComando# IS NOT 'IMPRIME' AND #vHistoria# IS NOT 1>
							<cfinclude template="ft_control.cfm">
						</cfif>

                        <!-- INCLUDE para visualisar Datos generales -->
                        <cfinclude template="ft_include_general.cfm">
                        <!-- Datos obtenidos del sistema -->
                        <cfoutput>
                            <table border="0" class="cuadrosFormularios">
                                <!-- Sexo -->
                                <tr>
                                    <td width="35%"><span class="Sans9GrNe">Sexo</span></td>
                                    <td width="65%">
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#Iif(tbAcademico.acd_sexo IS 'F',DE("Femenino"),DE("Masculino"))#</span>
                                        <cfelse>
                                            <cfinput name="nombre" type="text" class="datos" size="10" value="#Iif(tbAcademico.acd_sexo IS 'F',DE("Femenino"),DE("Masculino"))#" disabled>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Fecha de nacimiento -->
                                <tr>
                                    <td><span class="Sans9GrNe">Fecha de nacimiento</span></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(tbAcademico.acd_fecha_nac)#</span>
                                        <cfelse>
                                            <cfinput name="static_FechaNacimiento" id="static_FechaNacimiento" type="text" class="datos" size="10" value="#LsdateFormat(tbAcademico.acd_fecha_nac,'dd/mm/yyyy')#" disabled>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- País de nacimiento -->
                                <tr>
                                    <td><span class="Sans9GrNe">País de nacimiento</span></td>
                                    <td>
                                        <cfset vPaisNacimiento = ''>
                                        <cfloop query="ctPais">
                                            <cfif #pais_clave# IS #tbAcademico.pais_clave#>
                                                <cfset vPaisNacimiento = '#pais_nombre#'>
                                                <cfbreak>
                                            </cfif>
                                        </cfloop>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vPaisNacimiento#</span>
                                        <cfelse>
                                            <cfinput name="static_PaisNacimiento" type="text" class="datos" size="40" value="#vPaisNacimiento#" disabled>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Fecha de obtención del grado de doctor -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos21#</span></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos21)#</span>
                                        <cfelse>
                                            <cfinput name="pos21" type="text" class="datos" id="pos21" size="10" maxlength="10" value="#vCampoPos21#" disabled='#vActivaCampos#' onkeypress="return MascaraEntrada(event, '99/99/9999');">
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- País donde obtuvo el doctorado -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos11_p#</span></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <cfset vCampoPos11_p_txt = ''>
                                            <cfloop query="ctPais">
                                                <cfif #pais_clave# IS #vCampoPos11_p#>
                                                    <cfset vCampoPos11_p_txt = '#pais_nombre#'>
                                                    <cfbreak>
                                                </cfif>
                                            </cfloop>
                                            <span class="Sans9Gr">#vCampoPos11_p_txt#</span>
                                        <cfelse>
                                            <cfselect name="pos11_p" id="pos11_p" class="datos" query="ctPais" value="pais_clave" display="pais_nombre" queryPosition="Below" disabled='#vActivaCampos#' selected="#vCampoPos11_p#">
                                            <option value="">SELECCIONE</option>
                                            </cfselect>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Institución donde obtuvo el doctorado -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos11#</span></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoPos11#</span>
                                        <cfelse>
                                            <cfinput name="pos11" type="text" class="datos100" id="pos11" maxlength="254" value="#vCampoPos11#" disabled='#vActivaCampos#'>
                                        </cfif>
                                    </td>
                                </tr>
                            </table>
						</cfoutput>
						<!-- Datos ddebe ingresar -->
                        <cfoutput>
                            <table border="0" class="cuadrosFormularios">
                                <!-- Duración de la beca -->
                                <tr>
                                    <td width="30%"><span class="Sans9GrNe">#ctMovimiento.mov_pos13#</span></td>
                                    <td width="70%">
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">1 #ctMovimiento.mov_pos13_a#&nbsp;</span>
                                        <cfelse>
                                            <cfinput name="pos13_a" type="text" class="datos" id="pos13_a" size="1" Hmaxlength="1" value="1" disabled>
                                            <span class="Sans9Gr">#ctMovimiento.mov_pos13_a#</span>
                                            <!---
                                            <input type="text" class="datos" size="2" maxlength="1" disabled>
                                            <span class="Sans9Gr">#ctMovimiento.mov_pos13_m#</span>
                                            <input type="text" class="datos" size="2" maxlength="1" disabled>
                                            <span class="Sans9Gr">#ctMovimiento.mov_pos13_d#</span>
                                            --->
                                        </cfif>
                                        <!-- Fechas -->
                                        <span class="Sans9Gr">#ctMovimiento.mov_pos14#</span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos14)#&nbsp;</span>
                                        <cfelse>
                                            <cfinput name="pos14" type="text" class="datos" id="pos14" value="#vCampoPos14#" size="10" maxlength="10" disabled='#vActivaCampos#' onblur="CalcularSiguienteFecha();" onkeypress="return MascaraEntrada(event, '99/99/9999');">
                                        </cfif>
                                        <span class="Sans9Gr">#ctMovimiento.mov_pos15#</span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos15)#</span>
                                        <cfelse>
                                            <cfinput name="pos15" type="text" class="datos" id="pos15" value="#vCampoPos15#" size="10" maxlength="10" disabled>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Horas a la semana -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos16#</span></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#NumberFormat(vCampoPos16,"99")#</span>
                                        <cfelse>
                                            <cfinput name="pos16" id="pos16" type="text" class="datos" size="3" maxlength="3" disabled='#vActivaCampos#' value="#vCampoPos16#" onkeypress="return MascaraEntrada(event, '99');">
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Nombre del asesor -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos12#</span></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoPos12_txt#</span>
                                        <cfelse>
                                            <cfinput name="pos12_txt" id="pos12_txt" class="datos" type="text" size="100" maxlength="254" value="#vCampoPos12_txt#" disabled='#vActivaCampos#' autocomplete="off" onKeyUp="fObtenerAcademicos('pos12_txt','academico_dynamic','pos12')" style="width:450px" placeholder="Escriba el nombre del asesor y seleccione del menú que se despliega (NO COPIAR Y PEGAR)...">
                                            <cfinput name="pos12" id="pos12" type="hidden" value="#vCampoPos12#">
                                            <br>
                                            <div id="academico_dynamic" style="position:absolute;display:block;"></div>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Categoría y nivel del asesor -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos8#</span></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoPos8_txt#</span>
                                        <cfelse>
                                            <span id="ccn_dynamic">
                                                <cfinput name="pos8_txt" id="pos8_txt" type="text" class="datos" size="20" value="#vCampoPos8_txt#" disabled>
                                                <cfinput name="pos8" id="pos8" type="hidden" value="#vCampoPos8#">
                                            </span>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Nombre del proyecto que se desarrollará -->
                                <tr>
                                    <td colspan="2"><span class="Sans9GrNe">#ctMovimiento.mov_memo1#</span></td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoMemo1#</span>
                                        <cfelse>
                                            <cftextarea name="memo1" id="memo1" rows="5" class="datos100" value="#vCampoMemo1#" disabled='#vActivaCampos#'></cftextarea>
                                        </cfif>
                                    </td>
                                </tr>
                                <cfif #Session.sTipoSistema# IS 'stctic'>
                                    <!-- Asignación de beca por declinación de otro becario -->
                                    <tr>
                                        <td colspan="2">
                                            <span class="Sans9GrNe">#ctMovimiento.mov_pos20#&nbsp;</span>
                                            <cfinput name="pos20" id="pos20_s" type="radio" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos20 EQ "Si",DE("yes"),DE("no"))#" onclick="fActualizar();"><span class="Sans9Gr">S&iacute;&nbsp;</span>
                                            <cfinput name="pos20" id="pos20_n" type="radio" value="No"  disabled='#vActivaCampos#' checked="#Iif(vCampoPos20 EQ "No",DE("yes"),DE("no"))#" onclick="fActualizar();"><span class="Sans9Gr">No</span>
                                        </td>
                                    </tr>
                                    <!-- En sustitución de -->
                                    <tr id="pos12_o_row">
                                        <td><span class="Sans9GrNe">#ctMovimiento.mov_pos12_o#</span></td>
                                        <td>
                                            <cfif #vTipoComando# IS 'IMPRIME'>
                                                <span class="Sans9Gr">#vCampoPos12_o_txt#</span>
                                            <cfelse>
                                                <cfinput name="pos12_o_txt" id="pos12_o_txt" class="datos" type="text" size="100" maxlength="254" value="#vCampoPos12_o_txt#" disabled='#vActivaCampos#' autocomplete="off" onKeyUp="fObtenerAcademicos('pos12_o_txt','becario_dynamic','pos12_o')" style="width:400px">
                                                <cfinput name="pos12_o" id="pos12_o" type="hidden" value="#vCampoPos12_o#">
                                                <br>
                                                <div id="becario_dynamic" style="position:absolute; display:block;"></div>
                                            </cfif>
                                        </td>
                                    </tr>
                                </cfif>
                            </table>
                        </cfoutput>
                        <!-- Dictámenes -->
                        <cfoutput>
                            <table border="0" class="cuadrosFormularios">
                                <!-- Encabezados -->
                                <tr bgcolor="##CCCCCC">
                                    <td width="65%"></td>
                                    <td width="20%"><div align="center" class="Sans10NeNe">Aprobatoria</div></td>
                                    <td width="15%"><div align="center" class="Sans10NeNe">Se anexa</div></td>
                                </tr>
                                <!-- Opinión del consejo interno -->
                                <tr>
                                    <!-- Si/No -->
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos26#</span></td>
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
                                <!-- Carta del director -->
                                <tr>
                                    <!-- Si/No -->
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos28#</span></td>
                                    <td>
                                        <div align="center" class="Sans9GrNe">
                                            <cfinput name="pos28" type="radio" value="Si" checked="#Iif(vCampoPos28 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>S&iacute;&nbsp;
                                            <cfinput name="pos28" type="radio" value="No" checked="#Iif(vCampoPos28 EQ "No",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>No
                                        </div>
                                    </td>
                                    <!-- Se anexa -->
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
                                <!-- Constancia de obtención del grado de doctor -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos38#</span></td>
                                    <td><div align="center"><cfinput name="pos38" type="checkbox" id="pos38" value="Si" checked="#Iif(vCampoPos38 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Resumen de su tesis doctoral -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos37#</span></td>
                                    <td><div align="center"><cfinput name="pos37" type="checkbox" id="pos37" value="Si" checked="#Iif(vCampoPos37 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Curriculum vitae -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos36#</span></td>
                                    <td><div align="center"><cfinput name="pos36" type="checkbox" id="pos36" value="Si" checked="#Iif(vCampoPos36 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Carta-invitación de la entidad académica -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos33#</span></td>
                                    <td><div align="center"><cfinput name="pos33" type="checkbox" id="pos33" value="Si" checked="#Iif(vCampoPos33 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Proyecto de investigación -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos34#</span></td>
                                    <td><div align="center"><cfinput name="pos34" type="checkbox" id="pos34" value="Si" checked="#Iif(vCampoPos34 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Carta del candidato en la que se comprometa a dedicarse a tiempo completo -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos32#</span></td>
                                    <td><div align="center"><cfinput name="pos32" type="checkbox" id="pos32" value="Si" checked="#Iif(vCampoPos32 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Sintesis curricular del asesor -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos30#</span></td>
                                    <td><div align="center"><cfinput name="pos30" type="checkbox" id="pos30" value="Si" checked="#Iif(vCampoPos30 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
								<!--- Síntesis curricular del asesor --->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos40#</span></td>
                                    <td><div align="center"><cfinput name="pos40" type="checkbox" id="pos40" value="Si" checked="#Iif(vCampoPos40 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Tres últimos informes aprobados del asesor -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos41#</span></td>
                                    <td><div align="center"><cfinput name="pos41" type="checkbox" id="pos41" value="Si" checked="#Iif(vCampoPos41 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Formatos de solicitud DGAPA (copia) -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos35#</span></td>
                                    <td><div align="center"><cfinput name="pos35" type="checkbox" id="pos35" value="Si" checked="#Iif(vCampoPos35 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Documento que indique fecha de nacimiento (copia) -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos31#</span></td>
                                    <td><div align="center"><cfinput name="pos31" type="checkbox" id="pos31" value="Si" checked="#Iif(vCampoPos31 EQ 'Si',DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Trabajos publicados -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos39#</span></td>
                                    <td><div align="center"><cfinput name="pos39" type="checkbox" id="pos39" value="Si" checked="#Iif(vCampoPos39 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <tr>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                </tr>
                                <tr>
                                    <td colspan="2"><span class="Sans9Gr">* Reglas de Operación: IV. Requisitos punto 8</span></td>
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
