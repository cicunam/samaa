<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 18/02/2015 --->
<!--- FECHA ÚLTIMA MOD.: 10/10/2019 --->
<!--- FT-CTIC-44.-Cátedras CONACyT --->

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

<!--- Obtener el nombre del responsable técnico --->
<cfif #vCampoPos12# NEQ ''>
	<cfquery name="tbAcademicoAsesor" datasource="#vOrigenDatosSAMAA#">
	   	SELECT * FROM academicos 
        WHERE acd_id = #vCampoPos12#
	</cfquery>
	<cfset vCampoPos12_txt = '#Trim(tbAcademicoAsesor.acd_prefijo)# #Trim(tbAcademicoAsesor.acd_nombres)# #Trim(tbAcademicoAsesor.acd_apepat)# #Trim(tbAcademicoAsesor.acd_apemat)# '>
<cfelse>
	<cfset vCampoPos12_txt=''>
</cfif>

<!--- Obtener los datos de la última promoción --->
<cfquery name="tbMovimientosAnteriores" datasource="#vOrigenDatosSAMAA#">
	SELECT TOP 1 *
	FROM (movimientos
	LEFT JOIN movimientos_asunto ON movimientos.sol_id = movimientos_asunto.sol_id)
	LEFT JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave
	WHERE acd_id = #vIdAcad#
	AND mov_clave = 44
	AND asu_reunion = 'CTIC'
	AND dec_super = 'AP' <!--- Asuntos aprobados --->
	ORDER BY mov_fecha_inicio DESC
</cfquery>

<cfif #vTipoComando# EQ 'NUEVO' AND #tbMovimientosAnteriores.RecordCount# GT 0>
	<cfset vCampoPos14=#LsdateFormat(DateAdd("yyyy", 1, tbMovimientosAnteriores.mov_fecha_inicio),'dd/mm/yyyy')#>
	<cfset vCampoPos15=#LsdateFormat(DateAdd("yyyy", 1, tbMovimientosAnteriores.mov_fecha_final),'dd/mm/yyyy')#>    
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
				vMensaje += fValidaCampoLleno('pos12','RESPONSABLE TÉCNICO');
				vMensaje += fValidaCampoLleno('memo1','PROYECTO');
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
				}
				else if (vRegreso == 'pos12_o')
				{
					// Mostrar el nombre del académico asesor:
					document.getElementById('pos12_o').value = document.getElementById('selAcadLista').options[document.getElementById('selAcadLista').selectedIndex].value
					document.getElementById('pos12_o_txt').value = document.getElementById('selAcadLista').options[document.getElementById('selAcadLista').selectedIndex].text;
					// Ocultar la lista de académicos:
					document.getElementById('becario_dynamic').innerHTML = '';
				}
			}

			// Obtener Cátedras CONACyT anteriores:
			function ObtenerNoCatedras()
			{
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Función de atención a las petición HTTP:
				xmlHttp.onreadystatechange = function(){
					if (xmlHttp.readyState == 4) {
						document.getElementById('catedras_dynamic').innerHTML = xmlHttp.responseText;
					}
				}
				// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones
				xmlHttp.open("POST", "ft_ajax/lista_numero_catedras.cfm", true);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "&vIdAcad=" + encodeURIComponent(document.getElementById('pos2').value); //<!---parametros = "vRfc=" + encodeURIComponent(document.getElementById('vRFC').value);--->
				parametros += "&vCcnActual=" + encodeURIComponent(document.getElementById('pos8').value);
				parametros += "&vFt=" + encodeURIComponent(document.getElementById('vFt').value);
				parametros += "&vTipoComando=" + encodeURIComponent('<cfoutput>#vTipoComando#</cfoutput>');
				parametros += "&vDepClave=" + encodeURIComponent('<cfoutput>#vCampoPos1#</cfoutput>');
				parametros += "&vCampoPos17=" + encodeURIComponent('<cfoutput>#vCampoPos17#</cfoutput>');
				parametros += "&vCampoPos12_o=" + encodeURIComponent('<cfoutput>#vCampoPos12_o#</cfoutput>');
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);
			}
			// Actualizar el formulario:
