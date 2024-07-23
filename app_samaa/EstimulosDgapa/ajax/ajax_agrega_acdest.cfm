<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 27/05/2019 --->
<!--- FECHA ÚLTIMA MOD.: 27/05/2019 --->
<!--- ESTE MODAL SE EJECUTA UNA VEZ SELECCIONADO AL ACADÉMICO  --->
				
				<a id="aNuevoAcd" href="academico_estimulo.cfm?vEstimuloId=0&amp;vTipoComando=NV&amp;vSsnId=<cfoutput>#vpSsnId#&vAcdId=#vpAcdId#</cfoutput>" data-toggle="modal" data-target="#divNuevoAcdEst">
					<button id="cmdAgregaAcd" type="button" class="btn btn-success btn-md">
                    	<span class="glyphicon glyphicon-plus"></span> AGREGAR
					</button>
				</a>
                <div id="divNuevoAcdEst" class="modal fade" role="dialog">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <!-- Contenido del formulario para agregar estímulo -->
                        </div>
                    </div>
                </div>