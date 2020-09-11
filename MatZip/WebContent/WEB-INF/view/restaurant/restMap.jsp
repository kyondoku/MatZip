<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div id="sectionContainerCenter">
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=4c60cbf0c3fcc8772b7e3e33c2b33422"></script>
	<div id="mapContainer" style="width:100%; height:100%;"></div>
	<script>
		const options = {
			center: new kakao.maps.LatLng(35.866041, 128.593797),
			level: 3
		};

		const map = new kakao.maps.Map(mapContainer, options);
	</script>

</div>
