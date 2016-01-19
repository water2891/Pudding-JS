var count = 1;
var btn1Click = function(){
	//debugger
	var $btn1 = $("#btn1");
	$btn1.removeClass().addClass("row button" + (count + 1));
	//console.log(count);
	count = ++count % 5;

	//resetScrollView();
}

var resetScrollView = function(){
	var $scrollView1 = $("#scrollview1");
	$scrollView1[0].view.relayout();
}

var btnNo = 4;
var btn2Click = function(){
	var $btnList = $("#btnList");
	$btnList.append('<button class="row newButton button'+(count + 1)+'" onclick="@selector(doJsCallback:)" jsclick="newBtnClick">Button '+(++btnNo)+'</button>');
	count = ++count % 5;

	resetScrollView();
}

var btn3Click = function(dom){
	var $newBtns = $('.newButton');

	$newBtns.each(function(i){
		$(this).remove();
	});

	resetScrollView();
}

var btn4Click= function(){
	var $btnList = $("#btnList");
	$btnList.prepend('<button class="row newButton button'+(count + 1)+'" onclick="@selector(doJsCallback:)" jsclick="newBtnClick">Button '+(++btnNo)+'</button>');
	count = ++count % 5;

	resetScrollView();
}

var btn5Click = function(dom){
	$(dom).before('<button class="row newButton button'+(count + 1)+'" onclick="@selector(doJsCallback:)" jsclick="newBtnClick">Button '+(++btnNo)+'</button>');
	count = ++count % 5;

	resetScrollView();
}

var btn6Click = function(dom){
	$(dom).after('<button class="row newButton button'+(count + 1)+'" onclick="@selector(doJsCallback:)" jsclick="newBtnClick">Button '+(++btnNo)+'</button>');
	count = ++count % 5;

	resetScrollView();
}

var newBtnClick = function(dom, attr, section, row){
	alert((attr.text || "我") + "被点击了");
}

var viewDidLoad = function(){
	console.log("js端：viewDidLoad");
}