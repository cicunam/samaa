<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 09/05/2019 --->
<!--- FECHA ÚLTIMA MOD.: 06/06/2022 --->
<!--- LISTA LA RELACIÓN DE ESTÍMULOS  --->

<!--- LLAMADO A LA BASE DE DATOS DE ESTÍMULOS DE DGAPA --->
<cfquery name="tbEstimulosDgapa" datasource="#vOrigenDatosSAMAA#">
	SELECT *
    FROM consulta_estimulos_dgapa
   	WHERE ssn_id = #vpSsnId#
	ORDER BY    
	<cfif #vpSsnId# GTE 1576>    
    	orden_samaa, renovacion, dep_orden, cn_clase, nombre_completo_pmn
	<cfelse>
    	orden_samaa, ingreso DESC, dep_orden, cn_clase, nombre_completo_pmn
	</cfif>
<!--- 	ORDER BY C3.orden_samaa, T1.renovacion, T1.ingreso DESC, C1.dep_orden, T2.acd_apepat, T2.acd_apemat --->
</cfquery>

<!--- Variables de paginación --->
<cfset vConsultaTabla = tbEstimulosDgapa>
<cfif #vpAppEstDgapaMenu# EQ 'subAgSesVig'>
	<cfset Session.EstimulosDgapaFiltroVig.vSsnId = #vpSsnId#>
	<cfset vConsultaFiltro = #Session.EstimulosDgapaFiltroVig#>
<cfelse>
	<cfset Session.EstimulosDgapaFiltro.vSsnId = #vpSsnId#>
	<cfset vConsultaFiltro = #Session.EstimulosDgapaFiltro#>
</cfif>

<cfset vConsultaFuncion = 'fListarRegistros'>
<cfinclude template="#vCarpetaINCLUDE#/paginacion_variables.cfm">
<!--- Controles de paginación --->
<cfinclude template="#vCarpetaINCLUDE#/paginacion_bs.cfm">

