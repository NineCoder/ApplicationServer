<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
	<title>Mobile Web Application for Geospatial Data Using OpenGDS Mobile</title>
	<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
	
    <!-- dependency library CSS-->
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/egovframework/mbl/cmm/jquery.mobile-1.3.2.css" >   <!-- jQuery Mobile -->
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/egovframework/mbl/cmm/EgovMobile-1.3.2.css">      <!-- eGov Mobile -->
    <link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/ol3/ol.css">                      <!-- OpenLayers 3 -->

    <link rel="stylesheet" href="http://cdn.datatables.net/1.10.7/css/jquery.dataTables.min.css">      <!-- Data Table Plug-in -->

    <!-- dependency library JS-->
    <!-- egovFramework  KOREA-->
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/egovframework/mbl/cmm/jquery-1.9.1.min.js" charset="utf-8"></script>      <!-- jQuery -->
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/egovframework/mbl/cmm/jquery.mobile-1.3.2.min.js" charset="utf-8"></script> <!-- jQuery Mobile -->
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/egovframework/mbl/cmm/EgovMobile-1.3.2.js" charset="utf-8"></script>      <!-- eGov Mobile -->
    <script type="text/javascript" src="http://cdn.datatables.net/1.10.7/js/jquery.dataTables.min.js" charset="utf-8"></script> <!-- Data Table jQuery Plug-in-->

    <!-- Proj, OpenLayers3, D3 -->
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/proj4js/2.2.2/proj4.js" charset="utf-8"></script>                         <!-- Proj4js -->
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/ol3/ol.js" charset="utf-8"></script>                                      <!-- OpenLayers 3 -->
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/d3/d3.js" charset="utf-8"></script>                                       <!-- D3.js -->

	<script>
		var contextPath ='${pageContext.request.contextPath}';
		var addr = 'http://' + '${pageContext.request.serverName}';
		var port = '${pageContext.request.serverPort}';
		var serverAddr = addr + ':' + port + contextPath;
		var geoServerAddr = addr;
		geoServerAddr = 'http://113.198.80.9';
	</script>

    <script type="text/javascript" src="${pageContext.request.contextPath}/js/OpenGDSMobileLib/openGDSMobileClient1.3.js" charset="utf-8"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/main1.3.js" charset="utf-8"></script>
	
	<style>
        html, body{
            height : 100%;
        }

        #map{
            position : absolute;
            width : 100%;
            height : 100%;
        }
		#d3viewonMap{
			z-index:10;
			position:absolute;
			overflow-x:hidden;
			overflow-y:auto;
			height:300px;
			background : rgba(255,255,255,0.7);
		}
		#interpolationMap{
			z-index:10;
			position:absolute;
			overflow-x:hidden;
			overflow-y:auto;
			height:300px;
			background : rgba(255,255,255,0.7);
		}
		.font{
			font-size:70%;
		}
        #wfslayersList{
            height : 400px;
            overflow-y: auto;
        }
/* openGDS Mobile Demo CSS */
        /* basemap select*/
        .OGDSPosTopRight{
            position : absolute;
            z-index : 1000;
            top : 6px;
            left : auto;
            right : 10px;
        }
        /* attribute checkbox*/
        .OGDSPosBottomRight{
            position : absolute;
            z-index : 1000;
            bottom : 8px;
            right : 0px;
        }
        .OGDSPosTransLeftHide{
            transition: right 0.1s ease;
            position : absolute;
            right : -110px;
        }
        .OGDSPosTransLeftShow{
            transition: right 0.1s ease;
            position : absolute;
            right : 0px;
        }
        /* data list button*/
        .OGDSPosTopCenter{
            position : absolute;
            z-index : 999;
            width : 100%;
            left : 210px;
        }
        .OGDSPosTransTopDownHide{
            transition: top 0.1s ease;
            position : absolute;
            width : 100%;
            height : 20%;
            background : rgba(255,255,255,.5);
            z-index: 10001;
            top :-100%;
        }
        .OGDSPosTransTopDownShow{
            transition: top 0.1s ease;
            position : absolute;
            width : 100%;
            height : 20%;
            background : rgba(255,255,255,.5);
            z-index: 10001;
            top :0%;
        }
        #tableTab{
            list-style:none;
            position:relative;
            margin:0px;
            z-index:2;
            top:1px;
            display:table;
            border-left:1px solid #f5ab36;
        }
        #tableTab li {
            float:left;
        }
        #tableTab li a{
            background:#ffd89b;
            color:#222;
            display:block;
            padding:6px 15px;
            text-decoration:none;
            border-right:1px solid #f5ab36;
            border-top:1px solid #f5ab36;
            border-right:1px solid #f5ab36;
            margin:0;
        }
        #tableTab li a.selected {
            border-bottom:1px solid #fff;
            color:#344385;background:#fff;
        }
	</style>
