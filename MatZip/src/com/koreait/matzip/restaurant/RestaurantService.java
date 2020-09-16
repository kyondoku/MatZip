package com.koreait.matzip.restaurant;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.Part;

import com.google.gson.Gson;
import com.koreait.matzip.CommonUtils;
import com.koreait.matzip.FileUtils;
import com.koreait.matzip.vo.RestaurantDomain;
import com.koreait.matzip.vo.RestaurantMenuVO;
import com.koreait.matzip.vo.RestaurantRecommendMenuVO;
import com.koreait.matzip.vo.RestaurantVO;
import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

public class RestaurantService {
	private RestaurantDAO dao;
	
	public RestaurantService() {
		dao = new RestaurantDAO();
	}
	
	public int restReg(RestaurantVO param) {
		return dao.insRestaurant(param);
	}
	
	public String getRestList() {
		List<RestaurantVO> list = dao.selRestList();
		Gson gson = new Gson();
		return gson.toJson(list);
	}
	
	public RestaurantDomain getRest(RestaurantVO param) {		
		return dao.selRest(param);
	}
	
	public int addMenus(HttpServletRequest request) { //메뉴 
		int i_rest = CommonUtils.getIntParameter("i_rest", request);
		
		String targetPath = request.getServletContext().getRealPath("/res/img/restaurant/" + i_rest + "/menu");
		FileUtils.makeFolder(targetPath);
        
		RestaurantRecommendMenuVO vo = new RestaurantRecommendMenuVO();
		vo.setI_rest(i_rest);

		try {
        	for (Part part : request.getParts()) {        
        		String fileNm = part.getSubmittedFileName();
        		
                if(fileNm != null) {
                	String ext = FileUtils.getExt(fileNm);
                	String saveFileNm = UUID.randomUUID() + ext;
                	part.write(targetPath + "/" + saveFileNm); //파일 저장

    				vo.setMenu_pic(saveFileNm);
    		        dao.insMenu(vo);
                }
            }
        } catch(Exception e) {
        	e.printStackTrace();
        }
		return i_rest;
	}
	
	public int addRecMenus(HttpServletRequest request) {
		String savePath = request.getServletContext().getRealPath("/res/img/restaurant");
		String tempPath = savePath + "/temp";
		FileUtils.makeFolder(tempPath);
		
		
		int maxFileSize = 10_485_760; // 1024 * 1024 * 10 (10mb)
		MultipartRequest multi = null;
		int i_rest = 0;
		String[] menu_nmArr = null;
		String[] menu_priceArr = null;
		List<RestaurantRecommendMenuVO> list = null;
		try {																		//같은 파일명있으면 뒤에 1 붙여준다.
			multi = new MultipartRequest(request, tempPath, maxFileSize, "UTF-8", new DefaultFileRenamePolicy());
			
			i_rest = CommonUtils.getIntParameter("i_rest", multi);
			
			menu_nmArr = multi.getParameterValues("menu_nm");
			menu_priceArr = multi.getParameterValues("menu_price");
			
			if(menu_nmArr == null || menu_priceArr == null) {
				return i_rest;
			}
			
			list = new ArrayList();
			for(int i=0; i<menu_nmArr.length; i++) {
				RestaurantRecommendMenuVO vo = new RestaurantRecommendMenuVO();
				vo.setI_rest(i_rest);
				vo.setMenu_nm(menu_nmArr[i]);
				vo.setMenu_price(CommonUtils.parseStringToInt(menu_priceArr[i]));
				list.add(vo);
			}	

			String targetPath = savePath + "/" + i_rest;
			FileUtils.makeFolder(targetPath);
			
			String originFileNm = "";
			
			Enumeration files = multi.getFileNames();
			while(files.hasMoreElements()) {
				//hasMoreElements는 rs.next와 다르게 가르키지는 않는다. 가르키는건 nextElement
				String key = (String)files.nextElement();
				originFileNm = multi.getFilesystemName(key);

				if(originFileNm != null) { // 파일 선택 안했으면 null이 넘어옴
					String ext = originFileNm.substring(originFileNm.lastIndexOf("."));
					String saveFileNm = UUID.randomUUID() + ext;					
			
				File oldFile = new File(tempPath + "/" + originFileNm);
				File newFile = new File(targetPath + "/" + saveFileNm);
				oldFile.renameTo(newFile);
				
				int idx = CommonUtils.parseStringToInt(key.substring(key.lastIndexOf("_") + 1));
				RestaurantRecommendMenuVO vo = list.get(idx);
				vo.setMenu_pic(saveFileNm);
				}
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		if(list != null) {
			for(RestaurantRecommendMenuVO vo : list) {
				dao.insRecommendMenu(vo);
			}
		}
		return i_rest;
	}
	
	public List<RestaurantRecommendMenuVO> getMenuList(int i_rest) {
		return dao.selMenuList(i_rest);
	}
	
	public List<RestaurantRecommendMenuVO> getRecommendMenuList(int i_rest) {
		return dao.selRecommendMenuList(i_rest);
	}
	
	public int delRecMenu(RestaurantRecommendMenuVO param) {
		return dao.delRecommendMenu(param);
	}
}
