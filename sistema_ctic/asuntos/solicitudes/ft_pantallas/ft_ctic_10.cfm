<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 12/03/2014 --->
<!--- FECHA ÚLTIMA MOD.: 18/07/2024 --->
<!--- FT-CTIC-10.-Concurso de oposición para promoción o concurso cerrado (Investigador) --->

<!--- Incluir los siguientes archivos --->
<cfif #vTipoComando# EQ 'IMPRIME_EJEMPLO'>
	<cfinclude template="ft_campos_blanco.cfm"> <!---PERIMITE IMPRIMIR LA FT EN BLANCO --->
	<cfset vTipoComando = 'IMPRIME'>
<cfelse>
	<cfinclude template="ft_campos.cfm">
</cfif>

<!--- Obtener la lista de ubicaciones de la dependencia  (CATÁLOGOS GENERALES MYSQL) --->
<cfquery name="ctUbicacion" datasource="#vOrigenDatosCATALOGOS#">
	SELECT *, CONCAT(TRIM(ubica_nombre),  ', ', TRIM(ubica_lugar)) AS ubica_completa
    FROM catalogo_dependencias_ubica
	WHERE dep_clave = '#vCampoPos1#' 
    AND ubica_status = 1
	ORDER BY ubica_clave
</cfquery>

<!--- Obtener datos del catálogo de categorías y niveles (CATÁLOGOS GENERALES MYSQL) --->
<cfquery name="ctCategoria" datasource="#vOrigenDatosCATALOGOS#">
	SELECT * FROM catalogo_cn 
    WHERE (cn_siglas LIKE 'INV%' OR cn_siglas LIKE 'PROF%')
    AND cn_status = 1 
    ORDER BY cn_orden DESC
</cfquery>

<!--- ??? --->
<cfloop query="ctCategoria">
	<cfif #tbAcademico.cn_clave# EQ #cn_clave#>
		<cfset vIdCcnOrden = #cn_orden# - 1>
	</cfif>
</cfloop>

<!--- Prellenar el campo 'pos8' --->
<cfloop query="ctCategoria">
	<cfif #vIdCcnOrden# EQ #cn_orden#>
		<cfset vCampoPos8 = #cn_clave#>
	</cfif>
