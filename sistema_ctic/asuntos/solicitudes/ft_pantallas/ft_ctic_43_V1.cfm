<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 13/02/2014 --->
<!--- FECHA ÚLTIMA MOD.: 02/06/2022 --->
<!--- FT-CTIC-43.- Informe de beca y renovación posdoctoral --->

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

<!--- Buscar otro registro de Beca Posdoctoral del mismo académico --->
<cfquery name="tbMovimientosBecas" datasource="#vOrigenDatosSAMAA#">
	SELECT *
	FROM (movimientos AS T1
	LEFT JOIN movimientos_asunto AS T2 ON T1.sol_id = T2.sol_id)
	LEFT JOIN catalogo_decision AS C1 ON T2.dec_clave = C1.dec_clave
	<cfif #vTipoComando# EQ 'NUEVO'>
		WHERE T1.acd_id = #vIdAcad#
		AND (T1.mov_clave = 38 OR T1.mov_clave = 39) <!--- Beca o Renovación posdoctoral --->
		AND T2.asu_reunion = 'CTIC'
		AND (C1.dec_super = 'AP' OR C1.dec_super = 'CO')<!--- Asuntos aprobados --->
		AND (T1.mov_cancelado = 0 OR T1.mov_cancelado IS NULL)
        AND (GETDATE() BETWEEN T1.mov_fecha_inicio AND T1.mov_fecha_final OR T1.mov_fecha_final < GETDATE())
		ORDER BY T1.mov_fecha_inicio DESC
	<cfelse>
		WHERE T1.sol_id = #vCampoPos12#
	</cfif>
</cfquery>

<cfif #vTipoComando# EQ 'NUEVO'>
	<cfset vCampoPos14 = #LsDateFormat(tbMovimientosBecas.mov_fecha_inicio,'dd/mm/yyyy')#>
	<cfset vCampoPos15 = ''>
</cfif>

<cfif #tbMovimientosBecas.RecordCount# GT 0>
    <cfquery name="tbBajas" datasource="#vOrigenDatosSAMAA#">
        SELECT mov_fecha_inicio AS fecha_baja FROM movimientos
        WHERE acd_id = #vIdAcad#
        AND mov_clave = '14'
        AND (baja_clave = 1 OR baja_clave = 8)
        AND mov_fecha_inicio >  #LsDateFormat(tbMovimientosBecas.mov_fecha_inicio, 'dd/mm/yyyy')#
        ORDER BY mov_fecha_inicio DESC
    </cfquery>
    
    <cfif #tbBajas.RecordCount# EQ 0>
        <cfquery name="tbBajas" datasource="#vOrigenDatosSAMAA#">
            SELECT sol_pos14 AS fecha_baja FROM movimientos_solicitud
            WHERE sol_pos2 = #vIdAcad#
            AND mov_clave = '14'
            AND (sol_pos12 = 1 OR sol_pos12 = 8)
            AND sol_status < 4
            AND sol_pos14 >  #LsDateFormat(tbMovimientosBecas.mov_fecha_inicio, 'dd/mm/yyyy')#
            ORDER BY sol_pos14 DESC
        </cfquery>
    </cfif>
    <cfif #tbBajas.RecordCount# EQ 0>
        <cfset #vFechaBajaRenuncia# = 0>
    <cfelse>
        <cfset #vFechaBajaRenuncia# = #LsDateFormat(tbBajas.fecha_baja,'dd/mm/yyyy')#>
    </cfif>
