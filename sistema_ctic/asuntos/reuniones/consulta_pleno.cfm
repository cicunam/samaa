<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 22/10/2009 --->
<!--- FECHA ÚLTIMA MOD: 13/09/2022 --->

<!--- ESTE PARÁMETRO SE UTILIZA EN CASO DE QUE LAS VARIABLE DE SESIÓN DEL MÓDULO NO ESTEN DEFINIDAS PARA LAS BÚSQUEDES --->
<cfparam name="vpSolIdBusqueda" default="">
<cfparam name="vpSsnIdBusqueda" default="#Session.sSesion#">

<!--- Registrar la ruta del módulo actual --->
<cfset Session.sModulo = '#CGI.SCRIPT_NAME#'>
<!--- Crear un arreglo para guardar la información del filtro --->
<cfif NOT IsDefined('Session.AsuntosCTICFiltro')>
	<!--- Crear un arreglo para guardar la información del filtro --->
	<cfscript>
		AsuntosCTICFiltro = StructNew();
		AsuntosCTICFiltro.vFt = 0;
		AsuntosCTICFiltro.vActa = '#vpSsnIdBusqueda#';
		AsuntosCTICFiltro.vSeccion = '';
		AsuntosCTICFiltro.vDepId = '';
		AsuntosCTICFiltro.vAcadNom = '';
		AsuntosCTICFiltro.vNumSol = #vpSolIdBusqueda#;
		AsuntosCTICFiltro.vPagina = '1';
		AsuntosCTICFiltro.vRPP = '25';
		AsuntosCTICFiltro.vMarcadas = ArrayNew(1);
	</cfscript>
	<cfset Session.AsuntosCTICFiltro = '#AsuntosCTICFiltro#'>
</cfif>
<!--- Obtener la lista de movimientos disponibles (CATÁLOGOS LOCAL SAMAA) --->
<cfquery name="ctMovimiento" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_movimiento 
    WHERE mov_status = 1 ORDER BY mov_orden
</cfquery>

<!--- Obtener la lista de dependencias del SIC (CATÁLOGOS GENERALES MYSQL) --->
<cfquery name="ctDependencia" datasource="#vOrigenDatosCATALOGOS#">
	SELECT dep_clave, dep_siglas
    FROM catalogo_dependencias
    WHERE dep_clave LIKE '03%' 
    AND dep_tipo <> 'PRO'
    AND dep_status = 1
    ORDER BY dep_tipo, dep_siglas
</cfquery>

<!--- Obtener el listado de sesiones donde existen solicitudes que no se ha generado movimiento --->
<cfquery name="ctSesionesVencidas" datasource="#vOrigenDatosSAMAA#">
    SELECT ssn_id FROM consulta_solicitudes_pleno
    WHERE ssn_id_post = 0
	AND sol_status <= 1
    AND sol_retirada IS NULL <!--- SE AGREGÓ PARA ELIMINAR SOLICITUDES RETIRADAS (01/02/2022) --->
    GROUP BY ssn_id
    ORDER BY ssn_id DESC
</cfquery>

