<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 21/04/2009 --->
<!--- FECHA ÚLTIMA MOD.: 01/07/2020 --->
<!--- FT-CTIC-31.-Correción a oficio --->

<!--- Incluir los siguientes archivos --->
<cfif #vTipoComando# EQ 'IMPRIME_EJEMPLO'>
	<cfinclude template="ft_campos_blanco.cfm"> <!---PERIMITE IMPRIMIR LA FT EN BLANCO --->
	<cfset vTipoComando = 'IMPRIME'>
<cfelse>
	<cfinclude template="ft_campos.cfm">
</cfif>

<!--- Asignar valor al campo Pos12 (que contiene el asunto relacionado) --->
<cfif #vCampoPos12# EQ ''>
	<cfset vCampoPos12 = #vIdMovRel#>
</cfif>
<!--- Obtener datos del movimiento relacionado --->
<cfquery name="tbMovimientoRel" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM movimientos AS T1
	LEFT JOIN movimientos_asunto AS T2 ON T1.sol_id = T2.sol_id
	LEFT JOIN catalogo_movimiento AS C1 ON T1.mov_clave = C1.mov_clave
	WHERE T1.mov_id = #vCampoPos12#
	AND T2.asu_reunion = 'CTIC'
	ORDER BY T1.sol_id DESC
</cfquery>

<cfset vMovRelId = #tbMovimientoRel.sol_id#>

<cfquery name="tbCorrecionOficio" datasource="#vOrigenDatosSAMAA#">
	<!--- Revisa si cuenta con una correción a oficio previa --->
    SELECT TOP 1 T2.sol_id
    FROM movimientos AS T1
    INNER JOIN movimientos_correccion AS T2 ON T1.mov_id = T2.mov_id
    INNER JOIN movimientos_asunto AS T3 ON T2.sol_id = T3.sol_id
    WHERE T1.mov_id = #vCampoPos12#
	AND T2.sol_id <> #vIdSol# <!--- SE INCORPORA PARA NO INCLUIR ESTA MISMA CORRECIÓN  (01/07/2020) --->
	ORDER BY T3.ssn_id DESC <!--- SE ORDENA PARA SELECCIONAR EL OFICIO MAS RECIENTE (23/05/2018) --->
<!---	
    SELECT TOP 1 movimientos_correccion.sol_id
    FROM (movimientos 
    INNER JOIN movimientos_correccion ON movimientos.mov_id = movimientos_correccion.mov_id)
    INNER JOIN movimientos_asunto ON movimientos_correccion.sol_id = movimientos_asunto.sol_id AND movimientos_asunto.ssn_id < #Session.sSesion#
    WHERE movimientos.mov_id = #vCampoPos12#
	ORDER BY movimientos_asunto.ssn_id DESC <!--- SE ORDENA PARA SELECCIONAR EL OFICIO MAS RECIENTE (23/05/2018) --->
--->	
</cfquery>