<cfelse>
	<cfset #vFechaBajaRenuncia# = 0>    
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
				if (vMensaje.length > 0)
				{
					alert(vMensaje);
					return false;
				}
				else
				{
					// Advertencias (warnings):
					return true;
				}
			}
			function CalcularSiguienteFechaInforme()
			{
				var dia;
				var mes;
				var ano;
				// Verificar que haya una fecha con que trabajar:
				if (document.getElementById("pos14").value == '')
				{
					return;
				}
				else
				{
					dia = document.getElementById("pos14").value.substring(0,2);
					mes = document.getElementById("pos14").value.substring(3,5);
					ano = document.getElementById("pos14").value.substring(6,10);
//					alert(dia + ' ' + mes + ' ' + ano)
				}
				// Crear un objeto tipo date:
				ff = new Date(ano, mes-1, dia);
				// Sumar meses:
				// CALCULA LA FECHA FINAL EN CASO DE SELECCIONAR INFORME SEMESTRAL
				if (document.getElementById("pos10_6").checked)
				{
					ff.setMonth(ff.getMonth() + 6);
//					alert(ff.setMonth);
				}
				// CALCULA LA FECHA FINAL EN CASO DE SELECCIONAR INFORME ANUAL
				if (document.getElementById("pos10_12").checked)
				{
					if (('' + ff.getYear()).length < 4) aa = ff.getYear() + 1900; else aa = ff.getYear();
					ff.setYear(aa + 1);
//					alert(ff.setYear);
				}
				// CALCULA LA FECHA FINAL EN CASO DE SELECCIONAR INFORME POR RENUNCIA
				if (document.getElementById("pos10_14").checked)
				{
					//alert('RENUNCIA');
					if (document.getElementById("fecha_baja_renuncia").value == 0)
					{
						alert('NO SE ENCONTRO MOVIMIENTO O SOLICITUD DE BAJA (FT-CTIC-14) CAPTURADA Y EN STATUS DE "ENVIADA". EN CASO DE TENER LA SOLICITUD CON STATUS "EN CAPTURA", DÉ "ENVIAR" SOLICITUD. DE NO TENER LA SOLICITUD DE BAJA CAPTURADA SE DEBE REGISTRAR PRIMERO Y ENVIARLA. POSTERIORMENTE CAPTURE NUEVAMENTE SU SOLICITUD DE INFORME');
						document.getElementById("pos15").value = 'ERROR';
						return;
					}
					else
					{
						dia = document.getElementById("fecha_baja_renuncia").value.substring(0,2);
						mes = document.getElementById("fecha_baja_renuncia").value.substring(3,5);
						ano = document.getElementById("fecha_baja_renuncia").value.substring(6,10);
						ff = new Date(ano, mes-1, dia);
					}
				}
				if (document.getElementById("pos10_24").checked)
				{
					ff.setMonth(ff.getMonth() + 24);
//					alert(ff.setMonth);
				}				
				// Restar un día a la fecha obtenida:
				ff.setDate(ff.getDate() - 1);


				// Actualizar el siguiente campo:
				document.getElementById("pos15").value = dateFormat(ff);
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
						<!-- Datos debe ingresar -->
                        <cfoutput>
                            <table border="0" class="cuadrosFormularios">
                                <!-- Periodo de la beca -->
                                <tr>
                                    <td width="20%"><span class="Sans9GrNe">#ctMovimiento.mov_pos21# <cfif #tbMovimientosBecas.mov_clave# EQ 38>beca<cfelse>renovación de beca</cfif></span></td>
                                    <td width="80%">
                                        <!-- Fechas de beca -->
                                        <span class="Sans9Gr">#FechaCompleta(tbMovimientosBecas.mov_fecha_inicio)#&nbsp;</span>
                                        <span class="Sans9GrNe">#ctMovimiento.mov_pos22#</span>
                                        <span class="Sans9Gr">#FechaCompleta(tbMovimientosBecas.mov_fecha_final)#</span>
                                        <cfinput name='pos12' id='pos12' type='hidden' value='#tbMovimientosBecas.sol_id#'>
                                    </td>
                                </tr>
                                <!-- Periodo a reportar -->
                                <tr>
                                    <td width="20%"><span class="Sans9GrNe">#ctMovimiento.mov_pos13#</span></td>
                                    <td width="80%">
                                        <!--- YA NO SE REPORTA INFORME SEMESTRAL (02/06/2022)
										<cfinput name="pos10" id="pos10_6" type="radio" value="6" checked="#Iif(vCampoPos10 EQ "6",DE("yes"),DE("no"))#" disabled='#vActivaCampos#' onClick="CalcularSiguienteFechaInforme()"><span class="Sans9Gr">Semestral</span>
                                        --->
										<cfinput name="pos10" id="pos10_12" type="radio" value="12" checked="#Iif(vCampoPos10 EQ "12",DE("yes"),DE("no"))#" disabled='#vActivaCampos#' onClick="CalcularSiguienteFechaInforme()"><span class="Sans9Gr">Anual </span>
										<cfinput name="pos10" id="pos10_24" type="radio" value="24" checked="#Iif(vCampoPos10 EQ "24",DE("yes"),DE("no"))#" disabled='#vActivaCampos#' onClick="CalcularSiguienteFechaInforme()"><span class="Sans9Gr">Informe final</span>
										<cfinput name="pos10" id="pos10_14" type="radio" value="14" checked="#Iif(vCampoPos10 EQ "14",DE("yes"),DE("no"))#" disabled='#vActivaCampos#' onClick="CalcularSiguienteFechaInforme()"><span class="Sans9Gr">Renuncia </span>                                            
										<!-- Agrega la información de bajas por renuncia en caso de que se requiera -->
										<cfinput name="fecha_baja_renuncia" id="fecha_baja_renuncia" type="hidden" value="#vFechaBajaRenuncia#">
                                    </td>
                                </tr>
                                <!-- Periodo a reportar -->
                                <tr>
                                    <td width="20%"></td>
                                    <td width="80%">
                                        <!-- Fechas -->
                                        <span class="Sans9Gr">#ctMovimiento.mov_pos14#</span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos14)#&nbsp;</span>
                                        <cfelse>
                                            <cfinput name="pos14" type="text" class="datos" id="pos14" value="#vCampoPos14#" size="10" maxlength="10" disabled='#vActivaCampos#' onblur="CalcularSiguienteFecha();" onkeypress="return MascaraEntrada(event, '99/99/9999');">
                                        </cfif>
                                        <span class="Sans9Gr">#ctMovimiento.mov_pos15#&nbsp;</span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos15)#</span>
                                        <cfelse>
                                            <cfinput name="pos15" type="text" class="datos" id="pos15" value="#vCampoPos15#" size="10" maxlength="10" disabled>
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
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos30#</span></td>
                                    <td>
                                        <div align="center" class="Sans9GrNe">
                                            <cfinput name="pos30" type="radio" value="Si" checked="#Iif(vCampoPos30 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>S&iacute;&nbsp;
                                            <cfinput name="pos30" type="radio" value="No" checked="#Iif(vCampoPos30 EQ "No",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>No
                                        </div>
                                    </td>
                                    <!-- Se anexa -->
                                    <td>
                                        <div align="center">
                                            <cfinput name="pos31" type="checkbox" id="pos29" value="Si" checked="#Iif(vCampoPos31 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>
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
                                <!-- Comentarios y aprobación del asesor -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos28#</span></td>
                                    <td><div align="center"><cfinput name="pos28" type="checkbox" id="pos28" value="Si" checked="#Iif(vCampoPos28 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Informe de actividades -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos34#</span></td>
                                    <td><div align="center"><cfinput name="pos34" type="checkbox" id="pos34" value="Si" checked="#Iif(vCampoPos34 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <tr>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                </tr>
                                <tr>
                                    <td colspan="2"><span class="Sans9Gr">* Reglas de Operación: V Especificaciones de la beca. De las obligaciones c)</span></td>
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