<html>
	<head>
		<title>STCTIC - Asuntos Acad&eacute;mico-Administrativos</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<cfoutput>
			<link href="#vCarpetaCSS#/formularios.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/general.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/fuentes.css" rel="stylesheet" type="text/css">
			<script type="text/javascript" src="#vHttpWebGlobal#/xmlHttpRequest.js"></script>
		</cfoutput>

		<!--- LLAMADO A CÓDIGO DE JAVA SCRIPT COMÚN O GLOBAL --->
		<script type="text/javascript" src="../../comun/java_script/mascara_entrada.js"></script>

		<!--- JAVA SCRIPT USO LOCAL --->
		<script language="JavaScript" type="text/JavaScript">
			// Variables que indican que tipo de solicitudes han sido seleccionadas (no es muy buena solución pero funciona):
			var vSeleccionLYC = false;
			var vSeleccionOtras = false;
			// Listar las asuntos que pasan al pleno:
			function fListarSolicitudes(vPagina, vOrden, vOrdenDir)<!-- LAS ÚLTIMAS DOS VARIABLES NO SE OCUPAN, ES PARA HOMOLOGAR EL CÓDIGO Y USAR UN SOLO SELECT DE FT'S EN TODO EL SISTEMA -->
			{
				// Icono de espera:
				document.getElementById('solicitudes_dynamic').innerHTML = "<img src=\"<cfoutput>#vCarpetaIMG#</cfoutput>/wait.gif\" style=\"display:block; margin:auto;\">";
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Función de atención a las petición HTTP:
				xmlHttp.onreadystatechange = function(){
					if (xmlHttp.readyState == 4) {
						// Actualizar la lista de asuntos:
						document.getElementById('solicitudes_dynamic').innerHTML = xmlHttp.responseText;
						// Actualizar el contador de registros:
						document.getElementById('vRegRan_dynamic').innerHTML = document.getElementById('vRegRan').value;
						document.getElementById('vRegTot_dynamic').innerHTML = document.getElementById('vRegTot').value;
						// Actualizar el texto del filtro:
						if (document.getElementById('vFt').value == 0) document.getElementById('vFiltroActual').innerHTML = 'Todas las solicitudes';
						else document.getElementById('vFiltroActual').innerHTML = 'FT-CTIC-' + document.getElementById('vFt').value;
						fActivaBotones();
						fRegistraMovBCmd();
					}
				}
				// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones
				xmlHttp.open("POST", "asuntos_pleno.cfm", true);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "vFt=" + encodeURIComponent(document.getElementById('vFt').value);
				parametros += "&vActa=" + encodeURIComponent(document.getElementById('vActa').value);
				parametros += "&vSeccion=" + encodeURIComponent(document.getElementById('vSeccion').value);
				parametros += "&vDepId=" + encodeURIComponent(document.getElementById('vDepId').value);
				parametros += "&vAcadNom=" + encodeURIComponent(document.getElementById('vAcadNom').value);
				parametros += "&vNumSol=" + encodeURIComponent(document.getElementById('vNumSol').value);
				parametros += "&vPagina=" + encodeURIComponent(vPagina);
				parametros += "&vRPP=" + encodeURIComponent(document.getElementById('vRPP').value);
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);
				// Actualizar el cintillo:
				document.getElementById('txtActa').innerHTML = 'SESI&Oacute;N ' + document.getElementById('vActa').value;
			}
			// Seleccionar/Deseleccionar una o todas las solicitudes:
			function fSeleccionarRegistro(vIdSol, vTipo, vValor)
			{
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Generar una petición HTTP:
				xmlHttp.open("POST", "seleccionar_asunto.cfm", false);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "vIdSol=" + encodeURIComponent(vIdSol);
				parametros += "&vTipo=" + encodeURIComponent(vTipo);
				parametros += vValor == true ? "&vValor=TRUE": "&vValor=FALSE";
				// Pasar también los demás campos para seleccionar solo las solicitudes filtradas:
				parametros += "&vFt=" + encodeURIComponent(document.getElementById('vFt').value);
				parametros += "&vActa=" + encodeURIComponent(document.getElementById('vActa').value);
				parametros += "&vSeccion=" + encodeURIComponent(document.getElementById('vSeccion').value);
				parametros += "&vDepId=" + encodeURIComponent(document.getElementById('vDepId').value);
				parametros += "&vAcadNom=" + encodeURIComponent(document.getElementById('vAcadNom').value);
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);
				// Determinar si hay seleccionados asuntos:
				if (xmlHttp.responseText.indexOf('SELECCION-OTRAS') != -1) vSeleccionOtras = true;
				else vSeleccionOtras = false;
				// Determinar si hay seleccionados asuntos:
				if (xmlHttp.responseText.indexOf('SELECCION-LYC') != -1) vSeleccionLYC = true;
				else vSeleccionLYC = false;
				fContadorRegSel();
				//alert(vSeleccionOtras);
				//alert(vSeleccionLYC);
				// document.getElementById('hiddRegMarcados').value = <cfoutput>#ArrayLen(Session.AsuntosCTICFiltro.vMarcadas)#</cfoutput>;				
			}

			// Seleccionar/Deseleccionar una o todas las solicitudes:
			function fBuscarMarcadas()
			{
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Generar una petición HTTP:
				xmlHttp.open("POST", "seleccionar_asunto.cfm", false);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "vTipo=1";
				parametros += "&vValor=CONSULTA";
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);
				// Determinar si hay seleccionados asuntos:
				if (xmlHttp.responseText.indexOf('SELECCION-OTRAS') != -1) vSeleccionOtras = true;
				else vSeleccionOtras = false;
				// Determinar si hay seleccionados asuntos:
				if (xmlHttp.responseText.indexOf('SELECCION-LYC') != -1) vSeleccionLYC = true;
				else vSeleccionLYC = false;
			}

			// Marcar todas las solicitudes:
			function fMarcarTodas(vValor)
			{
				// Marcar todas las solicitudes en la BD:
				fSeleccionarRegistro('TODAS', 1, vValor);
				// Actualizar la lista:
				fListarSolicitudes(1);
				fContadorRegSel();
			}
			
			// AJAX para enviar datos de variable de sesión con el conteo de registros marcados sin necesidad de refrescar todo el sitio 
			function fContadorRegSel()
			{
				var xmlHttp = XmlHttpRequest();
				// Función de atención a las petición HTTP:
				xmlHttp.onreadystatechange = function(){
					if (xmlHttp.readyState == 4) {
						// Actualizar la lista de asuntos:
						document.getElementById('reg_seleccionados_dynamic').innerHTML = xmlHttp.responseText;

						//Verifica que haya registros seleccionados y que esté habilitado los botones
						//alert(document.getElementById('hiddRegMarcados').value);
						if (document.getElementById('hiddRegMarcados').value > 0)
						{ 
							if (document.getElementById('cmdImp2') && document.getElementById('cmdImp2').atributo == 'ODGAPA')
							{
								document.getElementById('cmdImp2').disabled = false;
							}
							if (document.getElementById('cmdImp1').style.display == '')
							{
								document.getElementById('cmdImp1').disabled = false;
							}
						}
						if (document.getElementById('hiddRegMarcados').value == 0)
						{
							if(document.getElementById('cmdImp1').style.display == '')
							{
								document.getElementById('cmdImp1').disabled = true;
							}
							if (document.getElementById('cmdImp2').style.display == '' && document.getElementById('cmdImp2').atributo == 'ODGAPA') 
							{
								document.getElementById('cmdImp2').disabled = true;
							}
						}
					}
				}
				// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones
				xmlHttp.open("POST", "ajax_registros_seleccion.cfm", true);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "vSubmenuActivo=1";
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);
			}


			// Indexar todos los asuntos:
			function fIndexarAsuntos()
			{
				//if (confirm("Esta operación respetará las asignaciones de sección que haya realizado manualmente. Sin embargo, sobrescribirá los cambios que haya realizado en la numeración de los asuntos. ¿Desea continuar?"))
				//{
					// Icono de espera:
					document.getElementById('solicitudes_dynamic').innerHTML = "<img src=\"<cfoutput>#vCarpetaIMG#</cfoutput>/wait.gif\" style=\"display:block; margin:auto;\">";
					// Crear un objeto XmlHttpRequest:
					var xmlHttp = XmlHttpRequest();
					// Generar una petición HTTP:
					xmlHttp.open("POST", "indexar_asuntos.cfm", false);
					xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
					// Crear la lista de parámetros:
					parametros = "vpSsnId=" + encodeURIComponent(document.getElementById('vActa').value);
					parametros += "&vReunion=" + encodeURIComponent('CTIC');
					// Enviar la petición HTTP:
					xmlHttp.send(parametros);
					// Actualizar la lista al terminar:
					fListarSolicitudes(1);
				//}
			}

			// Asignar decisión "aprobatoria" a los asuntos seleccionados:
			function fAsignarDecision()
			{
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Generar una petición HTTP:
				xmlHttp.open("POST", "recomendacion_decision.cfm", false);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				parametros = "vIdSol=" + encodeURIComponent('TODAS');
				parametros += "&vActa=" + encodeURIComponent(document.getElementById('vActa').value);
				parametros += "&vReunion=" + encodeURIComponent('CTIC');
				parametros += "&vDecision=" + encodeURIComponent(100); <!-- Aprobar/Ratificar genérico (1,35) --->
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);
				// Desmarcar todas las solicitudes y actualizar la lista:
				fMarcarTodas(false);
			}

			// Mostrar la lista de asuntos en formato PDF:
			function fImprimirListado()
			{

				if (document.getElementById('vSeccionImprimir').value == '5h') // Sección V (horizontal)
				{
					if (document.getElementById('vTipoListado_REC').checked)
					{
						window.open("impresion/listado_ctic_V.cfm?vTipo=REC&vActa=" + document.getElementById('vActa').value, "_blank", "modal=yes,location=no,menubar=no,titlebar=no,width=800,height=600,resizable=yes,scrollbars=yes,status=no");
					}
					else
					{
						window.open("impresion/listado_ctic_V.cfm?vTipo=ACTA&vActa=" + document.getElementById('vActa').value, "_blank", "modal=yes,location=no,menubar=no,titlebar=no,width=800,height=600,resizable=yes,scrollbars=yes,status=no");
					}
				}
				else if (document.getElementById('vSeccionImprimir').value == '5n') // Sección V (destinos nacionales)
				{

					window.open("impresion/listado_ctic_Vn.cfm?vActa=" + document.getElementById('vActa').value, "_blank", "modal=yes,location=no,menubar=no,titlebar=no,width=800,height=600,resizable=yes,scrollbars=yes,status=no");

				}
				else if (document.getElementById('vSeccionImprimir').value == '5i') // Sección V (destinos internacionales)
				{

					window.open("impresion/listado_ctic_Vi.cfm?vActa=" + document.getElementById('vActa').value, "_blank", "modal=yes,location=no,menubar=no,titlebar=no,width=800,height=600,resizable=yes,scrollbars=yes,status=no");

				}
				else // Todas las demás secciones:
				{
					if (document.getElementById('vTipoListado_REC').checked)
					{
						window.open("impresion/listado_ctic.cfm?vTipo=REC&vActa=" + document.getElementById('vActa').value + "&vSeccion=" + document.getElementById('vSeccionImprimir').value, "_blank", "modal=yes,location=no,menubar=no,titlebar=no,width=800,height=600,resizable=yes,scrollbars=yes,status=no");
					}
					else
					{
						window.open("impresion/listado_ctic.cfm?vTipo=ACTA&vActa=" + document.getElementById('vActa').value + "&vSeccion=" + document.getElementById('vSeccionImprimir').value, "_blank", "modal=yes,location=no,menubar=no,titlebar=no,width=800,height=600,resizable=yes,scrollbars=yes,status=no");
					}
				}
			}

			// Asignar números de oficio a asuntos/solicitudes:
			function fGenerarNoOficios(vTipo)
			{
                //alert(vSeleccionLYC);
                //alert(vSeleccionOtras);                
				// Verificar que se haya asignado el número inicial:
				if (isNaN(parseInt(document.getElementById('vNoOficio').value)) || parseInt(document.getElementById('vNoOficio').value) == 0)
				{
					alert('Debe indicar el número de oficio a partir del cual se generarán los oficios de respuesta.');
					return;
				}
				// Verificar que haya seleccionado alguna solicitud:
				else if (!vSeleccionLYC && !vSeleccionOtras && document.getElementById('vAsignaNoOficio').value != 'COAOP')
				{
					alert('Debe seleccionar las solicitudes a las que desea asignar número de oficio.');
					return;
				}
				// Verificar que no se seleccionen LYC al mismo tiempo que otros asuntos:
				else if (vSeleccionLYC && vSeleccionOtras)
				{
					alert('Ha seleccionado licencias y comisiones al mismo tiempo que otros asuntos pero la generación números de oficios de licencias y comisiones debe realizarse de manera separada. Por favor, corrija esta situación.');
					fMarcarTodas(false);
					return;
				}
				// Si hay solicitudes de LYC seleccionadas:
				else if (vSeleccionLYC)
				{
                    //alert('LYC');
					fGenerarNoOficiosAjax('LYC');
				}
				// Si hay solicitudes seleccionadas (distintas a LYC):
				else if (vSeleccionOtras)
				{
                    //alert('OTRAS');                    
					fGenerarNoOficiosAjax(document.getElementById('vAsignaNoOficio').value);
				}
				else if (document.getElementById('vAsignaNoOficio').value == 'COAOP')
				{
                    //alert('COAOP');
					fGenerarNoOficiosAjax(document.getElementById('vAsignaNoOficio').value);
				}
			}

			// Asignar números de oficio:
			function fGenerarNoOficiosAjax(vTipo)
			{
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Generar una petición HTTP:
				xmlHttp.open("POST", "asignar_no_oficio.cfm", true);
				xmlHttp.onreadystatechange = function(){
					if (xmlHttp.readyState == 4) 
                    {
                        if (xmlHttp.responseText.length == 0)
                        {
                            fMarcarTodas(false);
                            document.getElementById('vAsignaNoOficio').value = '';
                            document.getElementById('vNoOficio').value = '';
                            alert('Se asignaron correctamente los números de oficio');
                        }
                        else
                        {
                            //alert(xmlHttp.responseText.length);
                            alert('Se produjo un error al asignar los números de oficios');
                        }
					}
				}                
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				parametros = "vTipo=" + encodeURIComponent(vTipo);
				parametros += "&vActa=" + encodeURIComponent(document.getElementById('vActa').value);
				parametros += "&vNoOficio=" + encodeURIComponent(document.getElementById('vNoOficio').value);                
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);                
/*                
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Generar una petición HTTP:
				xmlHttp.open("POST", "asignar_no_oficio.cfm", false);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				parametros = "vTipo=" + encodeURIComponent(vTipo);
				parametros += "&vActa=" + encodeURIComponent(document.getElementById('vActa').value);
				parametros += "&vNoOficio=" + encodeURIComponent(document.getElementById('vNoOficio').value);                
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);
*/                
			}

			// Imprimir oficios de respuesta (19/09/2017):
			function fActivaBotones()
			{
				//alert(document.getElementById('hiddRegMarcados').value);
				fContadorRegSel();
				if (document.getElementById('vSeccion').value == '')
				{
					document.getElementById('cmdImp1').style.display = 'none';
					document.getElementById('cmdImp2').style.display = 'none';
					if (document.getElementById('vFt').value == 5)
					{
						document.getElementById('cmdImp2').style.display = '';
						document.getElementById('cmdImp2').value = 'Oficios COA oponentes';
						document.getElementById('cmdImp2').atributo = 'COAOP';
						document.getElementById('cmdImp1').style.display = 'none';
					}                    
				}
				else
				{
					document.getElementById('cmdImp1').style.display = '';
					document.getElementById('cmdImp1').value = document.getElementById('vSeccion').options[document.getElementById('vSeccion').selectedIndex].text;
					if (document.getElementById('vSeccion').value == 5)
					{
						document.getElementById('cmdImp2').style.display = '';
						document.getElementById('cmdImp2').value = 'Anexos de Lic. y Com.';
						document.getElementById('cmdImp2').atributo = 'ALyC';
					}
					else if (document.getElementById('vSeccion').value == 3)
					{
						document.getElementById('cmdImp2').style.display = 'none';
						document.getElementById('cmdImp2').value = 'Oficios para DGAPA';
						document.getElementById('cmdImp2').atributo = 'ODGAPA';			
					}
					else if (document.getElementById('vSeccion').value == 1 && document.getElementById('vFt').value == 30)
					{
						document.getElementById('cmdImp2').style.display = '';
						document.getElementById('cmdImp2').value = 'Oficios para la DGAPA';
						document.getElementById('cmdImp2').atributo = 'ODGAPA';
						document.getElementById('cmdImp1').style.display = 'none';
//						if (document.getElementById('hiddRegMarcados').value == 0) document.getElementById('cmdImp2').disabled = 'true';
//						if (document.getElementById('hiddRegMarcados').value > 0)  document.getElementById('cmdImp2').disabled = 'false';
					}
					else
					{
						document.getElementById('cmdImp2').style.display = 'none';
					}
				}
			}

			// Imprimir oficios de respuesta (19/09/2017):
			function fGenerarOficios()
			{
				// Si hay solicitudes seleccionadas (distintas a LYC):
				if (document.getElementById('vSeccion').value != 0 && document.getElementById('vSeccion').value != 5)
				{
					if (document.getElementById('vSeccion').value == 1 && document.getElementById('vFt').value == 30)
						{window.open("impresion/oficios_dgapa.cfm?vSsnId=" + encodeURIComponent(document.getElementById('vActa').value), "_blank", "modal=yes,location=no,menubar=no,titlebar=no,width=800,height=600,resizable=yes,scrollbars=yes,status=no");}
					else
						{window.open("impresion/oficios_v20.cfm?vSsnId=" + encodeURIComponent(document.getElementById('vActa').value), "_blank", "modal=yes,location=no,menubar=no,titlebar=no,width=800,height=600,resizable=yes,scrollbars=yes,status=no");}
				}
				else if (document.getElementById('vSeccion').value != 0 && document.getElementById('vSeccion').value == 5)
				{
					window.open("impresion/oficios_lyc_v20.cfm?vSsnId=" + encodeURIComponent(document.getElementById('vActa').value), "_blank", "modal=yes,location=no,menubar=no,titlebar=no,width=800,height=600,resizable=yes,scrollbars=yes,status=no");
				}
				// Desmarcar todas las solicitudes y actualizar la lista:
				if (vSeleccionOtras || vSeleccionLYC)
				{
					// IMPORTANTE: Debido a que el llamado al archivo "oficios.cfm" no es sincrono, es necesario esperar a que se genere la impresión antes de desmarcar las solicitudes y actualizar la lista:
					setTimeout("fMarcarTodas(false);", 5000);
				}				
			}
			// Imprimir tablas anexas a oficios de respuesta de licencias y comisiones, Oficios para DGAPA:
			function fGenerarAnexos()
			{
				if (document.getElementById('cmdImp2').atributo == 'ALyC')
					window.open("impresion/oficios_lyc_v20_anexos.cfm?vSsnId=" + encodeURIComponent(document.getElementById('vActa').value), "_blank", "modal=yes,location=no,menubar=no,titlebar=no,width=800,height=600,resizable=yes,scrollbars=yes,status=no");
				if (document.getElementById('cmdImp2').atributo == 'ODGAPA')
					window.open("impresion/oficios_dgapa.cfm?vSsnId=" + encodeURIComponent(document.getElementById('vActa').value), "_blank", "modal=yes,location=no,menubar=no,titlebar=no,width=800,height=600,resizable=yes,scrollbars=yes,status=no");
				if (document.getElementById('cmdImp2').atributo == 'COAOP')
					window.open("impresion/oficios_coa_oponentes.cfm?vSsnId=" + encodeURIComponent(document.getElementById('vActa').value), "_blank", "modal=yes,location=no,menubar=no,titlebar=no,width=800,height=600,resizable=yes,scrollbars=yes,status=no");
				// IMPORTANTE: Debido a que el llamado al archivo "oficios.cfm" no es sincrono, es necesario esperar a que se genere la impresión antes de desmarcar las solicitudes y actualizar la lista:
				setTimeout("fMarcarTodas(false);", 5000);
			}

			function fRegistraMovBCmd()
			{
				var vfechahoy = new Date();

				var vHoyDia = vfechahoy.getDate();
				var vHoyMes = vfechahoy.getMonth();
				var vHoyAnio = vfechahoy.getFullYear();
				
				var vSesionDia = document.getElementById("txtFechaSesion").value.substring(0,2);
				var vSesionMes = document.getElementById("txtFechaSesion").value.substring(3,5);
				var vSesionAnio = document.getElementById("txtFechaSesion").value.substring(6,10);

				var vHoyFecha = new Date(vHoyAnio, vHoyMes, vHoyDia);
				var vSesionFecha = new Date(vSesionAnio, vSesionMes - 1, vSesionDia);

				if (vHoyFecha >= vSesionFecha)
				{
					document.getElementById("trRegMovLine").style.display = '';
					document.getElementById("trRegMovLabel").style.display = '';
					document.getElementById("trRegMovLabel2").style.display = '';
					document.getElementById("trRegMovCmd").style.display = '';
				}
				else
				{
					document.getElementById("trRegMovLine").style.display = 'none';
					document.getElementById("trRegMovLabel").style.display = 'none';
					document.getElementById("trRegMovLabel2").style.display = 'none';
					document.getElementById("trRegMovCmd").style.display = 'none';
				}
			}

			// Registrar en la tabla de movimientos los asuntos seleccionados:
			function fRegistrarMovimientos()
			{
				if (confirm('A solicitado registrar movimientos en el historial, esta acción borrará de la lista todos aquellos asuntos que ya han sido resueltos. ¿Desea continuar?'))
				{
					// Icono de espera:
					document.getElementById('solicitudes_dynamic').innerHTML = "<img src=\"<cfoutput>#vCarpetaIMG#</cfoutput>/wait.gif\" style=\"display:block; margin:auto;\">";
					// Crear un objeto XmlHttpRequest:
					var xmlHttp = XmlHttpRequest();
					// Generar una petición HTTP:
					xmlHttp.open("POST", "registrar_movimiento.cfm", false);
					xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
					parametros = "vActa=" + encodeURIComponent(document.getElementById('vActa').value);
					// Enviar la petición HTTP:
					xmlHttp.send(parametros);
					// Mostrar informe de asuntos registrados:
					// Actualizar la lista de asuntos:
					document.getElementById('solicitudes_dynamic').innerHTML = xmlHttp.responseText;
					// Restablecer el valor de las banderas de selección:
					vSeleccionOtras = false;
					vSeleccionLYC = false;
					// Esperar 5 segundos y actualizar la lista:
					//setTimeout("fListarSolicitudes(1);", 10000);
				}
			}

		</script>
	</head>
    
	<body onLoad="<cfif #Session.AsuntosCTICFiltro.vPagina# IS NOT ''>fListarSolicitudes(<cfoutput>#Session.AsuntosCTICFiltro.vPagina#</cfoutput>);</cfif> fBuscarMarcadas();">
		<!-- Cintillo con nombre del módulo y Filtro -->
		<table class="Cintillo">
			<tr>
				<td><span class="Sans9GrNe">ASUNTOS QUE PASAN AL PLENO &gt;&gt; </span><span id="txtActa" class="Sans9Gr"><!-- Número de acta--></span></td>
				<td align="right">
					<cfoutput>
						<span class="Sans9GrNe">
							Filtro:
						</span>
						<span id="vFiltroActual" class="Sans9Gr">
							<cfif #Session.AsuntosCTICFiltro.vFt# NEQ 0>
								FT-CTIC-#Session.AsuntosCTICFiltro.vFt#
							<cfelse>
								Todas las solicitudes
							</cfif>
						</span>
					</cfoutput>
				</td>
			</tr>
		</table>
		<!-- Cuerpo de la lista de solicitudes -->
		<table width="98%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<!-- Columna izquierda (comandos) -->
				<td width="180" valign="top" class="bordesmenu">
					<div id="reg_seleccionados_dynamic" width="100%">
						<!-- AJAX: Para el conteo de registros marcados -->
					</div>
					<!-- Formulario de nueva solicitud -->
					<table width="180" border="0">
						<!-- División -->
						<tr><td><div class="linea_menu"></div></td></tr>
						<!-- Menú de la lista de solicitudes -->
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">MEN&Uacute;:</div></td>
						</tr>
						<!-- Opción: Indexar la lista -->
						<tr>
							<td><input id="cmdIdexaAsuntos" type="button" value="Ordenar asuntos" class="botones" onClick="fIndexarAsuntos();"></td>
						</tr>
						<!-- Opción: Aprobar/Ratificar -->
						<tr>
							<td><input id="cmdAsignaDec" type="button" value="Aprobar/Ratificar" class="botones" onClick="fAsignarDecision();"></td>
						</tr>
						<!-- Imprimir la lista de asuntos -->
						<tr><td><br><div class="linea_menu"></div></td></tr>
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">Imprimir listado:</div></td>
						</tr>
						<!-- Seleccionar sección a imprimir -->
						<tr>
							<td valign="top">
								<span class="Sans9Vi" align="justify">Seleccione la sección del listado que desea imprimir:<br></span>
								<select name="vSeccionImprimir" id="vSeccionImprimir" class="datos" style="width:95%;">
									<option value="1">Sección No. I</option>
									<option value="2">Sección No. II</option>
									<option value="3">Sección No. III</option>
									<option value="3.1">Sección No. III.I</option>
									<option value="3.2">Sección No. III.II</option>
									<option value="3.4">Sección No. III.IV</option>
									<option value="4">Sección No. IV</option>
									<option value="5">Sección No. V</option>
									<option value="5h">Sección No. V (horizontal)</option>
									<option value="5n">Sección No. V (nacionales)</option>
									<option value="5i">Sección No. V (internacionales)</option>
									<option value="6">Sección No. VI</option>
									<!---<option value="9">Todas las secciones</option>--->
								</select>
							</td>
						</tr>
						<!-- Tipo de listado -->
						<tr>
							<td class="Sans9GrNe">
								<input name="vTipoListado" id="vTipoListado_REC" type="radio" class="datos" checked> Recom.
								<input name="vTipoListado" id="vTipoListado_ACTA" type="radio" class="datos"> Decisiones
							</td>
						</tr>
						<!-- Botón imprimir listado -->
						<tr>
							<td><input id="cmdImprimirLista" type="button" value="Imprimir" class="botones" onClick="fImprimirListado();"></td>
						</tr>
						<!-- Asignar números de oficio -->
						<tr><td><br><div class="linea_menu"></div></td></tr>
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">Asignar No. Oficio:</div></td>
						</tr>
						<!-- Tipo de oficios -->
						<tr>
							<td>
								<select name="vAsignaNoOficio" id="vAsignaNoOficio" class="datos" style="width:95%;">
									<option value="">Seleccione el tipo</option>                                    
									<option value="RES">A los asuntos seleccionados</option>
									<option value="OFDGAPA">Para la DGAPA de los sabáticos con beca</option>
									<option value="COAOP">A los oponentes de COA´s</option>                                    
                                </select>
                            </td>
						</tr>
						<!-- A partir del número de oficio --->
						<tr>
							<td>
								<span class="Sans9GrNe">A partir del No.</span>
								<input name="vNoOficio" id="vNoOficio" type="text" maxlength="6" style="width: 40px;" class="datos">
							</td>
						</tr>
						<!-- Registrar movimientos: Botón de comando -->
						<tr>
							<td>
								<input id="cmdAsignaOficio" type="button" value="Asignar" class="botones" onClick="fGenerarNoOficios();">
							</td>
						</tr>

						<!-- Opción: Generar oficios -->
						<tr><td><br><div class="linea_menu"></div></td></tr>
						<tr>
							<td>
								<div align="left"><span class="Sans10NeNe">Generar oficios de la:</span></div>
							</td>
						</tr>
						<tr id="trImp1">
							<td>
								<input id="cmdImp1" type="button" value="" class="botones" onClick="fGenerarOficios();" style="display:none;">
							</td>
						</tr>
						<tr id="trImp2">
							<td>
								<input id="cmdImp2" type="button" value="" class="botones" atributo="" onClick="fGenerarAnexos();" style="display:none;">
							</td>
						</tr>
						<tr id="trImp3">
							<td>
								<input id="cmdImp3" type="button" value="Oponentes COA" class="botones" atributo="" onClick="" style="display:none;">
							</td>
						</tr>                        
