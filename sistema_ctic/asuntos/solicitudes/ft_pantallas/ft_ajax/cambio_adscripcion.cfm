<!--- CREADO: ARAM PICHARDO DURAN --->
<!--- EDITO: ARAM PICHARDO DURAN --->
<!--- FECHA CREA: 20/01/2023 --->
<!--- FECHA ÚLTIMA MOD.: 20/01/2023 --->
<!--- AJAX PARA CONTROLES DE CAMBIO DE ADSCRIPCIÓN --->

<cfparam name="vpPos20" default="Si">
<cfparam name="vpAdsc" default="">
<cfparam name="vpActivaCampos" default="">


<!--- Obtener la lista de subsistemas de la UNAM (CATÁLOGOS GENERALES MYSQL) --->
<cfquery name="ctSubsistema" datasource="#vOrigenDatosCATALOGOS#">
	SELECT *, UPPER(sis_nombre) AS sis_nombre_1 
	FROM catalogo_subsistemas
	ORDER BY sis_orden
</cfquery>
<!---
<!--- Obtener la lista de ubicaciones de la dependencia (CATÁLOGOS GENERALES MYSQL) --->
<cfquery name="ctUbicacion" datasource="#vOrigenDatosCATALOGOS#">
	SELECT *, CONCAT(TRIM(ubica_nombre),  ', ', TRIM(ubica_lugar)) AS ubica_completa
    FROM catalogo_dependencias_ubica
	WHERE dep_clave = '#vCampoPos1#' 
    AND ubica_status = 1
	ORDER BY ubica_clave
</cfquery>
--->
<cfif #vpAdsc# EQ 'AA'>
    ADSCRIPCIÓN ACTUAL <cfoutput>#vpPos20#</cfoutput>dadadas
    
<cfelseif #vpAdsc# EQ 'EA'>
    ENTIDAD A LA QUE ASPIRA <cfoutput>#vpPos20#</cfoutput>
</cfif>
    
    <table border="0">
        <tbody id="DatosSolFt13">
            <cfif #vpPos20# EQ 'Si' AND #vpAdsc# EQ 'EA' OR #vpPos20# EQ 'No' AND #vpAdsc# EQ 'AA'>
                <!-- Subsistema al que asíra -->
                <tr id="trLinea_5">
                    <td><span class="Sans9GrNe">Subsistema</span></td>
                    <td>
                        <select name="pos12_o" class="datos" id="pos12_o" disabled='#vpActivaCampos#' onChange="fObtenerDepUnam();">
                            <option value="">SELECCIONE</option>
                            <cfoutput query="ctSubsistema">
                                <option value="#sis_clave#">#sis_nombre_1#</option><!---  selected="#vCampoPos12_o#" --->
                            </cfoutput>
                        </select>
                    </td>
                </tr>
                <!-- Dependencia ala que aspira -->
                <tr id="trLinea_6">
                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos11#</span></td>
                    <td>
                        <div id="depunam_dynamic"><!-- AJAX: Dependencias del SS seleccionado --></div>
                    </td>
                </tr>
            <cfelse>
                
            </cfif>
            <!-- Ubicación a la que aspira -->
            <tr id="trUbicaDepAspira">
                <td><span class="Sans9GrNe">#ctMovimiento.mov_pos11_u#</span></td>
                <td><div id="ubicasic_dynamic"><!-- AJAX: Ubicaciones de la dependencia seleccionada --></div></td>
            </tr>
            <tr id="trLinea_9">
                <td></td>
                <td></td>
            </tr>
        </tbody>
    </table>
