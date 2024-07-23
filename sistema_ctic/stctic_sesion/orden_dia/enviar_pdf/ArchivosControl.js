function fActivaArchvios()
{
	var posTop = document.getElementById('cmdEnvioPdf').offsetTop;
	var posleft = document.getElementById('cmdEnvioPdf').offsetLeft;					
	parent.document.getElementById('ifrmSelArchivo').style.top = posTop + 'px';
	parent.document.getElementById('ifrmSelArchivo').style.left = '150px';	
}

parent.document.write("<iframe scrolling='no' frameborder='no' name='ifrmSelArchivo' id='ifrmSelArchivo' src='enviar_pdf/ft_archivo_selecciona.cfm?&vIdSol=<cfoutput>#vIdSol#</cfoutput>' width='515px' height='120'></iframe>");
parent.document.write("<div id='divSelArchivo'></div>");
