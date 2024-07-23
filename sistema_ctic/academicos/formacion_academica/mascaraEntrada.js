	
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