<!---
						<tr>
							<td>
								<div align="left"><span class="Sans10NeNe">Generar listado probatorios:</span></div>
							</td>
						</tr>
						<tr id="trImpListaAsuntosProb">
							<td>
								<input id="cmdImpListaAsuntosProb" type="button" value="Generar PDF " class="botones" onClick="fGenerarListadoAsuntosProb();">
							</td>
						</tr>
--->						
<!---
						<tr id="tr_I_II">
							<td>
								<input type="button" value="Parte I - II: " class="botones" onClick="fGenerarOficios();">
							</td>
						</tr>
						<tr id="tr_III">
							<td>
								<input type="button" value="Parte III: " class="botones" onClick="fGenerarOficios();">
							</td>
						</tr>
						<tr id="tr_IV">
							<td>
								<input type="button" value="Parte IV: " class="botones" onClick="fGenerarOficios();">
							</td>
						</tr>
						<tr id="tr_V">
							<td>
								<input type="button" value="Licencias y comisiones" class="botones" onClick="fGenerarLyCOficios();">
							</td>
						</tr>
						<tr id="tr_VA">
							<td>
								<input type="button" value="Anexos Lic. y Com." class="botones" onClick="fGenerarLyCAnexos();">
							</td>
						</tr>
						<tr id="tr_Dgapa">
							<td>
								<input type="button" value="Sabáticos DGAPA" class="botones" onClick="fGenerarSabaticosDgapa();">
							</td>
						</tr>
