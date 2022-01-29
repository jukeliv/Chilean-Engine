package ui;

import haxe.Int32;
import openfl.events.Event;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**
	The InfoUiText class provides an easy-to-use monitor to display this info:
	Memory Userage, Memory Userage Peack, Current Application Version and Current FPS
	( All this is Worke from FNF Mic'd Up Mod )
**/
class InfoUiText extends TextField{
	public var currentFPS(default, null):Int;

	@:noCompletion private var cacheCount:Int;
	@:noCompletion private var currentTime:Float;
	@:noCompletion private var times:Array<Float>;
    @:noCompletion private var showFps:Int = 0;

	@:noCompletion private var memPeak:Float = 0;
	@:noCompletion private var byteValue:Int32 = 1024;
	
	public function new(inX:Float = 10.0, inY:Float = 3.0) 
	{
		super();

		#if androidC
		byteValue = 1000;
		#end

		currentFPS = 0;
		selectable = false;
		mouseEnabled = false;
		x = inX;
		y = inY;
		selectable = false;
		defaultTextFormat = new TextFormat(openfl.utils.Assets.getFont(Paths.font("vcr.ttf")).fontName, 12, 0xFFFFFF);
		visible = false;
		cacheCount = 0;
		currentTime = 0;
		times = [];

		addEventListener(Event.ENTER_FRAME, function(e){
			var time = openfl.Lib.getTimer();
			onEnter(time - currentTime);
		});
		width = 150;
		height = 70;
	}

	private function onEnter(deltaTime:Float):Void{
		currentTime += deltaTime;
		times.push(currentTime);

		while (times[0] < currentTime - 1000)
		{
			times.shift();
		}

		var currentCount = times.length;
		currentFPS = Math.round((currentCount + cacheCount) / 2);
        if(currentFPS > showFps){
            showFps = currentFPS;
            this.textColor = 0x17FF00;
        }
        else if(currentFPS < showFps){
            this.textColor = 0xFF0000;
            showFps = currentFPS;
        }
        else
            this.textColor = 0xFFFFFF;

		var mem:Float = Math.round(System.totalMemory / (byteValue * byteValue));
		if (mem > memPeak){
			memPeak = mem;
			this.textColor = 0xFF0000;
		}
		else if(mem < memPeak){
			this.textColor = 0x17FF00;
			memPeak = mem;
		}
		else
			this.textColor = 0xFFFFFF;

		text = visible?(currentCount != cacheCount)?'FPS: ${showFps}\n':'' +'MEM: ${mem}MB\nMEM peak: ${memPeak}MB\nVersion: ${lime.app.Application.current.meta.get('version')}':"";
		
		cacheCount = currentCount;
	}
}