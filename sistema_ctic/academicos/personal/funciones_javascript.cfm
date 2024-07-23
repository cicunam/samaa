		<script language="JavaScript" type="text/JavaScript">
			<!-- AJAX QUE PERMITE VERIFICAR SI EL NÚMERO DE PLAZA ES CORRECTO -->
			function VerificaNoPlaza()
			{
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// FunciÃ³n de atenciÃ³n a las peticiÃ³n HTTP:
				//alert(document.getElementById('plaza_numero').value.length)
				if (document.getElementById('no_plaza').value.length == 8)
				{
					xmlHttp.onreadystatechange = function(){
						if (xmlHttp.readyState == 4) {
							document.getElementById('verifica_plaza_dynamic').innerHTML = xmlHttp.responseText;
							//if 	(document.getElementById('hidPlazaNumero').value == '1')
							//	{
							//		document.getElementById('plaza_numero').focus()
							//	}
						}
					}
					// Generar una peticiÃ³n HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
					xmlHttp.open("POST", "/comun_cic/ajax/codigo_verificador.cfm", true);
					xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
					// Crear la lista de parÃ¡metros:
					parametros = "vpNoPlaza=" + encodeURIComponent(document.getElementById('no_plaza').value);
					// Enviar la peticiÃ³n HTTP:
					xmlHttp.send(parametros);
				}
				else if (document.getElementById('no_plaza').value.length == 0)
				{
					// alert('EL NÚMERO DE PLAZA ES INCORRECTO')
					document.getElementById('verifica_plaza_dynamic').innerHTML = '';
				}
				else
				{
					alert('EL NÚMERO DE PLAZA ES INCORRECTO')
					document.getElementById('verifica_plaza_dynamic').innerHTML = '';
				}
			}

			<!-- AJAX QUE PERMITE CALCULAR LA ANTIGÜEDAD ACADÉMICO - CREADO: 27/09/2012-->
			function fCalulaAntigAcadCcn()
			{
				//if (document.getElementById('antigCcn_dynamic'))
					if (document.getElementById('con_clave').value >= 1 && document.getElementById('con_clave').value <= 3)
					{
						// Crear un objeto XmlHttpRequest:
						var xmlHttp = XmlHttpRequest();
						// Función de atención a las petición HTTP:
						xmlHttp.onreadystatechange = function(){
							if (xmlHttp.readyState == 4) {
								document.getElementById('antigCcn_dynamic').innerHTML = xmlHttp.responseText;
							}
						}
						// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
						xmlHttp.open("POST", "../../comun/calcula_antiguedad_ccn.cfm", true);
						xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
						// Crear la lista de parámetros:
						parametros = "vIdAcad=" + encodeURIComponent(<cfoutput>#vAcadId#</cfoutput>);
						parametros += "&vTipoSolicitudAntigCnn=N";
						parametros += "&vSolId=0";
						//parametros += "&vTipoReturn=Texto";
						xmlHttp.send(parametros);
					}
			}
			<!-- AJAX QUE SACA DE LA BASE DEL SNI DATOS DEL ACADÉMICO EN EL SNI - CREADO: 18/10/2013-->
			function fSni()
			{
				if (document.getElementById('sni_dynamic'))
				{
					if (document.getElementById('sni_exp').value > 0 && document.getElementById('activo').checked == true)
					{
						// Crear un objeto XmlHttpRequest:
						var xmlHttp = XmlHttpRequest();
						// Función de atención a las petición HTTP:
						xmlHttp.onreadystatechange = function(){
							if (xmlHttp.readyState == 4) {
								document.getElementById('sni_dynamic').innerHTML = xmlHttp.responseText;
							}
						}
						// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
						xmlHttp.open("POST", "../../comun/academico_sni.cfm", true);
						xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
						// Crear la lista de parámetros:
						parametros = "vExpSni=" + encodeURIComponent(document.getElementById('sni_exp_datos').value);
						xmlHttp.send(parametros);
					}
				}
			}
			<!-- HACE VISIBLE O INVISIBLE EL TR DE NOMBRAMIENTO --->
			function fNombramiento() 	
			{
				if (document.getElementById('con_clave').value >= 1 && document.getElementById('con_clave').value <= 4)
				{
					document.getElementById('trNombramiento').style.display = '';
				}
				else
				{
					document.getElementById('trNombramiento').style.display = 'none';
				}
			}
			<!-- HACE VISIBLE O INVISIBLE EL TR DE FECHA DE NOMBRAMIENTO --->
			function fFechaNombramiento() 	
			{
				if (document.getElementById('con_clave').value >= 1 && document.getElementById('con_clave').value <= 4)
				{
					document.getElementById('trFechaNombramiento').style.display = '';
				}
				else
				{
					document.getElementById('trFechaNombramiento').style.display = 'none';
				}
			}
			<!-- HACE VISIBLE O INVISIBLE EL TR DE FECHA DE DEFINITIVIDAD --->
			function fFechaDefinitividad() 	
			{
				if (document.getElementById('con_clave').value == 1)
				{
					document.getElementById('trFechaDefinitividad').style.display = '';
				}
				else
				{
					document.getElementById('trFechaDefinitividad').style.display = 'none';
				}
			}
			<!-- HACE VISIBLE O INVISIBLE EL TR DE FECHA DE INGRESO --->
			function fFechaIngreso()
			{
				if (document.getElementById('con_clave').value >= 1 && document.getElementById('con_clave').value <= 5)
				{
					document.getElementById('trFechaIngreso').style.display = '';
				}
				else
				{
					document.getElementById('trFechaIngreso').style.display = 'none';
				}
			}
			<!-- HACE VISIBLE O INVISIBLE EL TR DE NÚMERO DE PLAZA --->
			function fNoEmpleado()
			{
				if (document.getElementById('con_clave').value >= 1 && document.getElementById('con_clave').value <= 4)
				{
					document.getElementById('trNoEmpleado').style.display = '';
				}
				else
				{
					document.getElementById('trNoEmpleado').style.display = 'none';
				}
			}
			<!-- HACE VISIBLE O INVISIBLE EL TR DE NÚMERO DE PLAZA --->
			function fNoPlaza()
			{
				if (document.getElementById('con_clave').value >= 1 && document.getElementById('con_clave').value <= 4)
				{
					document.getElementById('trPlaza').style.display = '';
				}
				else
				{
					document.getElementById('trPlaza').style.display = 'none';
				}
			}			
			//	Funciones para validar (estas funciones se encuentran al final del código:
	        function fValidaCampos()
	        {
	            var vOk;
	            var vMensaje = '';
	    
	            //vMensaje = fValidaNombre();
	            //vMensaje += fValidaSexo();
	            //vMensaje += fValidaNoNulo('dep_clave', 'DEPENDENCIA');
	            //vMensaje += fValidaRfc();
	            //vMensaje += fValidaNoNulo('acd_prefijo', 'GRADO ACADEMICO');
	            //vMensaje += fValidaNoNulo('pais_clave', 'PAÍS DE NACIMIENTO');
				if (document.getElementById('no_plaza_valida'))
				{
					if (document.getElementById('no_plaza_valida').value == '1') vMensaje += 'EL NÚMERO DE PLAZA NO ES VÁLIDO\n';
				}
	            //vMensaje += fValidaNoNulo('nacion', 'NACIONALIDAD');
	            if (vMensaje.length > 0) 
	                {
	                    alert(vMensaje);
	                    return false;
	                }
	            else
	                {
	                    document.forms['frmAcademicos'].submit();
	                }
	        }
			// ...		    
			function fBloquearRegistro(vAccion)
			{
				document.getElementById('acd_rfc').disabled = vAccion;
				document.getElementById('acd_curp').disabled = vAccion;
				document.getElementById('acd_apepat').disabled = vAccion;
				document.getElementById('acd_apemat').disabled = vAccion;
				document.getElementById('acd_nombres').disabled = vAccion;
				document.getElementById('acd_fecha_nac').disabled = vAccion;
				if (document.getElementById('acd_prefijo')) document.getElementById('acd_prefijo').disabled = vAccion;
				document.getElementById('acd_sexo_F').disabled = vAccion;
				document.getElementById('acd_sexo_M').disabled = vAccion;
				document.getElementById('grado_clave').disabled = vAccion;
				document.getElementById('pais_clave').disabled = vAccion;
				if (document.getElementById('pais_clave').value == 'MEX') fJQListaEstados('<cfoutput>#tbAcademico.inegi_edo_nac_clave#</cfoutput>', 'INEGI'); //document.getElementById('edo_clave').disabled = vAccion;
				document.getElementById('pais_clave_nacimiento').disabled = vAccion;
				document.getElementById('acd_email').disabled = vAccion;
				document.getElementById('acd_memo').disabled = vAccion;
				document.getElementById('dep_clave').disabled = vAccion;
				//document.getElementById('dep_ubicacion').disabled = vAccion;
				document.getElementById('con_clave').disabled = vAccion;
				if (document.getElementById('con_clave').value >= 1 && document.getElementById('con_clave').value <= 3)
				{
					document.getElementById('cn_clave').disabled = vAccion;
					document.getElementById('fecha_cn').disabled = vAccion;
					if (document.getElementById('fecha_def')) document.getElementById('fecha_def').disabled = vAccion;
				}
				document.getElementById('fecha_pc').disabled = vAccion;
				document.getElementById('num_emp').disabled = vAccion;
				document.getElementById('no_plaza').disabled = vAccion;
				document.getElementById('sni_exp').disabled = vAccion;
				document.getElementById('migracion_clave_rt').disabled = vAccion;
				document.getElementById('migracion_clave_rp').disabled = vAccion;				
				//document.getElementById('migracion_clave_Io').disabled = vAccion;
				//document.getElementById('migracion_clave_Ie').disabled = vAccion;
				document.getElementById('no_expediente').disabled = vAccion;
				document.getElementById('activo').disabled = vAccion;
				if (document.getElementById('baja_clave')) document.getElementById('baja_clave').disabled = vAccion;
				if (vAccion == false)
				{
					document.getElementById('CmdEdita').style.display = "none";
					document.getElementById('CmdElimina').style.display = "none";
					document.getElementById('CmdImprime').style.display = "none";
					document.getElementById('CmdGuarda').style.display = "";
					document.getElementById('CmdCancela').style.display = "";
					document.getElementById('CmdRegresa').style.display = "none";
				}
				else
				{
					document.getElementById('CmdEdita').style.display = "";
					document.getElementById('CmdElimina').style.display = "";
					document.getElementById('CmdImprime').style.display = "";
					document.getElementById('CmdGuarda').style.display = "none";
					document.getElementById('CmdCancela').style.display = "none";
					document.getElementById('CmdRegresa').style.display = "";
				}
				 fJQObtenerUbicacion();
			}
	    	//	Deshabilita el tipo de calidad migratoria:
	        function fActualizaMigratoria()
	        {
	            if (document.getElementById('pais_clave').value == 'MEX' || document.getElementById('pais_clave').value == '')
	            {
	                document.getElementById('migratoria_dynamic').style.display = 'none';
	                document.getElementById('migratoria_dynamic').disabled = 'disabled';
					document.getElementById('tr_entidad_nac').style.display = '' 
					//fJQListaEstados('<cfoutput>#tbAcademico.inegi_edo_nac_clave#</cfoutput>', 'INEGI');
	            }
	            else
	            {
	                document.getElementById('migratoria_dynamic').style.display = '';
	                document.getElementById('migratoria_dynamic').disabled = '';
					document.getElementById('tr_entidad_nac').style.display = 'none'
	            }
	        }
	        //	Deshabilita el motivo de la baja:
	        function fActualizaBaja()
	        {
	        	if(document.getElementById('activo').checked) 
	        	{
	        		document.getElementById('baja_dynamic').style.display = 'none'; 
	        	}
	        	else 
	        	{
	        		document.getElementById('baja_dynamic').style.display = '';
	        	}	
	        }
			// Eliminar un académico de la base de datos (¿Se permitirá esto?):
			function fEliminarRegistro()
			{
				if (confirm('¿En realidad desea eliminar permanentemente de la base de datos el registro seleccionado, y todos los registros relacionados?'))
				{
					window.location = 'academico_personal_elimina.cfm?vAcadId=' + $('#vAcadId').val();
//					document.forms[0].action = 'academico_personal_elimina.cfm';
//					document.forms[0].submit();
				}
			}
		</script>