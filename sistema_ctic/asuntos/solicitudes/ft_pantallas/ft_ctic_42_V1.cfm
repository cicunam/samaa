<!--- CREADO: ARAM PICHARDO--->
<!--- EDITO: ARAM PICHARDO--->
<!--- FECHA: 05/06/2009--->
<!--- FECHA ÚLTIMA MOD.: 30/06/2016 --->
<!--- FT-CTIC-42.-Nuevo dictamen de Concurso Desierto--->

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

<!--- Obtener datos del catálogo de nombramiento --->
<cfquery name="ctCategoria" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_cn 
    WHERE cn_status = 1 
    ORDER BY cn_orden
</cfquery>

<html>
	<head>
		<!-- INCLUDE que agrega parte del contenido del encabezado -->
		<cfinclude template="ft_include_head_comun.cfm">
		<!-- JAVA SCRIT de uso local -->
		<script type="text/javascript">
			// Registrar el académico seleccionado por el usuario:
			function fSeleccionaAcad(vRegreso)
			{
				// Registrar el académico seleccionado por el usuario:
				document.getElementById('filtraacademico').value = document.getElementById('selAcadLista').options[document.getElementById('selAcadLista').selectedIndex].text;
				document.getElementById('idOponente').value = document.getElementById('selAcadLista').value;
				// Si el usuario selecciona NUEVO OPONENTE entonces mostrar el formulario para agregarlo:
				if (document.getElementById('selAcadLista').value == 'NUEVO')
				{
					fMostrarFormulario(true);
				}
				document.getElementById('academico_dynamic').innerHTML = '';
			}

			// Validar los datos ingresados por el usuario:
			function fValidaCamposFt()
			{
				var vMensaje = '';
				fLimpiaValida();
				vMensaje += fValidaCampoLleno('pos1_u','UBICACIÓN');
				vMensaje += fValidaCampoLleno('memo2','MOTIVO POR EL QUE SE DECLARA DESIERTO EL CONCURSO');
				if (document.getElementById('pos17').value == '0' || document.getElementById('pos17').value == '') vMensaje += "Hace falta agregar CONCURSANTES a la lista.\n";
				// Desplegar los mensajes de error encontrados en la forma, si existen:
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
	<body onLoad="fAgregarOponente('CONSULTA', 0)">
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
                        <!-- INCLUDE para la información de los oponentes LISTA, AGREGAR Y BAJAS -->
                        <cfinclude template="ft_include_oponentes_coa.cfm">
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
                                        <div align="left">
                                            <span class="Sans9GrNe">#ctMovimiento.mov_pos8#</span>
                                            <cfinput name="pos23" id="pos23" type="hidden" value="#vCampoPos23#">
                                            <cfif #vTipoComando# IS 'IMPRIME'>
                                                <span class="Sans9Gr">#vCampoPos8_txt#</span>
                                            <cfelse>
                                                <cfselect name="pos8" class="datos" id="pos8" query="ctCategoria" queryPosition="below" value="cn_clave" display="cn_siglas" selected="#tbConvocatorias.cn_clave#" disabled>
                                                <option value="" selected>SELECCIONE</option>
                                                </cfselect>
                                            </cfif>
                                        </div>
                                    </td>
                                </tr>
                                <!-- Fecha en que salió publicada la convocatoria en gaceta -->
                                <tr>
                                    <td colspan="2">
                                        <span class="Sans9GrNe">#ctMovimiento.mov_pos14# </span>
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
                                <!-- Número de concursantes que se presentaron -->
                                <tr>
                                    <td colspan="2">
                                        <span class="Sans9GrNe">#ctMovimiento.mov_pos17#&nbsp;</span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#NumberFormat(vCampoPos17,"99")#</span>
                                        <cfelse>
                                            <cfinput name="pos17" type="text" class="datos" id="pos17" size="3" maxlength="2" disabled>
                                        </cfif>
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
                                <!-- Nuevo dictamen de la Comisión Dictaminadora -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos31#</span></td>
                                    <td>
                                        <div align="center">
                                            <cfinput name="pos31" type="checkbox" id="pos31" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos31 EQ 'Si',DE("yes"),DE("no"))#">
                                        </div>
                                    </td>
                                </tr>
                                <!-- Copia del oficio enviado por el CTIC a la Comisión Dictaminadora -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos33#</span></td>
                                    <td><div align="center"><cfinput name="pos33" type="checkbox" id="pos33" value="Si" checked="#Iif(vCampoPos33 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
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
