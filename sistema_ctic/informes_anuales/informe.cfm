<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 27/10/2016 --->
<!--- FECHA ÚLTIMA MOD.: 21/05/2021 --->
<!--- PANTALLA PARA CONSULTAR Y/O EDITAR REGISTROS DE LOS INFORMES ANUALES --->

<cfparam name="vInformeAnualId" default="0">

<!--- QUERY PARA DESPLEGAR INFORMACIÓN --->
<cfquery name="tbInformesAnuales" datasource="#vOrigenDatosSAMAA#">
	SELECT
    T1.informe_anual_id, T1.informe_anio,
    T2.acd_id,
    ISNULL(dbo.SINACENTOS(T2.acd_apepat),'') + 
    CASE WHEN acd_apepat IS NULL THEN '' ELSE ' ' END + 
    ISNULL(dbo.SINACENTOS(T2.acd_apemat),'') + 
    CASE WHEN acd_apemat IS NULL THEN '' ELSE ' ' END + 
    ISNULL(dbo.SINACENTOS(T2.acd_nombres),'') AS acd_nombre_completo,
	T1.cn_clave,
    T1.dep_clave, C1.dep_nombre, T1.ubica_clave,
    T1.dec_clave_ci, T1.comentario_clave_ci, T1.comentario_texto_ci,
    T1.informe_status
    FROM movimientos_informes_anuales AS T1
	LEFT JOIN academicos AS T2 ON T1.acd_id = T2.acd_id
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C1 ON T1.dep_clave = C1.dep_clave <!---CATALOGOS GENERALES MYSQL --->
	<!--- LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_cn')# AS C2 ON T1.cn_clave = C2.cn_clave CATALOGOS GENERALES MYSQL --->
    WHERE T1.informe_anual_id = #vInformeAnualId#
</cfquery>

<!--- Obtener la lista de dependencias --->
<cfquery name="ctDependencia" datasource="#vOrigenDatosCATALOGOS#">
	SELECT * FROM catalogo_dependencias
    ORDER BY dep_nombre
</cfquery>

<!--- Obtener la lista de ubicaciones de la dependencia (CATÁLOGOS GENERALES MYSQL) --->
<cfquery name="ctUbicacion" datasource="#vOrigenDatosCATALOGOS#">
	SELECT *, CONCAT(TRIM(ubica_nombre),  ', ', TRIM(ubica_lugar)) AS ubica_completa
    FROM catalogo_dependencias_ubica
	WHERE dep_clave = '#tbInformesAnuales.dep_clave#' 
    AND ubica_status = 1
	ORDER BY ubica_clave
</cfquery>

<!--- Obtener la lista de categorías y niveles (CATÁLOGOS GENERALES MYSQL) --->
<cfquery name="ctCategoria" datasource="#vOrigenDatosCATALOGOS#">
	SELECT * FROM catalogo_cn 
	WHERE cn_siglas LIKE 'AYU%' OR cn_siglas LIKE 'INV%' OR cn_siglas LIKE 'PRO%' OR cn_siglas LIKE 'SIN%' OR cn_siglas LIKE 'TEC%' <!--- Solución temporal --->
	ORDER BY cn_siglas
</cfquery>

<!--- Obtener la lista de decisiones del CTIC (CATÁLOGOS LOCAL SAMAA) --->
<cfquery name="ctDecisionCi" datasource="#vOrigenDatosSAMAA#">
    SELECT * 
    FROM catalogo_decision
    WHERE dec_marca_ci = 1
</cfquery>

<cfif #vTipoComando# EQ "EDITA">
	<cfset vActivaCampos = "">
<cfelseif #vTipoComando# EQ "CONSULTA" OR #vTipoComando# EQ "CONSEMERGENTE">
	<cfset vActivaCampos = "disabled">
