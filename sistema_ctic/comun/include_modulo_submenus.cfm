            <nav class="navbar navbar-default navbar-static">
                <div class="container-fluid">
                    <div class="navbar-header">
                        <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
							<cfoutput query="tbSistemaSubMenu">
	                            <span class="icon-bar"></span>
							</cfoutput>                                
                            <span class="icon-bar"></span>
                        </button>
                        <span class="navbar-brand" title="Sistema para la Administración de Movimientos Académico-Administrativos">
							Sesión 
							<cfoutput>
                                #vSesionVigEst#
                                <input id="vAppEstDgapaMenu" name="vAppEstDgapaMenu" type="hidden" value="#vAppEstDgapaMenu#" maxlength="4">
                            </cfoutput>
						</span>
                    </div>
                    <div class="navbar-collapse collapse" id="myNavbar">
                        <ul class="nav navbar-nav">
							<cfoutput query="tbSistemaSubMenu">
            	                <li class="<cfif #submenu_control_id# EQ #vAppEstDgapaMenu#>active</cfif>" id="#submenu_control_id#"><a href="?vAppEstDgapaMenu=#submenu_control_id#">#submenu_nombre#</a></li><!---- onClick="fMenuRuta('#submenu_control_id#');" --->
							</cfoutput>
						</ul>
                        <ul class="nav navbar-nav navbar-right">
							<cfoutput>
								<li title="Regresar al menú principal"><a href="#vCarpetaRaizLogica#/sistema_ctic/" target="_top"><span class="glyphicon glyphicon-home" style="color:##0066CC;"></span> <strong style="color:##0066CC;">Men&uacute; principal</strong></a></li>
							</cfoutput>
                        </ul>
                    </div>
                </div>
            </nav>