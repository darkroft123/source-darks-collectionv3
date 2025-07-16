package game;

typedef FreeplaySong =  {
	var name:String;
	var icon:String;
	var difficulties:Array<String>;
	var color:String;
	var week:Int;

	@:optional
	var metadata:FreeplayMetadata;

	@:optional
	var menuConfig:FreeplayMenuConfig;

	@:optional
	var extraData:Dynamic;
}

typedef FreeplayMetadata = {
	@:optional
	var composer:String;
	@:optional
	var charter:String;
	@:optional
	var modcharter:String;
}

typedef FreeplayMenuConfig = {
	@:optional
	var canBeEntered:Bool;

	@:optional
	var showStats:Bool;
}