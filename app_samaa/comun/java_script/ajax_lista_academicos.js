<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO DURAN --->
<!--- FECHA CREA: 26/11/2015 --->
<!--- FECHA ULTIMA MOD.: 26/11/2015 --->
<!--- FUNCIONES GLOBALES PARA DESPELGAR Y SELECCIONAR UN ACADÉMICO POR MEDIOD E AJAX --->

// Obtener la lista de académicos:
function fListaSeleccionAcademico(vTipoBusq)
{
	//alert(document.getElementById('vAcadNom').value.length);
	// Ocultar la lista si no hay datos:
	if (document.getElementById('vAcadNom').value.length == 0 || document.getElementById('vAcadRfc').value.length == 0 || document.getElementById('vAcadId').value.length == 0) document.getElementById('lstAcad_dynamic').innerHTML = ''; 
	// Solo obtener la lista de académicos si hay más de 3 letras tecleadas:
	if (document.getElementById('vAcadNom').value.length <= 3 && vTipoBusq == 'NAME') return;
	if (document.getElementById('vAcadRfc').value.length <= 4 && vTipoBusq == 'RFC') return;
	if (document.getElementById('vAcadId').value.length <= 1 && vTipoBusq == 'CLAVE') return;
	// Crear un objeto XmlHttpRequest:
	var xmlHttp = XmlHttpRequest();
	// Función de atención a las petición HTTP:
	xmlHttp.onreadystatechange = function(){
		if (xmlHttp.readyState == 4) {
			document.getElementById('lstAcad_dynamic').innerHTML = xmlHttp.responseText;
		}
	}
	// Generar una petición HTTP: (Cambié el charset de iso-8859-1 a utf-8 para que pasen las letras Ñ-ñ))
	xmlHttp.open("POST", document.getElementById('vLigaAjax').value, true);
	xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=utf-8');
	// Crear la lista de parámetros:
	if (vTipoBusq == 'NAME') { parametros = "vTexto=" + encodeURIComponent(document.getElementById('vAcadNom').value); }
	if (vTipoBusq == 'RFC') { parametros = "vTexto=" + encodeURIComponent(document.getElementById('vAcadRfc').value); }
	if (vTipoBusq == 'CLAVE') { parametros = "vTexto=" + encodeURIComponent(document.getElementById('vAcadId').value); }
	parametros += "&vTipoBusq=" + vTipoBusq;
	// Enviar la petición HTTP:
	xmlHttp.send(parametros);
}

//Al seleccionar al académico de los resultados que despliega el "SELECT" envía estos datos a los elementos del formulario
function fSeleccionAcademico()
{
	// Registrar la clave y el nombre del académico seleccionado:
	document.getElementById('vSelAcad').value = document.getElementById('lstAcad').value;
	document.getElementById('vAcadId').value = document.getElementById('lstAcad').value;
	document.getElementById('vAcadNom').value = document.getElementById('lstAcad').options[document.getElementById('lstAcad').selectedIndex].text;
	document.getElementById('lstAcad_dynamic').innerHTML = '';
}

function fBorrarParametros()
{
	document.getElementById('vAcadId').value = '';
	document.getElementById('vAcadNom').value = '';
	document.getElementById('vSelAcad').value = '';
	document.getElementById('vAcadRfc').value = '';
}