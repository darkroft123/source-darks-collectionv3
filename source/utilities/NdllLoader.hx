package utilities;

import polymod.backends.PolymodAssets;
import lime.system.CFFI;

class NdllLoader {
	/**
	 * Load a function from a NDLL and return it.
	 * @param ndll 
	 * @param func 
	 * @param args 
	 * @param lazy 
	 * @return Dynamic
	 */
	public static function load(ndll:String, func:String, args:Int, lazy:Bool = false):Dynamic {
		return CFFI.load(PolymodAssets.getPath('assets/ndlls/$ndll.ndll'), func, args, lazy);
	}
    
    /**
     * Call a function from `load()`
     * TODO: Find a way to do this better.
     * @param func 
     * @param args 
     * @return Dynamic
     */
    public static function call(func:Dynamic, args:Array<Dynamic>):Dynamic{
        switch(args.length){
            case 0: 
                return func();
            case 1:
                return func(args[0]);
            case 2:
                return func(args[0], args[1]);
            case 3:
                return func(args[0], args[1], args[2]);
            case 4:
                return func(args[0], args[1], args[2], args[3]);
            case 5:
                return func(args[0], args[1], args[2], args[3], args[4]);
            case 6:
                return func(args[0], args[1], args[2], args[3], args[4], args[5]);
            case 7:
                return func(args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
            case 8:
                return func(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]);
            default:
                throw "Too many arguments";
        }
    }
}