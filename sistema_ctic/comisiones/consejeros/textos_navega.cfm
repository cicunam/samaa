	<table border="0" width="305" align="center">
		<cfoutput>
			<cfif #TotalPages_tbConsejeros# GT 1>
				<tr>
					<td width="25%" align="center">
						<span class="Sans10ViNe" 
							<cfif NOT PageNum_tbConsejeros GT 1>
								style="color:grey;"
							<cfelse>
								style="cursor:pointer;" onclick="fCambiaPagina(1);"
							</cfif>
							>Primero
						</span>
					</td>
					<td width="25%" align="center">
						<span class="Sans10ViNe" 
							<cfif NOT PageNum_tbConsejeros GT 1>
								style="color:grey;"
							<cfelse>
								style="cursor:pointer;" onclick="fCambiaPagina(#Max(DecrementValue(PageNum_tbConsejeros),1)#);"
							</cfif>
							>Anterior
						</span>
					</td>
					<td width="25%" align="center">
						<span class="Sans10ViNe" 
							<cfif NOT PageNum_tbConsejeros LT TotalPages_tbConsejeros>
								style="color:grey;"
							<cfelse>
								style="cursor:pointer;" onclick="fCambiaPagina(#Min(IncrementValue(PageNum_tbConsejeros),TotalPages_tbConsejeros)#);"
							</cfif>
							>Siguiente
						</span>
					</td>
					<td width="25%" align="center">
						<span class="Sans10ViNe" 
							<cfif NOT PageNum_tbConsejeros LT TotalPages_tbConsejeros>
								style="color:grey;"
							<cfelse>
								style="cursor:pointer;" onclick="fCambiaPagina(#TotalPages_tbConsejeros#);"
							</cfif>
							>&Uacute;ltimo
						</span>
					</td>
				</tr>
			</cfif>
		</cfoutput>
	</table>