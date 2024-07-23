<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 25/04/2017 --->
<!--- FECHA �LTIMA MOD.: 25/04/2017 --->
<!--- CONTROLES DE PAGINACI�N DE CONSULTAS ****SABDO BOOTSTRAP***** --->

<!--- Controles de paginaci�n --->

	<cfif TotalPages GT 1>
		<cfoutput>
			<!--- Si no existe un filtro crear un arreglo: vConsultaFiltro --->
            <cfif NOT isDefined("vConsultaFiltro")>
                <cfset vConsultaFiltro = StructNew()>
                <cfset vConsultaFiltro.vOrden =  '#vOrden#'>
                <cfset vConsultaFiltro.vOrdenDir = '#vOrdenDir#'>
            </cfif>
            <div class="container">                
                <ul class="pager">
                    <li><a <cfif NOT PageNum GT 1>disabled="true" style="color:grey;"<cfelse>style="cursor:pointer;" onclick="#vConsultaFuncion#(1);"</cfif>>Primero</a></li>
                    <li><a <cfif NOT PageNum GT 1>disabled="true" style="color:grey;"<cfelse>style="cursor:pointer;" onclick="#vConsultaFuncion#(#Max(DecrementValue(PageNum),1)#);"</cfif>>Anterior</a></li>
                    <li><a <cfif NOT PageNum LT TotalPages>disabled="true" style="color:grey;"<cfelse>style="cursor:pointer;" onclick="#vConsultaFuncion#(#Min(IncrementValue(PageNum),TotalPages)#);"</cfif>>Siguiente</a></li>
                    <li><a <cfif NOT PageNum LT TotalPages>style="color:grey;"<cfelse>style="cursor:pointer;" onclick="#vConsultaFuncion#(#TotalPages#);"</cfif>>&Uacute;ltimo</a></li>
                </ul>
            </div>
		</cfoutput>	
	</cfif>
