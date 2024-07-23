<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 04/05/2017 --->
<!--- FECHA ÚLTIMA MOD.: 04/05/2017 --->
<!---  FRAME LATERAL QUE INCLUYE LA PANTALLA DE LA INFORMACIÓN DE LA SOLICITUD --->
<!--------------------------------------------------->

<cfset vTipoVistaComentario = 'F'>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
		<meta charset="charset=iso-8859-1">    
        <meta http-equiv="Content-Type" content="text/html" />
        <title>Documento sin t&iacute;tulo</title>
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.0/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        
		<div id="myModal" class="modal-dialog">
            <div class="modal-content">
                <cfinclude template="include_informe_comentario.cfm">
            </div>
        </div>
    </body>
</html>