<!--- <cfif (LEN(#vpDepClave#) + LEN(#vpBuscaTexto#) + LEN(#vpBuscaPalabraClave#) + LEN(#vpTipoPublicaClave#)) GT 0>--->
<cfif #vpAppEstDgapaMenu# NEQ 'subAgSesVig'>
	<div style="color:#FF6600; position:absolute; top:-15px; left:84%; cursor:pointer;" class="hidden-xs hidden-sm hidden-md" onclick="fLimpiaFiltros();">
		<div style="float:left; width:300px;"><strong>Limpiar filtros y/o b&uacute;squedas</strong></div>
	</div>        
	<div style="color:#FF6600; position:absolute; top:-15px; left:96%; cursor:pointer;"  class="hidden-lg" onclick="fLimpiaFiltros();">
		<div style="float:left; width:20px;">
			<span class="glyphicon glyphicon-remove-sign " title="Limpiar filtros y/o búsquedas" style="color:#FF6600;"></span>
		</div>
	</div>
</cfif>
<!--- </cfif> --->

<table id="tbListaDatos" class="table table-striped table-hover table-condensed">
    <thead>
        <tr class="header">
			<th style="width:3%;"></th>
			<th style="width:7%;">
            	Entidad&nbsp;
				<cfif #vpAppEstDgapaMenu# NEQ 'subAgSesVig'>
					<span id="spanFiltroEntidad" class="glyphicon glyphicon-filter" title="Filtrar" style="cursor:pointer;" data-toggle="collapse" data-target="#divFiltros"></span>
				</cfif>
			</th>
			<th style="width:35%;">
				Nombre
				<cfif #vpAppEstDgapaMenu# NEQ 'subAgSesVig'>
					<span id="spanFiltrNombre" class="glyphicon glyphicon-filter" title="Filtrar" style="cursor:pointer;" data-toggle="collapse" data-target="#divFiltros"></span>
				</cfif>
			</th>
			<th style="width:13%;" class="hidden-sm hidden-xs">
				CCN
				<cfif #vpAppEstDgapaMenu# NEQ 'subAgSesVig'>
					<span id="spanFiltroCcn" class="glyphicon glyphicon-filter" title="Filtrar" style="cursor:pointer;" data-toggle="collapse" data-target="#divFiltros"></span>
				</cfif>
			</th>
			<th style="width:17%;" align="center">
				Dictamen
				<cfif #vpAppEstDgapaMenu# NEQ 'subAgSesVig'>
					<span id="spanFiltroEstimulo" class="glyphicon glyphicon-filter" title="Filtrar" style="cursor:pointer;" data-toggle="collapse" data-target="#divFiltros"></span>
				</cfif>
			</th>
			<th style="width:10%;" class="hidden-sm hidden-xs" align="center">Tipo</th>
			<th style="width:5%;" class="hidden-sm hidden-xs" align="center">
				Acta
				<cfif #vpAppEstDgapaMenu# NEQ 'subAgSesVig'>
	                <span id="spanFiltroActa" class="glyphicon glyphicon-filter" title="Filtrar" style="cursor:pointer;"></span>
				</cfif>
            </th>
			<th style="width:10%;" class="hidden-sm hidden-xs" align="center">
				No. oficio
				<cfif #vpAppEstDgapaMenu# NEQ 'subAgSesVig'>
					<span id="spanFiltroAnio" class="glyphicon glyphicon-filter" title="Filtrar" style="cursor:pointer;" data-toggle="collapse" data-target="#divFiltros"></span>
				</cfif>
			</th>
			<cfif #vpAppEstDgapaMenu# EQ 'subAgSesVig'>
				<th style="width:1%;" align="center"></th>
			</cfif>
		</tr>
	</thead>
	<tbody>
        <cfoutput query="tbEstimulosDgapa" startRow="#StartRow#" maxRows="#MaxRows#" >                
            <tr>
                <td class="small">#CurrentRow#</td>
                <td class="small">#dep_siglas#</td>
                <td class="small">#nombre_completo_pmn#</td>
                <td class="small hidden-sm hidden-xs">#cn_siglas#</td>
                <td class="small">#pride_nombre#<cfif #propuesto_pride_d# EQ 1> <sup><span class="glyphicon glyphicon glyphicon-asterisk samall" title="Propuesto para nivel D"></span></sup></cfif></td>
                <td class="small hidden-sm hidden-xs">
					<cfif #ingreso# EQ 1>INGRESO</cfif>
					<cfif #propuesto_pride_d# EQ 1>PROPUESTO D</cfif>
					<cfif #ratifica_caa_pride_d# EQ 1>RATIFICA D</cfif>
					<cfif #recurso_revision# EQ 1>RECURSO REV. </cfif>
					<cfif #renovacion# EQ 1>RENOVACI&Oacute;N</cfif>
					<cfif #reingreso# EQ 1>REINGRESO</cfif><!--- SE AGREGÓ EL 06/06/2022 --->
					<!--- <span class="glyphicon glyphicon-ok"> --->
				</td>
				<td class="small hidden-sm hidden-xs">#ssn_id#</td>
				<td class="small hidden-sm hidden-xs">#estimulo_oficio#</td>
				<cfif #vpAppEstDgapaMenu# EQ 'subAgSesVig'>
					<td class="small" align="center">
						<a href="&vTipoComando=EL" data-toggle="modal" data-target="###acd_id#">
							<span class="glyphicon glyphicon-remove" style="color:##F00; cursor:pointer;" title="Eliminar" onclick="fEliminaEstimuloId('#estimulo_id#','#nombre_completo_pmn#');"></span>
						</a>
					</td>
				</cfif>
            </tr>
        </cfoutput>
    </tbody>
	<tfoot>
		<tr>
			<td colspan="8">C <sup><span class="glyphicon glyphicon glyphicon-asterisk small"></span></sup> Propuesto para nivel D</td>
			<cfif #vpAppEstDgapaMenu# EQ 'subAgSesVig'>
				<td></td>
			</cfif>
		</tr>
    </tfoot>
</table>
<!--- Controles de paginación --->
<cfinclude template="#vCarpetaINCLUDE#/paginacion_bs.cfm">
<!--- Total de registros --->
<cfoutput>
    <input id="vPagAct" type="hidden" value="#PageNum#">
    <input id="vRegRan" type="hidden" value="#StartRow# al #EndRow#">
    <input id="vRegTot" type="hidden" value="#tbEstimulosDgapa.RecordCount#">
</cfoutput>
