<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 03/09/2020 --->
<!--- FECHA ÚLTIMA MOD.: 12/01/2021 --->
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
    T1.informe_status,
    T1.informe_cancela
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
    
<cfset vAnioProgAct = #tbInformesAnuales.informe_anio# + 1>
<cfset vActivaCampos = "disabled">

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
					url: "<cfoutput>#vCarpetaRaizLogicaSistema#</cfoutput>/informes_anuales/ajax/catalogo_comentarios.cfm",
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
    
        <script language="JavaScript" type="text/JavaScript">
			// Mostrar el formulario para cargar archivos:
			function fCancelaInforme() {
				$('#divCancelaMovInf_jquery').dialog('open');
			}

			// Ventana del diálogo (jQuery) para LIBERAR EL REGISTRO
			$(function() {
				$('#dialog:ui-dialog').dialog('destroy');
				$('#divCancelaMovInf_jquery').dialog({
                    //alert('CANCELA INFORME');
					autoOpen: false,
					height: 200,
					width: 500,
					modal: true,
					maxHeight: 250,
					title:'CANCELAR INFORME ANUAL',
					open: function() {
						$(this).load('../../comun/cancela_movimiento_informe.cfm', {vTipoAsunto:'INF', vRegistroId:$('#informe_id').val(), vValorChk:$('#mov_cancelado').is(':checked') ? 1 : 0})
					}
				});
			});				
		</script>    
    
		<cfform name="formInformeAnual" enctype="multipart/form-data" method="post" action="informe_acciones.cfm">
			<!-- Cintillo con nombre y número de registro --> 
			<cfif #vTipoComando# NEQ "CONSEMERGENTE">
                <table class="Cintillo">
                    <tr>
                        <td width="100%"><span class="Sans9GrNe">DETALLE DEL INFORME ANUAL &gt;&gt; </span><cfoutput><span class="Sans9Gr">#vTipoComando#</span></cfoutput></td>
                    </tr>
                </table>
			</cfif>
			<table width="90%" border="0">
				<tr>
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
                                        <td width="18%"><span class="FormularioTexto">Entidad acad&eacute;mica</span></td>
                                        <td width="82%">
                                            <cfinput name="dep_nombre" id="dep_nombre" type="text" class="datos100" value="#dep_nombre#" id_campo="#dep_clave#" disabled>
                                            <cfinput name="informe_id" id="informe_id" type="#vTipoInput#" value="#vInformeAnualId#" id_campo="#vInformeAnualId#">
										</td>
                                    </tr>
                                    <tr>
                                        <td><span class="FormularioTexto">Ubicaci&oacute;n</span></td>
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
                                    <td><span class="FormularioTexto">Categor&iacute;a y nivel</span></td>
                                    <td>
                                        <cfselect name="cn_clave" id="cn_clave" query="ctCategoria" value="cn_clave" display="cn_siglas" selected="#cn_clave#" queryPosition="below" class="datos" disabled="#vActivaCampos#">
                                            <option value="" selected>SELECCIONE</option>
                                        </cfselect>
                                    </td>
                                </table>
							</cfoutput>
							<!--- RECOMENDACIÓN DEL CONSEJO INTERNO --->
							<br />
							<cfoutput query="tbInformesAnuales">
                                <table border="0" class="cuadrosFormularios">
                                    <!-- Titulo del recuadro -->
                                    <tr bgcolor="##CCCCCC">
                                        <td width="98%" colspan="2" style="height:15px;">
                                            <span class="Sans9GrNe"><center>EVALUACI&Oacute;N DEL CONSEJO INTERNO</center></span>
                                        </td>
                                    </tr>
									<tr>
										<td width="18%"><span class="FormularioTexto">Dictamen del informe</span></td>
										<td width="82%">
											<cfselect name="dec_clave" id="dec_clave" query="ctDecisionCi" value="dec_clave" display="dec_descrip" selected="#dec_clave_ci#" queryPosition="below" class="datos" onChange="fDespliegaComentarioCi();" disabled="#vActivaCampos#" style="width:100%;">
												<option value="" selected>SELECCIONE</option>
											</cfselect>
										</td>
									</tr>
									<cfif #dec_clave_ci# EQ 4 OR #dec_clave_ci# EQ 49>
                                        <tr id="trComentarioCiTexto">
                                            <td><span class="Sans9GrNe">Comentario CI</span></td>                                    
                                            <td>
                                                <cftextarea name="comentario_texto_ci" id="comentario_texto_ci" rows="3" disabled="#vActivaCampos#" class="datos100" value="#comentario_texto_ci#"></cftextarea>
                                            </td>
                                        </tr>
                                        <tr id="trComentarioCi">
                                            <td>
                                                <span class="Sans9GrNe">Comentario cat&aacute;logo CIC</span>
                                                <cfinput type="hidden" name="comentario_clave_ci_tmp" id="comentario_clave_ci_tmp" value="#comentario_clave_ci#">
                                            </td>
                                            <td>
                                                <cfif #informe_anio# GTE '2016'>
                                                    <cfset vpDecClave = #dec_clave_ci#>
                                                    <cfset vpComentaClaveCi = #comentario_clave_ci#>
                                                    <cfinclude template="#vCarpetaRaizLogicaSistema#/informes_anuales/ajax/catalogo_comentarios.cfm">
                                                </cfif>
                                            </td>
                                        </tr>
									</cfif>
                                    <!--- TEMPORAL PARA LA ASF 12/01/2021 --->
            			            <cfif #tbInformesAnuales.informe_status# EQ ''>                                        
    		    						<tr id="trProgramaAct">
	    		        					<td>
		    			                    	<span class="Sans9GrNe">Dictamen del Programa<br/>de actividades #vAnioProgAct#</span>
			    							</td>
				    						<td>APROBAR</td>
            				    		</tr>
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
												<cfinclude template="#vCarpetaRaizLogicaSistema#/informes_anuales/ajax/informe_asunto.cfm">
                                            </td>
                                        </tr>
                                    </table>
                                </cfoutput>
							</cfif>
                            <div class="cuadrosMovCanMod" style="width: 300px;">
                                <cfif #tbInformesAnuales.informe_cancela# EQ 1>
                                    <cfset informe_cancelado = 'checked'>
                                <cfelse>
                                    <cfset informe_cancelado = ''>
                                </cfif>
                                <cfoutput>
                                    <input name="mov_cancelado" id="mov_cancelado" type="checkbox" value="Si" #informe_cancelado# onclick="fCancelaInforme();" <cfif #Session.sTipoSistema# IS 'sic'>disabled</cfif>>
                                    <span class="Sans9GrNe">Informe anual cancelado</span>
                                </cfoutput>                                    
                            </div>
						    <div id="divCancelaMovInf_jquery"></div>                                    
						</div>
                        <br />
                        <hr />
                        <br />
                        <div id="divCmd" align="center">
							<div id="divCmdSub1" style="width:25%; float:left;"></div>
							<div id="divCmdSub2" style="width:60%; float:left;">
                                <div class="divInformacionAcad" onclick="fInformacionAcad(<cfoutput>'#tbInformesAnuales.acd_id#'</cfoutput>);">
                                    CONSULTAR INFORMACI&Oacute;N ACAD&Eacute;MICA REPORTADA EN CISIC
                                </div>
							</div>
							<div id="divCmdSub3" style="width:25%; float:left;"></div>
<!---
							<div style="width:50%; float:left;" align="center"><input type="button" name="cmdCierraInforme" id="cmdCierraInforme" value="CERRAR VENTANA" class="botones" onclick="fCierraVentanaInforme();" /></div>

--->
						</div>
					</td>
				</tr>
			</table>
		</cfform>        