<!--- CREADO: ARAM PICHARDO--->
<!--- EDITO: ARAM PICHARDO--->
<!--- FECHA CREA: 05/06/2009--->
<!--- FECHA �LTIMA MOD.: 19/07/2024 --->
<!--- FT-CTIC-18.-Nuevo dictamen de Definitividad--->

<!--- Incluir los siguientes archivos --->
<cfif #vTipoComando# EQ 'IMPRIME_EJEMPLO'>
	<cfinclude template="ft_campos_blanco.cfm"> <!---PERIMITE IMPRIMIR LA FT EN BLANCO --->
	<cfset vTipoComando = 'IMPRIME'>
<cfelse>
	<cfinclude template="ft_campos.cfm">
</cfif>

<!--- Obtener la lista de ubicaciones de la dependencia (CAT�LOGOS GENERALES MYSQL) --->
<cfquery name="ctUbicacion" datasource="#vOrigenDatosCATALOGOS#">
	SELECT *, CONCAT(TRIM(ubica_nombre),  ', ', TRIM(ubica_lugar)) AS ubica_completa
    FROM catalogo_dependencias_ubica
	WHERE dep_clave = '#vCampoPos1#' 
    AND ubica_status = 1
	ORDER BY ubica_clave
</cfquery>

<!--- Buscar el registro de definitividad devuelto --->
<cfquery name="tbMovimientos" datasource="#vOrigenDatosSAMAA#">
	SELECT *
	FROM (movimientos  AS T1
	LEFT JOIN movimientos_asunto AS T2 ON T1.sol_id = T2.sol_id)
	LEFT JOIN catalogo_decision AS C2 ON T2.dec_clave = C2.dec_clave
	WHERE acd_id = #vIdAcad#
	AND (T1.mov_clave = 7 OR T1.mov_clave = 8)
	AND T2.asu_reunion = 'CTIC'
	AND C2.dec_super = 'DE' <!--- Asuntos devueltos SE CAMBIO POR EL C�DIGO DE ABAJO --->
	<!--- AND movimientos_asunto.dec_clave = 10  Asuntos devueltos --->
	<!--- Creo que aqu� falta la validaci�n de no m�s de 15 d�as --->
	ORDER BY T1.mov_fecha_inicio DESC
</cfquery>

<!--- Registrar el movimiento anterior (por compatibilidad con los datos hist�ricos) --->
<cfif #vCampoPos12# EQ ''>
	<cfif #tbMovimientos.RecordCount# GT 0>
		<cfset vCampoPos12=#tbMovimientos.mov_id#>
	</cfif>
