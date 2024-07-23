<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO DURAN --->
<!--- FECHA CREA: 26/11/2015 --->
<!--- FECHA ULTIMA MOD.: 10/11/2017 --->
<!--- FUNCIONES GLOBALES PARA DESPELGAR Y SELECCIONAR UN ACAD�MICO POR MEDIO DE AJAX / JQUERY --->


function fTeclas(){
	//comienza la cuenta regresiva
	var typingTimer;                //timer identifier
	
	if (!e) var e = window.event;
	if (e.keyCode) codigo = e.keyCode;
	else if (e.which) codigo = e.which;
	if (codigo==17) {/*alert(codigo) Si la tecla pulsada es CTRL enconces no mando la consulta, ya que fue usada para pegar un texto y me interesa la consulta del texto no de CTRL*/
	}else{
	
			if (typingTimer) clearTimeout(typingTimer);                 // Borrar si ya est� configurado    
				typingTimer = setTimeout(fListaSeleccionAcademico('NAME'), 1500);
			// en keydown, borre la cuenta regresiva
			$('#vAcadNom').keydown(function(){
				clearTimeout(typingTimer);
			});
	}
}

// Obtener la lista de acad�micos:
function fListaSeleccionAcademico(vTipoBusq)
{
	// Ocultar la lista si no hay datos:
	if (document.getElementById('vAcadNom').value.length == 0 || document.getElementById('vAcadRfc').value.length == 0 || document.getElementById('vAcadId').value.length == 0) 
		document.getElementById('lstAcad_dynamic').innerHTML = ''; 
	// Solo obtener la lista de acad�micos si hay m�s de 3 letras tecleadas:
	if (document.getElementById('vAcadNom').value.length <= 3 && vTipoBusq == 'NAME') return;
	if (document.getElementById('vAcadRfc').value.length <= 4 && vTipoBusq == 'RFC') return;
	if (document.getElementById('vAcadId').value.length <= 1 && vTipoBusq == 'CLAVE') return;
	// Crear un objeto XmlHttpRequest:
	var xmlHttp = XmlHttpRequest();
	// Funci�n de atenci�n a las petici�n HTTP:
	xmlHttp.onreadystatechange = function(){
		if (xmlHttp.readyState == 4) {
			//alert(document.getElementById('vAcadNom').value);
			document.getElementById('lstAcad_dynamic').innerHTML = xmlHttp.responseText;
		}
	}
	// Generar una petici�n HTTP: (Cambi� el charset de iso-8859-1 a utf-8 para que pasen las letras �-�))
	xmlHttp.open("POST", document.getElementById('vLigaAjax').value, true);
	xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=utf-8');
	// Crear la lista de par�metros:
	if (vTipoBusq == 'NAME') { parametros = "vTexto=" + encodeURIComponent(document.getElementById('vAcadNom').value); }
	if (vTipoBusq == 'RFC') { parametros = "vTexto=" + encodeURIComponent(document.getElementById('vAcadRfc').value); }
	if (vTipoBusq == 'CLAVE') { parametros = "vTexto=" + encodeURIComponent(document.getElementById('vAcadId').value); }
	parametros += "&vTipoBusq=" + vTipoBusq;
	// Enviar la petici�n HTTP:
	xmlHttp.send(parametros);
}

//Al seleccionar al acad�mico de los resultados que despliega el "SELECT" env�a estos datos a los elementos del formulario
function fSeleccionAcademico()
{
	// Registrar la clave y el nombre del acad�mico seleccionado:
	if (document.getElementById('vSelAcad'))
		document.getElementById('vSelAcad').value = document.getElementById('lstAcad').value;
	if(document.getElementById('vAcadId'))
		document.getElementById('vAcadId').value = document.getElementById('lstAcad').value;
	if(document.getElementById('vAcadNom'))
		document.getElementById('vAcadNom').value = document.getElementById('lstAcad').options[document.getElementById('lstAcad').selectedIndex].text;

	document.getElementById('lstAcad_dynamic').innerHTML = '';
	document.getElementById('lstAcad_dynamic').style.display = 'none';

	//ESTA OPCI�N PERMITE EJECUTAR UNA FUNCI�N S�LO EN EL M�DULO DE /estimulos_dgapa/
	if (window.location.pathname.indexOf("/estimulos_dgapa/") > 0)
	{
		$('#vCuentaIntervalo').val($('#vAcadNom').val().length)
		fAgregaAcdEst();
	}
}

function fBorrarParametros()
{
	document.getElementById('vAcadId').value = '';
	document.getElementById('vAcadNom').value = '';
	document.getElementById('vSelAcad').value = '';
	document.getElementById('vAcadRfc').value = '';
	document.getElementById('lstAcad_dynamic').innerHTML = ''; 
}


function fTeclasBS(){
	//comienza la cuenta regresiva
	var typingTimer;                //timer identifier
	
	if (!e) var e = window.event;
	if (e.keyCode) codigo = e.keyCode;
	else if (e.which) codigo = e.which;
	if (codigo==17) {/*alert(codigo) Si la tecla pulsada es CTRL enconces no mando la consulta, ya que fue usada para pegar un texto y me interesa la consulta del texto no de CTRL*/
	}else{
	
		if (typingTimer) clearTimeout(typingTimer);                 // Borrar si ya est� configurado    
			typingTimer = setTimeout(fBuscaAcademicoNombre(), 5000);
		// en keydown, borre la cuenta regresiva
		$('#vAcadNom').keydown(function(){
			clearTimeout(typingTimer);
		});
	}
}

 // ************ USANDO JQUERY ***************
function fBuscaAcademicoNombre()
{
	//alert($('#vAcadNom').val().length);
	if ($('#vAcadNom').val().length = 0)
	{
		$("#lstAcad_dynamic").html('');
		if (window.location.pathname.indexOf("/estimulos_dgapa/") > 0)
			$("#agrega_acdest_dynamic").html('');
	}
		if (window.location.pathname.indexOf("/estimulos_dgapa/") > 0)
		{vAcdActivo = 1;}
		else
		{vAcdActivo = 0;}
	//if ($('#vAcadNom').val().length <= 5) return;
	//if (event.keyCode  == '13' || event.which == '13')
		$.ajax({
			async: false,
			method: "POST",
			data: {vTexto: $('#vAcadNom').val(),vTipoBusq:"NAME",vCss:"OTRO",vpAcdActivo:vAcdActivo},
			url: $('#vUrlSelAcad').val(),
			success: function(data) {
				$("#lstAcad_dynamic").html(data);
			},
			error: function(data) {
				alert('ERROR AL DESPELGAR LA INFORMACI�N');
				//location.reload();
			}
		});
}