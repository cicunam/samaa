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
		
		for (c=0; c<document.forms['formFt'].elements.length; c++)
		{
			if (document.forms['formFt'].elements[c].type != 'hidden' && document.forms['formFt'].elements[c].type != 'button') document.forms['formFt'].elements[c].style.background = '#FFFFFF';
			if (document.forms['formFt'].elements[c].type != 'hidden'  && document.forms['formFt'].elements[c].type != 'button' && (document.forms['formFt'].elements[c].type == 'radio' || document.forms['formFt'].elements[c].type == 'checkbox')) document.forms['formFt'].elements[c].style.background = '#FFFFFF';
		}
	}

	<!-- CREADO: ARAM PICHARDO -->
	<!-- EDITO: ARAM PICHARDO -->
	<!-- FECHA: 12/05/2009 -->
	<!-- FUNCION QUE VALIDA SI SE CAPTURARON DESTINOS EN LA FORMA TELEGR�MICA FT-CTIC-2  -->

	function fValidaDestino()
	{
		if (parseFloat(document.getElementById("HiddenNumDestinos").value) == 0) <!--- HIDDEN ANTERIOR A VALIDAR (posND)--->
		{
			document.getElementById('lista_destinos_enc').style.background = '#FC8C8B';
			return 'Debe indicar al menos un DESTINO/INSTITUCI�N.\n';
		}
		else if (parseFloat(document.getElementById("HiddenNumDestinos").value) > 0)  <!--- HIDDEN ANTERIOR A VALIDAR (posND)--->
		{
			return '';	
		}
	}
	
	<!-- CREADO: JOS� ANTONIO ESTEVA -->
	<!-- CREADO: JOS� ANTONIO ESTEVA -->
	<!-- FECHA: 01/10/2009 -->
	<!-- FUNCION QUE VALIDA SI SE CAPTURARON PERIODOS DE ANTIG�EDAD EN LA FORMA TELEGR�MICA FT-CTIC-34 -->

	function fValidaAntig()
	{
		if (parseFloat(document.getElementById("pos13_a").value) == 0 && parseFloat(document.getElementById("pos13_m").value) == 0 && parseFloat(document.getElementById("pos13_d").value) == 0)
		{
			return 'Debe indicar al menos un PERIODO DE ANTIG�EDAD.\n';
		}
		else
		{
			return '';	
		}
	}

	<!-- CREADO: ARAM PICHARDO -->
	<!-- EDITO: JOS� ANTONIO ESTEVA -->
	<!-- FECHA: 27/08/2009 -->
	<!-- FUNCION QUE VALIDA LOS CAMPOS DE DESTINO Y QUE SEAN OBLIGATORIOS EN LA FORMA TELEGR�MICA FT-CTIC-2  -->

	function fValidaCamposDestino()
	{
		// No es necesario para las FT-CTIC-21 y FT-CTIC-30:
		document.getElementById("pos11_u").style.backgroundColor = '#FFFFFF';
		document.getElementById("pos11_p").style.backgroundColor = '#FFFFFF';			
		document.getElementById("pos11_e").style.backgroundColor = '#FFFFFF';
		document.getElementById("pos11_c").style.backgroundColor = '#FFFFFF';
		// Validaci�n:	
		var vSumaError = '';
		if (document.getElementById('pos11_u').value == '')
		{
			document.getElementById("pos11_u").style.backgroundColor = '#FC8C8B';
			vSumaError += 'Campo: INSTITUCI�N es obligarorio.\n';
		}
		if (document.getElementById('pos11_p').value == '')
		{
			document.getElementById("pos11_p").style.backgroundColor = '#FC8C8B';
			vSumaError += 'Campo: PA�S es obligarorio.\n';
		}
		if ((document.getElementById('pos11_p').value == 'MEX' || document.getElementById('pos11_p').value == 'USA') &&  document.getElementById('pos11_e').value == '')
		{
			document.getElementById("pos11_e").style.backgroundColor = '#FC8C8B';
			 vSumaError += 'Campo: ESTADO es obligarorio.\n';
		}
		if (document.getElementById('pos11_c').value == '')
		{
			document.getElementById("pos11_c").style.backgroundColor = '#FC8C8B';
			 vSumaError += 'Campo: CIUDAD es obligarorio.\n';
		}
		// Realizar la acci�n correspondeitne:			
		if (vSumaError.length > 0)
		{	
			alert(vSumaError);
			return false; 	// Necesario para las FT-CTIC-21 y FT-CTIC-30
		}	
		else
		{
			fAgregarDestino('INSERTA', 0);
			return true;	// Necesario para las FT-CTIC-21 y FT-CTIC-30
		}
	}

	<!-- CREADO: JOS� ANTONIO ESTEVA -->
	<!-- EDITO: JOS� ANTONIO ESTEVA -->
	<!-- FECHA: 01/10/2009 -->
	<!-- FUNCION QUE VALIDA LOS CAMPOS DE ANTIG�EDAD QUE SON OBLIGATORIOS EN LA FORMA TELEGR�MICA FT-CTIC-34  -->

	function fValidaCamposAntig()
	{
		// Quitar el color rojo antes de velidar:
		document.getElementById("antig_institucion").style.backgroundColor = '#FFFFFF';
		document.getElementById("antig_fecha_ini").style.backgroundColor = '#FFFFFF';			
		document.getElementById("antig_fecha_fin").style.backgroundColor = '#FFFFFF';
		// Validaci�n:	
		var vSumaError = '';
		if (document.getElementById('antig_institucion').value == '')
		{
			document.getElementById("antig_institucion").style.backgroundColor = '#FC8C8B';
			vSumaError += 'Campo: INSTITUCI�N es obligarorio.\n';
		}
		if (document.getElementById('antig_fecha_ini').value == '')
		{
			document.getElementById("antig_fecha_ini").style.backgroundColor = '#FC8C8B';
			vSumaError += 'Las fecha INICIAL es obligaroria.\n';
		}
		if (document.getElementById('antig_fecha_fin').value == '')
		{
			document.getElementById("antig_fecha_fin").style.backgroundColor = '#FC8C8B';
			vSumaError += 'La fecha FINAL es obligaroria.\n';
		}
		if (fComparaFechas("antig_fecha_ini", "antig_fecha_fin") != -1)
		{
			document.getElementById("antig_fecha_ini").style.backgroundColor = '#FC8C8B';
			document.getElementById("antig_fecha_fin").style.backgroundColor = '#FC8C8B';
			vSumaError += 'La fecha FINAL debe ser posterior a la fecha INICIAL.\n';
		}
		// Realizar la acci�n correspondeitne:			
		if (vSumaError.length > 0)
		{	
			alert(vSumaError);
			return false;
		}	
		else
		{
			fAgregarAntiguedad('INSERTA', 0);
			return true;
		}
	}

