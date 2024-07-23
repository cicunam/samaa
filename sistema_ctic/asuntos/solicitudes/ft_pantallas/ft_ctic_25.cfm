<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 05/06/2009--->
<!--- FECHA ULTIMA MOD.: 20/01/2023 --->
<!--- FT-CTIC-25.-Contrato bajo condiciones similares al anterior --->

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

<!--- Obtener los datos del COA --->
<cfquery name="tbMovimientosCOA" datasource="#vOrigenDatosSAMAA#">
	SELECT TOP 1 mov_id, mov_fecha_inicio
	FROM (movimientos
	LEFT JOIN movimientos_asunto ON movimientos.sol_id = movimientos_asunto.sol_id)
	LEFT JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave
	WHERE acd_id = #vIdAcad#
	AND (mov_clave = 5 OR mov_clave = 17 OR mov_clave = 35)
	AND asu_reunion = 'CTIC'
	AND dec_super = 'AP' <!--- Asuntos aprobados --->
	ORDER BY mov_fecha_inicio DESC
</cfquery>

<!--- Obtener los datos de la última promoción --->
<cfquery name="tbMovimientosPRO" datasource="#vOrigenDatosSAMAA#">
	SELECT TOP 1 mov_fecha_inicio
	FROM (movimientos
	LEFT JOIN movimientos_asunto ON movimientos.sol_id = movimientos_asunto.sol_id)
	LEFT JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave
	WHERE acd_id = #vIdAcad#
	AND (mov_clave = 9 OR mov_clave = 10)
	AND mov_cn_clave = '#vCampoPos3#' <!--- CAMBIO EN LA SELECCIÓN DE EL VALOR DE LA CATEGORÍA Y NIVEL DE tbMovimientoCOA A EL VALOR DE LA TABLA academicos  12/02/2016--->
	AND asu_reunion = 'CTIC'
	AND dec_super = 'AP' <!--- Asuntos aprobados --->
	ORDER BY mov_fecha_inicio DESC
</cfquery>

<!--- Obtener el número de renovación correspondiente --->
<cfquery name="tbMovimientosREN" datasource="#vOrigenDatosSAMAA#">
	SELECT *
	FROM (movimientos
	LEFT JOIN movimientos_asunto ON movimientos.sol_id = movimientos_asunto.sol_id)
	LEFT JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave
	WHERE acd_id = #vIdAcad#
	AND mov_clave = 25
	<cfif tbMovimientosPRO.RecordCount GT 0> AND mov_fecha_inicio > '#LsdateFormat(tbMovimientosPRO.mov_fecha_inicio,'dd/mm/yyyy')#'
	<cfelseif tbMovimientosPRO.RecordCount EQ 0> AND mov_fecha_inicio > '#LsdateFormat(tbMovimientosCOA.mov_fecha_inicio,'dd/mm/yyyy')#'
	</cfif>
	AND mov_cn_clave = '#vCampoPos8#' <!--- SE AGREGÓ ESTE FILTRO PORQUE HACIA EL CONTEO DE LAS RENOVACIONES EN LA CCN ACTUAL Y NO LAS REONOVACIONES DE CUALQUIER CCN 12/02/2016 --->
	AND asu_reunion = 'CTIC'
	AND dec_super = 'AP' <!--- Asuntos aprobados --->
	ORDER BY mov_fecha_inicio DESC
</cfquery>

<!--- Registrar el movimiento anterior (por compatibilidad con los datos históricos) --->
<cfif #vCampoPos12# EQ ''>
	<cfif #tbMovimientosREN.RecordCount# GT 0>
		<cfset vCampoPos12=#tbMovimientosREN.mov_id#>
	<cfelseif #tbMovimientosCOA.RecordCount# GT 0>
		<cfset vCampoPos12=#tbMovimientosCOA.mov_id#>
	</cfif>
</cfif>

<!--- Asignar la fecha en que ganó el COA --->
<cfif #vCampoPos21# EQ ''>
	<cfset vCampoPos21=#LsdateFormat(tbMovimientosCOA.mov_fecha_inicio,'dd/mm/yyyy')#>
</cfif>

<!--- Asignar la fecha de la última promoción --->
<cfif #vCampoPos22# EQ ''>
	<cfif #tbMovimientosPRO.RecordCount# GT 0>
		<cfset vCampoPos22=#LsdateFormat(tbMovimientosPRO.mov_fecha_inicio,'dd/mm/yyyy')#>
	<cfelse>
		<cfset vCampoPos22 = ''>
	</cfif>
