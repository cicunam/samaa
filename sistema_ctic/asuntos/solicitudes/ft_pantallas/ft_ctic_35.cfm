<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA CREA: 20/04/2009 --->
<!--- FECHA ÚLTIMA MOD.: 03/11/2016 --->
<!--- FT-CTIC-35.-Recurso de revisión de los concursos de opocosión --->

<!--- Incluir los siguientes archivos --->
<cfif #vTipoComando# EQ 'IMPRIME_EJEMPLO'>
	<cfinclude template="ft_campos_blanco.cfm"> <!---PERIMITE IMPRIMIR LA FT EN BLANCO --->
	<cfset vTipoComando = 'IMPRIME'>
<cfelse>
	<cfinclude template="ft_campos.cfm">
</cfif>

<cfinclude template="ft_scripts_valida.cfm">
<cfinclude template="ft_scripts_ajax.cfm">
<cfinclude template="ft_scripts_varios.cfm">

<!--- Asignar valor campo Pos12 (que contiene el asunto relacionado) --->
<cfif #vCampoPos12# EQ ''>
	<cfset vCampoPos12='#vIdMovRel#'>
</cfif>


<!--- Obtener la lista de ubicaciones de la entidad  (CATÁLOGOS GENERALES MYSQL) --->
<cfquery name="ctUbicacion" datasource="#vOrigenDatosCATALOGOS#">
	SELECT *, CONCAT(TRIM(ubica_nombre),  ', ', TRIM(ubica_lugar)) AS ubica_completa
	FROM catalogo_dependencias_ubica
	WHERE dep_clave = '#vCampoPos1#' 
	AND ubica_status = 1
	ORDER BY ubica_clave
</cfquery>

<!--- Obtener datos del movimiento relacionado --->
<cfquery name="tbMovimientoRel" datasource='#vOrigenDatosSAMAA#'>
	SELECT *
	FROM movimientos AS T1 
    INNER JOIN catalogo_movimiento AS T2 ON T1.mov_clave = T2.mov_clave
	WHERE T1.mov_id = #vCampoPos12#
