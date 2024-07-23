<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO DURAN --->
<!--- FECHA CREA: 27/11/2015 --->
<!--- FECHA �LTIMA MOD.: 27/11/2015 --->

<!--- FUNCIONES DE VALIDACI�N DE CAMPOS --->

	function fListaSeleccionAcademicoSus()
	{
		// Solo obtener la lista de acad�micos si hay m�s de tres letras tecleadas:
		if (document.getElementById('vNomAcadSus').value.length <= 3) return;
	// Crear un objeto XmlHttpRequest:
		var xmlHttp = XmlHttpRequest();
		// Funci�n de atenci�n a las petici�n HTTP:
		xmlHttp.onreadystatechange = function(){
			if (xmlHttp.readyState == 4) {
				document.getElementById('lstAcadSus_dynamic').innerHTML = xmlHttp.responseText;
			}
		}
		// Generar una petici�n HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
		xmlHttp.open("POST", "../../comun/seleccion_academico_comision.cfm", true);
		xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
		// Crear la lista de par�metros:
		parametros = "vTexto=" + encodeURIComponent(document.getElementById('vNomAcadSus').value);
		// Enviar la petici�n HTTP:
		xmlHttp.send(parametros);
	}
	
	function fSeleccionAcademicoSus()
	{
		// Registrar la clave y el nombre del acad�mico seleccionado:
		document.getElementById('vSelAcadSus').value = document.getElementById('lstAcadSus').value;
		document.getElementById('vNomAcadSus').value = document.getElementById('lstAcadSus').options[document.getElementById('lstAcadSus').selectedIndex].text;
		document.getElementById('lstAcadSus_dynamic').innerHTML = '';
	}

	// FUNCI�N PARA DIRECCIONAR LA ACCION DE LOS BOTONES:
	function fSubmitFormulario(vComandoSel)
	{
		var ValidaOK = true; // El valor predeterminado de la validaci�n es VERDADERO;
		if (vComandoSel == 'EDITA')
		{
			document.getElementById('vTipoComando').value = 'EDITA'
			document.forms[0].method = 'get';	
			document.forms[0].action = 'miembro_caaa.cfm';
			document.forms[0].submit();
		}
		if (vComandoSel == 'GUARDA')
		{
			if (fValidaCamposMiembrosComision) ValidaOK = fValidaCamposMiembrosComision();
			if (ValidaOK)
			{
				document.forms[0].action = 'miembro_caaa_guarda.cfm';
				document.forms[0].submit();
			}
		}
		if (vComandoSel == 'ELIMINAR')
		{
			if (confirm('�Desea eliminar el registro?'))
			{
				document.getElementById('vTipoComando').value = 'ELIMINAR'
				document.forms[0].action = 'miembro_caaa_guarda.cfm';
				document.forms[0].submit();
			}
		}
		if (vComandoSel == 'CANCELA')
		{
			window.history.go(-1);
		}
		if (vComandoSel == 'REGRESA')	
		{
			window.location = 'miembros_caaa_lista.cfm';
		}
	}
	// FUNCI�N PARA VALIDAR LOS CAMPOS DEL FORMULARIO:
	function fValidaCamposMiembrosComision()
	{
		var vOk;
		var vMensaje = '';
		fLimpiaValida();
		if (document.getElementById("vAcadNom").value == '' || document.getElementById("vSelAcad").value == '')
		{
			document.getElementById("vAcadNom").style.backgroundColor = '#FF3300'
			vMensaje += 'Campo: ACAD�MICO es requerido.\n'
		}			
		vMensaje += fValidaCampoLleno('comision_clave','COMISI�N');
		vMensaje += fValidaCampoLleno('fecha_inicio','FECHA DE INICIO');
		vMensaje += fValidaFecha('fecha_inicio','FECHA DE INICIO');
		if (document.getElementById("sustitucion").checked == true)
		{
			vMensaje += fValidaCampoLleno('ssn_id','PARA LA SESI�N');
			if (document.getElementById("vNomAcadSus").value == '' || document.getElementById("vSelAcadSus").value == '')
			{
				document.getElementById("vNomAcadSus").style.backgroundColor = '#FF3300'
				vMensaje += 'Campo: EN SUSTITUCI�N DE es requerido.\n'
			}			
		}			
		if (vMensaje.length > 0) 
		{
			alert(vMensaje);
			return false;
		}
		else
		{
			return true;
		}
	}
	function fSustitucionTmp()
	{
		if (document.getElementById("sustitucion").checked == true)
		{
//					alert('SI')
			document.getElementById("trSesion").style.display= '';
		}
		else
		{
//					alert('NO')
			document.getElementById("trSesion").style.display= 'none';
		}
	}
	function fDesplegable(vTipo, vAccion)
	{
		if (vTipo == 'SESIONES')
		{
			if (vAccion == 0)
			{
				document.getElementById('dSesiones').style.display = 'none';
				document.getElementById('bSesiones').innerHTML = "<img src=\"<cfoutput>#vCarpetaIMG#</cfoutput>/ir_abajo_15.jpg\" style=\"border:none;\" onclick=\"fDesplegable('SESIONES',1);\">";
			}
			else
			{
				document.getElementById('dSesiones').style.display = '';
				document.getElementById('bSesiones').innerHTML = "<img src=\"<cfoutput>#vCarpetaIMG#</cfoutput>/ir_arriba_15.jpg\" style=\"border:none;\" onclick=\"fDesplegable('SESIONES',0);\">";
			}
		}
		if (vTipo == 'CORREO')
		{
			if (vAccion == 0)
			{
				document.getElementById('dCorreo').style.display = 'none';
				document.getElementById('bCorreo').innerHTML = "<img src=\"<cfoutput>#vCarpetaIMG#</cfoutput>/ir_abajo_15.jpg\" style=\"border:none;\" onclick=\"fDesplegable('CORREO',1);\">";
			}
			else
			{
				document.getElementById('dCorreo').style.display = '';
				document.getElementById('bCorreo').innerHTML = "<img src=\"<cfoutput>#vCarpetaIMG#</cfoutput>/ir_arriba_15.jpg\" style=\"border:none;\" onclick=\"fDesplegable('CORREO',0);\">";
			}
		}
	}

