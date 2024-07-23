<!-- CREADO: JOSÉ ANTONIO ESTEVA -->
<!-- EDITO: JOSÉ ANTONIO ESTEVA -->
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