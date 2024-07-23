<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 16/03/2017 --->
<!--- FECHA ÚLTIMA MOD.: 16/03/2017 --->
<!--- GENERA EL LISTADO PARA LOS ACUSES DE RECIBO DE OFICIOS QUE SE ENTREGARAN AL ARCHIVO DE LA STCTIC --->
<!--- Enviar el contenido a un archivo MS Word --->

<cfparam name="vpInformeAnio" default="0">
<cfparam name="vpDepClave" default="">

<cfif #vpDepClave# EQ ''>
	<cfset vArchivoInformeAcuse = '#vNomArchivoFecha#_acuse_oficios_archivo_#vpInformeAnio#.doc'>
<cfelse>
	<cfset vArchivoInformeAcuse = '#vNomArchivoFecha#_acuse_oficios_archivo_#vpDepClave#_#vpInformeAnio#.doc'>
</cfif>

<cfheader name="Content-Disposition" value="inline; filename=#vArchivoInformeAcuse#">
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

            <cfquery name="tbInformesAnuales" datasource="#vOrigenDatosSAMAA#">
                SELECT 
					T2.acd_prefijo, T2.acd_nombres, T2.acd_apepat, T2.acd_apemat,
                    T3.informe_oficio
                FROM movimientos_informes_anuales AS T1
                LEFT JOIN academicos AS T2 ON T1.acd_id = T2.acd_id
				LEFT JOIN movimientos_informes_asunto AS T3 ON T1.informe_anual_id = T3.informe_anual_id AND T3.informe_reunion = 'CTIC'                
                WHERE T1.dep_clave = '#vpDepClave#'
                AND T1.informe_anio = '#vpInformeAnio#'
                AND T3.informe_oficio IS NOT NULL
                <!--- AND T1.dec_clave = #vDecClave#--->
                ORDER BY T3.informe_oficio ASC
            </cfquery>
            <cfif #tbInformesAnuales.RecordCount# GT 0>
                <table width="100%">
                    <tr>
                        <td width="20%" align="center"><img src="http://www.cic-ctic.unam.mx:31220/images/iconos/acuse_80.png"   /></td>
                        <td width="60%" align="center" style="font-size:14px" valign="top"><strong>CONSEJO TÉCNICO DE LA INVESTIGACIÓN CIENTÍFICA</strong></td>
                        <td width="20%" align="right" style="font-size:12px" valign="top"><strong>INFORMES ANUALES <cfoutput>#vpInformeAnio#</cfoutput></strong></td>                	
                    </tr>
                    <tr>
                        <td colspan="3">
                            <table width="100%">
                                <tr>
                                    <td width="5%" style="border-bottom: 1px solid #000; border-top: 1px solid #000;"></td>
                                    <td width="5%" style="font-size:10px; border-bottom: 1px solid #000; border-top: 1px solid #000;"><strong>ENTIDAD</strong></td>
                                    <td width="35%" style="font-size:10px; border-bottom: 1px solid #000; border-top: 1px solid #000;"><strong>NOMBRE</strong></td>
                                    <td width="15%" style="font-size:10px; border-bottom: 1px solid #000; border-top: 1px solid #000;"><strong>OFICIO</strong></td>
                                    <td width="20%" style="font-size:10px; border-bottom: 1px solid #000; border-top: 1px solid #000;"><strong>PERSONA QUE FOLIA</strong></td>
                                    <td width="20%" style="font-size:10px; border-bottom: 1px solid #000; border-top: 1px solid #000;"><strong>PERSONA QUE RECIBE</strong></td>                                    
                                </tr>
                                <cfoutput query="tbInformesAnuales">
                                    <tr>
                                        <td style="font-size:10px; border-bottom: 1px dashed ##000;" valign="top">#CurrentRow#</td>
                                        <td style="font-size:10px; border-bottom: 1px dashed ##000;">#vpDepSiglas#</td>
                                        <td style="font-size:10px; border-bottom: 1px dashed ##000;">#acd_apepat# #acd_apemat# #acd_nombres#</td>
                                        <td style="font-size:10px; border-bottom: 1px dashed ##000;" valign="top">CJIC/CTIC/#informe_oficio#</td>
                                        <td style="font-size:10px; border-bottom: 1px dashed ##000;" valign="top"></td>
                                        <td style="font-size:10px; border-bottom: 1px dashed ##000;" valign="top"></td>                                        
                                    </tr>
                                </cfoutput>
                            </table>
                        </td>
                    </tr>
                </table>
				<!--- Salto de página --->
                <br class="SaltoPagina">                
			</cfif>
        </cfloop>
    </body>
</html>