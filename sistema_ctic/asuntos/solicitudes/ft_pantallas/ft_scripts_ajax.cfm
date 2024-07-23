<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA: 30/09/2009 --->
<!--- FECHA ULTIMA MOD.: 24/06/2016 --->

<cfoutput>
	<script type="text/javascript" src="#vHttpWebGlobal#/xmlHttpRequest.js"></script>
</cfoutput>    

<script language="JavaScript" type="text/JavaScript">
	// Obtener la lista de estados de un país:
	function ObtenerEstados()
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
		xmlHttp.open("POST", "ft_ajax/lista_estados.cfm", true);
		xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
		// Crear la lista de parámetros:
		parametros = "vPais=" + encodeURIComponent(document.getElementById('pos11_p').value); 
		parametros += "&vCampoPos11_e=" + encodeURIComponent('<cfoutput>#vCampoPos11_e#</cfoutput>');
		parametros += "&vActivaCampos=" + encodeURIComponent('<cfoutput>#vActivaCampos#</cfoutput>');
		parametros += "&vFt=" + encodeURIComponent('<cfoutput>#vFt#</cfoutput>');
		// Enviar la petición HTTP:
		xmlHttp.send(parametros);
		// Es necesario habilitar el campo de Ciudad en caso de haberse deshabilitado:
		<cfif #vActivaCampos# IS NOT 'disabled'>if (document.getElementById('pos11_c'))  document.getElementById('pos11_c').disabled = false;</cfif>
	}

	// Lista los destinos ligados a una solicitud:
	function fListaDestino()
	{
		// Crear un objeto XmlHttpRequest:
		var xmlHttp = XmlHttpRequest();
		// Función de atención a las petición HTTP:
		xmlHttp.onreadystatechange = function(){
			if (xmlHttp.readyState == 4) {
				document.getElementById('destino_dynamic').innerHTML = xmlHttp.responseText;
				if (document.getElementById('posND')) document.getElementById('posND').value = parseInt(document.getElementById('NumDestinos').value);
			}
		}
		// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
		xmlHttp.open("POST", "ft_ajax/lista_destinos.cfm", true);
		xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
		// Crear la lista de parámetros:
		parametros = "vIdSol=" + encodeURIComponent(document.getElementById('vIdSol').value);
		parametros += "&vActivaCampos=" + encodeURIComponent('<cfoutput>#vActivaCampos#</cfoutput>');
		// Enviar la petición HTTP:
		xmlHttp.send(parametros);
	}
	// Elimina el destino seleccionado y ligados a una solicitud:
	function fEliminaDestino(IdRegDestino)
	{
		// Crear un objeto XmlHttpRequest:
		var xmlHttp = XmlHttpRequest();
		// Función de atención a las petición HTTP:
		xmlHttp.onreadystatechange = function(){
			if (xmlHttp.readyState == 4) {
				document.getElementById('destino_dynamic').innerHTML = xmlHttp.responseText;
				alert('EL DESTINO FUE ELIMINADO');
			}
		}
		// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
		xmlHttp.open("POST", "ft_ajax/lista_destinos.cfm", true);
		xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
		// Crear la lista de parámetros:
		parametros = "vIdSol=" + encodeURIComponent(document.getElementById('vIdSol').value);
		parametros += "&vIdRegDestino=" + IdRegDestino;
		parametros += "&vComandoDestino=ELIMINA";
		parametros += "&vActivaCampos=";		
		// Enviar la petición HTTP:
		xmlHttp.send(parametros);
	}	
	
