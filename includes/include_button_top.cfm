<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 25/04/2018 --->
<!--- FECHA ÚLTIMA MOD.: 05/12/2019 --->



<style>
	#myBtn {
		display: none; /* Hidden by default */
		position: fixed; /* Fixed/sticky position */
		bottom: 70px; /* Place the button at the bottom of the page */
		right: 30px; /* Place the button 30px from the right */
		z-index: 99; /* Make sure it does not overlap */
		border: none; /* Remove borders */
		outline: none; /* Remove outline */
		background-color: #428DFF; /*#62B0FF;*/ /* Set a background color */
		color: white; /* Text color */
		cursor: pointer; /* Add a mouse pointer on hover */
		padding: 10px; /* Some padding */
		border-radius: 10px; /* Rounded corners */
		font-size: 20px; /* Increase font size */
		width: 45x;
		height: 45px;		
	}
	
	#myBtn:hover {
		background-color:#999; /* Add a dark-grey background on hover */
	} 
</style>
<script>
	window.onscroll = function() {scrollFunction()};
	
	function scrollFunction() {
		if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
			document.getElementById("myBtn").style.display = "block";
		} else {
			document.getElementById("myBtn").style.display = "none";
		}
	}
	
	// When the user clicks on the button, scroll to the top of the document
	function topFunction() {
		document.body.scrollTop = 0; // For Safari
		document.documentElement.scrollTop = 0; // For Chrome, Firefox, IE and Opera
	} 
</script>

<button onclick="topFunction()" id="myBtn" class="btn-primary" title="Ir arriba"><span class="glyphicon glyphicon-menu-up"></span></button>