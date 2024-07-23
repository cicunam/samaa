<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA CREA.: 30/08/2017 --->
<!--- FECHA ULTIMA MOD.: 30/08/2017 --->
<!--- SESIÓN ORDINARIA --->
	<cfset vRutaUrl = "#vCarpetaCAAA#/archivos_ctic/archivos_pleno">
	<cfset vCuentaSel  = 0>

	<cfset vTituloSistema= UCASE('Consejo Técnico de la Investigación Científica / Becarios posdoctorales')>
    
	<cfquery name="tbAsuntosPleno" datasource="#vOrigenDatosSAMAA#">
		SELECT * FROM ((((movimientos_solicitud 
		LEFT JOIN academicos ON movimientos_solicitud.sol_pos2 = academicos.acd_id)
		LEFT JOIN catalogo_cn ON
		CASE
		WHEN movimientos_solicitud.sol_pos3 IS NULL THEN
			movimientos_solicitud.sol_pos8
		ELSE
			movimientos_solicitud.sol_pos3
		END
		= catalogo_cn.cn_clave)
		LEFT JOIN movimientos_asunto ON movimientos_solicitud.sol_id = movimientos_asunto.sol_id)
		LEFT JOIN catalogo_movimiento ON movimientos_solicitud.mov_clave = catalogo_movimiento.mov_clave)
		LEFT JOIN catalogo_dependencia ON movimientos_solicitud.sol_pos1 = catalogo_dependencia.dep_clave
		WHERE movimientos_asunto.ssn_id = #Session.sSesion# and movimientos_asunto.asu_reunion = 'CTIC'
		AND movimientos_asunto.asu_parte = 3.1
		ORDER BY asu_numero
        <!--- catalogo_dependencia.dep_siglas, academicos.acd_apepat, academicos.acd_apemat, academicos.acd_nombres --->
	</cfquery>
   	<html>
		<head>
            <title><cfif #CGI.SERVER_PORT# IS '31221'>SD / </cfif>SAMAA - BECARIOS POSDOCTORALES</title>
            <meta charset="charset=iso-8859-1">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    
            <cfoutput>
                <link href="#vCarpetaCSS#/jquery/tablas_datos.css" rel="stylesheet" type="text/css">
                <script type="text/javascript" src="#vHttpWebGlobal#/xmlHttpRequest.js"></script>
            </cfoutput>
            <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.0/jquery.min.js"></script>
            <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
		</head>
		<body>
			<cfinclude template="/comun_cic/head/encabezado_sistemas.cfm">
			<br>
			<div class="container-fluid">
				<div class="col-sm-1 col-md-1 col-lg-2"></div>            
				<div class="col-sm-10 col-md-10 col-lg-8">
                    <div class="row text-center">
                        <table id="posdoc" class="table table-striped table-hover">
                            <thead>
                                <tr class="header">
                                    <th width="5%">#</th>
                                    <th width="50%">Nombre</th>
                                    <th width="15%">Entidad</th>
                                    <th width="30%">Movimiento</th>
                                    <th width="5%">PDF</th>
                                </tr>
                            </thead>
                            <tbody>
                                <cfoutput query="tbAsuntosPleno">
                                    <cfset vArchivoPdf = #sol_pos2# & '_' & #sol_id# & '.pdf'>
                                    <cfset vArchivoPlenoPdf = #vCarpetaCAAA# & #vArchivoPdf#>
                                    <cfset vArchivoPlenoPdfWeb = #vWebCAAA# & #vArchivoPdf#>
                                    <tr>
                                        <td>#asu_numero#</td>
                                        <td>#acd_prefijo# #acd_nombres# #acd_apepat# #acd_apemat#</td>
                                        <td>#dep_siglas#</td>
                                        <td><span class="Sans10Ne">#mov_titulo_corto#</span></td>
                                        <td>
                                            <cfif FileExists(#vArchivoPlenoPdf#)>
                                                <a href="#vArchivoPlenoPdfWeb#" target="winPdf"><span class="glyphicon glyphicon-open-file" style="cursor:pointer;" title="Abrir archivo"></a>
                                            </cfif>
                                        </td>
                                    </tr>
                                </cfoutput>
                            </tbody>
                        </table>
                    </div>
                </div>
			</div>                
		<cfinclude template="../includes/include_pie_pagina.cfm">
    </body>
</html>