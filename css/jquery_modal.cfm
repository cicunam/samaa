<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 29/05/2019 --->
<!--- FECHA ÚLTIMA MOD.: 29/05/2019 --->
<!--- CSS EN ARCHIVO CFM PARA PODER IDENTIFICAR LA UBICACIÓN DEL SISTEMA PARA USAR EL COLOR ROJO EN DESARROLLO Y AZUL EN PRODUCCION --->
<!--- TEMPORAL EN LO QUE SE ENCUANTRA COMO ENVIAR VARIABLES A LOS ARCHIVOS CSS --->

		<cfif #CGI.SERVER_PORT# IS '31221'>
			<cfset vModalColorBg = '##d9232f'>
        <cfelse>
			<cfset vModalColorBg = '##507aaa'>        
		</cfif>
		<style>
			.modal-header-primary {
				color:#fff;
				padding:9px 15px;
				border-bottom:1px solid #eee;
				background-color: <cfoutput>#vModalColorBg#</cfoutput>;
				-webkit-border-top-left-radius: 5px;
				-webkit-border-top-right-radius: 5px;
				-moz-border-radius-topleft: 5px;
				-moz-border-radius-topright: 5px;
				border-top-left-radius: 5px;
				border-top-right-radius: 5px;
			}	
		</style>