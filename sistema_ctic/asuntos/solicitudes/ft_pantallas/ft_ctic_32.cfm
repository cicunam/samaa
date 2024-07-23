<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 20/04/2009 --->
<!--- FECHA ÚLTIMA MOD.: 19/06/2024 --->
<!--- FT-CTIC-32.-Modificación a las condiciones del año o semestre sabático --->

<!--- Incluir los siguientes archivos --->
<cfif #vTipoComando# EQ 'IMPRIME_EJEMPLO'>
	<cfinclude template="ft_campos_blanco.cfm"> <!---PERIMITE IMPRIMIR LA FT EN BLANCO --->
	<cfset vTipoComando = 'IMPRIME'>
<cfelse>
	<cfinclude template="ft_campos.cfm">
</cfif>

<!--- Precargar fecha de inicio del periodo que se va a modificar 
<cfif #vCampoPos21# EQ ''>
	<cfset vCampoPos21="#LsDateFormat(vFecSaba,'dd/mm/yyyy')#">
</cfif>
--->

<!--- Obtener información del año o semestre sabático que se va a modificar --->
<cfquery name="tbMovSabaticos" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM movimientos
	WHERE mov_id = #vMovSabId#
<!---
    acd_id = #vIdAcad#
	AND (mov_clave = 21 OR mov_clave = 30)
	AND mov_fecha_inicio = '#LsDateFormat(vCampoPos21,"dd/mm/yyyy")#'
--->	
</cfquery>
    
<!--- Determinar el tipo del último periodo sabático disfrutado --->
<cfif #tbMovSabaticos.mov_clave# EQ 21>
	<cfset vTipoBecaAnterior="SIN BECA">
<cfelseif #tbMovSabaticos.mov_clave# EQ 30>
	<cfset vTipoBecaAnterior="CON BECA">
<cfelse>
	<cfset vTipoBecaAnterior="NO HAY">
</cfif>    
    
<!--- Obtener datos del catalogo de países  (CATÁLOGOS GENERALES MYSQL) --->
<cfquery name="ctPais" datasource="#vOrigenDatosCATALOGOS#">
	SELECT * FROM catalogo_paises
	ORDER BY pais_nombre
</cfquery>

