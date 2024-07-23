<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA CREA: 13/04/2009 --->
<!--- FECHA ÚLTIMA MOD.: 27/10/2022 --->
<!--- FT-CTIC-37.-Recurso de reconsideración --->

<!--- Incluir los siguientes archivos --->
<cfif #vTipoComando# EQ 'IMPRIME_EJEMPLO'>
	<cfinclude template="ft_campos_blanco.cfm"> <!---PERIMITE IMPRIMIR LA FT EN BLANCO --->
	<cfset vTipoComando = 'IMPRIME'>
<cfelse>
	<cfinclude template="ft_campos.cfm">
</cfif>

<!--- Asignar valor campo Pos12 (que contiene el asunto relacionado) --->
<cfif #vCampoPos12# EQ ''>
	<cfset vCampoPos12 = #vIdMovRel#>
</cfif>

<cfif #vCampoPos12_o# EQ ''>
	<cfset vCampoPos12_o = #vTipoMovRel#>
</cfif>

<!--- Obtener la lista de ubicaciones de la entidad  (CATÁLOGOS GENERALES MYSQL) --->
<cfquery name="ctUbicacion" datasource="#vOrigenDatosCATALOGOS#">
	SELECT *, CONCAT(TRIM(ubica_nombre),  ', ', TRIM(ubica_lugar)) AS ubica_completa
	FROM catalogo_dependencias_ubica
	WHERE dep_clave = '#vCampoPos1#' 
	AND ubica_status = 1
	ORDER BY ubica_clave
</cfquery>

<cfif #vCampoPos12_o# EQ 'INF'>
	<!--- Obtener datos del informe relacionado --->
    <cfquery name="tbInformeRel" datasource='#vOrigenDatosSAMAA#'>
        SELECT T1.informe_anio 
        FROM movimientos_informes_anuales AS T1
        LEFT JOIN movimientos_informes_asunto AS T2 ON T1.informe_anual_id = T2.informe_anual_id
        LEFT JOIN catalogo_decision AS C1 ON T2.dec_clave = C1.dec_clave
        WHERE T1.informe_anual_id = #vCampoPos12#
        AND T2.informe_reunion = 'CTIC'
    </cfquery>
