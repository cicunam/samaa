

<cfobject type="application/pdf" data="http://www.cic-ctic.unam.mx:31221/samaa/aram/archivos_ctic/archivos_entidades/0302/9559_145357.pdf" width="100%" height="500" style="height: 85vh;">


<!--- 
<!--- Obtener el HTML de la FT --->
<cfheader name="Content-disposition" value="attachment;filename=new.pdf" />
<cfcontent type="application/pdf" file="e:/archivos_samaa/archivos_ctic/archivos_entidades/0302/9559_145357.pdf" deletefile="no"> 

<cfhttp url="#vCarpetaRaizWebSistema#/asuntos/solicitudes/#ctMovimiento.mov_ruta#" method="post" resolveurl="true">
	<cfhttpparam type="COOKIE" name="CFID" value="#cookie.cfid#">
	<cfhttpparam type="COOKIE" name="CFTOKEN" value="#cookie.cftoken#">
</cfhttp>
<cfpdf 

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Documento sin título</title>
</head>

    <body>
		<cfoutput><div style="padding-top:10px; margin-left:auto; margin-right:auto;">#cfhttp.fileContent#</div></cfoutput>    
    </body>
</html>
---->