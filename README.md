# Pudding-JS

JavascriptCore with jQuery for [Samurai-native](https://github.com/hackers-painters/samurai-native). Now you can use jQuery to control Samurai-native's UI & Interaction

## Screen Shots

![Pudding-JS](https://raw.githubusercontent.com/water2891/Pudding-JS/master/ScreenShots/Pudding-JS.gif)

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
