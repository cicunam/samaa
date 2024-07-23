<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 13/02/2014 --->
<!--- FECHA ÚLTIMA MOD.: 19/01/2023 --->
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
            
			function CalcularPeriodoInforme(vPos10, vpTipoComando)
			{
                //alert(vPos10);
                $.ajax({
                    async: false,
                    url: "ft_ajax/informe_becaposdoc_fechas.cfm",
                    type:'POST',
                    data: {vpAcdId: $('#pos2').val(), vpPos10: vPos10, vpTipoComando: vpTipoComando},
                    dataType: 'html',
                    success: function(data, textStatus) {
                        //alert(data);
                        $('#periodo_informar_dynamic').html(data);
                    },
                    error: function(data) {
                        alert('ERROR AL CARGAR EL PERIODO A INFORMAR');
                        //location.reload();
                    },
                });
			}
		</script>
	</head>
        <body onload="<cfoutput>CalcularPeriodoInforme(#vCampoPos10#, '#vTipoComando#');</cfoutput>">
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
                                <!-- Tipo de informe -->
                                <tr>
                                    <td width="20%"><span class="Sans9GrNe">Tipo de informe</span></td>
                                    <td width="80%">
                                        <!--- YA NO SE REPORTA INFORME SEMESTRAL Y ANUAL (02/06/2022) A SOLICITUD DE LA STCTIC
										<cfinput name="pos10" id="pos10_6" type="radio" value="6" checked="#Iif(vCampoPos10 EQ "6",DE("yes"),DE("no"))#" disabled='#vActivaCampos#' onClick="CalcularSiguienteFechaInforme()"><span class="Sans9Gr">Semestral</span>
										<cfinput name="pos10" id="pos10_12" type="radio" value="12" checked="#Iif(vCampoPos10 EQ "12",DE("yes"),DE("no"))#" disabled='#vActivaCampos#' onClick="CalcularPeriodoInforme(12, '#vTipoComando#');"><span class="Sans9Gr">Anual </span>
                                        --->
										<cfinput name="pos10" id="pos10_24" type="radio" value="24" checked="#Iif(vCampoPos10 EQ "24",DE("yes"),DE("no"))#" disabled='#vActivaCampos#' onClick="CalcularPeriodoInforme(24, '#vTipoComando#');"><span class="Sans9Gr">Informe final</span>
										<cfinput name="pos10" id="pos10_14" type="radio" value="14" checked="#Iif(vCampoPos10 EQ "14",DE("yes"),DE("no"))#" disabled='#vActivaCampos#' onClick="CalcularPeriodoInforme(14, '#vTipoComando#');"><span class="Sans9Gr">Renuncia </span>                                            
                                    </td>
                                </tr>
                                <!-- Periodo a reportar -->
                                <tr>
                                    <td width="20%"><span class="Sans9GrNe">#ctMovimiento.mov_pos13#</span></td>
                                    <td width="80%">
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <!-- Fechas -->
                                            <span class="Sans9Gr">#ctMovimiento.mov_pos14#</span>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos14)#&nbsp;</span>
                                            <span class="Sans9Gr">#ctMovimiento.mov_pos15#&nbsp;</span>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos15)#</span>
                                        <cfelse>
                                            <div id="periodo_informar_dynamic"><!--- DIV PARA INSERTAR AJAX ---></div>
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
                                <tr id="trInformeActividad">
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos34#</span></td>
                                    <td><div align="center"><cfinput name="pos34" type="checkbox" id="pos34" value="Si" checked="#Iif(vCampoPos34 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Carta de agredecimiento al programa (Agregado el 23/02/2023) -->
                                <tr id="trInformeActividad">
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos35#</span></td>
                                    <td><div align="center"><cfinput name="pos35" type="checkbox" id="pos35" value="Si" checked="#Iif(vCampoPos35 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
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
