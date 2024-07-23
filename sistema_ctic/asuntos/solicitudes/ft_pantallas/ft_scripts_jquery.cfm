<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 17/06/2016 --->
<!--- FECHA ÚLTIMA MOD.: 09/05/2024 --->

<!--- Funciones jQuery utilizadas por las FT --->

			<cfoutput>
                <script type="text/javascript" src="#vCarpetaLIB#/jquery-1.5.1.min.js"></script>
                <script type="text/javascript" src="#vCarpetaLIB#/jquery-ui-1.8.12.custom.min.js"></script>
                <script type="text/javascript" src="#vCarpetaLIB#/jquery.activity-indicator-1.0.0.min.js"></script>
            </cfoutput>


		<script type="text/javascript" language="JavaScript">
			// AJAX para actualizar la CCN 03/10/2019
			function fActualizaCcn()
			{
				//document.getElementById("loader").style.display = "block";
				//alert('ASIGNA SESION');
				$.ajax({
					//async: false,
					method: "POST",
					data: {vSolId:$("#vIdSol").val(),vAcadId:$("#vIdAcad").val()}, //,vTipoSolicitudAntigCnn:"A"
					url: "<cfoutput>#vCarpetaCOMUN#</cfoutput>/actualiza_ccn.cfm",
					success: function(data) {
						location.reload();
						//alert(data);
					},
					error: function(data) {
						alert('ERROR AL ACTUALIZAR LA CATEGORÍA EN CCN');
						//alert(data);
					}
				});
			}

			// AJAX para actualizar la antiguendad en CCN 
			function fActualizaAntigCcn()
			{
				//document.getElementById("loader").style.display = "block";
				//alert('ASIGNA SESION');
				$.ajax({
					//async: false,
					method: "POST",
					data: {vSolId:$("#vIdSol").val(),vIdAcad:$("#vIdAcad").val(),vTipoSolicitudAntigCnn:"A"},
					url: "<cfoutput>#vCarpetaCOMUN#</cfoutput>/calcula_antiguedad_ccn.cfm",
					success: function(data) {
						location.reload();
						//alert(data);
					},
					error: function(data) {
						alert('ERROR AL ACTUALIZAR LA CATEGORÍA EN CCN');
						//alert(data);						
					}
				});
			}

			// AJAX para actualizar la antiguendad en CCN 
			function fActualizaAntigAcad()
			{
				//document.getElementById("loader").style.display = "block";
				//alert('ASIGNA SESION');
				$.ajax({
					//async: false,
					method: "POST",
					data: {vSolId:$("#vIdSol").val(),vIdAcad:$("#vIdAcad").val(),vTipoSolicitudAntig:"A"},
					url: "<cfoutput>#vCarpetaCOMUN#</cfoutput>/calcula_antiguedad.cfm",
					success: function(data) {
						location.reload();
						//alert(data);
					},
					error: function(data) {
						alert('ERROR AL ACTUALIZAR LA CATEGORÍA EN CCN');
						//alert(data);						
					}
				});
			}

			// AJAX para actualizar las fechas de 1er. contrato o Fecha en CCN
			function fActualizaFecha(vTipoFecha)
			{
				//document.getElementById("loader").style.display = "block";
				//alert('ASIGNA SESION');
				$.ajax({
					//async: false,
					method: "POST",
					data: {vSolId:$("#vIdSol").val(),vAcadId:$("#vIdAcad").val(),vTipoFecha:vTipoFecha},
					url: "<cfoutput>#vCarpetaCOMUN#</cfoutput>/actualiza_fechas_ft.cfm",
					success: function(data) {
						location.reload();
						//alert(data);
					},
					error: function(data) {
						alert('ERROR AL ACTUALIZAR LA FECHA');
						//alert(data);
					}
				});				
			}
        </script>

		<script type="text/javascript" language="JavaScript">
            /* CREADO: JOSE ANTONIO ESTEVA */
            /* EDITO: JOSE ANTONIO ESTEVA */
            /* FECHA: 28/10/2010 */
                
            // Ventana de dialogo para mostrar la lista de movimientos:
            $(function() {
                $('#dialog:ui-dialog').dialog('destroy');
                $('#ListaMovimientos_jQuery').dialog({
                    autoOpen: false,
                    height: 500,
                    width: 700,
                    show: 'slow',
                    modal: true,
                    title: 'HISTORIA DE MOVIMIENTOS',			
                    open: function() {
                        $(this).load('<cfoutput>#vCarpetaRaizLogica#</cfoutput>/sistema_ctic/movimientos/consultas/movimientos_academico_emergente.cfm',
                        {
                            vIdAcad:$('#vIdAcad').val(),
                            vPagina:('1'),
                            vRPP:('25'),
                            vOrden:('mov_fecha_inicio'),
                            vOrdenDir:('DESC')
                        });
        //	        	fListarMovimientos(1,'mov_fecha_inicio','DESC');
                    }
                });
                $('#cmdMovHistoria').click(function(){
                    $('#ListaMovimientos_jQuery').dialog('open');
                });		
            });
        
            // Ventana de dialogo para mostrar los requisitos de la FT:
            $(function() {
                $('#dialog:ui-dialog').dialog('destroy');
                $('#ListaDocumentosAnexos_jQuery').dialog({
                    autoOpen: false,
                    height: 400,
                    width: 600,
                    show: 'slow',
                    modal: true,
                    title: 'DOCUMENTOS NECESARIOS PARA EL TRÁMITE DE LOS ASUNTOS ACADÉMICO-ADMINISTRATIVO',
                    open: function() {
                        $(this).load('ft_doc_art.cfm', 
                        {
                            vFt:$('#vFt').val()
                        });
                    }
                });
                $('#cmdDocsAnexos').click(function(){
                    $('#ListaDocumentosAnexos_jQuery').dialog('open');
                });
            });	   		
        </script>
            
		<!-- JQUERY uso exclusito FT-CTIC-5, FT-CTIC-15 Y FT-CTIC-17 -->
		<cfif #vFt# EQ 5 OR #vFt# EQ 15 OR #vFt# EQ 17>
			<script language="JavaScript" type="text/JavaScript">
                // Ventana del diálogo (jQuery) para AGREGAR OPONENTE QUE NO EXITE EN LA TABLA DE ACADÉMICOS
                $(function() {
                    $('#dialog:ui-dialog').dialog('destroy');
                    $('#nuevooponente_jquery').dialog({
                        autoOpen: false,
                        height: 300,
                        width: 500,
                        modal: true,
                        maxHeight: 320,
                        maxWidth: 520,
                        title: 'AGREGAR NUEVO OPONENTE NO REGISTRADO',
                        open: function() {
                            $(this).load('ft_ajax/agregar_nuevo_oponente_coa.cfm',	
							{
								vConvocatoria:$('#pos23').val(),
								vIdSol:$('#vIdSol').val(),								
								vFt:$('#vFt').val()
							});
                        }
                    });
                });
            </script>
		</cfif>
        
		<!-- JQUERY uso exclusito FT-CTIC-2, FT-CTIC-21, FT-CTIC-23, FT-CTIC-30 Y FT-CTIC-32 -->
		<cfif #vFt# EQ 2 OR #vFt# EQ 21 OR #vFt# EQ 23 OR #vFt# EQ 30 OR #vFt# EQ 32>
			<script language="JavaScript" type="text/JavaScript">
                // Ventana del diálogo (jQuery) para AGREGAR OPONENTE QUE NO EXITE EN LA TABLA DE ACADÉMICOS
                $(function() {
                    $('#dialog:ui-dialog').dialog('destroy');
                    $('#formularioDestino_jquery').dialog({
                        autoOpen: false,
                        height: 180,
                        width: 500,
                        modal: true,
                        maxHeight: 200,
                        maxWidth: 520,
                        title: 'AGREGAR NUEVO DESTINO A LA SOLICITUD',
                        open: function() {
                            $(this).load('ft_ajax/agregar_nuevo_destino.cfm',	
							{
								vIdAcad:$('#vIdAcad').val(),
								vIdSol:$('#vIdSol').val(),
								vFt:$('#vFt').val()
							});
                        }
                    });
					$('#cmdFormularioDestino').click(function(){
						$('#formularioDestino_jquery').dialog('open');
					});
                });
            </script>
		</cfif>
		<!-- JQUERY uso exclusito FT-CTIC-41, Calcula la antigüedad mínima requerida para una licencia con goce de sueldo 27/05/2024 -->
		<cfif #vFt# EQ 41>
			<script language="JavaScript" type="text/JavaScript">
				function fAniosMinimos()
				{
					//alert('Antigüedad mínima');
					$.ajax({
						//async: false,
						method: "POST",
						data: {vAcadId:$("#pos2").val(),vSolFechaInicio:$("#pos14").val()},
						url: "ft_ajax/antiguedad_minima.cfm",
						success: function(data) {
							$('#aniguedad_minima_dynamic').html(data);
							//location.reload();
							//alert(data);
						},
						error: function(data) {
							alert('ERROR AL CALCULAR LA ANTIGUEDAD MÍNIMA');
							//alert(data);
						}
					});
				}
            </script>			
		</cfif>