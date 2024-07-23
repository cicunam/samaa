<!--- CREADO: ARAM PICHARDO DURAN --->
<!--- EDITO: ARAM PICHARDO DURAN --->
<!--- FECHA CREA: 15/09/2014 --->
<!--- FECHA �LTIMA MOD.: 02/12/2015 --->

<!--- JAVA SCRIPT PARA TODO EL M�DULO DE ACAD�MICO QUE PERMITE CARGAR ALGUNOS DATOS --->

		<script language="JavaScript" type="text/JavaScript">
			// Datos del acad�mico:
			function fDatosAcademico()
			{
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Funci�n de atenci�n a las petici�n HTTP:
				xmlHttp.onreadystatechange = function(){
					if (xmlHttp.readyState == 4) {
						document.getElementById('AcadDatos_dynamic').innerHTML = xmlHttp.responseText;
					}
				}
				// Generar una petici�n HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
				xmlHttp.open("POST", "../../comun/academico_datos_v2.cfm", true);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de par�metros:
				parametros = "vAcadId=" + encodeURIComponent(<cfoutput>#Session.AcademicosFiltro.vAcadId#</cfoutput>);
				// Enviar la petici�n HTTP:
				xmlHttp.send(parametros);
			}

			<!-- AJAX QUE PERMITE CALCULAR LA ANTIG�EDAD ACAD�MICO - CREADO: 27/09/2012-->
			function fCalulaAntigAcad()
			{
				//if (document.getElementById('antigAcadSup_dynamic'))
				if (document.getElementById('con_clave_datos').value >= 1 && document.getElementById('con_clave_datos').value <= 3)
				{
					// Crear un objeto XmlHttpRequest:
					var xmlHttp = XmlHttpRequest();
					// Funci�n de atenci�n a las petici�n HTTP:
					xmlHttp.onreadystatechange = function(){
						if (xmlHttp.readyState == 4) {
							document.getElementById('antigAcad_dynamic').innerHTML = xmlHttp.responseText;
						}
					}
					// Generar una petici�n HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
					xmlHttp.open("POST", "../../comun/calcula_antiguedad.cfm", true);
					xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
					// Crear la lista de par�metros:
					parametros = "vIdAcad=" + encodeURIComponent(<cfoutput>#vAcadId#</cfoutput>);
					parametros += "&vTipoSolicitudAntig=N";
					parametros += "&vSolId=0";
					parametros += "&vTipoReturn=Texto";
					xmlHttp.send(parametros);
				}
			}
		</script>
<!---
		<script language="JavaScript" type="text/JavaScript">
            function fInformacionAcad()
            {
                document.forms['frmInfAcad'].submit();
            }
        </script>
--->		