<cfelseif #vCampoPos12_o# EQ 'MOV'>
	<!--- Obtener datos del movimiento relacionado --->
    <cfquery name="tbMovimientoRel" datasource='#vOrigenDatosSAMAA#'>
        SELECT *
        FROM movimientos AS T1
        INNER JOIN catalogo_movimiento AS C1 ON T1.mov_clave = C1.mov_clave
        WHERE T1.mov_id = #vCampoPos12#
    </cfquery>
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
                        <!-- INCLUDE para visualisar Información Académica -->
                        <cfinclude template="ft_include_datos_academicos.cfm">
                        <!-- Datos que deben ingresarse -->
                        <cfoutput>
                            <table border="0" class="cuadrosFormularios">
                                <!-- Asunto a reconsiderar -->
                                <tr>
                                    <td colspan="2">
                                        <span class="Sans9GrNe">#ctMovimiento.mov_pos12#</span>
                                        <!--- INPUT HIDDEN pra identificas el ID del movimiento/informe anual relacionado --->
            	                        <cfinput type="#vTipoInput#" id="pos12" name="pos12" value="#vCampoPos12#">
                                        <!--- INPUT HIDDEN para identificar si es movimiento o informe anual --->
                                        <cfinput type="#vTipoInput#" id="pos12_o" name="pos12_o" value="#vCampoPos12_o#">
                                    </td>
                                </tr>
							    <cfif #vCampoPos12_o# EQ 'INF'>
                                    <tr>
                                        <td width="20%"></td>
                                        <td width="80%">
					                        <!-- Movimiento relacionado -->
                                            <cfif #vTipoComando# IS 'IMPRIME'>
                                                <span class="Sans9Gr">INFORME ANUAL #tbInformeRel.informe_anio#</span>
                                            <cfelse>
                                                <input type="text" class="datos100" value="INFORME ANUAL #tbInformeRel.informe_anio#" disabled>
                                            </cfif>
                                        </td>
                                    </tr>
    							<cfelseif #vCampoPos12_o# EQ 'MOV'>
                                    <tr>
                                        <td width="20%"></td>
                                        <td width="80%">
                                            <cfif #vTipoComando# IS 'IMPRIME'>
                                                <span class="Sans9Gr">#Ucase(tbMovimientoRel.mov_titulo)#</span>
                                            <cfelse>
                                                <input type="text" class="datos100" value="#tbMovimientoRel.mov_titulo#" disabled>
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
                                                    <input id="pos14" name="pos14" type="text" class="datos" size="10" maxlength="10" value="#LsDateFormat(tbMovimientoRel.mov_fecha_inicio,'dd/mm/yyyy')#" disabled>
                                                </cfif>
                                                <span class="Sans9Gr" id="pos14_txt">
                                                    <cfif #tbMovimientoRel.mov_clave# EQ "22">al término de su cargo/nombramiento.</cfif>
                                                </span>
                                            </td>
                                        <cfelse>
                                            <td>
                                                <span class="Sans9GrNe">
                                                    <cfif #tbMovimientoRel.mov_clave# EQ 22>
                                                        Diferir
                                                    <cfelse>
                                                        Duración
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
                                                    <input id="pos14" name="pos14" type="text" class="datos" size="10" maxlength="10" value="#LsDateFormat(tbMovimientoRel.mov_fecha_inicio,'dd/mm/yyyy')#" disabled>
                                                </cfif>
                                                <span class="Sans9Gr">
                                                    <cfif #tbMovimientoRel.mov_clave# EQ 22>
                                                        a la fecha
                                                    <cfelse>
                                                        al
                                                    </cfif>
                                                </span>
                                                <cfif #vTipoComando# IS 'IMPRIME'>
                                                    <span class="Sans9Gr">#FechaCompleta(tbMovimientoRel.mov_fecha_final)#</span>
                                                <cfelse>
                                                    <input id="pos15" name="pos15" type="text" class="datos" size="10" maxlength="10" value="#LsDateFormat(tbMovimientoRel.mov_fecha_final,'dd/mm/yyyy')#" disabled>
                                                </cfif>
                                            </td>
                                        </cfif>
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
                                <!-- Opición del CTIC -->
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
                            </table>
                        </cfoutput>
                        <!-- Documentación -->
                        <cfoutput>
                            <table border="0" class="cuadrosFormularios">
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
                                <!-- Carta del interesado -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos32#</span></td>
                                    <td><div align="center"><cfinput name="pos32" type="checkbox" id="pos32" value="Si" checked="#Iif(vCampoPos32 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Fundamentación del recurrente -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos34#</span></td>
                                    <td><div align="center"><cfinput name="pos34" type="checkbox" id="pos34" value="Si" checked="#Iif(vCampoPos34 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
								<cfif #vCampoPos12_o# EQ 'MOV' AND (#tbMovimientoRel.mov_clave# NEQ 40 AND #tbMovimientoRel.mov_clave# NEQ 41)>
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
								<cfelseif #vCampoPos12_o# EQ 'INF'>
                                    <!-- Programa de trabajo -->
                                    <tr>
                                        <td><span class="Sans9GrNe">#ctMovimiento.mov_pos37# #tbInformeRel.informe_anio#</span></td>
                                        <td><div align="center"><cfinput name="pos37" type="checkbox" id="pos37" value="Si" checked="#Iif(vCampoPos37 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                    </tr>
                                    <!-- Informe anual de actividades  -->
                                    <tr>
                                        <td><span class="Sans9GrNe">#ctMovimiento.mov_pos38# #tbInformeRel.informe_anio#</span></td>
                                        <td><div align="center"><cfinput name="pos38" type="checkbox" id="pos38" value="Si" checked="#Iif(vCampoPos38 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                    </tr>                                
								</cfif>
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