<cfif #tbCorrecionOficio.RecordCount# GT 0>
	<cfset vMovRelId = #tbCorrecionOficio.sol_id#>
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

			// Función para habilitar/deshabilitar el formulario para agregar correcciones:
			function fMostrarFormulario(mostrar)
			{
				// Ocultar todos los formularios:
				document.getElementById('frmDivision').style.display= 'none';
				document.getElementById('frmDuracionDice').style.display= 'none';
				document.getElementById('frmDuracionDebeDecir').style.display= 'none';
				document.getElementById('frmBotones').style.display= 'none';
				document.getElementById('frmAcademicoDice').style.display= 'none';
				document.getElementById('frmAcademicoDebeDecir').style.display= 'none';
				document.getElementById('frmOtrosCampo').style.display= 'none';
				document.getElementById('frmOtrosDice').style.display= 'none';
				document.getElementById('frmOtrosDebeDecir').style.display= 'none';
				// Mostrar el formulario seleccionado:
				if (mostrar == 'NOMBRE')
				{
					document.getElementById('frmDivision').style.display= '';
					document.getElementById('frmAcademicoDice').style.display= '';
					document.getElementById('frmAcademicoDebeDecir').style.display= '';
					document.getElementById('frmBotones').style.display= '';
				}
				else if (mostrar == 'DURACION')
				{
					document.getElementById('frmDivision').style.display= '';
					document.getElementById('frmDuracionDice').style.display= '';
					document.getElementById('frmDuracionDebeDecir').style.display= '';
					document.getElementById('frmBotones').style.display= '';
				}
				else if (mostrar == 'OTRO')
				{
					document.getElementById('frmDivision').style.display= '';
					document.getElementById('frmOtrosCampo').style.display= '';
					document.getElementById('frmOtrosDice').style.display= '';
					document.getElementById('frmOtrosDebeDecir').style.display= '';
					document.getElementById('frmBotones').style.display= '';
				}
				else
				{
					// Es muy importante vaciar los campos del formulario al ocultaro:
					if (document.getElementById('fecha_inicio_debe_decir')) document.getElementById('fecha_inicio_debe_decir').value = '';
					if (document.getElementById('fecha_final_debe_decir')) document.getElementById('fecha_final_debe_decir').value = '';
					if (document.getElementById('duracion_a')) document.getElementById('duracion_a').value = '';
					if (document.getElementById('duracion_m')) document.getElementById('duracion_m').value = '';
					if (document.getElementById('duracion_d')) document.getElementById('duracion_d').value = '';
					// ...
					if (document.getElementById('nombre_debe_decir')) document.getElementById('nombre_debe_decir').value = '';
					if (document.getElementById('apepat_debe_decir')) document.getElementById('apepat_debe_decir').value = '';
					if (document.getElementById('apemat_debe_decir')) document.getElementById('apemat_debe_decir').value = '';
					// ...
					if (document.getElementById('otro_cambio_en')) document.getElementById('otro_cambio_en').value = '';
					if (document.getElementById('otro_cambio_dice')) document.getElementById('otro_cambio_dice').value = '';
					if (document.getElementById('otro_cambio_debe_decir')) document.getElementById('otro_cambio_debe_decir').value = '';
					// ...
					document.getElementById('frmSeleccionCampo').selectedIndex = 0;


				}
			}
			// Calcular la fecha final según los datos ingresados:
			function CalcularFechaFinal()
			{
				if (document.getElementById('fecha_final_debe_decir'))
				{
					// Obtener los valores que se van a sumar:
					aa = document.getElementById('duracion_a').value > 0 ?  document.getElementById('duracion_a').value: 0;
					mm = document.getElementById('duracion_m').value > 0 ?  document.getElementById('duracion_m').value: 0;
					dd = document.getElementById('duracion_d').value > 0 ?  document.getElementById('duracion_d').value: 0;
					// Asignar valor a la siguiente fecha:
					document.getElementById('fecha_final_debe_decir').value = CalcularSiguienteFecha2('fecha_inicio_debe_decir', aa, mm, dd);
				}
			}
			function fListaCorreccion(vComando, vTipo, vIdReg)
			{
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones
				xmlHttp.open("POST", "ft_ajax/lista_correcciones.cfm", false);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "vComando=" + encodeURIComponent('<cfoutput>#vTipoComando#</cfoutput>');
				parametros += "&vIdReg=" + encodeURIComponent(vIdReg);
				parametros += "&vActivaCampos=" + encodeURIComponent('<cfoutput>#vActivaCampos#</cfoutput>');
				parametros += "&vIdSol=" + encodeURIComponent(document.getElementById('vIdSol').value);
				parametros += "&vIdMov=" + encodeURIComponent(document.getElementById('pos12').value);
				parametros += "&vTipo=" + encodeURIComponent(vTipo);
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);
				// Actualizar la lista:
				document.getElementById('correccion_dynamic').innerHTML = xmlHttp.responseText;				
			}
			
			// AJAX: Agregar corrección a la lista:
			function fAgregarCorreccion(vComando, vTipo, vIdReg)
			{
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones
				xmlHttp.open("POST", "ft_ajax/lista_correcciones.cfm", false);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "vComando=" + encodeURIComponent(vComando);
				parametros += "&vIdReg=" + encodeURIComponent(vIdReg);
				parametros += "&vActivaCampos=" + encodeURIComponent('<cfoutput>#vActivaCampos#</cfoutput>');
				parametros += "&vIdSol=" + encodeURIComponent(document.getElementById('vIdSol').value);
				parametros += "&vIdMov=" + encodeURIComponent(document.getElementById('pos12').value);
				parametros += "&vTipo=" + encodeURIComponent(vTipo);
				// Campo a modificar:
				if (document.getElementById('frmSeleccionCampo').value == 'OTRO')
				{
					parametros += "&vCampo=" + encodeURIComponent(document.getElementById('otro_cambio_en').value);
				}
				else
				{
					parametros += "&vCampo=" + encodeURIComponent(document.getElementById('frmSeleccionCampo').value);
				}
				// Campos que se van a ingresar:
				if (vTipo == 'DICE')
				{
					if (document.getElementById('frmSeleccionCampo').value == 'NOMBRE')
					{
						parametros += "&vApePat=" + encodeURIComponent(document.getElementById('apepat_dice').value);
						parametros += "&vApeMat=" + encodeURIComponent(document.getElementById('apemat_dice').value);
						parametros += "&vNombre=" + encodeURIComponent(document.getElementById('nombre_dice').value);
					}
					else if (document.getElementById('frmSeleccionCampo').value == 'DURACION')
					{
						parametros += "&vFI=" + encodeURIComponent(document.getElementById('fecha_inicio_dice').value);
						if (document.getElementById('fecha_final_dice')) parametros += "&vFF=" + encodeURIComponent(document.getElementById('fecha_final_dice').value);
					}
					else if (document.getElementById('frmSeleccionCampo').value == 'OTRO')
					{
						parametros += "&vTexto=" + encodeURIComponent(document.getElementById('otro_cambio_dice').value);
					}
				}
				else
				{
					if (document.getElementById('frmSeleccionCampo').value == 'NOMBRE')
					{
						parametros += "&vApePat=" + encodeURIComponent(document.getElementById('apepat_debe_decir').value);
						parametros += "&vApeMat=" + encodeURIComponent(document.getElementById('apemat_debe_decir').value);
						parametros += "&vNombre=" + encodeURIComponent(document.getElementById('nombre_debe_decir').value);
					}
					else if (document.getElementById('frmSeleccionCampo').value == 'DURACION')
					{
						parametros += "&vFI=" + encodeURIComponent(document.getElementById('fecha_inicio_debe_decir').value);
						if (document.getElementById('fecha_final_debe_decir')) parametros += "&vFF=" + encodeURIComponent(document.getElementById('fecha_final_debe_decir').value);
					}
					else if (document.getElementById('frmSeleccionCampo').value == 'OTRO')
					{
						parametros += "&vTexto=" + encodeURIComponent(document.getElementById('otro_cambio_debe_decir').value);
					}
				}
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);
                
                
				// Actualizar la lista:
				document.getElementById('correccion_dynamic').innerHTML = xmlHttp.responseText;
			}
			// Validar los datos antes de agregar corrección:
			function fValidaCamposCorreccion()
			{
                
				fAgregarCorreccion('INSERTA', 'DICE', '');
				fAgregarCorreccion('INSERTA', 'DEBE DECIR', '');
				return true;
			}
		</script>
	</head>
	<body onLoad="fListaCorreccion('CONSULTA', '', '');"> <!--- fAgregarCorreccion('CONSULTA', '', '');" --->
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
                        <!-- Movimiento relacionado -->
                        <cfinput id="pos12" name="pos12" type="hidden" value="#vCampoPos12#">
                        <!-- Datos que deben ingresarse -->
                        <cfoutput>
                            <table border="0" class="cuadrosFormularios">
                                <!-- Tipo de movimiento -->
                                <tr>
                                    <td width="20%"><span class="Sans9GrNe">Tipo de asunto</span></td>
                                    <td width="80%" colspan="2">
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#Ucase(tbMovimientoRel.mov_titulo)#</span>
                                        <cfelse>
                                            <input type="text" class="datos100" value="#Ucase(tbMovimientoRel.mov_titulo)#" disabled>
                                        </cfif>
                                    </td>
                                </tr>
                                <!--- Datos de la última decisión del CTIC respecto al asunto relacionado --->
                                <cfquery name="tbAsuntosUltimo" datasource="#vOrigenDatosSAMAA#">
                                    SELECT TOP 1 * FROM movimientos_asunto
                                    LEFT JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave
                                    WHERE sol_id = #vMovRelId# 
                                    AND asu_reunion = 'CTIC'
                                    ORDER BY ssn_id DESC
                                </cfquery>
                                <tr>
                                    <!-- Número de Oficio -->
                                    <td><span class="Sans9GrNe">N&uacute;mero de oficio</span></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#tbAsuntosUltimo.asu_oficio#</span>
                                        <cfelse>
                                            <input type="text" class="datos" size="20" maxlength="20" value="#tbAsuntosUltimo.asu_oficio#" disabled>
                                        </cfif>
                                    </td>
                                    <!-- Número de acta -->
                                    <td align="right">
                                        <span class="Sans9GrNe">Del Acta&nbsp;</span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#tbAsuntosUltimo.ssn_id#</span>
                                        <cfelse>
                                            <input type="text" class="datos" size="4" maxlength="4" value="#tbAsuntosUltimo.ssn_id#" disabled>
                                        </cfif>
                                    </td>
                                </tr>
								<cfif #vTipoComando# NEQ 'IMPRIME'>
									<tr>
										<td width="20%"><span class="Sans9GrNe">Número de solicitud referida</span></td>
										<td width="80%" colspan="2">
											<input type="text" class="datos" value="#vCampoPos12#" disabled>
										</td>
									</tr>
								</cfif>
                            </table>
                        </cfoutput>
                        <!-- Correcciones que se desea realizar -->
                        <cfinput type="hidden" name="posND" id="posND" value="">
                            <table id="lista_instituciones" border="0" class="cuadrosFormularios">
                                <!-- Titulo del recuadro -->
                                <tr bgcolor="#CCCCCC">
                                    <td colspan="2">
                                        <span class="Sans9GrNe"><center>CORRECCIONES A REALIZARSE</center></span>
                                    </td>
                                </tr>
                                <!-- Lista de correcciones -->
                                <tr>
                                    <td colspan="2">
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <cfset vIdMov = #vCampoPos12#>
                                            <cfinclude template="ft_ajax/lista_correcciones.cfm">
                                        <cfelse>
                                            <div id="correccion_dynamic"><!-- AJAX: Lista de correcciones --></div>
                                        </cfif>
                                    </td>
                                </tr>

                                <!-- Selección de data que se desea modificar -->
                                <tr>
                                    <td class="NoImprimir" colspan="2" align="center">
                                        Agregar una de correcci&oacute;n de
                                        <select name="frmSeleccionCampo" id="frmSeleccionCampo" class="datos" onChange="fMostrarFormulario(this.value);" <cfif #vActivaCampos# IS 'disabled'>disabled</cfif>>
                                            <option value="">SELECCIONE</option>
                                            <option value="NOMBRE">Nombre del académico</option>
                                            <option value="DURACION">Duraci&oacute;n y/o fechas</option>
                                            <option value="OTRO">Otra correcci&oacute;n</option>
                                        </select>
                                    </td>
                                </tr>

                                <tr id="frmDivision" style="display: none;"><td colspan="2"><hr></td></tr>
                                <!-- FORMULARIO PARA AGREGAR CORRECCIONES (INICIA) -->
                                <!-- Coorrección de duración -->
                                <cfif #tbMovimientoRel.mov_fecha_final# EQ '' OR #tbMovimientoRel.mov_fecha_final# EQ #tbMovimientoRel.mov_fecha_inicio#>
                                    <!-- Dice -->
                                    <tr id="frmDuracionDice" style="display: none;">
                                        <td width="20%"><span class="Sans9GrNe">Dice</span></td>
                                        <td width="80%">
                                            <!-- Fechas -->
                                            <span class="Sans9Gr">
                                                <cfif #tbMovimientoRel.mov_clave# EQ 22>
                                                    Diferir de la fecha
                                                <cfelse>
                                                    A partir del
                                                </cfif>
                                            </span>
                                            <input id="fecha_inicio_dice" type="text" class="datos" size="10" value="<cfoutput>#LsDateFormat(tbMovimientoRel.mov_fecha_inicio,'dd/mm/yyyy')#</cfoutput>" disabled>
                                            <span class="Sans9Gr" id="pos14_txt">
                                                <cfif #tbMovimientoRel.mov_clave# EQ 22>al término de su cargo/nombramiento.</cfif>
                                            </span>
                                        </td>
                                    </tr>
                                    <!-- Debe decir -->
                                    <tr id="frmDuracionDebeDecir" style="display: none;">
                                        <td><span class="Sans9GrNe">Debe decir</span></td>
                                        <td>
                                            <span class="Sans9Gr">
                                                <cfif #tbMovimientoRel.mov_clave# EQ 22>
                                                    Diferir de la fecha&nbsp;
                                                <cfelse>
                                                    A partir del&nbsp;
                                                </cfif>
                                            </span>
                                            <input id="fecha_inicio_debe_decir" class="datos" type="text" size="10" maxlength="10" onChange="CalcularSiguienteFecha();" onKeyPress="return MascaraEntrada(event, '99/99/9999');">
                                            <span class="Sans9Gr" id="pos14_txt">
                                                <cfif #tbMovimientoRel.mov_clave# EQ 22>al término de su cargo/nombramiento.</cfif>
                                            </span>
                                        </td>
                                    </tr>
                                <cfelse>
                                    <!-- Dice -->
                                    <tr id="frmDuracionDice" style="display: none;">
                                        <td width="20%"><span class="Sans9GrNe">Dice</span></td>
                                        <td width="80%">
                                            <cfif #tbMovimientoRel.mov_clave# NEQ 22>
                                                <!--- Desglosar el periodo en años, meses y días --->
                                                <cfset vFF = #dateadd('d',1,tbMovimientoRel.mov_fecha_final)#>
                                                <cfset vF1 = #tbMovimientoRel.mov_fecha_inicio#>
                                                <cfset vAnios = #DateDiff('yyyy',#vF1#, #vFF#)#>
                                                <cfset vF2 = #dateadd('yyyy',vAnios,vF1)#>
                                                <cfset vMeses = #DateDiff('m',#vF2#, #vFF#)#>
                                                <cfset vF3 = #dateadd('m',vMeses,vF2)#>
                                                <cfset vDias = #DateDiff('d',#vF3#, #vFF#)#>
                                                <!--- Construir la cadena de texto que se mostrará --->
                                                <input type="text" class="datos" size="1" maxlength="1" value="<cfoutput>#vAnios#</cfoutput>" disabled>
                                                <span class="Sans9Gr">año(s)</span>
                                                <input type="text" class="datos" size="2" maxlength="2" value="<cfoutput>#vMeses#</cfoutput>" disabled>
                                                <span class="Sans9Gr">mes(es)</span>
                                                <input type="text" class="datos" size="2" maxlength="2" value="<cfoutput>#vDias#</cfoutput>" disabled>
                                                <span class="Sans9Gr">d&iacute;a(s)</span>
                                            </cfif>
                                            <!-- Fechas -->
                                            <span class="Sans9Gr">
                                                <cfif #tbMovimientoRel.mov_clave# EQ 22>
                                                    Diferir de la fecha&nbsp;
                                                <cfelse>
                                                    del&nbsp;
                                                </cfif>
                                            </span>
                                            <input id="fecha_inicio_dice" type="text" class="datos" size="10" maxlength="10" value="<cfoutput>#LsDateFormat(tbMovimientoRel.mov_fecha_inicio,'dd/mm/yyyy')#</cfoutput>" disabled>
                                            <span class="Sans9Gr">
                                                <cfif #tbMovimientoRel.mov_clave# EQ 22>
                                                    a la fecha&nbsp;
                                                <cfelse>
                                                    al&nbsp;
                                                </cfif>
                                            </span>
                                            <input id="fecha_final_dice" type="text" class="datos" size="10" maxlength="10" value="<cfoutput>#LsDateFormat(tbMovimientoRel.mov_fecha_final,'dd/mm/yyyy')#</cfoutput>" disabled>
                                        </td>
                                    </tr>
                                    <!-- Debe decir -->
                                    <tr id="frmDuracionDebeDecir" style="display: none;">
                                        <td><span class="Sans9GrNe" id="pos13_a_txt">Debe decir</span></td>
                                        <td>
                                            <cfif #tbMovimientoRel.mov_clave# NEQ 22>
                                                <input id="duracion_a" type="text" class="datos" size="1" maxlength="1" onBlur="CalcularFechaFinal();" onKeyPress="return MascaraEntrada(event, '9');">
                                                <span class="Sans9Gr">año(s)</span>
                                                <input id="duracion_m" type="text" class="datos" size="2" maxlength="2" onBlur="CalcularFechaFinal();" onKeyPress="return MascaraEntrada(event, '99');">
                                                <span class="Sans9Gr">mes(es)</span>
                                                <input id="duracion_d" type="text" class="datos" size="2" maxlength="2" onBlur="CalcularFechaFinal();" onKeyPress="return MascaraEntrada(event, '99');">
                                                <span class="Sans9Gr">día(s)</span>
                                            </cfif>
                                            <!-- Fechas -->
                                            <span class="Sans9Gr">
                                                <cfif #tbMovimientoRel.mov_clave# EQ 22>
                                                    Diferir de la fecha&nbsp;
                                                <cfelse>
                                                    del&nbsp;
                                                </cfif>
                                            </span>
                                            <input id="fecha_inicio_debe_decir" type="text" class="datos" size="10" maxlength="10" onBlur="CalcularFechaFinal();" onKeyPress="return MascaraEntrada(event, '99/99/9999');">
                                            <span class="Sans9Gr">
                                                <cfif #tbMovimientoRel.mov_clave# EQ 22>
                                                    a la fecha <input id="fecha_final_debe_decir" type="text" class="datos" size="10" maxlength="10" onKeyPress="return MascaraEntrada(event, '99/99/9999');">
                                                <cfelse>
                                                    al <input id="fecha_final_debe_decir" type="text" class="datos" size="10" maxlength="10" disabled>
                                                </cfif>
                                            </span>
                                        </td>
                                    </tr>
                                </cfif>
                                <!-- Corrección de nombre -->
                                <!-- Dice -->
                                <tr id="frmAcademicoDice" style="display: none;">
                                    <td width="20%"><span class="Sans9GrNe">Dice</span></td>
                                    <td width="80%">
                                        <table class="Sans9Gr">
                                            <tr>
                                                <td>Nombre</td>
                                                <td><input id="nombre_dice" type="text" class="datos" value="<cfoutput>#tbAcademico.acd_nombres#</cfoutput>" size="40" disabled></td>
                                            </tr>
                                            <tr>
                                                <td>Apellido paterno</td>
                                                <td><input id="apepat_dice" type="text" class="datos" value="<cfoutput>#tbAcademico.acd_apepat#</cfoutput>" size="40" disabled></td>
                                            </tr>
                                            <tr>
                                                <td>Apellido materno</td>
                                                <td><input id="apemat_dice" type="text" class="datos" value="<cfoutput>#tbAcademico.acd_apemat#</cfoutput>" size="40" disabled></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <!-- División -->
                                <tr><td colspan="2"><hr></td></tr>
                                <!-- Debe decir -->
                                <tr id="frmAcademicoDebeDecir" style="display: none;">
                                    <td width="20%"><span class="Sans9GrNe">Debe decir</span></td>
                                    <td width="80%">
                                        <table class="Sans9Gr">
                                            <tr>
                                                <td>Nombre</td>
                                                <td><input id="nombre_debe_decir" type="text" class="datos" size="40" maxlength="50"></td>
                                            </tr>
                                            <tr>
                                                <td>Apellido paterno</td>
                                                <td><input id="apepat_debe_decir" type="text" class="datos" size="40" maxlength="50"></td>
                                            </tr>
                                            <tr>
                                                <td>Apellido materno</td>
                                                <td><input id="apemat_debe_decir" type="text" class="datos" size="40" maxlength="50"></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <!-- Otras correcciones -->
                                <!-- Cambio en -->
                                <tr id="frmOtrosCampo" style="display: none;">
                                    <td width="20%"><span class="Sans9GrNe">Cambio en</span></td>
                                    <td width="80%">
                                        <input id="otro_cambio_en" type="text" class="datos" size="20" maxlength="20">
                                    </td>
                                </tr>
                                <!-- Dice -->
                                <tr id="frmOtrosDice" style="display: none;">
                                    <td><span class="Sans9GrNe">Dice</span></td>
                                    <td>
                                        <textarea id="otro_cambio_dice" cols="70" rows="4" class="datos100"></textarea>
                                    </td>
                                </tr>
                                <!-- Debe decir -->
                                <tr id="frmOtrosDebeDecir" style="display: none;">
                                    <td><span class="Sans9GrNe">Debe decir</span></td>
                                    <td>
                                        <textarea id="otro_cambio_debe_decir" cols="70" rows="4" class="datos100"></textarea>
                                    </td>
                                </tr>
                                <!-- Botones -->
                                <tr id="frmBotones" style="display: none;">
                                    <td colspan="2" align="center">
                                        <cfinput name="cmdAgregaCorreccion_1" id="cmdAgregaCorreccion_1" type="button" class="botonesStandar" value="AGREGAR" onclick="if (fValidaCamposCorreccion()) fMostrarFormulario(false);">
                                        <cfinput name="cmdAgregaCorreccion_2" id="cmdAgregaCorreccion_2" type="button" class="botonesStandar" value="CANCELAR" onclick="fMostrarFormulario(false);">
                                    </td>
                                </tr>
                                <!-- FORMULARIO PARA AGREGAR CORRECCIONES (TERMINA) -->
                            </table>
                            
                            <!-- Documentación -->
						<cfoutput>
                            <table border="0" class="cuadrosFormularios">
                                <!-- Encabezado -->
                                <tr bgcolor="##CCCCCC">
                                    <td width="85%"></td>
                                    <td width="15%"><div align="center" class="Sans10NeNe">Se anexa</div></td>
                                </tr>
                                <!-- Carta de director solicitando la corrección -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos29#</span></td>
                                    <td><div align="center"><cfinput name="pos29" type="checkbox" id="pos29" value="Si" checked="#Iif(vCampoPos29 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Original del oficio expedido por el CTIC -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos33#</span></td>
                                    <td><div align="center"><cfinput name="pos33" type="checkbox" id="pos33" value="Si" checked="#Iif(vCampoPos33 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
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
