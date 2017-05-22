<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8" trimDirectiveWhitespaces="true"%>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
    <%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>도서 수정</title>
<script src="http://code.jquery.com/jquery-3.1.1.min.js"></script>
<c:url var="url" value="/resources/jquery.bootpag.min.js" />
<script src="${url }"></script>
<link href="<c:url value='/resources/assets/css/bootstrap.css'/>" rel="stylesheet" />
<link href="<c:url value='/resources/assets/css/bootstrap-theme.css'/>" rel="stylesheet" />
<link href="<c:url value='/resources/assets/css/style.css'/>" rel="stylesheet" />
<link rel="stylesheet" href="<c:url value='/resources/assets/color/default.css'/>">
<script src="<c:url value='/resources/assets/js/bootstrap.js'/>"></script>
<script>
$(function(){
	if(${error==true}){
		$("#bookFormBody").text("정보수정을 실패했습니다.");
		$('#bookForm').modal('show');
	}
	
	$("#cover").change(function(e){
		var reader = new FileReader();
		reader.onload = function (e){
			document.getElementById("coverimg").src= reader.result; 
		}
		reader.readAsDataURL(this.files[0]);
	});
});
function logout() {
	$("#logout").submit();
}
function re() {
	$('#bnamediv').removeClass("has-error");
	$('#authordiv').removeClass("has-error");
	$('#bindexdiv').removeClass("has-error");
	$('#publisherdiv').removeClass("has-error");
	$('#bcontentsdiv').removeClass("has-error");
	$('#pdatediv').removeClass("has-error");
	$('#catediv').removeClass("has-error");
	var check = false;
	for(var i=0;i<$(".cate").length;i++){
		if($(".cate")[i].checked){
			check=true;
		}
	}
	
	if($("#bname").val()==""){
		$("#bookFormBody").text("도서 제목을 입력해주세요.");
		$('#bookForm').modal('show');
		$('#bnamediv').addClass("has-error");
		return false;
	}
	else if($("#author").val()==""){
		$("#bookFormBody").text("저자를 입력해주세요.");
		$('#bookForm').modal('show');
		$('#authordiv').addClass("has-error");
		return false;
	}
	else if($("#bindex").val()==""){
		$("#bookFormBody").text("목차를 입력해주세요.");
		$('#bookForm').modal('show');
		$('#bindexdiv').addClass("has-error");
		return false;
	}
	else if($("#publisher").val()==""){
		$("#bookFormBody").text("출판사를 입력해주세요.");
		$('#bookForm').modal('show');
		$('#publisherdiv').addClass("has-error");
		return false;
	}
	else if($("#bcontents").val()==""){
		$("#bookFormBody").text("상세내용을 입력해주세요.");
		$('#bookForm').modal('show');
		$('#bcontentsdiv').addClass("has-error");
		return false;
	}
	else if($("#pdate").val()==""){
		$("#bookFormBody").text("출판일을 입력해주세요.");
		$('#bookForm').modal('show');
		$('#pdatediv').addClass("has-error");
		return false;
	}
	else if(!check){
		$("#bookFormBody").text("카테고리를 선택해주세요.");
		$('#bookForm').modal('show');
		$('#catediv').addClass("has-error");
		return false;
	}
	return true;
}
</script>
<style>
#cate{
text-align: left;
}
#cover{
display: inline-block;
width: 70%;
}

</style>
</head>
<body>
	<header>
		<div id="navigation"class="navbar navbar-inverse navbar-fixed-top default"role="navigation">
			<div class="container">
				<!-- Brand and toggle get grouped for better mobile display -->
				<div class="navbar-header">
					<button type="button" class="navbar-toggle" data-toggle="collapse"
						data-target="#bs-example-navbar-collapse-1">
						<span class="icon-bar"></span> 
						<span class="icon-bar"></span> 
						<span class="icon-bar"></span>
					</button>
					<a class="navbar-brand" href="<c:url value="/"/>">Groovin</a>
				</div>
				<div>
					<div class="collapse navbar-collapse"
						id="bs-example-navbar-collapse-1">
						<nav>
						
						<ul class="nav navbar-nav navbar-left">
						<sec:authorize access="hasAuthority('ADMIN')">
									<li><a href="<c:url value="/user/join"/>">매니저계정만들기</a></li>
								</sec:authorize>
					</ul>
						<ul class="nav navbar-nav navbar-right" id="mynav">
								<sec:authentication var="id" property="name" />
								<c:url var="user" value="/user/info">
									<c:param name="id" value="${id }" />
								</c:url>
								<sec:authorize access="isAuthenticated()">
									<li><a href="javascript:logout();">로그아웃</a></li>
									<li><a href="${user}">내정보보기</a></li>
								</sec:authorize>
							<li><a href="<c:url value="/qna/list"/>">Q&amp;A게시판</a></li>
							<li><a href="<c:url value="/board/list"/>">자유게시판</a></li>
							</ul>
					
							<form action="<c:url value="/book/search"/>" method="post" onsubmit="return check();"
							class="navbar-form navbar-right" id="searchForm">
								<input type="hidden" name="${_csrf.parameterName }"
									value="${_csrf.token }"> 
									<select name="category" class="form-control input-lg">
									<option value="bname">제목</option>
									<option value="author">저자</option>
									<option value="publisher">출판사</option>
								</select> 
								<input type="text" name="keyword" id="key" class="form-control input-lg" placeholder="도서정보를 입력해주세요">
								<button type="submit" class="btn btn-theme" >검색</button>
							</form>
							
						</nav>
					</div>
					<!-- /.navbar-collapse -->
				</div>
			</div>
		</div>
	</header>
	<section id="addcon" class="section gray">
