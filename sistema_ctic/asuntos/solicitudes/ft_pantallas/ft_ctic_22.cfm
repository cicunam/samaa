<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 21/04/2009 --->
<!--- FECHA ÚLTIMA MOD.: 23/04/2009 --->
<!--- FT-CTIC-22.-Diferición de año sabático --->

<!--- Incluir los siguientes archivos --->
<cfif #vTipoComando# EQ 'IMPRIME_EJEMPLO'>
	<cfinclude template="ft_campos_blanco.cfm"> <!---PERIMITE IMPRIMIR LA FT EN BLANCO --->
	<cfset vTipoComando = 'IMPRIME'>
<cfelse>
	<cfinclude template="ft_campos.cfm">
</cfif>

<!--- Obtener último año o semestre sabático disfrutado --->
<cfquery name="tbMovimientosTemp" datasource="#vOrigenDatosSAMAA#">
	<!--- SELECT TOP 1 * ---> <!--- HAY UN CASO O VARIOS DONDE EL SABÁTICO ES POR MENOS DE SEIS MESES --->
	SELECT DATEDIFF(day, mov_fecha_inicio, mov_fecha_final) AS vDiasSabatico, *
	FROM (movimientos AS T1
	LEFT JOIN movimientos_asunto AS T2 ON T1.sol_id = T2.sol_id)
	LEFT JOIN catalogo_decision AS C1 ON T2.dec_clave = C1.dec_clave
	WHERE acd_id = #vIdAcad#
	AND (mov_clave = 21 OR mov_clave = 30)
	AND asu_reunion = 'CTIC'
	AND dec_super = 'AP' <!--- Asuntos aprobados --->
    AND (mov_cancelado IS NULL OR mov_cancelado = 0) <!--- 31/03/2017 SE HIZO CAMBIO DE CÓDIGO PARA IDENTIFICAR BIEN LOS ASUNTOS NO CANCELADOS --->
	ORDER BY mov_fecha_inicio DESC
</cfquery>

<!--- SE AGREGÓ ESTES QUERY DE QUERY PARA PODER ELIMINAR LOS SABÁTICOS MENORES A 180 DÍAS --->
<cfquery name="tbMovimientos" dbtype="query">
	SELECT *
	FROM tbMovimientosTemp
<!--- 	WHERE vDiasSabatico > 179 --->
</cfquery>

<!--- Asignar valores a las fechas del último periodo gozado --->
<cfif #vCampoPos21# EQ ''>
	<cfset vCampoPos21='#LsDateFormat(tbMovimientos.mov_fecha_inicio,'dd/mm/yyyy')#'>
</cfif>
<cfif #vCampoPos22# EQ ''>
	<cfset vCampoPos22='#LsDateFormat(tbMovimientos.mov_fecha_final,'dd/mm/yyyy')#'>
</cfif>

