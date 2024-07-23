<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 12/05/2022 --->
<!--- FECHA ÚLTIMA MOD: 12/05/2022 --->
<cfparam name="vArchivoPdf" default="5435_103145.pdf">
<cfparam name="vInfAnId" default="103145">
<cfset vParamFecha = #LsDateFormat(now(),'yyyymmdd')# & #LsTimeFormat(now(),'hhmmss')#>

<!--- Obtener datos de la solicitud --->
<cfquery name="tbInforme" datasource="#vOrigenDatosSAMAA#">
	SELECT informe_anual_id, acd_apepat, acd_apemat, acd_nombres
    FROM consulta_informes_anuales	
	WHERE informe_anual_id = #vInfAnId#
<!---    
	SELECT * FROM (movimientos_informes_anuales AS T1
	LEFT JOIN academicos AS T2 ON T1.acd_id = T2.acd_id)
	WHERE informe_anual_id = #vInfAnId#
--->
</cfquery>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
		<meta http-equiv='cache-control' content='no-cache'>
		<meta http-equiv='expires' content='0'>
		<meta http-equiv='pragma' content='no-cache'>
        <title>SAMAA DOCUMENTOS (<cfoutput query="tbInforme">#Trim(acd_apepat)# #Trim(acd_apemat)# #Trim(acd_nombres)#)</cfoutput></title><!---#vWebAcad#/#vArchivoPdf#--->
    </head>
<frameset cols="25%,*" framespacing="0" frameborder="no" border="0">
	<cfoutput>
		<frame src="informe_comentario.cfm?vInfAnId=#vInfAnId#" name="leftFrame" scrolling="yes" id="leftFrame" title="leftFrame" />
		<frame src="#vWebInformesAnuales#/#vArchivoPdf#?#vParamFecha#" name="mainFrame" id="mainFrame" title="mainFrame" />
	</cfoutput>
</frameset>
<noframes><body>
</body></noframes>
</html>