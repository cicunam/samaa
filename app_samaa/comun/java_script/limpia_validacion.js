<!-- CREADO: JOSÉ ANTONIO ESTEVA -->
<!-- EDITO: JOSÉ ANTONIO ESTEVA -->
<!-- FECHA: 13/05/2009 -->
<!-- FUNCION QUE LIMPIA LOS CAMPOS VALIDADOS Y MARCADOS EN COLOR  -->

function fLimpiaValida()
{
	// TEMPORAL: Mientras encontramos como marcar RADIO y CHECKBOX:
	for (c=0; c<document.forms[0].elements.length; c++)
	{
		if (document.forms[0].elements[c].type != 'hidden' && document.forms[0].elements[c].type != 'button' && document.forms[0].elements[c].type != 'submit')
		{
			//alert(document.forms[0].elements[c].type);
			document.forms[0].elements[c].style.background = '#FFFFFF';
		}
	}
}