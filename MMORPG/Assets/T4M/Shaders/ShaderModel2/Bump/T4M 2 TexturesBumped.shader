Shader "T4MShaders/ShaderModel2/Bump/T4M 2 Textures Bumped" {
Properties {
	_Splat0 ("Layer 1", 2D) = "white" {}
	_Splat1 ("Layer 2", 2D) = "white" {}
	_BumpSplat0 ("Layer1Normalmap", 2D) = "bump" {}
	_BumpSplat1 ("Layer2Normalmap", 2D) = "bump" {}
	_Control ("Control (RGBA)", 2D) = "white" {}
	_MainTex ("Never Used", 2D) = "white" {}
}

SubShader {
	Tags {
		"SplatCount" = "2"
		"RenderType" = "Opaque"
	}
CGPROGRAM
#pragma surface surf T4M exclude_path:prepass noforwardadd
#pragma exclude_renderers xbox360 ps3 
inline fixed4 LightingT4M (SurfaceOutput s, fixed3 lightDir, fixed atten)
{
	fixed diff = dot (s.Normal, lightDir);
	fixed4 c;
	c.rgb = s.Albedo * _LightColor0.rgb * (diff * atten * 2);
	c.a = 0.0;
	return c;
}

struct Input {
	float2 uv_Control : TEXCOORD0;
	float2 uv_Splat0: TEXCOORD1;
	float2 uv_Splat1 : TEXCOORD2;
};
sampler2D _Control;
sampler2D _Splat0, _Splat1;
sampler2D _BumpSplat0,_BumpSplat1;

void surf (Input IN, inout SurfaceOutput o) {
	fixed2 splat_control = tex2D (_Control, IN.uv_Control).rg;
		
	fixed3 lay1 = tex2D (_Splat0, IN.uv_Splat0);
	fixed3 lay2 = tex2D (_Splat1, IN.uv_Splat1);
	o.Alpha = 0.0;
	o.Albedo.rgb = (lay1 * splat_control.r + lay2 * splat_control.g);
	
	fixed3 lay1B = UnpackNormal (tex2D(_BumpSplat0, IN.uv_Splat0));
	fixed3 lay2B = UnpackNormal (tex2D(_BumpSplat1, IN.uv_Splat1));
	o.Normal = (lay1B * splat_control.r + lay2B * splat_control.g);
}
ENDCG  
}
// Fallback to Diffuse
Fallback "Diffuse"
}
