<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 29/11/2016 --->
<!--- FECHA ULTIMA MOD.: 14/02/2024 --->
<!--- CÓDIGO QUE PERMITE DESPLEGAR PANTALLA EMERGENTE CON LAS SOLICITUDES DE UN ACADÉMICO EN ESPECÍFICO --->
<!--- Obtener la lista de solicitudes enviadas por las entidades académicas del SIC --->

<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
	SELECT
    T1.sol_id, T1.sol_pos14, T1.sol_status, T1.sol_devuelta,
    T2.acd_apepat, T2.acd_apemat, T2.acd_nombres,
    C1.mov_titulo_corto,
    C2.dep_siglas
    FROM ((movimientos_solicitud AS T1
	LEFT JOIN academicos AS T2 ON T1.sol_pos2 = T2.acd_id)
	LEFT JOIN catalogo_movimiento AS C1 ON T1.mov_clave = C1.mov_clave) 
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C2 ON T1.sol_pos1 = C2.dep_clave <!---CATALOGOS GENERALES MYSQL --->
	WHERE T1.sol_pos2 = #vAcadId#
    ORDER BY sol_id
</cfquery>    

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Solicitudes en proceso</title>
</head>

    <body>
		<table border="0" cellpadding="2" cellspacing="0" style="width:100%; margin: 2px 0px 5px 0px; border: none">
			<tr valign="middle" bgcolor="#CCCCCC">
                <td width="3%" height="18px"><span class="Sans10GrNe">No.</span></td>
                <td width="5%" title="Número de solicitud"><span class="Sans10GrNe">SOL ID</span></td>
                <td width="8%"><span class="Sans10GrNe">ENTIDAD</span></td>
                <td width="28%"><span class="Sans10GrNe">NOMBRE</span></td>
                <td width="25%"><span class="Sans10GrNe">ASUNTO</span></td>
                <td width="14%" title="Fecha de inicio" ><span class="Sans10GrNe">FECHA INICIO</span></td>
                <td width="13%" title="Fecha de inicio" ><span class="Sans10GrNe">SITUACI&Oacute;N</span></td>
                <td width="5%" title="Fecha de inicio" ><span class="Sans10GrNe">ACTA</span></td>                
			</tr>
			<cfoutput query="tbSolicitudes">
				<cfquery name="tbAsunto" datasource="#vOrigenDatosSAMAA#">
					SELECT TOP 1  ssn_id FROM movimientos_asunto
					WHERE sol_id = #sol_id#
					<cfif #sol_status# IS 2>
						AND asu_reunion = 'CAAA'
					<cfelseif #sol_status# LTE 1>
						AND asu_reunion = 'CTIC'									
					</cfif>
					ORDER BY ssn_id DESC
				</cfquery>
				
				<tr onMouseOver="this.style.backgroundColor='##E8E8E8'" onMouseOut="this.style.backgroundColor='##FFFFFF'">
                    <td><span class="Sans10Gr">#CurrentRow#</span></td>
                    <td><span class="Sans10Gr">#sol_id#</span></td>
                    <td><span class="Sans10Gr">#dep_siglas#</span></td>
                    <td><span class="Sans10Gr">#Trim(acd_apepat)# #Trim(acd_apemat)# #Trim(PrimeraPalabra(acd_nombres))#</span></td>
                    <td><span class="Sans10Gr">#Ucase(mov_titulo_corto)#</span></td>
                    <td>
						<span class="Sans10Gr">
							<cfif #sol_pos14# IS NOT ''><!--- Si el campo no está vacío --->
                                #LsDateFormat(sol_pos14,"dd/mm/yyyy")#
                            </cfif>
						</span>
					</td>
                    <td>
						<cfif #sol_status# IS 4>
                            <cfif #sol_devuelta# IS 1>
                                <span class="Sans10Vi" style="text-decoration: blink;">DEVUELTA</span>
                            <cfelse>
                                <span class="Sans10Gr">EN CAPTURA</span>
                            </cfif>
						<cfelseif #sol_status# IS 3>
							<span class="Sans10Vi">ENVIADA</span>
						<cfelse>
							<span class="Sans10Vi">                        
								<cfif #sol_status# IS 2>
									EN LA CAAA
								<cfelseif #sol_status# IS 1>
									PLENO DEL CTIC
								<cfelseif #sol_status# IS 0>
									EN PROCESO DE REGISTRAR MOVIMIENTO
								</cfif>
							</span>
						</cfif>
					</td>
                    <td><span class="Sans10Gr"><strong>#tbAsunto.ssn_id#</strong></span></td>                                
				</tr>
			</cfoutput>
		</table>
</body>
</html>