</cfif>

<!--- Asignar la fecha de inicio del siguiente contrato --->
<cfif #vCampoPos14# EQ ''>
	<cfif tbMovimientosPRO.RecordCount GT 0>
		<cfif tbMovimientosREN.RecordCount GT 0>
			<cfset vCampoPos14=#LsdateFormat(DateAdd("yyyy", 1, tbMovimientosREN.mov_fecha_inicio),'dd/mm/yyyy')#>
		<cfelse>
			<cfset vCampoPos14=#LsdateFormat(DateAdd("yyyy", 1, tbMovimientosPRO.mov_fecha_inicio),'dd/mm/yyyy')#>
		</cfif>
	<cfelseif tbMovimientosCOA.RecordCount GT 0>
		<cfif tbMovimientosREN.RecordCount GT 0>
			<cfset vCampoPos14=#LsdateFormat(DateAdd("yyyy", 1, tbMovimientosREN.mov_fecha_inicio),'dd/mm/yyyy')#>
		<cfelse>
			<cfset vCampoPos14=#LsdateFormat(DateAdd("yyyy", 1, tbMovimientosCOA.mov_fecha_inicio),'dd/mm/yyyy')#>
		</cfif>
	</cfif>
</cfif>
<!--- Asignar el número de renovaciones de contrato --->
<cfif #vCampoPos17# EQ ''>
	<cfset vCampoPos17=#tbMovimientosREN.RecordCount# + 1>
</cfif>
<!---    
<cfoutput>
    vCampoPos8: #vCampoPos8#<br/>
    fecha coa: #LsdateFormat(tbMovimientosCOA.mov_fecha_inicio,'dd/mm/yyyy')#<br/>
    renovaciones: #tbMovimientosREN.recordcount#<br/>
    promocion: #tbMovimientosPRO.RecordCount#