</cfif>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="es">
	<head>
		<title>STCTIC - Asuntos Acad&eacute;mico-Administrativos</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<cfoutput>
			<link href="#vCarpetaCSS#/formularios.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/general.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/fuentes.css" rel="stylesheet" type="text/css">
			<link href="#vHttpWebGlobal#/css/jquery/jquery-ui-1.8.16.custom.css" type="text/css" rel="Stylesheet">
			<!--- JQUERY --->
			<script type="text/javascript" src="#vHttpWebGlobal#/jquery/jquery-1.6.2.min.js"></script>
			<script type="text/javascript" src="#vHttpWebGlobal#/jquery/jquery-ui-1.8.16.custom.min.js"></script>
			<!--- <script type="text/javascript" src="#vHttpWebGlobal#/xmlHttpRequest.js"></script> --->
			<!--- LLAMADO A CÓDIGO DE JAVA SCRIPT COMÚN O GLOBAL --->
            <script type="text/javascript" src="#vCarpetaRaizLogica#/sistema_ctic/comun/java_script/mascara_entrada.js"></script>
		</cfoutput>
		<script language="JavaScript" type="text/JavaScript">
			// Listar la historia del asunto:
			function fHistoriaAsunto()
			{
				$.ajax({
					//async: false,
					method: "POST",
					data: 
						{
							<cfoutput>
							vInformeAnualId:#vInformeAnualId#,
							vTipoAsunto:'INF'
							<cfif #vActivaCampos# NEQ ''>
								, 
								vActivaCampos:'#vActivaCampos#'
							</cfif>
							</cfoutput>							
						},
					url: "<cfoutput>#vCarpetaRaizLogicaSistema#</cfoutput>/comun/movimientos_asunto_lista.cfm",
					success: function(data) {
						$("#historia_informe_asunto_dynamic").html(data);
						//data;
					},
					error: function(data) {
						alert('ERROR AL DESPLEGAR EL CATÁLOGO DE COMENTARIOS');
						//alert(data);
					}
				});				
			}
			/* SCRIPT PARA HABILITAR O DESHABILITAR TR DE COMENTARIO */
			function fDespliegaComentarioCi()
			{
				if ($('#dec_clave').val() == 4 || $('#dec_clave').val() == 49)
				{
					document.getElementById('trComentarioCi').style.display = '';
					document.getElementById('trComentarioCiTexto').style.display = '';
					fCatalogoComentario();
				}
				else
				{
					document.getElementById('trComentarioCi').style.display = 'none';
					document.getElementById('trComentarioCiTexto').style.display = 'none';
				}				
			}
			
			function fCatalogoComentario()
			{
				$.ajax({
					//async: false,
					method: "POST",
					data: 
						{
							vpDecClave:$("#dec_clave").val(), 
							vpComentaClaveCi:$("#comentario_clave_ci_tmp").val()
							<cfif #vActivaCampos# NEQ ''>
								, 
								vActivaCampos:'<cfoutput>#vActivaCampos#</cfoutput>'
							</cfif>
						},
					url: "ajax/catalogo_comentarios.cfm",
					success: function(data) {
						$("#div_catalogo_comentarios").html(data);
						//location.reload();
						//fListarInformes();
						//data;
						
					},
					error: function(data) {
						alert('ERROR AL DESPLEGAR EL CATÁLOGO DE COMENTARIOS');
						//alert(data);
					}
				});
			}				
		</script>
	</head>
	
    <body onload="fHistoriaAsunto(); fDespliegaComentarioCi();">
		<cfform name="formInformeAnual" enctype="multipart/form-data" method="post" action="informe_acciones.cfm">
			<!-- Cintillo con nombre y número de registro --> 
			<table class="Cintillo">
				<tr>
					<td width="100%"><span class="Sans9GrNe">DETALLE DEL INFORME ANUAL &gt;&gt; </span><cfoutput><span class="Sans9Gr">#vTipoComando#</span></cfoutput></td>
				</tr>
			</table>
			<table width="90%" border="0">
				<tr>
					<cfif IsDefined('Session.InformesFiltro')> <!--- NO MUESTRA EL MENÚ EN LAS CONSULTAS FUERA DEL MÓDULO (23/05/2019) --->
                        <!-- Menú lateral --> 
                        <td class="menuformulario">
                            <cfinclude template="include_informe_menu.cfm">
                        </td>
					</cfif>
					<!-- Formulario -->
					<td class="formulario">
                        <p align="center">
                            <span class="Sans12GrNe">Informe Anual <cfoutput>#tbInformesAnuales.informe_anio#</cfoutput></span>
                            <br>
						</p>
						<div>
							<!--- INFORMACIÓN DEL ACADÉMICIO --->
							<cfoutput query="tbInformesAnuales">
                                <table border="0" class="cuadrosFormularios">
                                    <tr>
                                        <td width="18%"><span class="FormularioTexto">Entidad académica</span></td>
                                        <td width="82%">
                                            <cfinput name="dep_nombre" id="dep_nombre" type="text" class="datos100" value="#dep_nombre#" id_campo="#dep_clave#" disabled>
										</td>
                                    </tr>
                                    <tr>
                                        <td><span class="FormularioTexto">Ubicación</span></td>
                                        <td>
                                            <cfselect name="ubicacion" id="ubicacion" class="datos" query="ctUbicacion" value="ubica_clave" display="ubica_completa" queryPosition="below" selected="#ubica_clave#" style="width:480px" disabled>
	                                            <cfif #ctUbicacion.RecordCount# GT 1>
    	                                            <option value="">SELECCIONE</option>
        	                                    </cfif>
                                            </cfselect>
										</td>
                                    </tr>
                                    <tr>
                                        <td><span class="FormularioTexto">Nombre</span></td>
                                        <td>
											<cfinput name="acd_id_txt" id="acd_id_txt" type="text" value="#acd_nombre_completo#" class="datos100" disabled>
											<cfinput name="acd_id" id="acd_id" type="hidden" value="#acd_id#">
											<cfinput name="informe_anio" id="informe_anio" type="hidden" value="#informe_anio#">
											<cfinput name="informe_status" id="informe_status" type="hidden" value="#informe_status#">
										</td>
                                    </tr>
                                    <tr>
                                    <td><span class="FormularioTexto">Categoría y nivel</span></td>
                                    <td>
                                        <cfselect name="cn_clave" id="cn_clave" query="ctCategoria" value="cn_clave" display="cn_siglas" selected="#cn_clave#" queryPosition="below" class="datos" disabled="#vActivaCampos#">
                                            <option value="" selected>SELECCIONE</option>
                                        </cfselect>
                                    </td>
