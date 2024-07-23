<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA: 17/04/2009 --->
<!--- FECHA ÚLTIMA MOD.: 29/06/2016 --->
<!--- FT-CTIC-39.-Beca posdoctoral (renovación) --->

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
	<cfset vCampoPos12_txt = ' #Trim(tbAcademicoAsesor.acd_prefijo)# #Trim(tbAcademicoAsesor.acd_nombres)# #Trim(tbAcademicoAsesor.acd_apepat)# #Trim(tbAcademicoAsesor.acd_apemat)#'>
<cfelse>
	<cfset vCampoPos12_txt=''>
</cfif>

<!--- Prellenar el campo número de horas --->
<cfif #vCampoPos16# IS ''>
	<cfset vCampoPos16='40'>
</cfif>

<!--- Buscar el registro de Beca Posdoctoral que se va a renovar --->
<cfquery name="tbMovimientosBecas1" datasource="#vOrigenDatosSAMAA#">
	SELECT *
	FROM (movimientos AS T1
	LEFT JOIN movimientos_asunto AS T2 ON T1.sol_id = T2.sol_id)
	LEFT JOIN catalogo_decision AS C1 ON T2.dec_clave = C1.dec_clave
	WHERE T1.acd_id = #vIdAcad#
	AND T1.mov_clave = 38 <!--- Beca Posdoctoral --->
	AND T2.asu_reunion = 'CTIC'
	AND (C1.dec_super = 'AP' OR C1.dec_super = 'CO') <!--- Asuntos aprobados (AP) o condicionado a obtención de grado (CO)--->
	AND (T1.mov_cancelado = 0 OR T1.mov_cancelado IS NULL) <!--- Verifica que el asunto no esté cancelado --->
	ORDER BY T1.mov_fecha_inicio DESC <!--- Ordernar para obtener primero en último regostro --->
</cfquery>

<!--- Prellenar el campo fecha de inicio --->
<cfif #tbMovimientosBecas1.RecordCount# GT 0 AND #vCampoPos14# IS ''>
	<cfset vCampoPos14='#LsDateFormat(tbMovimientosBecas1.mov_fecha_final + 1,'dd/mm/yyyy')#'>
</cfif>