</head>
<body>
<div data-role="page">
    <!--Content-->
	<div data-role="content" style="padding:0; margin:0;">
        <div id="map" style="padding:0; margin:0;"></div>
        <div id="menuButton" class="OGDSPosTopCenter">
            <div data-role="controlgroup" data-type="horizontal">
                <a href="#vworldList" data-role="button" data-rel="popup" data-mini="true" data-inline="true"
                   data-position-to="window" onclick="vworldWMSUI()">국토/토지(공간정보오픈플랫폼:VWorld)</a>
                <a href="#WFSList" data-role="button" data-rel="popup" data-mini="true" data-inline="true" data-transition="slidefade">
                    도로명 전자지도(국가공간정보유통시스템)</a>
                <a href="#opendataList" data-role="button" data-rel="popup" data-mini="true" data-inline="true" data-transition="slidefade">
                    공공 데이터</a>
                <a href="#attrDataList" data-role="button" data-rel="popup" data-mini="true" data-inline="true" data-transition="slidefade">
                    저장 데이터(속성정보)</a>
            </div>
        </div>
        <div id="mapSelect" class="OGDSPosTopRight"></div>
        <div id="layerList"></div>
        <div id="dataViewCheckBox" class="OGDSPosBottomRight OGDSPosTransLeftHide">
            <fieldset data-role="controlgroup" data-type="horizontal">
                <input type="checkbox" id="attrChk" data-theme="g"> <label for="attrChk">속성정보</label>
                <input type="checkbox" id="attrEditChk" data-theme="a"> <label for="attrEditChk">편집모드</label>
            </fieldset>
        </div>
        <div id="attributeTable" class="OGDSPosTransTopDownHide">
        </div>
	</div>

    <!---custom div-->
    <!-- d3And Map div -->
    <div id="interpolationMap">
		<a href="#" data-role="button"
		     data-theme="a" data-icon="delete"
		     data-iconpos="notext" class="ui-btn-right" onclick="$('#interpolationMap').hide()"> Close</a><br>
		<img id="interpolationMapImage" src=""/>
		</div>
		<div id="d3viewonMap">
		  <a href="#" data-role="button"
		     data-theme="a" data-icon="delete"
		     data-iconpos="notext" class="ui-btn-right" onclick="$('#d3viewonMap').hide()"> Close</a>
		  <div id="range">
              			<table style="margin:0 auto">
              				<tr>
              					<td style="background:#0090ff; margin:0; padding:0">　</td>
              					<td style="background:#008080; margin:0; padding:0">　</td>
              					<td><span class="font">Good</span></td>
              					<td style="background:#4CFF4C; margin:0; padding:0">　</td>
              					<td style="background:#99FF99; margin:0; padding:0">　</td>
              					<td><span class="font">Normal</span></td>
              					<td style="background:#FFFF00; margin:0; padding:0">　</td>
              					<td style="background:#FFFF99; margin:0; padding:0">　</td>
              					<td><span class="font">Sensitive</span></td>
              					<td style="background:#FF9900; margin:0; padding:0">　</td>
              					<td><span class="font">Bad</span></td>
              					<td style="background:#FF0000; margin:0; padding:0">　</td>
              					<td><span class="font">Very Bad</span></td>
              				</tr>
              			</table>
            </div>
            <div id="d3viewonMap_sub"> </div>
		</div>
<!-- Vworld WMS -->
		<div data-role="popup"
		id="vworldList"
		data-overlay-theme="a"
		style="padding: 15px">
            <p>서로 다른 레이어 최대 5개 선택 가능</p>
            <div id="vworldSelect"> </div>
		</div>
<!-- Public Data PopUp -->
		<div id="setting"
		data-role="popup"
		data-overlay-theme="a"
		style="width:250px; text-align:center; align:center;">
		</div>
<!-- Public Data Select -->
		<div data-role="popup" id="dataSelect" data-overlay-theme="a">
		  <div id="range">
              			<table style="margin:0 auto">
              				<tr>
              					<td style="background:#0090ff; margin:0; padding:0">　</td>
              					<td style="background:#008080; margin:0; padding:0">　</td>
              					<td><span class="font">Good</span></td>
              					<td style="background:#4CFF4C; margin:0; padding:0">　</td>
              					<td style="background:#99FF99; margin:0; padding:0">　</td>
              					<td><span class="font">Normal</span></td>
              					<td style="background:#FFFF00; margin:0; padding:0">　</td>
              					<td style="background:#FFFF99; margin:0; padding:0">　</td>
              					<td><span class="font">Sensitive</span></td>
              					<td style="background:#FF9900; margin:0; padding:0">　</td>
              					<td><span class="font">Bad</span></td>
              					<td style="background:#FF0000; margin:0; padding:0">　</td>
              					<td><span class="font">Very Bad</span></td>
              				</tr>
              			</table>
            </div>
			<div id="d3View"> </div>
		</div>