</cfloop>

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
				if (document.getElementById('pos5_d').checked == true)
				{
					vMensaje += fValidaFecha('pos14','A PARTIR DEL');
				}
				if (document.getElementById('pos5_i').checked == true)
				{
					vMensaje += fValidaDuracionAMD();
					vMensaje += fValidaFecha('pos14','INICIO');
					vMensaje += fValidaDuracion();
				}
				vMensaje += fValidaCampoLleno('pos8','CATEGORIA Y NIVEL A QUE ASPIRA');
				vMensaje += document.getElementById('vNoAniosCcnDef').value < 3 ? 'El académico no cumple con el requisito de tener como mínimo 3 años de antigüedad en esta categoría y nivel.\n': '';
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
	<body onLoad="ObtenerCcnDef();">
		<!--- INCLUDE Cintillo con nombre y número de forma telegrámica / INCLUDE que contiene FORM para abrir archivo PDF (05/04/2019) --->
        <cfinclude template="ft_include_cintillo.cfm">
		<!--- FORMULARIO forma telegrámica --->
		<cfform name="formFt" id="formFt" method="POST" enctype="multipart/form-data" action="#vRutaPagSig#">
            <!-- Forma telegrámica -->
            <table width="100%" border="0">
                <tr>
                    <!-- Menú lateral -->
                    <cfif #vTipoComando# IS NOT 'IMPRIME'>
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
                        <cfif #Session.sTipoSistema# IS 'stctic' AND #vSolStatus# LT 3 AND #vTipoComando# IS NOT 'NUEVO' AND #vTipoComando# IS NOT 'IMPRIME'>
                            <cfinclude template="ft_control.cfm">
                        </cfif>

                        <!-- INCLUDE para visualisar Datos generales -->
                        <cfinclude template="ft_include_general.cfm">

                        <!-- INCLUDE para visualisar Información Académica -->
                        <cfinclude template="ft_include_datos_academicos.cfm">

                        <!-- Datos que deben ingresarse -->
						<cfoutput>						
                            <table border="0" class="cuadrosFormularios">
                                <!-- Categoría y nivel a que aspira -->
                                <tr>
                                    <td colspan="2">
                                        <span class="Sans9GrNe">#ctMovimiento.mov_pos8#&nbsp;</span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoPos8_txt#</span>
                                        <cfelse>
                                            <cfselect name="pos8" class="datos" id="pos8" disabled='#vActivaCampos#' query="ctCategoria" value="cn_clave" display="cn_siglas" selected="#vCampoPos8#" queryPosition="below">
                                            <option value="" selected>SELECCIONE</option>
                                            </cfselect>
                                        </cfif>
                                    </td>
                                </tr>
                                <cfif #vCampoPos5# EQ 1>
                                    <!-- Activa este código si el investigador es definitivo -->
                                    <tr>
                                        <td width="20%"><span class="Sans9GrNe">#ctMovimiento.mov_pos14#</span></td>
                                        <td width="80%">
                                            <cfif #vTipoComando# IS 'IMPRIME'>
                                                <span class="Sans9Gr">#FechaCompleta(vCampoPos14)#</span>
                                            <cfelse>
                                                <cfinput name="pos14" type="text" class="datos" id="pos14" size="10" maxlength="10" disabled='#vActivaCampos#' value="#vCampoPos14#" onKeyPress="return MascaraEntrada(event, '99/99/9999');" onBlur="ObtenerCcnDef();">
                                            </cfif>
                                            <div id="ccnactual_dynamic"><!-- AJAX: Años de actividad ininterrumpida --></div>
                                        </td>
                                    </tr>
                                <cfelseif #vCampoPos5# EQ 2>
                                    <!-- Activa este código si el investigador es interino -->
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
                                                <span
                                                    <cfif #vCampoPos13_m# EQ 0>class="NoImprimir"</cfif>
                                                    ><cfinput type="text" name="pos13_m" disabled='#vActivaCampos#' class="datos" id="pos13_m" onChange="CalcularSiguienteFecha();" value="#vCampoPos13_m#" size="2" maxlength="2" onkeypress="return MascaraEntrada(event, '99');">
                                                    <span class="Sans9Gr">
                                                        #ctMovimiento.mov_pos13_m#
                                                    </span>
                                                </span>
                                                <span
                                                    <cfif #vCampoPos13_d# EQ 0>class="NoImprimir"</cfif>
                                                    ><cfinput type="text" name="pos13_d" disabled='#vActivaCampos#' class="datos" id="pos13_d" onChange="CalcularSiguienteFecha();" value="#vCampoPos13_d#" size="2" maxlength="2" onkeypress="return MascaraEntrada(event, '99');">
                                                    <span class="Sans9Gr">
                                                        #ctMovimiento.mov_pos13_d#
                                                    </span>
                                                </span>
                                            </cfif>
                                            <!-- Fechas -->
                                            <span class="Sans9Gr">#MID(ctMovimiento.mov_pos14,10,13)#</span>
                                            <cfif #vTipoComando# IS 'IMPRIME'>
                                              <span class="Sans9Gr">#FechaCompleta(vCampoPos14)#&nbsp;</span>
                                            <cfelse>
                                                <cfinput type="text" name="pos14" disabled='#vActivaCampos#' class="datos" id="pos14" onChange="CalcularSiguienteFecha();" value="#vCampoPos14#" size="10" maxlength="10" onkeypress="return MascaraEntrada(event, '99/99/9999');">
                                          </cfif>
                                            <span class="Sans9Gr">#ctMovimiento.mov_pos15#</span>
                                            <cfif #vTipoComando# IS 'IMPRIME'>
                                                <span class="Sans9Gr">#FechaCompleta(vCampoPos15)#</span>
                                            <cfelse>
                                                <cfinput onclick="pos15.value=''" name="pos15" type="text" class="datos" id="pos15" size="10" maxlength="10" disabled value="#vCampoPos15#">
                                            </cfif>
                                            <div id="ccnactual_dynamic"><!-- AJAX: Años de actividad ininterrumpida --></div>
                                        </td>
                                    </tr>
                                </cfif>
                            </table>
                        </cfoutput>
  						<!-- Dictámenes -->
						<!--- Llamado a INCLUDE general de los dictámenes requeridos en la FT 18/07/2024 --->
						<cfinclude template="ft_include_anexoDictamen.cfm">
