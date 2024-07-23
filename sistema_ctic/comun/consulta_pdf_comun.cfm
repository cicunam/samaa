<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 04/04/2019 --->
<!--- FECHA ÚLTIMA MOD: 04/04/2019 --->

<script>
	function fPdfAbrir(vArchivo, vModulo, vSolStatus, vCarpEntidad)
	{
		document.getElementById('vArchivoPdf').value = vArchivo;
		document.getElementById('vModulo').value = vModulo;
		document.getElementById('vSolStatus').value = vSolStatus;
		document.getElementById('vCarpEntidad').value = vCarpEntidad;
		document.forms['frmPdfAbre'].target = vArchivo;
		document.forms['frmPdfAbre'].submit();
	}
</script>

<div id="divArchivoCons" style="width:160px;"><!---  position:fixed; top:300px; left:5px;--->
	<cfform name="frmPdfAbre" id="frmPdfAbre" action="#vCarpetaCOMUN#/consulta_pdf.cfm" method="post">
		<cfinput type="#vTipoInput#" name="vArchivoPdf" id="vArchivoPdf" value=""><br />
		<cfinput type="#vTipoInput#" name="vModulo" id="vModulo" value=""><br />
		<cfinput type="#vTipoInput#" name="vSolStatus" id="vSolStatus" value=""><br />
		<cfinput type="#vTipoInput#" name="vCarpEntidad" id="vCarpEntidad" value="">
	</cfform>
</div>