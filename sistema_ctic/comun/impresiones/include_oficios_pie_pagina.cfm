<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 30/06/2017 --->
<!--- FECHA ULTIMA MOD.: 22/06/2022 --->
<!--- INCLUDE PARA EL PÁRRAFO DE PIE DE PÁGINA DE LOS OFICIOS QUE SE GENERAN --->
                <cfquery name="tbDirectorio" datasource="#vOrigenDatosSAMAA#">
                    SELECT siglas_oficio
                    FROM samaa_stctic_dir
                    WHERE #now()# BETWEEN fecha_inicio AND fecha_final
                    AND nivel_id = 1
                    ORDER BY nivel_id, nombre_comp
                </cfquery>
                
                <cfif #vpSiglasOficio# EQ 'COAOP'>
                    <!--- Obtener la información del SECRETARIO ACADÉMICO actual (25/05/2022) --->
                    <cfquery name="tbAcademicosCargosSa" datasource="#vOrigenDatosSAMAA#">
                        SELECT caa_firma, caa_siglas 
                        FROM academicos_cargos
                        WHERE adm_clave = 82
                        AND caa_status = 'A'
                        AND dep_clave = '030101'
                    </cfquery>
                    <cfset vSiglasOficio = '#tbAcademicosCargosCoord.caa_siglas#/#tbAcademicosCargosSa.caa_siglas#/#Session.SiglasStCtic#/sve'>
                <cfelse>
                    <cfset vSiglasOficio = '#tbAcademicosCargosCoord.caa_siglas#/#Session.SiglasStCtic#/#LCase(vpSiglasOficio)#'>
                </cfif>
                <!--- INSERTA LAS SIGLAS DE LOS RESPONSABLES DE LOS OFICIOS --->
				<cfoutput>
					<p class="pOficioPiePag">Acta #vSsnId#</p>
					<p class="pOficioEspacio"><br /><!--- &nbsp; SE REPLAZÓ nbsp; POR br EL 23/05/2019 YA QUE INCORPORABA UN CARACTER RARO EN MSWORD ---></p>
					<p class="pOficioPiePag">
						#vSiglasOficio#<img class="pOficioRubrica" src="http://vectores.cic-ctic.unam.mx:31221#vCarpetaCOMUN#/impresiones/rubricas/20240429_rubrica_MLB_mod.jpg">
					</p>
					<!--- <img style=3D"position: absolute; margin-left: 32; margin-top: 9;" src="http://vectores.cic-ctic.unam.mx:31221#vCarpetaCOMUN#/impresiones/rubricas/20240429_rubrica_MLB_mod.jpg" width="10px" >--->
					<!--- style="background-image: url('http://vectores.cic-ctic.unam.mx:31221#vCarpetaCOMUN#/impresiones/rubricas/20240429_rubrica_MLB_mod.jpg');" --->
				</cfoutput>