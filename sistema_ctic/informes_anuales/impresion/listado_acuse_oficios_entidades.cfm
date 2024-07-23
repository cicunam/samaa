<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 30/05/2016 --->
<!--- FECHA ÚLTIMA MOD.: 09/03/2017 --->
<!--- GENERA EL LISTADO PARA LOS ACUSES DE RECIBO DE OFICIOS QUE SE ENTREGARAN EN LAS ENTIDADES --->
<!--- Enviar el contenido a un archivo MS Word --->

<cfparam name="vpInformeAnio" default="0">
<cfparam name="vpDepClave" default="">

<cfif #vpDepClave# EQ ''>
	<cfset vArchivoInformeAcuse = '#vNomArchivoFecha#_acuse_oficios_entidades_#vpInformeAnio#.doc'>
<cfelse>
	<cfset vArchivoInformeAcuse = '#vNomArchivoFecha#_acuse_oficios_entidades_#vpDepClave#_#vpInformeAnio#.doc'>
</cfif>

<cfheader name="Content-Disposition" value="inline; filename=#vArchivoInformeAcuse#.doc">
<cfcontent type="application/msword; charset=iso-8859-1">

<!--- Catálogo de Entidades --->
<cfquery  name="tbCatalogoEntidad" datasource="#vOrigenDatosCATALOGOS#">
    SELECT dep_clave, dep_nombre, dep_siglas
    FROM catalogo_dependencias
    WHERE dep_clave LIKE '03%'
    AND dep_status = 1
    AND dep_tipo <> 'PRO'
    <cfif vpDepClave NEQ ''>
    	AND dep_clave = '#vpDepClave#'
	</cfif>    
    ORDER BY dep_orden ASC
</cfquery>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns:v="urn:schemas-microsoft-com:vml"
xmlns:o="urn:schemas-microsoft-com:office:office"
xmlns:w="urn:schemas-microsoft-com:office:word"
xmlns:m="http://schemas.microsoft.com/office/2004/12/omml"
xmlns="http://www.w3.org/TR/REC-html40">
<!---
<html xmlns="http://www.w3.org/1999/xhtml">
--->
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
		<title>Documento sin título</title>
		<link href="http://www.cic-ctic.unam.mx:31220/samaa/css/oficios.css" rel="stylesheet" type="text/css">
	</head>
	<body style="color:black; font-family:'Arial Narrow'; font-weight:normal;">
		<cfloop query="tbCatalogoEntidad">
        
        	<cfset vpDepClave = #tbCatalogoEntidad.dep_clave#>
        	<cfset vpDepNombre = #tbCatalogoEntidad.dep_nombre#>
        	<cfset vpDepSiglas = #tbCatalogoEntidad.dep_siglas#>            
				
			<cfset vDecClave = 1>
			<cfinclude template="listado_acuse_oficios_entidades_inc.cfm">
			<cfset vDecClave = 49>
			<cfinclude template="listado_acuse_oficios_entidades_inc.cfm">
			<cfset vDecClave = 4>
			<cfinclude template="listado_acuse_oficios_entidades_inc.cfm">
            
        </cfloop>
    </body>
</html>