var alert = function(msg,title){
	document.alert(msg || "", title || "");
}

if(document.implementation == undefined){
	document.implementation = {
		createHTMLDocument: function(str){
			return document.createHTMLDocument(str)
		}
	}
}
if(document.getElementById == undefined){
	document.getElementById = function(str){
		return document.querySelectorAll("#" + str)[0];
	}
}

var Pudding = {
	ver		: "0.1.0",
	getCmp	: function(str){
		return document.querySelectorAll(str)
	},
	get		: Native.get,
	print	: Native.output,
	log		: console.log,
}

var welcomeLog = "";
welcomeLog += "  +========================================================================+\n";
welcomeLog += "      pageTitle: " + pageTitle + "\n";
welcomeLog += "      uiConfigPath: " + uiConfigPath + "\n";
welcomeLog += "      PuddingVer: " + Pudding.ver + "\n";
welcomeLog += "  +========================================================================+\n";
console.log(welcomeLog)

function EventManager()
{
    this.dispatchEvent = function(eventType, eventArgs)
    {
        eventArgs = eventArgs || {};
        var events = this["on"+eventType];
        var called = 0;
 
        if(events && typeof(events) == "function")
            events = [events];
 
        if(!eventArgs.type) eventArgs.type = eventType;
        //阻止默认动作的执行
        eventArgs.preventDefault = function()
        {
            eventArgs.defaultOp = null;
        }
        //阻止事件起泡
        eventArgs.stopPropagation = function()
        {
            eventArgs.cancelBubble = true;
        }
        var $pointer = this;
        if(events)
        {
            for(var i = 0; i < events.length; i++)
            {
 
                setTimeout(
                    (function(i){
                        var evt = events[i];
                        var len = events.length;
                        var capturer = events.capturer;
                        var capturerName = events.capturerName;
                        return    function(){
                            called++;
 
                            var ret = evt.call($pointer,eventArgs);
                            //如果有捕获事件的方法，并且没有阻止事件气泡，在最后一个事件处理程序结束之后调用它
                            if(!eventArgs.cancelBubble && called == len && capturer && capturerName && capturer[capturerName])
                            {
                                setTimeout(function(){
                                        capturer[capturerName](eventArgs)
                                    },1)
                            }
                            //如果定义了默认动作，在最后一个事件处理程序结束之后执行它
                            if(called == len && eventArgs.defaultOp) 
                            {
                                eventArgs.defaultOp.call($pointer, eventArgs);
                            }
                            return ret;
                        }
                    })(i), 1
                );
            }
        }
        else if(eventArgs.defaultOp)
        {
            eventArgs.defaultOp.call($pointer, eventArgs);
        }
    }
    this.fireEvent = this.dispatchEvent;
    this.captureEvents = function(target, eventType, capturerName, closure)
    {
        if(capturerName instanceof Function)
        {
            closure = capturerName;
            capturerName = null;
        }
        capturerName = capturerName || "on" + eventType;
        target["on"+eventType] = target["on"+eventType] || [function(){}];
        var events = target["on"+eventType];
        if(typeof(events) == "function")
        {
            target["on"+eventType] = [events];
        }
 
        target["on"+eventType].capturer = this;
        target["on"+eventType].capturerName = capturerName;
 
        if(closure)
            this[capturerName] = closure;
    }
 
    this.addEventListener = function(eventType, closure)
    {
        if(this["on"+eventType] == null)
        {
            this["on"+eventType] = [];
        }
        var events = this["on"+eventType];
        if(events && typeof(events) == "function"){
            this["on"+eventType] = [events];       
            events = this["on"+eventType];
        }
        events.push(closure);
        return closure;
    }
 
    this.removeEventListener = function(eventType, closure)
    {
        var events = this["on"+eventType];
        if(events && typeof(events) == "function")
            events = [events];       
         
        for(var i = 0; i < events.length; i++)
        {
            if(events[i] == closure)
                events.splice(i, 1);
        }
        return closure;
    }
}

EventManager.call(this);