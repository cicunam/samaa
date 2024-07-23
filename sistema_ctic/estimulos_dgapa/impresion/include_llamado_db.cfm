<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 08/02/2023 --->
<!--- FECHA ÚLTIMA MOD.: 08/02/2023 --->
<!--- INCLUDE PARA LLAMADO DE TABLAS --->

<cfquery name="tbEstimulosDgapa" datasource="#vOrigenDatosSAMAA#">
	SELECT T1.*
	, 
    T2.acd_prefijo
    , 
    T2.acd_nombres
	,
    ISNULL(dbo.SINACENTOS(acd_apepat),'') + 
    CASE WHEN acd_apepat IS NULL THEN '' ELSE ' ' END + 
    ISNULL(dbo.SINACENTOS(acd_apemat),'') AS nombre_completo_pm
    , T2.acd_id, T2.acd_rfc, T2.dep_clave, T2.dep_ubicacion, T2.acd_prefijo, T2.acd_sexo, T2.cn_clave, T2.con_clave
    , C1.dep_clave, C1.dep_siglas
    , C2.cn_clave, cn_siglas
	, C3.pride_nivel
	, C4.pride_nivel AS pride_nivel_ant
	, C3.orden_samaa
    FROM estimulos_dgapa AS T1
	LEFT JOIN academicos AS T2 ON T1.acd_id = T2.acd_id
	LEFT JOIN OPENQUERY(MYSQL, 'SELECT * FROM catalogos.catalogo_dependencias') AS C1 ON T1.dep_clave = C1.dep_clave
	LEFT JOIN OPENQUERY(MYSQL, 'SELECT * FROM catalogos.catalogo_cn') AS C2 ON T1.cn_clave = C2.cn_clave
	LEFT JOIN OPENQUERY(MYSQL, 'SELECT * FROM catalogos.catalogo_pride') AS C3 ON T1.pride_clave = C3.pride_clave
	LEFT JOIN OPENQUERY(MYSQL, 'SELECT * FROM catalogos.catalogo_pride') AS C4 ON T1.pride_clave_ant = C4.pride_clave
   	WHERE ssn_id = #vpSsnId#
	ORDER BY 
	<cfif #vpSsnId# GTE 1576 AND #vpSsnId# LTE 1638>
    	C3.orden_samaa, T1.renovacion, C1.dep_orden, C2.cn_clase, T2.acd_apepat, T2.acd_apemat
	<cfelseif #vpSsnId# GTE 1639 AND #vpSsnId# LTE 1648> <!--- SE AGREGÓ ESTE ORDEN A PETICIÓN DE ADRINA 15/06/2022 --->
    	C1.dep_orden, C3.orden_samaa, T1.ingreso DESC, C2.cn_clase, T2.acd_apepat, T2.acd_apemat
	<cfelseif #vpSsnId# GTE 1649> <!--- SE AGREGÓ ESTE ORDEN A PETICIÓN DE ADRINA 05/12/2022 --->
    	C1.dep_orden, C3.orden_samaa, T1.ingreso DESC, T1.estimulo_oficio
	<cfelse>
    	C3.orden_samaa, T1.ingreso DESC, C1.dep_orden, C2.cn_clase, T2.acd_apepat, T2.acd_apemat
	</cfif>
<!--- ORDER BY C1.dep_orden, T2.acd_apepat, T2.acd_apemat --->
</cfquery>

<cfquery name="tbSesionesCtic" datasource="#vOrigenDatosSAMAA#">
	SELECT ssn_id, ssn_fecha 
	FROM sesiones
	WHERE ssn_id =  #vpSsnId#
    AND ssn_clave = 1   
</cfquery>