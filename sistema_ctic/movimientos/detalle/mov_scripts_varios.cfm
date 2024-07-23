<!--- CREADO: JOSE ANTONIO ESTEVA --->
<!--- EDITO: JOSE ANTONIO ESTEVA --->
<!--- FECHA: 18/05/2011 --->
<!--- Funciones javascript utilizadas por las FT --->

<script type="text/javascript" src="<cfoutput>#vCarpetaLIB#</cfoutput>/jquery-1.5.1.min.js"></script>
<script type="text/javascript" src="<cfoutput>#vCarpetaLIB#</cfoutput>/jquery-ui-1.8.12.custom.min.js"></script>
<script type="text/javascript" src="<cfoutput>#vCarpetaLIB#</cfoutput>/jquery.activity-indicator-1.0.0.min.js"></script>

<script type="text/javascript" language="JavaScript">
	
	// CREADO: JOSÉ ANTONIO ESTEVA 
	// EDITO: JOSÉ ANTONIO ESTEVA 
	// FECHA: 15/04/2009 
	// FUNCION QUE PARA PONER CAMPOS VISIBLES O INVISIBLES 
	
	// 	Versión javascript de la función trim() que existe en otros lenguajes:
	String.prototype.trim = function() 
	{
		a = this.replace(/^\s+/, '');
		return a.replace(/\s+$/, '');
	};
	
	// Mostrar elemento HTML:
	function show(tag) 
	{
		document.getElementById(tag).style.display = '';
	}
	// Eliminar elemento HTML:
	function hide(tag) 
	{
		document.getElementById(tag).style.display = 'none';
	}
	
	// CREADO: JOSE ANTONIO ESTEVA 
	// EDITO: JOSE ANTONIO ESTEVA 
	// FECHA: 15/04/2009 
	// FUNCION PARA CAMBIAR EL TEXTO DE UN ELEMENTO HTML 
	
	// Cambiar el texto interior de un elemento HTML:
	function changeText(tag, texto)
	{
		document.getElementById(tag).innerHTML = texto;
	}
	
	// Limipar el contenido de un campo:
	function clean(tag, texto)
	{
		try
		{
			document.getElementById(tag).value = null;
		}
		catch (err)
		{
			document.getElementById(tag).value = '';
		}
	}
	
	
	// CREADO: JOSÉ ANTONIO ESTEVA 
	// EDITO: JOSÉ ANTONIO ESTEVA 
	// FECHA: 09/05/2009 
	// FUNCION QUE VALIDA QUE UNA FECHA EXISTA Y SEA CORRECTA 

	function fValidaFecha(tag, desc)
	{
		var	vDia;
		var	vMes;
		var	vAno;
		var	vF;
		// Verificar que el campo que se quiere validar exista:
		if (!document.getElementById(tag)) return "El campo: " + desc.toUpperCase() + " no existe.\n";
		// Verificar que el campo esté completamente lleno:
		if (document.getElementById(tag).value.length != 10) return "La fecha: " + desc.toUpperCase() + " es incorrecta.\n";
		// Verificar si se puede generar una fecha con los datos del campo:
		try
		{
			vDia = document.getElementById(tag).value.substring(0,2);
			vMes = document.getElementById(tag).value.substring(3,5);
			vAno = document.getElementById(tag).value.substring(6,10);
			vF = new Date(vAno, vMes-1, vDia);
		}
		catch (err)
		{
			document.getElementById(tag).style.backgroundColor = '#FC8C8B'
			return "No se ha ingresado completa la fecha: " + desc.toUpperCase() + ".\n";
		}
		// Validar que la fecha ingresada sea la misma que la generada...
		if (vF.getDate() != vDia || vF.getMonth() + 1 != vMes || vF.getFullYear() != vAno)
		{	
			return "La fecha: " + desc.toUpperCase() + " es incorrecta.\n";
		}
		return '';
	}
	
	<!----------------------------------------------------------------------------->
	<!--- DESHABILITADO DESHABILITADO DESHABILITADO DESHABILITADO DESHABILITADO --->
	<!----------------------------------------------------------------------------->
	<!---
	// Ventana de dialogo para mostrar la forma telegrámica asociada:
	$(function() {
		$('#dialog:ui-dialog').dialog('destroy');
		$('#FormaTelegramica').dialog({
			autoOpen: false,
			height: 'auto',
			width: 700,
			show: 'slow',
			modal: false,
			open: function() {
	        	fMostrarSolicitud($('#sol_id').val());
	        }
		});
	});

	// CREADO: JOSE ANTONIO ESTEVA-
	// EDITO: JOSE ANTONIO ESTEVA-
	// FECHA: 24/03/2009-
	// FUNCION PARA APLICAR MASCASAR DE ENTRADA -
	
	function MascaraEntrada(e, mascara) 
	{
		var codigo;
		var origen;
		var posicion;
		var filtro;
		// Acceso a objeto de evento:
		if (!e) var e = window.event;
		// Detectar el objeto que originó el evento: 
		if (e.target) origen= e.target;
		else if (e.srcElement) origen = e.srcElement;
		if (origen.nodeType == 3) origen = targ.parentNode;
		// Obtener el código de la tecla oprimida:
		if (e.keyCode) codigo = e.keyCode;
		else if (e.which) codigo = e.which;
		// Dejar pasar teclas para borrar y saltar al siguiente campo (pueden ser más):
		if (codigo == 8 || codigo == 9 || codigo == 46) return true;
		// Obtener la posición donde se está capturando y su máscara correspondiente: 
		posicion = origen.value.length;
		// Si en la posición actual hay un delimitador agregarlo a la cadena y pasar a la siguiente posición:
		filtro = mascara.charAt(posicion);
		if (filtro!='9' && filtro!='A')
		{
		   origen.value += filtro; 
		   posicion++;
		   filtro = mascara.charAt(posicion); 
		} 
		// Verificar si el carácter tecleado corresponde a la máscara:
		if (filtro == "9" && (codigo >= 48 && codigo <= 57)) return true; 										// Número
		if (filtro == "A" && ((codigo >= 65 && codigo <= 90) || (codigo >= 97 && codigo <= 122))) return true; 	// Letra
		// Sino, no pasa!
		return false;	 
	}

	--->
	   		
</script>