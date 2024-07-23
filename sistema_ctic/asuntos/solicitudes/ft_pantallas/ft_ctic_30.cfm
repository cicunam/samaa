<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA: 21/04/2009 --->
<!--- FECHA ÚLTIMA MOD.: 24/06/2016 --->
<!--- FT-CTIC-30.-Año o semestre sabático con beca de DGAPA --->

<!--- Incluir los siguientes archivos --->
<cfif #vTipoComando# EQ 'IMPRIME_EJEMPLO'>
	<cfinclude template="ft_campos_blanco.cfm"> <!---PERIMITE IMPRIMIR LA FT EN BLANCO --->
	<cfset vTipoComando = 'IMPRIME'>
<cfelse>
	<cfinclude template="ft_campos.cfm">
</cfif>

<!--- Obtener último año o semestre sabático disfrutado --->
<cfquery name="tbMovimientos" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM (movimientos
	LEFT JOIN movimientos_asunto ON movimientos.sol_id = movimientos_asunto.sol_id)
	LEFT JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave
	WHERE acd_id = #vIdAcad#
	AND (mov_clave = 21 OR mov_clave = 30)
	AND asu_reunion = 'CTIC'
	AND dec_super = 'AP' <!--- Asuntos aprobados --->
	AND (mov_cancelado IS NULL OR  mov_cancelado = 0) <!--- Movimientos NO CANCELADOS --->
	ORDER BY mov_fecha_inicio DESC
</cfquery>

<!--- Obtener datos del catalogo de países  (CATÁLOGOS GENERALES MYSQL) --->
<cfquery name="ctPais" datasource="#vOrigenDatosCATALOGOS#">
	SELECT * FROM catalogo_paises
	ORDER BY pais_nombre
</cfquery>

<!--- Asignar valores a las fechas del último periodo gozado --->
<cfif #vCampoPos21# EQ ''>
	<cfset vCampoPos21='#LsDateFormat(tbMovimientos.mov_fecha_inicio,'dd/mm/yyyy')#'>
</cfif>
<cfif #vCampoPos22# EQ ''>
	<cfset vCampoPos22='#LsDateFormat(tbMovimientos.mov_fecha_final,'dd/mm/yyyy')#'>
</cfif>

