<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 30/09/2009 --->
<!--- FECHA ÚLTIMA MOD: 02/08/2023 --->

<script language="JavaScript" type="text/JavaScript">

	// Variable globales (buscar una mejor solución):
	var hay_decision_CTIC = false;	

	// Obtener la ubicacion de la dependencia destino (solo SIC)
	function fObtenerUbicaciones(vDep, vContenedor, vSelect, vCampo)
	{
		// Crear un objeto XmlHttpRequest:
		var xmlHttp = XmlHttpRequest();
		// Función de atención a las petición HTTP:
		xmlHttp.onreadystatechange = function(){
			if (xmlHttp.readyState == 4) {
				document.getElementById(vContenedor).innerHTML = xmlHttp.responseText;
			}
		}
		// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
		xmlHttp.open("POST", "mov_ajax/lista_ubicaciones.cfm", true);
		xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');		
		// Crear la lista de parámetros:
		parametros = "vDep=" + encodeURIComponent(document.getElementById(vDep).value);
		parametros += "&vUbica=" + encodeURIComponent(vSelect);
		parametros += "&vActivaCampos=" + encodeURIComponent('<cfoutput>#vActivaCampos#</cfoutput>');
		if (vCampo) parametros += "&vCampo=" + encodeURIComponent(vCampo);
		else parametros += vDep == 'dep_clave' ? "&vCampo=dep_ubicacion" : "&vCampo=mov_dep_ubicacion";
		// Enviar la petición HTTP:
		xmlHttp.send(parametros);
	}
	// Lista de academicos:
	function fObtenerAcademico(vCampo) 
	{
			// Ocultar la lista si no hay texto:
			if (document.getElementById(vCampo + '_txt').value.length == 0) document.getElementById('academico_dynamic_' + vCampo).innerHTML = '';
				
			// Empaeza a buscar a partir de tres letras:
			if (document.getElementById(vCampo + '_txt').value.length < 3) return;
			// Crear un objeto XmlHttpRequest:
			var xmlHttp = XmlHttpRequest();
			// Función de atención a las petición HTTP:
			xmlHttp.onreadystatechange = function(){
				if (xmlHttp.readyState == 4) {
					document.getElementById('academico_dynamic_' + vCampo).innerHTML = xmlHttp.responseText;
				}
			}
			// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
			xmlHttp.open("POST", "mov_ajax/lista_academicos.cfm", true);
			xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
			// Crear la lista de parámetros:
			parametros = "vFiltraNombre=" + encodeURIComponent(document.getElementById(vCampo + '_txt').value);
			parametros += "&vCampo=" + encodeURIComponent(vCampo);
			// Enviar la petición HTTP:
			xmlHttp.send(parametros);
	}
	// Obtener la lista de estados de un país:
	function fObtenerEstados()
	{
		// Crear un objeto XmlHttpRequest:
		var xmlHttp = XmlHttpRequest();
		// Función de atención a las petición HTTP:
		xmlHttp.onreadystatechange = function(){
			if (xmlHttp.readyState == 4) {
				document.getElementById('estados_dynamic').innerHTML = xmlHttp.responseText;
			}
		}
		// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
		xmlHttp.open("POST", "mov_ajax/lista_estados.cfm", true);
		xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
		// Crear la lista de parámetros:
		parametros = "vPais=" + encodeURIComponent(document.getElementById('pais_clave').value); 
		parametros += "&vEstado=" + encodeURIComponent('<cfoutput>#edo_clave#</cfoutput>');
		parametros += "&vActivaCampos=" + encodeURIComponent('<cfoutput>#vActivaCampos#</cfoutput>');
		// Enviar la petición HTTP:
		xmlHttp.send(parametros);
	}
	// Listar destinos/instituciones:
	function fMostrarDestinos(vSolId)
	{
		// Crear un objeto XmlHttpRequest:
		var xmlHttp = XmlHttpRequest();
		// Función de atención a las petición HTTP:
		xmlHttp.onreadystatechange = function(){
			if (xmlHttp.readyState == 4) {
				document.getElementById('destinos_dynamic').innerHTML = xmlHttp.responseText;
				document.getElementById('b_destinos_dynamic').innerHTML = "<img src=\"<cfoutput>#vCarpetaIMG#</cfoutput>/ir_arriba_15.jpg\" style=\"border:none;\" onclick=\"fOcultarDestinos();\">";
			}
		}
		// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
		xmlHttp.open("POST", "mov_ajax/lista_destinos.cfm", true);
		xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
		// Crear la lista de parámetros:
		parametros = "vIdSol=" + encodeURIComponent(vSolId); 
		// Enviar la petición HTTP:
		xmlHttp.send(parametros);
	}
	// Listar oponentes/concursantes:
	function fMostrarOponentes(vFt, vConvocatoria)
	{
		// Crear un objeto XmlHttpRequest:
		var xmlHttp = XmlHttpRequest();
		// Función de atención a las petición HTTP:
		xmlHttp.onreadystatechange = function(){
			if (xmlHttp.readyState == 4) {
				document.getElementById('oponentes_dynamic').innerHTML = xmlHttp.responseText;
				document.getElementById('b_oponentes_dynamic').innerHTML = "<img src=\"<cfoutput>#vCarpetaIMG#</cfoutput>/ir_arriba_15.jpg\" style=\"border:none;\" onclick=\"fOcultarOponentes();\">";
			}
		}
		// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
		xmlHttp.open("POST", "<cfoutput>#vCarpetaRaizLogicaSistema#</cfoutput>/movimientos/detalle/mov_ajax/lista_oponentes.cfm", true);
		xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
		// Crear la lista de parámetros:
		parametros = "vFt=" + encodeURIComponent(vFt); 
		parametros += "&vConvocatoria=" + encodeURIComponent(vConvocatoria); 
		parametros += "&vSolId=" + encodeURIComponent(document.getElementById('sol_id').value); // Se agregó el 02/08/2023 para diferenciar las solicitudes
		// Enviar la petición HTTP:
		xmlHttp.send(parametros);
	}
