// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tim/MBlend"
{
	Properties
	{
		[HideInInspector] __dirty( "", Int ) = 1
		_AlbedoA("Albedo A", 2D) = "gray" {}
		_ColorA("Color A", Color) = (1,1,1,1)
		_NormalA("Normal A", 2D) = "bump" {}
		_NormalIntensityA("Normal Intensity A", Float) = 1
		_MetallicA("Metallic A", 2D) = "white" {}
		_MetallicIntensityA("Metallic Intensity A", Float) = 0
		_SmoothnessA("Smoothness A", 2D) = "white" {}
		_SmoothnessIntensityA("Smoothness Intensity A", Float) = 0
		_AlbedoB("Albedo B", 2D) = "gray" {}
		_ColorB("Color B", Color) = (1,1,1,1)
		_NormalB("Normal B", 2D) = "bump" {}
		_NormalIntensityB("Normal Intensity B", Float) = 1
		_MetallicB("Metallic B", 2D) = "white" {}
		_MetallicIntensityB("Metallic Intensity B", Float) = 0
		_SmoothnessB("Smoothness B", 2D) = "white" {}
		_SmoothnessIntensityB("Smoothness Intensity B", Float) = 0
		_DisplayVertexPaint("Display Vertex Paint", Int) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float _NormalIntensityA;
		uniform sampler2D _NormalA;
		uniform float4 _NormalA_ST;
		uniform float _NormalIntensityB;
		uniform sampler2D _NormalB;
		uniform float4 _NormalB_ST;
		uniform int _DisplayVertexPaint;
		uniform float4 _ColorA;
		uniform sampler2D _AlbedoA;
		uniform float4 _AlbedoA_ST;
		uniform float4 _ColorB;
		uniform sampler2D _AlbedoB;
		uniform float4 _AlbedoB_ST;
		uniform sampler2D _MetallicA;
		uniform float4 _MetallicA_ST;
		uniform float _MetallicIntensityA;
		uniform sampler2D _MetallicB;
		uniform float4 _MetallicB_ST;
		uniform float _MetallicIntensityB;
		uniform sampler2D _SmoothnessA;
		uniform float4 _SmoothnessA_ST;
		uniform float _SmoothnessIntensityA;
		uniform sampler2D _SmoothnessB;
		uniform float4 _SmoothnessB_ST;
		uniform float _SmoothnessIntensityB;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_NormalA = i.uv_texcoord * _NormalA_ST.xy + _NormalA_ST.zw;
			float2 uv_NormalB = i.uv_texcoord * _NormalB_ST.xy + _NormalB_ST.zw;
			float RedVertexColor = i.vertexColor.r;
			o.Normal = lerp( UnpackScaleNormal( tex2D( _NormalA,uv_NormalA) ,_NormalIntensityA ) , UnpackScaleNormal( tex2D( _NormalB,uv_NormalB) ,_NormalIntensityB ) , RedVertexColor );
			float2 uv_AlbedoA = i.uv_texcoord * _AlbedoA_ST.xy + _AlbedoA_ST.zw;
			float2 uv_AlbedoB = i.uv_texcoord * _AlbedoB_ST.xy + _AlbedoB_ST.zw;
			float4 temp_output_2_0 = lerp( ( _ColorA * tex2D( _AlbedoA,uv_AlbedoA) ) , ( _ColorB * tex2D( _AlbedoB,uv_AlbedoB) ) , RedVertexColor );
			float4 ifLocalVar36 = 0;
			if( (float)_DisplayVertexPaint > 0.0 )
				ifLocalVar36 = i.vertexColor;
			else if( (float)_DisplayVertexPaint == 0.0 )
				ifLocalVar36 = temp_output_2_0;
			else if( (float)_DisplayVertexPaint < 0.0 )
				ifLocalVar36 = temp_output_2_0;
			o.Albedo = ifLocalVar36.rgb;
			float2 uv_MetallicA = i.uv_texcoord * _MetallicA_ST.xy + _MetallicA_ST.zw;
			float2 uv_MetallicB = i.uv_texcoord * _MetallicB_ST.xy + _MetallicB_ST.zw;
			o.Metallic = lerp( ( tex2D( _MetallicA,uv_MetallicA) * _MetallicIntensityA ) , ( tex2D( _MetallicB,uv_MetallicB) * _MetallicIntensityB ) , RedVertexColor ).r;
			float2 uv_SmoothnessA = i.uv_texcoord * _SmoothnessA_ST.xy + _SmoothnessA_ST.zw;
			float2 uv_SmoothnessB = i.uv_texcoord * _SmoothnessB_ST.xy + _SmoothnessB_ST.zw;
			o.Smoothness = lerp( ( tex2D( _SmoothnessA,uv_SmoothnessA) * _SmoothnessIntensityA ) , ( tex2D( _SmoothnessB,uv_SmoothnessB) * _SmoothnessIntensityB ) , RedVertexColor ).r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=7003
0;567;1553;451;102.2232;107.449;1.9;True;False
Node;AmplifyShaderEditor.ColorNode;19;-694.5795,-568.7545;Float;False;Property;_ColorB;Color B;9;0;1,1,1,1;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.VertexColorNode;1;-1848.021,3.401575;Float;False;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;5;-782.0455,-404.9946;Float;True;Property;_AlbedoB;Albedo B;8;0;None;True;0;False;gray;Auto;False;Object;-1;Auto;Texture2D;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;4;-774.6764,-758.0764;Float;True;Property;_AlbedoA;Albedo A;0;0;None;True;0;False;gray;Auto;False;Object;-1;Auto;Texture2D;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.ColorNode;18;-714.2599,-926.5126;Float;False;Property;_ColorA;Color A;1;0;1,1,1,1;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;35;-768.1238,1455.45;Float;False;Property;_SmoothnessIntensityB;Smoothness Intensity B;15;0;0;0;0;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-352.3257,-474.7181;Float;False;0;COLOR;0,0,0,0;False;1;COLOR;0.0;False;COLOR
Node;AmplifyShaderEditor.SamplerNode;13;-791.6348,981.2003;Float;True;Property;_SmoothnessA;Smoothness A;6;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RegisterLocalVarNode;20;-1654.308,29.37177;Float;False;RedVertexColor;-1;True;0;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-339.6239,-837.0325;Float;False;0;COLOR;0.0;False;1;COLOR;0.0,0,0,0;False;COLOR
Node;AmplifyShaderEditor.GetLocalVarNode;22;-349.7364,-653.5914;Float;False;20;FLOAT
Node;AmplifyShaderEditor.SamplerNode;14;-785.4347,1259.801;Float;True;Property;_SmoothnessB;Smoothness B;14;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;32;-734.7239,547.5505;Float;False;Property;_MetallicIntensityA;Metallic Intensity A;5;0;0;0;0;FLOAT
Node;AmplifyShaderEditor.SamplerNode;10;-773.6347,356.4001;Float;True;Property;_MetallicA;Metallic A;4;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;11;-776.0347,621.3996;Float;True;Property;_MetallicB;Metallic B;12;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;33;-732.0239,813.1508;Float;False;Property;_MetallicIntensityB;Metallic Intensity B;13;0;0;0;0;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;34;-768.1238,1181.45;Float;False;Property;_SmoothnessIntensityA;Smoothness Intensity A;7;0;0;0;0;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;26;-1054.624,-20.34912;Float;False;Property;_NormalIntensityA;Normal Intensity A;3;0;1;0;0;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;27;-1050.624,141.6509;Float;False;Property;_NormalIntensityB;Normal Intensity B;11;0;1;0;0;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-195.524,1088.251;Float;False;0;COLOR;0.0;False;1;FLOAT;0.0,0,0,0;False;COLOR
Node;AmplifyShaderEditor.SamplerNode;8;-761.3337,97.70021;Float;True;Property;_NormalB;Normal B;10;0;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.GetLocalVarNode;24;-63.94042,676.9352;Float;False;20;FLOAT
Node;AmplifyShaderEditor.IntNode;37;205.6745,-826.5489;Float;False;Property;_DisplayVertexPaint;Display Vertex Paint;16;0;0;INT
Node;AmplifyShaderEditor.LerpOp;2;-120.8562,-693.4713;Float;False;0;COLOR;0.0;False;1;COLOR;0.0,0,0,0;False;2;FLOAT;0.0;False;COLOR
Node;AmplifyShaderEditor.SamplerNode;7;-768.0335,-94.49986;Float;True;Property;_NormalA;Normal A;2;0;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-307.624,432.7507;Float;False;0;COLOR;0.0;False;1;FLOAT;0.0,0,0,0;False;COLOR
Node;AmplifyShaderEditor.GetLocalVarNode;23;-396.4907,122.0439;Float;False;20;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-204.924,1268.051;Float;False;0;COLOR;0.0;False;1;FLOAT;0,0,0,0;False;COLOR
Node;AmplifyShaderEditor.VertexColorNode;38;234.4749,-726.7493;Float;False;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-306.224,681.3507;Float;False;0;COLOR;0.0;False;1;FLOAT;0.0;False;COLOR
Node;AmplifyShaderEditor.GetLocalVarNode;25;-12.06894,1332.95;Float;False;20;FLOAT
Node;AmplifyShaderEditor.LerpOp;12;245.3916,1125.7;Float;False;0;COLOR;0.0;False;1;COLOR;0.0,0,0,0;False;2;FLOAT;0.0;False;COLOR
Node;AmplifyShaderEditor.LerpOp;6;-73.70824,8.100114;Float;False;0;FLOAT3;0.0;False;1;FLOAT3;0.0,0,0,0;False;2;FLOAT;0.0;False;FLOAT3
Node;AmplifyShaderEditor.LerpOp;9;206.0916,531.9997;Float;False;0;COLOR;0.0;False;1;COLOR;0.0,0,0,0;False;2;FLOAT;0.0;False;COLOR
Node;AmplifyShaderEditor.ConditionalIfNode;36;506.9739,-774.0494;Float;False;False;0;INT;0.0;False;1;FLOAT;0.0;False;2;COLOR;0.0;False;3;COLOR;0.0;False;4;COLOR;0.0;False;COLOR
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;966.6265,-3.299957;Float;False;True;6;Float;ASEMaterialInspector;0;Standard;Tim/MBlend;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;False;0;4;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;False;Cylindrical;Relative;0;;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;OBJECT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;13;OBJECT;0.0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False
WireConnection;16;0;19;0
WireConnection;16;1;5;0
WireConnection;20;0;1;1
WireConnection;15;0;18;0
WireConnection;15;1;4;0
WireConnection;30;0;13;0
WireConnection;30;1;34;0
WireConnection;8;5;27;0
WireConnection;2;0;15;0
WireConnection;2;1;16;0
WireConnection;2;2;22;0
WireConnection;7;5;26;0
WireConnection;28;0;10;0
WireConnection;28;1;32;0
WireConnection;31;0;14;0
WireConnection;31;1;35;0
WireConnection;29;0;11;0
WireConnection;29;1;33;0
WireConnection;12;0;30;0
WireConnection;12;1;31;0
WireConnection;12;2;25;0
WireConnection;6;0;7;0
WireConnection;6;1;8;0
WireConnection;6;2;23;0
WireConnection;9;0;28;0
WireConnection;9;1;29;0
WireConnection;9;2;24;0
WireConnection;36;0;37;0
WireConnection;36;2;38;0
WireConnection;36;3;2;0
WireConnection;36;4;2;0
WireConnection;0;0;36;0
WireConnection;0;1;6;0
WireConnection;0;3;9;0
WireConnection;0;4;12;0
ASEEND*/
//CHKSM=F2E2564503EDC99A42E878292582FC78E06159E7