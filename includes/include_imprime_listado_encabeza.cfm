<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 25/08/2016 --->
<!--- FECHA ÚLTIMA MOD.: 12/03/2020 --->
<!--- ENCABEZADO GENERAL PARA LA IMPRESIÓN DE LISTADOS DE INFORMACIÓN DE LOS ACADÉMICOS --->
<!--- IMPRESIÓN DE LISTADO INDIVIDUAL DE: INFORMES ANUALES, MOVIMIENTOS, ETC..  --->


				<cfoutput>
                    <link href="#vCarpetaCSS#/fuentes_listado_impresion.css" rel="stylesheet" type="text/css">
                </cfoutput>            
				<!-- Titulo da la página --->
				<center>
					<span class="Titulo">
                    	<b>
                            COORDINACIÓN DE LA INVESTIGACIÓN CIENTÍFICA
                            <br />
                            SECRETARÍA TÉCNICA DEL CONSEJO TÉCNICO
						</b>
					</span>                        
                    <br />
                    <br />
					<span class="Subtitulo">
						<cfif #vModuloImp# EQ 'INFORME'>
							<cfif #vTipoReporte# EQ 'ACUSE'>
	                            <i><b><cfoutput>#tbInformesAnual.dep_nombre#</cfoutput></b></i><br />
                            </cfif>
                            <i><b>INFORMES ANUALES</b></i>
                            <br>                            
							<cfif #vTipoReporte# EQ 'IND'>
                                <cfoutput query="tbAcademico">
                                    <b>#acd_prefijo# #acd_nombres# #acd_apepat# #acd_apemat#</b>
                                    <br>
                                    #dep_nombre#
                                </cfoutput>
                                <br><br>
							<cfelseif #vTipoReporte# EQ 'MODINFREC'>
                                <cfoutput><b>#Session.InformesFiltro.vInformeAnio#</b></cfoutput>
                                <br><br>                        	
                            <cfelse>
                                <cfoutput><b>#Session.InformesConsultaFiltro.vInformeAnio#</b></cfoutput>
                                <br><br>
                            </cfif>
						<cfelseif  #vModuloImp# EQ 'MOVIMIENTOS'>
							<cfoutput>                        
								<cfif #vTipoReporte# EQ 'IND'>
                                    <b>#tbMovimientos.acd_prefijo# #tbMovimientos.acd_nombres# #tbMovimientos.acd_apepat# #tbMovimientos.acd_apemat#</b>
                                    <br/>
                                    #tbMovimientos.dep_nombre#
                                    <br/><br/>
                                    <i><b>MOVIMIENTOS ACAD&Eacute;MICO-ADMINISTRATIVOS</b></i>
                                    <br/>
								<cfelseif #vTipoReporte# EQ 'SES'>
									<br/>
									<i>ASUNTOS RESUELTOS EN LA SESION <cfoutput>#vActa#</cfoutput></i>
								<cfelseif #vTipoReporte# EQ 'VENCE'>
									<br/>
									<i>MOVIMIENTOS POR VENCER EN LOS PR&Oacute;XIMOS 3 MESES</i>
								</cfif>
							</cfoutput>
						<cfelseif  #vModuloImp# EQ 'ASUNTOS'>
							<cfif #vTipoReporte# EQ 'LEXPEDIENTE'>
                                <br/>
                                <b><i>REGISTRO DE PRÉSTAMO DE EXPEDIENTES DEL ARCHIVO PARA LA SESIÓN </i><cfoutput>#vSsnId#</cfoutput></b>
                                <br/>
							<cfelseif #vTipoReporte# EQ 'LPROBATORIOS'>
                                <b><i>RELACIÓN DE ASUNTOS DEL ACTA </i><cfoutput>#vSsnId#</cfoutput></b>
                                <br/>
							</cfif>
						</cfif>
					</span>
				</center>