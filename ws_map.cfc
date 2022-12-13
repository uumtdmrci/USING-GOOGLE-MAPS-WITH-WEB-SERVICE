 
<cfcomponent>
<cffunction name="getVisits_company" returnFormat="JSON" access="remote" output="false" returntype="any">
     <cfargument name="manager_id_" required="false" default=""> 

    <cfquery name="get_v" datasource="workcubedev_brfplatform_planlamaonline">
        SELECT  C.PLANLAMA_KOD
        FROM 
            PLANNING_DRAFT P 
            LEFT JOIN SETUP_ROOT SR ON SR.ROOT_ID = P.ROOT_ID 
            LEFT JOIN MANAGERS M ON M.KOLTUK_ID = SR.KOLTUK_ID
            LEFT JOIN COMPANY C ON C.COMPANY_ID = P.COMPANY_ID
         WHERE 
            YEAR(P.PLAN_DATE) = #year(now())# AND 
            MONTH(P.PLAN_DATE) = #month(now())# AND
            DAY(P.PLAN_DATE) = #day(now())# AND
            M.MANAGER_ID = '#arguments.manager_id_#'  
     </cfquery>
    <cfset company_list = valueList(get_v.PLANLAMA_KOD)>
    <cfreturn company_list />
</cffunction>  
 
</cfcomponent>

