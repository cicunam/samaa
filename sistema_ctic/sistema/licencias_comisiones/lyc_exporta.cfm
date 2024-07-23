<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA ULTIMA MOD.: 03/11/2014 --->
<!--- CÓDIGO QUE GENERA UNA BASE DE DATOS EN FOXPRO DE LICENCIAS Y COMISIONES MENORES A 22 DÍAS PARA SER DESCARGADA POR ALEJANDRO DEL CTIC--->

<cfset vArchivoDbf = 'lyc_' & #vActa# & '.dbf'>
<cfset vArchivoTxt = 'lyc_' & #vActa# & '.txt'>
<cfset vCarpetaOrigenFortel = 'E:\bases_access\Licencias\'>
<cfset vCarpetaDestinoFortel = #vCarpetaRaizArchivos# & '\archivos_lyc\'>

<cffile action="copy" source="#vCarpetaOrigenFortel#\base_blanco\fortel.dbf" destination="#vCarpetaOrigenFortel#">
<cffile action="copy" source="#vCarpetaOrigenFortel#\base_blanco\fortel.txt" destination="#vCarpetaOrigenFortel#">

<!--- Obtener la lista de LICENCIAS Y COMISIONES con goce de sueldo enviadas por las entidades académicas del SIC --->
<cfquery name="tbLyC" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM ((((((((movimientos_solicitud 
	LEFT JOIN movimientos_asunto ON movimientos_solicitud.sol_id = movimientos_asunto.sol_id)
	LEFT JOIN movimientos_solicitud_comision ON movimientos_solicitud.sol_id = movimientos_solicitud_comision.sol_id)
	LEFT JOIN catalogo_movimiento ON movimientos_solicitud.mov_clave = catalogo_movimiento.mov_clave) 
	LEFT JOIN catalogo_dependencia ON movimientos_solicitud.sol_pos1 = catalogo_dependencia.dep_clave)
	LEFT JOIN academicos ON movimientos_solicitud.sol_pos2 = academicos.acd_id)
	LEFT JOIN catalogo_pais ON movimientos_solicitud.sol_pos11_p = catalogo_pais.pais_clave)
	LEFT JOIN catalogo_pais_edo ON movimientos_solicitud.sol_pos11_e = catalogo_pais_edo.edo_clave)
	LEFT JOIN catalogo_actividad ON movimientos_solicitud.sol_pos12 = catalogo_actividad.activ_clave)    
	LEFT JOIN catalogo_cn ON movimientos_solicitud.sol_pos3 = catalogo_cn.cn_clave
	WHERE movimientos_solicitud.sol_status = 1 <!--- Asuntos que pasan a la PLENO --->
	AND movimientos_asunto.asu_reunion = 'CTIC' <!--- Registro de asunto PLENO --->
	AND movimientos_asunto.asu_parte = 5 <!--- Excluir los asuntos que no pasan a las reuniones CAAA/CTIC --->
	AND (movimientos_solicitud.mov_clave = 40 OR movimientos_solicitud.mov_clave = 41)	<!--- Filtro solo de Licencias y Comisiones a las que ya se asignó una sesión --->
	AND movimientos_asunto.ssn_id = #vActa# 	<!--- Filtro por acta --->
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

<cfquery name="dbfLyC" datasource="Fortel">
	DELETE 
	FROM fortel 
</cfquery>

<cfloop query="tbLyC">	
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

	<cfquery datasource="Fortel">
       	INSERT INTO fortel
		(RFC, SIGDEP, APELLIDO, NOMBRE, GRADO, CCN, ASUNTO, DIAS, FI, FF, COMENT1, COMENT2, COMENT3, COMENT4, COMENT5, COMENT6, COMENT7, DESTINONAL, TEMPORAL, ACTA, ACTIVID, SOL_ID, EMPLEADO)
            VALUES (
            '#acd_rfc#'
            ,
            '#dep_siglas#'
            ,
            '#vApellido#'
            ,
            '#acd_nombres#'
            ,
            '#acd_prefijo#'
            ,
            '#cn_siglas#'
			,
            <cfif #mov_clave# EQ 40>'A2'
            <cfelseif #mov_clave# EQ 41>'B11'
            </cfif>
            ,
            #sol_pos13_d#
            ,
            '#LsDateFormat(sol_pos14,'dd/mm/yy')#'
            ,
            '#LsDateFormat(sol_pos15,'dd/mm/yy')#'
            ,
            '#vComenta1#'
            ,
            '#vComenta2#'
            ,
            '#vComenta3#'
            ,
            '#vComenta4#'
            ,
            '#vComenta5#'
            ,
            <cfif #mov_clave# EQ 40>NULL
            <cfelseif #mov_clave# EQ 41>'S'
            </cfif>
            ,
            '#vComenta7#'
            ,
            <cfif #sol_pos11_p# EQ 'MEX'>1
			<cfelse>0</cfif>
            ,
            'T'
            ,
            #ssn_id#
            ,
			'#activ_descrip#'
            ,
            #sol_id#
            ,
            #num_emp#
            )
    </cfquery>

