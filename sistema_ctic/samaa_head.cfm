<!--- CREADO: ARAM PICHARDO--->
<!--- EDITO: ARAM PICHARDO--->
<!--- FECHA: 05/06/2009--->
<!--- PÁGINA PRINCIPAL PARA LOS ACCESOS DE LA COORDINACIÓN--->
<html>
	<head>
		<title>STCTIC - Asuntos Acad&eacute;mico-Administrativos</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<cfoutput>
            <link href="#vCarpetaCSSGlobal#/encabezados.css" rel="stylesheet" type="text/css">
            <link href="#vCarpetaCSSGlobal#/general.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/fuentes.css" rel="stylesheet" type="text/css">
		</cfoutput>
		<script type="text/javascript" src="<cfoutput>#vCarpetaLIB#</cfoutput>/jquery-1.7.2.min.js"></script>
		<script type="text/javascript">
			// ...
			$(function() {

				$("#importar_datos").click(function() {

					// Actualizar el texto en el servidor:
					$.ajax({
						async: false,
						url: "sistema/ajax_importar_datos.cfm",
						beforeSend: function() {
					    	$("#importar_datos").attr("src","<cfoutput>#vCarpetaIMG#</cfoutput>/wait.gif").load();
					    },
					    complete: function() {
					    	$("#importar_datos").attr("src","<cfoutput>#vCarpetaIMG#</cfoutput>/importar.png").load();
					    },
					    success: function(data) {

							window.parent.frames[2].location.reload();
						}

					});

				});

			});
		</script>
	</head>
	<body>
		<!--- Encabezado base --->
		<cfinclude template="../head.cfm">
	</body>
</html>