<!-- Attribute Data Save -->
        <div data-role="popup" id="attrDataList">
            <p id="NotData">데이터 없음</p>
            <ul data-role="listview" id="attrList">

            </ul>
        </div>
<!--WFS PopUp-->
        <div data-role="popup" id="WFSList">
            <ul data-role="listview" id="wfslayersList">
                <li data-theme="z" data-role="list-divider">도로명 전자지도</li>
                <li><a href="#" onclick="wfsLoad('seoul_sig', 'sig_kor_nm')">서울특별시(구 단위)</a></li>
                <li><a href="#" onclick="wfsLoad('seoul_emd', 'emd_kor_nm')">서울특별시(동 단위)</a></li>
                <li><a href="#" onclick="wfsLoad('incheon_emd', 'emd_kor_nm')">인천광역시(동 단위)</a></li>
                <li><a href="#" onclick="wfsLoad('sejong_emd', 'emd_kor_nm')">세종특별자치시(동 단위)</a></li>
                <li><a href="#" onclick="wfsLoad('daejong_emd', 'emd_kor_nm')">대전광역시(동 단위)</a></li>
                <li><a href="#" onclick="wfsLoad('daegu_emd', 'emd_kor_nm')">대구광역시(동 단위)</a></li>
                <li><a href="#" onclick="wfsLoad('ulsan_emd', 'emd_kor_nm')">울산광역시(동 단위)</a></li>
                <li><a href="#" onclick="wfsLoad('gwangju_emd', 'emd_kor_nm')">광주광역시(동 단위)</a></li>
                <li><a href="#" onclick="wfsLoad('busan_emd', 'emd_kor_nm')">부산광역시(동 단위)</a></li>
                <li><a href="#" onclick="wfsLoad('chungbuk_sig', 'sig_kor_nm')">충청북도(구 단위)</a></li>
                <li><a href="#" onclick="wfsLoad('chungnam_sig', 'sig_kor_nm')">충청남도(구 단위)</a></li>
                <li><a href="#" onclick="wfsLoad('gangwon_sig', 'sig_kor_nm')">강원도(구 단위)</a></li>
                <li><a href="#" onclick="wfsLoad('gyeonggi_sig', 'sig_kor_nm')">경기도(구 단위)</a></li>
                <li><a href="#" onclick="wfsLoad('Gyeongsangbuk_sig', 'sig_kor_nm')">경상북도(구 단위)</a></li>
                <li><a href="#" onclick="wfsLoad('Gyeongsangnam_sig', 'sig_kor_nm')">경상남도(구 단위)</a></li>
                <li><a href="#" onclick="wfsLoad('Jeju_sig', 'sig_kor_nm')">제주도(구 단위)</a></li>
                <li><a href="#" onclick="wfsLoad('Jellanam_sig', 'sig_kor_nm')">전라남도(구 단위)</a></li>
                <li><a href="#" onclick="wfsLoad('Jeollabuk_sig', 'sig_kor_nm')">전라북도(구 단위)</a></li>
            </ul>
        </div>
<!--Open Data PopUp-->
        <div data-role="popup" id="opendataList">
            <ul data-role="listview">
                <li data-theme="z" data-role="list-divider">데이터 셋</li>
                <li><a href="#" onclick="wfsLoad('seoul_env_position', 'name')">환경 센서위치(서울열린데이터광장)</a></li>
                <li><a href="#" onclick="wfsLoad('city_wer_mse_esb_loca_w','point')">도시 기상 관측망(서울열린데이터광장)</a></li>
                <li><a href="#" onclick="wfsLoad('sejong_population_wgs84')">인구 데이터(세종특별시2013.1.-2014.2.)</a></li>
                <li data-theme="z" data-role="list-divider">오픈 API</li>
                <li><a href="#setting" data-rel="popup" data-position-to="window"
                       onclick="createSeoulPublicAreaEnvUI()">서울시 실시간 대기환경(서울열린데이터광장)</a></li>
                <li><a href="#setting" data-rel="popup" data-position-to="window"
                       onclick="createPublicPortalUI('airKorea')">전국 실시간 대기환경(공공데이터포털: 에어코리아)</a></li>
                <li><a href="#setting" data-rel="popup" data-position-to="window"
                       onclick="createPublicPortalUI('nuclear')">원자력발전소 실시간 주변 방사선량(공공데이터포털: 한국수력원자력)</a></li>
                <li><a href="#setting" data-rel="popup" data-position-to="window"
                       onclick="createPublicPortalUI('greengas')">온실가스배출량 조회 서비스(공공데이터포털: 한국지역난방공사)</a></li>
            </ul>
        </div>
    </div> 
</body>
</html>

