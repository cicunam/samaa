<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO DURAN --->
<!--- FECHA CREA: 26/11/2015 --->
<!--- FECHA ULTIMA MOD.: 26/11/2015 --->



<!-- CREADO: JOSÉ ANTONIO ESTEVA -->
<!-- EDITO: JOSÉ ANTONIO ESTEVA -->
<!-- FECHA: 13/05/2009 -->
<!-- FUNCION QUE LIMPIA LOS CAMPOS VALIDADOS Y MARCADOS EN COLOR  -->
function fLimpiaValida()
{
	// TEMPORAL: Mientras encontramos como marcar RADIO y CHECKBOX:
	//if (document.getElementById('lista_destinos_enc')) document.getElementById('lista_destinos_enc').style.background = '#FFFFFF';
	
	for (c=0; c<document.forms[0].elements.length; c++)
	{
		if (document.forms[0].elements[c].type != 'hidden' && document.forms[0].elements[c].type != 'button') document.forms[0].elements[c].style.background = '#FFFFFF';
		if (document.forms[0].elements[c].type != 'hidden' && (document.forms[0].elements[c].type == 'radio' || document.forms[0].elements[c].type == 'checkbox')) document.forms[0].elements[c].style.background = '#FFFFFF';
	}
}

<!-- CREADO: JOSÉ ANTONIO ESTEVA -->
<!-- EDITO: JOSÉ ANTONIO ESTEVA -->
<!-- FECHA: 13/05/2009 -->
<!-- FUNCION QUE VALIDA QUE UN CAMPO NO ESTÉ VACÍO -->

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

<!-- CREADO: JOSÉ ANTONIO ESTEVA -->
<!-- EDITO: JOSÉ ANTONIO ESTEVA -->
<!-- FECHA: 09/05/2009 -->
<!-- FUNCION QUE VALIDA QUE UN CAMPO NO ESTÉ VACÍO -->

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
	
<!-- CREADO: JOSÉ ANTONIO ESTEVA -->
<!-- EDITO: JOSÉ ANTONIO ESTEVA -->
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
