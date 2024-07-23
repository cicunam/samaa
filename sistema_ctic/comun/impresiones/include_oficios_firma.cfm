<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 30/06/2017 --->
<!--- FECHA ULTIMA MOD.: 14/05/2024 --->
<!--- INCLUDE PARA EL PÁRRAFO DE FIRMA DEL COORDINADOR DE LOS OFICIOS QUE SE GENERAL OFICIOS --->

				<!--- Obtener la información del COORDINADOR actual --->
				<cfquery name="tbAcademicosCargosCoord" datasource="#vOrigenDatosSAMAA#">
					SELECT caa_firma, caa_siglas, CASE WHEN acd_sexo = 'F' THEN 'PRESIDENTA' ELSE 'PRESIDENTE' END AS vCoordTitulo
					FROM consulta_cargos_acadadm
					WHERE adm_clave = 84
					AND caa_status = 'A'
				</cfquery>

				<!--- Firma --->
                <cfoutput>
					<p class="pOficioPiePag">
						A t e n t a m e n t e
					</p>
					<!--- <p class="pOficioEspacio">&nbsp;</p>--->
					<p class="pOficioPiePag">
						"Por mi raza hablar&aacute; el esp&iacute;ritu"
					</p>
					<p class="pOficioPiePag">
						Ciudad Universitaria, Cd. Mx.,  #LCase(FechaCompleta(tbSesiones.ssn_fecha))# <!--- A SOLICITUD DE MARIANA, LA FECHA DE OFICIOS CAMBIA DEL DÍA POSTERIOR DE CTIC A LA FECHA DEL CTIC --->
					</p>
					<!--- Espacio --->
					<cfloop index="Espacio" from="1" to="5">                    
						<p class="pOficioEspacio"><br /><!--- &nbsp; ---></p>
					</cfloop>
					<p class="pOficioPiePag">
						#UCASE(tbAcademicosCargosCoord.caa_firma)#
					</p>
					<p class="pOficioPiePag">
						#tbAcademicosCargosCoord.vCoordTitulo# DEL CONSEJO T&Eacute;CNICO DE LA INVESTIGACI&Oacute;N CIENT&Iacute;FICA
						<!--- #UCASE("Presidente del Consejo T&eacute;cnico de la Investigaci&oacute;n Cient&iacute;fica")# --->
					</p>
				</cfoutput>