--->						                        
						<!-- Registrar movimeitnos -->
						<tr id="trRegMovLine" style="display:none;"><td><br><div class="linea_menu"></div></td></tr>
						<tr id="trRegMovLabel" style="display:none;">
							<td valign="top"><div align="left" class="Sans10NeNe">Registrar movimientos:</div></td>
						</tr>
						<!-- Descripción de la asignación a sesión -->
						<tr id="trRegMovLabel2" style="display:none;">
							<td><span class="Sans9Vi" align="justify">Registrar todos los asuntos resueltos en el historial.</span></td>
						</tr>
						<!-- A partir del número de oficio y botón OK --->
						<tr id="trRegMovCmd" style="display:none;">
							<td>
								<input id="cmdRegistraMov" type="button" value="Registrar" class="botones" onClick="fRegistrarMovimientos();">
							</td>
						</tr>
						<!---
						<!-- Navegación -->
						<tr><td valign="top"><br><div class="linea_menu"></div></td></tr>
						<tr>
							<td><span class="Sans10NeNe">Navegaci&oacute;n:</span></td>
						</tr>
						<!-- Ir al Menú principal -->
						<tr>
							<td>
								<input type="button" class="botones" value="Menú principal" onclick="top.location.replace('../../<cfoutput>#Session.sTipoSistema#</cfoutput>_index.cfm');">
							</td>
						</tr>
						--->
						<!-- Filtrar por -->
						<tr><td valign="top"><br><div class="linea_menu"></div></td></tr>
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">Filtrar por:</div></td>
						</tr>
						<!-- Acta (No. Sesión) -->
						<tr>
							<td>
								<span class="Sans9GrNe">Sesi&oacute;n:<br></span>
								<select name="vActa" id="vActa" class="datos" onChange="fListarSolicitudes(1);">
									<cfoutput query="ctSesionesVencidas">
										<cfif #ssn_id# LT #Session.sSesion#>
											<cfset vColorActa = '##FF0000'>
                                        <cfelse>
											<cfset vColorActa = '##000000'>
                                        </cfif>
										<option  style="color:#vColorActa#" value="#ssn_id#" <cfif isDefined("Session.AsuntosCTICFiltro.vActa") AND #Session.AsuntosCTICFiltro.vActa# EQ #ssn_id#>selected</cfif>>#ssn_id#</option>
									</cfoutput>
								</select>
							</td>
						</tr>
