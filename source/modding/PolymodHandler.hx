package modding;

#if MODDING_ALLOWED
import polymod.Polymod;

class PolymodHandler {
    public static var metadataArrays:Array<String> = [];

    public static function loadMods() {
        loadModMetadata();

		Polymod.init({
			modRoot:"mods/",
			dirs: ModList.getActiveMods(metadataArrays),
            framework: OPENFL,
			errorCallback: function(error:PolymodError)
			{
				switch(error.severity){
                    case ERROR:
                        trace(error.message, PrintType.ERROR);
                    case WARNING:
                        trace(error.message, PrintType.WARNING);
                    default:
                        trace(error.message);
                }
			},
            frameworkParams: {
                assetLibraryPaths: [
                    "songs" => "songs",
                    "stages" => "stages",
                    "shared" => "shared",
                    "fonts" => "fonts"
                ]
            }
		});
    }

    public static function loadModMetadata() {
        metadataArrays = [];

        var tempArray:Array<ModMetadata> = Polymod.scan({
            modRoot: "mods/",
            apiVersionRule: "*.*.*",
            errorCallback: function(error:PolymodError) {
                #if debug
                trace(error.message, LOG);
                #end
            },
        });

        for(metadata in tempArray) {
            metadataArrays.push(metadata.id);
            ModList.modMetadatas.set(metadata.id, metadata);
        }
    }
}
#end