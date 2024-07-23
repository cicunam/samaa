<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 25/08/2016 --->
<!--- FECHA �LTIMA MOD.: 12/03/2020 --->
<!--- ENCABEZADO GENERAL PARA LA IMPRESI�N DE LISTADOS DE INFORMACI�N DE LOS ACAD�MICOS --->
<!--- IMPRESI�N DE LISTADO INDIVIDUAL DE: INFORMES ANUALES, MOVIMIENTOS, ETC..  --->


				<cfoutput>
                    <link href="#vCarpetaCSS#/fuentes_listado_impresion.css" rel="stylesheet" type="text/css">
                </cfoutput>            
				<!-- Titulo da la p�gina --->
				<center>
					<span class="Titulo">
                    	<b>
                            COORDINACI�N DE LA INVESTIGACI�N CIENT�FICA
                            <br />
                            SECRETAR�A T�CNICA DEL CONSEJO T�CNICO
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
                                <b><i>REGISTRO DE PR�STAMO DE EXPEDIENTES DEL ARCHIVO PARA LA SESI�N </i><cfoutput>#vSsnId#</cfoutput></b>
                                <br/>
							<cfelseif #vTipoReporte# EQ 'LPROBATORIOS'>
                                <b><i>RELACI�N DE ASUNTOS DEL ACTA </i><cfoutput>#vSsnId#</cfoutput></b>
                                <br/>
							</cfif>
						</cfif>
					</span>
				</center>