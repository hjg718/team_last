package team.service;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import team.book.model.Book;
import team.book.model.BookDao;
import team.book.model.BookVo;

@Service
public class BookService {

	@Autowired
	private SqlSessionTemplate sqlST;
	
	public Book search(String keyword,String category){
		BookDao dao = sqlST.getMapper(BookDao.class);
		Book book= dao.search(keyword,category,1);
		return book;
	}

	public boolean add(BookVo vo) {
		BookDao dao = sqlST.getMapper(BookDao.class);
		MultipartFile file = vo.getCover();
		String[] name= file.getOriginalFilename().split("\\.");
		vo.setCoverName(name[1]);
		int row = dao.add(vo);
		if(row>0){
			for(int i=0;i<vo.getCate().size();i++){
				dao.addcate(vo.getBnum(),vo.getCate().get(i));
			}
			InputStream ins = null;
			OutputStream ous = null;
			try {
				ins = file.getInputStream();
				String coverName= vo.getBnum()+"."+name[1];
				File f = new File("D:/upload/"+coverName);
				byte[] buf = new byte[1024];
				int read = 0;
				ous = new FileOutputStream(f);
				while((read=ins.read(buf))!=-1){
					ous.write(buf, 0, read);
					ous.flush();
				}
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}finally {
				try {
					ins.close();
					ous.close();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			return true;
		}
		return false;
	}

	public BookVo recent(int bnum) {
		BookDao dao = sqlST.getMapper(BookDao.class);
		BookVo book = dao.read(bnum);
		List<String> cate= dao.getcate(bnum);
		book.setCate(cate);
		return book;
	}

	public String searchPage(String keyword, String category, int page) {
		BookDao dao = sqlST.getMapper(BookDao.class);
		Book book= dao.search(keyword,category,page);
		List<BookVo> list= book.getList();
		JSONArray jarr = new JSONArray();
		for(int i=0;i<list.size();i++){
			JSONObject jobj = new JSONObject();
			jobj.put("bnum", list.get(i).getBnum());
			jobj.put("bname", list.get(i).getBname());
			jobj.put("coverName", list.get(i).getCoverName());
			jobj.put("publisher", list.get(i).getPublisher());
			jobj.put("author", list.get(i).getAuthor());
			jarr.add(jobj);
		}
		return jarr.toJSONString();
	}

	public Book read(int bnum) {
		BookDao dao = sqlST.getMapper(BookDao.class);
		BookVo vo= dao.read(bnum);
		List<String> cate= dao.getcate(bnum);
		vo.setCate(cate);
		Book book = dao.readRental(bnum);
		if(book!=null){
			Calendar cal = new GregorianCalendar(Locale.KOREA);
			cal.setTime(book.getRentaldate());
			cal.add(Calendar.DAY_OF_YEAR, 10);
			SimpleDateFormat sd = new SimpleDateFormat("MM-dd");
			String returndate = sd.format(cal.getTime());
			book.setReturndate(returndate);
		}
		else if(book==null){
			book = new Book();
		}
		int num = dao.checkBook(bnum);
		List<String> subscriber = dao.subscriber(bnum);
		book.setBookingnum(num);
		book.setSubscriber(subscriber);
		book.setVo(vo);
		return book;
	}

	public String rental(int booknum, String userid) {
		BookDao dao = sqlST.getMapper(BookDao.class);
		JSONObject jobj = new JSONObject();
		int pass = dao.check(userid);
			if(pass>0){
				int row = dao.rental(booknum,userid);
				if(row>0){
					dao.addCurrbook(userid);
					jobj.put("pass", true);
				}
			}
			else jobj.put("pass", false);
		return jobj.toJSONString();
	}

	public String returnBook(int num,String id) {
		BookDao dao = sqlST.getMapper(BookDao.class);
		JSONObject jobj = new JSONObject();
		int row = dao.returnBook(num);
		if(row>0){
			dao.decCurrbook(id);
			jobj.put("pass", true);
		}
		return jobj.toJSONString();
	}

	public String booking(int booknum, String userid) {
		BookDao dao = sqlST.getMapper(BookDao.class);
		JSONObject jobj = new JSONObject();
		int pass = dao.checkBook(booknum);
			if(pass<5){
				int row = dao.booking(booknum,userid);
				if(row>0){
					jobj.put("pass", true);
				}
			}
			else jobj.put("pass", false);
		return jobj.toJSONString();
	}
}
