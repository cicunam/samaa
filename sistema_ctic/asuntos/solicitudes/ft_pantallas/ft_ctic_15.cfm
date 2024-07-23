<!--- CREADO: ARAM PICHARDO--->
<!--- EDITO: ARAM PICHARDO--->
<!--- FECHA CREA: 05/06/2009--->
<!--- FECHA ÚLTIMA MOD.: 19/07/2024 --->
<!--- FT-CTIC-15.-Concurso Desierto--->

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

<!--- Obtener datos del catálogo de nombramiento (CATÁLOGOS GENERALES MYSQL) --->
<cfquery name="ctCategoria" datasource="#vOrigenDatosCATALOGOS#">
	SELECT * FROM catalogo_cn 
    WHERE cn_status = 1 
    ORDER BY cn_orden DESC
</cfquery>

<html>
	<head>
		<!-- INCLUDE que agrega parte del contenido del encabezado -->
		<cfinclude template="ft_include_head_comun.cfm">

		<!-- INCLUDE con JAVASCRIPT de uso común con FT 5, 15 Y 42  -->
		<cfinclude template="ft_scripts_coas.cfm">
            
		<!-- JAVASCRIPT de uso local -->
		<script type="text/javascript">
			// Validar los datos ingresados por el usuario:
			function fValidaCamposFt()
			{
				var vMensaje = '';
				fLimpiaValida();
				vMensaje += fValidaCampoLleno('pos1_u','UBICACIÓN');
				vMensaje += fValidaCampoLleno('memo2','MOTIVO POR EL QUE SE DECLARA DESIERTO EL CONCURSO');
				// if (document.getElementById('pos17').value == '0' || document.getElementById('pos17').value == '') vMensaje += "Hace falta agregar CONCURSANTES a la lista.\n";
				// vMensaje += fValidaFecha('pos12','A PARTIR DEL');
				// Desplegar los mensajes de error encontrados en la forma, si existen:
				if (vMensaje.length > 0)
				{
					alert(vMensaje);
					return false;
				}
				else
				{
                    //alert(parseInt($('#NumConcursa').val());
                    $('#pos17').val(parseInt($('#NumConcursa').val()));
					return true;
				}
			}            
		</script>
	</head>
	<body onLoad="fOnloadPantalla();">
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
                            
                        <!-- Otros datos que deben ingresarse -->
                        <cfoutput>
                            <table border="0" class="cuadrosFormularios">
                                <!-- Número de plaza de la convocatoria -->
                                <tr>
                                    <td width="20%"><span class="Sans9GrNe">#ctMovimiento.mov_pos9# </span></td>
                                    <td width="80%">
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#tbConvocatorias.coa_no_plaza#</span>
                                        <cfelse>
                                            <!--- NOTA: Como en en lase de vCampoPos1 inicializar al principio si no tiene datos --->
                                            <cfinput type="text" name="pos9" value="#tbConvocatorias.coa_no_plaza#" size="9" maxlength="8" class="datos" id="pos9" disabled>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Categoría y nivel de la convocatoria -->
                                <tr>
                                    <td colspan="2">
                                        <span class="Sans9GrNe">#ctMovimiento.mov_pos8#&nbsp;</span>
                                        <cfinput name="pos23" id="pos23" type="hidden" value="#vCampoPos23#">
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoPos8_txt#</span>
                                        <cfelse>
                                            <cfselect name="pos8" class="datos" id="pos8" query="ctCategoria" queryPosition="below" value="cn_clave" display="cn_siglas" selected="#tbConvocatorias.cn_clave#" disabled>
                                                <option value="" selected>SELECCIONE</option>
                                            </cfselect>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Fecha en que salió publicada la convocatoria en gaceta -->
                                <tr>
                                    <td colspan="2" valign="top">
                                        <span class="Sans9GrNe">#ctMovimiento.mov_pos21#&nbsp;</span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos21)#</span>
                                        <cfelse>
                                            <cfinput name="pos21" type="text" class="datos" id="pos21" size="10" maxlength="10" disabled value="#LsDateFormat(tbConvocatorias.coa_gaceta_fecha,'dd/mm/yyyy')#">
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- En el área -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_memo1#</span></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#Ucase(tbConvocatorias.coa_area)#</span>
                                        <cfelse>
                                            <cftextarea name="memo1" rows="5" class="datos100" id="memo1" disabled value="#Ucase(tbConvocatorias.coa_area)#"></cftextarea>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Motivo por el que se declara desierto el concurso -->
                                <tr>
                                    <td colspan="2">
                                        <div align="left"><span class="Sans9GrNe">#ctMovimiento.mov_memo2#</span><br></div>
                                    </td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoMemo2#</span>
                                        <cfelse>
                                            <cftextarea name="memo2" rows="5" disabled='#vActivaCampos#' class="datos100" id="memo2" value="#vCampoMemo2#"></cftextarea>
                                        </cfif>
                                    </td>
                                </tr>
                            </table>
                        </cfoutput>
                                        
                        <!--- Tabla para listara los oponentes --->
                        <table border="0" class="cuadrosFormularios">
                            <!-- Titulo del recuadro -->
                            <tr bgcolor="#CCCCCC" width="25px"ss>
                                <td align="center">
                                    <span class="Sans9GrNe">CONCURSANTE(S)</span>
                                </td>
                            </tr>
                            <tr>
                                <td align="center">
                                    <cfif #vTipoComando# IS 'IMPRIME'>
                                        <cfset vpSolId = #vIdSol#>
                                        <cfset vpCoaId = #vCampoPos23#>
                                        <cfset vActivaCampos = 'disabled'>
                                        <cfinclude template="ft_ajax/coa_lista_oponentes.cfm">
                                    <cfelse>
                                        <div id="oponentes_dynamic"><!-- AJAX: Lista oponentes --></div>
                                    </cfif>
                                </td>                                
                            </tr>
                        </table>
                        <!--- Tabla para listara las solicitudes registradas en convocatoria COA --->
                        <cfif #vTipoComando# IS 'EDITA' OR #vTipoComando# IS 'NUEVO'>
                            <table border="0" class="cuadrosFormularios">
                                <!-- Titulo del recuadro -->
                                <tr bgcolor="#CCCCCC" width="25px"ss>
                                    <td align="center"><span class="Sans9GrNe">SOLICITUDES REGISTRADAS, RECIBIDAS EN LA ENTIDAD Y QUE SE ENVIÓ ACUSE DE RECIBO</span></td>
                                </tr>
                                <tr>
                                    <td align="center"><div id="solicitudescoa_dynamic"><!-- AJAX: Lista solicitudes COA --></div></td>
                                </tr>
                            </table>
                        </cfif>
                        <!-- Número de concursantes -->
                        <cfoutput>
                            <table border="0" class="cuadrosFormularios">
                                <tr>
                                    <td width="35%"class="Sans9GrNe">#ctMovimiento.mov_pos17#</td>
                                    <td width="65%">
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#NumberFormat(vCampoPos17,"99")#</span>
                                        <cfelse>
                                            <cfinput name="pos17" id="pos17" type="text" class="datos" value="#LsNumberFormat(vCampopos17,99)#" size="2" maxlength="2" disabled>
                                        </cfif>
                                    </td>
                                </tr>
                            </table>
                        </cfoutput>
						<!-- Documentación -->
						<!--- Llamado a INCLUDE general de los anexos requeridos en la FT 19/07/2024 --->
						<cfinclude template="ft_include_anexoAnexos.cfm">
