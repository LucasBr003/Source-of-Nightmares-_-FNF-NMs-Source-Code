package;

import openfl.filters.ShaderFilter;

class ShadersHandler
{
	public static var chromaticAberration:ShaderFilter = new ShaderFilter(new ChromaticAberration());
	
	public static function setChrome(chromeOffset:Float):Void
	{
		/*if (Highscore.getPhoto())
		{
			chromeOffset = 0.0;
		}*/

		chromaticAberration.shader.data.rOffset.value = [chromeOffset];
		chromaticAberration.shader.data.gOffset.value = [chromeOffset * 0.5];
		chromaticAberration.shader.data.bOffset.value = [chromeOffset * -1];
	}
}