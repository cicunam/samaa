<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 15/05/2020 --->
<!--- FECHA ÚLTIMA MOD.: 23/02/2022  --->
<!--- INCLUDE QUE AGREGA DESPUÉS DEL ENCABEZADO LOS SUBMENÚS DEL MÓDULO SELECCIONADO --->

		<!--- LLAMADO A LA TABLA DE SUBMENÚ --->
		<cfinclude template="#vCarpetaCOMUN#/include_db_submenu.cfm">
            
		<div id="navMenus">
			<nav class="navbar navbar-default navbar-static"> <!--- navbar-fixed-top--->
                <div class="container-fluid">
                    <div class="navbar-header">
                        <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
							<cfoutput query="tbSistemaSubMenu">
	                            <span class="icon-bar"></span>
							</cfoutput>                                
                            <span class="icon-bar"></span>
                        </button>
                        <span class="navbar-brand" title="Sistema para la Administración de Movimientos Académico-Administrativos">
							<cfoutput>
                                <cfif #vMenuClave# EQ 3 AND #Session.sTipoSistema# EQ 'sic'>
                                    Informes #Session.vInformeAnio#
                                <cfelse>
    								Sesi&oacute;n vigente #Session.sSesion#
                                </cfif>
            					<input type="hidden" name="vSubMenuActivo" id="vSubMenuActivo" value="#vSubMenuActivo#">
            					<input type="hidden" value="0"  name="vPagina" id="vPagina">								
							</cfoutput>								
						</span>
                    </div>
                    <div class="navbar-collapse collapse" id="myNavbar">
                        <ul class="nav navbar-nav">
							<cfoutput query="tbSistemaSubMenu">
            	                <li class="<cfif #submenu_clave# EQ #vSubMenuActivo#>active</cfif>" id="#submenu_control_id#"><a href="?vSubMenuActivo=#submenu_clave#">#submenu_nombre#</a></li><!---- onClick="fMenuRuta('#submenu_control_id#');" --->
							</cfoutput>
						</ul>
                        <ul class="nav navbar-nav navbar-right">
							<cfoutput>
								<li title="Regresar al men&uacute; principal"><a href="#vCarpetaRaizLogica#/app_samaa/" target="_top"><span class="glyphicon glyphicon-home" style="color:##0066CC;"></span> <strong style="color:##0066CC;">Men&uacute; principal</strong></a></li>
							</cfoutput>
                        </ul>
                    </div>
                </div>
            </nav>
		</div>			