/* ELIMINAR 19/10/2017
	// Listar la historia del asunto:
	function fHistoriaAsunto(vComando, vKey)
	{
		// Crear un objeto XmlHttpRequest:
		var xmlHttp = XmlHttpRequest();
		// Función de atención a las petición HTTP:
		xmlHttp.onreadystatechange = function(){
			if (xmlHttp.readyState == 4) {
				document.getElementById('historia_asunto_dynamic').innerHTML = xmlHttp.responseText;
				document.getElementById('b_historia_asunto_dynamic').innerHTML = "<img src=\"<cfoutput>#vCarpetaIMG#</cfoutput>/ir_arriba_15.jpg\" style=\"border:none;\" onclick=\"fOcultarHistoriaAsunto();\">";
				if (document.getElementById('hay_decision_CTIC')) hay_decision_CTIC = true; else hay_decision_CTIC = false;
			}
		}
		// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
		xmlHttp.open("POST", "mov_ajax/historia_asunto.cfm", true);
		xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
		// Crear la lista de parámetros:
		parametros = "vIdSol=" + encodeURIComponent(document.getElementById('sol_id').value);
		// Parametros para insertar registro:
		if (vComando == 'INSERTA' || vComando == 'EDITA') { 
			parametros += "&vSesion=" + encodeURIComponent(document.getElementById('frm_ssn_id').value); 
			parametros += "&vReunion=" + encodeURIComponent(document.getElementById('frm_asu_reunion').value);
			parametros += "&vDecision=" + encodeURIComponent(document.getElementById('frm_dec_clave').value);
			parametros += "&vNotas=" + encodeURIComponent(document.getElementById('frm_asu_notas').value);
			parametros += "&vOficio=" + encodeURIComponent(document.getElementById('frm_asu_oficio').value);
		}
		// Si se envió una clave, retransmitirla:
		if (vKey) parametros += "&vKey=" + encodeURIComponent(vKey);
		parametros += "&vActivaCampos=" + encodeURIComponent('<cfoutput>#vActivaCampos#</cfoutput>'); 
		parametros += "&vComando=" + encodeURIComponent(vComando);
		// Enviar la petición HTTP:
		xmlHttp.send(parametros);
	}
*/	
	// Mostrar/Ocultar el formulario para agregar asuntos:
	function fMostrarFormularioAsuntos(mostrar, vSesion, vReunion, vDecision, vNotas, vOficio)
	{
		if (mostrar)
		{
			// Crear un objeto XmlHttpRequest:
			var xmlHttp = XmlHttpRequest();
			// Función de atención a las petición HTTP:
			xmlHttp.onreadystatechange = function(){
				if (xmlHttp.readyState == 4) {
					document.getElementById('frm_agregar_asunto').innerHTML = xmlHttp.responseText;
					document.getElementById('cmd_agregar_asunto').style.display = 'none';
				}
			}
			// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
			xmlHttp.open("POST", "mov_ajax/historia_asunto_frm.cfm", true);
			xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
			parametros = '';
			// Si se envía una llave entonces se debe editar el registro:
			if (vSesion) parametros += "&vSesion=" + encodeURIComponent(vSesion); 
			if (vReunion) parametros += "&vReunion=" + encodeURIComponent(vReunion);
			if (vDecision) parametros += "&vDecision=" + encodeURIComponent(vDecision);
			if (vNotas) parametros += "&vNotas=" + encodeURIComponent(vNotas);
			if (vOficio) parametros += "&vOficio=" + encodeURIComponent(vOficio);
			if (vSesion && vReunion) parametros += "&vKey=" + encodeURIComponent(document.getElementById('sol_id').value.trim() + vSesion.trim() + vReunion.trim()); 
			// Enviar la petición HTTP:
			xmlHttp.send(parametros);
		}
		else
		{
			document.getElementById('frm_agregar_asunto').innerHTML = '';
			document.getElementById('cmd_agregar_asunto').style.display = '';
		}
	}
	// Listar correcciones a oficio:
	function fMostrarCorreccionesOficio(vIdMov, vMov)
	{
		// Crear un objeto XmlHttpRequest:
		var xmlHttp = XmlHttpRequest();
		// Función de atención a las petición HTTP:
		xmlHttp.onreadystatechange = function(){
			if (xmlHttp.readyState == 4) {
				document.getElementById('correcciones_oficio_dynamic').innerHTML = xmlHttp.responseText;
				document.getElementById('b_correcciones_oficio_dynamic').innerHTML = "<img src=\"<cfoutput>#vCarpetaIMG#</cfoutput>/ir_arriba_15.jpg\" style=\"border:none;\" onclick=\"fOcultarCorreccionesOficio();\">";
			}
		}
		// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
		xmlHttp.open("POST", "mov_ajax/lista_correcciones.cfm", true);
		xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
		// Crear la lista de parámetros:
		parametros = "vIdMov=" + encodeURIComponent(vIdMov); 
		parametros += "&vMov=" + encodeURIComponent(vMov); 
		// Enviar la petición HTTP:
		xmlHttp.send(parametros);
	}
	// Desglosar duración en años, meses y días:
	function fDesglosarDuracion()
	{
		// Validar que existan y sean correctas ambas fechas:
		if (fValidaFecha('mov_fecha_inicio','') +  fValidaFecha('mov_fecha_final','') == '')
		{
			// Crear un objeto XmlHttpRequest:
			var xmlHttp = XmlHttpRequest();
			// Función de atención a las petición HTTP:
			xmlHttp.onreadystatechange = function(){
				if (xmlHttp.readyState == 4) {
					document.getElementById('duracion_dynamic').innerHTML = xmlHttp.responseText;
				}
			}
			// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
			xmlHttp.open("POST", "mov_ajax/desglose_duracion.cfm", true);
			xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
			// Crear la lista de parámetros:
			parametros = "mov_fecha_inicio=" + encodeURIComponent(document.getElementById('mov_fecha_inicio').value); 
			parametros += "&mov_fecha_final=" + encodeURIComponent(document.getElementById('mov_fecha_final').value); 
			parametros += "&vActivaCampos=<cfoutput>#vActivaCampos#</cfoutput>"; 			
			
			// Enviar la petición HTTP:
			xmlHttp.send(parametros);
		}
	}
	
	<!----------------------------------------------------------------------------------------------------------------------->
	<!--- DESHABILITADO DESHABILITADO DESHABILITADO DESHABILITADO DESHABILITADO DESHABILITADO DESHABILITADO DESHABILITADO --->
	<!----------------------------------------------------------------------------------------------------------------------->
	<!---
	// Mostrar la forma telegrámica asociada:
	function fMostrarSolicitud(vIdSol)
	{
		$('#FormaTelegramica').activity();
		// Crear un objeto XmlHttpRequest:
		var xmlHttp = XmlHttpRequest();
		// Función de atención a las petición HTTP:
		xmlHttp.onreadystatechange = function(){
			if (xmlHttp.readyState == 4) {
				document.getElementById('FormaTelegramica').innerHTML = xmlHttp.responseText;
				$('#FormaTelegramica').activity(false);
			}
		}
		// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
		xmlHttp.open("POST", '<cfoutput>#Application.vCarpetaRaiz#</cfoutput>/sistema_ctic/asuntos/solicitudes/ft_pantallas/ft_consulta_historia.cfm', true);
		xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
		// Crear la lista de parámetros:
		parametros = "vIdSol=" + encodeURIComponent(vIdSol); 
		// Enviar la petición HTTP:
		xmlHttp.send(parametros);
	}
	--->
	
</script>