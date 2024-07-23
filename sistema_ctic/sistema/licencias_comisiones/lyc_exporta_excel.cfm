<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 20/10/2017 --->
<!--- FECHA ULTIMA MOD.: 30/01/2020 --->
<!--- CÓDIGO QUE GENERA UN ARCHIVO EN FORMATO EXCEL DE LICENCIAS Y COMISIONES MENORES A 22 DÍAS PARA SER DESCARGADA POR ALEJANDRO DEL CTIC--->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<cfparam name="vpSesion" default="0">

<!--- IMPRESION DE LA LISTA DE ASUNTOS QUE PASAN AL PLENO --->
<!--- Enviar el contenido a un archivo MS Word --->
<cfheader name="Content-Disposition" value="inline; filename=#vNomArchivoFecha#_LicenciasyComisiones_#vSsnId#.xls">
<cfcontent type="application/msexcel; charset=iso-8859-1">

<!--- Obtener la lista de LICENCIAS Y COMISIONES con goce de sueldo enviadas por las entidades académicas del SIC --->
<cfquery name="tbLyC" datasource="#vOrigenDatosSAMAA#">
	SELECT 
	T1.sol_id, T1.mov_clave, T1.sol_pos2, T1.sol_pos11_c, T1.sol_pos11_e, T1.sol_pos11_p, T1.sol_pos13_d, T1.sol_pos14, T1.sol_pos15, T1.sol_sintesis,
	T2.asu_numero, T2.ssn_id,
	T3.acd_rfc, T3.num_emp, T3.acd_apepat, T3.acd_apemat, T3.acd_nombres, T3.acd_prefijo,
	C2.dep_siglas,
    C3.activ_descrip,
    C4.cn_siglas,
    C5.pais_clave, C5.pais_nombre,
    C6.edo_clave, C6.edo_nombre
    FROM ((((((movimientos_solicitud AS T1
	LEFT JOIN movimientos_asunto AS T2 ON T1.sol_id = T2.sol_id)
	LEFT JOIN academicos AS T3 ON T1.sol_pos2 = T3.acd_id)
	LEFT JOIN catalogo_dependencia AS C2 ON T1.sol_pos1 = C2.dep_clave)
	LEFT JOIN catalogo_actividad AS C3 ON T1.sol_pos12 = C3.activ_clave)
	LEFT JOIN catalogo_cn AS C4 ON T1.sol_pos3 = C4.cn_clave)
	LEFT JOIN catalogo_pais AS C5 ON T1.sol_pos11_p = C5.pais_clave)
	LEFT JOIN catalogo_pais_edo AS C6 ON T1.sol_pos11_e = C6.edo_clave
	<!--- LEFT JOIN movimientos_solicitud_comision ON T1..sol_id = movimientos_solicitud_comision.sol_id) --->
	<!--- LEFT JOIN catalogo_movimiento AS C1 ON T1..mov_clave = catalogo_movimiento.mov_clave)  --->
	WHERE (T1.sol_status = 1 OR T1.sol_status = 0) <!--- Asuntos que pasan a la PLENO --->
	AND T2.asu_reunion = 'CTIC' <!--- Registro de asunto PLENO --->
	AND T2.asu_parte = 5 <!--- Excluir los asuntos que no pasan a las reuniones CAAA/CTIC --->
	AND (T1.mov_clave = 40 OR T1.mov_clave = 41)	<!--- Filtro solo de Licencias y Comisiones a las que ya se asignó una sesión --->
	AND T2.ssn_id = #vSsnId# 	<!--- Filtro por acta --->
	<!--- Filtro por dependencia --->
	<cfif #vDepId# IS NOT ''>AND T1.sol_pos1 = '#vDepId#'</cfif>
	ORDER BY 
	T2.asu_parte,
	T2.asu_numero,
	C2.dep_orden,
	T3.acd_apepat,
	T3.acd_apemat,
	T3.acd_nombres,
	T1.sol_pos14
</cfquery>

