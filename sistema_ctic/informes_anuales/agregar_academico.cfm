<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 23/05/2016 --->
<!--- FECHA ULTIMA MOD.: 09/02/2022 --->
<!--- VENTANA EMERGENTE USANDO JQUERY para agregar nuavos académicos al listado de informes --->

<!--- LLAMADO A CÓDIGO DE JAVA SCRIPT COMÚN O GLOBAL --->
<cfoutput>
	<link href="#vCarpetaCSS#/fuentes.css" rel="stylesheet" type="text/css">
	<script type="text/javascript" src="#vCarpetaRaizLogica#/sistema_ctic/comun/java_script/ajax_lista_academicos.js"></script>
</cfoutput>

<cfif #Session.sTipoSistema# EQ 'stctic'>
	<cfset vInformeStatus = 1>
<cfelse>
	<cfset vInformeStatus = 0>
</cfif>

<!--- JQUERY USO LOCAL --->
<script language="JavaScript" type="text/JavaScript">
	function fGuardaAcademico()
	{
		if ($("#vSelAcad").val() > 0)
		{
			$.ajax({
				//async: false,
				url: "ajax/informe_agregar_academico.cfm",
				method: "POST",
				//data: new FormData($('#frmAgregarAcd')[0]),
				data: {acd_id:$("#vSelAcad").val(), informe_anio:$("#informe_anio").val(), informe_status:$("#informe_status").val()},
				success: function(data) {
					location.reload();
					//fListarInformes();
					//alert(data);
				},
				error: function(data) {
					alert('ERROR AL AGREGAR ACADÉMICO');
					//alert(data);						
				}
			});
		}
		else
		{alert('NO HA SELECCIONADO ACADÉMICO');}
	}    
</script>
<cfform id="frmAgregarAcd" name="frmAgregarAcd">
	<br>
	<label class="Sans11NeNe">Escriba el nombre del acad&eacute;mico a agregar</label><br>
    <cfinput type="text" id="vAcadNom" name="vAcadNom" value="" class="datosJQ100" onKeyUp="fListaSeleccionAcademico('NAME');">
	<cfinput type="hidden" id="vSelAcad" name="vSelAcad" value="">
	<cfinput type="hidden" id="informe_anio" name="informe_anio" value="#vpInformeAnio#">
	<cfinput type="hidden" id="informe_status" name="informe_status" value="#vInformeStatus#">    
	<cfinput type="hidden" id="vAcadRfc" name="vAcadRfc" value="">
	<cfinput type="hidden" id="vAcadId" name="vAcadId" value="">
	<cfinput type="hidden" id="vLigaAjax" name="vLigaAjax" value="#vAjaxListaAcademicos#">
    <div id="lstAcad_dynamic" style="position:absolute;display:block;">
        <!-- AJAX: Lista desplegable de académicos -->
    </div>
    <br><br>
    <div align="center"><cfinput type="button" id="" name="" value="Agregar" class="botonesStandar" onClick="fGuardaAcademico();"></div>
    <br />
    <span class="Arial10rojaN">Nota: </span><span class="Arial10roja">Es importante verificar que el acad&eacute;mico a agregar no est&eacute; en el listado para evitar que se duplique</span>
</cfform>
