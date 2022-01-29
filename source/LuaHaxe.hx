package;
#if LUA_ENABLED
import llua.Lua;
import llua.LuaL;
import llua.State;
#end

using StringTools;

class LuaHaxe {
    public var scriptsName:String = ''; 
    public var closeScript:Bool = false;

    public var accessedProps:Map<String, Dynamic> = null;
    public function new(script:String) {

        #if LUA_ENABLED
        var lua:State;

        #if LUA_ENABLED
        lua = LuaL.newstate();
        LuaL.openlibs(lua);
        Lua.init_callbacks(lua);

        var result:Dynamic = LuaL.dofile(lua, script);
		var resultStr:String = Lua.tostring(lua, result);
		if(resultStr != null && result != 0) {
			lime.app.Application.current.window.alert(resultStr, 'Error on .LUA script!');
			trace('Error on .LUA script! ' + resultStr);
			lua = null;
			return;
		}

        scriptName = script;
        trace('Lua file loaded succesfully:' + script);

        //Lua Function/Variables :/
        set('Function_Stop', Function_Stop);
		set('Function_Continue', Function_Continue);
		set('luaDebugMode', false);
		set('luaDeprecatedWarnings', true);
        //Chart Editor shit
        set('inChartEditor', false);

        //Song
        set('score',0);
        set('Song',PlayState.SONG.song);
        set('scrollSpeed', PlayState.SONG.speed);
		//Characters
        set('Boyfriend', PlayState.instance.boyfriend);
        set('Girldfriend', PlayState.instance.gf);
        set('Dad', PlayState.instance.dad);
        //PlayState
        set('curBeat', 0);
		set('curStep', 0);
		for(i in 0...){
			set('playerStrumX$i', 0);
			set('playerStrumX$i', 0);
		}
        set('camGame',PlayState.instance.camGame);
        set('camHud',PlayState.instance.camGame);
        set('misses',0);
        set('shit',0);
        set('bad',0);
        set('good',0);
        set('sick',0);

        Lua_helper.add_callback(lua,"addLuaScript",function(luaFile:String,?ignoreAlreadyRunning:Bool = false) { //would be dope asf. 
			var cervix = luaFile + ".lua";
			var doPush = false;
			if(FileSystem.exists(Paths.modFolders(cervix))) {
				cervix = Paths.modFolders(cervix);
				doPush = true;
			} else {
				cervix = Paths.getPreloadPath(cervix);
				if(FileSystem.exists(cervix)) {
					doPush = true;
				}
			}

			if(doPush)
			{
				if(!ignoreAlreadyRunning)
				{
					for (luaInstance in PlayState.instance.luaArray)
					{
						if(luaInstance.scriptName == cervix)
						{
							luaTrace('The script "' + cervix + '" is already running!');
							return;
						}
					}
				}
				PlayState.instance.luaArray.push(new FunkinLua(cervix)); 
				return;
			}
			luaTrace("Script doesn't exist!");
		});

		Lua_helper.add_callback(lua,"setVariable",function(tag:String,value:String){
		});
        #end
    }

    public function stop() {
		#if LUA_ALLOWED
		if(lua == null)
			return;

		if(accessedProps != null) {
			accessedProps.clear();
		}

		Lua.close(lua);
		lua = null;
		#end
	}
}