<div class="container">
<div class="row">
<div class="col-md-8 col-md-offset-2">
<div class="heading">
<h3> 도서 정보 수정</h3>
</div>
<P></P>
<div id="inputCon">

<form:form commandName="book.vo" action="edit?${_csrf.parameterName }=${_csrf.token }"
enctype="multipart/form-data" method="post" class="form-horizontal" onsubmit="return re();">
  <form:hidden path="bnum"/>
 <div class="form-group" id="coverdiv">
    <label for="cover" class="col-sm-2 control-label">표지</label>
    <div class="col-sm-10">
    <img src="<c:url value="/book/img?coverName=${book.vo.coverName}"/>" width="29%" height="170px" id="coverimg" class="img-rounded">
      <form:input path="cover" type="file" class="form-control" id="cover" />
    </div>
  </div>
  
<div class="form-group" id="bnamediv">
    <label for="bname" class="col-sm-2 control-label">도서 제목</label>
    <div class="col-sm-10">
      <form:input path="bname" class="form-control" id="bname" placeholder="도서 제목을 입력해주세요"/>
    </div>
  </div>
<div class="form-group" id="authordiv">
    <label for="author" class="col-sm-2 control-label">저자</label>
    <div class="col-sm-10">
      <form:input path="author" class="form-control" id="author" placeholder="저자를 입력해주세요"/>
    </div>
  </div>
  
<div class="form-group" id="bindexdiv">
    <label for="bindex" class="col-sm-2 control-label">목차</label>
    <div class="col-sm-10">
    <form:textarea path="bindex" class="form-control" rows="5" style="resize: none;" id="bindex" placeholder="목차를 입력해주세요" />
    </div>
  </div>
  
  <div class="form-group" id="publisherdiv">
    <label for="publisher" class="col-sm-2 control-label">출판사</label>
    <div class="col-sm-10">
      <form:input path="publisher" class="form-control" id="publisher" placeholder="출판사를 입력해주세요"/>
    </div>
  </div>
  
  <div class="form-group" id="bcontentsdiv">
    <label for="bcontents" class="col-sm-2 control-label">상세내용</label>
    <div class="col-sm-10">
    <form:textarea path="bcontents" class="form-control" rows="5" style="resize: none;" id="bcontents" placeholder="상세내용을 입력해주세요" />
    </div>
  </div>
  
    <div class="form-group" id="pdatediv">
    <label for="pdate" class="col-sm-2 control-label">출판일</label>
    <div class="col-sm-10">
    <form:input path="pdate" type="date" class="form-control" id="pdate" />
    </div>
  </div>
  
    <div class="form-group" id="catediv">
    <label class="col-sm-2 control-label">카테고리</label>
    <div class="col-sm-10" id="cate">
   
  	<label class="checkbox-inline">
  	<form:checkbox path="cate" class="cate" value="소설" label="소설" />
	</label>
	
	<label class="checkbox-inline">
	<form:checkbox path="cate" class="cate" value="에세이" label="에세이" />
	</label>
	
	<label class="checkbox-inline">
	<form:checkbox path="cate" class="cate" value="시" label="시" />
	</label>
	
	<label class="checkbox-inline">
	<form:checkbox path="cate" class="cate" value="수필" label="수필" />
	</label>
	
	<label class="checkbox-inline">
	<form:checkbox path="cate" class="cate" value="자서전" label="자서전" />
	</label>
	
	<label class="checkbox-inline">
	<form:checkbox path="cate" class="cate" value="여행" label="여행" />
	</label>
	
	<label class="checkbox-inline">
	<form:checkbox path="cate" class="cate" value="사회/이슈" label="사회/이슈" />
	</label>
	<br>
	<label class="checkbox-inline">
	<form:checkbox path="cate" class="cate" value="과학" label="과학" />
	</label>
	
	<label class="checkbox-inline">
	<form:checkbox path="cate" class="cate" value="위인/전기" label="위인/전기" />
	</label>
	
	<label class="checkbox-inline">
	<form:checkbox path="cate" class="cate" value="기술서" label="기술서" />
	</label>
	
	<label class="checkbox-inline">
	<form:checkbox path="cate" class="cate" value="만화" label="만화" />
	</label>
	
	<label class="checkbox-inline">
	<form:checkbox path="cate" class="cate" value="요리" label="요리" />
	</label>
	
	<label class="checkbox-inline">
	<form:checkbox path="cate" class="cate" value="음악" label="음악" />
	</label>
	
	<label class="checkbox-inline">
	<form:checkbox path="cate" class="cate" value="학습서" label="학습서" />
	</label>
	 <div class="help-block">중복 선택 가능합니다.</div>
    </div>
 	</div>
  <div id="bset">
<button type="submit" class="btn btn-theme">저장하기</button>
<button type="reset" class="btn btn-theme">다시 작성하기</button>
</div>
</form:form>
</div>
</div>
</div>
</div>
</section>
<!--로그아웃  -->
<form action="<c:url value="/logout"/>" method="post" id="logout">
<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }">
</form>
<!--입력폼  -->
<div class="modal fade" id="bookForm" tabindex="-1"
		aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-body" id="bookFormBody">
				</div>
				<div class="modal-footer">
					<button type="button" class="close" data-dismiss="modal"
					aria-label="Close">
					확인
				</button>
				</div>
			</div>
		</div>
	</div>
</body>
</html>