<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 17/04/2009 --->
<!--- FECHA ÚLTIMA MOD.: 17/05/2024 --->
<!--- FT-CTIC-3.-Prórroga de comisión --->

<!--- Incluir los siguientes archivos --->
<cfif #vTipoComando# EQ 'IMPRIME_EJEMPLO'>
	<cfinclude template="ft_campos_blanco.cfm"> <!---PERIMITE IMPRIMIR LA FT EN BLANCO --->
	<cfset vTipoComando = 'IMPRIME'>
<cfelse>
	<cfinclude template="ft_campos.cfm">
</cfif>

<!--- Obtener datos del catálogo de países (CATÁLOGOS GENERALES MYSQL) --->
<cfquery name="ctPais" datasource="#vOrigenDatosCATALOGOS#">
	SELECT * FROM catalogo_paises 
    ORDER BY pais_nombre
</cfquery>

<!--- Obtener datos de la primera comisión --->
<cfquery name="tbMovimientosUltimo" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM (movimientos
	LEFT JOIN movimientos_asunto ON movimientos.sol_id = movimientos_asunto.sol_id)
	LEFT JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave
	WHERE acd_id = #vIdAcad#
	AND mov_clave = 2 <!--- Comisión, Prórroga de comisión (mov_clave = 2 OR mov_clave = 3) --->
	AND asu_reunion = 'CTIC'
	AND dec_super = 'AP' <!--- Asuntos aprobados --->
	ORDER BY mov_fecha_inicio DESC
</cfquery>

<!--- Registrar el movimiento anterior (por compatibilidad con los datos históricos) --->
<cfif #vCampoPos12# EQ ''>
	<cfif #tbMovimientosUltimo.RecordCount# GT 0>
		<cfset vCampoPos12=#tbMovimientosUltimo.mov_id#>
	</cfif>
</cfif>

<!--- VERIFICA QUE EXISTAN PRORROGAS EN BASE A PARTIR DE LA FECHA DE LA ÚLTIMA COMISIÓN---->
<cfif #tbMovimientosUltimo.RecordCount# GT 0>
	<cfset vComisionDias = #DateDiff('d',tbMovimientosUltimo.mov_fecha_inicio,tbMovimientosUltimo.mov_fecha_final)# & " días">
	<cfset vComisionFechaI = #LsDateFormat(tbMovimientosUltimo.mov_fecha_inicio,'dd/mm/yyyy')#>
	<cfset vComisionFechaF = #LsDateFormat(tbMovimientosUltimo.mov_fecha_final,'dd/mm/yyyy')#>
	<cfquery name="tbMovimientosProrroga" datasource="#vOrigenDatosSAMAA#">
		SELECT * FROM (movimientos
		LEFT JOIN movimientos_asunto ON movimientos.sol_id = movimientos_asunto.sol_id)
		LEFT JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave
		WHERE acd_id = #vIdAcad#
		AND mov_clave = 3 <!--- Prórroga de comisión --->
		AND mov_fecha_inicio > '#LsDateFormat(vComisionFechaI,"dd/mm/yyyy")#'
		AND asu_reunion = 'CTIC'
		AND dec_super = 'AP' <!--- Asuntos aprobados --->
		ORDER BY mov_fecha_inicio
	</cfquery>
</cfif>

