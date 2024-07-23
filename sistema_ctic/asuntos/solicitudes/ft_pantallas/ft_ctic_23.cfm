<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 21/04/2009 --->
<!--- FECHA ÚLTIMA MOD.: 23/04/2009 --->
<!--- FT-CTIC-23.- Informe de periodo sabático --->

<!--- Incluir los siguientes archivos --->
<cfif #vTipoComando# EQ 'IMPRIME_EJEMPLO'>
	<cfinclude template="ft_campos_blanco.cfm"> <!---PERIMITE IMPRIMIR LA FT EN BLANCO --->
	<cfset vTipoComando = 'IMPRIME'>
<cfelse>
	<cfinclude template="ft_campos.cfm">
</cfif>

<!--- Precargar fecha de inicio del periodo que se va a modificar --->
<cfif #vCampoPos12# EQ ''>
	<cfset vCampoPos12='#vFecSaba#'>
</cfif>

<!--- Obtener información del año o semestre sabático que se va a modificar --->
<cfquery name="tbMovimientos" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM movimientos
	WHERE acd_id = #vIdAcad#
	AND mov_id = #vCampoPos12#
</cfquery>

<!--- Registrar el movimiento anterior (por compatibilidad con los datos históricos) --->
<cfif #vCampoPos12# EQ ''>
	<cfif #tbMovimientos.RecordCount# GT 0>
		<cfset vCampoPos12=#tbMovimientos.mov_id#>
	</cfif>
</cfif>

<!--- Determinar el tipo del último periodo sabático disfrutado --->
<cfif #tbMovimientos.mov_clave# EQ 21>
	<cfset vTipoBecaAnterior="SIN BECA">
<cfelseif #tbMovimientos.mov_clave# EQ 30>
	<cfset vTipoBecaAnterior="CON BECA">
<cfelse>
	<cfset vTipoBecaAnterior="NO HAY">
</cfif>

<!--- ELIMINA XXXXXXXXXXXXXX
	<!--- Obtener datos del catalogo de países  (CATÁLOGOS GENERALES MYSQL) --->
	<cfquery name="ctPais" datasource="#vOrigenDatosCATALOGOS#">
		SELECT * FROM catalogo_paises
		ORDER BY pais_nombre
	</cfquery>
--->

