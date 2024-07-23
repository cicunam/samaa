<!--- CREADO: ARAM PICHARDO DURAN --->
<!--- EDITO: ARAM PICHARDO DURAN --->
<!--- FECHA CREA: 04/11/2022 --->
<!--- FECHA ÚLTIMA MOD.: 08/11/2022 --->
<!--- CÓDIGO PARA NUMEROS COAS Y SOLICITUDES REGISTRADAS --->
<!--- CONVOCATORIAS COAs --->

<cfquery name="ctEntidades" datasource="#vOrigenDatosCATALOGOS#">
    SELECT dep_nombre, MID(dep_clave,1,5) AS dep_clave
    FROM catalogo_dependencias
    WHERE dep_clave LIKE '03%'
    AND dep_status = 1
    AND (dep_tipo = 'INS' OR dep_tipo = 'CEN' OR dep_tipo = 'DEP' OR dep_tipo = 'DDC')
    ORDER BY dep_orden, dep_nombre
</cfquery>

<!doctype html>
<html>
    <head>
        <meta charset="utf-8">
        <title>Reporte COA's</title>
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">        
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.0/jquery.min.js"></script>
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>        
        
    </head>
    <body>
		<div class="container-fluid text-center" style="min-height: 400px;">
			<div class="row content">
                <div class="col-sm-1 sidenav text-left visible-md visible-lg"></div>
				<div class="col-sm-10 text-left">        
                    <h4><strong>SUBSISTEMA DE LA INVESTIGACI&Oacute;N CIENT&Iacute;FICA</strong></h4>
                    <h4><strong>CONVOCATORIAS DE CONCURSO DE OPOSICI&Oacute;N ABIERTO</strong></h4>
                    <h3></h3>
                    <table class="table table-striped table-hover table-condensed">
                        <tr class="header">
                            <cfif CGI.SERVER_PORT IS "31221">                
                                <td></td>
                            </cfif>                
                            <td><strong>Entidad acad&eacute;mica</strong></td>
                            <td colspan="3" align="center"><strong>Convocatorias</strong></td>
                            <td colspan="2" align="center"><strong>Ganador COA</strong></td>                
                            <td colspan="3" align="center"><strong>Solicitudes registradas y concluidas</strong></td>
                        </tr>
                        <tr class="header">
                            <td></td>
                            <cfif CGI.SERVER_PORT IS "31221">                
                                <td></td>
                            </cfif>
                            <td align="center"><strong>Total</strong></td>
                            <td align="center"><strong>Concluidas</strong></td>
                            <td align="center"><strong>En proceso</strong></td>
                            <td align="center"><strong>Mujeres</strong></td>
                            <td align="center"><strong>Hombres</strong></td>
                            <td align="center"><strong>Total</strong></td>
                            <td align="center"><strong>Mujeres</strong></td>
                            <td align="center"><strong>Hombres</strong></td>
                        </tr>            
                        <cfoutput query="ctEntidades">
                            <cfquery name="tbConvocatorias" datasource="#vOrigenDatosSAMAA#">
                                SELECT 
                                T1.coa_id, T1.dep_clave, T1.coa_status
                                ,
                                (
                                    SELECT COUNT(*) FROM movimientos AS TM1
                                    LEFT JOIN academicos AS TM2 ON TM1.acd_id = TM2.acd_id
                                    WHERE TM1.coa_id = T1.coa_id
                                    AND TM2.acd_sexo = 'F'
                                ) AS vMovM
                                ,
                                (
                                    SELECT COUNT(*) FROM movimientos AS TM1
                                    LEFT JOIN academicos AS TM2 ON TM1.acd_id = TM2.acd_id
                                    WHERE TM1.coa_id = T1.coa_id
                                    AND TM2.acd_sexo = 'M'
                                ) AS vMovH
                                ,
                                (
                                    SELECT COUNT(*) FROM movimientos_solicitud AS TS1
                                    LEFT JOIN academicos AS TS2 ON TS1.sol_pos2 = TS2.acd_id
                                    WHERE TS1.sol_pos23 = T1.coa_id
                                    AND TS2.acd_sexo = 'F'
                                ) AS vSolM
                                ,
                                (
                                    SELECT COUNT(*) FROM movimientos_solicitud AS TS1
                                    LEFT JOIN academicos AS TS2 ON TS1.sol_pos2 = TS2.acd_id
                                    WHERE TS1.sol_pos23 = T1.coa_id
                                    AND TS2.acd_sexo = 'M'
                                ) AS vSolH
                                FROM convocatorias_coa AS T1
                                WHERE T1.dep_clave LIKE '#dep_clave#%'
                                AND T1.ssn_id > 1618
                                AND T1.coa_status BETWEEN 4 AND 16
                            </cfquery>

                            <cfquery name="tbConvocatoriasTemp" dbtype="query">
                                SELECT COUNT(*) AS vCuenta,
                                (SUM(vMovM) + SUM(vSolM)) AS vCoaGanaM,
                                (SUM(vMovH) + SUM(vSolH)) AS vCoaGanaH
                                FROM tbConvocatorias
                            </cfquery>

                            <cfquery name="tbConvocatoriasProc" dbtype="query">
                                SELECT COUNT(*) AS vCuenta
                                FROM tbConvocatorias
                                WHERE coa_status = 4
                            </cfquery>

                            <cfquery name="tbConvocatoriasCon" dbtype="query">
                                SELECT COUNT(*) AS vCuenta
                                FROM tbConvocatorias
                                WHERE coa_status > 4
                            </cfquery>                

                            <cfquery name="tbSolCoa" datasource="#vOrigenDatosSOLCOA#">                        
                                SELECT SUBSTRING(sol_curp, 11, 1) AS vSexo
                                FROM consultaSolicitudConvoca
                                WHERE solicitud_id > 0
                                AND solicitud_status > 4
                                AND dep_clave LIKE '#dep_clave#%'
                            </cfquery>

                            <cfquery name="tbSolCoaM" dbtype="query">
                                SELECT COUNT(*) AS vCuenta
                                FROM tbSolCoa
                                WHERE vSexo = 'M'
                            </cfquery>

                            <cfquery name="tbSolCoaH" dbtype="query">                        
                                SELECT COUNT(*) AS vCuenta
                                FROM tbSolCoa
                                WHERE vSexo = 'H'
                            </cfquery>                

                            <tr>
                                <cfif CGI.SERVER_PORT IS "31221">
                                    <td>#dep_clave#</td>
                                </cfif>
                                <td>#dep_nombre#</td>
                                <td align="center"><strong>#tbConvocatoriasTemp.vCuenta#</strong></td>
                                <td align="center">#tbConvocatoriasCon.vCuenta#</td>
                                <td align="center">#tbConvocatoriasProc.vCuenta#</td>
                                <td align="center">#tbConvocatoriasTemp.vCoaGanaM#</td>
                                <td align="center">#tbConvocatoriasTemp.vCoaGanaH#</td>
                                <td align="center"><strong>#tbSolCoa.RecordCount#</strong></td>
                                <td align="center">#tbSolCoaM.vCuenta#</td>
                                <td align="center">#tbSolCoaH.vCuenta#</td>
                            </tr>
                        </cfoutput>
                    </table>
                </div>
                <div class="col-sm-1 sidenav text-left visible-md visible-lg"></div>
            </div>
        </div>
    </body>
</html>