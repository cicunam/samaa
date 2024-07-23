<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA CREA: 30/10/2009--->
<!--- FECHA ÚLTIMA MOD: 10/03/2023 --->
<!--- DATOS DE CONTROL DEL ASUNTO --->
<!--- Datos de control del registro --->

<!--- Obtener los datos de la solicitud --->
<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM movimientos_solicitud 
    WHERE movimientos_solicitud.sol_id = #vIdSol#
</cfquery>

<!--- Obtener la ubicación principal de la entidad que está capturando --->
<cfquery name="ctDepUbica" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_dependencia_ubica 
    WHERE dep_clave = '#vCampoPos1#' 
    AND dbo.TRIM(ubica_clave) = '01'
</cfquery>

<!--- INCLUDE para obtener el nombre del director para firma --->
<cfinclude template="#vCarpetaCOMUN#/include_firma_docs.cfm">

<cfif #tbSolicitudes.sol_fecha_firma# EQ "">
	<cfset vFechaFirma = #LsDateFormat(now(),'dd/mm/yyyy')#>
<cfelse>
	<cfset vFechaFirma = #LsDateFormat(tbSolicitudes.sol_fecha_firma,'dd/mm/yyyy')#>
</cfif>

<!-- Script para actualizar la información de control -->
<script type="text/javascript">
	function fActualizaFirma(vParte)
	{
        alert(document.getElementById('vFechaFirma').value);
        alert(document.getElementById('vAcdIdFirma').value);
		// Crear un objeto XmlHttpRequest:
		var xmlHttp = XmlHttpRequest();
		// Generar una petición HTTP:
		xmlHttp.open("POST", "ft_ajax/actualizar_firma.cfm", false);
		xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
		// Crear la lista de parámetros (obligatorios):
		parametros = "vParte=" + encodeURIComponent(vParte);
		parametros += "&vIdSol=" + encodeURIComponent('<cfoutput>#vIdSol#</cfoutput>');
		// Crear la lista de parámetros (opcionales):
		if (vParte == 'FechaFirma') parametros += "&vFechaFirma=" + encodeURIComponent(document.getElementById('vFechaFirma').value);
		if (vParte == 'AcademicoFirma') parametros += "&vAcdIdFirma=" + encodeURIComponent(document.getElementById('vAcdIdFirma').value);
//		alert(parametros)
		// Enviar la petición HTTP:
		xmlHttp.send(parametros);
		document.getElementById('vAlerta').innerHTML = xmlHttp.responseText
	}
</script>

<!-- Datos para la firma de la forma telegrámica -->
	<div align="center">
        <table width="80%" border="0" class="cuadros" bgcolor="#EEEEEE" cellspacing="0">
            <!-- Encabezado -->
          <tr bgcolor="#CCCCCC">
                <td colspan="2"><div align="center" class="Sans10NeNe">DATOS DE LA FIRMA DE LA SOLICITUD</div></td>
            </tr>
                <tr><td height="5" colspan="2"></td></tr>
                <!-- Sección en el listado y número de asunto -->
                <tr>
                    <td width="308" align="right" valign="middle">
                    <cfoutput>
                        <span class="Sans9Gr"><cfif #ctDepUbica.ubica_lugar# EQ "CIUDAD UNIVERSITARIA">Ciudad Universitaria, Cd. Mx.<cfelse>#ctDepUbica.ubica_lugar#</cfif>, A </span>
                    </cfoutput>
                    </td>
                    <td width="308">
                        <cfoutput>
                        <input type="text" name="vFechaFirma" id="vFechaFirma" class="datos" value="#vFechaFirma#" size="10" maxlength="10" onkeypress="return MascaraEntrada(event, '99/99/9999');" onchange="fActualizaFirma('FechaFirma');">
                      </cfoutput>
                  </td>
                </tr>
                <!-- Decisión del CTIC -->
                <tr>
                    <td colspan="2"></td>
                </tr>
                <!-- Número de oficio -->
                <tr>
                    <td colspan="2" align="center">
                        <hr width="50%">
                        <select name="vAcdIdFirma" id="vAcdIdFirma" class="datos" onchange="fActualizaFirma('AcademicoFirma');">
                            <option value="">-------------------------</option>
                            <cfoutput query="tbFirma">
                                <option value="#acd_id#" <cfif #Val(acd_id)# EQ #tbSolicitudes.acd_id_firma#>selected</cfif>>#Ucase(acd_prefijo)# #Ucase(acd_nombres)# #Ucase(acd_apepat)# #Ucase(acd_apemat)#</option>
                            </cfoutput>
                        </select>
                    </td>
                </tr>
        </table>
	</div>
    <div id="vAlerta"></div>