<html>
	<head>
		<!-- INCLUDE que agrega parte del contenido del encabezado -->
		<cfinclude template="ft_include_head_comun.cfm">

		<!-- JAVA SCRIT de uso local -->
		<script language="JavaScript" type="text/JavaScript">
			// Validar los datos ingresados por el usuario:
			function fValidaCamposFt()
			{
				var vOk;
				var vMensaje = '';
				fLimpiaValida();
				vMensaje = fValidaCampoLleno('memo1','OBJETO DE LA COMISIÓN');
				vMensaje += fValidaCampoLleno('pos11','INSTITUCIÓN');
				vMensaje += fValidaCampoLleno('pos11_p','PAÍS');
				// if (document.getElementById('pos11_p').value=='MEX' || document.getElementById('pos11_p').value=='USA') 
                vMensaje += fValidaCampoLleno('pos11_e','ESTADO');
				vMensaje += fValidaCampoLleno('pos11_c','CIUDAD');
				vMensaje += fValidaDuracionAMD();
				vMensaje += fValidaFecha('pos14','INICIO');
				vMensaje += fValidaDuracion();
				vMensaje += fValidaDuracionMinima(22)
				vMensaje += fValidaGoceSueldo();
				vMensaje += fValidaComisionPaspa();
				vMensaje += fValidaFechaProrroga();
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
	<body <cfif #tbMovimientosUltimo.Recordcount# GT 0>onLoad="ObtenerEstados();"</cfif>>
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
<!--- ELIMINA XXXXXXXXXXXXXX
                        <!-- Campos ocultos -->
                        <cfinput name="vFt" id="vFt" type="hidden" value="#vFt#">
                        <cfinput name="vIdAcad" type="hidden" id="vIdAcad" value="#vIdAcad#">
                        <cfinput name="vTipoComando" type="hidden" id="vTipoComando" value="#vTipoComando#">
                        <cfinput name="vIdSol" type="hidden" value="#vIdSol#">
                        <cfinput name="vSolStatus" type="hidden" value="#vSolStatus#">
--->
                        <!-- Registrar el movimiento anterior (por compatibilidad con los datos históricos -->
                        <cfinput name="pos12" type="hidden" value="#vCampoPos12#">
    
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
                            <!-- Objeto de la comisión -->
                            <tr>
                                <td colspan="2"><span class="Sans9GrNe">#ctMovimiento.mov_memo1#</span></td>
                            </tr>
                            <tr>
                                <td width="20%"></td>
                                <td width="80%">
                                    <cfif #vTipoComando# IS 'IMPRIME'>
                                        <span class="Sans9Gr">#vCampoMemo1#</span>
                                    <cfelse>
                                        <cftextarea name="memo1" cols="70" rows="5" class="datos100" id="memo1" disabled='#vActivaCampos#' value="#vCampoMemo1#"></cftextarea>
                                    </cfif>
                                </td>
                            </tr>
                            <!-- Institución en la que está comisionado -->
                            <tr>
                                <td colspan="2"><span class="Sans9GrNe">#ctMovimiento.mov_pos11#</span></td>
                            </tr>
                            <tr>
                                <td></td>
                                <td>
                                    <cfif #vTipoComando# IS 'IMPRIME'>
                                        <span class="Sans9Gr">#vCampoPos11#</span>
                                    <cfelse>
                                        <cfinput name="pos11" type="text" class="datos100" id="pos11" size="70" maxlength="254" value="#vCampoPos11#" disabled='#vActivaCampos#'>
                                    </cfif>
                                </td>
                            </tr>
                            <!-- País -->
                            <tr>
                                <td><span class="Sans9GrNe">#ctMovimiento.mov_pos11_p#</span></td>
                                <td>
                                    <cfif #vTipoComando# IS 'IMPRIME'>
                                        <cfloop query="ctPais">
                                            <cfif #pais_clave# IS #vCampoPos11_p#>
                                                <cfset vCampoPos11_p_txt = #pais_nombre#>
                                                <cfbreak>
                                            </cfif>
                                        </cfloop>
                                        <span class="Sans9Gr">#vCampoPos11_p_txt#</span>
                                    <cfelse>
                                        <cfselect name="pos11_p" class="datos" id="pos11_p" disabled='#vActivaCampos#' query="ctPais" queryPosition="below" display="pais_nombre" value="pais_clave" selected="#vCampoPos11_p#" onchange="ObtenerEstados();">
                                        <option value="">SELECCIONE</option>
                                        </cfselect>
                                    </cfif>
                                </td>
                            </tr>
                            <!-- Estado -->
                            <tr>
                                <td><span class="Sans9GrNe">#ctMovimiento.mov_pos11_e#</span></td>
                                <td id="estados_dynamic">
                                    <cfif #vTipoComando# IS 'IMPRIME'>
                                        <cfif #vCampoPos11_p# EQ 'MEX' OR #vCampoPos11_p# EQ 'USA'>
                                            <cfquery name="ctEstados" datasource="#vOrigenDatosSAMAA#">
                                                SELECT * FROM catalogo_pais_edo WHERE edo_clave = '#vCampoPos11_e#'
                                            </cfquery>
                                            <span class="Sans9Gr">#ctEstados.edo_nombre#</span>
                                        <cfelse>
                                            <span class="Sans9Gr">#vCampoPos11_e#</span>
                                        </cfif>
                                    <cfelse>
                                        <!-- AJAX: Lista de estados -->
                                    </cfif>
                                </td>
                            </tr>
                            <!-- Ciudad -->
                            <tr>
                                <td><span class="Sans9GrNe">#ctMovimiento.mov_pos11_c#</span></td>
                                <td>
                                    <cfif #vTipoComando# IS 'IMPRIME'>
                                        <span class="Sans9Gr">#vCampoPos11_c#</span>
                                    <cfelse>
                                        <cfinput name="pos11_c" id="pos11_c" type="text" class="datos" size="50" maxlength="254" value="#vCampoPos11_c#" disabled='#vActivaCampos#'>
                                    </cfif>
                                </td>
                            </tr>
                            <!-- PASPA -->
                            <tr>
                                <td colspan="2">
                                    <span class="Sans9GrNe">#ctMovimiento.mov_pos20#</span>
                                    <span class="Sans9Gr">
                                        <cfinput name="pos20" id="pos20_s" type="radio" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampopos20 EQ "Si",DE("yes"),DE("no"))#">S&iacute;&nbsp;
                                        <cfinput name="pos20" id="pos20_n" type="radio" value="No"  disabled='#vActivaCampos#' checked="#Iif(vCampopos20 EQ "No",DE("yes"),DE("no"))#">No&nbsp;
                                    </span>
                                </td>
                            </tr>
                        </table>
                        <!-- Periodo que solicita -->
                        <table id="lista_instituciones" border="0" class="cuadrosFormularios">
                            <tr bgcolor="##CCCCCC">
                                <td colspan="2">
                                    <span class="Sans9GrNe"><center>Periodo que se solicita</center></span>
                                </td>
                            </tr>
                            <!-- Duración -->
                            <tr>
                                <td width="20%"><span class="Sans9GrNe">#ctMovimiento.mov_pos13#</span></td>
                                <td width="80%">
                                    <!-- Desglose -->
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
                                            ><cfinput name="pos13_a" type="text" class="datos" id="pos13_a" size="1" maxlength="1" disabled='#vActivaCampos#' value="#vCampoPos13_a#" onchange="CalcularSiguienteFecha();" onkeypress="return MascaraEntrada(event, '9');">
                                            <span class="Sans9Gr">
                                                #ctMovimiento.mov_pos13_a#
                                            </span>
                                        </span>
                                        <span
                                            <cfif #vCampoPos13_m# EQ 0>class="NoImprimir"</cfif>
                                            ><cfinput name="pos13_m" type="text" class="datos" id="pos13_m" size="2" maxlength="2" disabled='#vActivaCampos#' value="#vCampoPos13_m#" onchange="CalcularSiguienteFecha();" onkeypress="return MascaraEntrada(event, '99');">
                                            <span class="Sans9Gr">
                                                #ctMovimiento.mov_pos13_m#
                                            </span>
                                        </span>
                                        <span
                                            <cfif #vCampoPos13_d# EQ 0>class="NoImprimir"</cfif>
                                            ><cfinput name="pos13_d" type="text" class="datos" id="pos13_d" size="2" maxlength="2" disabled='#vActivaCampos#' value="#vCampoPos13_d#" onchange="CalcularSiguienteFecha();" onkeypress="return MascaraEntrada(event, '99');">
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
                                        <cfinput name="pos14" type="text" class="datos" id="pos14" size="10" maxlength="10" disabled='#vActivaCampos#' value="#vCampoPos14#" onchange="CalcularSiguienteFecha();" onkeypress="return MascaraEntrada(event, '99/99/9999');">
                                    </cfif>
                                    <span class="Sans9Gr">#ctMovimiento.mov_pos15#</span>
                                    <cfif #vTipoComando# IS 'IMPRIME'>
                                        <span class="Sans9Gr">#FechaCompleta(vCampoPos15)#</span>
                                    <cfelse>
                                        <cfinput name="pos15" id="pos15" type="text" class="datos" size="10" maxlength="10" disabled value="#vCampoPos15#">
                                    </cfif>
                                    <!-- Campos oculos -->
                                    <cfinput type="hidden" name="pos_FechaIniUlimMov" id="pos_FechaIniUlimMov" value="#DateFormat(tbMovimientosUltimo.mov_fecha_inicio,'dd/mm/yyyy')#">
                                    <!--- Encontrar la fecha final de la última comisión o prórroga --->
                                    <cfif IsDefined('tbMovimientosProrroga') AND #tbMovimientosProrroga.RecordCount# GT 0>
                                        <cfloop query="tbMovimientosProrroga" startrow="#tbMovimientosProrroga.RecordCount#">
                                            <cfinput type="hidden" name="pos_FechaFinUlimMov" id="pos_FechaFinUlimMov" value="#DateFormat(tbMovimientosProrroga.mov_fecha_final,'dd/mm/yyyy')#">
                                        </cfloop>
                                    <cfelse>
                                        <cfinput type="hidden" name="pos_FechaFinUlimMov" id="pos_FechaFinUlimMov" value="#DateFormat(tbMovimientosUltimo.mov_fecha_final,'dd/mm/yyyy')#">
                                    </cfif>
                                </td>
                            </tr>
                            <!-- Nota SOLO PARA STCTIC -->
                            <cfif #Session.sTipoSistema# IS 'stctic'>
                            <tr>
                                <td ></td>
                                <td>
                                    <span class="Sans9GrNe">#ctMovimiento.mov_pos12_o#:</span>
                                    <cfif #vTipoComando# IS 'IMPRIME'>
                                        <span class="Sans9Gr">#vCampoPos12_o#</span>
                                    <cfelse>
                                        <cfinput name="pos12_o" type="text" class="datos" id="pos12_o" size="50" maxlength="50" disabled='#vActivaCampos#' value="#vCampoPos12_o#">
                                    </cfif>
                                </td>
                            </tr>
                            </cfif>
                            <!-- Goce de sueldo -->
                            <tr>
                                <td><span class="Sans9GrNe">#ctMovimiento.mov_pos17#</span></td>
                                <td>
                                    <span class="Sans9Gr">
                                        <cfinput onclick="pos17.disabled=true;pos17.value='100'" name="pos18" id="pos18_t" type="radio" value="T" disabled='#vActivaCampos#' checked="#Iif(vCampoPos18 EQ "T",DE("yes"),DE("no"))#"> Total&nbsp;
                                        <cfinput onclick="pos17.disabled=false;pos17.value=''" name="pos18" id="pos18_p" type="radio" value="P" disabled='#vActivaCampos#'  checked="#Iif(vCampoPos18 EQ "P",DE("yes"),DE("no"))#"> Parcial&nbsp;
                                        <cfinput type="text" name="pos17" size="4" maxlength="4" disabled class="datos" value="#vCampoPos17#" onkeypress="return MascaraEntrada(event, '99');">(%)&nbsp;
                                        <cfinput onclick="pos17.disabled=true;pos17.value='0'" name="pos18" id="pos18_sgs" type="radio" value="X" disabled='#vActivaCampos#' checked="#Iif(vCampoPos18 EQ "X",DE("yes"),DE("no"))#"> Sin goce de sueldo
                                    </span>
                                </td>
                            </tr>
                        </table>
                        </cfoutput>
                        <!-- Primer periodo autorizado -->
                        <cfif #tbMovimientosUltimo.RecordCount# GT 0>
                            <table id="lista_instituciones" border="0" class="cuadrosFormularios">
                                <tr bgcolor="#CCCCCC">
                                    <td>
                                        <span class="Sans9GrNe"><center>Primer periodo autorizado para esta comisi&oacute;n</center></span>
                                    </td>
                                </tr>
                                <tr><td height="5px"></td></tr>
                                <tr>
                                    <td align="center">
                                        <span class="Sans9Gr">
                                            <cfoutput>
                                            <cfif #vTipoComando# IS 'IMPRIME'>
                                                #vComisionDias# &nbsp;
                                            <cfelse>
                                                Duraci&oacute;n <input type="text" class="datos" size="10" maxlength="8" value="#vComisionDias#" disabled>
                                            </cfif>
                                            del
                                            <cfif #vTipoComando# IS 'IMPRIME'>
                                                #FechaCompleta(vComisionFechaI)#&nbsp;
                                            <cfelse>
                                                <input type="text" class="datos" size="10" maxlength="10" value="#vComisionFechaI#" disabled>
                                            </cfif>
                                            al
                                            <cfif #vTipoComando# IS 'IMPRIME'>
                                                #FechaCompleta(vComisionFechaF)#
                                            <cfelse>
                                                <input type="text" class="datos" size="10" maxlength="10" value="#vComisionFechaF#" disabled>
                                            </cfif>
                                            </cfoutput>
                                        </span>
                                    </td>
                                </tr>
		                        <cfif #tbMovimientosUltimo.RecordCount# GT 0>
									<cfset vNoRenova = 1>
    	                            <cfoutput query="tbMovimientosProrroga">
        	                            <tr>
            	                            <td align="center">
                	                            <span class="Sans9Gr">
                    	                            #vNoRenova#a.  Renovaci&oacute;n:
                        	                        <cfif #vTipoComando# IS 'IMPRIME'>
                            	                        #datediff('d',tbMovimientosProrroga.mov_fecha_inicio,tbMovimientosProrroga.mov_fecha_final)# días&nbsp;
                                	                <cfelse>
                                    	                Duraci&oacute;n <input type="text" class="datos" size="10" maxlength="25" disabled value="#datediff('d',tbMovimientosProrroga.mov_fecha_inicio,tbMovimientosProrroga.mov_fecha_final)# días">
                                        	        </cfif>
                                            	    del
                                                	<cfif #vTipoComando# IS 'IMPRIME'>
	                                                    #LsdateFormat(tbMovimientosProrroga.mov_fecha_inicio,'dd/mm/yyyy')# &nbsp;
    	                                            <cfelse>
        	                                            <input type="text" class="datos" size="10" maxlength="10" disabled value="#LsdateFormat(tbMovimientosProrroga.mov_fecha_inicio,'dd/mm/yyyy')#">
            	                                    </cfif>
                	                                al
                    	                            <cfif #vTipoComando# IS 'IMPRIME'>
                        	                            #LsdateFormat(tbMovimientosProrroga.mov_fecha_final,'dd/mm/yyyy')#&nbsp;
                            	                    <cfelse>
                                	                    <input type="text" class="datos" size="10" maxlength="10" disabled value="#LsdateFormat(tbMovimientosProrroga.mov_fecha_final,'dd/mm/yyyy')#">
                                    	            </cfif>
                                        	    </span>
	                                        </td>
    	                                </tr>
										<cfset vNoRenova = vNoRenova + 1>
            	                    </cfoutput>
								</cfif>
                            </table>
                        </cfif>
                        <!-- Dictámenes -->
						<!--- Llamado a INCLUDE general de los dictámenes requeridos en la FT 17/05/2024 --->
						<cfinclude template="ft_include_anexoDictamen.cfm">
<!---
                        <cfoutput>
                        <table border="0" class="cuadrosFormularios">
                            <tr bgcolor="##CCCCCC">
                                <td width="65%"></td>
                                <td width="20%"> <div align="center" class="Sans9GrNe">Aprobatoria</div></td>
                                <td width="15%"> <div align="center" class="Sans9GrNe">Se anexa</div></td>
                            </tr>
                            <!-- Opinión del consejo interno -->
                            <tr>
                                <td class="Sans9GrNe">#ctMovimiento.mov_pos26#</td>
                                <td>
                                    <div align="center">
                                        <span class="Sans9GrNe">
                                            <cfinput name="pos26" id="pos26_s" type="radio" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos26 EQ "Si",DE("yes"),DE("no"))#">S&iacute;
                                            <cfinput name="pos26" id="pos26_n" type="radio" value="No" disabled='#vActivaCampos#' checked="#Iif(vCampoPos26 EQ "No",DE("yes"),DE("no"))#">No
                                        </span>
                                    </div>
                                </td>
                                <td>
                                    <div align="center">
                                        <span class="Sans9GrNe">
                                            <cfinput name="pos27" type="checkbox" id="pos27" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos27 EQ "Si",DE("yes"),DE("no"))#">
                                        </span>
                                    </div>
                                </td>
                            </tr>
                            <!-- Carta del director -->
                            <tr>
                                <td class="Sans9GrNe">#ctMovimiento.mov_pos28#</td>
                                <td>
                                    <div align="center">
                                        <span class="Sans9GrNe">
                                            <cfinput name="pos28" id="pos28_s" type="radio" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos28 EQ "Si",DE("yes"),DE("no"))#">S&iacute;
                                            <cfinput name="pos28" id="pos28_n" type="radio" value="No" disabled='#vActivaCampos#' checked="#Iif(vCampoPos28 EQ "No",DE("yes"),DE("no"))#">No
                                        </span>
                                    </div>
                                </td>
                                <td>
                                    <div align="center">
                                        <span class="Sans9GrNe">
                                            <cfinput name="pos29" type="checkbox" id="pos29" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos29 EQ "Si",DE("yes"),DE("no"))#">
                                        </span>
                                    </div>
                                </td>
                            </tr>
                        </table>
                        </cfoutput>
