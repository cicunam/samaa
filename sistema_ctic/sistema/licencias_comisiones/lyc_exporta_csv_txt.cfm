<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 01/11/2009 --->
<!--- FECHA ULTIMA MOD.: 27/06/2016 --->
<!--- CÓDIGO QUE GENERA UNA BASE DE DATOS EN FOXPRO DE LICENCIAS Y COMISIONES MENORES A 22 DÍAS PARA SER DESCARGADA POR ALEJANDRO DEL CTIC--->

<cfparam name="vpSesion" default="0">

<cfset vArchivoTxt = 'lyc_' & #vpSesion# & '.txt'>
<cfset vArchivoCsv = 'lyc_' & #vpSesion# & '.csv'>
<cfset vArchivoCsv = 'lyc_' & #vpSesion# & '.xls'>
<cfset vCarpetaOrigenArchivos = #vCarpetaRaizArchivos# & '\archivos_lyc\archivo_base\'>
<cfset vCarpetaDestinoArchivos = #vCarpetaRaizArchivos# & '\archivos_lyc\'>

<!--- GENERA ARCHIVO TXT --->
<cffile action="copy" source="#vCarpetaOrigenArchivos#lyc_base.txt" destination="#vCarpetaDestinoArchivos#">
<cffile action="RENAME" source="#vCarpetaDestinoArchivos#lyc_base.txt" destination="#vCarpetaDestinoArchivos & vArchivoTxt#" nameconflict="overwrite">
<!--- GENERA ARCHIVO CSV --->
<cffile action="copy" source="#vCarpetaOrigenArchivos#lyc_base.csv" destination="#vCarpetaDestinoArchivos#">
<cffile action="RENAME" source="#vCarpetaDestinoArchivos#lyc_base.csv" destination="#vCarpetaDestinoArchivos & vArchivoCsv#" nameconflict="overwrite">

<!--- Obtener la lista de LICENCIAS Y COMISIONES con goce de sueldo enviadas por las entidades académicas del SIC --->
<cfquery name="tbLyC" datasource="#vOrigenDatosSAMAA#">
	SELECT * 
    FROM ((((((((movimientos_solicitud 
	LEFT JOIN movimientos_asunto ON movimientos_solicitud.sol_id = movimientos_asunto.sol_id)
	LEFT JOIN movimientos_solicitud_comision ON movimientos_solicitud.sol_id = movimientos_solicitud_comision.sol_id)
	LEFT JOIN catalogo_movimiento ON movimientos_solicitud.mov_clave = catalogo_movimiento.mov_clave) 
	LEFT JOIN catalogo_dependencia ON movimientos_solicitud.sol_pos1 = catalogo_dependencia.dep_clave)
	LEFT JOIN academicos ON movimientos_solicitud.sol_pos2 = academicos.acd_id)
	LEFT JOIN catalogo_pais ON movimientos_solicitud.sol_pos11_p = catalogo_pais.pais_clave)
	LEFT JOIN catalogo_pais_edo ON movimientos_solicitud.sol_pos11_e = catalogo_pais_edo.edo_clave)
	LEFT JOIN catalogo_actividad ON movimientos_solicitud.sol_pos12 = catalogo_actividad.activ_clave)    
	LEFT JOIN catalogo_cn ON movimientos_solicitud.sol_pos3 = catalogo_cn.cn_clave
	WHERE (movimientos_solicitud.sol_status = 1 OR movimientos_solicitud.sol_status = 0) <!--- Asuntos que pasan a la PLENO --->
	AND movimientos_asunto.asu_reunion = 'CTIC' <!--- Registro de asunto PLENO --->
	AND movimientos_asunto.asu_parte = 5 <!--- Excluir los asuntos que no pasan a las reuniones CAAA/CTIC --->
	AND (movimientos_solicitud.mov_clave = 40 OR movimientos_solicitud.mov_clave = 41)	<!--- Filtro solo de Licencias y Comisiones a las que ya se asignó una sesión --->
	AND movimientos_asunto.ssn_id = #vpSesion# 	<!--- Filtro por acta --->
	<!--- Filtro por dependencia --->
	<cfif #vDepId# IS NOT ''>AND sol_pos1 = '#vDepId#'</cfif>
	ORDER BY 
	movimientos_asunto.asu_parte,
	movimientos_asunto.asu_numero,
	catalogo_dependencia.dep_orden,
	academicos.acd_apepat,
	academicos.acd_apemat,
	academicos.acd_nombres,
	movimientos_solicitud.sol_pos14
