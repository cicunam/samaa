<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 25/04/2017 --->
<!--- FECHA ÚLTIMA MOD.: 25/04/2017 --->
<!--- VARIABLES DE PAGINACIÓN DE CONSULTAS --->

<cfparam name="vConsultaFuncion" default="fListarSolicitudes">

<cfset PageNum = #vPagina#>
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfset MaxRows=#vRPP#>
<cfset StartRow=Min((PageNum-1)*MaxRows+1,Max(vConsultaTabla.RecordCount,1))>
<cfset EndRow=Min(StartRow+MaxRows-1,vConsultaTabla.RecordCount)>
<cfset TotalPages=Ceiling(vConsultaTabla.RecordCount/MaxRows)>
<cfset QueryString=Iif(CGI.QUERY_STRING NEQ "",DE("&"&CGI.QUERY_STRING),DE(""))>
<cfset tempPos=ListContainsNoCase(QueryString,"PageNum=","&")>
<cfif tempPos NEQ 0>
	<cfset QueryString=ListDeleteAt(QueryString,tempPos,"&")>
</cfif>