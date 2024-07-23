<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 09/05/2019 --->
<!--- FECHA ÚLTIMA MOD.: 12/11/2019 --->
<!--- AGREGA LOS ESTÍMULOS QUE SE VERÁN EN LA SESIÓN VIGENTE --->

	<div class="alert alert-success">
		<div class="form-group">
			<cfoutput>
				<label class="col-sm-2 control-label" for="usr">Agregar acad&eacute;mico:</label>
                <div class="col-xs-8" style="margin-top:-7px;">
					<input type="text" name="vAcadNom" id="vAcadNom" class="form-control input-sm"><!---  onKeyUp="fTeclasBS();" --->
					<div id="lstAcad_dynamic" style="position:absolute;display:block; width:97%; z-index:100;"><!--- Ajax para listar el filtro ---></div>
					<input  type="#vTipoInput#"name="vSelAcad" id="vSelAcad" value="" onkeypress="fAgregaAcdEst();">
					<input type="#vTipoInput#" id="vUrlSelAcad" name="vUrlSelAcad" value="#vAjaxListaAcademicos#"><!--- #vCarpetaRaizLogicaSistema#/comun/seleccion_academico.cfm--->
                    <!--- INCLUDE ADICIONAL PARA LA BÚSQUEDA DE ACADÉMICOS (FECHA INCORPORA 12/11/2019) --->
                    <cfset vTipobusquedaValor = 'SelAcdDgapa'>
                    <cfinclude template="#vCarpetaCOMUN#/lista_academicos_teclas_contol.cfm"></cfinclude>
                </div>
				<div class="col-xs-2" style="margin-top:-8px;">
					<div id="agrega_acdest_dynamic"><!-- Una vez seleccionado el académico se activa el botón para abrir el MODAL que incluye el formulario  --></div>
				</div>
			</cfoutput>
		</div>
	</div>
    <!--- JAVA SCRIPT COMÚN PARA REALIZAR BÚSQUEDAD DE ACADÉMICOS (FECHA INCORPORA 12/11/2019) --->
    <cfoutput>
        <script type="text/javascript" src="#vCarpetaRaizLogicaSistema#/comun/java_script/ajax_lista_academicos_teclas.js"></script>
    </cfoutput>