<!--- Inicializar o desglosar en campo 'pos12' en sus 4 controles checkbox --->
<cfif Find("PERIODO",#vCampoPos12#) NEQ 0>
	<cfset vCampoPos12_1="yes">
<cfelse>
	<cfset vCampoPos12_1="no">
</cfif>
<cfif Find("PROGRAMA",#vCampoPos12#) NEQ 0>
	<cfset vCampoPos12_2="yes">
<cfelse>
	<cfset vCampoPos12_2="no">
</cfif>
<cfif Find("LUGAR",#vCampoPos12#) NEQ 0>
	<cfset vCampoPos12_3="yes">
<cfelse>
	<cfset vCampoPos12_3="no">
</cfif>
<cfif Find("BECA",#vCampoPos12#) NEQ 0>
	<cfset vCampoPos12_4="yes">
<cfelse>
	<cfset vCampoPos12_4="no">
</cfif>

<!--- Precargar periodo: Año o semestre --->
<cfif #vCampoPos13# EQ ''>}
    <cfset vMovFecIni = #LsDateFormat(tbMovSabaticos.mov_fecha_inicio,'dd/mm/yyyy')#>
    <cfset vMovFecFin = #LsDateFormat(tbMovSabaticos.mov_fecha_final,'dd/mm/yyyy')#>
	<cfif DateDiff('m',#vMovFecIni#, #vMovFecFin#) GT 6>
		<cfset vCampoPos13='A'>
	<cfelse>
		<cfset vCampoPos13='S'>
	</cfif>
</cfif>
<!--- Precargar periodo: Fecha inicial --->
<cfif #vCampoPos14# EQ ''>
	<cfset vCampoPos14='#LsDateFormat(tbMovSabaticos.mov_fecha_inicio,'dd/mm/yyyy')#'>
</cfif>
<!--- Precargar periodo: Fecha final --->
<cfif #vCampoPos15# EQ ''>
	<cfset vCampoPos15='#LsDateFormat(tbMovSabaticos.mov_fecha_final,'dd/mm/yyyy')#'>
</cfif>

<!--- Precargar fecha de inicio del periodo que se va a modificar --->
<cfif #vCampoPos21# EQ ''>
	<cfset vCampoPos21='#LsDateFormat(tbMovSabaticos.mov_fecha_inicio,'dd/mm/yyyy')#'>
</cfif>

<!--- Precargar fecha de término del periodo que se va a modificar --->
<cfif #vCampoPos22# EQ ''>
	<cfset vCampoPos22='#LsDateFormat(tbMovSabaticos.mov_fecha_final,'dd/mm/yyyy')#'>
</cfif>
<!--- Precargar periodo: Programa --->
<cfif #vCampoMemo1# EQ ''>
	<cfset vCampoMemo1='#tbMovSabaticos.mov_memo_1#'>
</cfif>
<!--- Precargar instituciones --->
<!---
NOTA: POR AHORA NO SE PUEDE OBTENER ESTA INFORMACIÓN PORQUE EL LA TABLA DE MOVIMIENTOS NO TIENE REGISTRADA LA SOLICITUD ASOCIADA, Y LAS INSTITUCIONES ESTÁN ASOCIADAS A LAS SOLICITUDES.
<cfquery name="tbDestinos" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM movimientos_destino, catalogo_pais WHERE pos11_p = catpais_cod AND id_ft_captura = '#vIdSol#'
</cfquery>
<cfif #tbDestinos.RecordCount# EQ 0 >
	<cfquery datasource="#vOrigenDatosSAMAA#">
		INSERT INTO movimientos_destino (id_ft_captura, acd_id, RFC, pos11, pos11_p, pos11_e, pos11_c)
		SELECT '#vIdSol#', acd_id, RFC, pos11, pos11_p, pos11_e, pos11_c WHERE id_ft_captura = '#vIdSol#'
	</cfquery>
</cfif>
--->
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
				vMensaje += (document.getElementById('pos12_1').checked || document.getElementById('pos12_2').checked || document.getElementById('pos12_3').checked || document.getElementById('pos12_4').checked) ? '' : 'Campo: MODIFICACIÓN A REALIZAR debe seleccionar una opción.\n';
				vMensaje += document.getElementById('pos13_1').checked || document.getElementById('pos13_2').checked ? '' : 'Campo: TIPO DE PERIODO debe seleccionar una opción.\n';
				vMensaje += fValidaFecha('pos14','INICIO');
			    // vMensaje += fValidaCampoLleno('memo1','NUEVO PROGRAMA'); <-- Lo deshabilité porque no siempre existe
				// Validar campos de destinos:
				vMensaje += fValidaDestino();
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
			// Mostrar y ocultar los controles según el tipo de modificación:
			function fCambiaModificacion()
			{
				// Deshabilitar campos dinámicos:
				document.getElementById('pos13_1').disabled = true;
				document.getElementById('pos13_2').disabled = true;
				document.getElementById('pos14').disabled = true;
				document.getElementById('memo1').disabled = true;
				// TEMPORALMENTE DEHABILITADO POR EL PROBLEMA AL TRAER LOS REGISTROS RELACIONADOS -->
				// document.getElementById('cmdMostrarFormulario').disabled = true;
				// <-- TEMPORALMENTE DEHABILITADO POR EL PROBLEMA AL TRAER LOS REGISTROS RELACIONADOS
				// Texto de las etiquetas:
				document.getElementById('txtPeriodo').innerHTML = "Tipo de periodo";
				document.getElementById('txtPrograma').innerHTML = "Programa de actividades precisando productos";
				//document.getElementById('txtLugar').innerHTML = "Instituciones donde realizará su período sabático";
				// Poner color de fondo blanco:
				document.getElementById('idPeriodo').style.backgroundColor = "white";
				document.getElementById('idPrograma').style.backgroundColor = "white";
				document.getElementById('idPrograma_etq').style.backgroundColor = "white";
				document.getElementById('idLugar').style.backgroundColor = "white";
				// Inicializar el campo 'pos12':
				document.getElementById('pos12').value = '';
				// Actualizar los campos lógicos de modificación:
				if (document.getElementById('pos12_1').checked)
				{
					document.getElementById('pos12').value += 'PERIODO ';
					document.getElementById('txtPeriodo').innerHTML = "Nuevo tipo de periodo";
					document.getElementById('idPeriodo').style.backgroundColor = "yellow";
					<cfif #vActivaCampos# EQ ''>
						document.getElementById('pos13_1').disabled = false;
						document.getElementById('pos13_2').disabled = false;
						document.getElementById('pos14').disabled = false;

					</cfif>
				}
				if (document.getElementById('pos12_2').checked)
				{
		            document.getElementById('pos12').value += 'PROGRAMA ';
		            document.getElementById('txtPrograma').innerHTML = "Nuevo programa precisando productos";
		            document.getElementById('idPrograma').style.backgroundColor = "yellow";
		            document.getElementById('idPrograma_etq').style.backgroundColor = "yellow";
					<cfif #vActivaCampos# EQ ''>
						document.getElementById('memo1').disabled = false;
					</cfif>
				}
				if (document.getElementById('pos12_3').checked)
				{
					document.getElementById('pos12').value += 'LUGAR ';
					document.getElementById('txtLugar').innerHTML = "Nuevas instituciones donde realizará su período sabático";
					document.getElementById('idLugar').style.backgroundColor = "yellow";
					<cfif #vActivaCampos# EQ ''>
						document.getElementById('cmdMostrarFormulario').disabled = false;
					</cfif>
				}
				if (document.getElementById('pos12_4').checked)
				{
					document.getElementById('pos12').value += 'BECA ';
				}
			}
			// Mostrar los documentos necesarios si se solicita beca DGAPA:
			function fDocumentosDGAPA()
			{
				if (document.getElementById('pos12_4').checked)
				{
					if (document.getElementById('DocDGAPA_1'))
					{
						document.getElementById('DocDGAPA_1').style.display = '';
						document.getElementById('DocDGAPA_2').style.display = '';
						document.getElementById('DocDGAPA_3').style.display = '';
						document.getElementById('DocDGAPA_4').style.display = '';
						document.getElementById('DocDGAPA_5').style.display = '';
					}
				}
				else
				{
					if (document.getElementById('DocDGAPA_1'))
					{
						document.getElementById('DocDGAPA_1').style.display = 'none';
						document.getElementById('DocDGAPA_2').style.display = 'none';
						document.getElementById('DocDGAPA_3').style.display = 'none';
						document.getElementById('DocDGAPA_4').style.display = 'none';
						document.getElementById('DocDGAPA_5').style.display = 'none';
						document.getElementById('DocDGAPA_1').checked = false;
						document.getElementById('DocDGAPA_2').checked = false;
						document.getElementById('DocDGAPA_3').checked = false;
						document.getElementById('DocDGAPA_4').checked = false;
						document.getElementById('DocDGAPA_5').checked = false;
					}
				}
			}
			// Actualizar
			function fCalcularPos15()
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
			}
		</script>
	</head>
	<body onLoad="fListaDestino(); fCambiaModificacion(); fDocumentosDGAPA();"> <!---  fAgregarDestino('CONSULTA', 0); --->
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
                        <!-- Datos que deben ingresarse: periodo a modificar -->
                        <cfoutput>
                            <table border="0" class="cuadrosFormularios">
                                <!-- Periodo sabático que se va a modificar -->
                                <tr>
                                    <td width="30%"><span class="Sans9GrNe">#ctMovimiento.mov_pos21#</span></td>
                                    <td width="70%">
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos21)#</span>
                                        <cfelse>
                                            <cfinput name="pos21" id="pos21" type="text" class="datos" size="10" value="#vCampoPos21#" disabled>
                                        </cfif>
                                        <span class="Sans9Gr">al</span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos22)#</span>
                                        <cfelse>
                                            <cfinput name="pos22" id="pos22" type="text" class="datos" size="10" value="#vCampoPos22#" disabled>
                                        </cfif>
                                        <cfif #vTipoBecaAnterior# EQ "CON BECA">
                                            <span class="Sans9Gr"> (con beca DGAPA)</span>
                                        <cfelse>
                                            <span class="Sans9Gr"> (sin beca DGAPA)</span>
                                        </cfif>
                                        <cfinput type="#vTipoInput#" name="pos12_o" id="pos12_o" value="#vMovSabId#">
                                    </td>
                                </tr>
                                <!-- Modificación a realizarse -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos12#</span></td>
                                    <td colspan="2">
                                        <cfinput name="pos12_1" id="pos12_1" type="checkbox" value="PERIODO" checked="#vCampoPos12_1#" disabled='#vActivaCampos#' onclick="fCambiaModificacion();">
                                        <span class="Sans9Gr">Periodo&nbsp;</span>
                                        <cfinput name="pos12_2" id="pos12_2" type="checkbox" value="PROGRAMA" checked="#vCampoPos12_2#" disabled='#vActivaCampos#' onclick="fCambiaModificacion();">
                                        <span class="Sans9Gr">Programa&nbsp;</span>
                                        <cfinput name="pos12_3" id="pos12_3" type="checkbox" value="LUGAR" checked="#vCampoPos12_3#" disabled='#vActivaCampos#' onclick="fCambiaModificacion();">
                                        <span class="Sans9Gr">Lugar</span>
										<!--- Se agregó el 19/06/2024 --->											
										<cfif #vTipoBecaAnterior# EQ "SIN BECA">
                                            <cfinput name="pos12_4" id="pos12_4" type="checkbox" value="BECA" checked="#vCampoPos12_4#" disabled='#vActivaCampos#' onclick="fCambiaModificacion(); fDocumentosDGAPA();">
                                            <span class="Sans9Gr">Solicita sabático con beca de la DGAPA</span>
										<cfelse>
                                            <cfinput name="pos12_4" id="pos12_4" type="checkbox" value="SIN BECA" checked="#vCampoPos12_4#" disabled='#vActivaCampos#' onclick="fCambiaModificacion(); fDocumentosDGAPA();">
                                            <span class="Sans9Gr">Solicita sabático sin beca de la DGAPA</span>
										</cfif>
<!---									Se eliminó el 19/06/2024		
                                        <span <cfif #vTipoBecaAnterior# EQ "CON BECA">style="display:none"></cfif>>
                                            <cfinput name="pos12_4" id="pos12_4" type="checkbox" value="BECA" checked="#vCampoPos12_4#" disabled='#vActivaCampos#' onclick="fCambiaModificacion(); fDocumentosDGAPA();">
                                            <span class="Sans9Gr">Solicita la beca de DGAPA</span>
                                        </span>
--->
                                        <cfinput name="pos12" id="pos12" type="hidden" value="#vCampoPos12#">
                                    </td>
                                </tr>
                            </table>
                        </cfoutput>
                        <!-- Datos que deben ingresarse: Cambios -->
                        <cfoutput>
                            <table border="0" class="cuadrosFormularios">
                                <!-- Nuevo periodo -->
                                <tr id="idPeriodo">
                                    <td width="30%">
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9GrNe" id="txtPeriodo">
                                                <cfif #Find("PERIODO", vCampoPos12)# IS 0>Tipo de periodo<cfelse>Nuevo tipo de periodo</cfif>
                                            </span>
                                        <cfelse>
                                            <span class="Sans9GrNe" id="txtPeriodo">Nuevo tipo de periodo</span>
                                        </cfif>
                                    </td>
                                    <td width="70%" colspan="2">
                                        <!-- Periodo -->
                                        <cfinput type="radio" name="pos13" id="pos13_1" value="A" checked="#Iif(vCampoPos13 EQ 'A',DE("yes"),DE("no"))#" disabled='#vActivaCampos#' onchange="fCalcularPos15();">
                                        <span class="Sans9Gr">A&ntilde;o&nbsp;</span>
                                        <cfinput type="radio" name="pos13" id="pos13_2" value="S" checked="#Iif(vCampoPos13 EQ 'S',DE("yes"),DE("no"))#" disabled='#vActivaCampos#' onchange="fCalcularPos15();">
                                        <span class="Sans9Gr">Semestre&nbsp;</span>
                                        <!-- Fechas -->
                                        <span class="Sans9Gr">#ctMovimiento.mov_pos14#</span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos14)#&nbsp;</span>
                                        <cfelse>
                                            <cfinput name="pos14" id="pos14" type="text" class="datos" size="11" maxlength="10" value="#vCampoPos14#" disabled='#vActivaCampos#' onblur="fCalcularPos15();" onkeypress="return MascaraEntrada(event, '99/99/9999');">
                                        </cfif>
                                        <span class="Sans9Gr">#ctMovimiento.mov_pos15# </span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos15)#</span>
                                        <cfelse>
                                            <cfinput name="pos15" id="pos15" type="text" class="datos" size="11" maxlength="10" value="#vCampoPos15#" disabled>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Nuevo programa -->
                                <tr id="idPrograma_etq">
                                    <td colspan="3">
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9GrNe" id="txtPeriodo">
                                                <cfif #Find("PROGRAMA", vCampoPos12)# IS 0>Programa precisando productos<cfelse>Nuevo programa precisando productos</cfif>
                                            </span>
                                        <cfelse>
                                            <span class="Sans9GrNe" id="txtPrograma">#ctMovimiento.mov_memo1#</span>
                                        </cfif>
                                    </td>
                                </tr>
                                <tr id="idPrograma">
                                    <td></td>
                                    <td colspan="2">
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoMemo1#</span>
                                        <cfelse>
                                            <cftextarea name="memo1" id="memo1" cols="80" rows="5" class="datos100" value="#vCampoMemo1#" disabled='#vActivaCampos#'></cftextarea>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Erogaciones adicionales -->
                                <tr id="idErogacion">
                                    <td colspan="3">
                                        <span class="Sans9GrNe">#ctMovimiento.mov_pos19#&nbsp;</span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#NumberFormat(vCampoPos19,"_$_-.__")#</span>
                                        <cfelse>
                                            <cfinput name="pos19" id="pos19" type="text" class="datos" size="10" maxlength="10" value="#vCampoPos19#" disabled='#vActivaCampos#'>
                                        </cfif>
                                    </td>
                                </tr>
                            </table>
                        </cfoutput>

                        <!-- INCLUDE Instituciones donde realizará (Se agregó el 23/01/2022) -->
                        <cfinclude template="ft_include_destinos.cfm">
                            
<!---                   ELIMINAR                          
                        <!--- PENDIENTE POR ACUALIZAR --->
                        <!-- Nuevas instituciones donde realizará su período sabático -->
                        <cfoutput>
							<cfinput type="hidden" name="posND" id="posND" value=""> <!-- Importante para validar después -->
                            <table id="idLugar" border="0" class="cuadrosFormularios">
                                <tr bgcolor="##CCCCCC">
                                    <td colspan="2">
                                        <span class="Sans9GrNe">
                                            <center id="txtLugar">
                                                <cfif #vTipoComando# IS 'IMPRIME'>
                                                    <span class="Sans9GrNe" id="txtPeriodo">
                                                        <cfif #Find("PROGRAMA", vCampoPos12)# IS 0>Instituciones donde realizar&aacute; su periodo sab&aacute;tico<cfelse>Nuevas instituciones donde realizar&aacute; su periodo sab&aacute;tico</cfif>
                                                    </span>
                                                <cfelse>
                                                    Instituciones donde realizar&aacute; su periodo sab&aacute;tico
                                                </cfif>
                                            </center>
                                        </span>
                                    </td>
                                </tr>
                                <!-- Lista de instituciones -->
                                <tr>
                                    <td colspan="2" id="destino_dynamic">
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <cfinclude template="ft_ajax/lista_destinos.cfm">
                                        <cfelse>
                                            <!-- AJAX: Lista de instituciones -->
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Botón que habilita el formulario para agregar instituciones -->
                                <tr class="NoImprimir">
                                    <td colspan="2" align="center">
                                        <cfinput name="cmdMostrarFormulario" id="cmdMostrarFormulario" type="button" class="botonesStandar" value="AGREGAR INSTITUCIÓN" onclick="fMostrarFormulario(true);" disabled='#vActivaCampos#'>
                                    </td>
                                </tr>
                                <!-- FORMULARIO PARA AGREGAR INSTITUCIONES (INICIA) -->
                                <!-- Institución -->
                                <tr id="frmInstitucion" style="display: none;">
                                    <td width="130"><span class="Sans9GrNe">Institución</span></td>
                                    <td><cfinput name="pos11_u" type="text" class="datos" id="pos11_u" size="60" maxlength="254"></td>
                                </tr>
                                <!-- País -->
                                <tr id="frmPais" style="display: none;">
                                    <td><span class="Sans9GrNe">País</span></td>
                                    <td>
                                        <cfselect name="pos11_p" class="datos" id="pos11_p" query="ctPais" queryPosition="below" value="pais_clave" display="pais_nombre" onchange="ObtenerEstados();">
                                            <option value="">SELECCIONE</option>
                                        </cfselect>
                                    </td>
                                </tr>
                                <!-- Estado -->
                                <tr id="frmEstado" style="display: none;">
                                    <td><span class="Sans9GrNe">Estado</span></td>
                                    <td id="estados_dynamic">
                                        <cfinput name="pos11_e" id="pos11_e" type="text" class="datos" size="50" maxlength="254">
                                    </td>
                                </tr>
                                <!-- Ciudad -->
                                <tr id="frmCiudad" style="display: none;">
                                    <td><span class="Sans9GrNe">Ciudad</span></td>
                                    <td><cfinput name="pos11_c" id="pos11_c" type="text" class="datos" size="50" maxlength="254"></td>
                                </tr>
                                <!-- Botones -->
                                <tr id="frmBotones" style="display: none;">
                                    <td colspan="2" align="center">
                                        <cfinput name="cmdAgregaDestino_1" type="button" class="botonesStandar" id="cmdAgregaDestino_1" value="ACEPTAR" onclick="if (fValidaCamposDestino()) fMostrarFormulario(false);">
                                        <cfinput name="cmdAgregaDestino_2" type="button" class="botonesStandar" id="cmdAgregaDestino_2" value="CANCELAR" onclick="fMostrarFormulario(false);">
                                    </td>
                                </tr>
                                <!-- FORMULARIO PARA AGREGAR INSTITUCIONES (TERMINA) -->
                            </table>
                        </cfoutput>
--->                                        
                        <!-- Dictámenes -->
                        <cfoutput>
                            <table border="0" class="cuadrosFormularios">
                                <!-- Encabezados -->
                                <tr bgcolor="##CCCCCC">
                                    <td width="65%"></td>
                                    <td width="20%"><div align="center" class="Sans10NeNe">Aprobatoria</div></td>
                                    <td width="15%"> <div align="center" class="Sans10NeNe">Se anexa</div></td>
                                </tr>
                                <!-- Opición del consejo interno -->
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
                                <!-- Encabezados -->
                                <tr bgcolor="##CCCCCC">
                                    <td width="85%"></td>
                                    <td width="15%"><div align="center" class="Sans10NeNe">Se anexa</div></td>
                                </tr>
                                <cfif "#vTipoBecaAnterior#" EQ 'SIN BECA'>
                                    <!-- Carta del director (con una breve semblanza del Investigador anfitrión y descripción académica de la Institución) -->
                                    <tr>
                                        <td><span class="Sans9GrNe">#ctMovimiento.mov_pos29#</span></td>
                                        <td><div align="center"><cfinput name="pos29" type="checkbox" id="pos29" value="Si" checked="#Iif(vCampoPos29 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                    </tr>
                                    <!-- Carta del interesado -->
                                    <tr>
                                        <td><span class="Sans9GrNe">#ctMovimiento.mov_pos32#</span></td>
                                        <td><div align="center"><cfinput name="pos32" type="checkbox" id="pos32" value="Si" checked="#Iif(vCampoPos32 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                    </tr>
                                    <!-- En caso de tener proyecto de investigación con financiamiento del CONACyT  -->
                                    <tr>
                                        <td><span class="Sans9GrNe">#ctMovimiento.mov_pos31#</span></td>
                                        <td><div align="center"><cfinput name="pos31" type="checkbox" id="pos31" value="Si" checked="#Iif(vCampoPos31 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                    </tr>                                      
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
                                    <!-- Documentos adicionales si solicita la beca DGAPA (INICIA) -->
                                    <!-- Curriculum vitae de la persona con quien va a laborar -->
                                    <tr id="DocDGAPA_1">
                                        <td><span class="Sans9GrNe">#ctMovimiento.mov_pos36#</span></td>
                                        <td><div align="center"><cfinput name="pos36" type="checkbox" id="pos36" value="Si" checked="#Iif(vCampoPos36 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                    </tr>
                                    <!-- Formatos DGAPA (copia) -->
                                    <tr id="DocDGAPA_2">
                                        <td><span class="Sans9GrNe">#ctMovimiento.mov_pos35#</span></td>
                                        <td><div align="center"><cfinput name="pos35" type="checkbox" id="pos35" value="Si" checked="#Iif(vCampoPos35 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                    </tr>
                                    <!-- Constancia actualizada de la situación laboral emitida por la DGP -->
                                    <tr id="DocDGAPA_3">
                                        <td><span class="Sans9GrNe">#ctMovimiento.mov_pos37#</span></td>
                                        <td><div align="center"><cfinput name="pos37" type="checkbox" id="pos37" value="Si" checked="#Iif(vCampoPos37 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                    </tr>
                                    <!-- Constancias oficiales (idioma y otro(s) apoyo(s)) -->
                                    <tr id="DocDGAPA_4">
                                        <td><span class="Sans9GrNe">#ctMovimiento.mov_pos38#</span></td>
                                        <td><div align="center"><cfinput name="pos38" type="checkbox" id="pos38" value="Si" checked="#Iif(vCampoPos38 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                    </tr>
                                    <!-- Copias de acta de nacimiento y del último grado obtenido -->
                                    <tr id="DocDGAPA_5">
                                        <td><span class="Sans9GrNe">#ctMovimiento.mov_pos39#</span></td>
                                        <td><div align="center"><cfinput name="pos39" type="checkbox" id="pos39" value="Si" checked="#Iif(vCampoPos38 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                    </tr>
                                    <!-- Documentos adicionales si solicita la beca DGAPA (TERMINA) -->
                                <cfelseif "#vTipoBecaAnterior#" EQ 'CON BECA'>
                                    <tr>
                                        <td><span class="Sans9GrNe">#ctMovimiento.mov_pos29#</span></td>
                                        <td><div align="center"><cfinput name="pos29" type="checkbox" id="pos29" value="Si" checked="#Iif(vCampoPos29 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                    </tr>
                                    <tr>
                                        <td><span class="Sans9GrNe">#ctMovimiento.mov_pos32#</span></td>
                                        <td><div align="center"><cfinput name="pos32" type="checkbox" id="pos32" value="Si" checked="#Iif(vCampoPos32 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                    </tr>
                                    <tr>
                                        <td><span class="Sans9GrNe">#ctMovimiento.mov_pos33#</span></td>
                                        <td><div align="center"><cfinput name="pos33" type="checkbox" id="pos33" value="Si" checked="#Iif(vCampoPos33 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                    </tr>
                                    <tr>
                                        <td><span class="Sans9GrNe">#ctMovimiento.mov_pos34#</span></td>
                                        <td><div align="center"><cfinput name="pos34" type="checkbox" id="pos34" value="Si" checked="#Iif(vCampoPos34 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                    </tr>
                                    <tr>
                                        <td><span class="Sans9GrNe">#ctMovimiento.mov_pos36# (si cambió el asesor)</span></td>
                                        <td><div align="center"><cfinput name="pos36" type="checkbox" id="pos36" value="Si" checked="#Iif(vCampoPos36 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                    </tr>
                                    <tr>
                                        <td><span class="Sans9GrNe">#ctMovimiento.mov_pos35#</span></td>
                                        <td><div align="center"><cfinput name="pos35" type="checkbox" id="pos35" value="Si" checked="#Iif(vCampoPos35 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                    </tr>
                                    <tr>
                                        <td><span class="Sans9GrNe">#ctMovimiento.mov_pos38#</span></td>
                                        <td><div align="center"><cfinput name="pos38" type="checkbox" id="pos38" value="Si" checked="#Iif(vCampoPos38 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                    </tr>
                                </cfif>
                            </table>
                        </cfoutput>
                        <!---
                        <!-- Comentario -->
                        <cfoutput>
                        <span class="Sans9Gr" align="center" width="60%">#ctMovimiento.mov_comentarios#</span>
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