<html>
	<head>
		<!-- INCLUDE que agrega parte del contenido del encabezado -->
		<cfinclude template="ft_include_head_comun.cfm">
		<!-- JAVA SCRIT de uso local -->
		<script type="text/javascript">
			// Actualizar el formulario según las opciones seleccionadas:
			function fActualizar()
			{
				// Calcular fecha de término del movimiento:
				if (document.getElementById('pos13_1').checked)
				{
					document.getElementById('pos15').value = CalcularSiguienteFecha2("pos14", 1, 0, 0);
				}
				else if (document.getElementById('pos13_2').checked)
				{
					document.getElementById('pos15').value = CalcularSiguienteFecha2("pos14", 0, 6, 0);
				}
				// Cargar los destinos:
				// fAgregarDestino('CONSULTA', 0); ELIMINAR, ES REMPLAZADO POR fListaDestino()
				fListaDestino();
			}

			// Validación de los datos ingresados por el usuario:
			function fValidaCamposFt()
			{
				var vMensaje = '';
				fLimpiaValida();
				vMensaje += document.getElementById('pos13_1').checked || document.getElementById('pos13_2').checked ? '' : 'Campo: TIPO DE PERIODO debe seleccionar una opción.\n';
				vMensaje += fValidaFecha('pos14','INICIO');
				vMensaje += fValidaCampoLleno('memo1','LABOR');
				vMensaje += fValidaDestino();
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
	<body onLoad="fActualizar();">
		<!--- INCLUDE Cintillo con nombre y número de forma telegrámica / INCLUDE que contiene FORM para abrir archivo PDF (05/04/2019) --->
        <cfinclude template="ft_include_cintillo.cfm">
		<!--- FORMULARIO forma telegrámica --->
		<cfform name="formFt" id="formFt" enctype="multipart/form-data" action="#vRutaPagSig#">
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
                                <!-- Año, senestre, período -->
                                <tr>
                                    <td width="20%"><span class="Sans9GrNe">#ctMovimiento.mov_pos13#</span></td>
                                    <td width="80%">
                                        <cfinput type="radio" name="pos13" id="pos13_1" value="A" checked="#Iif(vCampoPos13 EQ 'A',DE("yes"),DE("no"))#" disabled='#vActivaCampos#' onchange="fActualizar();">
                                        <span class="Sans9Gr">A&ntilde;o&nbsp;</span>
                                        <cfinput type="radio" name="pos13" id="pos13_2" value="S"  checked="#Iif(vCampoPos13 EQ 'S',DE("yes"),DE("no"))#" disabled='#vActivaCampos#' onchange="fActualizar();">
                                        <span class="Sans9Gr">Semestre</span>
                                    </td>
                                </tr>
                                <!-- Fecha de último periodo tomado -->
                                <tr>
                                    <td colspan="2">
                                        <span class="Sans9GrNe">#ctMovimiento.mov_pos21#&nbsp;</span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos21)#</span>
                                        <cfelse>
                                            <cfinput name="pos21" type="text" class="datos" size="10" maxlength="10" id="pos21" value="#vCampoPos21#" disabled>
                                        </cfif>
                                        <span class="Sans9Gr">#ctMovimiento.mov_pos22# </span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos22)#</span>
                                        <cfelse>
                                            <cfinput name="pos22" type="text" class="datos" size="10" maxlength="10" id="pos22" value="#vCampoPos22#" disabled>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Fecha del periodo que solicita -->
                                <tr>
                                    <td colspan="2">
                                        <span class="Sans9GrNe">#ctMovimiento.mov_pos14#&nbsp;</span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos14)#</span>
                                        <cfelse>
                                            <cfinput name="pos14" type="text" class="datos" id="pos14" size="10" maxlength="10" value="#vCampoPos14#" disabled='#vActivaCampos#' onchange="fActualizar();" onkeypress="return MascaraEntrada(event, '99/99/9999');">
                                        </cfif>
                                        <span class="Sans9Gr">#ctMovimiento.mov_pos15# </span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos15)#</span>
                                        <cfelse>
                                            <cfinput name="pos15" type="text" class="datos" id="pos15" size="10" maxlength="10" value="#vCampoPos15#" disabled>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Labor que desempañará -->
                                <tr>
                                    <td colspan="2"><span class="Sans9GrNe">#ctMovimiento.mov_memo1#</span><br></td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoMemo1#</span>
                                        <cfelse>
                                            <cftextarea name="memo1" cols="80" rows="5" class="datos100" id="memo1" value="#vCampoMemo1#" disabled='#vActivaCampos#'></cftextarea>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Erogaciones -->
                                <tr>
                                    <td colspan="2">
                                        <span class="Sans9GrNe">#ctMovimiento.mov_pos19#&nbsp;</span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#NumberFormat(vCampoPos19,"_$_-.__")#</span>
                                        <cfelse>
                                            <cfinput name="pos19" type="text" class="datos" id="pos19" size="10" maxlength="10" value="#vCampoPos19#" disabled='#vActivaCampos#' onkeypress="return MascaraEntrada(event, '999999');">
                                        </cfif>
                                    </td>
                                </tr>
                            </table>
                        </cfoutput>

                         <!-- INCLUDE Instituciones donde realizó su período sabático -->
                        <cfinclude template="ft_include_destinos.cfm">

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
                                    <td width="15%"> <div align="center" class="Sans10NeNe">Se anexa</div></td>
                                </tr>
                                <!-- Carta del director (con una breve semblanza del Investigador anfitrión y descripción académica de la Institución) -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos29#</span></td>
                                    <td><div align="center"><cfinput name="pos29" type="checkbox" id="pos29" value="Si" checked="#Iif(vCampoPos29 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Solicitud del interesado 12/02/2018 cambió de CARTA a SILICITUD -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos32#</span></td>
                                    <td><div align="center"><cfinput name="pos32" type="checkbox" id="pos32" value="Si" checked="#Iif(vCampoPos32 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- En caso de tener proyecto de investigación con financiamiento del CONACyT (ALTA: 12/02/2018) -->
								<cfif #vTipoComando# EQ 'NUEVO'>
	                                <cfset vcomparafechas =  DateDiff('d',CreateDate(2018,2,12),#vFechaHoy#)>
								<cfelse>
									<cfset vcomparafechas =  DateDiff('d',CreateDate(2018,2,12),#tbSolicitudes.cap_fecha_crea#)>
                                </cfif>
								<cfif #vcomparafechas# GT 0>                                
                                    <tr>
                                        <td><span class="Sans9GrNe">#ctMovimiento.mov_pos31#</span></td>
                                        <td><div align="center"><cfinput name="pos31" type="checkbox" id="pos31" value="Si" checked="#Iif(vCampoPos31 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                    </tr>
								</cfif>
                                <!-- Carta de la(s) institución(es) -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos33#</span></td>
                                    <td><div align="center"><cfinput name="pos33" type="checkbox" id="pos33" value="Si" checked="#Iif(vCampoPos33 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Programa de actividades -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos34#</span></td>
                                    <td><div align="center"><cfinput name="pos34" type="checkbox" id="pos34" value="Si" checked="#Iif(vCampoPos34 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Curriculum vitae de la persona con quien va a laborar -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos36#</span></td>
                                    <td><div align="center"><cfinput name="pos36" type="checkbox" id="pos36" value="Si" checked="#Iif(vCampoPos36 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Formatos de DGAPA (copia) -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos35#</span></td>
                                    <td><div align="center"><cfinput name="pos35" type="checkbox" id="pos35" value="Si" checked="#Iif(vCampoPos35 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Constancia actualizada de la situación laboral emitida por la DGP -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos37#</span></td>
                                    <td><div align="center"><cfinput name="pos37" type="checkbox" id="pos37" value="Si" checked="#Iif(vCampoPos37 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Constancias oficiales (idioma y otro(s) apoyo(s)) -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos38#</span></td>
                                    <td><div align="center"><cfinput name="pos38" type="checkbox" id="pos38" value="Si" checked="#Iif(vCampoPos38 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Copias de acta de nacimiento y del último grado obtenido -->
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
