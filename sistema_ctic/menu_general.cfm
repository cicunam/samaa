<!--- CREADO: ARAM PICHARDO--->
<!--- EDITO: ARAM PICHARDO--->
<!--- FECHA CREA: 05/06/2009--->
<!--- FECHA : 05/06/2009--->
<!--- PÁGINA PRINCIPAL PARA LOS ACCESOS DEL SUBSISTEMA DE LA INVESTIGACIÓN CIENTÍFICA--->

<!---
		<table width="100%" border="0">
			<!-- Encabezados -->
			<tr bgcolor="#004B97">
				<td class="MenuTituloAzulM" width="33%"><span class="Sans11BlNe">Recepci&oacute;n de documentos</span></td>
				<td class="MenuTituloAzulM" width="33%"><span class="Sans11BlNe">Reuni&oacute;n de la CAAA</span></td>
				<td class="MenuTituloAzulM" width="33%"><span class="Sans11BlNe">Sesi&oacute;n del Pleno</span></td>
			</tr>
			<!-- Menús -->
			<tr>
				<!-- Receición de documentos -->
				<td class="MenuContenido">
					<cfoutput>
					<span class="Sans10Ne">
						Fecha l&iacute;mite de recepci&oacute;n de documentos:<br>
						#ReReplace(LSDATEFORMAT(tbSesionDoc.ssn_fecha, 'DDDD'),"(.)","\u\1")# #LSDATEFORMAT(tbSesionDoc.ssn_fecha, 'DD')# de #LSDATEFORMAT(tbSesionDoc.ssn_fecha, 'MMMM')#,
						para la sesi&oacute;n #LSNUMBERFORMAT(tbSesionDoc.ssn_id,'9999')#.
					<!---
						<br><br>
						<span class="Sans10Ne">Los documentos se reciben en la Secretar&iacute;a T&eacute;cnica del Consejo, hasta las 14:30 hrs del d&iacute;a se&ntilde;alado como fecha l&iacute;mite.</span>
						<br>
						--->
					</span>
					</cfoutput>
				</td>
				<!-- Reunión de la CAAA -->
				<td valign="top" class="MenuContenido">
					<cfoutput>
					<span class="Sans10Ne">
						Pr&oacute;xima reunión de la CAAA (#LSNUMBERFORMAT(tbSesionCAAA.ssn_id,'9999')#):<br>
						<cfif IsDate(#tbSesion.ssn_fecha_m#)>
							#ReReplace(LSDATEFORMAT(tbSesionCAAA.ssn_fecha_m, 'DDDD'),"(.)","\u\1")# #LSDATEFORMAT(tbSesionCAAA.ssn_fecha_m, 'DD')# de #LSDATEFORMAT(tbSesionCAAA.ssn_fecha_m, 'MMMM')# a las 10:00 hrs.<br>
						<cfelse>
							#ReReplace(LSDATEFORMAT(tbSesionCAAA.ssn_fecha, 'DDDD'),"(.)","\u\1")# #LSDATEFORMAT(tbSesionCAAA.ssn_fecha, 'DD')# de #LSDATEFORMAT(tbSesionCAAA.ssn_fecha, 'MMMM')# a las 10:00 hrs.<br>
						</cfif>
						#tbSesionCAAA.ssn_sede#
					</span>
					</cfoutput>
				</td>
				<!-- Sesión del pleno -->
				<td valign="top" class="MenuContenido">
					<cfoutput>
					<span class="Sans10Ne">
						Pr&oacute;xima Sesi&oacute;n Ordinaria del pleno (#vSesionVig#):<br>
						<cfif IsDate(#tbSesion.ssn_fecha_m#)>
							#ReReplace(LSDATEFORMAT(tbSesion.ssn_fecha_m, 'DDDD'),"(.)","\u\1")# #LSDATEFORMAT(tbSesion.ssn_fecha_m, 'DD')# de #LSDATEFORMAT(tbSesion.ssn_fecha_m, 'MMMM')# a las 10:00 hrs.<br>
						<cfelse>
							#ReReplace(LSDATEFORMAT(tbSesion.ssn_fecha, 'DDDD'),"(.)","\u\1")# #LSDATEFORMAT(tbSesion.ssn_fecha, 'DD')# de #LSDATEFORMAT(tbSesion.ssn_fecha, 'MMMM')# a las 10:00 hrs.<br>
						</cfif>
						#tbSesion.ssn_sede#
					</span>
					</cfoutput>
					<cfif #tbSesionExtra.RecordCount# GT 0>
						<br><br>
						<cfoutput>
						<span class="Sans10Ne">
							Pr&oacute;xima Sesi&oacute;n Extraordinaria del Pleno:<br>
							#ReReplace(LsDateFormat(tbSesionExtra.ssn_fecha, 'DDDD'),"(.)","\u\1")# #LsDateFormat(tbSesionExtra.ssn_fecha, 'DD')# de #LsDateFormat(tbSesionExtra.ssn_fecha, 'MMMM')# a las #LsTimeFormat(tbSesionExtra.ssn_fecha, 'HH:mm')# hrs.<br>
						</span>
						</cfoutput>
					</cfif>
				</td>
			</tr>
			<!-- Separación -->
			<tr><td class="MenuSeparacion" colspan="3"></td></tr>
		</table>
--->		
		<!-- Menú de avisos y calendario -->
		<table width="100%" border="0">
			<!-- Encabezados -->
			<tr >
				<td class="MenuTituloAzulM" width="50%"><div class="Sans11BlNe">Avisos importantes </div></td>
				<td class="MenuTituloAzulM" width="50%"><div class="Sans11BlNe">Calendario de Sesiones </div></td>
			</tr>
			<!-- Menús -->
			<tr>
				<!-- Avisos importantes -->
				<td class="MenuContenido">
					<marquee direction="up" scrollamount="1" scrolldelay="120">
						<!---
						<!-- Fecha límite de recepción de becas posdoctorales -->	
						<div style="text-align:left;" class="Sans10Ne">
							Se les recuerda que la fecha l&iacute;mite de recepci&oacute;n de Becas Posdoctorales es el <b>10 de junio de 2010</b>.
						</div>
						<br><hr><br>
						--->
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
								Si requiere apoyo t&eacute;nico escribanos a <a href="mailto:samaa@cic.unam.mx">samaa@cic-ctic.unam.mx</a>.
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
				</td>
				<!-- Calendario de sesiones -->
				<td id="calendario_dynamic" class="MenuContenido" width="50%">
					<!-- AJAX: Calendario de sesiones --> 
				</td>
			</tr>
			<!-- Separación -->
			<tr><td class="MenuSeparacion" colspan="3"></td></tr>
		</table>
		<!-- Menú de créditos -->
		<table width="100%" border="0">
			<!-- Encabezados -->
			<tr bgcolor="#004B97">
				<td class="MenuTituloAzulM" width="50%"><span class="Sans11BlNe">Requerimientos de sistema</span></td>
				<td class="MenuTituloAzulM" width="50%"><span class="Sans11BlNe">Contacto</span></td>
			</tr>
			<!-- Menús -->
			<tr>
				<!-- Menú de requerimientos -->
				<td class="MenuContenido" style="text-align: left; padding-left: 20px;">
					<span class="Sans10Ne">
						<ul>
							<li>
							<span class="Sans11Ne">Windows:</span>
							Internet Explorer 8.0+, Mozilla FireFox, Google Chrome o Apple Safari</li>
							<li>
							<span class="Sans11Ne">Mac:</span>
							Safari 1.2</li>
							<li>
							<span class="Sans11Ne">Linux:</span>
							Mozilla Firefox 3.0</li>
							<li>Adobe Reader 9+</li>
							<li>Resoluci&oacute;n de v&iacute;deo 800x600</li>
						</ul>
					</span>
				</td>
				<!-- Menú de créditos -->
				<td class="MenuContenido">
					<span class="Sans11Ne">Correo electr&oacute;nico:</span><br>
					<span class="Sans10Ne"><a href="mailto:samaa@cic-ctic.unam.mx">samaa@cic.unam.mx</a></span>
					<br><br>
					<span class="Sans11Ne">Tel&eacute;fonos: </span><br>
					<span class="Sans10Ne">5622-4168 y 5622-4170</span><br>
					<br><br>
					<span class="Sans10Ne">Aram Pichardo Durán</span><br>
					<span class="Sans10Ne">José Antonio Esteva Ramírez</span><br>
				</td>
			</tr>
		</table>
