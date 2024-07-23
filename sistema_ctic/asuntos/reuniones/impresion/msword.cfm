<!----------------------------------->
<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: JOSÉ ANTONIO ESTEVA --->
<!--- TOMADO DE: http://www.codeproject.com/KB/office/Wordyna.aspx?fid=59794&select=867201&tid=865022 --->
<!--- FECHA: 01/06/2010 --->
<!--------------------------------------------------------------------------->
<!--- MANERA DE GENERAR UN DOCUMENTO MS-WORD A PARTIR DE UN HTML CON CSS! --->
<!--------------------------------------------------------------------------->
<!--- FAVOR DE NO BORRAR ESTE ARCHIVO --->
<!--------------------------------------->
<cfcontent type="application/msword; charset=iso-8859-1">
<cfheader name="Content-Disposition" value="inline; filename=listado_ctic_V.doc">

<html xmlns:o='urn:schemas-microsoft-com:office:office'	xmlns:w='urn:schemas-microsoft-com:office:word' xmlns='http://www.w3.org/TR/REC-html40'>
	<head>
		<title>Prueba HTML-CSS-MSWord</title>
		<!--[if gte mso 9]>
			<xml>
				<w:WordDocument>
				<w:View>Print</w:View>
				<w:Zoom>90</w:Zoom>
				<w:DoNotOptimizeForBrowser/>
				</w:WordDocument>
			</xml>
		<![endif]-->
		<style>
			<!-- /* Style Definitions */
			@page Section1 {
				size:8.5in 11.0in;
				margin:1.0in 1.25in 1.0in 1.25in ;
				mso-header-margin:.5in;
				mso-footer-margin:.5in; 
				mso-paper-source:0;
				}
			div.Section1 {
				page:Section1;
			} -->
		</style>
	</head>
	<body lang=EN-US style='tab-interval:.5in'>
		<div class=Section1>
			<h1>Time and tide wait for none</h1>
			<p style='color:red'>
				<i><cfoutput>#Now()#</cfoutput></i>
			</p>
		</div>
	</body>
</html> 
