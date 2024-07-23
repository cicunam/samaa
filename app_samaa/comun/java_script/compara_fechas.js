<!-- CREADO: JOSÉ ANTONIO ESTEVA -->
<!-- EDITO: JOSÉ ANTONIO ESTEVA -->
<!-- FECHA: 13/05/2009 -->
<!-- FUNCION QUE VALIDA QUE UN CAMPO NO ESTÉ VACÍO -->


			// Comparar fechas:
			function fCompararFechas(tag1, tag2)
			{
				try
				{
					vDia1 = document.getElementById(tag1).value.substring(0,2);
					vMes1 = document.getElementById(tag1).value.substring(3,5);
					vAno1 = document.getElementById(tag1).value.substring(6,10);
					vF1 = new Date(vAno1, vMes1-1, vDia1);
					vDia2 = document.getElementById(tag2).value.substring(0,2);
					vMes2 = document.getElementById(tag2).value.substring(3,5);
					vAno2 = document.getElementById(tag2).value.substring(6,10);
					vF2 = new Date(vAno2, vMes2-1, vDia2);
					// La primera es mayor:
					if (vF1 > vF2)
					{
						return 1;
					}
					// La primera es menor:
					else if (vF1 < vF2)
					{
						return -1
					}
					// Son iguales:
					else if (vF1 == vF2)
					{
						return 0;
					}
				}
				catch (err)
				{
					return 9;				// Error al compara las fechas
				}
			}