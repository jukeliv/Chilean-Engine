package;

import flixel.addons.ui.FlxUI;
import flixel.FlxG;
import flixel.addons.ui.FlxUITabMenu;

class CharacterState extends MusicBeatState {
    var UI_Box:FlxUITabMenu;
    var tabs = [
        {name: "Character Info", label: "Character Info"},
        {name: "Animations", label: "Animations"}
    ];
    override public function create(){
        super.create();

        UI_Box=new FlxUITabMenu(null,tabs,true);

        UI_Box.resize(300, 400);
		UI_Box.x = FlxG.width / 2;
		UI_Box.y = 20;
		add(UI_Box);

        addCharacterInfoUI();
		addAnimationsUI();
    }

    function addCharacterInfoUI():Void
    {
        var tab_group_character_info = new FlxUI(null, UI_Box);
		tab_group_character_info.name = 'Character Info';

        UI_Box.addGroup(tab_group_character_info);
    }
    function addAnimationsUI():Void
    {
        var tab_group_animations = new FlxUI(null, UI_Box);
		tab_group_animations.name = 'Animations';

        UI_Box.addGroup(tab_group_animations);
    }
}