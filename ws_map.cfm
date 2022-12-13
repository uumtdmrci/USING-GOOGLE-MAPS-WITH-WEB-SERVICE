
<cfquery name="get_001" datasource="#dsn_mobile#">
	SELECT MANAGER_ID,PLANLAMA_MANAGER_ID FROM MANAGERS WHERE MANAGER_ID = #manager_id_#
</cfquery>

<cfhttp url="http://cloud.magazacilikonline.com/cfc/mngpro.cfc?method=getVisits_company" method="get" resolveURL="yes" >
	 <cfhttpparam type="formfield" name="manager_id_" value="#get_001.PLANLAMA_MANAGER_ID#"> 
</cfhttp>

<cfset theData=replace(cfhttp.FileContent,'"','','all')>
<cfset arr = listLen(theData)>


<cfquery name="GET_KOR_" datasource="#dsn_mobile#">
	SELECT  C.COORDINATE_1 , C.COORDINATE_2 ,C.COMPANY_ADDRESS,C.FULLNAME,C.COMPANY_ID,SC.CITY_NAME AS IL , C.TEDARIKCI,CC.FULLNAME AS SEFA ,SD.COUNTY_NAME AS ILCE
		FROM SETUP_ROOT_AY SRA 
	LEFT JOIN COMPANY C ON C.COMPANY_ID = SRA.COMPANY_ID
	LEFT JOIN SETUP_CITY SC ON SC.CITY_ID = C.CITY
	LEFT JOIN SETUP_COUNTY SD ON SD.COUNTY_ID = C.COUNTY
	LEFT JOIN COMPANY CC ON CC.COMPANY_ID = C.TEDARIKCI
	WHERE 
		LEN(C.COORDINATE_1)>0 
		AND LEN(C.COORDINATE_2)>0  
		<cfif len(theData)>
			AND  C.PLANLAMA_KOD IN (
			<cfset current=0> 
			<cfloop list="#theData#" index="aa" >
				<cfset current = current +1>
				'#aa#'<cfif arr neq current >,<cfelse></cfif>
			</cfloop>
			)
		</cfif>	
 </cfquery>
 
 	<div id="basic-map" class="height-500"></div><br>
 
		   <script>
		$(document).ready(function(){
			getGetir();
		});
	  function getGetir() {
	   
			var location1_1_1= document.getElementById('location1_1_1').value;
			var location2_1_1= document.getElementById('location2_1_1').value;
			  
		var uluru = {lat: location1_1_1, lng: location2_1_1};
		var map = new google.maps.Map(document.getElementById('basic-map'), {
			
		  zoom: 11,
		  center: uluru
		});

		var pos = new google.maps.LatLng(location1_1_1, location2_1_1);
		   

		   var image = {
					url: "/documents/offtrade/icon/person.png", // url
					scaledSize: new google.maps.Size(45, 45), // scaled size
					origin: new google.maps.Point(0,0), // origin
					anchor: new google.maps.Point(11, 23) // anchor
					}; 
			// Create a marker and center map on user location
			marker = new google.maps.Marker({
				position: pos,
				map: map,
				center: pos,
				icon: image
			});

			map.setCenter(pos);



		var locations = [
				<cfoutput query='GET_KOR_'>
					{lat: #COORDINATE_1#, lng: #COORDINATE_2#},
				</cfoutput>
			];
		var locationInfoStart=[
					<cfoutput query='GET_KOR_'>
						['<center><a href="#request.self#?fuseaction=#module_Name#.web_parts&company_id=#company_id#">#fullname#</a></center> #trim(COMPANY_ADDRESS)# / #ILCE#<center><a href="http://maps.apple.com/?q=#COORDINATE_1#,#COORDINATE_2#" style="color:##9C0431;"><b>Yol Tarifi Al <br><i class="fa-solid fa-map-location fa-lg"></i></b></a></center><!---<br><span style="color:red;"><cfif len(SEFA)>Tedarikçi  :#SEFA#</cfif></span><br><br>!---><!---Yol Tarifi&nbsp;&nbsp;<a href="http://maps.google.com/maps?q=#COORDINATE_1#,#COORDINATE_2#"><img src="/documents/#module_name#/icon/sef.png" width="15px"></a>!--->', #COORDINATE_1#, #COORDINATE_2#,4],
					</cfoutput>
				];
		for (i = 0; i < locations.length; i++) {  
			var image1 = {
					url: "/documents/offtrade/icon/green.png", // url
					scaledSize: new google.maps.Size(40, 40), // scaled size
					origin: new google.maps.Point(0,0), // origin
					anchor: new google.maps.Point(11, 23) // anchor
					}; 
				var marker = new google.maps.Marker({
			position: new google.maps.LatLng(locations[i].lat, locations[i].lng),
			map: map,
			icon:image1
			});

			var infowindow = new google.maps.InfoWindow();

			google.maps.event.addListener(marker, 'click', (function(marker, i) {
				return function() {
				infowindow.setContent(locationInfoStart[i][0]);
				infowindow.open(map, marker);
				}
			})(marker, i));
			
			infowindow.setContent(locationInfoStart[i][0]);
			infowindow.close(map, marker);
			}
			
	  }
	  var infowindow = new google.maps.InfoWindow();
 google.maps.event.addListener(marker, 'click', (function(marker, i) {
	return function() {
	infowindow.setContent(locationInfoStart[i][0]);
	infowindow.open(map, marker);
	}
})(marker, i));
	</script>

	<script async defer
	src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCK_PWv9uohJ1TsgzwmHuqXrMGfymDq_Bk&callback=initMap">
	</script>
