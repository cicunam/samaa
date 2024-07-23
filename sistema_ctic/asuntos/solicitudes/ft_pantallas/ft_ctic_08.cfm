<!--- CREADO: ARAM PICHARDO--->
<!--- EDITO: ARAM PICHARDO--->
<!--- FECHA CREA: 27/05/2009--->
<!--- FECHA ÚLTIMA MOD.: 18/07/2024 --->
<!--- FT-CTIC-8.-Concurso de oposición para Definitividad o concurso cerrado (Investigador)--->

<!--- Incluir los siguientes archivos --->
<cfif #vTipoComando# EQ 'IMPRIME_EJEMPLO'>
	<cfinclude template="ft_campos_blanco.cfm"> <!---PERIMITE IMPRIMIR LA FT EN BLANCO --->
	<cfset vTipoComando = 'IMPRIME'>
<cfelse>
	<cfinclude template="ft_campos.cfm">
</cfif>

<!--- Obtener la lista de ubicaciones de la dependencia  (CATÁLOGOS GENERALES MYSQL) --->
<cfquery name="ctUbicacion" datasource="#vOrigenDatosCATALOGOS#">
	SELECT *, CONCAT(TRIM(ubica_nombre),  ', ', TRIM(ubica_lugar)) AS ubica_completa
    FROM catalogo_dependencias_ubica
	WHERE dep_clave = '#vCampoPos1#' 
    AND ubica_status = 1
	ORDER BY ubica_clave
</cfquery>

<!--- Obtener datos del último movimiento 5, 6 o 25 --->
<cfquery name="tbMovimientoUltimo" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM (movimientos
	LEFT JOIN movimientos_asunto ON movimientos.sol_id = movimientos_asunto.sol_id)
	LEFT JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave
	WHERE acd_id = #vIdAcad#
	AND (mov_clave = 5 OR mov_clave = 6 OR mov_clave = 25)
	AND asu_reunion = 'CTIC'
	AND dec_super = 'AP' <!--- Asuntos aprobados --->
	ORDER BY mov_fecha_inicio DESC
</cfquery>

<!--- Obtener registros con la última categoría y nivel (obtenida antes) --->
<cfquery name="tbMovimientoCcn" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM (movimientos
	LEFT JOIN movimientos_asunto ON movimientos.sol_id = movimientos_asunto.sol_id)
	LEFT JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave
	WHERE acd_id = #vIdAcad#
	AND mov_cn_clave = '#tbMovimientoUltimo.mov_cn_clave#'
	AND asu_reunion = 'CTIC'
	AND (mov_clave = 5 OR mov_clave = 6 OR mov_clave = 25)
	ORDER BY mov_fecha_inicio DESC
</cfquery>

<cfif #tbMovimientoCcn.RecordCount# GT 0>
	<cfset vFechaHoy = Now()>
    <cfset vFechaInicio = #tbMovimientoCcn.mov_fecha_inicio#>
    <cfset vFechaFinal = #tbMovimientoCcn.mov_fecha_final#>
    <cfset vCuentaAnios = #datediff('d',tbMovimientoCcn.mov_fecha_inicio,vFechaHoy)#>
    <cfloop query="tbMovimientoCcn" startrow="2">
        <cfif #mov_fecha_final# EQ #vFechaInicio# - 1>
            <cfset vCuentaAnios = #vCuentaAnios# + #datediff('d',mov_fecha_inicio,mov_fecha_final + 1)#>
        <cfelseif #vFechaInicio# GT #mov_fecha_inicio# AND #vFechaInicio# LT #mov_fecha_final# + 1>
            <cfset vCuentaAnios = #vCuentaAnios# + #datediff('d',mov_fecha_inicio,vFechaInicio)#>
        <cfelse>
            <cfbreak>
        </cfif>
        <cfset vFechaInicio = #mov_fecha_inicio#>
        <cfset vFechaFinal = #mov_fecha_final#>
    </cfloop>
</cfif>

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
				vMensaje += fValidaCampoLleno('pos1_u','UBICACIÓN');
				vMensaje += fValidaFecha('pos14','DEFINITIVIDAD A PARTIR DEL');
//				vMensaje += document.getElementById('vAntigAcadAnios').value < 3 ? 'El académico no cumple con el requisito de tener como mínimo 3 años de antigüedad.\n': '';
				vMensaje += document.getElementById('vNoAniosCcnDef').value < 3 ? 'El académico no cumple con el requisito de tener como mínimo 3 años de antigüedad en esta categoría y nivel.\n': '';
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
	<body onLoad="ObtenerCcnDef();">
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
<!--- ELIMINA XXXXXXXXXXXXXX
                        <!-- Campos ocultos -->
                        <cfinput name="vFt" type="hidden" id="vFt" value="#vFt#">
                        <cfinput name="vIdAcad" type="hidden" id="vIdAcad" value="#vIdAcad#">
                        <cfinput name="vTipoComando" type="hidden" id="vTipoComando">
                        <cfinput name="vIdSol" type="hidden" value="#vIdSol#">
                        <cfinput name="vSolStatus" type="hidden" value="#vSolStatus#">
