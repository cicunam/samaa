<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 27/05/2016 --->
<!--- FECHA ÚLTIMA MOD. : 27/05/2016 --->
<!--- PÁGINA PRINCIPAL PARA LOS ACCESOS DEL SUBSISTEMA DE LA INVESTIGACIÓN CIENTÍFICA--->


					<marquee direction="up" scrollamount="1" scrolldelay="100" style="height:250px;">
						<!-- Cambio en la operación del sistema -->	
						<div style="text-align:left;" class="Sans10Ne">
							<a href="../sistema_pleno/ctic_pleno/ctic_pleno_index.cfm" target="_parent">Presentaciones de metas, estrategias, prospectivas y evaluación académica de las entidades del Subsistema de la Investigación Científica.</a><br><br>
							Se les comunica que ha cambiado la manera de imprimir la relaci&oacute;n de licencias y comisiones, el acuse de recibo de solicitudes y
							la lista de solicitudes de uso interno. Ahora, la manera de generar dichos documentos es la siguiente: 
							<ol>
								<li>Seleccionar el tipo de impresi&oacute;n del rubro <b>imprimir</b> del men&uacute; lateral de la lista de solicitudes.</li>
								<li>En el caso de licencias y comisiones, seleccionar las solicitudes que desea incluir en la relaci&oacute;n.</li>
								<li>Utilizar el bot&oacute;n de comando <b>imprimir</b> para generar el documento.</li>
							</ol>
						</div>
						<br><hr><br>
						<!-- Cambio en la operación del sistema -->	
						<div style="text-align:left;" class="Sans10Ne">
							<p>
								Si requiere apoyo t&eacute;nico escribanos a <a href="mailto:samaa@cic-ctic.unam.mx">samaa@cic-ctic.unam.mx</a>.
							</p>
						</div>
						<div class="Sans10Ne">
							<blockquote>
							<cfif IsDate(#tbSesion.ssn_fecha_m#)>
								<br><hr><br>
								<cfoutput> 
								<span class="Sans11Ne">Cambio de fecha de sesi&oacute;n ordinaria del pleno (</span>
								<span class="ArialAltas11N">
									#LSNUMBERFORMAT(tbSesion.ssn_id,'9999')#
								</span>
								)<br><br>
								<span class="Sans10Ne">del </span>
								<span class="Sans11Ne">
									#LSDATEFORMAT(tbSesion.ssn_fecha, 'DDDD')# #LSDATEFORMAT(tbSesion.ssn_fecha, 'DD')# 
								</span>
								<span class="Sans10Ne">
									de
								</span>
								<span class="Sans11Ne">
									#LSDATEFORMAT(tbSesion.ssn_fecha, 'MMMM')#
								</span>
								<br><br>
								<span class="Sans10Ne">al</span>
								<span class="Sans11Ne">
									#LSDATEFORMAT(tbSesion.ssn_fecha_m, 'DDDD')# #LSDATEFORMAT(tbSesion.ssn_fecha_m, 'DD')# 
								</span>
								<span class="Sans10Ne">
									de
								</span>
								<span class="Sans11Ne">
									#LSDATEFORMAT(tbSesion.ssn_fecha_m, 'MMMM')#
								</span>
								<span class="VerdanaAltas11b">
									.
								</span>
								</cfoutput>
							</cfif>
							</blockquote>
						</div>
					</marquee>