<!--- Precargar periodo: Año o semestre --->
<cfif #vCampoPos13# EQ ''>
	<cfif DateDiff('m',#tbMovimientos.mov_fecha_inicio#, #tbMovimientos.mov_fecha_final#) GT 6>
		<cfset vCampoPos13='A'>
	<cfelse>
		<cfset vCampoPos13='S'>
	</cfif>
</cfif>

<!--- Precargar periodo: Fecha inicial --->
<cfif #vCampoPos14# EQ ''>
	<cfset vCampoPos14='#LsDateFormat(tbMovimientos.mov_fecha_inicio,'dd/mm/yyyy')#'>
</cfif>

<!--- Precargar fecha de término del periodo que se va a modificar --->
<cfif #vCampoPos15# EQ ''>
	<cfset vCampoPos15='#LsDateFormat(tbMovimientos.mov_fecha_final,'dd/mm/yyyy')#'>
</cfif>

<!--- Precargar instituciones --->
<!---
NOTA: POR AHORA NO SE PUEDE OBTENER ESTA INFORMACIÓN PORQUE EL LA TABLA DE MOVIMIENTOS NO TIENE
REGISTRADA LA SOLICITUD ASOCIADA, Y LAS INSTITUCIONES ESTÁN ASOCIADAS A LAS SOLICITUDES.
<cfquery name="tbDestinos" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM movimientos_destino, catalogo_pais WHERE pos11_p = catpais_cod AND id_ft_captura = '#vIdSol#'
</cfquery>
<cfif #tbDestinos.RecordCount# EQ 0 >
	<cfquery datasource="#vOrigenDatosSAMAA#">
		INSERT INTO movimientos_destino (id_ft_captura, acd_id, RFC, pos11, pos11_p, pos11_e, pos11_c)
		SELECT '#vIdSol#', acd_id, RFC, pos11, pos11_p, pos11_e, pos11_c WHERE id_ft_captura = '#vIdSol#'
	</cfquery>
</cfif>
--->
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
				// Validar campo de labor que desempeñó:
			    vMensaje += fValidaCampoLleno('memo1','LABOR');
				// Validar campo de destinos:
				vMensaje += fValidaDestino();
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

/* ELIMINAR 24/06/2016
			// Función para habilitar/deshabilitar el formulario para agregar instituciones:
			function fMostrarFormulario(accion)
			{
				if (accion)
				{
					// Quitar color rojo:
					document.getElementById("pos11_u").style.backgroundColor = '#FFFFFF';
					document.getElementById("pos11_p").style.backgroundColor = '#FFFFFF';
					document.getElementById("pos11_e").style.backgroundColor = '#FFFFFF';
					document.getElementById("pos11_c").style.backgroundColor = '#FFFFFF';
					// Mostrar el formulario:
					document.getElementById('frmInstitucion').style.display= '';
					document.getElementById('frmPais').style.display= '';
					document.getElementById('frmEstado').style.display= '';
					document.getElementById('frmCiudad').style.display= '';
					document.getElementById('frmBotones').style.display= '';
					// Ocultar botón de agregar institución:
					document.getElementById('cmdMostrarFormulario').style.display= 'none';
				}
				else
				{
					// Es muy importante vaciar los campos del formulario al ocultaro:
					document.getElementById('pos11_u').value = '';
					document.getElementById('pos11_p').value = '';
					document.getElementById('pos11_e').value = '';
					document.getElementById('pos11_c').value = '';
					// Ocultar el formulario:
					document.getElementById('frmInstitucion').style.display= 'none';
					document.getElementById('frmPais').style.display= 'none';
					document.getElementById('frmEstado').style.display= 'none';
					document.getElementById('frmCiudad').style.display= 'none';
					document.getElementById('frmBotones').style.display= 'none';
					// Ocultar botón de agregar institución:
					document.getElementById('cmdMostrarFormulario').style.display= '';
				}
			}
*/			
		</script>
	</head>
	<body onLoad="fListaDestino();"><!---fAgregarDestino('CONSULTA', 0);"--->
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
                                <!-- Periodo -->
                                <tr>
                                    <td colspan="2">
                                        <span class="Sans9GrNe">#ctMovimiento.mov_pos13#&nbsp;</span>
                                        <!-- Periodo -->
                                        <cfinput type="radio" name="pos13" id="pos13_1" value="A" checked="#Iif(vCampoPos13 EQ 'A',DE("yes"),DE("no"))#" disabled>
                                        <span class="Sans9Gr">A&ntilde;o&nbsp;</span>
                                        <cfinput type="radio" name="pos13" id="pos13_2" value="S" checked="#Iif(vCampoPos13 EQ 'S',DE("yes"),DE("no"))#" disabled>
                                        <span class="Sans9Gr">Semestre </span>
                                        <!-- Fechas -->
                                        <span class="Sans9Gr">#ctMovimiento.mov_pos14#</span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos14)#</span>
                                        <cfelse>
                                            <cfinput name="pos14" id="pos14" type="text" class="datos" size="11" maxlength="10" value="#vCampoPos14#" disabled>
                                        </cfif>
                                        <span class="Sans9Gr">#ctMovimiento.mov_pos15# </span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos15)#</span>
                                        <cfelse>
                                            <cfinput name="pos15" id="pos15" type="text" class="datos" size="11" maxlength="10" value="#vCampoPos15#" disabled>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Labores que desempeñó -->
                                <tr>
                                    <td colspan="2"><span class="Sans9GrNe">#ctMovimiento.mov_memo1#</span></td>
                                </tr>
                                <tr>
                                    <td width="20%"></td>
                                    <td width="80%">
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoMemo1#</span>
                                        <cfelse>
                                            <cftextarea name="memo1" rows="5" class="datos100" id="memo1" value="#vCampoMemo1#" disabled='#vActivaCampos#'></cftextarea>
                                        </cfif>
                                    </td>
                                </tr>
                            </table>
                        </cfoutput>

                         <!-- INCLUDE Instituciones donde realizó su período sabático -->
                        <cfinclude template="ft_include_destinos.cfm">
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
                                <!-- Encabezados -->
                                <tr bgcolor="##CCCCCC">
                                    <td width="85%"></td>
                                    <td width="15%"><div align="center" class="Sans10NeNe">Se anexa</div></td>
                                </tr>
                                <!-- Carta del interesado -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos32#</span></td>
                                    <td><div align="center"><cfinput name="pos32" type="checkbox" id="pos32" value="Si" checked="#Iif(vCampoPos32 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
                                </tr>
                                <!-- Informe de labores -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos34#</span></td>
                                    <td><div align="center"><cfinput name="pos34" type="checkbox" id="pos34" value="Si" checked="#Iif(vCampoPos34 EQ "Si",DE("yes"),DE("no"))#" disabled='#vActivaCampos#'></div></td>
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