</cfquery>

<cfoutput query="tbLyC">
	<cfset vApellido = #acd_apepat# & ' ' & #acd_apemat#>
 	<cfset vComenta1 = #MID(sol_sintesis,1,50)#>
 	<cfset vComenta2 = #MID(sol_sintesis,51,100)#>
 	<cfset vComenta3 = #MID(sol_sintesis,101,150)#>
 	<cfset vComenta4 = #MID(sol_sintesis,151,200)#>
 	<cfset vComenta5 = #MID(sol_sintesis,201,250)#>
	<cfset vComenta7 = ''>

	<cfif #sol_pos11_p# EQ 'MEX' OR #sol_pos11_p# EQ 'USA'>
	 	<cfset vComenta7 = #sol_pos11_c# & ', ' & #edo_nombre# & ', ' & #pais_nombre#>
	<cfelse>
		<cfif #sol_pos11_c# NEQ ''>
		 	<cfset vComenta7 = #sol_pos11_c#>
		</cfif>
		<cfif #sol_pos11_e# NEQ ''>
			<cfif #vComenta7# eq ''>
			 	<cfset vComenta7 = #sol_pos11_e#>
			<cfelse>
			 	<cfset vComenta7 = #vComenta7# & ', ' & #sol_pos11_e#>
			</cfif>
		</cfif>
		<cfif #pais_nombre# NEQ ''>
			<cfif #vComenta7# EQ ''>
			 	<cfset vComenta7 = #pais_nombre#>
			<cfelse>
			 	<cfset vComenta7 = #vComenta7# & ', ' & #pais_nombre#>
			</cfif>
		</cfif>
    </cfif>

	<cfset vContenidoArchivos = ''>
	<cfset vContenidoArchivos = '"' & #acd_rfc# & '"'>
	<cfset vContenidoArchivos = #vContenidoArchivos# & ';' & '"' & #dep_siglas# & '"' >
	<cfset vContenidoArchivos = #vContenidoArchivos# & ';' & '"' & #vApellido# & '"' >
	<cfset vContenidoArchivos = #vContenidoArchivos# & ';' & '"' & #acd_nombres# & '"' >
	<cfset vContenidoArchivos = #vContenidoArchivos# & ';' & '"' & #acd_prefijo# & '"' >
	<cfset vContenidoArchivos = #vContenidoArchivos# & ';' & '"' & #cn_siglas# & '"' >
	<cfif #mov_clave# EQ 40>
		<cfset vContenidoArchivos = #vContenidoArchivos# & ';' & '"' & 'A2' & '"' >
	<cfelseif #mov_clave# EQ 41>
		<cfset vContenidoArchivos = #vContenidoArchivos# & ';' & '"' & 'B11' & '"' >
	</cfif>
	<cfset vContenidoArchivos = #vContenidoArchivos# & ';' & #sol_pos13_d# >
	<cfset vContenidoArchivos = #vContenidoArchivos# & ';' & '"' & #LsDateFormat(sol_pos14,'dd/mm/yy')# & '"' >
	<cfset vContenidoArchivos = #vContenidoArchivos# & ';' & '"' & #LsDateFormat(sol_pos15,'dd/mm/yy')# & '"' >
	<cfset vContenidoArchivos = #vContenidoArchivos# & ';' & '"' & #vComenta1# & '"' >
	<cfset vContenidoArchivos = #vContenidoArchivos# & ';' & '"' & #vComenta2# & '"' >
	<cfset vContenidoArchivos = #vContenidoArchivos# & ';' & '"' & #vComenta3# & '"' >
	<cfset vContenidoArchivos = #vContenidoArchivos# & ';' & '"' & #vComenta4# & '"' >
	<cfset vContenidoArchivos = #vContenidoArchivos# & ';' & '"' & #vComenta5# & '"' >
	<cfif #mov_clave# EQ 40>
		<cfset vContenidoArchivos = #vContenidoArchivos# & ';' & '"' & '' & '"' >
	<cfelseif #mov_clave# EQ 41>
		<cfset vContenidoArchivos = #vContenidoArchivos# & ';' & '"' & 'S' & '"' >
	</cfif>
	<cfset vContenidoArchivos = #vContenidoArchivos# & ';' & '"' & '#vComenta7#' & '"' >
	<cfif #sol_pos11_p# EQ 'MEX'>
		<cfset vContenidoArchivos = #vContenidoArchivos# & ';' & '1' >
	<cfelse>
		<cfset vContenidoArchivos = #vContenidoArchivos# & ';' & '0'>
	</cfif>
	<cfset vContenidoArchivos = #vContenidoArchivos# & ';' & '"' & 'T' & '"' >
	<cfset vContenidoArchivos = #vContenidoArchivos# & ';' & #ssn_id#>
	<cfset vContenidoArchivos = #vContenidoArchivos# & ';' & '"' & '#activ_descrip#' & '"' >
	<cfset vContenidoArchivos = #vContenidoArchivos# & ';' & #sol_id#>
	<cfset vContenidoArchivos = #vContenidoArchivos# & ';' & #num_emp#>

	<cffile action="append" file="#vCarpetaDestinoArchivos#\#vArchivoTxt#" output="#vContenidoArchivos#" charset="utf-8" addnewline="yes" fixnewline="yes">
	<cffile action="append" file="#vCarpetaDestinoArchivos#\#vArchivoCsv#" output="#vContenidoArchivos#" charset="utf-8" addnewline="yes" fixnewline="yes">
	<cffile action="append" file="#vCarpetaDestinoArchivos#\#vArchivoXls#" output="#vContenidoArchivos#" charset="utf-8" addnewline="yes" fixnewline="yes">    
