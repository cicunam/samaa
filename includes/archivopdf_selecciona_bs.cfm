<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 13/06/2016 --->
<!--- FECHA ÚLTIMA MOD.: 22/04/2022 --->
<!--- MÓDULO GENERAL PARA LA SELECCIÓN DE ARCHIVOS PARA ENVIAR AL SAMAA --->

<cfparam name="vModuloConsulta" default="">
<cfparam name="vAcdId" default="">
<cfparam name="vNumRegistro" default="">
<cfparam name="vSsnIdArchivo" default="">
<cfparam name="vDepClave" default="">
<cfparam name="vUsuarioId" default="0">    
	
		<script type="text/javascript">
			// Valida que el archivo se seleccionó:
			function fValidaArchivo()
			{
				if (document.getElementById('selecciona_pdf').value == '')
				{
					alert('No se ha seleccionado el archivo');
				}
			}
		</script>
        
		<script language="JavaScript" type="text/JavaScript">
            $(function() {
               $('#cmdEnvia_pdf').click(function(){
					$.ajax({
						url: "<cfoutput>#vCarpetaINCLUDE#</cfoutput>/archivopdf_carga.cfm",
						type:'POST',
						async: false,
						data: new FormData($('#formEnviaArchivo')[0]),
						processData: false,
						contentType: false,
						success: function(data) {
							alert(data);
							location.reload();
						},
						error: function(data) {
							alert('ERROR AL CARGAR EL ARCHIVO');
							//location.reload();
						},
					});
				});
            });
        </script>
<!---
    </head>
	<body>
--->	

        <div class="modal-header">
			<button id="CierraModalArriba" type="button" class="close" data-dismiss="modal">&times;</button>
            <h4 class="modal-title">SELECCIONE EL ARCHIVO A ENVIAR</h4>
        </div>
        <div class="modal-body">
	        <cfform name="formEnviaArchivo" id="formEnviaArchivo">
				<div class="form-group">
					<cfinput type="file" name="selecciona_pdf" id="selecciona_pdf" class="form-control" size="55">
                    <cfinput type="#vTipoInput#" id="vModuloConsulta" name="vModuloConsulta" value="#vpModuloConsulta#">
                    <cfinput type="#vTipoInput#" id="vAcdId" name="vAcdId" value="#vpAcdId#">
                    <cfinput type="#vTipoInput#" id="vNumRegistro" name="vNumRegistro" value="#vpNumRegistro#">
                    <cfinput type="#vTipoInput#" id="vSsnIdArchivo" name="vSsnIdArchivo" value="#vpSsnIdArchivo#">
                    <cfinput type="#vTipoInput#" id="vDepClave" name="vDepClave" value="#vpDepClave#">
                    <cfinput type="#vTipoInput#" id="vSolStatus" name="vSolStatus" value="#vpSolStatus#">
                    <cfinput type="#vTipoInput#" id="vUsuarioId" name="vUsuarioId" value="#Session.sUsuarioId#">
                    <cfinput type="#vTipoInput#" id="vCarpetaINCLUDE" name="vCarpetaINCLUDE" value="#vCarpetaINCLUDE#">
				</div>
	        </cfform>
			<div class="text-left">
            	<h6 class="small">
                    Recuerde que los archivos deben ser enviados con las siguientes caracter&iacute;zticas:<br />
                    <br>
                    <strong>Formato: </strong>Adobe Acrobat (PDF)<br />
                    <strong>Tipo de salida: </strong>Blanco y negro<br />
                    <strong>Resoluci&oacute;n: </strong>300 dpi
				</h6>
			</div>
		</div>
        <div class="modal-footer">
			<button id="cmdEnvia_pdf" type="button" class="btn btn-success" onClick="fSubmitFormulario('ENVIAR')">Cargar archivo</button>
			<button id="CierraModalAbajo" type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
        </div>
