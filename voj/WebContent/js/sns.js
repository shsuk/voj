/************************************************************************
* 1. 함수명 : goYozmDaum(link,prefix,parameter)
* 2. 용  도 : 요즘 SNS 서비스와 연동작업을 제어한다.
* 4. 버  전 : ver 1.0.0
* 5. 로  그
*************************************************************************/
function goYozmDaum(link,prefix,parameter)
{
 var href = "http://yozm.daum.net/api/popup/prePost?link=" + encodeURIComponent(link) + "&prefix=" + encodeURIComponent(prefix) + "&parameter=" + encodeURIComponent(parameter);
 var a = window.open(href, 'yozmSend', 'width=466, height=356');
 if ( a ) {
 a.focus();
 }
}
/************************************************************************
* 1. 함수명 : sendTwitter(title,url)
* 2. 용  도 : 트위터 SNS 서비스와 연동작업을 제어한다.
* 4. 버  전 : ver 1.0.0
* 5. 로  그
*************************************************************************/
function sendTwitter(title,url)
{
 var wp = window.open("http://twitter.com/home?status=" + encodeURIComponent(title) + " " + encodeURIComponent(url), 'twitter', '');
 if ( wp ) {
 wp.focus();
 }
}
/************************************************************************
* 1. 함수명 : sendMe2Day(title,url,tag)
* 2. 용  도 : 미투데이 SNS 서비스와 연동작업을 제어한다.
* 4. 버  전 : ver 1.0.0
* 5. 로  그
*************************************************************************/
function sendMe2Day(title,url,tag)
{
 title = "\""+title+"\":"+url;
 var wp = window.open("http://me2day.net/posts/new?new_post[body]=" + encodeURIComponent(title) + "&new_post[tags]=" + encodeURIComponent(tag), 'me2Day', '');
 if ( wp ) {
 wp.focus();
 }
}
/************************************************************************
* 1. 함수명 : sendFaceBook(title,url)
* 2. 용  도 : 페이스북 SNS 서비스와 연동작업을 제어한다.
* 4. 버  전 : ver 1.0.0
* 5. 로  그
*************************************************************************/
function sendFaceBook(title,url)
{
 var wp = window.open("http://www.facebook.com/sharer.php?u=" + url + "&t=" + encodeURIComponent(title), 'facebook', 'width=600px,height=420px');
 if ( wp ) {
 wp.focus();
 }
}
/************************************************************************
* 1. 함수명 : sendCyWorld(url,title,thumbnail,summary)
* 2. 용  도 : 싸이월드 SNS 서비스와 연동작업을 제어한다.
* 4. 버  전 : ver 1.0.0
* 5. 로  그
*************************************************************************/
function sendCyWorld(url,title,thumbnail,summary)
{
 var wp = window.open("http://csp.cyworld.com/bi/bi_recommend_pop.php?url="+encodeURIComponent(url)+"&title="+encodeURIComponent(title)+"&thumbnail="+encodeURIComponent(thumbnail)+"&summary="+encodeURIComponent(summary),"xu","width=400px,height=364px")
 if ( wp ) {
 wp.focus();
 }
}
/************************************************************************
* 1. 함수명 : sendSms(title,code)
* 2. 용  도 : sms 서비스와 연동작업을 제어한다.
* 4. 버  전 : ver 1.0.0
* 5. 로  그
*************************************************************************/
function sendSms(title,code)
{
 var wp = window.open("/pages/etc/tosms.php?code="+code+"&title="+encodeURIComponent(title),"","width=445px,height=420px")
 if ( wp ) {
 wp.focus();
 }
}
/************************************************************************
* 1. 함수명 : sendMail(title,code)
* 2. 용  도 : 메일 서비스와 연동작업을 제어한다.
* 4. 버  전 : ver 1.0.0
* 5. 로  그
*************************************************************************/
function sendMail(title,code)
{
 var wp = window.open("/pages/etc/tomail.php?code="+code+"&title="+encodeURIComponent(title),"","width=445px,height=420px");
 if ( wp ) {
 wp.focus();
 }
}
/************************************************************************
* 1. 함수명 : goCyWorld(code)
* 2. 용  도 : 싸이월드 서비스와 연동작업을 제어한다.
* 4. 버  전 : ver 1.0.0
* 5. 로  그
*************************************************************************/
function goCyWorld(code)
{
 var href = "http://api.cyworld.com/openscrap/post/v1/?xu=http://dongheejo.net/cyworldApi.php?code=" + code +"&sid=s0300011";
 var a = window.open(href, 'cyworld', 'width=450,height=410');
 if ( a ) {
 a.focus();
 }
}