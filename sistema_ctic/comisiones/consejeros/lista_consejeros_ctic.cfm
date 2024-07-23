<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO DURAN --->
<!--- FECHA CREA: 05/03/2010 --->
<!--- FECHA ULTIMA MOD.: 10/06/2016 --->

				<!---<cfoutput>#vCarpetaINCLUDE#</cfoutput> --->
                <cfparam name="vAdmClave" default="">
                <cfparam name="vDepClave" default="">
                <cfparam name="vActivo" default="">
                <cfparam name="vPagina" default="">
                
                <cfset vDepClaveCorta = #MID(vDepClave,1,4)#>

				<!--- Registrar filtros --->
                <cfset Session.ConsejerosFiltro.vDep = '#vDepClave#'>
                <cfset Session.ConsejerosFiltro.vAdmClave = '#vAdmClave#'>
                <cfset Session.ConsejerosFiltro.vActivos = '#vActivo#'>
                <cfset Session.ConsejerosFiltro.vPagina = #vPagina#>
                <cfset Session.ConsejerosFiltro.vRPP = #vRPP#>
                <cfset Session.ConsejerosFiltro.vOrden = '#vOrden#'>
                <cfset Session.ConsejerosFiltro.vOrdenDir = '#vOrdenDir#'>

				<!--- QUERY PARA DESPLEGAR INFORMACIÓN --->
                <cfquery name="tbConsejeros" datasource="#vOrigenDatosSAMAA#">
                    SELECT * FROM consulta_cargos_acadadm
                    WHERE 1 = 1
                    <!---AND C2.adm_ctic_miembro = 1 (T1.adm_clave = '01' OR T1.adm_clave = '12' OR T1.adm_clave = '32' OR T1.adm_clave = '82'  OR T1.adm_clave = '84')--->
                    <cfif #vActivo# EQ 'checked'>
                        AND caa_status = 'A'
                    </cfif>
                    <cfif #vAdmClave# NEQ ''>
                        AND adm_clave = '#vAdmClave#'
                    </cfif>
                    <cfif #vDepClave# NEQ ''>
                        AND dep_clave LIKE '#vDepClaveCorta#%'
                    </cfif>
                    ORDER BY dep_siglas ASC, adm_clave DESC
                    <cfif #vActivo# NEQ 1>, YEAR(caa_fecha_inicio) DESC</cfif>
                </cfquery>

				<!--- Variables de paginación --->
                <cfset vConsultaTabla = tbConsejeros>
                <cfset vConsultaFiltro = Session.ConsejerosFiltro>
                <cfset vConsultaFuncion = "fListarConsejeros">
                <cfinclude template="#vCarpetaINCLUDE#/paginacion_variables.cfm">

				<!--- Controles de paginación --->
                <cfinclude template="#vCarpetaINCLUDE#/paginacion.cfm">

                <table style="width: 780px;  margin: 2px 0px 10px 15px; border: none" cellspacing="0" cellpadding="1">
                    <tr valign="middle" height="18px" bgcolor="#CCCCCC">
                        <td width="6%" class="Sans9GrNe">ENTIDAD</td>
                        <td width="40%" class="Sans9GrNe">NOMBRE</td>
                        <td width="30%" class="Sans9GrNe">CARGO</td>
                        <td width="15%" class="Sans9GrNe">PERIODO / A PARTIR DE</td>
						<cfif #Session.sTipoSistema# IS 'stctic'>
							<td width="3%" bgcolor="#FFBC81"><!-- Ver PDF --></td>
    	                    <td width="3%" bgcolor="#0066FF"><!-- Ver detalle --></td>
						</cfif>
                    </tr>
            
                    <cfoutput query="tbConsejeros" startRow="#StartRow#" maxRows="#MaxRows#">

						<!--- Crea variable de archivo de solicitud --->
						<cfset vArchivoPdfTemp = #acd_id# & '_' & #caa_id# & '.pdf'>
						<cfset vArchivoCargosAAPdf = #vCarpetaCargosAA# & #vArchivoPdfTemp#>			
						<cfset vArchivoCargosAAPdfWeb = #vWebCargosAA# & #vArchivoPdfTemp#>

                        <tr onMouseOver="this.style.backgroundColor='##E8E8E8'" onMouseOut="this.style.backgroundColor='##FFFFFF'">
                            <td valign="top"><span class="Sans9Gr">#dep_siglas#</span></td>
                            <td valign="top"><span class="Sans9Gr">#acd_prefijo# #nombre_completo_npm#</span></td>
                            <td valign="top" title="#adm_descrip#"><span class="Sans9Gr">#adm_descrip#<cfif adm_clave EQ 13> T.A.</cfif></span></td>
                            <td valign="top"><span class="Sans9Gr">#LsDateFormat(caa_fecha_inicio, 'dd/mm/yyyy')# - #LsDateFormat(caa_fecha_final, 'dd/mm/yyyy')#</span></td>
							<cfif #Session.sTipoSistema# IS 'stctic'>
                                <!-- PDF -->
                                <td>
                                    <cfif FileExists(#vArchivoCargosAAPdf#)>
                                        <a href="#vArchivoCargosAAPdfWeb#" target="WINARCHIVO"><img src="#vCarpetaICONO#/pdf_icon_2017.png" width="15px" style="border:none;cursor:pointer;" title="Ver documentos en PDF"></a>
                                    </cfif>
                                </td>
                                <!-- Botón VER -->
                                <td align="center">
                                    <a href="consejero_ctic.cfm?vCaaId=#tbConsejeros.caa_id#&vTipoComando=CONSULTA"><img src="#vCarpetaICONO#/detalle_15.jpg" style="border:none;"></a>
                                </td>
							</cfif>
                        </tr>
                    </cfoutput>
                </table>
				<!--- Controles de paginación --->
                <cfinclude template="#vCarpetaINCLUDE#/paginacion.cfm">
                <!--- Total de registros --->
				<cfoutput>
                    <input id="vPagAct" type="hidden" value="#PageNum#">
                    <input id="vRegRan" type="hidden" value="#StartRow# al #EndRow#">
                    <input id="vRegTot" type="hidden" value="#tbConsejeros.RecordCount#">
                </cfoutput>