//			function fActualizar()
//			{
//				if (document.getElementById('pos20_s').checked)
//				{
//					show('pos12_o_row');
//				}
//				else
//				{
//					hide('pos12_o_row');
//					document.getElementById('pos12_o').value = '';
//					document.getElementById('pos12_o_txt').value = '';
//				}
//			}
		</script>
	</head>
	<body onLoad=" ObtenerNoCatedras();"><!---  onLoad="fActualizar();"--->
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
                                <!-- Duración del contrato -->
								<!--- Por necesidades de la STCTIC se incorporó año, mes, día en la duración 10/10/2019 --->
                                <tr>
                                    <td width="20%"><span class="Sans9GrNe">#ctMovimiento.mov_pos13#</span></td>
                                    <td width="80%">
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
                                                <span class="Sans9Gr">
                                                    #vCampoPos13_d# #ctMovimiento.mov_pos13_d#&nbsp;
                                            </span>
                                            </span>
                                        <cfelse>
                                            <span
                                                <cfif #vCampoPos13_a# EQ 0>class="NoImprimir"</cfif>
                                                ><cfinput type="text" name="pos13_a" disabled='#vActivaCampos#' class="datos" id="pos13_a" onChange="CalcularSiguienteFecha();" value="#vCampoPos13_a#" size="1" maxlength="1" onkeypress="return MascaraEntrada(event, '9');">
                                                <span class="Sans9Gr">
                                                    #ctMovimiento.mov_pos13_a#
                                            </span>
                                            </span>
                                            <span <cfif #vCampoPos13_m# EQ 0>class="NoImprimir"</cfif>>
												<cfinput type="text" name="pos13_m" disabled='#vActivaCampos#' class="datos" id="pos13_m" onChange="CalcularSiguienteFecha();" value="#vCampoPos13_m#" size="2" maxlength="2" onkeypress="return MascaraEntrada(event, '99');">
                                                <span class="Sans9Gr">
                                                    #ctMovimiento.mov_pos13_m#
                                            </span>
                                            </span>
                                            <span
                                                <cfif #vCampoPos13_d# EQ 0>class="NoImprimir"</cfif>>
                                                <cfinput type="text" name="pos13_d" disabled='#vActivaCampos#' class="datos" id="pos13_d" onChange="CalcularSiguienteFecha();" value="#vCampoPos13_d#" size="2" maxlength="2" onkeypress="return MascaraEntrada(event, '99');">
                                                <span class="Sans9Gr">
                                                    #ctMovimiento.mov_pos13_d#
                                            </span>
                                            </span>
                                        </cfif>
                                        <!-- Fechas -->
                                        <span class="Sans9Gr">#ctMovimiento.mov_pos14#</span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos14)#&nbsp;</span>
                                        <cfelse>
                                            <cfinput type="text" name="pos14" disabled='#vActivaCampos#' class="datos" id="pos14" onChange="CalcularSiguienteFecha();" value="#vCampoPos14#" size="10" maxlength="10" onkeypress="return MascaraEntrada(event, '99/99/9999');" onBlur="ObtenerNoContratos();">
                                        </cfif>
                                        <span class="Sans9Gr">#ctMovimiento.mov_pos15#</span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos15)#</span>
                                        <cfelse>
                                            <cfinput onclick="pos15.value=''" name="pos15" type="text" class="datos" id="pos15" size="10" maxlength="10" disabled value="#vCampoPos15#">
                                        </cfif>
                                    </td>
                                </tr>
<!--- ELIMINAR 10/10/2019
                                <!-- Duración de la cátedra -->
                                <tr>
                                    <td width="20%"><span class="Sans9GrNe">#ctMovimiento.mov_pos13#</span></td>
                                    <td width="80%">
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
--->								
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
                                <!-- Nombre del responsable técnico -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos12#</span></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoPos12_txt#</span>
                                        <cfelse>
                                            <cfinput name="pos12_txt" id="pos12_txt" class="datos" type="text" size="100" maxlength="254" value="#vCampoPos12_txt#" disabled='#vActivaCampos#' autocomplete="off" onKeyUp="fObtenerAcademicos('pos12_txt','academico_dynamic','pos12')" style="width:450px"  placeholder="Escriba el nombre del asesor y seleccione del menú que se despliega (NO COPIAR Y PEGAR)...">
                                            <cfinput name="pos12" id="pos12" type="hidden" value="#vCampoPos12#">
                                            <br>
                                            <div id="academico_dynamic" style="position:absolute;display:block;"></div>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Categoría y nivel del responsable técnico -->
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
                                <!-- Controles dinámicos -->
                                <tr>
                                    <td colspan="2" id="catedras_dynamic">
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <cfset vCcnActual='#vCampoPos8#'>
                                            <cfset vDepClave='#vCampoPos1#'>
                                            <cfinclude template="ft_ajax/lista_numero_catedras.cfm">
                                        <cfelse>
                                            <!-- AJAX: Contratos anteriores -->
                                        </cfif>
                                    </td>
                                </tr>
        <!---
                                <cfif #Session.sTipoSistema# IS 'stctic'>
                                    <!-- ¿Ha tenido antes otras cátedras?   -->
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
                                                <cfinput name="pos12_o" id="pos12_o" type="hidden" value="#vCampoPos12#">
                                                <br>
                                                <div id="becario_dynamic" style="position:absolute; display:block;"></div>
                                            </cfif>
                                        </td>
                                    </tr>
                                </cfif>
        --->
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
                                <!-- Opinión del comisión dictaminadora -->
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
                                            <cfinput name="pos31" type="checkbox" id="pos31" value="Si" checked="#Iif(vCampoPos31 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>
                                        </div>
                                    </td>
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
                                <!-- Carta del responsable técnico -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos32#</span></td>
                                    <td><div align="center"><cfinput name="pos32" type="checkbox" id="pos32" value="Si" checked="#Iif(vCampoPos32 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Programa de actividades -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos34#</span></td>
                                    <td><div align="center"><cfinput name="pos34" type="checkbox" id="pos34" value="Si" checked="#Iif(vCampoPos34 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
        <!---
                                <!-- Informe anual de actividades -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos35#</span></td>
                                    <td><div align="center"><cfinput name="pos35" type="checkbox" id="pos35" value="Si" checked="#Iif(vCampoPos35 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
        --->
                                <!-- Curriculum vitae -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos36#</span></td>
                                    <td><div align="center"><cfinput name="pos36" type="checkbox" id="pos36" value="Si" checked="#Iif(vCampoPos36 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
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
