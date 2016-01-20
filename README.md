# Pudding-JS

JavascriptCore with jQuery for [Samurai-native](https://github.com/hackers-painters/samurai-native). Now you can use jQuery to control Samurai-native's UI & Interaction

## Screen Shots

![Pudding-JS](https://raw.githubusercontent.com/water2891/Pudding-JS/master/ScreenShots/Pudding-JS.gif)

## HTML

```html
        <UIScrollView onclick="@selector(xx:)" id="scrollview1" class="list" xtype="UIScrollView">
            <div onclick="@selector(zz:)" id="btnList" class="wrapper" xtype="div">
                <button onclick="@selector(doJsCallback:)" jsclick="btn1Click" id="btn1" class="row button1">改变样式</button>
                <button onclick="@selector(doJsCallback:)" jsclick="btn2Click" id="btn2" class="row button2">在最下方新增按钮</button>
                <button onclick="@selector(doJsCallback:)" jsclick="btn6Click" id="btn6" class="row button1">在下方插入新按钮</button>
                <button onclick="@selector(doJsCallback:)" jsclick="btn3Click" id="btn3" class="row button3">删除所有新增按钮</button>
                <button onclick="@selector(doJsCallback:)" jsclick="btn4Click" id="btn4" class="row button4">在最上方新增按钮</button>
                <button onclick="@selector(doJsCallback:)" jsclick="btn5Click" id="btn5" class="row button5">在上方插入新按钮</button>
            </div>
        </UIScrollView>
```

## Javascript

`var resetScrollView = function(){
	var $scrollView1 = $("#scrollview1");
	$scrollView1[0].view.relayout();
}

var btnNo = 4;
var btn2Click = function(){
	var $btnList = $("#btnList");
	$btnList.append('<button class="row newButton button'+(count + 1)+'" onclick="@selector(doJsCallback:)" jsclick="newBtnClick">Button '+(++btnNo)+'</button>');
	count = ++count % 5;

	resetScrollView();
}`


##jQuery 2.x

Pudding-JS use jQuery custom build base on [jQuery 2.x](https://github.com/jquery/jquery/tree/2.2-stable):

```bash
$ grunt custom:-ajax,-ajax/xhr,-ajax/script,-ajax/jsonp,-css,-deprecated,-dimensions,-effects,-event/alias,-event/trigger,-event/focusin,-offset,-wrap,-exports/amd,-sizzle
```

##jQuery Methods Support List

###Dom's methods

| Method      |    Supported | Remark  |
| --------: | :--: | :-------- |
|length| √ | |	
|jquery| √ | |	
|toArray| √ | |	
|get| √ | |	
|pushStack| √ | |	
|each| √ | |	
|map| √ | |	
|slice| √ | |	
|first| √ | |	
|last| √ | |	
|eq| √ | |	
|end| √ | |	
|find| √ | |	
|filter| √ | partial |
|not| √ | |	
|is| √ | |	
|has| √ | partial |
|closest| √ | |	
|index| √ | |	
|add| √ | |	
|addBack| √ | |	
|parent| √ | |	
|parents| √ | partial |
|parentsUntil| √ | |	
|next| √ | |	
|prev| √ | |	
|nextAll| √ | |	
|prevAll| √ | |	
|nextUntil| √ | |	
|prevUntil| √ | |	
|siblings| √ | |	
|children| √ | |	
|contents| √ | |	
|ready| ? | |	
|data| √ | |	
|removeData| √ | |	
|queue| × | |	
|dequeue| × | |	
|clearQueue| × | |	
|promise| ? | |	
|detach| √ | partial |
|remove| √ | partial |
|text| √ | |	
|append| √ | |	
|prepend| √ | |	
|before| √ | |	
|after| √ | |	
|empty| √ | |	
|clone| × | |	
|html| √ | partial |
|replaceWith| ? | |	
|appendTo| ? | |	
|prependTo| ? | |	
|insertBefore| ? | |	
|insertAfter| ? | |	
|replaceAll| ? | |	
|delay| ? | |	
|attr| √ | |	
|removeAttr| √ | |	
|prop| × | |	
|removeProp| × | |	
|addClass| √ | |	
|removeClass| √ | |	
|toggleClass| √ | |	
|hasClass| √ | |	
|val| √ | partial |
|serialize| ? | |	
|serializeArray| ? | |	

###Ajax
| Method      |    Supported | Remark  |
| --------: | :--: | :-------- |
| get | √  | partial |

###Utility
| Method      |    Supported | Remark  |
| --------: | :--: | :-------- |
| jQuery.contains() | √ |  |
| jQuery.each() | √ |  |
| jQuery.extend() | √ |  |
| jQuery.globalEval() |  |  |
| jQuery.grep() |  |  |
| jQuery.inArray() |  |  |
| jQuery.isArray() |  |  |
| jQuery.isEmptyObject() |  |  |
| jQuery.isFunction() |  |  |
| jQuery.isNumeric() |  |  |
| jQuery.isPlainObject() |  |  |
| jQuery.isWindow() |  |  |
| jQuery.isXMLDoc() |  |  |
| jQuery.makeArray() |  |  |
| jQuery.map() |  |  |
| jQuery.merge() |  |  |
| jQuery.noop()  |  |  |
| jQuery.now() |  |  |
| jQuery.parseHTML() |  |  |
| jQuery.parseJSON() |  |  |
| jQuery.parseXML() |  |  |
| jQuery.proxy() |  |  |
| jQuery.support |  |  |
| jQuery.trim() |  |  |
| jQuery.type() |  |  |
| jQuery.unique() |  |  |

## Licensing

Pudding-JS is licensed under the MIT License.