/*
	<!-- CREADO: ARAM PICHARDO -->
	<!-- EDITO: JOS� ANTONIO ESTEVA -->
	<!-- FECHA: 27/08/2009 -->
	<!-- FUNCION QUE VALIDA LOS CAMPOS DE UN NUEVO ACAD�MICO -->

	function fValidaCamposNuevoAcademico()
	{
		// Quitar color rojo de los controles:
		document.getElementById("frmPaterno").style.backgroundColor = '#FFFFFF';
		document.getElementById("frmMaterno").style.backgroundColor = '#FFFFFF';
		document.getElementById("frmNombres").style.backgroundColor = '#FFFFFF';
		document.getElementById("frmNacionalidad").style.backgroundColor = '#FFFFFF';
		// Validaciones:	
		var vSumaError = '';
		if (document.getElementById('frmPaterno').value == '' && document.getElementById('frmMaterno').value == '' && document.getElementById('frmNombres').value == '')
		{
			document.getElementById("frmPaterno").style.backgroundColor = '#FC8C8B';
			document.getElementById("frmMaterno").style.backgroundColor = '#FC8C8B';
			document.getElementById("frmNombres").style.backgroundColor = '#FC8C8B';
			vSumaError += 'Debe indicar el APELLIDO PATERNO, MATERNO o NOMBRES del acad�mico.\n';
		}
		if (document.getElementById('frmNacionalidad').value == '')
		{
			document.getElementById("frmNacionalidad").style.backgroundColor = '#FC8C8B';
			vSumaError += 'Debe indicar la NACIONALIDAD del acad�mico.\n';
		}
		if (!document.getElementById('frmSexoF').checked && !document.getElementById('frmSexoM').checked)
		{
			 vSumaError += 'Debe indicar el SEXO del acad�mico.\n';
		}
		// Realizar la acci�n correspondeitne:			
		if (vSumaError.length > 0)
		{	
			alert(vSumaError);
			return false;
		}	
		else
		{
			fAgregarOponente('INSERTA', 0);
			return true;
		}
	}
*/

	<!-- CREADO: ARAM PICHARDO -->
	<!-- EDITO: JOS� ANTONIO ESTEVA -->
	<!-- FECHA: 23/04/2009 -->
	<!-- FUNCION QUE VERIFICA Y VALIDA QUE EL TIEMPO DE DURACI�N SEA IGUAL O MENOR A UN A�O -->
	
	<!-- NOTA: Las fechas deben validarse antes con la funci�n fValidaFecha() -->

	function fValidaDuracion()
	{
		var vDiaI = document.getElementById("pos14").value.substring(0,2);
		var vMesI = document.getElementById("pos14").value.substring(3,5);
		var vAnoI = document.getElementById("pos14").value.substring(6,10);
		var vDiaF = document.getElementById("pos15").value.substring(0,2);
		var vMesF = document.getElementById("pos15").value.substring(3,5);
		var vAnoF = document.getElementById("pos15").value.substring(6,10);
		
		var vFI = new Date(vAnoI, vMesI-1, vDiaI);
		var vFF = new Date(vAnoF, vMesF-1, vDiaF);
		
		if (('' + vFI.getYear()).length < 4) aa = vFI.getYear() + 1900; else aa = vFI.getYear();
		var vFC = vFI.setYear(aa + 1);
		
		if (vFF >= vFC)
		{
			return 'La DURACI�N m�xima del movimiento es de un a�o.\n';	
		}
		else
		{
			return '';
		}
	}
	
	function fValidaDifericion(vCFI, vCFF, vAnios)
	{
		var vDiaI = document.getElementById(vCFI).value.substring(0,2);
		var vMesI = document.getElementById(vCFI).value.substring(3,5);
		var vAnoI = document.getElementById(vCFI).value.substring(6,10);
		var vDiaF = document.getElementById(vCFF).value.substring(0,2);
		var vMesF = document.getElementById(vCFF).value.substring(3,5);
		var vAnoF = document.getElementById(vCFF).value.substring(6,10);
		
		var vFI = new Date(vAnoI, vMesI-1, vDiaI);
		var vFF = new Date(vAnoF, vMesF-1, vDiaF);
		
		if (('' + vFI.getYear()).length < 4) aa = vFI.getYear() + 1900; else aa = vFI.getYear();
		var vFC = vFI.setYear(aa + vAnios);
		
		if (vFF >= vFC)
		{
			return "La diferici�n no puede ser mayor a " + vAnios + " a�os.\n";	
		}
		else
		{
			return '';
		}
	}

	<!-- CREADO: JOS� ANTONIO ESTEVA -->
	<!-- EDITO: JOS� ANTONIO ESTEVA -->
	<!-- FECHA: 20/05/2009 -->
	<!-- FUNCION QUE VERIFICA QUE UN PERIODO SEA DE M�NIMO EL N�MERO DE D�AS INDICADO -->

	function fValidaDuracionMinima(vDias)
	{
		var vDiaI = document.getElementById("pos14").value.substring(0,2);
		var vMesI = document.getElementById("pos14").value.substring(3,5);
		var vAnoI = document.getElementById("pos14").value.substring(6,10);
		var vDiaF = document.getElementById("pos15").value.substring(0,2);
		var vMesF = document.getElementById("pos15").value.substring(3,5);
		var vAnoF = document.getElementById("pos15").value.substring(6,10);
		// Crear dos objetos de tipo fecha (inicial y final):
		var vFI = new Date(vAnoI, vMesI-1, vDiaI);
		var vFF = new Date(vAnoF, vMesF-1, vDiaF);
		// Generar fecha con la que se realizar� la comparaci�n:
		var vFC = vFI.setDate(vFI.getDate() + vDias - 1);
		// Verificar que el periodo sea de m�nimo el n�mero de d�as indicado:
		if (vFF < vFC)
		{
			return 'La DURACI�N m�nima del movimiemnto es ' + vDias + ' d�as.\n';	
		}
		else
		{
			return '';
		}
	}

	<!-- CREADO: JOS� ANTONIO ESTEVA -->
	<!-- EDITO: JOS� ANTONIO ESTEVA -->
	<!-- FECHA: 20/05/2009 -->
	<!-- FUNCION QUE VERIFICA QUE UN PERIODO SEA DE M�NIMO EL N�MERO DE D�AS INDICADO -->

	function fValidaDuracionMaximo(vDias, vTextoMensaje)
	{
		var vDiaI = document.getElementById("pos14").value.substring(0,2);
		var vMesI = document.getElementById("pos14").value.substring(3,5);
		var vAnoI = document.getElementById("pos14").value.substring(6,10);
		var vDiaF = document.getElementById("pos15").value.substring(0,2);
		var vMesF = document.getElementById("pos15").value.substring(3,5);
		var vAnoF = document.getElementById("pos15").value.substring(6,10);
		// Crear dos objetos de tipo fecha (inicial y final):
		var vFI = new Date(vAnoI, vMesI-1, vDiaI);
		var vFF = new Date(vAnoF, vMesF-1, vDiaF);
		// Generar fecha con la que se realizar� la comparaci�n:
		var vFC = vFI.setDate(vFI.getDate() + vDias - 1);
		// Verificar que el periodo sea de m�nimo el n�mero de d�as indicado:
		if (vFF > vFC)
		{
			return 'La DURACI�N m�xima del movimiento es ' + vDias + ' d�as ' + vTextoMensaje + '.\n';	
		}
		else
		{
			return '';
		}
	}

	<!-- CREADO: ARAM PICHARDO -->
	<!-- EDITO: ARAM PICHARDO -->
	<!-- FECHA: 23/04/2009 -->
	<!-- FUNCION QUE VALIDA LA SELECCION DE TIPO DE ACTIVIDAD EN CATEDRAS, TRABAJOS O ASESORIAS -->

	function fValidaActividadCatedra()
	{
		if (!document.getElementById('pos12_c').checked && !document.getElementById('pos12_t').checked && !document.getElementById('pos12_a').checked)
		{
			document.getElementById("pos12_row").style.backgroundColor = '#FC8C8B';
			return 'Campo: ACTIVIDAD debe seleccionar una opci�n.\n';
		}
		else
		{
			return '';
		}
	}

	<!-- CREADO: ARAM PICHARDO -->
	<!-- EDITO: ARAM PICHARDO -->
	<!-- FECHA: 23/04/2009 -->
	<!-- FUNCION QUE VALIDA LA SELECCION DE TIPO DE ACTIVIDAD EN CATEDRAS, TRABAJOS O ASESORIAS -->

	function fValidaTipoRegComision()
	{
		if(document.getElementById("pos12_c").checked == false && document.getElementById("pos12_p").checked == false)
		{
			document.getElementById("pos12_c").style.backgroundColor = '#FC8C8B'
			document.getElementById("pos12_p").style.backgroundColor = '#FC8C8B'
			return 'Campo: TIPO DE SOLICITUD debe seleccionar una opci�n.\n';
		}
		else
		{
			return '';
		}
	}

	<!-- CREADO: ARAM PICHARDO -->
	<!-- EDITO: ARAM PICHARDO -->
	<!-- FECHA: 05/05/2009 -->
	<!-- FUNCION QUE VALIDA LA SELECCION DE TIPO DE REGISTRO EN COMISION ENCOMENDADA -->

	function fValidaDuracionAMD()
	{
		var vNumerosDiffCero

		vNumerosDiffCero = parseFloat(document.getElementById("pos13_a").value=='' ? "0" : document.getElementById('pos13_a').value) + parseFloat(document.getElementById("pos13_m").value=='' ? "0" : document.getElementById('pos13_m').value) + parseFloat(document.getElementById("pos13_d").value=='' ? "0" : document.getElementById('pos13_d').value);
		
		if (vNumerosDiffCero == 0)
		{
			document.getElementById("pos13_a").style.backgroundColor = '#FC8C8B'
			document.getElementById("pos13_m").style.backgroundColor = '#FC8C8B'
			document.getElementById("pos13_d").style.backgroundColor = '#FC8C8B'
			return 'Campo: DURACI�N indique a�os, meses y/o d�as.\n';
		}
		if (parseFloat(document.getElementById("pos13_a").value) > 1 || parseFloat(document.getElementById("pos13_m").value) > 11 || parseFloat(document.getElementById("pos13_d").value) > 30)
		{
			txtError = "";
			if(parseFloat(document.getElementById("pos13_a").value) > 1)  
			{
				document.getElementById("pos13_a").style.backgroundColor = '#FC8C8B'
				txtError += ' Campo: A�OS no debe ser mayor a 1.\n';
			}
			if(parseFloat(document.getElementById("pos13_m").value) > 11)  
			{
				document.getElementById("pos13_m").style.backgroundColor = '#FC8C8B'
				txtError += ' Campo: MESES no debe ser mayor a 11.\n';
			}
			if(parseFloat(document.getElementById("pos13_d").value) > 30) 
			{
				document.getElementById("pos13_d").style.backgroundColor = '#FC8C8B'
				txtError += ' Campo: D�AS no debe ser mayor a 30.\n';
			}	
			return txtError;
		}
		return '';
	}

	<!-- CREADO: ARAM PICHARDO -->
	<!-- EDITO: ARAM PICHARDO -->
	<!-- FECHA: 29/04/2009 -->
	<!-- FUNCION QUE VALIDA EL TIPO DE GOCE DE SUELDO -->

	function fValidaGoceSueldo()
	{
		if(document.getElementById("pos18_t").checked == false && document.getElementById("pos18_p").checked == false && document.getElementById("pos18_sgs").checked == false)
		{

			document.getElementById("pos18_t").style.backgroundColor = '#FC8C8B'
			document.getElementById("pos18_p").style.backgroundColor = '#FC8C8B'
			document.getElementById("pos18_sgs").style.backgroundColor = '#FC8C8B'
			return 'Campo: GOCE DE SUELDO debe seleccionar una opci�n.\n';
		}
		else
		{
			if(document.getElementById("pos18_p").checked == true && (document.getElementById("pos17").value == '' || parseFloat(document.getElementById("pos17").value) < 1))
			{
				document.getElementById("pos17").style.backgroundColor = '#FC8C8B'
				return 'Campo: PORCENTAJE DE SUELDO no puede ser cero o nulo.\n';
			}
			return '';
		}
	}

	<!-- CREADO: ARAM PICHARDO -->
	<!-- EDITO: ARAM PICHARDO -->
	<!-- FECHA: 29/04/2009 -->
	<!-- FUNCION QUE VALIDA EL TIPO DE GOCE DE SUELDO -->

	function fValidaComisionPaspa()
	{
		if(document.getElementById("pos20_s").checked == false && document.getElementById("pos20_n").checked == false)
		{
			document.getElementById("pos20_s").style.backgroundColor = '#FC8C8B'
			document.getElementById("pos20_n").style.backgroundColor = '#FC8C8B'
			return 'Campo: PASPA debe seleccionar una opci�n.\n';
		}
		else
		{
			return '';
		}
	}

	<!-- CREADO: ARAM PICHARDO -->
	<!-- EDITO: ARAM PICHARDO -->
	<!-- FECHA: 01/05/2009 -->
	<!-- FUNCION QUE VALIDA LA SELECCION EN EL CATALOGO DE PAIS -->

	function fValidaHoras(vHoras, vMensajesHoras, vFtHoras)
	{
		var vSumaHoras;

		if (vFtHoras == 'F1')
		{
			vSumaHoras = parseFloat(document.getElementById("pos16").value=='' ? "0" : document.getElementById('pos16').value) + parseFloat(document.getElementById("pos19").value=='' ? "0" : document.getElementById('pos19').value);
		}
		else if (vFtHoras == 'F6')
		{
			vSumaHoras = parseFloat(document.getElementById("pos16").value=='' ? "0" : document.getElementById('pos16').value);
		}
		if (vSumaHoras > vHoras)
		{
			document.getElementById("pos16").style.backgroundColor = '#FC8C8B';
			if (vFtHoras == 'F1') document.getElementById("pos19").style.backgroundColor = '#FC8C8B';
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
			document.getElementById(tag).style.backgroundColor = '#FC8C8B'
			return "La fecha " + desc + " falta o es incorrecta.\n";
		}
		// Verificar si la fecha ingresada es correcta:	
		if (vAno < 1900)
		{
			document.getElementById(tag).style.backgroundColor = '#FC8C8B'
			return "La fecha " + desc + " es incorrecta.\n";
		}
		if (vF.getDate() == vDia && vF.getMonth() + 1 == vMes && vF.getFullYear() == vAno)
		{	
			return '';
		}
		else
		{
			document.getElementById(tag).style.backgroundColor = '#FC8C8B'			
			return "Campo: Fecha " + desc + " falta o es incorrecta.\n";
		}
	}	

	<!-- CREADO: ARAM PICHARDO -->
	<!-- EDITO: ARAM PICHARDO -->
	<!-- FECHA: 13/05/2009 -->
	<!-- FUNCION QUE VALIDA LA FECHA DE INICIO DE LA P�RROGA CON LA COMISI�N O LA �LTIMA PR�RROGA -->

	function fValidaFechaProrroga()
	{
		if (document.getElementById("pos14").value == '')
		{
			return '';
		}
		else
		{
			var vDiaC = document.getElementById("pos14").value.substring(0,2);
			var vMesC = document.getElementById("pos14").value.substring(3,5);
			var vAnoC = document.getElementById("pos14").value.substring(6,10);
			var vFecC = new Date(vAnoC, vMesC - 1, vDiaC - 1);

			var vDiaV = document.getElementById("pos_FechaFinUlimMov").value.substring(0,2);
			var vMesV = document.getElementById("pos_FechaFinUlimMov").value.substring(3,5);
			var vAnoV = document.getElementById("pos_FechaFinUlimMov").value.substring(6,10);
			var vFecV = new Date(vAnoV, vMesV - 1, vDiaV);

			var vDiaI = document.getElementById("pos_FechaIniUlimMov").value.substring(0,2);
			var vMesI = document.getElementById("pos_FechaIniUlimMov").value.substring(3,5);
			var vAnoI = document.getElementById("pos_FechaIniUlimMov").value.substring(6,10);
			var vFecI = new Date(vAnoI, vMesI - 1, vDiaI);

			if (vFecC > vFecV)
			{
				document.getElementById("pos14").style.backgroundColor = '#FC8C8B'			
				return "La fecha de INICIO debe ser m�ximo un d�a posterior a la fecha de t�rmino de la comisi�n o de la �ltima pr�rroga de comisi�n.\n";
			}
			if (vFecC < vFecI)
			{
				document.getElementById("pos14").style.backgroundColor = '#FC8C8B'			
				return "La fecha de INICIO debe ser mayor a la fecha de inicio de la comisi�n o de la �ltima pr�rroga de comisi�n.\n";
			}
			return '';
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
			document.getElementById(tag).style.backgroundColor = '#FC8C8B'
			return "Campo: " + desc + " es obligatorio.\n";
		}
	}
	
	<!-- CREADO: JOS� ANTONIO ESTEVA -->
	<!-- EDITO: JOS� ANTONIO ESTEVA -->
	<!-- FECHA: 09/05/2009 -->
	<!-- FUNCION QUE VALIDA QUE UN CAMPO NO EST� VAC�O -->

	function fValidaSelCombo(tag, desc)
	{
		if (document.getElementById(tag).value == '0')
		{
			document.getElementById(tag).style.backgroundColor = '#FC8C8B'
			return "Campo: " + desc + " debe seleccionar un valor.\n";
		}
		else
		{
			return '';
		}
	}
		
	<!-- CREADO: JOS� ANTONIO ESTEVA -->
	<!-- EDITO: JOS� ANTONIO ESTEVA -->
	<!-- FECHA: 08/05/2009 -->
	<!-- COMPARA DOS CAMPOS FECHA: Si la primera es mayor regresa 1, si la primera es menor regres -1, si non igules regres 0, si hay error regres 9. -->

	function fComparaFechas(tag1, tag2)
	{
		try
		{
			vDia1 = document.getElementById(tag1).value.substring(0,2);
			vMes1 = document.getElementById(tag1).value.substring(3,5);
			vAno1 = document.getElementById(tag1).value.substring(6,10);
			vF1 = new Date(vAno1, vMes1-1, vDia1);
				
			vDia2 = document.getElementById(tag2).value.substring(0,2);
			vMes2 = document.getElementById(tag2).value.substring(3,5);
			vAno2 = document.getElementById(tag2).value.substring(6,10);
			vF2 = new Date(vAno2, vMes2-1, vDia2);
				
			if (vF1 > vF2)			// La primera es mayor
			{
				return 1;
			}
			else if (vF1 < vF2) 	// La primera es menor	
			{
				return -1
			}
			else if (vF1 == vF2) 	// Son iguales
			{
				return 0;
			}	
		}
		catch (err)
		{
			return 9;				// Error al compara las fechas
		}	
	}

	<!-- CREADO: JOS� ANTONIO ESTEVA -->
	<!-- EDITO: JOS� ANTONIO ESTEVA -->
	<!-- FECHA: 12/04/2011 -->
	<!-- VERIFICA SI LA SEGUNDA FECHA ES UN DIA DESPU�S QUE LA PRIMERA  -->

	function fValidaUnDiaDespues(tag, fecha_compara, desc)
	{
		try
		{
			vDia1 = document.getElementById(tag).value.substring(0,2);
			vMes1 = document.getElementById(tag).value.substring(3,5);
			vAno1 = document.getElementById(tag).value.substring(6,10);
			vF1 = new Date(vAno1, vMes1-1, vDia1);
				
			vDia2 = fecha_compara.substring(0,2);
			vMes2 = fecha_compara.substring(3,5);
			vAno2 = fecha_compara.substring(6,10);
			vF2 = new Date(vAno2, vMes2-1, vDia2);
			
			if (parseInt((vF1-vF2)/(24*3600*1000)) == 1) return '';
			else 
			{
				document.getElementById(tag).style.backgroundColor = '#FC8C8B'
				return desc;
			}
			
			
		}
		catch (err)
		{
			document.getElementById(tag).style.backgroundColor = '#FC8C8B'
			return 'Error al comparar la FECHA DE INICIO con la fecha de la beca anterior.\n';
		}	
	}
	
	// Regresa TRUE si la fecha 
	function fValidaFechaPosterior(tag1, tag2)
	{
		if (fComparaFechas(tag1, tag2) == 1)
		{
			return true;
		}
		else
		{
			return false;
		}
	}

	// Valida que el n�mero de plaza este completo
	function fValidaPlaza()
	{
		if (document.getElementById('pos9').value.length == 8 )
		{
			return '';
		}
		else
		{
			document.getElementById('pos9').style.backgroundColor = '#FC8C8B'
			return "Campo: N�MERO DE PLAZA es incorrecto.\n";
		}
	}
	
	// Valida que la clase de dos CCN sean iguales :
	function fValidaMismoTipoAcademico (ccn1, ccn2)
	{
		if (ccn1.substring(0,3) != ccn2.substring(0,3))
		{
			if (ccn1.substring(0,3) == "TEC")
			{
				return "Un T�CNICO ACAD�MICO no puede concursar por una plaza de INVESTIGADOR.\n";
			}
			else
			{
				return "Un INVESTIGADOR no puede concursar por una plaza de T�CNICO ACAD�MICO.\n";
			}
		}
		else
		{
			return '';
		}
	}

</script>
