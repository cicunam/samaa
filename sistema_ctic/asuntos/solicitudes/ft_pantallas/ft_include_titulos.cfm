<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 23/02/2016 --->
<!--- FECHA ULTIMA MOD.: 23/02/2016--->
<!--- Titulo de la forma telegrámica --->

					<cfoutput>
                        <p align="center">
                            <span class="Sans12GrNe">#ctMovimiento.mov_titulo#</span>
                            <br>
                            <cfif #ctMovimiento.mov_subtitulo# NEQ ''>
                            	<span class="Sans10Gr">#ctMovimiento.mov_subtitulo#</span>
							</cfif>
                            <cfif #ctMovimiento.mov_clase# NEQ ''>
                            	<br><span class="Sans10Gr">#ctMovimiento.mov_clase#</span>
	                            <cfif #ctMovimiento.mov_subtitulo# EQ ''><br /></cfif>
							<cfelse>
								<br />
	                            <cfif #ctMovimiento.mov_subtitulo# EQ ''><br /></cfif>
							</cfif>
                            <cfif #vTipoComando# IS 'IMPRIME'><br><br></cfif>
                        </p>
					</cfoutput>