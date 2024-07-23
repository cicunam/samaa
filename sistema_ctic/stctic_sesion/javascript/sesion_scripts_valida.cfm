<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: JOSE ANTONIO ESTEVA --->
<!--- FECHA: 12/05/2009 --->
<!--- FUNCIONES DE VALIDACI�N DE CAMPOS --->

<script type="text/javascript">

	<!-- CREADO: ARAM PICHARDO -->
	<!-- EDITO: ARAM PICHARDO -->
	<!-- FECHA: 12/05/2009 -->
	<!-- FUNCION QUE LIMPIA LOS CAMPOS VALIDADOS Y MARCADOS EN COLOR  -->

	function fLimpiaValida()
	{
		// TEMPORAL: Mientras encontramos como marcar RADIO y CHECKBOX:
		if (document.getElementById('lista_destinos_enc')) document.getElementById('lista_destinos_enc').style.background = '#FFFFFF';
		
		for (c=0; c<document.forms[0].elements.length; c++)
		{
			if (document.forms[0].elements[c].type != 'hidden') document.forms[0].elements[c].style.background = '#FFFFFF';
			if (document.forms[0].elements[c].type != 'hidden' && (document.forms[0].elements[c].type == 'radio' || document.forms[0].elements[c].type == 'checkbox')) document.forms[0].elements[c].style.background = '#FFFFFF';
		}
	}

	function fValidaHoras(vHoras, vMensajesHoras, vFtHoras)
	{
		var vSumaHoras;

		if (vFtHoras == 'F1')
		{
			vSumaHoras = parseFloat(document.getElementById("pos16").value=='' ? "0" : document.getElementById('pos16').value) + parseFloat(document.getElementById("pos17").value=='' ? "0" : document.getElementById('pos17').value);
		}
		else if (vFtHoras == 'F6')
		{
			vSumaHoras = parseFloat(document.getElementById("pos16").value=='' ? "0" : document.getElementById('pos16').value);
		}

		if (vSumaHoras == 0)
		{
			document.getElementById("pos16").style.backgroundColor = '#FF3300';

			if (vFtHoras == 'F1') return 'Campo: N�MERO DE HORAS es obligatorio.\n';			
		}
		else if (vSumaHoras > vHoras)
		{
			document.getElementById("pos16").style.backgroundColor = '#FF3300';
			if (vFtTemp == '1') document.getElementById("pos17").style.backgroundColor = '#FF3300';
			document.getElementById("pos16").focus();
			return vMensajesHoras;
		}
		return '';
	}

	<!-- CREADO: JOS� ANTONIO ESTEVA -->
	<!-- EDITO: JOS� ANTONIO ESTEVA -->
	<!-- FECHA: 09/05/2009 -->
	<!-- FUNCION QUE VALIDA QUE UNA FECHA EXISTA Y SEA CORRECTA -->

	function fValidaFecha(tag, desc)
	{
		var	vDia;
		var	vMes;
		var	vAno;
		var	vF;
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
			document.getElementById(tag).style.backgroundColor = '#FF3300'
			return "La fecha " + desc + " falta o es incorrecta.\n";
		}
		// Verificar si la fecha ingresada es correcta:	
		if (vAno < 1900)
		{
			document.getElementById(tag).style.backgroundColor = '#FF3300'
			return "La fecha " + desc + " es incorrecta.\n";
		}
		if (vF.getDate() == vDia && vF.getMonth() + 1 == vMes && vF.getFullYear() == vAno)
		{	
			return '';
		}
		else
		{
			document.getElementById(tag).style.backgroundColor = '#FF3300'			
			return "Campo: Fecha " + desc + " falta o es incorrecta.\n";
		}
	}	

	<!-- CREADO: JOS� ANTONIO ESTEVA -->
	<!-- EDITO: JOS� ANTONIO ESTEVA -->
	<!-- FECHA: 09/05/2009 -->
	<!-- FUNCION QUE VALIDA QUE UN N�MERO SEA MENOR QUE -->

	function fValidaMenorQue(tag, num, desc)
	{
		if (document.getElementById(tag).value < num)
		{
			return '';
		}
		else
		{
			return desc;
		}
	}	
	
	<!-- CREADO: JOS� ANTONIO ESTEVA -->
	<!-- EDITO: JOS� ANTONIO ESTEVA -->
	<!-- FECHA: 13/05/2009 -->
	<!-- FUNCION QUE VALIDA QUE UN CAMPO NO EST� VAC�O -->

	function fValidaCampoLleno(tag, desc)
	{
		if (document.getElementById(tag).value && document.getElementById(tag).value != "")
		{
			return '';
		}
		else
		{
			document.getElementById(tag).style.backgroundColor = '#FF3300'
			return "Campo: " + desc + " es obligatorio.\n";
		}
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
		// Detectar el objeto que origin� el evento: 
		if (e.target) origen= e.target;
		else if (e.srcElement) origen = e.srcElement;
		if (origen.nodeType == 3) origen = targ.parentNode;
		// Obtener el c�digo de la tecla oprimida:
		if (e.keyCode) codigo = e.keyCode;
		else if (e.which) codigo = e.which;
		// Dejar pasar teclas para borrar y saltar al siguiente campo (pueden ser m�s):
		if (codigo == 8 || codigo == 9 || codigo == 46) return true;
		// Obtener la posici�n donde se est� capturando y su m�scara correspondiente: 
		posicion = origen.value.length;
		// Si en la posici�n actual hay un delimitador agregarlo a la cadena y pasar a la siguiente posici�n:
		filtro = mascara.charAt(posicion);
		if (filtro!='9' && filtro!='A')
		{
		   origen.value += filtro; 
		   posicion++;
		   filtro = mascara.charAt(posicion); 
		} 
		// Verificar si el car�cter tecleado corresponde a la m�scara:
		if (filtro == "9" && (codigo >= 48 && codigo <= 57)) return true; 										// N�mero
		if (filtro == "A" && ((codigo >= 65 && codigo <= 90) || (codigo >= 97 && codigo <= 122))) return true; 	// Letra
		// Sino, no pasa!
		return false;	 
	}
</script>
