<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA CREA.: 05/10/2009 --->
<!--- FECHA ÚLTIMA MOD.: 03/12/2021 --->
<!--- Parámetros utilizados --->
<cfparam name="vFt" default="0">

<!--- Mensajes de error --->
<cfset vMsgRequeridoTxt = 'Es requerido'>
<cfset vMsgFecha = 'La fecha debe de ser Dia/Mes/Año; ejemplo ' & #LsdateFormat(NOW(),'dd/mm/yyyy')#>
<cfset vMsgNumero = 'Se requiere números enteros'>
<cfset vMsgMontos = 'Se requiere cantidades, ejemplo $8000'>

<!--- Abrir el catálogo de grados (CATÁLOGOS GENERALES MYSQL) --->
<cfquery name="ctGrado" datasource="#vOrigenDatosCATALOGOS#">
	SELECT * FROM catalogo_grados 
    ORDER BY grado_clave ASC
</cfquery>

<!--- Abrir el catálogo de movimientos (CATÁLOGOS LOCAL SAMAA)--->
<cfquery name="ctMovimiento" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_movimiento 
    WHERE mov_clave = #vFt#
</cfquery>

<!--- Abrir el catálogo de dependencias (CATÁLOGOS GENERALES MYSQL) --->
<cfquery name="ctDependencia" datasource="#vOrigenDatosCATALOGOS#">
	SELECT * FROM catalogo_dependencias
	WHERE dep_clave LIKE '03%' 
	<cfif #Session.sTipoSistema# IS 'sic'>
		AND dep_clave = '#Session.sIdDep#'
	</cfif>
	AND dep_status = 1 
	ORDER BY dep_nombre
</cfquery>

<!--- Abrir el catálogo de paises (CATÁLOGOS GENERALES MYSQL) --->
<cfquery name="ctPais" datasource="#vOrigenDatosCATALOGOS#">
	SELECT * FROM catalogo_paises 
    ORDER BY pais_nombre ASC
</cfquery>

<cffunction name="CalidadMigratoria" >
	<cfif #FORM1.nacion# NEQ "MEXICO">
		FORM1.calidad.disabled = false	
	</cfif>
</cffunction>

