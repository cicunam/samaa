				<!--- CREADO: ARAM PICHARDO--->
                <!--- EDITO: ARAM PICHARDO--->
                <!--- FECHA CREA: 22/03/2017 --->
                <!--- FECHA ULTIMA MOD.: 22/03/2017 --->
                <!--- CÓDIGO GENERAL QUE PERIMITE GENERA UN SELECT DE LAS SESIONE DEL CTIC EN LOS DIFERENTES MÓDULOS O PANTALLAS DE CAPTURA   --->

				<cfset vModuloConsulta = "#attributes.ModuloConsulta#">
				<cfset vSsnIdFIltro = "#attributes.SsnIdFiltro#">
				<cfset vSsnId = #attributes.SsnId#>
				<cfset vSsnInicio = #vSsnId# - #attributes.SsnInicio#>
				<cfset vSsnFinal = #vSsnId# + #attributes.SsnFinal#>
				<cfset vSsnVence = "#attributes.SsnVence#">
                <cfset vOnChange = "#attributes.OnChange#">
				
				<!--- Obtener las próximas sesiones --->
                <cfquery name="ctSesiones" datasource="#vOrigenDatosSAMAA#">
                    SELECT ssn_id FROM sesiones 
                    WHERE ssn_clave = 1
                    AND ssn_id BETWEEN #vSsnInicio# AND #vSsnFinal#
                    ORDER BY ssn_id DES
                </cfquery>

				<cfif #vSsnVence# EQ 1>
					<!--- Obtener el listado de sesiones donde existen solicitudes que no se ha generado movimiento --->
                    <cfquery name="ctSesionesVencidas" datasource="#vOrigenDatosSAMAA#">
                        SELECT 
                        T2.ssn_id
                        FROM movimientos_solicitud AS T1
                        LEFT JOIN movimientos_asunto AS T2 ON T1.sol_id = T2.sol_id AND asu_reunion = 'CTIC'
                        WHERE T2.ssn_id < #Session.sSesion#-1
                        AND sol_retirada IS NULL
                    <!---    
                        AND (T2.dec_clave <> 13 OR T2.dec_clave <> 11)    
                        AND (sol_status = 1 OR sol_status = 0)
                    --->	
                        GROUP BY T2.ssn_id
                        ORDER BY T2.ssn_id DESC
                    </cfquery>
				</cfif>
                
                <select name="vActa" id="vActa" class="datos" onChange="fListarSolicitudes(1);">
                    <cfoutput query="ctSesiones">
                        <option value="#ssn_id#" <cfif isDefined(#vSsnIdFIltro#) AND #vSsnIdFIltro# EQ #ssn_id# + 2>selected</cfif>>#ssn_id#</option>
                    </cfoutput>
					<cfif #vSsnVence# EQ 1>                    
						<cfoutput query="ctSesionesVencidas">
                            <option  style="color:##FF0000" value="#ssn_id#" <cfif isDefined(#vSsnIdFIltro#) AND #vSsnIdFIltro# EQ #ssn_id#>selected</cfif>>#ssn_id#</option>
                        </cfoutput>
					</cfif>
                </select>