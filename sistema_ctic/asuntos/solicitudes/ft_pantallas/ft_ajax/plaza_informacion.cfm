<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 01/01/2018 --->
<!--- FECHA ÚLTIMA MOD.: 08/05/2024 --->
<!--- 
	AJAX que muestra la información de la plaza registrada en la plantilla de la DGPo
--->


	<!--- ABRE TABLA DE CATÁLOGO DE PLANTILLAS REGISTRADASA EN LA BASE DE DATOS --->
    <cfquery name="tbCatalogoPlantillas" datasource="#vOrigenDatosPlantilla#">
        SELECT TOP 1 *
        FROM catalogo_tablas_plantillas
		WHERE plantilla_status = 1
		ORDER BY plantilla_archivo DESC
	</cfquery>

	<!--- <cfoutput>#tbCatalogoPlantillas.plantilla_archivo# - #vpNoPlaza#</cfoutput> --->
	<!--- ABRE TABLA DE CATÁLOGO DE PLANTILLAS REGISTRADASA EN LA BASE DE DATOS --->
	<cfquery name="tbPlantilla" datasource="#vOrigenDatosPlantilla#">
		SELECT *
		FROM #tbCatalogoPlantillas.plantilla_archivo#
		WHERE plaza + '-' + plaza_cv = '#vpNoPlaza#'
	</cfquery>

	<cfif #tbPlantilla.RecordCount# GT 0>
		<cfoutput query="tbPlantilla">
			<strong>INFORMACI&Oacute;N DE LA PLANTILLA #tbCatalogoPlantillas.plantilla_qna#/#tbCatalogoPlantillas.plantilla_anio#</strong>
            <hr />
            <table width="100%" border="0" cellpadding="0">
                <tr>
                    <td valign="top"><strong>Entidad</strong></td>
                </tr>
                <tr>
                    <td style="padding-left: 15px;">#adscripcion#</td>
                </tr>
                <tr>
                    <td valign="top"><strong>Cod. prog. entidad</strong></td>
                </tr>                <tr>
                    <td style="padding-left: 15px;">#dep##sd#</td>
                </tr>
                <tr>
                    <td valign="top"><strong>Clase, categor&iacute;a y nivel</strong></td>
                </tr>
                <tr>
                    <td style="padding-left: 15px;">#cn_siglas_nom#</td>
                </tr>
                <tr>
                    <td valign="top"><strong>Situaci&oacute;n</strong></td>
                </tr>
                <tr>
                    <td style="padding-left: 15px;">#status#</td>
                </tr>
                <tr>
                    <td valign="top"><strong>C&oacute;digo program&aacute;tico plaza</strong></td>
                </tr>
                <tr>
                    <td style="padding-left: 15px;">#cp#</td>
                </tr>
                <tr>
                    <td valign="top"><strong>Observaciones</strong></td>
                </tr>
                <tr>
                    <td style="padding-left: 15px;">#observaciones#</td>
                </tr>
            </table>
	  	</cfoutput>
	</cfif>