<html>
	<head>
		<title>STCTIC - Asuntos Acad&eacute;mico-Administrativos</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<cfoutput>
			<link href="#vCarpetaCSS#/formularios.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/general.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/fuentes.css" rel="stylesheet" type="text/css">
			<!--- <script type="text/javascript" src="#vHttpWebGlobal#/xmlHttpRequest.js"></script>--->

			<!--- LLAMADO A CÓDIGO DE JAVA SCRIPT COMÚN O GLOBAL --->
            <script type="text/javascript" src="#vCarpetaRaizLogica#/sistema_ctic/comun/java_script/limpia_validacion.js"></script>
            <script type="text/javascript" src="#vCarpetaRaizLogica#/sistema_ctic/comun/java_script/mascara_entrada.js"></script>
            <script type="text/javascript" src="#vCarpetaRaizLogica#/sistema_ctic/comun/java_script/valida_formato_fecha.js"></script>
		</cfoutput>

        <!--- ******* JQUERY ******* --->
		<cfinclude template="../comun_modulo/js_funciones_jquery.cfm">

        <!--- ******* JAVA SCRIPT USO LOCAL ******* --->
		<script language="JavaScript" type="text/JavaScript">
			//	Funciones para validar (estas funciones se encuentran al final del codigo:
			function fSeleccionaNaional()
			{
				if (document.getElementById('pais_clave').value == 'MEX')
					{ 
						document.getElementById('tr_entidad_nac').style.display = '' 
						fJQListaEstados('', 'INEGI')
						//fListaEstados();
					}
				else
					{ document.getElementById('tr_entidad_nac').style.display = 'none' }
					
				document.getElementById('pais_clave_nacimiento').value = document.getElementById('pais_clave').value
				fActualizaMigratoria()
			}

			//	Deshabilita el tipo de calidad migratoria:
			function fActualizaMigratoria()
			{
				if (document.getElementById('pais_clave_nacimiento').value == 'MEX' || document.getElementById('pais_clave_nacimiento').value == '')
				{
					document.getElementById('migratoria_dynamic').style.display = 'none'
					document.getElementById('divRfcH').style.display = 'none'
					document.getElementById('divCurp').style.display = 'none'
					// document.getElementById('migratoria_dynamic').disabled = true
				}
				else
				{
					document.getElementById('migratoria_dynamic').style.display = ''
					document.getElementById('divRfcH').style.display = ''
					document.getElementById('divCurp').style.display = ''
					// document.getElementById('migratoria_dynamic').disabled = false
				}
			}

			// FUNCION QUE LIMPIA LOS CAMPOS VALIDADOS Y MARCADOS EN COLOR
			function fLimpiaValida()
			{
				// TEMPORAL: Mientras encontramos como marcar RADIO y CHECKBOX:
				if (document.getElementById('lista_destinos_enc')) document.getElementById('lista_destinos_enc').style.background = '#FFFFFF';
				
				for (c=0; c<document.forms[0].elements.length; c++)
				{
					if (document.forms[0].elements[c].type != 'hidden' && document.forms[0].elements[c].type != 'button') document.forms[0].elements[c].style.background = '#FFFFFF';
					if (document.forms[0].elements[c].type != 'hidden' && document.forms[0].elements[c].type != 'button' && (document.forms[0].elements[c].type == 'radio' || document.forms[0].elements[c].type == 'checkbox')) document.forms[0].elements[c].style.background = '#FFFFFF';
				}
			}

			//	Funciones para validar (estas funciones se encuentran al final del código:
			function fValidaCamposNuevoAcad()
			{
				var vOk;
				var vMensaje = '';
				fLimpiaValida();				
				vMensaje = fValidaNombre();
				vMensaje += fValidaNoNulo('curp', 'CURP');
				vMensaje += fValidaFecha('fecha_nac','FECHA DE NACIMIENTO');
				vMensaje += fValidaSexo();
				if (document.getElementById('rfcc').value.length > 0 || document.getElementById('rfcn').value.length > 0)
				{
					vMensaje += fValidaRfc();
					vMensaje += fValidaRfcFeNum();
					vMensaje += fValidaNoNulo('rfcc', 'RFC');
					vMensaje += fValidaNoNulo('rfcn', 'RFC');					
				}
				vMensaje += fValidaNoNulo('dep_clave', 'ENTIDAD');
				vMensaje += fValidaNoNulo('dep_ubicacion', 'UBICACIÓN');				
				vMensaje += fValidaNoNulo('grado_clave', 'GRADO ACADÉMICO');
				
				vMensaje += fValidaNoNulo('pais_clave', 'PAÍS DE NACIMIENTO');
				if (document.getElementById('rfcc').value == 'MEX')
				vMensaje += fValidaNoNulo('pais_clave_nacimiento', 'NACIONALIDAD');				
				//if (document.getElementById('grado_clave').value != '')	vMensaje += fValidaNoNulo('acd_prefijo', 'PREFIJO DE NOMBRE');
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
			//	Validar al menos la captura de un datos en el NOMBRE:
			function fValidaNombre()
			{
				if (document.getElementById('apepat').value == '' && document.getElementById('apemat').value == '' && document.getElementById('nombres').value == '')
				{
					document.getElementById('apepat').style.backgroundColor = '#FC8C8B'
					document.getElementById('apemat').style.backgroundColor = '#FC8C8B'
					document.getElementById('nombres').style.backgroundColor = '#FC8C8B'
					return 'Debe indicar al menos APELLIDO PATERNO, MATERNO o NOMBRE\n';
				}
				else
				{
					return '';
				}
			}
			//	Validar SEXO:
			function fValidaSexo()
			{
				if (document.getElementById('Sexo_F').checked == false  && document.getElementById('Sexo_M').checked == false )
				{
					//document.getElementById('Sexo_F').style.backgroundColor = '#FC8C8B'
					//document.getElementById('Sexo_M').style.backgroundColor = '#FC8C8B'
					document.getElementById('tdSexo').style.backgroundColor = '#FC8C8B'
					return 'Campo: SEXO es obligatorio\n';
				}
				else
				{
					return '';
				}
			}
			//	Validar CALIDAD MIGRATORIA:
			function fValidaCalidad()
			{
				//if (document.getElementById('calidad_Io').checked == false && document.getElementById('calidad_Ie').checked == false  && document.getElementById('calidad_Ni').checked == false)
				if (document.getElementById('calidad_rt').checked == false && document.getElementById('calidad_rp').checked == false)
				{
					return 'Campo: CALIDAD MIGRATORIA es obligatorio\n';
				}
				else
				{
					return '';
				}
			}
			//	Validar que exista algún valor en campo:
			function fValidaNoNulo(vCampo, vTexto)
			{
				if (document.getElementById(vCampo).value == '')
				{
					document.getElementById(vCampo).style.backgroundColor = '#FC8C8B'
					return "Campo: " + vTexto +  " es obligatorio\n";
				}
				else
				{
					return '';
				}
			}
			//	Validar RFC:
			function fValidaRfc()
			{
				if (document.getElementById('rfcc').value.length < 4)
				{
					document.getElementById('rfcc').style.backgroundColor = '#FC8C8B'
					return 'Campo: RFC debe tener cuatro caracteres de texto\n';
				}
				else if (document.getElementById('rfcn').value.toString().length < 6)
				{
					document.getElementById('rfcn').style.backgroundColor = '#FC8C8B'
					return 'Campo: RFC debe tener seis caracteres de numericos\n';
				}
				else
				{
					return '';
				}
			}
			//	VALIDA LA APRTE DE FECHA DE NACIMIENTO DEL RFC:
			function fValidaRfcFeNum()
			{
				var vMensajesRfc = ''
				if (parseInt(document.getElementById('rfcn').value.substring(2,4)) > 12)
				{
					document.getElementById('rfcn').style.backgroundColor = '#FC8C8B'
					vMensajesRfc += 'Campo: RFC ESTA COMPUESTO POR año|MES|día el MES de nacimiento no debe ser mayor a 12\n'
				}
				if (parseInt(document.getElementById('rfcn').value.substring(4,6)) > 31)
				{
					document.getElementById('rfcn').style.backgroundColor = '#FC8C8B'
					vMensajesRfc += 'Campo: RFC ESTA COMPUESTO POR año|mes|DÍA; el DÍA de nacimiento no debe ser mayor a 31\n'
				}
				return vMensajesRfc;
			}
			
			// FUNCIÓN PARA GUARDAR FORMULARIO PREVIA VALIDACION (SOLO EN CASO DE HACERLO DESDE UNA FORMA TELEGRÁMICA)
			function fGuardaNuevoAcad()		
			{
				if (fValidaCamposNuevoAcad) ValidaOK = fValidaCamposNuevoAcad();
				if (ValidaOK)
				{
					//alert(document.forms['frmNuevoAcad'].action);
					document.forms['frmNuevoAcad'].submit();
				}
			}

		</script>
	</head>
	<body> <!---onLoad="fJQObtenerUbicacion();  fJQListaPrefijos(''); fActualizaMigratoria();" --->
		<cfform name="frmNuevoAcad" id="frmNuevoAcad" method="POST" action="#vCarpetaRaizLogica#/sistema_ctic/academicos/academico_nuevo/nuevo_academico_verifica.cfm">
            <cfinput name="vFt" id="vFt" type="#vTipoInput#" value="#vFt#">
            <!--- <cfinput name="vIdSol" type="hidden" value="#vIdSol#"> --->
            <cfinput name="fecha_crea" type="#vTipoInput#" id="fecha_crea" value="#LSDateFormat(Now(), "dd/mm/yyyy")#">
            <cfinput name="MM_GuardaReg" type="#vTipoInput#" id="MM_GuardaReg" value="NUEVO">
            <cfif #vFt# EQ "5">
                <cfinput name="vIdCoa" id="vIdCoa" type="" value="#vIdCoa#">
            </cfif>
	         <!-- Cuerpo de la lista de solicitudes -->
            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <!-- Columna derecha (formulario) -->
                    <td align="center">
                        <div class="Sans12GrNe" align="center">
                          <cfoutput>#Ucase(ctMovimiento.mov_titulo)#</cfoutput><br>
                            NUEVO ACAD&Eacute;MICO<br>
                            <br><br>
                        </div>
                        <table width="95%" border="0" class="cuadros">
                            <!-- Apellido paterno -->
                            <tr>
                                <td width="20%" colspan="2" class="Sans9GrNe">Apellido paterno</td>
                                <td width="80%"><cfinput name="apepat" id="apepat" type="text" class="datos" size="50" maxlength="254"></td>
                            </tr>
                            <!-- Apellido materno -->
                            <tr>
                                <td colspan="2" class="Sans9GrNe">Apellido materno </td>
                                <td><cfinput name="apemat" id="apemat" type="text" class="datos" size="50" maxlength="254"></td>
                            </tr>
                            <!-- Nombres -->
                            <tr>
                                <td class="Sans9GrNe">Nombre(s)</td>
                                <td><span class="Arial10rojaN">*</span></td>
                                <td><cfinput name="nombres" type="text" class="datos" id="nombres" size="50" maxlength="254"></td>
                            </tr>
                            <!-- CURP -->
                            <tr>
                                <td class="Sans9GrNe">CURP</td>
                                <td><span class="Arial10rojaN">*</span></td>
                                <td>
                                    <cfinput name="curp" type="text" class="datos" id="curp" size="22" maxlength="20">
                                    <div id="divCurp"><span class="Sans9Vi">En caso de no contar con la CURP por ser extranjero teclee "EXTRANJERO" en el campo correspondiente</span></div>
                                </td>
                            </tr>
                            <!-- RFC -->
                            <tr>
                                <td class="Sans9GrNe">RFC</td>
                                <td>&nbsp;</td>
                                <td>
                                    <cfinput name="rfcc" type="text" class="datos" id="rfcc" size="4" maxlength="4" onkeypress="return MascaraEntrada(event, 'AAAA');"> -
                                    <cfinput name="rfcn" type="text" class="datos" id="rfcn" size="6" maxlength="6" onkeypress="return MascaraEntrada(event, '999999');"> -
                                    <cfinput name="rfch" type="text" class="datos" id="rfch" size="4" maxlength="3">
                                    <div id="divRfcH"><span class="Sans9Vi">En caso de no contar con Homoclave por ser extranjero teclee "XXX" en el campo correspondiente</span></div>
                                </td>
                            </tr>
                            <!-- Dependencia -->					
                            <tr>
                                <td class="Sans9GrNe">Entidad</td>
                                <td>&nbsp;</td>
                                <td>
                                    <cfselect name="dep_clave" id="dep_clave" class="datos" query="ctDependencia" value="dep_clave" display="dep_nombre" queryPosition="below" onChange="fJQObtenerUbicacion();">
                                        <cfif #ctDependencia.recordcount# GT 1>
                                            <option selected value="">SELECCIONE</option>
                                        </cfif>
                                    </cfselect>
									<cfinput name="vUbicaClave" id="vUbicaClave" value="" type="hidden" size="5" maxlength="5" class="datos">
                              </td>
                            </tr>
                            <!-- Ubicación -->
                            <tr>
                                <td class="Sans9GrNe">Ubicaci&oacute;n</td>
                                <td>&nbsp;</td>
                              <td><div id="adscripcion_dynamic"><!-- Esta lista se actualiza con AJAX --></div></td>
                            </tr>
                            <!-- FECHA DE NACIMIENTO -->
                            <tr>
                                <td class="Sans9GrNe">Fecha nacimiento</td>
                                <td><span class="Arial10rojaN">*</span></td>
                                <td><cfinput name="fecha_nac" id="fecha_nac" type="text" class="datos" size="10" maxlength="10" onkeypress="return MascaraEntrada(event, '99/99/9999');"> 
                                <span class="Sans9GrNe">dd/mm/aaaa</span></td>
                            </tr>
                            <!-- País de nacimiento -->
                            <tr>
                                <td class="Sans9GrNe">Pa&iacute;s de nacimiento</td>
                                <td><span class="Arial10rojaN">*</span></td>
                                <td>
                                    <cfselect name="pais_clave" id="pais_clave" class="datos" query="ctPais" queryPosition="below" display="pais_nombre" value="pais_clave" onChange="fSeleccionaNaional();">
                                        <option value="">SELECCIONE</option>
                                    </cfselect>
                                </td>
                            </tr>
                            <!-- Entidad / Estado de nacimiento -->
                            <tr id="tr_entidad_nac" style="display:none">
                                <td class="Sans9GrNe">Entidad de nacimiento</td>
                                <td><span class="Arial10rojaN">*</span></td>
                                <td><div id="edonacimiento_dynamic"><!-- Esta lista se actualiza con AJAX --></div></td>
                            </tr>
                            <tr>
                                <td class="Sans9GrNe">Nacionalidad</td>
                                <td><span class="Arial10rojaN">*</span></td>
                                <td>
                                    <cfselect name="pais_clave_nacimiento" id="pais_clave_nacimiento" class="datos" query="ctPais" queryPosition="below" display="pais_nacionalidad" value="pais_clave" onChange="fActualizaMigratoria();">
                                        <option value="">SELECCIONE</option>
                                    </cfselect>
                                </td>
                            </tr>
                            <!-- Calidad migratoria -->
                            <tr id="migratoria_dynamic">
                                <td><span class="Sans9GrNe">Calidad migratoria</span></td>
                                <td><span class="Arial10rojaN">*</span></td>
                                <td id="tdPos">
                                    <cfinput name="calidad" id="calidad_rt" type="radio" value="4"><span class="Sans9ViNe">Residente temporal</span>
                                    <cfinput name="calidad" id="calidad_rp" type="radio" value="5"><span class="Sans9ViNe">Residente permanente</span>                            
<!---                            
                                    <cfinput name="calidad" id="calidad_Ni" type="radio" value="3">
                                    <span class="Sans9ViNe">No inmigrante (Visitante) </span><span class="Sans12Ne" style="background-color:#999;" onClick="alert('>No inmigrante (Visitante): Visitante con/sin actividades lucrativas o estudiantes.')" onMouseOver="this.style.cursor='pointer';this.style.textDecoration='underline';" onMouseOut="this.style.textDecoration='none';">&nbsp;?&nbsp;</span>
                                    <cfinput name="calidad" id="calidad_Ie" type="radio" value="2">
                                    <span class="Sans9ViNe">Inmigrante </span><span class="Sans12Ne" style="background-color:#999;" onClick="alert('Inmigrante: Se les considera a los que tienen más de 5 años en el país.')" onMouseOver="this.style.cursor='pointer';this.style.textDecoration='underline';" onMouseOut="this.style.textDecoration='none';">&nbsp;?&nbsp;</span>
                                    <cfinput name="calidad" id="calidad_Io" type="radio" value="1">
                                    <span class="Sans9ViNe">Inmigrado </span><span class="Sans12Ne" style="background-color:#999;" onClick="alert('Inmigrado: Se les considera a los que tienen más de 10 años en el país.')" onMouseOver="this.style.cursor='pointer';this.style.textDecoration='underline';" onMouseOut="this.style.textDecoration='none';">&nbsp;?&nbsp;</span>
--->
                                </td>
                            </tr>
                            <!-- Sexo -->
                            <tr>
                                <td width="122" class="Sans9GrNe">Sexo</td>
                                <td><span class="Arial10rojaN">*</span></td>
                                <td id="tdSexo">
                                    <cfinput name="Sexo" id="Sexo_F" type="radio" value="F"><span class="Sans9Gr">Mujer</span>
                                    <cfinput name="Sexo" id="Sexo_M" type="radio" value="M"><span class="Sans9Gr">Hombre</span>
                                </td>
                            </tr>
                            <!-- Prefijo de nombre (grado académico) -->
                            <tr>
                                <td class="Sans9GrNe">Grado Acad&eacute;mico</td>
                                <td><span class="Arial10rojaN">*</span></td>
                                <td>
                                    <cfselect name="grado_clave" id="grado_clave" query="ctGrado" queryPosition="below" display="grado_descrip" value="grado_clave" class="datos" onchange="fJQListaPrefijos('')">
                                        <option value="" selected>SELECCIONE</option>
                                    </cfselect>
                                </td>
                            </tr>
                            <!-- Prefijo de nombre (del grado académico) -->
                            <tr>
                                <td class="Sans9GrNe">Prefijo de nombre</td>
                                <td><span class="Arial10rojaN">*</span></td>
                                <td colspan="3" class="Sans9Gr"><div id="prefijo_dynamic"><!-- Esta lista se actualiza con AJAX --></div></td>
                            </tr>
                            <!-- Correo electrónico -->
                            <tr>
                                <td class="Sans9GrNe">Correo electr&oacute;nico </td>
                                <td>&nbsp;</td>
                                <td><cfinput name="email" type="text" class="datos" id="email" size="60" maxlength="254"></td>
                            </tr>
                        </table>
                        <!-- Notas -->
                      <div align="left" class="Arial10rojaN"><i>* Campos obligatorios</i></div>
                    </td>
                </tr>
				<tr>
					<td align="center">
						<table width="30%" >
							<tr>
								<td align="center" width="50%"><cfinput name="cmdEnviaNuevoAcad" id="cmdEnviaNuevoAcad"  type="button" class="botones" value="Guardar" onclick="fGuardaNuevoAcad();"></td>
								<td align="center" width="50%"><cfinput name="cmdCancelaEnviaAcad" id="cmdCancelaEnviaAcad" type="button" class="botones" value=" Cancelar" onclick="window.history.go(-1)"></td>
							</tr>
						</table>
					</td>
				</tr>
            </table>
		</cfform>
	</body>
</html>
<!--- SE CAMBIÓ DE POSICIÓN YA QUE COMO ES UN MODAL , EL ONLOAD NO FUNCIONA 03/12/2021 --->
<script language="JavaScript" type="text/JavaScript">                
    fJQObtenerUbicacion();  
    fJQListaPrefijos(''); 
    fActualizaMigratoria();
</script>