<!---
                        <cfoutput>
                            <table border="0" class="cuadrosFormularios">
                                <tr bgcolor="##CCCCCC">
                                    <td width="65%"></td>
                                    <td width="20%"> <div align="center"><span class="Sans9GrNe">Aprobatoria</span></div></td>
                                    <td width="15%"> <div align="center"><span class="Sans9GrNe">Se anexa</span></div></td>
                                </tr>
                                <!-- Comisión Dictaminadora -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos30#</span></td>
                                    <td>
                                        <div align="center">
                                            <span class="Sans9GrNe">
                                                <cfinput name="pos30" id="pos30_s" type="radio" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos30 EQ 'Si',DE("yes"),DE("no"))#">S&iacute;&nbsp;
                                                <cfinput name="pos30" id="pos30_n" type="radio" value="No" disabled='#vActivaCampos#' checked="#Iif(vCampoPos30 EQ 'No',DE("yes"),DE("no"))#">No
                                            </span>
                                        </div>
                                    </td>
                                    <td>
                                        <div align="center">
                                            <span class="Sans9GrNe">
                                                <cfinput name="pos31" type="checkbox" id="pos31" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos31 EQ 'Si',DE("yes"),DE("no"))#">
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                                <!-- Opinión del Consejo Interno -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos26#</span></td>
                                    <td>
                                        <div align="center">
                                            <span class="Sans9GrNe">
                                                <cfinput name="pos26" id="pos26_s" type="radio" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos26 EQ 'Si',DE("yes"),DE("no"))#">S&iacute;&nbsp;
                                                <cfinput name="pos26" id="pos26_n" type="radio" value="No" disabled='#vActivaCampos#' checked="#Iif(vCampoPos26 EQ 'No',DE("yes"),DE("no"))#">No
                                            </span>
                                        </div>
                                    </td>
                                    <td>
                                        <div align="center">
                                            <span class="Sans9GrNe">
                                                <cfinput name="pos27" type="checkbox" id="pos27" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos27 EQ 'Si',DE("yes"),DE("no"))#">
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                                <!-- Apreciación del director -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos28#</span></td>
                                    <td>
                                        <div align="center">
                                            <span class="Sans9GrNe">
                                                <cfinput name="pos28" id="pos28_s" type="radio" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos28 EQ 'Si',DE("yes"),DE("no"))#">S&iacute;&nbsp;
                                                <cfinput name="pos28" id="pos28_n" type="radio" value="No" disabled='#vActivaCampos#' checked="#Iif(vCampoPos28 EQ 'No',DE("yes"),DE("no"))#">No
                                            </span>
                                        </div>
                                    </td>
                                    <td>
                                        <div align="center">
                                            <span class="Sans9GrNe">
                                                <cfinput name="pos29" type="checkbox" id="pos29" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos29 EQ 'Si',DE("yes"),DE("no"))#">
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </cfoutput>
--->
                        <!-- Documentación -->
						<!--- Llamado a INCLUDE general de los anexos requeridos en la FT 18/07/2024 --->
						<cfinclude template="ft_include_anexoAnexos.cfm">
<!---
                        <cfoutput>
                            <table border="0" class="cuadrosFormularios">
                                <tr bgcolor="##CCCCCC">
                                    <td width="85%"></td>
                                    <td width="15%"> <div align="center"><span class="Sans9GrNe">Se anexa</span></div></td>
                                </tr>
                                <!-- Carta del director (con resumen de la obra del académico) (2) -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos33#</span></td>
                                    <td>
                                        <div align="center">
                                            <span class="Sans9GrNe">
                                                <cfinput name="pos33" type="checkbox" id="pos33" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos33 EQ 'Si',DE("yes"),DE("no"))#">
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                                <!-- Carta razonada del interesado -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos32#</span></td>
                                    <td>
                                        <div align="center">
                                            <span class="Sans9GrNe">
                                                <cfinput name="pos32" type="checkbox" id="pos32" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos32 EQ 'Si',DE("yes"),DE("no"))#">
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                                <!-- Informe y programa de actividades -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos34#</span></td>
                                    <td>
                                        <div align="center">
                                            <span class="Sans9GrNe">
                                                <cfinput name="pos34" type="checkbox" id="pos34" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos34 EQ 'Si',DE("yes"),DE("no"))#">
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                                <!-- Curriculum vitae -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos36#</span></td>
                                    <td>
                                        <div align="center">
                                            <span class="Sans9GrNe">
                                                <cfinput name="pos36" type="checkbox" id="pos36" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos36 EQ 'Si',DE("yes"),DE("no"))#">
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                                <!-- Trabajos publicados (1) -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos39#</span></td>
                                    <td>
                                        <div align="center">
                                            <span class="Sans9GrNe">
                                                <cfinput name="pos39" type="checkbox" id="pos39" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos39 EQ 'Si',DE("yes"),DE("no"))#">
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </cfoutput>
--->
                        <!-- Comentarios -->
                        <table width="620" border="0">
                            <tr>
                                <td><cfoutput><span class="Sans9Gr">#ctMovimiento.mov_comentarios#</span></cfoutput></td>
                            </tr>
                        </table>
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
