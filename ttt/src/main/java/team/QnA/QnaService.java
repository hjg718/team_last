package team.QnA;

import org.json.simple.JSONObject;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class QnaService {
	
	@Autowired
	private SqlSessionTemplate sqlsessiontemplate;

	public String  save(QnaVo vo){
		QnaDao dao = sqlsessiontemplate.getMapper(QnaDao.class);
		JSONObject job = new JSONObject();
		int input = dao.save(vo);
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
		QnaDao dao = sqlsessiontemplate.getMapper(QnaDao.class);
		QnaVo vo = dao.Recent(userId);
		return vo;
	}
}