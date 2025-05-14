package hscript;

@:dox(hide)
class Config {
	// Runs support for custom classes in these
	public static final ALLOWED_CUSTOM_CLASSES = [
		#if !dox
		"flixel",
        "game",
		"modding",
		"states",
		//"shaders",
		"substates",
		"ui"
		#end
	];

	// Runs support for abstract support in these
	public static final ALLOWED_ABSTRACT_AND_ENUM = [
		#if !dox
		"flixel",
		"openfl.display.BlendMode",
		#end
	];

	// Incase any of your files fail
	// These are the module names
	public static final DISALLOW_CUSTOM_CLASSES = [
        "flixel.graphics.frames.FlxFrame"
	];

	public static final DISALLOW_ABSTRACT_AND_ENUM = [
	];
}