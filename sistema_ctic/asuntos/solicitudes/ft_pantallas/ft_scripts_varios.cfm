<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA: 17/04/2009 --->
<!--- Funciones javascript utilizadas por las FT --->

<script type="text/javascript" language="JavaScript">
	
	<!-- CREADO: JOSÉ ANTONIO ESTEVA -->
	<!-- EDITO: JOSÉ ANTONIO ESTEVA -->
	<!-- FECHA: 15/04/2009 -->
	<!-- FUNCION QUE PARA PONER CAMPOS VISIBLES O INVISIBLES -->
	
	// 	Versión javascript de la función trim() que existe en otros lenguajes:
	String.prototype.trim = function() 
	{
		a = this.replace(/^\s+/, '');
		return a.replace(/\s+$/, '');
	};
	
	// Mostrar elemento HTML:
	function show(tag) 
	{
		if (document.getElementById(tag)) document.getElementById(tag).style.display = '';
	}
	// Eliminar elemento HTML:
	function hide(tag) 
	{
		if (document.getElementById(tag))	document.getElementById(tag).style.display = 'none';
	}
	
	<!-- CREADO: JOSE ANTONIO ESTEVA -->
	<!-- EDITO: JOSE ANTONIO ESTEVA -->
	<!-- FECHA: 15/04/2009 -->
	<!-- FUNCION PARA CAMBIAR EL TEXTO DE UN ELEMENTO HTML -->
	
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
	
	<!-- CREADO: JOSE ANTONIO ESTEVA--->
	<!-- EDITO: JOSE ANTONIO ESTEVA--->
	<!-- FECHA: 24/03/2009--->
	<!-- FUNCION QUE CALCULA LA FECHA FINAL EN DURACIÓN--->
	
	function CalcularSiguienteFecha()
	{
		var dia;
		var mes;
		var ano;
		// Verificar que haya una fecha con que trabajar:
		if (document.getElementById("pos14").value == '')
		{
			return;
		}
		else
		{
			dia = document.getElementById("pos14").value.substring(0,2);
			mes = document.getElementById("pos14").value.substring(3,5);
			ano = document.getElementById("pos14").value.substring(6,10);
//			alert(dia + ' ' + mes + ' ' + ano)
		}
		// Crear un objeto tipo date:
		ff = new Date(ano, mes-1, dia);
		// Sumar años:
		if (document.getElementById("pos13_a"))
		{
			if (document.getElementById("pos13_a").value > 0)
			{
				if (('' + ff.getYear()).length < 4) aa = ff.getYear() + 1900; else aa = ff.getYear();
				ff.setYear(aa + parseInt(document.getElementById("pos13_a").value));
			}
		}	
		// Sumar meses:
		if (document.getElementById("pos13_m"))
		{
			if (document.getElementById("pos13_m").value > 0)
			{
				ff.setMonth(ff.getMonth() + parseInt(document.getElementById("pos13_m").value));
//				alert(ff.setMonth)
			}
		}	
		// Sumar días:
		if (document.getElementById("pos13_d"))	
		{
			
			if (document.getElementById("pos13_d").value > 0) 
			{
				ff.setDate(ff.getDate() + parseInt(document.getElementById("pos13_d").value));
			}
		}	
		// Restar un día a la fecha obtenida:
		ff.setDate(ff.getDate() - 1);
		
		// TEMPORAL -->
		if (document.getElementById("pos15_temp")) document.getElementById("pos15_temp").value = dateFormat(ff);
		// <-- TEMPORAL
		
		// Actualizar el siguiente campo:
		document.getElementById("pos15").value = dateFormat(ff);
	}
	
	<!-- CREADO: JOSE ANTONIO ESTEVA -->
	<!-- EDITO: JOSE ANTONIO ESTEVA -->
	<!-- FECHA: 04/06/2009 -->
	<!-- FUNCION QUE CALCULA LA FECHA DADAS UNA FECHA INICIAL, AÑOS, MESES Y DÍAS --->
	<!-- Esta función general podría sustituir a la anterior cambiando un poco el codigo de las FT que la utilizan -->
	
	function CalcularSiguienteFecha2(fi, aa, mm, dd)
	{
		// Verificar que haya una fecha válida con la cual trabajar:
		if (document.getElementById(fi).value.length == 10)
		{
			dia = document.getElementById(fi).value.substring(0,2);
			mes = document.getElementById(fi).value.substring(3,5);
			ano = document.getElementById(fi).value.substring(6,10);
		}
		else
		{
			return "";
		}
		// Convertir los valores que se van a sumar a "entero":
		aa = parseInt(aa);
		mm = parseInt(mm);
		dd = parseInt(dd);
		// Crear un objeto tipo date:
		ff = new Date(ano, mes-1, dia);
		// Sumar años:
		if (aa > 0)
		{
			if (('' + ff.getYear()).length < 4) aaa = ff.getYear() + 1900; else aaa = ff.getYear();
			ff.setYear(aaa + aa);
		}
		// Sumar meses:
		if (mm > 0)
		{
			ff.setMonth(ff.getMonth() + mm);
		}
		// Sumar días:
		if (dd > 0) 
		{
			ff.setDate(ff.getDate() + dd);
		}
		// Restar un día a la fecha obtenida:
		ff.setDate(ff.getDate() - 1);
		
		// Regresar la fecha obtenida (con formato):
		return dateFormat(ff);
	}
	
	function dateFormat(dd)
	{
		var dia = '00' + dd.getDate();
		var mes = '00' + (dd.getMonth() + 1);
		// Obtener el año de la fecha:
		if (('' + dd.getYear()).length < 4) aa = dd.getYear() + 1900; else aa = dd.getYear();
		// Regresar la fecha en formato "dd/mm/aaaa":
		return dia.substring(dia.length - 2) + '/' + mes.substring(mes.length - 2) + '/' + aa;
	}
	
	<!-- CREADO: JOSE ANTONIO ESTEVA--->
	<!-- EDITO: JOSE ANTONIO ESTEVA--->
	<!-- FECHA: 24/03/2009--->
	<!-- FUNCION PARA APLICAR MASCASAR DE ENTRADA --->
	
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

	<!-- CREADO: JOSE ANTONIO ESTEVA--->
	<!-- EDITO: JOSE ANTONIO ESTEVA--->
	<!-- FECHA: 23/09/2009--->
	
	// FUNCION PARA MOSTRAR LA LISTA DE ERRORES EN UNA VENTANA PERSONALIZADA, UTILIZA El ARCHIVO FT_ERRORES.CFM:
	function MostrarErrores(vMensaje) 
	{
		vListaErrores = "<ul class='ArialAltas10N'><li>";
		vListaErrores += vMensaje.replace(/\n/gi, "</li><li>");
		vListaErrores = vListaErrores.substring(0,vListaErrores.length-5);
		vListaErrores += "</ul>";
	   	window.open("ft_errores.cfm?vListaErrores=" + encodeURIComponent(vListaErrores), "_blank", 'width=620,height=500,resizable=yes,scrollbars=yes,directories=no,location=no,menubar=no,status=no,titlebar=yes,toolbar=no,modal=yes');
	 }

	<!-- CREADO: JOSE ANTONIO ESTEVA--->
	<!-- EDITO: JOSE ANTONIO ESTEVA--->
	<!-- FECHA: 24/03/2009--->
	<!-- FUNCION PARA PREPARAR LA FT PARA IMPRESIÓN --->
	 
	function PrepararImpresion()
	{
		// Reemplazar los controles TEXT y TEXTAREA por un SPAN (para evitar que se trunquen los datos):
		c = 0
		while (c < document.forms['formFt'].elements.length)
		{
			// Habilitar el campo para que no aparezca en gris:
			if (parent.document.forms['formFt'].elements[c].type != 'hidden') parent.document.forms['formFt'].elements[c].disabled = false;
			
			// Reemplazar los campos "text" y "textarea" por un "span" para evitar que se trunquen los datos. 
			if (document.forms['formFt'].elements[c].type == 'text' || document.forms['formFt'].elements[c].type == 'textarea') 
			{
				var cInput = document.forms['formFt'].elements[c];
				var cSpan = document.createElement("span");
				// Crear un SPAN con el contenido original:
				cSpan.className = "Sans9Gr";
				cSpan.innerHTML = document.forms['formFt'].elements[c].value;
				// Remplazar el control anterior por el nuevo control:
				cInput.parentNode.replaceChild(cSpan, cInput);
			}
			else
			{
				c++;
			}
		}
	}

	<!-- CREADO: CHRIS HOGBEN --->
	<!-- EDITO: JOSE ANTONIO ESTEVA --->
	<!-- FUNCION PARA PREPARAR VALIDAR QUE UNA FECHA EXISTA --->
	function ValidarFecha(Fecha){
	
		var day;	
		var month;
		var year;
		
		// Vefificar que la fecha se haya capturado en su totalidad -->
		if (MyDate.length != 10) return false;
		
		// Desglosar la fecha para analizarla -->
		day = eval(MyDate.substring(0,2));	
		month = eval(MyDate.substring(3,5) - 1);	// <-- En javascript Enero=0 y Diciembre=11
		year = eval(MyDate.substring(6,10));
		
		// Validar que la fecha realmente exista -->
		dteDate = new Date(year,month,day);
		return ((day==dteDate.getDate()) && (month==dteDate.getMonth()) && (year==dteDate.getFullYear()));
	
	} // validarFecha
	
	<!-- CREADO: JOSE ANTONIO ESTEVA--->
	<!-- EDITO: JOSE ANTONIO ESTEVA--->
	<!-- FECHA: 28/10/2010--->

	// Prellenar y bloquear el campo CIUDAD al detectar MEXICO-DISTRITO FEDERAL:
	function fDetectarDF(vEstado)
	{
		if (document.getElementById('pos11_c'))
		{
			if (vEstado == 'DF') 
			{
				document.getElementById('pos11_c').value = 'MEXICO';
				document.getElementById('pos11_c').disabled = true;
			}
			else
			{
				document.getElementById('pos11_c').value = '';
				document.getElementById('pos11_c').disabled = false;
			}
		}	
	}
	
</script>