package com.openGDSMobileApplicationServer.Controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.openGDSMobileApplicationServer.airQuality.AirQualityService;

@Controller
public class WebAirQualityController {
	
	@Autowired
	AirQualityService aqs;
	
	@RequestMapping("/airQualityCreateMap.do")
	public void createAirQualityMap(){
		System.out.println("ha");
		aqs.requestAirQualityMapCreate(null);
	}
}