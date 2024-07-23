<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 03/06/2009 --->
<!--- FECHA ÚLTIMA MOD.: 18/07/2024 --->
<!--- FT-CTIC-12.-Cambio de medio tiempo a tiempo completo o viceversa--->

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

<!--- Obtener la contrparte (en tiempo) de la categoría y nivel actuales --->
<cfset vContraparte = "">
<cfif mid(#vCampoPos3_txt#, len(#vCampoPos3_txt#) - 1, len(#vCampoPos3_txt#)) EQ "MT">
	<cfset vContraparte = mid(#vCampoPos3_txt#, 1, len(#vCampoPos3_txt#) - 2) & 'TC'>
<cfelseif mid(#vCampoPos3_txt#, len(#vCampoPos3_txt#) - 1, len(#vCampoPos3_txt#)) EQ "TC">
	<cfset vContraparte = mid(#vCampoPos3_txt#, 1, len(#vCampoPos3_txt#) - 2) & 'MT'>
</cfif>

<!--- Obtener datos del catálogo de categorías y niveles (CATÁLOGOS GENERALES MYSQL) --->
<cfquery name="ctCategoria" datasource="#vOrigenDatosCATALOGOS#">
	SELECT * FROM catalogo_cn 
    WHERE cn_siglas = '#vContraparte#'
</cfquery>

<!--- Asignar el valor apropiado al campo pos8 y pos8_txt --->
<cfset vCampoPos8 = '#ctCategoria.cn_clave#'>
<cfset vCampoPos8_txt = '#ctCategoria.cn_siglas#'>

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
				vMensaje += fValidaFecha('pos14','A PARTIR DEL');
				vMensaje += fValidaPlaza();
				vMensaje += fValidaCampoLleno('pos9','NÚMERO DE PLAZA');
				vMensaje += fValidaCampoLleno('pos8','CAMBIO QUE SE PROPONE');
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
                                <!-- Cambio que se propone -->
                                <tr>
                                    <td width="20%"><span class="Sans9GrNe">#ctMovimiento.mov_pos12#</span></td>
                                    <td width="80%">
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoPos8_txt#</span>
                                        <cfelse>
                                            <cfinput name="pos8_txt" id="pos8_txt" type="text" class="datos" size="20" value="#vCampoPos8_txt#" disabled>
                                            <cfinput name="pos8" id="pos8" type="hidden" value="#vCampoPos8#">
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Número de plaza -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos9#</span></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoPos9#</span>
                                        <cfelse>
                                            <cfinput name="pos9" type="text" class="datos" id="pos9" size="8" maxlength="9" disabled='#vActivaCampos#' value="#vCampoPos9#" onkeypress="return MascaraEntrada(event, '99999-99');">
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- A partir del -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos14#</span></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos14)#</span>
                                        <cfelse>
                                            <cfinput name="pos14" type="text" class="datos" id="pos14" size="10" maxlength="10" disabled='#vActivaCampos#' value="#vCampoPos14#" onKeyPress="return MascaraEntrada(event, '99/99/9999');">
                                        </cfif>
                                    </td>
                                </tr>
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
                                    <td width="20%" class="Sans9GrNe"> <div align="center"><b>Aprobatoria</b></div></td>
                                    <td width="15%" class="Sans9GrNe"> <div align="center"><b>Se anexa</b></div></td>
                                </tr>
                                <!-- Opinión de la Comisión Dictaminadora -->
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
                                            <cfinput name="pos31" type="checkbox" id="pos31" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos31 EQ 'Si',DE("yes"),DE("no"))#">
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
                                            <cfinput name="pos27" type="checkbox" id="pos27" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos27 EQ 'Si',DE("yes"),DE("no"))#">
                                        </div>
                                    </td>
                                </tr>
                                <!-- Opinión del director -->
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
                                            <cfinput name="pos29" type="checkbox" id="pos29" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos28 EQ 'Si',DE("yes"),DE("no"))#">
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
                                    <td width="15%"><div align="center" class="Sans9GrNe"><b>Se anexa</b></div></td>
                                </tr>
                                <!-- Carta del interesado dirigida al director -->
                                <tr>
                                    <td><b><span class="Sans9GrNe">#ctMovimiento.mov_pos32#</span></b></td>
                                    <td>
                                        <div align="center">
                                            <b>
                                            <cfinput name="pos32" type="checkbox" id="pos32" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos32 EQ 'Si',DE("yes"),DE("no"))#">
                                            </b>
                                        </div>
                                    </td>
                                </tr>
                                <!-- Curriculum vitae -->
                                <tr>
                                    <td><b><span class="Sans9GrNe">#ctMovimiento.mov_pos36#</span></b></td>
                                    <td>
                                        <div align="center">
                                            <b>
                                            <cfinput name="pos36" type="checkbox" id="pos36" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos36 EQ 'Si',DE("yes"),DE("no"))#">
                                            </b>
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
