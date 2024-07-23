					<!--- CREADO: ARAM PICHARDO--->
					<!--- EDITO: ARAM PICHARDO--->
					<!--- FECHA CREA: 13/04/2018 --->
					<!--- FECHA ULTIMA MOD.: 13/04/2018 --->
					
					<!--- CONTROL PARA LISTAR LAS SESIONES POSTERORES A LA SESIÓN VIGENTE DEL CTIC --->
                    <!--- NOTA: remplaza al archivo movimientos_catalogoa_select.cfm --->

					<cfset vSsnId = "#attributes.SsnId#">

                    <cfquery name="tbSesiones" datasource="samaa">
                        SELECT TOP 5 ssn_id FROM sesiones 
                        WHERE ssn_clave = 1
                        AND ssn_id >= #vSsnId#
                        ORDER BY ssn_id
                    </cfquery>
                    
                    <select name="vSsnId" id="vSsnId" class="datos">
                        <cfoutput query="tbSesiones">
                            <option value="#ssn_id#">#ssn_id#</option>
                        </cfoutput>
                    </select>