<!---
						<!-- Sección -->
						<tr>
							<td valign="top">
								<span class="Sans9GrNe">Secci&oacute;n:<br></span>
								<!--- NOTA: Obtener esta lista del catálogo de partes --->
								<select name="vSeccion" id="vSeccion" class="datos" style="width:95%;" onChange="fListarSolicitudes(1);">
									<option value="">Todas</option>
									<option value="1" <cfif isDefined("Session.AsuntosCTICFiltro.vSeccion") AND #Session.AsuntosCTICFiltro.vSeccion# EQ 1>selected</cfif>>Sección No. I</option>
									<option value="2.1" <cfif isDefined("Session.AsuntosCTICFiltro.vSeccion") AND #Session.AsuntosCTICFiltro.vSeccion# EQ 2.1>selected</cfif>>Sección No. II.I</option>
									<option value="2.2" <cfif isDefined("Session.AsuntosCTICFiltro.vSeccion") AND #Session.AsuntosCTICFiltro.vSeccion# EQ 2.2>selected</cfif>>Sección No. II.III</option>
									<option value="3" <cfif isDefined("Session.AsuntosCTICFiltro.vSeccion") AND #Session.AsuntosCTICFiltro.vSeccion# EQ 3>selected</cfif>>Sección No. III</option>
									<option value="3.1" <cfif isDefined("Session.AsuntosCTICFiltro.vSeccion") AND #Session.AsuntosCTICFiltro.vSeccion# EQ 3.1>selected</cfif>>Sección No. III.I</option>
									<option value="3.2" <cfif isDefined("Session.AsuntosCTICFiltro.vSeccion") AND #Session.AsuntosCTICFiltro.vSeccion# EQ 3.2>selected</cfif>>Sección No. III.II</option>
									<option value="3.4" <cfif isDefined("Session.AsuntosCTICFiltro.vSeccion") AND #Session.AsuntosCTICFiltro.vSeccion# EQ 3.4>selected</cfif>>Sección No. III.IV</option>
									<option value="4.1" <cfif isDefined("Session.AsuntosCTICFiltro.vSeccion") AND #Session.AsuntosCTICFiltro.vSeccion# EQ 4.1>selected</cfif>>Sección No. IV.I</option>
									<option value="4.2" <cfif isDefined("Session.AsuntosCTICFiltro.vSeccion") AND #Session.AsuntosCTICFiltro.vSeccion# EQ 4.2>selected</cfif>>Sección No. IV.III</option>
									<option value="4.4" <cfif isDefined("Session.AsuntosCTICFiltro.vSeccion") AND #Session.AsuntosCTICFiltro.vSeccion# EQ 4.4>selected</cfif>>Sección No. IV.IV</option>
									<option value="5" <cfif isDefined("Session.AsuntosCTICFiltro.vSeccion") AND #Session.AsuntosCTICFiltro.vSeccion# EQ 5>selected</cfif>>Sección No. V</option>
									<option value="6" <cfif isDefined("Session.AsuntosCTICFiltro.vSeccion") AND #Session.AsuntosCTICFiltro.vSeccion# EQ 6>selected</cfif>>Sección No. VI</option>
									<option value="7" <cfif isDefined("Session.AsuntosCTICFiltro.vSeccion") AND #Session.AsuntosCTICFiltro.vSeccion# EQ 7>selected</cfif>>Otros asuntos</option>
								</select>
							</td>
						</tr>
