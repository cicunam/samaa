/****************************************************************************************
 * Esta rutina permite crear un objeto XMLHttpRequest para trabajar con la técnica AJAX *
 ****************************************************************************************/
function XmlHttpRequest()
{
	//var xmlHttp = null;
	var xmlHttp;
	try
	{
		xmlHttp = new XMLHttpRequest(); 						// Firefox, Opera 8.0+, Safari
	}
	catch(e)
	{
		try
		{
			xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");		// Internet Explorer 6.0+
		}
		catch(e)
		{
			xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");	// Internet Explorer 5.5+
		}
	}
	return xmlHttp;
}