<!--- CREADO: ARAM PICHARDO DURAN --->
<!--- EDITO: ARAM PICHARDO DURAN --->
<!--- FECHA CREA: 06/12/2019 --->
<!--- FECHA ÚLTIMA MOD.: 30/03/2020 --->


<!--- Abre tabla de solicitudes para indicar si esxiete solicitud en trámite--->
<cfquery name="tbSoliciudes" datasource="#vOrigenDatosSAMAA#">
	SELECT COUNT(*) AS vCuentaSol
	FROM movimientos_solicitud
	WHERE sol_pos2 = #vAcadId# 
	AND sol_retirada IS NULL
</cfquery>	


<div>
	<div style="width: 50%; float:left">
		<div class="divSolicitudesTramite">
			<table border="0" cellpadding="0" cellspacing="0" width="98%" style="margin-top:-1px;">
				<tr>
					<td align="right" width="70%" valign="middle">
						<span class="Sans10ViNe">SOLICITUDES EN TRÁMITE: </span>
						<span class="Sans10NeNe">#tbSoliciudes.vCuentaSol#</span>
					</td>
					<td align="right" width="2%"></td>
					<td width="28%" valign="middle">
						<cfif #tbSoliciudes.vCuentaSol# GT 0>
							<img id="imgDetalleSolProceso" src="#vCarpetaICONO#/detalle_15.jpg" style="border:none; cursor:pointer;" title="Consultar solicitudes en trámite" onClick="fVentanaEmergeSolPorc();">
							<input type="hidden" id="acd_id" name="acd_id" value="#vAcadId#" />
						</cfif>													
					</td>												
				</tr>
			</table>
		<div id="ListaSolCons_jQuery"><!-- JQUERY: Formulario de captura de nuevo oponente --></div>	
	</div>
	<div style="width: 50%; float:left">
		<cfif #Session.sTipoSistema# EQ 'stctic' AND #Session.sUsuarioNivel# EQ 0 AND (#tbAcademicos.con_clave# EQ 1 OR #tbAcademicos.con_clave# EQ 2 OR #tbAcademicos.con_clave# EQ 3 OR #tbAcademicos.con_clave# EQ 6 OR #tbAcademicos.con_clave# EQ 10)>
			<cfif CGI.SERVER_PORT IS "31220">
				<cfset vLigaInformacionAcad = 'http://www.cic-ctic.unam.mx:31220/consultas/academicos/valida_academico.cfm'>
			<cfelse>
				<cfset vLigaInformacionAcad = 'http://www.cic-ctic.unam.mx:31221/consultas/aram/academicos/valida_academico.cfm'>
			</cfif>
			<cfform id="frmInfAcad" method="post" action="#vLigaInformacionAcad#" target="winConsultas">
				<div class="divInformacionAcad" onclick="fInformacionAcad();">
					CONSULTAR INFORMACIÓN ACADÉMICA
					<cfinput type="hidden" id="vpSistemaAcceso" name="vpSistemaAcceso" value="#ToBase64('SAMAA')#">				
					<cfinput type="hidden" id="acdid" name="acdid" value="#vAcadId#">
					<cfinput type="hidden" id="vpSistemaPass" name="vpSistemaPass" value="#ToBase64('?31101$Cic8282Sts;')#">
				</div>
			</cfform>
		</cfif>                        		
	</div>	
</div>