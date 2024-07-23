<!--- CREADO: ARAM PICHARDO--->
<!--- EDITO: ARAM PICHARDO--->
<!--- FECHA CREA: 04/06/2009 --->
<!--- FECHA ÚLTIMA MOD.: 19/07/2024 --->
<!--- FT-CTIC-14.-Baja--->

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

<!--- Obtener información del catálogo de bajas --->
<cfquery name="ctBaja" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_baja
    ORDER BY baja_descrip
</cfquery>


<cfif #vTipoComando# IS 'IMPRIME'>
    <cfquery name="ctTipoContrato" datasource="#vOrigenDatosSAMAA#">
        SELECT * FROM catalogo_contrato
        WHERE con_clave = #vCampoPos5#
    </cfquery>
	<cfif  #vCampoPos12_o# NEQ ''>
	    <cfquery name="tbMovimientoInterrumpidoImp" datasource="#vOrigenDatosSAMAA#">
	        SELECT * FROM movimientos T1
	        LEFT JOIN catalogo_movimiento C2 ON T1.mov_clave = C2.mov_clave
	        WHERE T1.acd_id = #vIdAcad#
			AND T1.mov_id = #vCampoPos12_o#
    	</cfquery>
		<cfset vMovFt = #tbMovimientoInterrumpidoImp.mov_clave#>
    	<cfset vDatosMovimiento = #UCASE(tbMovimientoInterrumpidoImp.mov_titulo_corto)# & ' ' & #LsDateFormat(tbMovimientoInterrumpidoImp.mov_fecha_inicio,'dd/mm/yyyy')# & ' - ' & #LsDateFormat(tbMovimientoInterrumpidoImp.mov_fecha_final,'dd/mm/yyyy')#>
	<cfelse>
		<cfset vMovFt = 0>
		<cfset vDatosMovimiento = ''>
	</cfif>
