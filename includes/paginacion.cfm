<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA: 24/04/2014 --->
<!--- CONTROLES DE PAGINACIÓN DE CONSULTAS --->

<!--- Controles de paginación --->

<table border="0" style="width:50%; margin:10px auto 10px auto;">
	<cfif TotalPages GT 1>
		<cfoutput>
			
			<cfif isDefined('vOrden') AND isDefined('vOrdenDir')>
			
				<!--- Si no existe un filtro crear un arreglo: vConsultaFiltro --->
				<cfif NOT isDefined("vConsultaFiltro")>
					<cfset vConsultaFiltro = StructNew()>
					<cfset vConsultaFiltro.vOrden =  '#vOrden#'>
					<cfset vConsultaFiltro.vOrdenDir = '#vOrdenDir#'>
				</cfif>
			
				<tr>
					<td width="25%" align="center">
						<span class="Sans10ViNe">
							<a <cfif NOT PageNum GT 1>disabled="true" style="color:grey;"<cfelse>style="cursor:pointer;" onclick="#vConsultaFuncion#(1,'#vConsultaFiltro.vOrden#','#vConsultaFiltro.vOrdenDir#');"</cfif>>Primero</a>
						</span>
					</td>
					<td width="25%" align="center">
						<span class="Sans10ViNe">
							<a <cfif NOT PageNum GT 1>disabled="true" style="color:grey;"<cfelse>style="cursor:pointer;" onclick="#vConsultaFuncion#(#Max(DecrementValue(PageNum),1)#,'#vConsultaFiltro.vOrden#','#vConsultaFiltro.vOrdenDir#');"</cfif>>Anterior</a>
						</span>
					</td>
					<td width="25%" align="center">
						<span class="Sans10ViNe">
							<a <cfif NOT PageNum LT TotalPages>disabled="true" style="color:grey;"<cfelse>style="cursor:pointer;" onclick="#vConsultaFuncion#(#Min(IncrementValue(PageNum),TotalPages)#,'#vConsultaFiltro.vOrden#','#vConsultaFiltro.vOrdenDir#');"</cfif>>Siguiente</a>
						</span>
					</td>
					<td width="25%" align="center">
						<span class="Sans10ViNe">
							<a <cfif NOT PageNum LT TotalPages>style="color:grey;"<cfelse>style="cursor:pointer;" onclick="#vConsultaFuncion#(#TotalPages#,'#vConsultaFiltro.vOrden#','#vConsultaFiltro.vOrdenDir#');"</cfif>>&Uacute;ltimo</a>
						</span>
					</td>
				</tr>
			<cfelse>
				<tr>
					<td width="25%" align="center">
						<span class="Sans10ViNe">
							<a <cfif NOT PageNum GT 1>disabled="true" style="color:grey;"<cfelse>style="cursor:pointer;" onclick="#vConsultaFuncion#(1);"</cfif>>Primero</a>
						</span>
					</td>
					<td width="25%" align="center">
						<span class="Sans10ViNe">
							<a <cfif NOT PageNum GT 1>disabled="true" style="color:grey;"<cfelse>style="cursor:pointer;" onclick="#vConsultaFuncion#(#Max(DecrementValue(PageNum),1)#);"</cfif>>Anterior</a>
						</span>
					</td>
					<td width="25%" align="center">
						<span class="Sans10ViNe">
							<a <cfif NOT PageNum LT TotalPages>disabled="true" style="color:grey;"<cfelse>style="cursor:pointer;" onclick="#vConsultaFuncion#(#Min(IncrementValue(PageNum),TotalPages)#);"</cfif>>Siguiente</a>
						</span>
					</td>
					<td width="25%" align="center">
						<span class="Sans10ViNe">
							<a <cfif NOT PageNum LT TotalPages>style="color:grey;"<cfelse>style="cursor:pointer;" onclick="#vConsultaFuncion#(#TotalPages#);"</cfif>>&Uacute;ltimo</a>
						</span>
					</td>
				</tr>
			</cfif>	
		</cfoutput>	
	</cfif>
</table>