<!--- Obtener la lista de LICENCIAS Y COMISIONES que ya se tramitaron --->
<cfif #tbLyC.RecordCount# EQ 0>
	<cfquery name="tbLyC" datasource="#vOrigenDatosSAMAA#">
		SELECT 
		T1.sol_id, T1.mov_clave, T1.sol_pos2, T1.sol_pos11_c, T1.sol_pos11_e, T1.sol_pos11_p, T1.sol_pos13_d, T1.sol_pos14, T1.sol_pos15, T1.sol_sintesis,
		T2.asu_numero, T2.ssn_id,
		T3.acd_rfc, T3.num_emp, T3.acd_apepat, T3.acd_apemat, T3.acd_nombres, T3.acd_prefijo,
		C2.dep_siglas,
		C3.activ_descrip,
		C4.cn_siglas,
		C5.pais_clave, C5.pais_nombre,
		C6.edo_clave, C6.edo_nombre
		FROM ((((((movimientos_solicitud_historia AS T1
		LEFT JOIN movimientos_asunto AS T2 ON T1.sol_id = T2.sol_id)
		LEFT JOIN academicos AS T3 ON T1.sol_pos2 = T3.acd_id)
		LEFT JOIN catalogo_dependencia AS C2 ON T1.sol_pos1 = C2.dep_clave)
		LEFT JOIN catalogo_actividad AS C3 ON T1.sol_pos12 = C3.activ_clave)
		LEFT JOIN catalogo_cn AS C4 ON T1.sol_pos3 = C4.cn_clave)
		LEFT JOIN catalogo_pais AS C5 ON T1.sol_pos11_p = C5.pais_clave)
		LEFT JOIN catalogo_pais_edo AS C6 ON T1.sol_pos11_e = C6.edo_clave
		<!--- LEFT JOIN movimientos_solicitud_comision ON T1..sol_id = movimientos_solicitud_comision.sol_id) --->
		<!--- LEFT JOIN catalogo_movimiento AS C1 ON T1..mov_clave = catalogo_movimiento.mov_clave)  --->
		WHERE (T1.sol_status = 1 OR T1.sol_status = 0) <!--- Asuntos que pasan a la PLENO --->
		AND T2.asu_reunion = 'CTIC' <!--- Registro de asunto PLENO --->
		AND T2.asu_parte = 5 <!--- Excluir los asuntos que no pasan a las reuniones CAAA/CTIC --->
		AND (T1.mov_clave = 40 OR T1.mov_clave = 41)	<!--- Filtro solo de Licencias y Comisiones a las que ya se asignó una sesión --->
		AND T2.ssn_id = #vSsnId# 	<!--- Filtro por acta --->
		<!--- Filtro por dependencia --->
		<cfif #vDepId# IS NOT ''>AND T1.sol_pos1 = '#vDepId#'</cfif>
		ORDER BY 
		T2.asu_parte,
		T2.asu_numero,
		C2.dep_orden,
		T3.acd_apepat,
		T3.acd_apemat,
		T3.acd_nombres,
		T1.sol_pos14
	</cfquery>
</cfif>
	
	
<html xmlns:v="urn:schemas-microsoft-com:vml"
xmlns:o="urn:schemas-microsoft-com:office:office"
xmlns:w="urn:schemas-microsoft-com:office:excel"
xmlns:m="http://schemas.microsoft.com/office/2004/12/omml"
xmlns="http://www.w3.org/TR/REC-html40">

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
				<td valign="top">RFC</td>
				<td valign="top">SIGDEP</td>
				<td valign="top">APELLIDO</td>
				<td valign="top">NOMBRE</td>
				<td valign="top">GRADO</td>
				<td valign="top">CCN</td>
				<td valign="top">ASUNTO</td>
				<td valign="top">DIAS</td>
				<td valign="top">FI</td>
				<td valign="top">FF</td>
				<td valign="top">COMENT1</td>
				<td valign="top">COMENT2</td>
				<td valign="top">COMENT3</td>
				<td valign="top">COMENT4</td>
				<td valign="top">COMENT5</td>
				<td valign="top">COMENT6</td>
				<td valign="top">COMENT7</td>
				<td valign="top">DESTINONAL</td>
				<td valign="top">TEMPORAL</td>
				<td valign="top">ACTA</td>
				<td valign="top">ACTIVID</td>
				<td valign="top">SOL_ID</td>
				<td valign="top">EMPLEADO</td>
			</tr>
                
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
				<tr>
					<td valign="top">#acd_rfc#</td>
					<td valign="top">#dep_siglas#</td>
					<td valign="top">#vApellido#</td>
					<td valign="top">#acd_nombres#</td>
					<td valign="top">#acd_prefijo#</td>
					<td valign="top">#cn_siglas#</td>
					<td valign="top"><cfif #mov_clave# EQ 40>A2<cfelseif #mov_clave# EQ 41>B11</cfif></td>                    
					<td valign="top">#sol_pos13_d#</td>
					<td valign="top">#LsDateFormat(sol_pos14,'dd/mm/yy')#</td>
					<td valign="top">#LsDateFormat(sol_pos15,'dd/mm/yy')#</td>
					<td valign="top">#vComenta1#</td>
					<td valign="top">#vComenta2#</td>
					<td valign="top">#vComenta3#</td>
					<td valign="top">#vComenta4#</td>
					<td valign="top">#vComenta5#</td>
					<td valign="top"><cfif #mov_clave# EQ 40><cfelseif #mov_clave# EQ 41>S</cfif></td>
					<td valign="top">#vComenta7#</td>
					<td valign="top"><cfif #sol_pos11_p# EQ 'MEX'>1<cfelse>0</cfif></td>
					<td valign="top">T</td>
					<td valign="top">#ssn_id#</td>
					<td valign="top">#activ_descrip#</td>
					<td valign="top">#sol_id#</td>
					<td valign="top">#num_emp#</td>
				</tr>
			</cfoutput>
		</table>
    </body>
</html>