/* <!-- 24/06/2016 ELIMINAR ESTE AJAX */
	// Agregar destinos a una solicitud:
	function fAgregarDestino(vComandoDestino, IdRegDestino)
	{
		// Crear un objeto XmlHttpRequest:
		var xmlHttp = XmlHttpRequest();
		// Función de atención a las petición HTTP:
		xmlHttp.onreadystatechange = function(){
			if (xmlHttp.readyState == 4) {
				document.getElementById('destino_dynamic').innerHTML = xmlHttp.responseText;
				document.getElementById('posND').value = parseInt(document.getElementById('NumDestinos').value);
			}
		}
		// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
		xmlHttp.open("POST", "ft_ajax/lista_destinos.cfm", true);
		xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
		// Crear la lista de parámetros:
		parametros = "vInstitucion=" + encodeURIComponent(document.getElementById('pos11_u').value);	
		parametros += "&vPais=" + encodeURIComponent(document.getElementById('pos11_p').value); 
		parametros += "&vEstado=" + encodeURIComponent(document.getElementById('pos11_e').value);
		parametros += "&vCiudad=" + encodeURIComponent(document.getElementById('pos11_c').value);
		parametros += "&vIdAcad=" + encodeURIComponent(document.getElementById('pos2').value); //<!---parametros += "&vRfc=" + encodeURIComponent(document.getElementById('rfc').value);--->
		parametros += "&vIdSol=" + encodeURIComponent(document.getElementById('vIdSol').value);
		parametros += "&vIdRegDestino=" + encodeURIComponent(IdRegDestino);			
		parametros += "&vComandoDestino=" + encodeURIComponent(vComandoDestino);
		parametros += "&vActivaCampos=" + encodeURIComponent('<cfoutput>#vActivaCampos#</cfoutput>');
		// Enviar la petición HTTP:
		xmlHttp.send(parametros);
	}
/* --> */	

	// Agregar periodo de antiguedad:
	function fAgregarAntiguedad(vComandoDestino, IdRegDestino)
	{
		// Crear un objeto XmlHttpRequest:
		var xmlHttp = XmlHttpRequest();
		// Función de atención a las petición HTTP:
		xmlHttp.onreadystatechange = function(){
			if (xmlHttp.readyState == 4) {
				document.getElementById('antiguedad_dynamic').innerHTML = xmlHttp.responseText;
				document.getElementById('pos13_a').value = parseInt(document.getElementById('antig_suma_anios').value);
				document.getElementById('pos13_m').value = parseInt(document.getElementById('antig_suma_meses').value);
				document.getElementById('pos13_d').value = parseInt(document.getElementById('antig_suma_dias').value);
			}
		}
		// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
		xmlHttp.open("POST", "ft_ajax/lista_periodos.cfm", true);
		xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
		// Crear la lista de parámetros:
		parametros = "vInstitucion=" + encodeURIComponent(document.getElementById('antig_institucion').value);	
		parametros += "&vFechaIni=" + encodeURIComponent(document.getElementById('antig_fecha_ini').value); 
		parametros += "&vFechaFin=" + encodeURIComponent(document.getElementById('antig_fecha_fin').value);
		parametros += "&vIdAcad=" + encodeURIComponent(document.getElementById('pos2').value);			
		parametros += "&vIdSol=" + encodeURIComponent(document.getElementById('vIdSol').value);			
		parametros += "&vIdRegAntig=" + encodeURIComponent(IdRegDestino);			
		parametros += "&vComandoAntig=" + encodeURIComponent(vComandoDestino);
		parametros += "&vActivaCampos=" + encodeURIComponent('<cfoutput>#vActivaCampos#</cfoutput>');
		// Enviar la petición HTTP:
		xmlHttp.send(parametros);
	}

	// Agregar nuevo oponente a un concurso:
	function fAgregarOponente(vComandoDestino, vAcademico)
	{
		// Si el usuario desea insertar un oponente, verificar que haya seleccionado ya a uno:
		if (vComandoDestino == 'INSERTA' && document.getElementById('idOponente').value == "0") 
		{
			alert('Por favor, escriba el nombre del académico que desea agregar.')
			return;
		}
		// Crear un objeto XmlHttpRequest:
		var xmlHttp = XmlHttpRequest();
		// Función de atención a las petición HTTP:
		xmlHttp.onreadystatechange = function()
		{
			if (xmlHttp.readyState == 4)
			{
				document.getElementById('oponente_dynamic').innerHTML = xmlHttp.responseText;
				document.getElementById('pos17').value = document.getElementById('NumOponentes').value;
			}
		}
		// Generar una petición HTTP:
		xmlHttp.open("POST", "ft_ajax/lista_oponentes.cfm", true);
		xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
		// Crear la lista de parámetros:
		parametros = "vFt=" + encodeURIComponent(document.getElementById('vFt').value);
		parametros += "&vIdSol=" + encodeURIComponent(document.getElementById('vIdSol').value);
		parametros += "&vActivaCampos=" + encodeURIComponent('<cfoutput>#vActivaCampos#</cfoutput>');
		parametros += "&vComandoDestino=" + encodeURIComponent(vComandoDestino);
		parametros += "&vConvocatoria=" + encodeURIComponent(document.getElementById('pos23').value);
		// Determinar que ID de académico se debe enviar:
		if (vComandoDestino == 'GANADOR')
		{
			parametros += "&selOponente=" + encodeURIComponent(document.getElementById('pos2').value);
		}
		else if (vComandoDestino == 'ELIMINA') 
		{
			parametros += "&selOponente=" + encodeURIComponent(vAcademico);
		}
		else if (vComandoDestino == 'INSERTA')
		{
			parametros += "&selOponente=" + encodeURIComponent(document.getElementById('idOponente').value);
			// Determinar si se enviarán los datos de un nuevo académico:
			if (document.getElementById('idOponente').value=='NUEVO')
			{
				parametros += "&frmPaterno=" + encodeURIComponent(document.getElementById('frmPaterno').value);
				parametros += "&frmMaterno=" + encodeURIComponent(document.getElementById('frmMaterno').value);
				parametros += "&frmNombres=" + encodeURIComponent(document.getElementById('frmNombres').value);				
				parametros += "&frmGrado=" + encodeURIComponent(document.getElementById('frmGrado').value);
				parametros += document.getElementById('frmSexoF').checked ? "&frmSexo=F" : "&frmSexo=M";
				parametros += "&frmNacionalidad=" + encodeURIComponent(document.getElementById('frmNacionalidad').value);
			}
/*
			else
			{
				parametros += "&frmPaterno=NULL";
				parametros += "&frmMaterno=NULL";
				parametros += "&frmNombres=NULL";
				parametros += "&frmGrado=NULL";
				parametros += "&frmSexo=NULL";
				parametros += "&frmNacionalidad=NULL";
			}
*/
		}
		else 
		{
			parametros += "&selOponente=NULL";
		}		

		// Enviar la petición HTTP:
		xmlHttp.send(parametros);
		// Limpiar los controles para agregar nuevos oponentes:
		if (document.getElementById('filtraacademico')) document.getElementById('filtraacademico').value = ''
		if (document.getElementById('idOponente')) document.getElementById('idOponente').value = '0'

	}
	
