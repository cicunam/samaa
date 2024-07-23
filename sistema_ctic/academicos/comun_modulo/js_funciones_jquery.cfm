<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 02/02/2017 --->
<!--- FECHA ULTIMA MOD.: 02/02/2017 --->


		<!--- ******* JQUERY ******* --->
		<script language="JavaScript" type="text/JavaScript">
			// DESPLIEGA LAS UBICACIONES DE LAS ENTIDADES
			function fJQObtenerUbicacion()
			{
				var parametrosOU = 
				{
					"vDepClave" : $("#dep_clave").val()
					,
					"vUbicaClave" : $("#vUbicaClave").val()
					,
					"vHabilitaDes" : $("#dep_clave").prop("disabled")
					,
					"vTipoConsulta" : "T"
				};
				//alert($("#dep_clave").prop("disabled"));
		        $.ajax({
		                data:  parametrosOU,
		                url:   '<cfoutput>#vCarpetaRaizLogica#</cfoutput>/sistema_ctic/comun/entidad_ubicacion.cfm',
		                type:  'post',
		                beforeSend: function () {
							$("#adscripcion_dynamic").html("Procesando, espere por favor...");
		                },
		                success:  function (response) {
							$("#adscripcion_dynamic").html(response);
		                }
		        });
			}
			// DESPLIEGA LOS PREFIJOS DE GRADO ACADÉMICO
			function fJQListaPrefijos(vPrefijo)
			{
				var parametrosLP = 
				{
					"vGrado" : $("#grado_clave").val()
					,
					"vPrefijo" : vPrefijo
					,
					"vHabilitaDes" : $("#grado_clave").prop("disabled")
				};
				
		        $.ajax({
		                data:  parametrosLP,
		                url:   '<cfoutput>#vCarpetaRaizLogica#</cfoutput>/sistema_ctic/comun/seleccion_prefijos_grado.cfm',
		                type:  'post',
		                beforeSend: function () {
							$("#prefijo_dynamic").html("Procesando, espere por favor...");
		                },
		                success:  function (response) {
							$("#prefijo_dynamic").html(response);
		                }
		        });				
			}
			// DESPLIEGA ESTADOS DE LA REPÚBLICA MEXICANA
			function fJQListaEstados(vEdoClave, vTipoClaveEdo)
			{
				var parametrosLE = 
				{
					"vEdoClave" : vEdoClave
					,
					"vTipoClaveEdo" : vTipoClaveEdo
					,
					"vHabilitaDes" : $("#pais_clave").prop("disabled")
				};
		        $.ajax({
		                data:  parametrosLE,
		                url:   '<cfoutput>#vCarpetaRaizLogica#</cfoutput>/sistema_ctic/comun/seleccion_estados_mexico.cfm',
		                type:  'post',
		                beforeSend: function () {
							$("#edonacimiento_dynamic").html("Procesando, espere por favor...");
		                },
		                success: function (response) {
							$("#edonacimiento_dynamic").html(response);
		                },
						error: function () {
							$("#edonacimiento_dynamic").html("<span class='Arial10rojaN'>Hubo un error al realizar el proceso...</span>");
						}
		        });
			}
		</script>