<cfelse>
	<cfset vMovFt = 0>
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
				var vMensaje = '';
				fLimpiaValida();
				vMensaje += fValidaCampoLleno('pos1_u','UBICACIÓN');
				vMensaje += fValidaCampoLleno('pos12','CAUSA');
				vMensaje += fValidaFecha('pos14','A PARTIR DEL');
				//if ($("#pos9").length > 0 )
				//{
				//	vMensaje += fValidaCampoLleno('pos9','NÚMERO DE PLAZA');
				//}
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

			function fHabilitaDesAjax()
			{
				//alert(document.getElementById('pos12_o').options[document.getElementById('pos12_o').selectedIndex].label.substring(0,2));
				//if(document.getElementById('pos12_o').options[document.getElementById('pos12_o').selectedIndex].getAttribute('movClave') == '38'  || document.getElementById('pos12_o').options[document.getElementById('pos12_o')].getAttribute('movClave') == '39')
				if(document.getElementById('pos12_o').options[document.getElementById('pos12_o').selectedIndex].getAttribute('movClave') == '38'  || document.getElementById('pos12_o').options[document.getElementById('pos12_o').selectedIndex].getAttribute('movClave') == '39')
				{
					hide('trCcn');
					hide('trConClave');
					hide('trConClave2');
					hide('trAntig');
					hide('trPlaza');
					document.getElementById('pos5_bp').checked = 'true';
				}
				else
				{
					show('trCcn');
					show('trConClave2');
					show('trAntig');
					show('trPlaza');
					if(document.getElementById('pos12_o').options[document.getElementById('pos12_o').selectedIndex].getAttribute('movClave') == '6')document.getElementById('pos5_o').checked = 'true';
				}
			}
			// AJAX para ligar la baja con un movimiento
			function fLigaBaja()
			{
				if (document.getElementById('pos12').value == 6 || document.getElementById('pos12').value == 9 || document.getElementById('pos12').value == 11 || document.getElementById('pos12').value == 12)
				{
					hide('trCcn');
					hide('trConClave2');
					hide('trAntig');
					hide('trPlaza');
					//document.getElementById('pos5_bp').checked = 'true';
					// alert('BECA')
				}
				else
				{
					show('trCcn');
					show('trConClave2');
					show('trAntig');
					show('trPlaza');
					// alert('OTROS MOV')
				}
				if (document.getElementById('pos12').value == 1 || document.getElementById('pos12').value == 4 || document.getElementById('pos12').value == 5 || document.getElementById('pos12').value == 6  || document.getElementById('pos12').value == 8  || document.getElementById('pos12').value == 9)
				{
					show('trMovRel');
					// Crear un objeto XmlHttpRequest:
					var xmlHttp = XmlHttpRequest();
					// Función de atención a las petición HTTP:
					xmlHttp.onreadystatechange = function(){
						if (xmlHttp.readyState == 4) {
							document.getElementById('ajax_liga_baja').innerHTML = xmlHttp.responseText;
							if ($("#pos12_o").length > 0)
							{
								fHabilitaDesAjax();
							}
						}
					}
					// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones
					xmlHttp.open("POST", "ft_ajax/tipo_mov_baja.cfm", true);
					xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
					// Crear la lista de parámetros:
					parametros = "vAcdId=" + encodeURIComponent(document.getElementById('pos2').value);
					parametros += "&vBajaClave=" + encodeURIComponent(document.getElementById('pos12').value);
					parametros += "&vCampoPos12_o=" + encodeURIComponent('<cfoutput>#vCampoPos12_o#</cfoutput>');
					parametros += "&txtMov_pos12_o=" + encodeURIComponent('<cfoutput>#ctMovimiento.mov_pos12_o#</cfoutput>');
					parametros += "&vActivaCampos=" + encodeURIComponent('<cfoutput>#vActivaCampos#</cfoutput>');
					// Enviar la petición HTTP:
					xmlHttp.send(parametros);
					// Es necesario habilitar el campo de Ciudad en caso de haberse deshabilitado:
					<cfif #vActivaCampos# IS NOT 'disabled'>if (document.getElementById('pos11_c'))  document.getElementById('pos11_c').disabled = false;</cfif>
				}
				else
				{
					document.getElementById('ajax_liga_baja').innerHTML = '';
					hide('trMovRel');
				}
			}

			// ENVÍA NOTIFICACION
			function fEnviaNotificaBaja()
			{
					var xmlHttp = XmlHttpRequest();
					// Función de atención a las petición HTTP:
					xmlHttp.onreadystatechange = function(){
						document.getElementById('ajax_envia_notifica_baja').innerHTML = xmlHttp.responseText;
						document.getElementById('cmdNotificaBaja').disabled = true;
					}
					// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones
					xmlHttp.open("POST", "<cfoutput>#vCarpetaCOMUN#</cfoutput>/correo_renuncia_beca_posdoc.cfm", true);
					xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
					// Crear la lista de parámetros:
					parametros = "vSolId=" + encodeURIComponent(document.getElementById('vIdSol').value);
					// Enviar la petición HTTP:
					xmlHttp.send(parametros);
			}			
		</script>
	</head>
	<body onLoad="fLigaBaja();">
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
                                <!-- Causa -->
                                <tr>
                                    <td width="20%"><span class="Sans9GrNe">#ctMovimiento.mov_pos12# </span></td>
                                    <td width="80%">
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <cfloop query="ctBaja">
                                                <cfif #baja_clave# IS #vCampoPos12#>
                                                    <cfset vCampoPos12_txt = '#baja_descrip#'>
                                                    <cfbreak>
                                                </cfif>
                                            </cfloop>
                                            <span class="Sans9Gr">#vCampoPos12_txt#</span><cfinput name="pos12" id="pos12" type="hidden" value="#vCampoPos12#">
                                        <cfelse>
                                            <cfselect name="pos12" id="pos12" class="datos" query="ctBaja" queryPosition="below" value="baja_clave" display="baja_descrip" selected="#vCampoPos12#" onChange="fLigaBaja();" disabled='#vActivaCampos#'>
                                            <option value="">SELECCIONE</option>
                                            </cfselect>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Mustra AJAX de los posibles movimientos a dar de baja -->
                                <tr id="trMovRel">
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos12_o#</span></td>
                                    <td>
                                    <cfif #vTipoComando# NEQ 'IMPRIME' AND (#vMovFt# NEQ 38 AND #vMovFt# NEQ 39)>
                                        <div id="ajax_liga_baja"></div></td>
                                    <cfelse>
                                       	<span class="Sans9Gr">#vDatosMovimiento#</span>
                                    </cfif>
                                </tr>
                                <!-- A partir del -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos14#</span></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos14)#</span>
                                        <cfelse>
                                            <cfinput name="pos14" type="text" class="datos" id="pos14" size="10" maxlength="10" value="#vCampoPos14#" onkeypress="return MascaraEntrada(event, '99/99/9999');" disabled='#vActivaCampos#'>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Número de plaza -->
                                <cfif #vMovFt# NEQ 38 OR #vMovFt# NEQ 39>
                                    <tr id="trPlaza">
                                        <td><span class="Sans9GrNe">#ctMovimiento.mov_pos9#</span></td>
                                        <td>
                                            <cfif #vTipoComando# IS 'IMPRIME'>
                                                <span class="Sans9Gr">#vCampoPos9#</span>
                                            <cfelse>
                                                <cfinput name="pos9" type="text" class="datos" id="pos9" size="8" maxlength="8" value="#vCampoPos9#"  onkeypress="return MascaraEntrada(event, '99999-99');" disabled='#vActivaCampos#'>
                                            </cfif>
                                        </td>
                                    </tr>
                                </cfif>
                                <!-- Observaciones -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_memo1#</span></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoMemo1#</span>
                                        <cfelse>
                                            <cftextarea name="memo1" rows="5" class="datos100" id="memo1" value="#vCampoMemo1#" disabled='#vActivaCampos#'></cftextarea>
                                        </cfif>
                                    </td>
                                </tr>
                            </table>
                        </cfoutput>
						<!-- Documentación -->
						<!--- Llamado a INCLUDE general de los anexos requeridos en la FT 18/07/2024 --->
						<cfinclude template="ft_include_anexoAnexos.cfm">
<!---
                        <cfoutput>
                            <table border="0" class="cuadrosFormularios">
                                <tr bgcolor="##CCCCCC">
                                    <td width="85%"></td>
                                    <td width="15%"><div align="center" class="Sans10NeNe">Se anexa</div></td>
                                </tr>
                                <!-- Carta del interesado con la renuncia, si existe -->
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos31#</span></td>
                                    <td width="100">
                                        <div align="center">
                                            <cfinput name="pos31" type="checkbox" id="pos31" value="Si" checked="#Iif(vCampoPos31 EQ 'Si',DE("yes"),DE("no"))#" disabled='#vActivaCampos#'>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </cfoutput>
--->
						<!--- INCLUDE LLAMADO A CÓDIGO DE NOTIFICACIÓN DE RENUNCIA DE BECAS POSDOCTORAL --->
						<cfif #vTipoComando# EQ 'CONSULTA' AND #vCampoPos5# EQ 6 AND #vSolStatus# GTE 3 AND (#vCampoPos12# EQ 1 OR #vCampoPos12# EQ 6 OR #vCampoPos12# EQ 8)>
							<cfinclude template="ft_include_correo_notifica_envio.cfm">
                        </cfif>

						<!--- INCLUDE PARA SELECCIONAR FIRMA DE FORMA TELEGRÁMICA --->
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