</cfloop>

<!--- GENERA ARCHIVO DBF --->
<cffile action="copy" source="#vCarpetaOrigenFortel#fortel.dbf" destination="#vCarpetaDestinoFortel#" nameconflict="overwrite">
<cffile action="RENAME" source="#vCarpetaDestinoFortel#fortel.dbf" destination="#vCarpetaDestinoFortel & vArchivoDbf#" nameconflict="overwrite">

<!--- Obtener el número de sesión que se verá en la CAAA --->
<cfquery name="tbSesion" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM sesiones WHERE ssn_clave = 4 AND ssn_id = #Session.sSesion#
</cfquery>

<!--- GENERA ARCHIVO TXT ---->
<cffile action="copy" source="#vCarpetaOrigenFortel#fortel.txt" destination="#vCarpetaDestinoFortel#" nameconflict="overwrite">
<cffile action="RENAME" source="#vCarpetaDestinoFortel#fortel.txt" destination="#vCarpetaDestinoFortel & vArchivoTxt#" nameconflict="overwrite">

<cfoutput query="tbCorreos">
	<cffile action="append" file="#vRutaArchivo#\#vArchivoCsv#" output="#registro_correo#" charset="utf-8" addnewline="yes" fixnewline="yes">
</cfoutput>


<cfmail type="html" to="olaf.villanueva@gmail.com" bcc="samaa@cic.unam.mx" from="samaa@cic.unam.mx" subject="Licencias y comisiones #vActa#"  server="correo.cic.unam.mx" username="samaa" password="QQQwww123">
<!---
<cfmail type="html" to="aramp@unam.mx" from="samaa@cic-ctic.unam.mx" subject="Licencias y comisiones #vActa#"  server="132.248.61.3">
--->
Estimado Usuario:<br>
<br>
Le hacemos llegar la base de datos de licencias con goce de sueldo y comisiones menores a 22 dias de la sesion <cfoutput>#vActa#</cfoutput>.

Saludos.
<cfmailparam file="#vCarpetaDestinoFortel & vArchivoDbf#">
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
	<table class="Cintillo">
	  <tr>
	    <td><span class="Sans9GrNe"> EXPORTAR LICENCIAS Y COMISIONES CON GOCE DE SUELDO </span></td>
	    <td align="right"><cfoutput> <span class="Sans9Gr"><b>SESI&Oacute;N:#tbSesion.ssn_id#</b></span> </cfoutput></td>
      </tr>
    </table>
	<table width="1024" border="0" cellpadding="0" cellspacing="0">
	  <tr>
	    <!-- Columna izquierda (comandos) -->
	    <td width="180" valign="top" class="bordesmenu"><!-- Campos ocultos -->
	      <!-- Formulario de nueva solicitud -->
	      <table width="180" border="0">
	        <!-- Divisi&oacute;n -->
	        <tr>
	          <td width="146"><div class="linea_menu"></div></td>
            </tr>
	        <!-- Men&uacute; de la lista de solicitudes -->
	        <tr>
	          <td valign="top"><div align="left" class="Sans10NeNe">Men&uacute;:</div></td>
            </tr>
	        <!-- Opci&oacute;n: Imprimir listado -->
	        <tr>
	          <td>&nbsp;</td>
            </tr>
	        <!-- Opci&oacute;n: Genera Archivo para Fortel -->
	        <tr>
	          <td><input type="button" value="Cerrar ventana" class="botones" onClick="window.location = 'consulta_lyc.cfm'"></td>
            </tr>
	        <!-- Tipo de vista de la lista -->
	        <tr>
	          <td valign="top"><br>
	            <div class="linea_menu"></div></td>
            </tr>
          </table></td>
	    <!-- Columna derecha (listado) -->
	    <td width="844" align="center" valign="top"><p>&nbsp;</p>
	      <p>&nbsp;</p>
	      <p>EL ARCHIVO CON LICENCIAS Y COMISIONES PARA LA SESIÓN <cfoutput>#vActa#</cfoutput> SE ENVIO A LA CUENTA DE CORREO ELECTRONICO REGISTRADA</span></p>
		</td>
      </tr>
    </table>
	<p>&nbsp;</p>
    </body>
</html>