--->
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
                                <!-- Solicita definitividad a partir de -->
                                <tr>
                                    <td>
                                        <span class="Sans9GrNe">#ctMovimiento.mov_pos14#&nbsp;</span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos14)#</span>
                                        <cfelse>
                                            <cfinput name="pos14" id="pos14" type="text" class="datos" size="10" maxlength="10" disabled='#vActivaCampos#' value="#vCampoPos14#" onkeypress="return MascaraEntrada(event, '99/99/9999');" onBlur="ObtenerCcnDef();">
                                        </cfif>
                                        <div id="ccnactual_dynamic"><!-- AJAX: Años de actividad ininterrumpida --></div>
                                    </td>
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
                                    <td width="20%" class="Sans9GrNe"> <div align="center">Aprobatorio</div></td>
                                    <td width="15%" class="Sans9GrNe"> <div align="center">Se anexa</div></td>
                                </tr>
                                <!-- Comisión dictaminadora -->
                                <tr>
                                    <td class="Sans9GrNe">#ctMovimiento.mov_pos30#</td>
                                    <td>
                                        <div align="center">
                                            <span class="Sans9GrNe">
                                                <cfinput name="pos30" id="pos30_s" type="radio" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos30 EQ 'Si',DE("yes"),DE("no"))#">S&iacute;&nbsp;
                                                <cfinput name="pos30" id="pos30_n" type="radio" value="No" disabled='#vActivaCampos#' checked="#Iif(vCampoPos30 EQ 'No',DE("yes"),DE("no"))#">No
                                            </span>
                                        </div>
                                    </td>
                                    <td>
                                        <div align="center">
                                            <span class="Sans9GrNe">
                                                <cfinput name="pos31" type="checkbox" id="pos31" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos31 EQ 'Si',DE("yes"),DE("no"))#">
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                                <!-- Opinión del consejo interno -->
                                <tr>
                                    <td class="Sans9GrNe">#ctMovimiento.mov_pos26#</td>
                                    <td>
                                        <div align="center">
                                            <span class="Sans9GrNe">
                                                <cfinput name="pos26" type="radio" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos26 EQ 'Si',DE("yes"),DE("no"))#">S&iacute;&nbsp;
                                                <cfinput name="pos26" type="radio" value="No" disabled='#vActivaCampos#' checked="#Iif(vCampoPos26 EQ 'No',DE("yes"),DE("no"))#">No
                                            </span>
                                        </div>
                                    </td>
                                    <td>
                                        <div align="center">
                                            <span class="Sans9GrNe">
                                                <cfinput name="pos27" type="checkbox" id="pos27" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos27 EQ 'Si',DE("yes"),DE("no"))#">
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                                <!-- Opinión del director -->
                                <tr>
                                    <td class="Sans9GrNe">#ctMovimiento.mov_pos28#</td>
                                    <td>
                                        <div align="center">
                                            <span class="Sans9GrNe">
                                                <cfinput name="pos28" type="radio" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos28 EQ 'Si',DE("yes"),DE("no"))#">S&iacute;&nbsp;
                                                <cfinput name="pos28" type="radio" value="No" disabled='#vActivaCampos#' checked="#Iif(vCampoPos28 EQ 'No',DE("yes"),DE("no"))#">No
                                            </span>
                                        </div>
                                    </td>
                                    <td>
                                        <div align="center">
                                            <span class="Sans9GrNe">
                                                <cfinput name="pos29" type="checkbox" id="pos29" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos29 EQ 'Si',DE("yes"),DE("no"))#">
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </cfoutput>
--->
						<!-- Documentación -->
						<!--- Llamado a INCLUDE general de los anexos requeridos en la FT 18/07/2024 --->
						<cfinclude template="ft_include_anexoAnexos.cfm">
<!---
                        <cfoutput>
                            <table border="0" class="cuadrosFormularios">
                                <tr bgcolor="##CCCCCC">
                                    <td width="85%"></td>
                                    <td width="15%"> <div align="center" class="Sans9GrNe">Se anexa</div></td>
                                </tr>
                                <!-- Carta razonada del interesado -->
                                <tr>
                                    <td class="Sans9GrNe">#ctMovimiento.mov_pos32#</td>
                                    <td>
                                        <div align="center">
                                            <span class="Sans9GrNe">
                                                <cfinput name="pos32" type="checkbox" id="pos32" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos32 EQ 'Si',DE("yes"),DE("no"))#">
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                                <!-- Informe y programa de actividades -->
                                <tr>
                                    <td class="Sans9GrNe">#ctMovimiento.mov_pos34#</td>
                                    <td>
                                        <div align="center">
                                            <span class="Sans9GrNe">
                                                <cfinput name="pos34" type="checkbox" id="pos34" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos34 EQ 'Si',DE("yes"),DE("no"))#">
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                                <!-- Curriculum vitae -->
                                <tr>
                                    <td class="Sans9GrNe">#ctMovimiento.mov_pos36#</td>
                                    <td>
                                        <div align="center">
                                            <span class="Sans9GrNe">
                                                <cfinput name="pos36" type="checkbox" id="pos36" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos36 EQ 'Si',DE("yes"),DE("no"))#">
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                                <!-- Trabajos publicados -->
                                <tr>
                                    <td class="Sans9GrNe">#ctMovimiento.mov_pos39#</td>
                                    <td>
                                        <div align="center">
                                            <span class="Sans9GrNe">
                                                <cfinput name="pos39" type="checkbox" id="pos392" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos39 EQ 'Si',DE("yes"),DE("no"))#">
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