/* <!-- 24/06/2016 ELIMINAR ESTE AJAX
	// Agregar academico:
	function fAgregarAcademico()
	{
		// Ocultar la lista si no hay datos:
		if (document.getElementById('filtraacademico').value.length == 0) document.getElementById('academico_dynamic').innerHTML = '';
		// Empezar a buscar a partir de 3 letras:
		if (document.getElementById('filtraacademico').value.length < 3) return;
		// Crear un objeto XmlHttpRequest:
		var xmlHttp = XmlHttpRequest();
		// Función de atención a las petición HTTP:
		xmlHttp.onreadystatechange = function(){
			if (xmlHttp.readyState == 4) {
				document.getElementById('academico_dynamic').innerHTML = xmlHttp.responseText;
			}
		}
		// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
		xmlHttp.open("POST", "ft_ajax/lista_academicos.cfm", true);
		xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');

		// Crear la lista de parámetros:
		parametros = "vFiltraNombre=" + encodeURIComponent(document.getElementById('filtraacademico').value);
		parametros += "&vFt=" + encodeURIComponent(document.getElementById('vFt').value);
		// Enviar la petición HTTP:
		xmlHttp.send(parametros);
	}
--> */
	
	// Lista de academicos:
	// --------------------------------------------------------------------------------------------
	// NOTA: Es una versión más genérica que la fucnión anterior, permite asignar el campo (vCampo)
	//       de donde tomará el texto de búsqueda. Esta función podría sustituir a la anterior
	//       para conseguir código más ligero.
	// --------------------------------------------------------------------------------------------
	function fObtenerAcademicos(vTexto, vLista, vRegreso) 
	{
			// Ocultar la lista si no hay datos:
			if (document.getElementById(vTexto).value.length == 0) document.getElementById(vLista).innerHTML = '';
			// Empezar a buscar a partir de 3 letras:
			if (document.getElementById(vTexto).value.length < 3) return;
			// Crear un objeto XmlHttpRequest:
			var xmlHttp = XmlHttpRequest();
			// Función de atención a las petición HTTP:
			xmlHttp.onreadystatechange = function(){
				if (xmlHttp.readyState == 4) {
					document.getElementById(vLista).innerHTML = xmlHttp.responseText;
				}
			}
			// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
			xmlHttp.open("POST", "ft_ajax/lista_academicos.cfm", true);
			xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=utf-8');
			
			// Crear la lista de parámetros:
			parametros = "vTexto=" + encodeURIComponent(document.getElementById(vTexto).value);
			parametros += "&vFt=" + encodeURIComponent(document.getElementById('vFt').value);
			parametros += "&vRegreso=" + encodeURIComponent(vRegreso);
			// Enviar la petición HTTP:
			xmlHttp.send(parametros);
	}
	// Obtener días de licencia ocupados en el año:
	function ObtenerDiasLicencia()
	{
		// Verificar que exista el año de busqueda:
		if (document.getElementById('pos14').value.length < 10) return;
		// Crear un objeto XmlHttpRequest:
		var xmlHttp = XmlHttpRequest();
		// Función de atención a las petición HTTP:
		xmlHttp.onreadystatechange = function(){
			if (xmlHttp.readyState == 4) {
				document.getElementById('dias_licencia_dynamic').innerHTML = xmlHttp.responseText;
			}
		}
		// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
		xmlHttp.open("POST", "ft_ajax/licencia_dias.cfm", true);
		xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
		// Crear la lista de parámetros:
		parametros = "vAnio=" + encodeURIComponent(document.getElementById('pos14').value.substring(6,10));
		parametros += "&vIdAcad=" + encodeURIComponent(document.getElementById('pos2').value); //<!---parametros += "&vRfc=" + encodeURIComponent('<cfoutput>#vRfc#</cfoutput>');--->
		parametros += "&vIdSol=" + encodeURIComponent('<cfoutput>#vIdSol#</cfoutput>');
		// Enviar la petición HTTP:
		xmlHttp.send(parametros);
	}

	// Verificar si el académico tiene otra licencia/comision en proceso:
	function ObtenerTraslapeLicencia()
	{
		// Verificar que exista el año de busqueda:
		if (document.getElementById('pos14').value.length < 10 || document.getElementById('pos15').value.length < 10) return;
		// Crear un objeto XmlHttpRequest:
		var xmlHttp = XmlHttpRequest();
		// Función de atención a las petición HTTP:
		xmlHttp.onreadystatechange = function(){
			if (xmlHttp.readyState == 4) {
				document.getElementById('traslape_licencia_dynamic').innerHTML = xmlHttp.responseText;
			}
		}
		// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
		xmlHttp.open("POST", "ft_ajax/licencia_traslape.cfm", true);
		xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
		// Crear la lista de parámetros:
		parametros = "vFechaInicio=" + encodeURIComponent(document.getElementById('pos14').value);
		parametros += "&vFechaFinal=" + encodeURIComponent(document.getElementById('pos15').value);
		parametros += "&vIdAcad=" + encodeURIComponent(document.getElementById('pos2').value); //<!---parametros += "&vRfc=" + encodeURIComponent('<cfoutput>#vRfc#</cfoutput>');--->
		parametros += "&vIdSol=" + encodeURIComponent('<cfoutput>#vIdSol#</cfoutput>');
		// Enviar la petición HTTP:
		xmlHttp.send(parametros);
	}
	// Verificar si el académico tiene otra licencia/comision en proceso:
	function TieneContratoVigente()
	{
		// Verificar que exista el año de busqueda:
		if (document.getElementById('pos14').value.length < 10 || document.getElementById('pos15').value.length < 10) return;
		// Crear un objeto XmlHttpRequest:
		var xmlHttp = XmlHttpRequest();
		// Función de atención a las petición HTTP:
		xmlHttp.onreadystatechange = function(){
			if (xmlHttp.readyState == 4) {
				document.getElementById('contrato_vigente_dynamic').innerHTML = xmlHttp.responseText;
			}
		}
		// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
		xmlHttp.open("POST", "ft_ajax/contrato_vigente.cfm", true);
		xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
		// Crear la lista de parámetros:
		parametros = "vFechaInicio=" + encodeURIComponent(document.getElementById('pos14').value);
		parametros += "&vFechaFinal=" + encodeURIComponent(document.getElementById('pos15').value);
		parametros += "&vIdAcad=" + encodeURIComponent(document.getElementById('pos2').value);
		//parametros += "&vIdSol=" + encodeURIComponent('<cfoutput>#vIdSol#</cfoutput>');
		// Enviar la petición HTTP:
		xmlHttp.send(parametros);
	}
	// Obtener los contratos anteriores en una obra determinada:
	function ObtenerNoContratos()
	{
		// Crear un objeto XmlHttpRequest:
		var xmlHttp = XmlHttpRequest();
		// Función de atención a las petición HTTP:
		xmlHttp.onreadystatechange = function(){
			if (xmlHttp.readyState == 4) {
				document.getElementById('contratos_dynamic').innerHTML = xmlHttp.responseText;
			}
		}
		// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
		xmlHttp.open("POST", "ft_ajax/lista_contratos.cfm", true);
		xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
		// Crear la lista de parámetros:
		parametros = "&vIdAcad=" + encodeURIComponent(document.getElementById('pos2').value); //<!---parametros = "vRfc=" + encodeURIComponent(document.getElementById('vRFC').value);--->
		parametros += "&vCcnActual=" + encodeURIComponent(document.getElementById('pos8').value);
		parametros += "&vFt=" + encodeURIComponent(document.getElementById('vFt').value);		
		parametros += "&vActivaCampos=" + encodeURIComponent('<cfoutput>#vActivaCampos#</cfoutput>');
		parametros += "&vTipoComando=" + encodeURIComponent('<cfoutput>#vTipoComando#</cfoutput>');
		<!--- parametros += "&vNoPlaza=" + encodeURIComponent('<cfoutput>#vCampoPos9#</cfoutput>');--->
		parametros += "&vNoPlaza=" + encodeURIComponent(document.getElementById('pos9').value);
		parametros += "&vDepClave=" + encodeURIComponent('<cfoutput>#vCampoPos1#</cfoutput>');
		parametros += "&vProgramaClave=" + encodeURIComponent(document.getElementById('pos12').value);
		<!--- parametros += "&vIdSol=" + encodeURIComponent('<cfoutput>#vIdSol#</cfoutput>'); NOTA: EL CAMBIO ESTÁ EN DILEMA --->
		// Enviar la petición HTTP:
		xmlHttp.send(parametros);
	}

	// Verifica que proceda la solicitud de definitividad, se checa que al menos tenga tres años de antigüedad sin interrumpir:
	function ObtenerCcnDef()
	{
		// Crear un objeto XmlHttpRequest:
		var xmlHttp = XmlHttpRequest();
		// Función de atención a las petición HTTP:
		xmlHttp.onreadystatechange = function(){
			if (xmlHttp.readyState == 4) {
				document.getElementById('ccnactual_dynamic').innerHTML = xmlHttp.responseText;
			}
		}
		// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
		xmlHttp.open("POST", "ft_ajax/revisa_def_anios_ccn.cfm", true);
		xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
		// Crear la lista de parámetros:
		parametros = "&vIdAcad=" + encodeURIComponent(document.getElementById('pos2').value); //<!---parametros = "vRfc=" + encodeURIComponent(document.getElementById('vRFC').value); --->
		parametros += "&vFt=" + encodeURIComponent(document.getElementById('vFt').value);
		parametros += "&vCcnActual=" + encodeURIComponent(document.getElementById('pos3').value);
		parametros += "&vTipoContrato=" + encodeURIComponent('<cfoutput>#vCampoPos5#</cfoutput>');
		parametros += "&vFechaSolicitud=" + encodeURIComponent(document.getElementById('pos14').value);
		//parametros += "&vLlamado=" + encodeURIComponent(vLlamado);
		// Enviar la petición HTTP:
		xmlHttp.send(parametros);
	}	

	// Obtener el CCN de un asesor:
	function ObtenerCcnAsesor(vIdAcad)
	{
		// Crear un objeto XmlHttpRequest:
		var xmlHttp = XmlHttpRequest();
		// Función de atención a las petición HTTP:
		xmlHttp.onreadystatechange = function(){
			if (xmlHttp.readyState == 4) {
				document.getElementById('ccn_dynamic').innerHTML = xmlHttp.responseText;
			}
		}
		// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
		xmlHttp.open("POST", "ft_ajax/ccn_asesor.cfm", true);
		xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
		// Crear la lista de parámetros:
		parametros = "vIdAcad=" + encodeURIComponent(vIdAcad);
		// Enviar la petición HTTP:
		xmlHttp.send(parametros);
	}

	// Obtener las dependencias del subsistema seleccionado
	function fObtenerDepUnam()
	{
		// Crear un objeto XmlHttpRequest:
		//alert('HOLA'); 
		var xmlHttp = XmlHttpRequest();
		// Función de atención a las petición HTTP:
		xmlHttp.onreadystatechange = function(){
			if (xmlHttp.readyState == 4) {
				document.getElementById('depunam_dynamic').innerHTML = xmlHttp.responseText;
				if (document.getElementById('pos12_o').value == '03')
				{
					fObtenerUbicaSIC();
					document.getElementById('trUbicaDepAspira').style.display = '';
				}
				else
				{
					document.getElementById('trUbicaDepAspira').style.display = 'none';
				}
			}
		}
		// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
		xmlHttp.open("POST", "ft_ajax/lista_dep_unam.cfm", true);
		xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');		
		// Crear la lista de parámetros:
		parametros = "vSubsistema=" + encodeURIComponent(document.getElementById('pos12_o').value); 
		parametros += "&vActivaCampos=" + encodeURIComponent('<cfoutput>#vActivaCampos#</cfoutput>');
		parametros += "&vCampoPos11=" + encodeURIComponent('<cfoutput>#vCampoPos11#</cfoutput>'); 		
		// Enviar la petición HTTP:
		xmlHttp.send(parametros);
	}	
	// Obtener la ubicacion de la dependencia destino (solo SIC)
	function fObtenerUbicaSIC()
	{
		// Crear un objeto XmlHttpRequest:
		var xmlHttp = XmlHttpRequest();
		// Función de atención a las petición HTTP:
		xmlHttp.onreadystatechange = function(){
			if (xmlHttp.readyState == 4) {
				document.getElementById('ubicasic_dynamic').innerHTML = xmlHttp.responseText;
                //alert(document.getElementById('pos11_u').value)
			}
		}
		// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
		xmlHttp.open("POST", "ft_ajax/lista_dep_ubica.cfm", true);
		xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');		
		// Crear la lista de parámetros:
		parametros = "vPos11=" + encodeURIComponent(document.getElementById('pos11').value); 
		parametros += "&vCampopos11_u=" + encodeURIComponent('<cfoutput>#vCampopos11_u#</cfoutput>'); 
		parametros += "&vActivaCampos=" + encodeURIComponent('<cfoutput>#vActivaCampos#</cfoutput>');
		// Enviar la petición HTTP:
		xmlHttp.send(parametros);
	}
