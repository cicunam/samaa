<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 03/02/2010 --->
<!--- FECHA ULTIMA MOD.: 31/01/2023 --->

<!--- FORMULARIO DE DATOS PERSONALES --->

<!--- Parámetros utilizados --->
<cfparam name="vAcadId" default="0">
<cfparam name="vActivaCampos" default="">
<cfparam name="vTipoComando" default="CONSULTA">

<!--- Registrar el identificador del académico (para futuros regresos desde detalle) --->
<cfif #vAcadId# GT 0>
	<cfset Session.AcademicosFiltro.vAcadId = #vAcadId#>
	<!--- <cfoutput>#Session.AcademicosFiltro.vAcadId#</cfoutput>--->
</cfif>

<!--- INCLUDE que abre la tabla de academicos e inserta en hidden tres datos --->
<cfinclude template="../include_datos_academico.cfm">
<!---
	<!--- Obtener datos del académico --->    
	<cfquery name="tbAcademico" datasource="#vOrigenDatosSAMAA#">
		SELECT * FROM academicos 
		WHERE acd_id = #vAcadId#
	</cfquery>
--->
<!--- Obtener información del catálogo de bajas (CATÁLOGOS LOCAL SAMAA) --->
<cfquery name="ctBaja" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_baja
	WHERE baja_status = 1
    ORDER BY baja_descrip
</cfquery>

<!--- Obtener información del catálogo de grados académicos (CATÁLOGOS LOCAL SAMAA) --->
<cfquery name="ctGrado" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_grado 
    ORDER BY grado_clave
</cfquery>

<!--- Obtener información del catálogo de dependencias (CATÁLOGOS GENERALES MYSQL) --->
<cfquery name="ctDependencia" datasource="#vOrigenDatosCATALOGOS#">
	SELECT * FROM catalogo_dependencias
	<!--- WHERE dep_status = 1 --->
	ORDER BY substr(dep_clave,1,2), dep_nombre
</cfquery>

<!--- Obtener información del catálogo de países (CATÁLOGOS GENERALES MYSQL) --->
<cfquery name="ctPais" datasource="#vOrigenDatosCATALOGOS#">
	SELECT * FROM catalogo_paises
	ORDER BY pais_nombre
</cfquery>

<!--- Obtener datos del catálogo de nombramiento (CATÁLOGOS GENERALES MYSQL) --->
<cfquery name="ctCategoria" datasource="#vOrigenDatosCATALOGOS#">
	SELECT * FROM catalogo_cn
	WHERE cn_status > 0
	ORDER BY cn_descrip
</cfquery>

<!--- Obtener información del catálogo de tipo de contrato (CATÁLOGOS LOCAL SAMAA) --->
<cfquery name="ctContrato" datasource="#vOrigenDatosSAMAA#"> <!--- REVISAR EN CATÁLOGOS GENERALES MYSQL NO COINCIDE LA ESTRUCTURA CON SAMAA --->
	SELECT * FROM catalogo_contrato
	WHERE con_status = 1
	ORDER BY con_clave
</cfquery>

<!--- VARIABLE QUE CALCULA LA ANTIGÜEDAD EN DEFINITIVOS --->	
<cfif IsDefined('tbAcademico.FECHA_DEF')>
	<cfif #tbAcademico.FECHA_DEF# NEQ "">
		<cfset vAntigDefAnios = #DateDiff('yyyy',#tbAcademico.FECHA_DEF#, now())#>
		<cfset vF2 = #dateadd('yyyy',vAntigDefAnios,tbAcademico.FECHA_DEF)#>
		<cfset vAntigDefMeses = #DateDiff('m',#vF2#, now())#>
		<cfset vF3 = #dateadd('m',vAntigDefMeses,vF2)#>			
		<cfset vAntigDefDias = #DateDiff('d',#vF3#, now())#>
		<cfset vAntigDef = #vAntigDefAnios# & " año(s) " & #vAntigDefMeses# & " mes(es) " & #vAntigDefDias# & " día(s) ">
	<cfelse>
		<cfset vAntigDef = "">
	</cfif>
