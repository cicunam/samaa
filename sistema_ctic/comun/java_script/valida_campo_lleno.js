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