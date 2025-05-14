package shaders;

import flixel.system.FlxAssets.FlxShader;
class VCR {
	public var shader(default, null):VCRController = new VCRController();
	public var time(default, set):Float = 0;

	private function set_time(value:Float) {
		time = value;
		shader.iTime.value = [time];
		return time;
	}

	public function new() {
		shader.iTime.value = [0];
	}
}
class VCRController extends FlxShader {
    @:glFragmentSource('
        #pragma header

#define round(a) floor(a + 0.5)
#define iResolution vec3(openfl_TextureSize, 0.)
uniform float iTime;
#define iChannel0 bitmap
uniform sampler2D iChannel1;
uniform sampler2D iChannel2;
uniform sampler2D iChannel3;
#define texture flixel_texture2D


#define PI 3.14159265

vec3 tex2D(sampler2D _tex, vec2 _p) {
	vec3 col = texture(_tex, _p).xyz;
	if (0.5 < abs(_p.x - 0.5)) col = vec3(0.1);
	return col;
}

float hash(vec2 _v) {
	return fract(sin(dot(_v, vec2(89.44, 19.36))) * 22189.22);
}

float iHash(vec2 _v, vec2 _r) {
	float h00 = hash(floor(_v * _r + vec2(0.0)) / _r);
	float h10 = hash(floor(_v * _r + vec2(1.0, 0.0)) / _r);
	float h01 = hash(floor(_v * _r + vec2(0.0, 1.0)) / _r);
	float h11 = hash(floor(_v * _r + vec2(1.0, 1.0)) / _r);
	vec2 ip = smoothstep(vec2(0.0), vec2(1.0), mod(_v * _r, 1.));
	return (h00 * (1. - ip.x) + h10 * ip.x) * (1. - ip.y) + (h01 * (1. - ip.x) + h11 * ip.x) * ip.y;
}

float noise(vec2 _v) {
	float sum = 0.;
	for (int i = 1; i < 9; i++) {
		sum += iHash(_v + vec2(i), vec2(2. * pow(2., float(i)))) / pow(2., float(i));
	}
	return sum;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
	vec2 uv = fragCoord.xy / iResolution.xy;
	vec2 uvn = uv;
	vec3 col = vec3(0.0);

	uvn.x += (noise(vec2(uvn.y, iTime)) - 0.5) * 0.005;
	uvn.x += (noise(vec2(uvn.y * 100.0, iTime * 10.0)) - 0.5) * 0.01;

	float tcPhase = clamp((sin(uvn.y * 8.0 - iTime * PI * 1.2) - 0.92) * noise(vec2(iTime)), 0.0, 0.01) * 10.0;
	float tcNoise = max(noise(vec2(uvn.y * 100.0, iTime * 10.0)) - 0.5, 0.0);
	uvn.x -= tcNoise * tcPhase;

	float snPhase = smoothstep(0.03, 0.0, uvn.y);
	uvn.y += snPhase * 0.3;
	uvn.x += snPhase * ((noise(vec2(uv.y * 100.0, iTime * 10.0)) - 0.5) * 0.2);

	col = tex2D(iChannel0, uvn);
	col *= 1.0 - tcPhase;
	col = mix(col, col.yzx, snPhase);

	for (float x = -4.0; x < 2.5; x += 1.0) {
		col.xyz += vec3(
			tex2D(iChannel0, uvn + vec2(x - 0.0, 0.0) * 7E-3).x,
			tex2D(iChannel0, uvn + vec2(x - 2.0, 0.0) * 7E-3).y,
			tex2D(iChannel0, uvn + vec2(x - 4.0, 0.0) * 7E-3).z
		) * 0.1;
	}
	col *= 0.6;

	col *= 1.0 + clamp(noise(vec2(0.0, uv.y + iTime * 0.2)) * 0.6 - 0.25, 0.0, 0.1);

	fragColor = vec4(col, texture(iChannel0, uv).a);
}

void main() {
	mainImage(gl_FragColor, openfl_TextureCoordv * openfl_TextureSize);
}
    ')

    @:glVertexSource('
        attribute float openfl_Alpha;
        attribute vec4 openfl_ColorMultiplier;
        attribute vec4 openfl_ColorOffset;
        attribute vec4 openfl_Position;
        attribute vec2 openfl_TextureCoord;

        varying float openfl_Alphav;
        varying vec4 openfl_ColorMultiplierv;
        varying vec4 openfl_ColorOffsetv;
        varying vec2 openfl_TextureCoordv;

        uniform mat4 openfl_Matrix;
        uniform bool openfl_HasColorTransform;
        uniform vec2 openfl_TextureSize;

        attribute float alpha;
        attribute vec4 colorMultiplier;
        attribute vec4 colorOffset;
        uniform bool hasColorTransform;

        void main(void) {
            openfl_Alphav = openfl_Alpha;
            openfl_TextureCoordv = openfl_TextureCoord;

            if (openfl_HasColorTransform) {
                openfl_ColorMultiplierv = openfl_ColorMultiplier;
                openfl_ColorOffsetv = openfl_ColorOffset / 255.0;
            }

            gl_Position = openfl_Matrix * openfl_Position;

            openfl_Alphav = openfl_Alpha * alpha;
            if (hasColorTransform) {
                openfl_ColorOffsetv = colorOffset / 255.0;
                openfl_ColorMultiplierv = colorMultiplier;
            }
        }
    ')

    public function new() {
        super();
    }
}