</cfif>
<html>
	<head>
		<title>STCTIC - Asuntos Acad&eacute;mico-Administrativos</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<cfoutput>
			<link href="#vCarpetaCSS#/formularios.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/general.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/fuentes.css" rel="stylesheet" type="text/css">
			<link href="#vHttpWebGlobal#/css/jquery/jquery-ui-1.8.16.custom.css" type="text/css" rel="Stylesheet">
            
			<script type="text/javascript" src="#vHttpWebGlobal#/xmlHttpRequest.js"></script>
			<script type="text/javascript" src="#vHttpWebGlobal#/jquery/jquery-1.6.2.min.js"></script>
			<script type="text/javascript" src="#vHttpWebGlobal#/jquery/jquery-ui-1.8.16.custom.min.js"></script>
			<!--- LLAMADO A CÓDIGO DE JAVA SCRIPT COMÚN O GLOBAL --->
            <script type="text/javascript" src="#vCarpetaRaizLogicaSistema#/comun/java_script/mascara_entrada.js"></script>
		</cfoutput>

		<!--- JAVA SCRIPT USO LOCAL EN EL MÓDULO ACADÉMICOS --->
		<cfinclude template="../javaScript_academicos.cfm">
		<cfinclude template="funciones_javascript.cfm">
		<cfinclude template="../comun_modulo/js_funciones_jquery.cfm">

		<script language="JavaScript" type="text/JavaScript">
	        function fInicioCargaPagina()
	        {
				document.getElementById('mPa').className = 'MenuEncabezadoBotonSeleccionado';
				fDatosAcademico();
				fJQObtenerUbicacion(); //fObtenerUbicacion();
				fBloquearRegistro('true');
				fActualizaMigratoria(); 
				fActualizaBaja(); 
				fJQListaPrefijos('<cfoutput>#tbAcademico.acd_prefijo#</cfoutput>'); //fListaPrefijos(); 
				fCargaTrTablas();
				//fSni();
	        }
	        function fCargaTrTablas()
	        {
				fNombramiento();
				fCalulaAntigAcad(); 
				fCalulaAntigAcadCcn();
				fFechaNombramiento();
				fFechaDefinitividad();
				fFechaIngreso();
				fNoEmpleado();				
				fNoPlaza();
			}
	        function fBuscaSni()
	        {
				window.open('http://www.cic.unam.mx:31220/consultas/sni/buscador/buscador.cfm?vNombreBusqueda=' + document.getElementById('nombre_completo_pmn').value,'winSni')
			}
		</script>
	</head>
	<body onLoad="fInicioCargaPagina();">
		<!-- Cintillo con nombre del módulo y filtro -->
		<table class="Cintillo">
			<tr>
				<td><span class="Sans9GrNe">PERSONAL ACAD&Eacute;MICO &gt;&gt; </span><span class="Sans9Gr">DATOS PERSONALES</span></td>
				<td align="right">
					<span class="Sans9Gr">
						<b>Filtro:</b> <cfoutput>#tbAcademico.acd_apepat# #tbAcademico.acd_apemat# #tbAcademico.acd_nombres#</cfoutput>
					</span>
				</td>
			</tr>
		</table>
		<table width="98%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td width="20%" height="461" valign="top" class="BordesLateralMarron">
					<table width="180" border="0">
						<!-- Menú del módulo -->
						<tr><td><div class="linea_menu"></div></td></tr>
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">Men&uacute;:</div></td>
						</tr>
						<!-- Opción: Corregir -->
						<tr id="CmdEdita">
							<td valign="top">
								<input type="button" value="Corregir" class="botones" onClick="fBloquearRegistro(false);" <cfif #Session.sTipoSistema# IS 'sic' OR (#Session.sTipoSistema# IS 'stctic' AND #Session.sUsuarioNivel# GT 2)>disabled</cfif>>
							</td>
						</tr>
						<!-- Opción: Imprimir -->
						<tr id="CmdImprime">
							<td valign="top">
								<input type="button" value="Imprimir" class="botones">
							</td>
						</tr>
						<!-- Opción: Regresar -->
						<tr id="CmdRegresa">
							<td>
								<input type="button" value="Regresar" class="botones" onClick="window.location.replace('../consulta_academicos.cfm');">
							</td>
						</tr>
						<!-- Opción: Guardar -->
						<tr id="CmdGuarda">
							<td valign="top"><input type="submit" value="Guardar" class="botones" onClick="fValidaCampos();"></td>
						</tr>
						<!-- Opción: Cancelar -->
						<tr id="CmdCancela">
							<td valign="top"><input type="button" value="Cancelar" class="botones" onClick="window.location='academico_personal.cfm?vAcadId=<cfoutput>#vAcadId#</cfoutput>'"></td>
						</tr>
                        <!--- SE CAMBIÓ DE POSICIÓN EL BOTÓN DE ELIMINAR PARA EVITAR ELIMINAR EL REGISTRO POR ERROR 03/04/2019 --->
						<tr height="20px"><td></td></tr>
						<!-- Opción: Eliminar -->
						<tr id="CmdElimina">
							<td valign="top">
								<input type="button" value="Eliminar" class="botones" onClick="fEliminarRegistro();" <cfif #Session.sTipoSistema# IS 'sic' OR (#Session.sTipoSistema# IS 'stctic' AND #Session.sUsuarioNivel# GT 2)>disabled</cfif>>
							</td>
						</tr>
					</table>
					<table width="180" border="0">
						<!-- Más información -->
						<tr><td><br><div class="linea_menu"></div></td></tr>
					</table>
				</td>
				<td width="80%" valign="top">
					<!-- Datos del académico -->
					<div id="AcadDatos_dynamic"><!-- AJAX: Lista Datos Académico --></div>
					<!-- Menú -->
					<cfset vTituloModulo = 'INFORMACIÓN GENERAL'>
                    <cfinclude template="../include_menus.cfm">
                    <br>
					<cfform id="frmAcademicos" method="post" action="academico_personal_edita.cfm">
                        <!-- Campo ocultos -->	
                        <!---<input name="vTipoComando" id="vTipoComando" type="hidden" value="#vTipoComando#">--->
                        <!-- Formulario de captura -->
                        <table border="0" class="cuadrosDatosAcademico"><!--- style="width:99%;  margin:0px 0px 5px 15px; border:none;" cellspacing="0" cellpadding="2" --->
                            <cfoutput>
                            <!-- Titulo -->
                            <tr>
                                <td colspan="4" bgcolor="##CCCCCC"><div align="center" class="Sans12NeNe">DATOS GENERALES</div></td>
                            </tr>
                            <!-- Apellido paterno -->
                            <tr>
                                <td width="20%" class="Sans9GrNe">Apellido paterno</td>
                                <td width="80%" colspan="3" class="Sans9Gr">
                                    <cfinput name="acd_apepat" id="acd_apepat" type="text" value="#tbAcademico.acd_apepat#" size="50" maxlength="254" class="datos">
                                    <input name="vAcadId" id="vAcadId" value="#vAcadId#" type="hidden" size="5" maxlength="5" class="datos">
                                </td>
                            </tr>
                            <!-- Apellido materno -->
                            <tr>
                                <td class="Sans9GrNe">Apellido materno</td>
                                <td colspan="3" class="Sans9Gr">
                                    <cfinput name="acd_apemat" id="acd_apemat" type="text" value="#tbAcademico.acd_apemat#" size="50" maxlength="254" class="datos">
                                </td>
                            </tr>
                            <!-- Nombre -->
                            <tr>
                                <td class="Sans9GrNe">Nombre</td>
                                <td colspan="3" class="Sans9Gr">
                                    <cfinput name="acd_nombres" id="acd_nombres" type="text" value="#tbAcademico.acd_nombres#" size="50" maxlength="254" class="datos">
                                </td>
                            </tr>
                            <!-- RFC -->
                            <tr>
                              <td class="Sans9GrNe">Fecha de nacimiento</td>
                              <td colspan="3" class="Sans9Gr"><cfinput name="acd_fecha_nac" id="acd_fecha_nac" type="text" class="datos" value="#LsDateFormat(tbAcademico.acd_fecha_nac,"dd/mm/yyyy")#" size="10" maxlength="10" onkeypress="return MascaraEntrada(event, '99/99/9999');"></td>
                              </tr>
                            <tr>
                                <td class="Sans9GrNe">RFC</td>
                                <td colspan="3" class="Sans9Gr">
                                    <cfinput name="acd_rfc" id="acd_rfc" type="text" value="#tbAcademico.acd_rfc#" class="datos" size="16" maxlength="13" onkeypress="return MascaraEntrada(event, 'AAAA999999XXX');">
                                </td>
                            </tr>
                            <!-- CURP -->
                            <tr>
                                <td class="Sans9GrNe">CURP</td>
                                <td colspan="3" class="Sans9Gr">
                                    <cfinput name="acd_curp" id="acd_curp" type="text" value="#tbAcademico.acd_curp#" class="datos" size="25" maxlength="20">
                                </td>
                            </tr>
                            <!-- Sexo -->
                            <tr>
                                <td class="Sans9GrNe">Sexo</td>
                                <td colspan="3" class="Sans9Gr">
                                    <cfinput name="acd_sexo" id="acd_sexo_F" type="radio" value="F" checked="#Iif(tbAcademico.acd_sexo EQ "F",DE("yes"),DE("no"))#"> Mujer
                                    <cfinput name="acd_sexo" id="acd_sexo_M" type="radio" value="M" checked="#Iif(tbAcademico.acd_sexo EQ "M",DE("yes"),DE("no"))#"> Hombre
                                </td>
                            </tr>
                            <!-- Grado académico -->
                            <tr>
                                <td class="Sans9GrNe">Grado acad&eacute;mico</td>
                                <td colspan="3" class="Sans9Gr">
                                    <cfselect name="grado_clave" id="grado_clave" query="ctGrado" queryPosition="below" display="grado_descrip" value="grado_clave" selected="#tbAcademico.grado_clave#" class="datos" onchange="fJQListaPrefijos('#tbAcademico.acd_prefijo#');">
                                        <option value="" selected>SELECCIONE</option>
                                    </cfselect>
                                </td>
                            </tr>
                            <!-- Prefijo de nombre (del grado académico) -->
                            <tr>
                                <td class="Sans9GrNe">Prefijo de nombre</td>
                                <td colspan="3">
                                    <div id="prefijo_dynamic"><!-- Esta lista se actualiza con AJAX --></div>
                                </td>
                            </tr>
                            <!-- País de nacimiento -->
                            <tr>
                                <td class="Sans9GrNe"><span class="Sans9GrNe">Pa&iacute;s de nacimiento</span></td>
                                <td colspan="3" class="Sans9Gr">
                                    <cfselect name="pais_clave" id="pais_clave" query="ctPais" queryPosition="below" display="pais_nombre" value="pais_clave" selected="#tbAcademico.pais_clave#" class="datos" onchange="fActualizaMigratoria();">
                                        <option value="">SELECCIONE</option>
                                    </cfselect>
                                </td>
                            </tr>
                            <!-- Entidad / Estado de nacimiento -->
                            <tr id="tr_entidad_nac" style="display:none">
                                <td class="Sans9GrNe">Entidad de nacimiento</td>
                                <td><div id="edonacimiento_dynamic"><!-- Esta lista se actualiza con AJAX --></div></td>
                            </tr>                        
                            <!-- Nacionalidad -->
                            <tr>
                                <td class="Sans9GrNe">Nacionalidad</td>
                                <td colspan="3" class="Sans9Gr">
                                    <cfselect name="pais_clave_nacimiento" id="pais_clave_nacimiento" class="datos" query="ctPais" queryPosition="below" display="pais_nacionalidad" value="pais_clave" selected="#tbAcademico.pais_clave_nacimiento#" onChange="fActualizaMigratoria();">
                                        <option value="">SELECCIONE</option>
                                    </cfselect>
                                </td>
                            </tr>
                            <!-- Calidad migratoria -->
                            <tr id="migratoria_dynamic">
                                <td class="Sans9GrNe">Calidad migratoria</td>
                                <td colspan="3" class="Sans9Gr">
                                    <cfinput name="migracion_clave" id="migracion_clave_rt" type="radio" value="4" checked="#Iif(tbAcademico.migracion_clave EQ "4",DE("yes"),DE("no"))#"><span class="Sans9Gr">Residente temporal</span>
                                    <cfinput name="migracion_clave" id="migracion_clave_rp" type="radio" value="5" checked="#Iif(tbAcademico.migracion_clave EQ "5",DE("yes"),DE("no"))#"><span class="Sans9Gr">Residente permanente</span>
    <!---
                                    <cfinput name="migracion_clave" id="migracion_clave_Io" type="radio" value="3" checked="#Iif(tbAcademico.migracion_clave EQ "3",DE("yes"),DE("no"))#"><span class="Sans9Gr">No inmigrante (Visitante)</span>
                                    <cfinput name="migracion_clave" id="migracion_clave_Ie" type="radio" value="2" checked="#Iif(tbAcademico.migracion_clave EQ "2",DE("yes"),DE("no"))#"><span class="Sans9Gr">Inmigrante</span>
                                    <cfinput name="migracion_clave" id="migracion_clave_Ni" type="radio" value="1" checked="#Iif(tbAcademico.migracion_clave EQ "1",DE("yes"),DE("no"))#"><span class="SansGr">Inmigrado</span>
    --->
                                </td>
                            </tr>
                            <!-- Correo electrónico -->
                            <tr>
                                <td class="Sans9GrNe">Correo electr&oacute;nico</td>
                                <td colspan="3" class="Sans9Gr">
                                    <cfinput name="acd_email" id="acd_email" type="text" value="#tbAcademico.acd_email#" class="datos" size="60" maxlength="254">
                                </td>
                            </tr>
                            </cfoutput>
                        </table>
						<br/>
                        <table border="0" class="cuadrosDatosAcademico"><!--- cellpadding="2" cellspacing="0" style="width:99%;  margin:0px 0px 5px 15px; border:0;"--->
                            <cfoutput>
                                <tr>
                                    <td colspan="2" bgcolor="##CCCCCC"><div align="center" class="Sans12NeNe">INFORMACI&Oacute;N ACAD&Eacute;MICA</div></td>
                                </tr>
                                <!-- Dependencia de adscripción -->
                                <tr>
                                    <td width="20%" class="Sans9GrNe">Entidad</td>
                                    <td width="80%">
                                        <cfselect name="dep_clave" id="dep_clave" query="ctDependencia" display="dep_nombre" value="dep_clave" queryPosition="below" selected="#tbAcademico.dep_clave#" class="datos100" style="width:450px" onChange="fJQObtenerUbicacion();" disabled>
                                            <option selected value="">SELECCIONE</option>
                                        </cfselect>
                                        <cfinput name="vUbicaClave" id="vUbicaClave" value="#tbAcademico.dep_ubicacion#" type="hidden" size="5" maxlength="5" class="datos">
                                    </td>
                                </tr>
                                <!-- Ubicación -->
                                <tr>
                                    <td class="Sans9GrNe">Ubicaci&oacute;n</td>
                                    <td id="adscripcion_dynamic">
                                        <div id="adscripcion_dynamic"><!-- Esta lista se actualiza con AJAX --></div>
                                    </td>
                                </tr>
                                <!-- Tipo de contrato -->
                                <tr>
                                    <td class="Sans9GrNe">Tipo de contrato</td>
                                    <td>
                                        <cfselect name="con_clave" id="con_clave" query="ctContrato" queryPosition="below" selected="#tbAcademico.con_clave#" display="con_descrip" value="con_clave" class="datos" onChange="fCargaTrTablas();">
                                            <option value="0">SELECCIONE TIPO DE CONTRATO</option>
                                        </cfselect>
                                    </td>
                                </tr>
                                <!-- Categoría y nivel -->
                                <tr id="trNombramiento">
                                    <td class="Sans9GrNe">Nombramiento</td>
                                    <td>
                                        <cfselect name="cn_clave" id="cn_clave" query="ctCategoria" queryPosition="below" display="cn_descrip" value="cn_clave" selected="#tbAcademico.cn_clave#" class="datos">
                                            <option value="" selected>SELECCIONE CLASE, CATEGORÍA Y NIVEL</option>
                                        </cfselect>
                                    </td>
                                </tr>
                                <!-- Fecha de obtención de la categoría -->
                                <tr id="trFechaNombramiento">
                                    <td class="Sans9GrNe">Fecha nombramiento</td>
                                    <td>
                                        <div style="width:15%; float:left;">
                                            <cfinput type="text" name="fecha_cn" id="fecha_cn" class="datos" value="#LsDateFormat(tbAcademico.fecha_cn,"dd/mm/yyyy")#" size="10" maxlength="10" onkeypress="return MascaraEntrada(event, '99/99/9999');">
                                        </div>
                                        <div id="antigCcn_dynamic" style="width:80%; float:left;"><!-- inserta la antigüedad en la CCN desde un AJAX--></div>
                                    </td>
                                </tr>
                                <!-- Fecha de definitividad, en su caso -->
                                <tr id="trFechaDefinitividad">
                                    <td class="Sans9GrNe">Fecha definitividad</td>
                                    <td>
                                        <div style="width:15%; float:left;">
                                            <cfinput name="fecha_def" id="fecha_def" type="text" class="datos" value="#LsDateFormat(tbAcademico.fecha_def,"dd/mm/yyyy")#" size="10" maxlength="10" onkeypress="return MascaraEntrada(event, '99/99/9999');">
                                        </div>
                                        <div style="width:80%; float:left;">
                                            <span class="Sans10NeNe">Antig&uuml;edad definitivo: </span><span class="Sans10Gr"><em>#vAntigDef#</em></span>
                                        </div>
                                    </td>
                                </tr>
                                <!-- Fecha de ingreso -->
                                <tr  id="trFechaIngreso">
                                    <td class="Sans9GrNe">Fecha de ingreso</td>
                                    <td>
                                        <div style="width:15%; float:left;">
                                            <cfinput name="fecha_pc" id="fecha_pc" type="text" class="datos" value="#LsDateFormat(tbAcademico.fecha_pc,"dd/mm/yyyy")#" size="10" maxlength="10" onkeypress="return MascaraEntrada(event, '99/99/9999');">
                                        </div>
                                        <div id="antigAcad_dynamic" style="width:80%; float:left;"><!-- inserta la antigüedad desde un AJAX--></div>                                
                                    </td>
                                </tr>
                                <!-- Número de empleado -->
                                <tr id="trNoEmpleado">
                                    <td class="Sans9GrNe">N&uacute;mero de empleado</td>
                                    <td class="Sans9Gr"><cfinput name="num_emp" id="num_emp" type="text" value="#tbAcademico.num_emp#" size="8" maxlength="8" class="datos" onkeypress="return MascaraEntrada(event, '9999999');"></td>
                                </tr>
                                <!-- Número de plaza -->
                                <tr id="trPlaza">
                                    <td class="Sans9GrNe">N&uacute;mero de plaza</td>
                                    <td>
                                        <div style="width:15%; float:left;">
                                            <cfinput name="no_plaza" id="no_plaza" type="text" value="#tbAcademico.no_plaza#" size="8" maxlength="8" class="datos" onkeypress="return MascaraEntrada(event, '99999-99');" onBlur="VerificaNoPlaza();">
                                        </div>
                                        <div style="width:50%;" id="verifica_plaza_dynamic"></div>                                
                                    </td>
                                </tr>
                                <!-- Situación -->
                                <tr>
                                    <td class="Sans9GrNe">Acad&eacute;mico activo</td>
                                    <td>
                                        <cfinput name="activo" id="activo" type="checkbox" value="Si" checked="#Iif(tbAcademico.activo IS 1,DE("yes"),DE("no"))#" onClick="fActualizaBaja();">
                                    </td>	
                                </tr>
                                <!-- Motivo de baja -->
                                <tr id="baja_dynamic">
                                    <td class="Sans9GrNe">Motivo de baja</td>
                                    <td>
                                        <cfselect name="baja_clave" id="baja_clave" query="ctBaja" queryPosition="below" display="baja_descrip" value="baja_clave" selected="#tbAcademico.baja_clave#" class="datos">
                                            <option value="" selected>SELECCIONE</option>
                                        </cfselect>
                                    </td>
                                </tr>
        
                                <!-- Expediente SNI -->
								<tr>
									<td class="Sans9GrNe">Expediente SNI</td>
									<td>
										<div style="width:15%; float:left;">
											<cfinput name="sni_exp" id="sni_exp" type="text" value="#Iif(tbAcademico.sni_exp EQ "999999",DE(""),DE("#tbAcademico.sni_exp#"))#" size="8" maxlength="8" class="datos" onkeypress="return MascaraEntrada(event, '9999999');">
										</div>
										<cfif #Session.sTipoSistema# IS 'stctic' AND #Session.sUsuarioNivel# EQ 0 AND tbAcademico.sni_exp EQ ''>
											<div style="width:70%; cursor:pointer;" onClick="fBuscaSni();">
												<span class="Sans9ViNe">Buscar NÚMERO DE EXPEDIENTE en base del SNI</span>
												<cfinput type="hidden" id="nombre_completo_pmn" name="nombre_completo_pmn" value="#tbAcademico.nombre_completo_pmn#">
											</div>
										</cfif>
									</td>
								</tr>
                                <tr>
                                    <td class="Sans9GrNe" valign="top">&nbsp;</td>
                                    <td valign="top"><!---<div id="sni_dynamic"><!-- INSERTA LOS DATOS DEL SNI --></div>---></td>
                                </tr>
                            </cfoutput>
                        </table>
						<br/>
                        <table border="0" class="cuadrosDatosAcademico"><!--- style="width:99%;  margin:0px 0px 5px 15px; border:none;" cellspacing="0" cellpadding="2"--->
                            <cfoutput>
                            <tr>
                                <td colspan="4" bgcolor="##CCCCCC"><div align="center" class="Sans12NeNe">DATOS CTIC</div></td>
                            </tr>
                            <tr>
                                <td width="20%" class="Sans9GrNe">No. expediente</td>
                                <td width="80%" class="Sans9Gr">
                                    <cfinput type="text" name="no_expediente" id="no_expediente" size="15" maxlength="15" class="datos" value="#tbAcademico.NO_EXPEDIENTE#">
                                </td>
                            </tr>
                            <tr>
                                <td class="Sans9GrNe">Fecha de crea del registro</td>
                                <td>
                                    <cfinput type="text" name="cap_fecha_crea" class="datos" id="cap_fecha_crea" value="#LsDateFormat(tbAcademico.cap_fecha_crea,"dd/mm/yyyy")# #LsDateFormat(tbAcademico.cap_fecha_crea,"HH:MM")# hrs." size="20" maxlength="20" disabled>
                                </td>
                            </tr>                        
                            <tr>
                                <td class="Sans9GrNe">Observaciones</td>
                                <td colspan="3">
                                    <cftextarea name="acd_memo" id="acd_memo" rows="5" value="#tbAcademico.acd_memo#" class="datos100"></cftextarea>
                                </td>
                            </tr>
                          </cfoutput>
                        </table>
					</cfform>
				</td>
			</tr>
		</table>
	</body>
</html>
