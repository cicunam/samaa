<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 16/06/2016 --->
<!--- FECHA ÚLTIMA MOD.: 16/06/2016 --->
<!--- Include de HEAD para todas las formas telegrámicas --->

        <cfoutput>
			<title>SAMAA - FT-CTIC-#vFt#</title>
			<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
			<link href="#vCarpetaCSS#/formularios.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/general.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/fuentes.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/jquery/jquery-ui-1.8.12.custom.css" rel="stylesheet" type="text/css">
		</cfoutput>

		<cfif #vTipoComando# IS 'IMPRIME' AND #vSolStatus# GT 3>
			<style type="text/css">
				body {
					background-image:url(<cfoutput>#vCarpetaIMG#/iPreliminar.gif</cfoutput>);
					background-position:center;
				}
			</style>
		</cfif>

		<!--- Código JAVASCRIPT común --->
        <cfinclude template="ft_scripts_ajax.cfm">
        <cfinclude template="ft_scripts_menu.cfm">
        <cfinclude template="ft_scripts_valida.cfm">
        <cfinclude template="ft_scripts_varios.cfm">

		<!--- Código JQUERY común --->        
        <cfinclude template="ft_scripts_jquery.cfm">