<!---
                                    <tr>
                                        <td><span class="Sans9GrNe">Tipo de contrato</span></td>
                                        <td>
                                            <cfinput type="radio" name="con_clave" id="con_clave_o" value="3" checked="#Iif(con_clave EQ "3",DE("yes"),DE("no"))#" disabled>Obra determinada
                                            <cfinput type="radio" name="con_clave" id="con_clave_i" value="2" checked="#Iif(con_clave EQ "2",DE("yes"),DE("no"))#" disabled>Concurso Abierto
                                            <cfinput type="radio" name="con_clave" id="con_clave_d" value="1" checked="#Iif(con_clave EQ "1",DE("yes"),DE("no"))#" disabled>Definitivo
										</td>
                                    </tr>
--->
                                </table>
							</cfoutput>
							<!--- RECOMENDACIÓN DEL CONSEJO INTERNO --->
							<br />
							<cfoutput query="tbInformesAnuales">
                                <table border="0" class="cuadrosFormularios">
                                    <!-- Titulo del recuadro -->
                                    <tr bgcolor="##CCCCCC">
                                        <td width="98%" colspan="2" style="height:15px;">
                                            <span class="Sans9GrNe"><center>EVALUACIÓN DEL CONSEJO INTERNO</center></span>
                                        </td>
                                    </tr>
									<tr>
										<td width="18%"><span class="FormularioTexto">Dictamen</span></td>
										<td width="82%">
											<cfselect name="dec_clave" id="dec_clave" query="ctDecisionCi" value="dec_clave" display="dec_descrip" selected="#dec_clave_ci#" queryPosition="below" class="datos" onChange="fDespliegaComentarioCi();" disabled="#vActivaCampos#" style="width:100%;">
												<option value="" selected>SELECCIONE</option>
											</cfselect>
										</td>
									</tr>
                                        <tr id="trComentarioCiTexto">
                                            <td><span class="Sans9GrNe">Comentario</span></td>                                    
                                            <td>
                                                <cftextarea name="comentario_texto_ci" id="comentario_texto_ci" rows="3" disabled="#vActivaCampos#" class="datos100" value="#comentario_texto_ci#"></cftextarea>
                                            </td>
                                        </tr>
										<tr id="trComentarioCi">
											<td>
												<span class="Sans9GrNe">Comentario catálogo CIC</span>
												<cfinput type="hidden" name="comentario_clave_ci_tmp" id="comentario_clave_ci_tmp" value="#comentario_clave_ci#">
											</td>
											<td>
                        	                	<cfif #informe_anio# GTE '2016'>
											  		<div id="div_catalogo_comentarios"><!--DESPLIEGA CATÁLOGO COMENTARIO --></div>
		                               		    </cfif>
                                        	</td>
										</tr>
									<cfif #dec_clave_ci# EQ 4 OR #dec_clave_ci# EQ 49>                                    
									</cfif>
								</table>
							</cfoutput>
							<!--- REGISTROS DE LOS ASUNTOS DEL CTIC --->
							<cfif #tbInformesAnuales.informe_status# GTE 2 OR #tbInformesAnuales.informe_status# EQ ''>
                                <br />
                                <cfoutput>
                                    <table border="0" class="cuadrosFormularios">
                                        <!-- Titulo del recuadro -->
                                        <tr bgcolor="##CCCCCC">
                                            <td width="98%" colspan="2" style="height:15px;">
                                                <span class="Sans9GrNe"><center>HISTORIA DEL ASUNTO CAAA/CTIC</center></span>
                                            </td>
                                        </tr>
                                        <!-- Historia del asunto -->
                                        <tr>
                                            <td>
   	                                            <div id="historia_informe_asunto_dynamic"><!-- AJAX: Historia del asunto --></div>
                                            </td>
                                        </tr>
                                    </table>
                                </cfoutput>
							</cfif>
						</div>
						<div id="divAsunto_jQuery" title="DETALLE DE ASUNTO"></div>
					</td>
				</tr>
			</table>
		</cfform>
    </body>
</html>
