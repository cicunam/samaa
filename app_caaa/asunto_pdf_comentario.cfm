<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 04/05/2017 --->
<!--- FECHA ÚLTIMA MOD: 02/09/2020 --->

<cfparam name="vArchivoPdf" default="5435_103145.pdf">
<cfparam name="vSolId" default="103145">
<cfset vParamFecha = #LsDateFormat(now(),'yyyymmdd')# & #LsTimeFormat(now(),'hhmmss')#>

<!--- Obtener datos de la solicitud --->
<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
	SELECT sol_id, acd_apepat, acd_apemat, acd_nombres
    FROM consulta_solicitudes_caaa
	WHERE sol_id = #vSolId#
<!---
	SELECT * FROM (movimientos_solicitud
	LEFT JOIN academicos ON movimientos_solicitud.sol_pos2 = academicos.acd_id)
	LEFT JOIN catalogo_movimiento ON movimientos_solicitud.mov_clave = catalogo_movimiento.mov_clave
	WHERE sol_id = #vSolId#
--->	
</cfquery>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1; " />
		<meta http-equiv='cache-control' content='no-cache'>
		<meta http-equiv='expires' content='0'>
		<meta http-equiv='pragma' content='no-cache'>
        <title>SAMAA DOCUMENTOS (<cfoutput query="tbSolicitudes">#Trim(acd_apepat)# #Trim(acd_apemat)# #Trim(acd_nombres)#)</cfoutput></title>
    </head>
<frameset cols="25%,*" framespacing="0" frameborder="no" border="0">
	<cfoutput>
		<frame src="asunto_comentario.cfm?vSolId=#vSolId#" name="leftFrame" scrolling="yes" id="leftFrame" title="leftFrame" />
		<frame src="#vWebCAAA#/#vArchivoPdf#?#vParamFecha#" name="mainFrame" id="mainFrame" title="mainFrame" />
	</cfoutput>
</frameset>
<noframes><body>
</body></noframes>
</html>