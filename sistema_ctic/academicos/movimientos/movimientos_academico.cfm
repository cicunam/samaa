<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 02/10/2017 --->
<!--- FECHA ÚLTIMA MOD.: 02/10/2017 --->

<!--- LISTA DE MOVIMIENTOS DE UN ACADÉMICO --->
<!--- Registrar el filtro --->

<cfset Session.AcademicosMovFiltro.vIdAcad = #vIdAcad#>
<cfset Session.AcademicosMovFiltro.vNomAcad = '#vNomAcad#'>
<cfset Session.AcademicosMovFiltro.vRfcAcad = '#vRfcAcad#'>
<cfset Session.AcademicosMovFiltro.vFt = '#vFt#'>
<cfset Session.AcademicosMovFiltro.vAnioMov = #vAniosMov#>
<cfset Session.AcademicosMovFiltro.vPagina = #vPagina#>
<cfset Session.AcademicosMovFiltro.vRPP = #vRPP#>
<cfset Session.AcademicosMovFiltro.vOrden = '#vOrden#'>
<cfset Session.AcademicosMovFiltro.vOrdenDir = '#vOrdenDir#'>

<cfset vModuloConsutla = 'ACAD'>

<!---  INCLUDE PARA LISTAR LOS MOVIMIENTOS DEL ACADÉMICO --->
<cfinclude template="#vCarpetaRaizLogicaSistema#/comun/include_movimientos_academico.cfm">