</cfoutput>
--->
<html>
	<head>
		<!-- INCLUDE que agrega parte del contenido del encabezado -->
		<cfinclude template="ft_include_head_comun.cfm">
		<!-- JAVA SCRIT de uso local -->
		<script type="text/javascript">
			// Actaukuzar el formulario:
			function fActualizar()
			{
				CalcularSiguienteFecha();
			}
			// Validar los datos ingresados por el usuario:
			function fValidaCamposFt()
			{
				var vMensaje = '';
				fLimpiaValida();
				vMensaje += fValidaCampoLleno('pos1_u','UBICACIÓN');
				vMensaje += fValidaFecha('pos14','INICIO');
				if (document.getElementById('pos22').value)
				{
					vMensaje += fValidaFechaPosterior('pos14','pos22') ? '': 'La fecha de INICIO debe ser posterior que la fecha de la última promoción.\n';
				}
				else
				{
					vMensaje += fValidaFechaPosterior('pos14','pos21') ? '': 'La fecha de INICIO debe ser posterior que la fecha en que ganó el COA.\n';
				}
				vMensaje += document.getElementById('pos12').value != '' ? '': 'No se encontró ningún contrato anterior.\n';
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
	<body onLoad="fActualizar();">
		<!--- INCLUDE Cintillo con nombre y número de forma telegrámica / INCLUDE que contiene FORM para abrir archivo PDF (05/04/2019) --->
        <cfinclude template="ft_include_cintillo.cfm">
		<!--- FORMULARIO forma telegrámica --->
		<cfform name="formFt" id="formFt" method="POST" enctype="multipart/form-data" action="#vRutaPagSig#">
            <!-- Forma telegrámica -->
            <table width="100%" border="0">
                <tr>
                    <!-- Menú lateral -->
                    <cfif #vTipoComando# IS NOT 'IMPRIME'>
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
                        <!-- Registrar el movimiento anterior (por compatibilidad con los datos históricos -->
                        <cfinput name="pos12" type="hidden" value="#vCampoPos12#">

                        <!-- Datos para ser llenados por la ST-CTIC -->
                        <cfif #Session.sTipoSistema# IS 'stctic' AND #vSolStatus# LT 3 AND #vTipoComando# IS NOT 'NUEVO' AND #vTipoComando# IS NOT 'IMPRIME'>
                            <cfinclude template="ft_control.cfm">
                        </cfif>

                        <!-- INCLUDE para visualisar Datos generales -->
                        <cfinclude template="ft_include_general.cfm">
                        <!-- INCLUDE para visualisar Información Académica -->
                        <cfinclude template="ft_include_datos_academicos.cfm">
                        <!-- Datos que deben ingresarse -->							
                        <cfoutput>
                            <table border="0" class="cuadrosFormularios">
                                <!-- Fecha en que ganó el concurso abierto -->
                                <tr>
                                    <td width="25%"><span class="Sans9GrNe">#ctMovimiento.mov_pos21# </span></td>
                                    <td width="75%">
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos21)#</span>
                                        <cfelse>
                                            <cfinput name="pos21" id="pos21" type="text" class="datos" size="10" maxlength="10" disabled value="#vCampoPos21#">
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Fecha de la última promoción -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos22# </span></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos22)#</span>
                                        <cfelse>
                                            <cfinput name="pos22" id="pos22" type="text" class="datos" size="10" maxlength="10" disabled value="#vCampoPos22#">
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Duración -->
                                <!-- Se remplazó el código original por duración año(s), mes(es) y día(s) -->
                                <tr>
                                    <td width="25%"><span class="Sans9GrNe">#ctMovimiento.mov_pos13#</span></td>
                                    <td width="75%">
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
                                            <span class="Sans9Gr">#vCampoPos13_d# #ctMovimiento.mov_pos13_d#&nbsp;</span>
                                            </span>
                                        <cfelse>
                                            <span
                                                <cfif #vCampoPos13_a# EQ 0>class="NoImprimir"</cfif>
                                            ><cfinput type="text" name="pos13_a" disabled='#vActivaCampos#' class="datos" id="pos13_a" onChange="CalcularSiguienteFecha();" value="#vCampoPos13_a#" size="1" maxlength="1" onkeypress="return MascaraEntrada(event, '9');">
                                            <span class="Sans9Gr">#ctMovimiento.mov_pos13_a#</span>
                                            </span>
                                            <span
                                                <cfif #vCampoPos13_m# EQ 0>class="NoImprimir"</cfif>
                                            ><cfinput type="text" name="pos13_m" disabled='#vActivaCampos#' class="datos" id="pos13_m" onChange="CalcularSiguienteFecha();" value="#vCampoPos13_m#" size="2" maxlength="2" onkeypress="return MascaraEntrada(event, '99');">
                                            <span class="Sans9Gr">#ctMovimiento.mov_pos13_m#</span>
                                            </span>
                                            <span
                                            <cfif #vCampoPos13_d# EQ 0>class="NoImprimir"</cfif>
                                            ><cfinput type="text" name="pos13_d" disabled='#vActivaCampos#' class="datos" id="pos13_d" onChange="CalcularSiguienteFecha();" value="#vCampoPos13_d#" size="2" maxlength="2" onkeypress="return MascaraEntrada(event, '99');">
                                            <span class="Sans9Gr">#ctMovimiento.mov_pos13_d#</span>
                                            </span>
                                        </cfif>
                                        <!-- Fechas -->
                                        <span class="Sans9Gr">#MID(ctMovimiento.mov_pos14,10,13)#</span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos14)#&nbsp;</span>
                                        <cfelse>
                                            <cfinput type="text" name="pos14" disabled='#vActivaCampos#' class="datos" id="pos14" onChange="CalcularSiguienteFecha();" value="#vCampoPos14#" size="10" maxlength="10" onkeypress="return MascaraEntrada(event, '99/99/9999');">
                                        </cfif>
                                        <span class="Sans9Gr">#ctMovimiento.mov_pos15#</span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos15)#</span>
                                        <cfelse>
                                            <cfinput onclick="pos15.value=''" name="pos15" type="text" class="datos" id="pos15" size="10" maxlength="10" disabled value="#vCampoPos15#">
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Código original hasta el 25/01/2011 -->
                                <!---
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos13#</span><br></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">1</span>
                                        <cfelse>
                                            <cfinput name="pos13_a" type="text" class="datos" id="pos13_a" size="1" maxlength="1" disabled="true" value="1">
                                        </cfif>
                                        <span class="Sans9Gr">#ctMovimiento.mov_pos13_a#&nbsp;</span>
                                        <!---
                                        <cfinput name="pos13_m" type="text" class="datos" id="pos13_m" size="2" maxlength="2" disabled="true" value="#vCampoPos13_m#">
                                        <span class="Sans9Gr">#ctMovimiento.mov_pos13_m#</span>
                                        <cfinput name="pos13_d" type="text" class="datos" id="pos13_d" size="2" maxlength="2" disabled="true"  value="#vCampoPos13_d#">
                                        <span class="Sans9Gr">#ctMovimiento.mov_pos13_d#,</span>
                                        --->
                                        <!-- Fechas -->
                                        <span class="Sans9Gr">#ctMovimiento.mov_pos14# </span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos14)#&nbsp;</span>
                                        <cfelse>
                                            <cfinput type="text" name="pos14" class="datos" id="pos14" size="10" maxlength="10" disabled='#vActivaCampos#' value="#vCampoPos14#" onChange="CalcularSiguienteFecha();" onkeypress="return MascaraEntrada(event, '99/99/9999');">
                                        </cfif>
                                        <span class="Sans9Gr">#ctMovimiento.mov_pos15# </span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos15)#</span>
                                        <cfelse>
                                            <cfinput name="pos15" id="pos15" type="text" class="datos" size="10" maxlength="10" value="#vCampoPos15#" disabled="true">
                                        </cfif>
                                    </td>
                                </tr>
                                --->
                                <!-- Número de renovación -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos17#</span></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#NumberFormat(vCampoPos17,"99")#</span>
                                        <cfelse>
                                            <cfinput name="pos17" type="text" class="datos" id="pos17" size="2" value="#LsNumberFormat(vCampoPos17, '99')#" disabled>
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
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos26#</span></td>
                                    <td>
                                        <div align="center" class="Sans9GrNe">
                                            <cfinput name="pos26" type="radio" value="Si" checked="#Iif(vCampoPos26 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>S&iacute;&nbsp;
                                            <cfinput name="pos26" type="radio" value="No" checked="#Iif(vCampoPos26 EQ "No",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>No
                                        </div>
                                    </td>
                                    <td>
                                        <div align="center">
                                            <cfinput name="pos27" type="checkbox" id="pos27" value="Si" checked="#Iif(vCampoPos27 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>
                                        </div>
                                    </td>
                                </tr>
                                <!-- Apreciación del director -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos28#</span></td>
                                    <td>
                                        <div align="center" class="Sans9GrNe">
                                            <cfinput name="pos28" type="radio" value="Si" checked="#Iif(vCampoPos28 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>S&iacute;&nbsp;
                                            <cfinput name="pos28" type="radio" value="No" checked="#Iif(vCampoPos26 EQ "No",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>No
                                        </div>
                                    </td>
                                    <td>
                                        <div align="center">
                                            <cfinput name="pos29" type="checkbox" id="pos29" value="Si" checked="#Iif(vCampoPos29 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </cfoutput>
                        <cfoutput>
                            <table border="0" class="cuadrosFormularios">
                                <!-- Encabezados -->
                                <tr bgcolor="##CCCCCC">
                                    <td width="85%"></td>
                                    <td width="15%" height="2"><div align="center" class="Sans10NeNe">Se anexa</div></td>
                                </tr>
                                <!-- Carta razonada del interesado -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos32#</span></td>
                                    <td><div align="center"><cfinput name="pos32" type="checkbox" id="pos32" value="Si" checked="#Iif(vCampoPos32 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Informe y programa de actividades (avalados para el caso de técnicos académicos) -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos34#</span></td>
                                    <td><div align="center"><cfinput name="pos34" type="checkbox" id="pos34" value="Si" checked="#Iif(vCampoPos34 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Curriculum vitae -->
                                <tr>
                                    <td class="Sans9GrNe">#ctMovimiento.mov_pos36#</td>
                                    <td><div align="center"><cfinput name="pos36" type="checkbox" id="pos36" value="Si" checked="#Iif(vCampoPos36 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Trabajos publicados (sin copias) -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos39#</span></td>
                                    <td><div align="center"><cfinput name="pos39" type="checkbox" id="pos39" value="Si" checked="#Iif(vCampoPos39 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
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
	<cfif #vTipoComando# EQ 'NUEVO' AND #vCampoPos12# EQ ''>
		alert('AVISO: No se encontró ningún contrato anterior. Si prosigue con la captura la solicitud será rechazada.');
	</cfif>
</script>
