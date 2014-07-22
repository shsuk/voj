// POST방식으로 무료만화페이지 이동 대원제작
function FnFreeComicView(parm) {
	var f = document.createElement('form');
	var objs, value;
	for (var key in parm) {
		value = parm[key];
		objs = document.createElement('input');
		objs.setAttribute('type', 'hidden');
		objs.setAttribute('name', key);
		objs.setAttribute('value', value);
		f.appendChild(objs);
	}
	f.setAttribute('method', 'post');
	f.setAttribute('action', '../../page/dw_freecomic_series/freecomic_view.jsp');
	document.body.appendChild(f);
	f.submit();
}