--->										
                        <!-- Documentación -->
						<!--- Llamado a INCLUDE general de los anexos requeridos en la FT 17/05/2024 --->
						<cfinclude template="ft_include_anexoAnexos.cfm">
<!---										
                        <cfoutput>
                        <table border="0" class="cuadrosFormularios">
                            <tr bgcolor="##CCCCCC">
                                <td width="85%"></td>
                                <td width="15%"> <div align="center" class="Sans9GrNe">Se anexa</div></td>
                            </tr>
                            <!-- Carta del interesado -->
                            <tr>
                                <td class="Sans9GrNe">#ctMovimiento.mov_pos32#</td>
                                <td>
                                    <div align="center">
                                        <span class="Sans9GrNe">
                                            <cfinput name="pos32" type="checkbox" id="pos32" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos32 EQ "Si",DE("yes"),DE("no"))#">
                                        </span>
                                    </div>
                                </td>
                            </tr>
                            <!-- Carta fundamentada de la institución para la prórroga -->
                            <tr>
                                <td class="Sans9GrNe">#ctMovimiento.mov_pos33#</td>
                                <td>
                                    <div align="center">
                                        <span class="Sans9GrNe">
                                            <cfinput name="pos33" type="checkbox" id="pos33" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos33 EQ "Si",DE("yes"),DE("no"))#">
                                        </span>
                                    </div>
                                </td>
                            </tr>
                            <!-- Programa de actividades (avalado para el caso de técnicos académicos) -->
                            <tr>
                                <td class="Sans9GrNe">#ctMovimiento.mov_pos34#</td>
                                <!--- AGREGAR --->
                                <td>
                                    <div align="center">
                                        <span class="Sans9GrNe">
                                            <cfinput name="pos34" type="checkbox" id="pos34" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos34 EQ "Si",DE("yes"),DE("no"))#">
                                        </span>
                                    </div>
                                </td>
                            </tr>
                            <!-- Informe de actividades -->
                            <tr>
                                <td class="Sans9GrNe">#ctMovimiento.mov_pos35#</td>
                                <td>
                                    <div align="center">
                                        <cfinput name="pos35" type="checkbox" id="pos35" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos35 EQ "Si",DE("yes"),DE("no"))#">
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

<!-- Si de entrada el movimiento no procede, avisar al usuario para evitarle la captura -->
<script type="text/javascript">
	<cfif #vTipoComando# EQ 'NUEVO' AND #tbMovimientosUltimo.Recordcount# LT 1>
		alert('AVISO: El académico seleccionado no cuenta con una Comisión y/o Prorroga mayor a 22 días. Si prosigue con la captura la solicitud puede ser rechazada.');
	</cfif>
</script>