</cfquery>

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
	<body>

		<!--- Ventanas emergentes
		<div id="ListaMovimientos" title="Historia de movimientos" style="background-color:#fafafa; display:none;"></div>
		 --->
		<!--- IFRAME PARA EL ENVIO DE DOCUMENTOS DIGITALIZADOS (PDF)
		<iframe scrolling="no" class="EmergenteArchivo" frameborder="no" name="ifrmSelArchivo" id="ifrmSelArchivo" src="enviar_pdf/ft_archivo_selecciona.cfm?&vIdSol=<cfoutput>#vIdSol#</cfoutput>" style="display:none;"></iframe>
		 --->		
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
                        <cfoutput>
                            <!-- Datos obtenidos por el sistema -->
                            <table border="0" class="cuadrosFormularios">
                                <!-- Categoría y nivel -->
                                <tr>
                                    <td width="25%"><span class="Sans9GrNe">#ctMovimiento.mov_pos3#</span></td>
                                    <td width="75%">
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoPos3_txt#</span>
                                        <cfelse>
                                            <cfinput name="pos3_txt" id="pos3_txt" type="text" class="datos" size="20" value="#vCampoPos3_txt#" disabled>
                                            <cfinput name="pos3" id="pos3" type="hidden" value="#vCampoPos3#">
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Tipo de contrato -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos5# </span></td>
                                    <td>
                                        <span class="Sans9Gr">
                                            <cfinput type="radio" name="pos5" id="pos5_i" value="2" checked="#Iif(vCampoPos5 EQ "2",DE("yes"),DE("no"))#" disabled>Concurso Abierto&nbsp;
                                            <cfinput type="radio" name="pos5" id="pos5_d" value="1" checked="#Iif(vCampoPos5 EQ "1",DE("yes"),DE("no"))#" disabled>Definitivo&nbsp;
                                            <cfinput type="radio" name="pos5" id="pos5_o" value="3" checked="#Iif(vCampoPos5 EQ "3",DE("yes"),DE("no"))#" disabled>Obra determinada
                                        </span>
                                    </td>
                                </tr>
                                <!-- Antigüedad -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos6#</span></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoPos6_txt#</span>
                                        <cfelse>
                                            <cfinput name="pos6_txt" id="pos6_txt" type="text" class="datos" size="30" value="#vCampoPos6_txt#" disabled>
                                            <cfinput name="pos6" id="pos6" type="hidden" value="#vCampoPos6#">
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Primer contrato -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos7#</span></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos7)#</span>
                                        <cfelse>
                                            <cfinput name="pos7" id="pos7" type="text" class="datos" size="10" value="#vCampoPos7#" disabled>
                                        </cfif>
                                    </td>
                                </tr>
                            </table>
                        </cfoutput>
                        <!-- Datos que deben ingresarse -->
                        <cfoutput>
                            <table border="0" class="cuadrosFormularios">
                                <!-- Asunto a revisar -->
                                <tr>
                                    <!---
                                    <td>
                                        <cfinput name="pos12" type="radio" value="Concurso Abierto" checked="#Iif(vCampoPos12 EQ "Concurso Abierto",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>
                                        <span class="Sans9Gr">Concurso Abierto</span>
                                        <cfinput name="pos12" type="radio" value="Definitividad" checked="#Iif(vCampoPos12 EQ "Definitividad",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>
                                        <span class="Sans9Gr">Definitividad</span>
                                        <cfinput name="pos12" type="radio" value="Promocion" checked="#Iif(vCampoPos12 EQ "Promocion",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>
                                        <span class="Sans9Gr">Promoci&oacute;n</span>
                                    </td>
                                    --->
                                    <td width="25%"><span class="Sans9GrNe">#ctMovimiento.mov_pos12#</span></td>
                                    <td width="75%">
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#Ucase(tbMovimientoRel.mov_titulo)#</span>
                                        <cfelse>
                                            <input type="text" class="datos100" value="#Ucase(tbMovimientoRel.mov_titulo)#" disabled>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Duración -->
                                <tr>
                                    <cfif #tbMovimientoRel.mov_fecha_final# EQ '' OR #tbMovimientoRel.mov_fecha_final# EQ #tbMovimientoRel.mov_fecha_inicio#>
                                        <td>
                                            <span class="Sans9GrNe">
                                                <cfif #tbMovimientoRel.mov_clave# EQ 22>
                                                    Diferir&nbsp;
                                                <cfelse>
                                                    A partir del&nbsp;
                                                </cfif>
                                            </span>
                                        </td>
                                        <td>
                                            <!-- Fecha -->
                                            <span class="Sans9Gr">
                                                <cfif #tbMovimientoRel.mov_clave# EQ 22>De la fecha</cfif>
                                            </span>
                                            <cfif #vTipoComando# IS 'IMPRIME'>
                                                <span class="Sans9Gr">#FechaCompleta(tbMovimientoRel.mov_fecha_inicio)#&nbsp;</span>
                                            <cfelse>
                                                <input id="pos14_dice" type="text" class="datos" size="10" maxlength="10" value="#LsDateFormat(tbMovimientoRel.mov_fecha_inicio,'dd/mm/yyyy')#" disabled>
                                            </cfif>
                                            <span class="Sans9Gr" id="pos14_txt">
                                                <cfif #tbMovimientoRel.mov_clave# EQ "22">al término de su cargo/nombramiento.</cfif>
                                            </span>
                                        </td>
                                    <cfelse>
                                        <td>
                                            <span class="Sans9GrNe">
                                                <cfif #tbMovimientoRel.mov_clave# EQ 22>
                                                    Diferir&nbsp;
                                                <cfelse>
                                                    Duración&nbsp;
                                                </cfif>
                                            </span>
                                        </td>
                                        <td>
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
                                                <cfif #vTipoComando# IS 'IMPRIME'>
                                                    <span <cfif #vAnios# EQ 0>class="NoImprimir"</cfif>><span class="Sans9Gr">#vAnios# a&ntilde;os&nbsp;</span></span>
                                                    <span <cfif #vMeses# EQ 0>class="NoImprimir"</cfif>><span class="Sans9Gr">#vMeses# mes(es)&nbsp;</span></span>
                                                    <span <cfif #vDias# EQ 0>class="NoImprimir"</cfif>><span class="Sans9Gr">#vDias# d&iacute;a(s)&nbsp;</span></span>
                                                <cfelse>
                                                    <input type="text" class="datos" size="1" maxlength="1" value="#vAnios#" disabled>
                                                    <span class="Sans9Gr">año(s)</span>
                                                    <input type="text" class="datos" size="2" maxlength="2" value="#vMeses#" disabled>
                                                    <span class="Sans9Gr">mes(es)</span>
                                                    <input type="text" class="datos" size="2" maxlength="2" value="#vDias#" disabled>
                                                    <span class="Sans9Gr">d&iacute;a(s)</span>
                                                </cfif>
                                            </cfif>
                                            <!-- Fechas -->
                                            <span class="Sans9Gr">
                                                <cfif #tbMovimientoRel.mov_clave# EQ 22>
                                                    De la fecha&nbsp;
                                                <cfelse>
                                                    del&nbsp;
                                                </cfif>
                                            </span>
                                            <cfif #vTipoComando# IS 'IMPRIME'>
                                                <span class="Sans9Gr">#FechaCompleta(tbMovimientoRel.mov_fecha_inicio)#&nbsp;</span>
                                            <cfelse>
                                                <input type="text" class="datos" size="10" maxlength="10" value="#LsDateFormat(tbMovimientoRel.mov_fecha_inicio,'dd/mm/yyyy')#" disabled>
                                            </cfif>
                                            <span class="Sans9Gr">
                                                <cfif #tbMovimientoRel.mov_clave# EQ 22>
                                                    a la fecha&nbsp;
                                                <cfelse>
                                                    al&nbsp;
                                                </cfif>
                                            </span>
                                            <cfif #vTipoComando# IS 'IMPRIME'>
                                                <span class="Sans9Gr">#FechaCompleta(tbMovimientoRel.mov_fecha_final)#</span>
                                            <cfelse>
                                                <input type="text" class="datos" size="10" maxlength="10" value="#LsDateFormat(tbMovimientoRel.mov_fecha_final,'dd/mm/yyyy')#" disabled>
                                            </cfif>
                                        </td>
                                    </cfif>
                                </tr>
                            </table>
                        </cfoutput>
                        <!-- Dicatámenes -->
                        <cfoutput>
                            <table border="0" class="cuadrosFormularios">
                                <!-- Encabezados -->
                                <tr bgcolor="##CCCCCC">
                                    <td width="65%"></td>
                                    <td width="20%"><div align="center" class="Sans10NeNe">Aprobatorio</div></td>
                                    <td width="15%"><div align="center" class="Sans10NeNe">Se anexa</div></td>
                                </tr>
                                <!-- Copia del dictámen de la comisión -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos30#</span></td>
                                    <!-- Si/no -->
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
                                <!-- Copia del oficio enviado por el CTIC -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos33#</span></td>
                                    <td><div align="center"><cfinput name="pos33" type="checkbox" id="pos33" value="Si" checked="#Iif(vCampoPos33 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Carta del director -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos29#</span></td>
                                    <td><div align="center"><cfinput name="pos29" type="checkbox" id="pos29" value="Si" checked="#Iif(vCampoPos29 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Carta del interesado solicitando el recurso de revisión, dirigida al Director de la dependencia -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos32#</span></td>
                                    <td><div align="center"><cfinput name="pos32" type="checkbox" id="pos32" value="Si" checked="#Iif(vCampoPos32 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Carta del interesado nombrando a su representante, dirigida al Director de la dependencia -->
                                <tr>
                                    <td><p><span class="Sans9GrNe">#ctMovimiento.mov_pos34#</span></p></td>
                                    <td><div align="center"><cfinput name="pos34" type="checkbox" id="pos34" value="Si" checked="#Iif(vCampoPos34 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Carta de aceptación del representante -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos35#</span></td>
                                    <td><div align="center"><cfinput name="pos35" type="checkbox" id="pos35" value="Si" checked="#Iif(vCampoPos35 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Carta del director informando el nombre del representante de la Comisión Dictaminadora -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos37#</span></td>
                                    <td><div align="center"><cfinput name="pos37" type="checkbox" id="pos37" value="Si" checked="#Iif(vCampoPos37 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Curriculum vitae -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos36#</span></td>
                                    <td><div align="center"><cfinput name="pos36" type="checkbox" id="pos36" value="Si" checked="#Iif(vCampoPos36 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Publicaciones -->
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
