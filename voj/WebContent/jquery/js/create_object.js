var Agent = navigator.userAgent;
Agent = Agent.toLowerCase();
 
if (Agent.indexOf("win64") == -1) 
{   
    document.write('<object onError="activex_error()" CODEBASE="drviewscr.cab#Version=1,0,0,68" classid="clsid:A286DF4E-7E4F-4816-A3AD-1FE23462D98C"  width="100%"  height="100%" id="TestX_Control1" ></object>');
}else { 
    document.write('<object onError="activex_error()" CODEBASE="drviewscrX64.cab#Version=1,0,0,68"  classid="clsid:A286DF4E-7E4F-4816-A3AD-1FE23462D964"  width="100%"  height="100%" id="TestX_Control1" ></object>');
}