<!---
<!--- Si hay texto en el campo pos12 activar la casilla de verificación vCargoNombramiento --->
<cfif Len(Trim(#vCampoPos12#)) GT 0>
	<cfset vCampoPos10 = 3>
<cfelse>
	<cfset vCampoPos10 = 0>
</cfif>
--->

<html>
	<head>
		<!-- INCLUDE que agrega parte del contenido del encabezado -->
		<cfinclude template="ft_include_head_comun.cfm">
		<!-- JAVA SCRIT de uso local -->
		<script type="text/javascript">
			// Actualizar el formulario según las selecciones dle usuario:
			function fActualizar()
			{
				if (document.getElementById('pos10').checked)
				{
					document.getElementById('pos12_row').style.display = '';
					document.getElementById('pos15_txt').style.display = 'none';
					document.getElementById('pos15').style.display = 'none';
					document.getElementById('pos15').value = '';
				}
				else
				{
					document.getElementById('pos12_row').style.display = 'none';
					document.getElementById('pos15_txt').style.display = '';
					document.getElementById('pos15').style.display = '';
					document.getElementById('pos12').value = '';
				}
			}
			// Validación de los datos ingresados por el usuario:
			function fValidaCamposFt()
			{
				var vMensaje = '';
				fLimpiaValida();
				vMensaje += fValidaFecha('pos14','A DIFERIR');
				if (document.getElementById('pos10').checked)
				{
					vMensaje += fValidaCampoLleno('pos12','CARGO');
				}
				else
				{
					vMensaje += fValidaFecha('pos15','NUEVA');
					vMensaje +=  fValidaDifericion('pos14', 'pos15', 2);
				}
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
                                <!-- Fecha del último periodo sabático (obtenido del sistema) -->
                                <tr>
                                    <td colspan="2">
                                        <span class="Sans9GrNe">#ctMovimiento.mov_pos21#&nbsp;</span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos21)#</span>
                                        <cfelse>
                                            <cfinput name="pos21" id="pos21" type="text" class="datos" size="10" maxlength="10" value="#vCampoPos21#" disabled>
                                        </cfif>
                                        <span class="Sans9Gr">#ctMovimiento.mov_pos22#</span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos22)#</span>
                                        <cfelse>
                                            <cfinput name="pos22" id="pos22" type="text" class="datos" size="10" maxlength="10" value="#vCampoPos22#" disabled>
                                        </cfif>
                                    </td>
                                </tr>
                            </table>
						</cfoutput>
						<!-- Solicita diferir del-al-->
                        <cfoutput>
                            <table border="0" class="cuadrosFormularios">
                                <!-- Solicita diferir para ocuper un cargo o nombramiento -->
                                <tr>
                                    <td colspan="2">
                                        <span class="Sans9GrNe">Solicita diferir para ocupar un cargo/nombramiento&nbsp;</span>
                                        <cfinput name="pos10" id="pos10" type="checkbox" value="3" checked="#Iif(vCampoPos10 EQ "3",DE("yes"),DE("no"))#" disabled='#vActivaCampos#' onclick="fActualizar();">
                                    </td>
                                </tr>
                                <!-- Diferición de la fecha, ala fecha -->
                                <tr>
                                    <td colspan="2">
                                        <span class="Sans9GrNe">#ctMovimiento.mov_pos14#&nbsp;</span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos14)#</span>
                                        <cfelse>
                                            <cfinput name="pos14" type="text" class="datos" id="pos14" size="10" maxlength="10" value="#vCampoPos14#" disabled='#vActivaCampos#' onkeypress="return MascaraEntrada(event, '99/99/9999');">
                                        </cfif>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <cfif #vCampoPos10# IS NOT 3>
                                                <span class="Sans9GrNe" id="pos15_txt">#ctMovimiento.mov_pos15#</span>
                                                <span class="Sans9Gr">#FechaCompleta(vCampoPos15)#</span>
                                            </cfif>
                                        <cfelse>
                                            <span class="Sans9GrNe" id="pos15_txt">#ctMovimiento.mov_pos15#</span>
                                            <cfinput name="pos15" type="text" class="datos" id="pos15" size="10" maxlength="10" value="#vCampopos15#" disabled='#vActivaCampos#' onkeypress="return MascaraEntrada(event, '99/99/9999');">
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Solicita diferir para ocupar un cargo o nombramiento -->
                                <cfif #vTipoComando# IS 'IMPRIME'>
                                    <cfif #vCampoPos10# IS 3>
                                        <tr>
                                            <td colspan="2">
                                                <span class="Sans9GrNe">#ctMovimiento.mov_pos12#&nbsp;</span>
                                              <span class="Sans9Gr">#vCampoPos12#</span>
                                            </td>
                                        </tr>
                                    </cfif>
                                <cfelse>
                                    <tr id="pos12_row">
                                        <td colspan="2">
                                            <span class="Sans9GrNe">#ctMovimiento.mov_pos12#&nbsp;</span>
                                            <cfinput name="pos12" type="text" class="datos" id="pos12" size="50" maxlength="254" value="#vCampoPos12#" disabled='#vActivaCampos#'>
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
                                    <td width="20%"> <div align="center" class="Sans10NeNe">Aprobatoria</div></td>
                                    <td width="15%"> <div align="center" class="Sans10NeNe">Se anexa</div></td>
                                </tr>
                                <!-- Opición del consejo interno -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos26#</span></td>
                                    <td>
                                        <!-- Si/no -->
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
                                <!-- Encabezados -->
                                <tr bgcolor="##CCCCCC">
                                    <td width="85%"></td>
                                    <td width="15%"><div align="center" class="Sans10NeNe">Se anexa</div></td>
                                </tr>
                                <!-- Carta del director -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos29#</span></td>
                                    <td><div align="center"><cfinput name="pos29" type="checkbox" id="pos29" value="Si" checked="#Iif(vCampoPos29 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Carta del interesado -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos32#</span></td>
                                    <td><div align="center"><cfinput name="pos32" type="checkbox" id="pos32" value="Si" checked="#Iif(vCampoPos32 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
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
