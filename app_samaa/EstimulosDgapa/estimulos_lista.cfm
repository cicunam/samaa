<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 09/05/2019 --->
<!--- FECHA ÚLTIMA MOD.: 05/06/2019 --->
<!--- LISTA LA RELACIÓN DE ESTÍMULOS  --->

<!--- LLAMADO A LA BASE DE DATOS DE ESTÍMULOS DE DGAPA --->
<cfquery name="tbEstimulosDgapa" datasource="#vOrigenDatosSAMAA#">
	SELECT T1.*
	, 
    ISNULL(dbo.SINACENTOS(acd_apepat),'') + 
    CASE WHEN acd_apepat IS NULL THEN '' ELSE ' ' END + 
    ISNULL(dbo.SINACENTOS(acd_apemat),'') + 
    CASE WHEN acd_apemat IS NULL THEN '' ELSE ' ' END + 
    ISNULL(dbo.SINACENTOS(acd_nombres),'') AS nombre_completo_pmn
    , T2.acd_id, T2.acd_rfc, T2.dep_clave, T2.dep_ubicacion, T2.acd_prefijo, T2.acd_sexo, T2.cn_clave, T2.con_clave
    , C1.dep_clave, C1.dep_siglas
    , C2.cn_clave, cn_siglas
	, C3.pride_nombre
    FROM estimulos_dgapa AS T1
	LEFT JOIN academicos AS T2 ON T1.acd_id = T2.acd_id
	LEFT JOIN OPENQUERY(MYSQL, 'SELECT * FROM catalogos.catalogo_dependencias') AS C1 ON T1.dep_clave = C1.dep_clave
	LEFT JOIN OPENQUERY(MYSQL, 'SELECT * FROM catalogos.catalogo_cn') AS C2 ON T1.cn_clave = C2.cn_clave
	LEFT JOIN OPENQUERY(MYSQL, 'SELECT * FROM catalogos.catalogo_pride') AS C3 ON T1.pride_clave = C3.pride_clave    
   	WHERE ssn_id = #vpSsnId#
	ORDER BY    
	<cfif #vpSsnId# GTE 1576>    
    	C3.orden_samaa, T1.renovacion, C1.dep_orden, C2.cn_clase, T2.acd_apepat, T2.acd_apemat
	<cfelse>
    	C3.orden_samaa, T1.ingreso DESC, C1.dep_orden, C2.cn_clase, T2.acd_apepat, T2.acd_apemat
	</cfif>
<!--- 	ORDER BY C3.orden_samaa, T1.renovacion, T1.ingreso DESC, C1.dep_orden, T2.acd_apepat, T2.acd_apemat --->
</cfquery>

<!--- Variables de paginación --->
<cfset vConsultaTabla = tbEstimulosDgapa>
<cfif #vpSubMenuActivo# EQ '1'>
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
<cfif #vpSubMenuActivo# NEQ '1'>
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
				<cfif #vpSubMenuActivo# NEQ '1'>
					<span id="spanFiltroEntidad" class="glyphicon glyphicon-filter" title="Filtrar" style="cursor:pointer;" data-toggle="collapse" data-target="#divFiltros"></span>
				</cfif>
			</th>
			<th style="width:35%;">
				Nombre
				<cfif #vpSubMenuActivo# NEQ '1'>
					<span id="spanFiltrNombre" class="glyphicon glyphicon-filter" title="Filtrar" style="cursor:pointer;" data-toggle="collapse" data-target="#divFiltros"></span>
				</cfif>
			</th>
			<th style="width:13%;" class="hidden-sm hidden-xs">
				CCN
				<cfif #vpSubMenuActivo# NEQ '1'>
					<span id="spanFiltroCcn" class="glyphicon glyphicon-filter" title="Filtrar" style="cursor:pointer;" data-toggle="collapse" data-target="#divFiltros"></span>
				</cfif>
			</th>
			<th style="width:17%;" align="center">
				Dictamen
				<cfif #vpSubMenuActivo# NEQ '1'>
					<span id="spanFiltroEstimulo" class="glyphicon glyphicon-filter" title="Filtrar" style="cursor:pointer;" data-toggle="collapse" data-target="#divFiltros"></span>
				</cfif>
			</th>
			<th style="width:10%;" class="hidden-sm hidden-xs" align="center">Tipo</th>
			<th style="width:5%;" class="hidden-sm hidden-xs" align="center">
				Acta
				<cfif #vpSubMenuActivo# NEQ '1'>
	                <span id="spanFiltroActa" class="glyphicon glyphicon-filter" title="Filtrar" style="cursor:pointer;"></span>
				</cfif>
            </th>
			<th style="width:10%;" class="hidden-sm hidden-xs" align="center">
				No. oficio
				<cfif #vpSubMenuActivo# NEQ '1'>
					<span id="spanFiltroAnio" class="glyphicon glyphicon-filter" title="Filtrar" style="cursor:pointer;" data-toggle="collapse" data-target="#divFiltros"></span>
				</cfif>
			</th>
			<cfif #vpSubMenuActivo# EQ '1'>
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
					<!--- <span class="glyphicon glyphicon-ok"> --->
				</td>
				<td class="small hidden-sm hidden-xs">#ssn_id#</td>
				<td class="small hidden-sm hidden-xs">#estimulo_oficio#</td>
				<cfif #vpSubMenuActivo# EQ '1'>
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
			<cfif #vpSubMenuActivo# EQ '1'>
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
