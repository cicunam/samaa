<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 13/03/2017 --->
<!--- FECHA ÚLTIMA MOD.: 13/03/2017 --->

<cfparam name="vActivaCampos" default="">

    <cfquery name="ctComentaTextos" datasource="#vOrigenDatosSAMAA#">
        SELECT * 
        FROM catalogo_decs_informes_comenta
        WHERE dec_clave = #vpDecClave#
    </cfquery>
    
        <select name="comentario_clave_ci" id="comentario_clave_ci" class="datos" style="width:100%;" <cfoutput>#vActivaCampos#</cfoutput>>
            <option value="">SELECCIONE</option>
			<cfoutput query="ctComentaTextos">
				<option value="#comentario_clave#" <cfif #vpComentaClaveCi# EQ #comentario_clave#>selected="selected"</cfif>>#comentario_descrip#</option>
			</cfoutput>
        </select>
    

<!---
        <cfform name="frmComentaTexto">
            <cfselect name="comentario_clave_ci" id="comentario_clave_ci" class="datos" query="ctComentaTextos" value="comentario_clave" display="comentario_descrip" queryPosition="below" selected="#vpComentaClaveCi#" style="width:95%;" disabled="#vActivaCampos#">
                <option value="">SELECCIONE</option>
            </cfselect>
        </cfform>
---->		