<!---
                        <cfoutput>
                            <table border="0" class="cuadrosFormularios">
                                <tr bgcolor="##CCCCCC">
                                    <td width="85%"></td>
                                    <td width="15%"><div align="center" class="Sans10NeNe">Se anexa</div></td>
                                </tr>
                                <!-- Dictamen de la Comisión Dictaminadora -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos31#</span></td>
                                    <td>
                                        <div align="center">
                                            <cfinput name="pos31" type="checkbox" id="pos31" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos31 EQ 'Si',DE("yes"),DE("no"))#">
                                        </div>
                                    </td>
                                </tr>
                                <!-- Carta del director -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos29#</span></td>
                                    <td>
                                        <div align="center">
                                            <cfinput name="pos29" type="checkbox" id="pos29" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos29 EQ 'Si',DE("yes"),DE("no"))#">
                                        </div>
                                    </td>
                                </tr>
                                <!-- Convocatoria publicada en Gaceta UNAM -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos35#</span></td>
                                    <td>
                                        <div align="center">
                                            <cfinput name="pos35" type="checkbox" id="pos35" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos35 EQ 'Si',DE("yes"),DE("no"))#">
                                        </div>
                                    </td>
                                </tr>
                                <!-- Curriculum vitae del (los) concursante(s) -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos36#</span></td>
                                    <td>
                                        <div align="center">
                                            <cfinput name="pos36" type="checkbox" id="pos36" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos36 EQ 'Si',DE("yes"),DE("no"))#">
                                        </div>
                                    </td>
                                </tr>
                                <!-- Prueba del (los) concursantes(s) -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos37#</span></td>
                                    <td>
                                        <div align="center">
                                            <cfinput name="pos37" type="checkbox" id="pos37" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos37 EQ 'Si',DE("yes"),DE("no"))#">
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