</cfif>

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
				vMensaje += fValidaCampoLleno('pos1_u','UBICACI�N');
				vMensaje += fValidaFecha('pos14','DEFINITIVIDAD A PARTIR DEL');
				vMensaje += <cfoutput>#tbMovimientos.RecordCount#</cfoutput> > 0 ? '' : 'No se encontr� el dictamen de DEFINITIVIDAD devuelto por el CTIC.\n';
				vMensaje += document.getElementById('vNoAniosCcnDef').value < 3 ? 'El acad�mico no cumple con el requisito de tener como m�nimo 3 a�os de antig�edad.\n': '';
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
		<!--- INCLUDE Cintillo con nombre y n�mero de forma telegr�mica / INCLUDE que contiene FORM para abrir archivo PDF (05/04/2019) --->
        <cfinclude template="ft_include_cintillo.cfm">
		<!--- FORMULARIO forma telegr�mica --->
		<cfform name="formFt" id="formFt" method="POST" enctype="multipart/form-data" action="#vRutaPagSig#">
            <!-- Forma telegr�mica -->
            <table width="100%" border="0">
                <tr>
                    <!-- Men� lateral -->
                    <cfif #vTipoComando# IS NOT 'IMPRIME' AND #vHistoria# IS NOT 1>
                        <td class="menuformulario">
                            <!-- INCLUDE M�nu izquierdo -->
                            <cfinclude template="ft_include_menu.cfm">
                        </td>
                    </cfif>
                    <!-- Formulario -->
                    <td class="formulario">
                        <!-- INCLUDE Titulos de la forma telegr�mica -->
                        <cfinclude template="ft_include_titulos.cfm">
                        <!-- INCLUDE Campos ocultos GENERALES-->
                        <cfinclude template="ft_include_campos_ocultos.cfm">
                        <!-- Registrar el movimiento anterior (por compatibilidad con los datos hist�ricos -->
                        <cfinput name="pos12" type="hidden" value="#vCampoPos12#">

                        <!-- Datos para ser llenados por la ST-CTIC -->
                        <cfif #Session.sTipoSistema# IS 'stctic' AND #vSolStatus# LT 3 AND #vTipoComando# IS NOT 'NUEVO' AND #vTipoComando# IS NOT 'IMPRIME' AND #vHistoria# IS NOT 1>
                            <cfinclude template="ft_control.cfm">
                        </cfif>

                        <!-- INCLUDE para visualisar Datos generales -->
                        <cfinclude template="ft_include_general.cfm">
                        <!-- INCLUDE para visualisar Informaci�n Acad�mica -->
                        <cfinclude template="ft_include_datos_academicos.cfm">
                        <!-- Datos que deben ingresarse -->
                        <cfoutput>
                            <table border="0" class="cuadrosFormularios">
                                <!-- Se solicita definitividad a partir del -->
                                <tr>
                                    <td>
                                        <span class="Sans9GrNe">#ctMovimiento.mov_pos14#&nbsp;</span>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos14)#</span>
                                        <cfelse>
                                            <cfinput name="pos14" id="pos14" type="text" class="datos" size="10" maxlength="10" value="#vCampoPos14#" disabled='#vActivaCampos#' onkeypress="return MascaraEntrada(event, '99/99/9999');" onBlur="ObtenerCcnDef();">
                                            <div id="ccnactual_dynamic"><!-- AJAX: A�os de actividad ininterrumpida --></div>
                                        </cfif>
                                    </td>
                                </tr>
                            </table>
                        </cfoutput>
  						<!-- Dict�menes -->
						<!--- Llamado a INCLUDE general de los dict�menes requeridos en la FT 19/07/2024 --->
						<cfinclude template="ft_include_anexoDictamen.cfm">
<!---
                        <cfoutput>
                            <table border="0" class="cuadrosFormularios">
                                <tr bgcolor="##CCCCCC">
                                    <td width="65%"></td>
                                    <td width="20%"><div align="center" class="Sans10NeNe">Aprobatorio</div></td>
                                    <td width="15%"><div align="center" class="Sans10NeNe">Se anexa</div></td>
                                </tr>
                                <!-- Nuevo Dictamen de la Comisi�n Dictaminadora -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos30#</span></td>
                                    <td>
                                        <div align="center">
                                            <span class="Sans9GrNe">
                                                <cfinput name="pos30" type="radio" value="Si" checked="#Iif(vCampoPos30 EQ 'Si',DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>S&iacute;&nbsp;
                                                <cfinput name="pos30" type="radio" value="No" checked="#Iif(vCampoPos30 EQ 'No',DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>No
                                            </span>
                                        </div>
                                    </td>
                                    <td>
                                        <div align="center">
                                            <cfinput name="pos31" type="checkbox" id="pos31" value="Si" checked="#Iif(vCampoPos31 EQ 'Si',DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </cfoutput>
--->
						<!-- Documentaci�n -->
						<!--- Llamado a INCLUDE general de los anexos requeridos en la FT 19/07/2024 --->
						<cfinclude template="ft_include_anexoAnexos.cfm">
<!---
                        <cfoutput>
                            <table border="0" class="cuadrosFormularios">
                                <tr bgcolor="##CCCCCC">
                                    <td width="85%"></td>
                                    <td width="15%"><div align="center" class="Sans10NeNe">Se anexa</div></td>
                                </tr>
                                <!-- Copia del oficio enviado por el CTIC a la Comisi�n Dictaminadora -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos33#</span></td>
                                    <td>
                                        <div align="center">
                                            <cfinput name="pos33" type="checkbox" id="pos33" value="Si" checked="#Iif(vCampoPos33 EQ 'Si',DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>
                                        </div>
                                    </td>
                                </tr>
                                <!-- Curriculum vitae -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos36#</span></td>
                                    <td>
                                        <div align="center">
                                            <cfinput name="pos36" type="checkbox" id="pos36" value="Si" checked="#Iif(vCampoPos36 EQ 'Si',DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>
                                        </div>
                                    </td>
                                </tr>
                                <!-- Trabajos publicados -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos39#</span></td>
                                    <td>
                                        <div align="center">
                                            <cfinput name="pos39" type="checkbox" id="pos39" value="Si" checked="#Iif(vCampoPos39 EQ 'Si',DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>
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
	<cfif #vTipoComando# EQ 'NUEVO' AND #tbMovimientos.RecordCount# LT 1>
		alert('AVISO: No se encontr� el dictamen de DEFINITIVIDAD devuelto por el CTIC. Si prosigue con la captura la solicitud ser� rechazada.');
	</cfif>
</script>