</cfoutput>

<cfif #CGI.SERVER_PORT# EQ '31221'>
	<cfset vCorreoTo = 'aramp@unam.mx'>
<cfelse>
	<cfset vCorreoTo = 'ctic@unam.mx, evelyn@cic.unam.mx, emmanuel@cic.unam.mx'>
</cfif>


<!--- SE ENVÍA CORREO CON LOS ARCHIVOS ADJUNTOS EN FORTMATO CSV Y TXT olaf.villanueva@gmail.com--->
<cfmail type="html" to="#vCorreoTo#" bcc="samaa@cic.unam.mx" from="samaa@cic.unam.mx" subject="Licencias y comisiones #vpSesion#" server="correo.cic.unam.mx" username="samaa" password="QQQwww123">
	Estimado Usuario:<br>
	<br>
	Le hacemos llegar la base de datos de licencias con goce de sueldo y comisiones menores a 22 dias de la sesion <cfoutput>#vpSesion#</cfoutput>.
    <br />
    <br />    
	Saludos.
	<cfmailparam file="#vCarpetaDestinoArchivos & vArchivoCsv#">
	<cfmailparam file="#vCarpetaDestinoArchivos & vArchivoTxt#">
</cfmail>

<html>
	<head>
		<title>STCTIC - Asuntos Acad&eacute;mico-Administrativos</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href="<cfoutput>#vCarpetaCSS#</cfoutput>/formularios.css" rel="stylesheet" type="text/css">
		<link href="<cfoutput>#vCarpetaCSS#</cfoutput>/general.css" rel="stylesheet" type="text/css">
		<link href="<cfoutput>#vCarpetaCSS#</cfoutput>/fuentes.css" rel="stylesheet" type="text/css">
	</head>
	<body>

		<table border="0" cellpadding="0" cellspacing="0">
			<tr>
				<!-- Columna derecha (listado) -->
				<td align="center" valign="top">
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>                    
					<p><span class="Sans14NeNe">EL ARCHIVO CON LICENCIAS Y COMISIONES PARA LA SESIÓN <cfoutput>#vpSesion#</cfoutput> SE ENVIO A LA CUENTA DE CORREO ELECTRÓNICO REGISTRADA</span></p>
				</td>
			</tr>
		</table>
		<p>&nbsp;</p>
    </body>
</html>