<html>
	<head>
		<!-- INCLUDE que agrega parte del contenido del encabezado -->
		<cfinclude template="ft_include_head_comun.cfm">
		<!-- JAVA SCRIT de uso local -->
		<script type="text/javascript">
			// Validación de los datos ingresados por el usuario:
			function fValidaCamposFt()
			{
				var vMensaje = '';
				fLimpiaValida();
				vMensaje += fValidaCampoLleno('pos1_u','UBICACIÓN');
				vMensaje += fValidaFecha('pos14','INICIAL');
				vMensaje += fValidaCampoLleno('pos16','HORAS');
				vMensaje += fValidaCampoLleno('pos12','ASESOR');
				vMensaje += fValidaCampoLleno('memo1','PROYECTO');
				vMensaje += fValidaUnDiaDespues('pos14', '<cfif #tbMovimientosBecas1.RecordCount# GT 0><cfoutput>#LsDateFormat(tbMovimientosBecas1.mov_fecha_final,'dd/mm/yyyy')#</cfoutput></cfif>', 'La FECHA DE INICIO debe ser un día posterior a la fecha de término de la beca anterior.\n');
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
			// El usuario selecciona un académico de la lista:
			function fSeleccionaAcad(vRegreso)
			{
				// Mostrar el nombre del académico asesor:
				document.getElementById('pos12').value = document.getElementById('selAcadLista').options[document.getElementById('selAcadLista').selectedIndex].value
				document.getElementById('pos12_txt').value = document.getElementById('selAcadLista').options[document.getElementById('selAcadLista').selectedIndex].text;
				// Actualizar el campo CCN del asesor:
				ObtenerCcnAsesor(document.getElementById('selAcadLista').options[document.getElementById('selAcadLista').selectedIndex].value);
				// Ocultar la lista de académicos:
				document.getElementById('academico_dynamic').innerHTML = '';
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
                        <!-- Datos obtenidos del sistema -->
                        <cfoutput>
                            <table border="0" class="cuadrosFormularios">
                                <!-- Sexo -->
                                <tr>
                                    <td width="20%"><span class="Sans9GrNe">Sexo</span></td>
                                    <td width="80%">
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
                                            <cfinput name="nombre" type="text" class="datos" size="10" value="#LsdateFormat(tbAcademico.acd_fecha_nac,'dd/mm/yyyy')#" disabled>
                                        </cfif>
                                    </td>
                                </tr>
                            </table>
						</cfoutput>
                        <cfoutput>
                            <table border="0" class="cuadrosFormularios">
                                <!-- Duración de la beca -->
                                <tr>
                                    <td width="30%"><span class="Sans9GrNe">#ctMovimiento.mov_pos13#</span></td>
                                    <td width="70%">
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">1 #ctMovimiento.mov_pos13_a#&nbsp;</span>
                                        <cfelse>
                                            <cfinput name="pos13_a" type="text" class="datos" id="pos13_a" size="1" maxlength="1" value="1" disabled>
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
                                            <cfinput name="pos14" type="text" id="pos14" class="datos" value="#vCampoPos14#" size="10" maxlength="10" disabled='#vActivaCampos#' onblur="CalcularSiguienteFecha();" onkeypress="return MascaraEntrada(event, '99/99/9999');">
                                        </cfif>
                                        <span class="Sans9Gr">#ctMovimiento.mov_pos15#</span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos15)#</span>
                                        <cfelse>
                                            <cfinput name="pos15" type="text" id="pos15" class="datos" value="#vCampoPos15#" size="10" maxlength="10" disabled>
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
                                            <cfinput name="pos12_txt" id="pos12_txt" class="datos" type="text" size="100" maxlength="254" value="#vCampoPos12_txt#" disabled='#vActivaCampos#' autocomplete="off" onKeyUp="fObtenerAcademicos('pos12_txt','academico_dynamic','');" style="width:450px" placeholder="Escriba el nombre del asesor y seleccione del menú que se despliega (NO COPIAR Y PEGAR)...">
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
                                <!-- Nombre del proyecto que se desarrollaró -->
                                <tr>
                                    <td colspan="2"><span class="Sans9GrNe">#ctMovimiento.mov_memo1#</span></td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoMemo1#</span>
                                        <cfelse>
                                            <cftextarea name="memo1" id="memo1" cols="80" rows="5" class="datos100" value="#vCampoMemo1#" disabled='#vActivaCampos#'></cftextarea>
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
                                <!-- Carta-invitación de la entidad académica -->
                                <tr>
                                  <td><span class="Sans9GrNe">#ctMovimiento.mov_pos33#</span></td>
                                  <td><div align="center"><cfinput name="pos33" type="checkbox" id="pos33" value="Si" checked="#Iif(vCampoPos33 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Informe de actividades del primer año de beca -->
                                <tr>
                                  <td><span class="Sans9GrNe">#ctMovimiento.mov_pos37#</span></td>
                                  <td><div align="center">
                                    <cfinput name="pos37" type="checkbox" id="pos37" value="Si" checked="#Iif(vCampoPos37 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>
                                  </div></td>
                                </tr>
                                <!-- Programa de actividades de investigación -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos34#</span></td>
                                    <td><div align="center"><cfinput name="pos34" type="checkbox" id="pos34" value="Si" checked="#Iif(vCampoPos34 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Curriculum vitae (actualizado) -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos36#</span></td>
                                    <td><div align="center">
                                      <cfinput name="pos36" type="checkbox" id="pos36" value="Si" checked="#Iif(vCampoPos36 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>
                                    </div></td>
                                </tr>
                                <!-- Carta del candidato en la que se comprometa a dedicarse a tiempo completo -->
                                <tr>
                                  <td><span class="Sans9GrNe">#ctMovimiento.mov_pos32#</span></td>
                                  <td><div align="center">
                                    <cfinput name="pos32" type="checkbox" id="pos32" value="Si" checked="#Iif(vCampoPos32 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>
                                  </div></td>
                                </tr>
                                <!-- Formatos de solicitud DGAPA (copia) -->
                                <tr>
                                  <td><span class="Sans9GrNe">#ctMovimiento.mov_pos35#</span></td>
                                  <td><div align="center">
                                    <cfinput name="pos35" type="checkbox" id="pos35" value="Si" checked="#Iif(vCampoPos35 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>
                                  </div></td>
                                </tr>								
                                <!-- Trabajos publicados -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos30#</span></td>
                                    <td><div align="center"><cfinput name="pos30" type="checkbox" id="pos30" value="Si" checked="#Iif(vCampoPos30 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
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
<!-- Si de entrada el movimiento no procede, avisar al usuario para evitarle la captura -->
<script type="text/javascript">
	<cfif #vTipoComando# EQ 'NUEVO' AND #tbMovimientosBecas1.RecordCount# LT 1>
	   	alert('AVISO: No se encontró el registro de beca posdoctoral anterior. Si prosigue con la captura la solicitud será rechazada.');
	</cfif>
<!---
	<cfelseif #tbMovimientosBecas2.numero_becas# GT 1>
		alert('AVISO: Sólo se permite una renovación de beca posdoctoral y el académico ya tuvo una. Si prosigue con la captura la solicitud será rechazada.');
	</cfif>
--->	
</script>
