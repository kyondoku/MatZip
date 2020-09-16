<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
   	<style>
	   	.label {margin-bottom: 96px;}
		.label * {display: inline-block;vertical-align: top;}
		.label .left {background: url("https://t1.daumcdn.net/localimg/localimages/07/2011/map/storeview/tip_l.png") no-repeat;display: inline-block;height: 24px;overflow: hidden;vertical-align: top;width: 7px;}
		.label .center {background: url(https://t1.daumcdn.net/localimg/localimages/07/2011/map/storeview/tip_bg.png) repeat-x;display: inline-block;height: 24px;font-size: 12px;line-height: 24px;}
		.label .right {background: url("https://t1.daumcdn.net/localimg/localimages/07/2011/map/storeview/tip_r.png") -1px 0  no-repeat;display: inline-block;height: 24px;overflow: hidden;width: 6px;}
		/*
		.customoverlay {position:relative;bottom:85px;border-radius:6px;border: 1px solid #ccc;border-bottom:2px solid #ddd;float:left;}
		.customoverlay:nth-of-type(n) {border:0; box-shadow:0px 1px 2px #888;}
		.customoverlay a {display:block;text-decoration:none;color:#000;text-align:center;border-radius:6px;font-size:14px;font-weight:bold;overflow:hidden;background: #d95050;background: #d95050 url(https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/arrow_white.png) no-repeat right 14px center;}
		.customoverlay .title {display:block;text-align:center;background:#fff;margin-right:35px;padding:10px 15px;font-size:14px;font-weight:bold;}
		.customoverlay:after {content:'';position:absolute;margin-left:-12px;left:50%;bottom:-12px;width:22px;height:12px;background:url('https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/vertex_white.png')}
		*/
   	</style>
    
<div id="sectionContainerCenter">
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=4c60cbf0c3fcc8772b7e3e33c2b33422"></script>
	<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
	<div id="mapContainer" style="width:100%; height:100%;"></div>
	<script>

	const options = {
			center: new kakao.maps.LatLng(35.866041, 128.593797),
			level: 5 //지도의 레벨
		};

		var map = new kakao.maps.Map(mapContainer, options);
		
		console.log(map.getCenter())

		function getRestaurantList() {
			axios.get('/restaurant/ajaxGetList').then(function(res) {
				console.log(res.data)
				
				res.data.forEach(function(item) {
					createMarker(item)
				})	
			})
		}	
		getRestaurantList()
		
		function createMarker(item) {
			var content = document.createElement('div')
			content.className = 'label'

			var leftSpan = document.createElement('span')
			leftSpan.className = 'left'
			
			var rightSpan = document.createElement('span')
			rightSpan.className = 'right'
			
			var centerSpan = document.createElement('span')
			centerSpan.className = 'center'
			centerSpan.innerText = item.nm
			
			content.appendChild(leftSpan)
			content.appendChild(centerSpan)
			content.appendChild(rightSpan)
			
			var mPos = new kakao.maps.LatLng(item.lat, item.lng)
			var marker = new kakao.maps.CustomOverlay({
				position: mPos,
				content: content
			});
			
			/*
			kakao.maps.event.addListener(marker, 'click', function() {
				console.log('마커 클릭 : ' + item.i_rest)
			});
			*/
			
			addEvent(content, 'click', function() {
				console.log('마커 클릭: ' + item.i_rest)
				moveToDetail(item.i_rest)
			})
			
			marker.setMap(map)
		}
		
		function moveToDetail(i_rest) {
			location.href = '/restaurant/restDetail?i_rest=' + i_rest
		}
		
		function addEvent(target, type, callback) {
			if(target.addEventListener) {
				target.addEventListener(type, callback);
			} else {
				target.attachEvent('on' + type, callback);
			}
		}
		

		//check for Geolocation support
		
		if(navigator.geolocation) {
			console.log('Geolocation is supported!');
		
			var startPos;
			navigator.geolocation.getCurrentPosition(function(pos) {
				startPos = pos
				console.log('lat : ' + startPos.coords.latitude)
				console.log('lng : ' + startPos.coords.longitude)
				
				if(map) {
				var moveLatLon = new kakao.maps.LatLng(startPos.coords.latitude, startPos.coords.longitude);
				map.panTo(moveLatLon)
				}
			});
			
		} else {
			console.log('Geolocation is not supported for this Browser/OS.');
		}
		
		
		/*
		var mapOption = { 
		        center: new kakao.maps.LatLng(35.866041, 128.593797), // 지도의 중심좌표
		        level: 5 // 지도의 확대 레벨
		    };
		
			var map = new kakao.maps.Map(mapContainer, mapOption);
	
			function getRestaurantList() {
				axios.get('/restaurant/ajaxGetList').then(function(res) {
					console.log(res.data)
					
					res.data.forEach(function(item) {
						createMarker(item)
					})	
				})
			}	
			getRestaurantList()
	
		var imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_red.png', // 마커이미지의 주소입니다    
		    imageSize = new kakao.maps.Size(64, 69), // 마커이미지의 크기입니다
		    imageOption = {offset: new kakao.maps.Point(27, 69)}; // 마커이미지의 옵션입니다. 마커의 좌표와 일치시킬 이미지 안에서의 좌표를 설정합니다.
	
	
		// 마커를 생성합니다
		function createMarker(item) {
		    // 마커의 이미지정보를 가지고 있는 마커이미지를 생성합니다
			var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption),
			    markerPosition = new kakao.maps.LatLng(item.lat, item.lng); // 마커가 표시될 위치입니다
			// 커스텀 오버레이에 표출될 내용으로 HTML 문자열이나 document element가 가능합니다
			var content = `<div class="customoverlay"><a href="https://search.daum.net/search?w=tot&DA=YZR&t__nil_searchbox=btn&sug=&sugo=&sq=&o=&q=\${item.nm}"><span class="title">\${item.nm}</span></a></div>`;
			// 커스텀 오버레이가 표시될 위치입니다 
		    	
			var marker = new kakao.maps.Marker({
			  position: markerPosition,
			  image: markerImage // 마커이미지 설정 
			});
			
			var position = new kakao.maps.LatLng(item.lat, item.lng);  
			// 마커가 지도 위에 표시되도록 설정합니다
			marker.setMap(map);  
			// 커스텀 오버레이를 생성합니다
			var customOverlay = new kakao.maps.CustomOverlay({
			    map: map,
			    position: position,
			    content: content,
			    yAnchor: 1 
			})		
	    }
	    */

	</script>
</div>