--->
						<!-- Dependencia -->
						<tr>
							<td valign="top">
								<span class="Sans9GrNe">Entidad:<br></span>
								<select name="vDepId" id="vDepId" class="datos" style="width:95%;" onChange="fListarSolicitudes(1);">
									<option value="">Todas</option>
									<cfoutput query="ctDependencia">
									<option value="#dep_clave#" <cfif isDefined("Session.AsuntosCTICFiltro.vDepId") AND #dep_clave# EQ #Session.AsuntosCTICFiltro.vDepId#>selected</cfif>>#dep_siglas#</option>
									</cfoutput>
								</select>
							</td>
						</tr>
						<!-- Académico -->
						<tr>
							<td>
								<span class="Sans9GrNe">Acad&eacute;mico:<br></span>
								<input name="vAcadNom" id="vAcadNom" type="text" style="width:95%;" class="datos" value="<cfoutput>#Session.AsuntosCTICFiltro.vAcadNom#</cfoutput>" onKeyUp="if (this.value.length == 0 || this.value.length >= 3) fListarSolicitudes(1)">
							</td>
						</tr>
						<!-- Número de solicitud -->
						<tr>
							<td>
								<span class="Sans9GrNe">No. Solicitud:<br></span>
								<input name="vNumSol" id="vNumSol" type="text" style="width: 60px;" class="datos" value="<cfoutput>#Session.AsuntosCTICFiltro.vNumSol#</cfoutput>" onKeyPress="return MascaraEntrada(event, '999999');" onKeyUp="fListarSolicitudes(1);">
							</td>
						</tr>
						<!--- Selección de número de registros por página --->
						<cfmodule template="#vCarpetaINCLUDE#/registros_pagina.cfm" filtro="AsuntosCTICFiltro" funcion="fListarSolicitudes" ordenable="no">
						<!--- Contador de registros --->
						<cfmodule template="#vCarpetaINCLUDE#/contador_registros.cfm">
					</table>
					<!--- Include para abrir archivo PDF enviando parámetros por POST --->
					<cfinclude template="#vCarpetaRaizLogicaSistema#/comun/consulta_pdf_comun.cfm">
				</td>
				<!-- Columna derecha (listado) -->
				<td width="844" valign="top">
                	<!--- MODULE PARA AGRAGAR SELECT CON EL CATÁLOGO DE MOVIMIENTOS --->
					<div style="float:left; width:65%; margin:5px 0px 5px 15px; padding:5px 5px 5px 5px; height:30px; background-color:#FFCC66">
						<cfmodule template="#vCarpetaINCLUDE#/module_movimientos_catalogo_select.cfm" filtro="0" funcion="fListarSolicitudes" sFiltrovFt="#Session.AsuntosCTICFiltro.vFt#" sFiltrovOrden="0" sFiltrovOrdenDir="0">
					</div>
                	<!--- MODULE PARA AGRAGAR SELECT CON EL CATÁLOGO DE SECCIÓN PARA LOS ASUNTOS --->
					<div style="float:left; width:25%; margin:5px 0px 5px 15px; padding:5px 5px 5px 5px; height:30px; background-color:#FFCC66">
						<cfmodule template="#vCarpetaINCLUDE#/module_seccion_catalogo_select.cfm" funcion="fListarSolicitudes" sFiltrovSeccion="#Session.AsuntosCTICFiltro.vSeccion#">                    
					</div>
					<div id="solicitudes_dynamic" width="100%">
						<!-- AJAX: Lista de solicitudes -->
					</div>
				</td>
			</tr>
		</table>
	</body>
</html>