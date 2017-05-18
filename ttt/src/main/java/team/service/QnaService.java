package team.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import jdk.nashorn.internal.scripts.JS;
import team.QnA.Qna;
import team.QnA.QnaDao;
import team.QnA.QnaVo;

@Service
public class QnaService {
	
	@Autowired
	private SqlSessionTemplate sqlST;

	public String  save(QnaVo vo){
		QnaDao dao = sqlST.getMapper(QnaDao.class);
		JSONObject job = new JSONObject();
		int input = dao.save(vo);
		System.out.println("svc"+vo.getPwd());
		boolean ok ;
		if(input == 0){
			ok = false;
		}else {
			ok = true;
		}
		job.put("save",ok);
		return job.toJSONString();
	}
	
	public QnaVo Recent(String userId){
		QnaDao dao = sqlST.getMapper(QnaDao.class);
		QnaVo vo = dao.Recent(userId);
		return vo;
	}
	
	
	public ArrayList<QnaVo> List(){
		QnaDao dao = sqlST.getMapper(QnaDao.class);
		return dao.List();
	}
	
	
	public String Page(int num){
		QnaDao dao = sqlST.getMapper(QnaDao.class);
		JSONArray jarr = new JSONArray();
		Qna list = dao.getPage(num);
		for(int i=0; i<list.getList().size(); i++){
			JSONObject job = new JSONObject();
			job.put("title",list.getList().get(i).getTitle());
			job.put("num",list.getList().get(i).getNum());
			job.put("author",list.getList().get(i).getAuthor());
			jarr.add(job);
		}
		return jarr.toJSONString();
	}
	

	public QnaVo Read(int num){
		QnaDao dao = sqlST.getMapper(QnaDao.class);
		return dao.Read(num);
	}
	
	public String Find(String keyword,String category,int pgnum){
		QnaDao dao = sqlST.getMapper(QnaDao.class);
		JSONArray jarr = new JSONArray();
		ArrayList<QnaVo> list = dao.Find(keyword,category,pgnum);
		for(int i=0; i<list.size(); i++){
			JSONObject job = new JSONObject();
			job.put("num",list.get(i).getNum());
			job.put("title",list.get(i).getTitle());
			job.put("author",list.get(i).getAuthor());
			job.put("total",list.get(i).getTotalpages());
			job.put("curr",list.get(i).getPage());
			jarr.add(job);
		}
		return jarr.toJSONString();
	}
	
	
	public int Modify(QnaVo vo,HttpSession session){
		QnaDao dao = sqlST.getMapper(QnaDao.class);
		session.setAttribute("userId",vo.getAuthor());
		Map<String,Boolean> map = new HashMap<String,Boolean>();
		int mod = dao.Modify(vo);
		boolean ok ;
		if(mod==0){
			ok = false;
		}else{
			ok = true;
		}
		map.put("save", ok);
		return mod;
	}
	
	public String Delete(int num){
		QnaDao dao = sqlST.getMapper(QnaDao.class);
		int del = dao.Delete(num);
		JSONObject job = new JSONObject();
		boolean ok = false;
		if(del > 0){
			ok = true;
			job.put("remove",ok);
		}
		return job.toJSONString();
		
	}
	
}
