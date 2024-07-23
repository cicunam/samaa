<!--- CREADO: ARAM PICHARDO--->
<!--- EDITO: ARAM PICHARDO--->
<!--- FECHA CREA: 14/06/2016--->
<!--- FECHA ÚLTIMA MOD.: 09/10/2017--->
<!--- MÓDULO PARA BUSCAR Y UBICAR UNA SOLICITUD  --->

<!--- Busca en la tabla de solicitudes si existe en número de solicitud --->
<cfquery name="tbSolicitudesSearch" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM movimientos_solicitud AS T1
    WHERE sol_id = #vSolIdBusqueda#
</cfquery>

<cfif #tbSolicitudesSearch.RecordCount# GT 0>
	<!--- En caso de encontrar resultados, verifica la situación de la solicitud --->
	<cfif #tbSolicitudesSearch.sol_status# GTE 4>
        <!--- EN LA ENTIDAD --->
		<cfset vcflocation = "consulta_entidades.cfm">
		<cfset vModuloMarca = "SolEntidad">
        <cfif NOT IsDefined('Session.AsuntosEntidadFiltro')>    
			<cfset vcflocation = #vcflocation# & "?vpSolIdBusqueda=" & #vSolIdBusqueda#>
        <cfelse>
            <cfset Session.AsuntosEntidadFiltro.vNumSol = #vSolIdBusqueda#>
        </cfif>
    <cfelseif #tbSolicitudesSearch.sol_status# EQ 3>
        <!--- EN SOLICITUDES RECIBIDAS --->
		<cfset vcflocation ="consulta_revisiones.cfm">
		<cfset vModuloMarca = "SolRecibidas">
        <cfif NOT IsDefined('Session.AsuntosRevisionFiltro')>    
			<cfset vcflocation = #vcflocation# & "?vpSolIdBusqueda=" & #vSolIdBusqueda#>
        <cfelse>
            <cfset Session.AsuntosRevisionFiltro.vNumSol = #vSolIdBusqueda#>
        </cfif>
    <cfelseif #tbSolicitudesSearch.sol_status# EQ 2>
        <!--- EN LA CAAA --->
        <cfquery name="tbSolAsunto" datasource="#vOrigenDatosSAMAA#">
            SELECT ssn_id FROM movimientos_asunto
            WHERE sol_id = #vSolIdBusqueda#
			AND asu_reunion = 'CAAA'
        </cfquery>
		<cfset vcflocation ="../reuniones/consulta_caaa.cfm"> 
		<cfset vModuloMarca = "AsuntosCAAA">
        <cfif NOT IsDefined('Session.AsuntosCAAAFiltro')>    
			<cfset vcflocation = "#vcflocation#?vpSolIdBusqueda=#vSolIdBusqueda#&vpSsnIdBusqueda=#tbSolAsunto.ssn_id#">
        <cfelse>
            <cfset Session.AsuntosCAAAFiltro.vNumSol = #vSolIdBusqueda#>
			<cfset Session.AsuntosCAAAFiltro.vActa = #tbSolAsunto.ssn_id#>
        </cfif>
    <cfelseif #tbSolicitudesSearch.sol_status# LTE 1>
        <!--- EN LA PLENO DEL CTIC --->
        <cfquery name="tbSolAsunto" datasource="#vOrigenDatosSAMAA#">
            SELECT ssn_id FROM movimientos_asunto
            WHERE sol_id = #vSolIdBusqueda#
			AND asu_reunion = 'CTIC'
        </cfquery>
		<cfset vcflocation ="../reuniones/consulta_pleno.cfm">
		<cfset vModuloMarca = "AsuntosCTIC">
        <cfif NOT IsDefined('Session.AsuntosCTICFiltro')>    
			<cfset vcflocation = "#vcflocation#?vpSolIdBusqueda=#vSolIdBusqueda#&vpSsnIdBusqueda=#tbSolAsunto.ssn_id#">
        <cfelse>
            <cfset Session.AsuntosCTICFiltro.vNumSol = #vSolIdBusqueda#>
			<cfset Session.AsuntosCTICFiltro.vActa = #tbSolAsunto.ssn_id#>
        </cfif>
    </cfif>
    <html>
        <head>
            <title>SAMAA - Búsqueda de solicitud</title>
            <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    
            <script type="text/javascript">
                function fRedirecciona()
                {
                    alert('SE ENCONTRÓ EN SOLICITUDES EN LA ENTIDAD');
                }
                window.parent.frames['topFrame'].MarcarModulo('<cfoutput>#vModuloMarca#</cfoutput>');
                window.location = '<cfoutput>#vcflocation#</cfoutput>';
                //window.parent.frames['topFrame'].document.getElementById('SolEntidad').className = 'MenuEncabezadoBotonSeleccionado';
            </script>
        </head>
        <body onLoad="fRedirecciona();">
            <cfoutput>#vcflocation# - #vModuloMarca#
                <input type="hidden" id="vcflocation" value="#vcflocation#" />
                <input type="hidden" id="vModuloMarca" value="#vModuloMarca#" />
            </cfoutput>
        </body>
    </html>
<cfelse>
	<script type="text/javascript">
    	alert('NO SE ENCONTRÓ EL NÚMERO DE SOLICITUD');
		//window.location.reload();
		
	</script>
</cfif>
