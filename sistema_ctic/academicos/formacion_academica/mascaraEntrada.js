	
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