/*
	// Desplegar la lista de movimientos del académico:
	function fListarMovimientos(vPagina, vOrden, vOrdenDir)
	{
		if (document.getElementById('pos2').value != '')
		{
			$('#ListaMovimientos').activity();
			// Crear un objeto XmlHttpRequest:
			var xmlHttp = XmlHttpRequest();
			// Función de atención a las petición HTTP:
			xmlHttp.onreadystatechange = function(){
				if (xmlHttp.readyState == 4) {
					document.getElementById('ListaMovimientos').innerHTML = xmlHttp.responseText;
					$('#ListaMovimientos').activity(false);
				}
			}
			// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
			xmlHttp.open("POST", "<cfoutput>#Application.vCarpetaRaiz#/sistema_ctic/movimientos/consultas/movimientos_academico_emergente.cfm</cfoutput>", true);
			xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
			// Crear la lista de parámetros:
			parametros = "vIdAcad=" + encodeURIComponent(document.getElementById('pos2').value);
			parametros += "&vPagina=" + vPagina;
			parametros += "&vOrden=" + encodeURIComponent(vOrden);
			parametros += "&vOrdenDir=" + encodeURIComponent(vOrdenDir);
			// Enviar la petición HTTP:
			xmlHttp.send(parametros);
		}
	}
*/	
</script>