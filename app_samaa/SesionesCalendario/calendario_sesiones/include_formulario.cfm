				<cfquery name="tbCalendario" datasource="#vOrigenDatosSAMAA#">
					SELECT TOP 1 * FROM sesiones 
					WHERE ssn_clave = #vValor#
					<cfif #vTipoComando# EQ "E" OR #vTipoComando# EQ "C">AND ssn_id = #vpSsnId#</cfif>
					ORDER BY ssn_id DESC
				</cfquery>

				<cfif #vTipoComando# EQ "N">
					<cfset vActivaCampos = "">
					<cfset vssn_fecha = #LsDateFormat(tbCalendario.ssn_fecha + 14,'dd/mm/yyyy')#>
					<cfset vssn_hora = #LsTimeFormat(tbCalendario.ssn_fecha,'HH:mm')#>
					<cfset vssn_sede = #tbCalendario.ssn_sede#>
					<cfset vssn_nota = "">
					<cfset vTitulo = "NUEVA ">
				<cfelseif #vTipoComando# EQ "E" OR #vTipoComando# EQ "C">
					<cfif #vTipoComando# EQ "E">
						<cfset vActivaCampos = "">
					<cfelseif #vTipoComando# EQ "C">
						<cfset vActivaCampos = "disabled">
					</cfif>
					<cfset vssn_fecha = #LsDateFormat(tbCalendario.ssn_fecha,'dd/mm/yyyy')#>
					<cfset vssn_hora = #LsTimeFormat(tbCalendario.ssn_fecha,'HH:mm')#><!---  --->
					<cfset vssn_sede = #tbCalendario.ssn_sede#>
					<cfset vssn_nota = #tbCalendario.ssn_nota#>
				</cfif>
				<cfif #vssn_id# LT #session.sSesion#>
					<cfset vDisabledEdita = "disabled">
				<cfelse>
					<cfset vDisabledEdita = "">
				</cfif>

				<div class="form-group">
					<label class="control-label col-sm-2" for="recdocFecha">Fecha:</label>
					<div class="col-sm-4 text-left">
						<cfinput name="ssn_fecha#vValor#" id="ssn_fecha#vValor#" value="#LsDateFormat(vssn_fecha,'dd/mm/yyyy')#" type="text" disabled='#vActivaCampos#' class="datos" size="11" maxlength="10">
    				</div>
					<div class="col-sm-6 text-left">                    
						<label for="recdocFecha">Hora:</label>
						<cfinput name="ssn_hora#vValor#" id="ssn_hora#vValor#" value="#vssn_hora#" disabled='#vActivaCampos#' type="text" class="datos" size="7" maxlength="5">
					</div>
				</div>
				<cfif #vpSesionTipo# EQ 'P'>
					<div class="form-group">
						<label class="control-label col-sm-2" for="lblsedeCaaa">Sesi&oacute;n:</label>
						<div class="col-sm-10 text-left">
							<cfselect name="ssn_id" id="ssn_id" query="ctSesiones" queryPosition="below" display="ssn_id" label="ssn_id" class="datos">
							</cfselect>
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-sm-2" for="lblsedeCaaa">Periodo convocatoria:</label>
						<div class="col-sm-10 text-left">
							<cfselect name="periodo_conv_id" id="periodo_conv_id" query="ctPosdocConvPer" queryPosition="below" display="periodo_convocatoria" value="periodo_conv_id" selected="#vperiodo_conv_id#" class="datos" disabled='#vActivaCampos#'>
								<option value="">SELECCIONE</option>
							</cfselect>
						</div>
					</div>
				</cfif>
				<div class="form-group">						
					<label class="control-label col-sm-2" for="lblsedeCaaa">Lugar:</label>
					<div class="col-sm-10 text-left">
						<cftextarea name="ssn_sede#vValor#" id="ssn_sede#vValor#" value="#vssn_sede#" cols="70" rows="2" class="datos" disabled='#vActivaCampos#'></cftextarea>
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-sm-2" for="email">Nota:</label>
					<div class="col-sm-10 text-left">
						<cftextarea name="ssn_nota#vValor#" id="ssn_nota#vValor#" value="#vssn_nota#" disabled='#vActivaCampos#' cols="70" rows="2" class="datos"></cftextarea>
					</div>
				</div>