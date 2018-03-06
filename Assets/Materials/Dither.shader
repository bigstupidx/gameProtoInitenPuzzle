// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tim/Dither2"
{
	Properties
	{
		[HideInInspector] __dirty( "", Int ) = 1
		_MaskClipValue( "Mask Clip Value", Float ) = 0.5
		_Speed("Speed", Float) = 0
		_TilingTP("TilingTP", Float) = 0
		_BlendFalloff("Blend Falloff", Float) = 1
		_GradientMax("GradientMax", Float) = 1
		_DissolveIntens("DissolveIntens", Float) = 0
		_ColorContrast("ColorContrast", Float) = 0
		_ColorOffset("ColorOffset", Float) = 0
		_DissolveTexture("DissolveTexture", 2D) = "white" {}
		_GradientOffset("GradientOffset", Float) = 0
		_Texture0("Texture 0", 2D) = "white" {}
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Transparent+0" }
		Cull Off
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 5.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) fixed3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
		};

		uniform sampler2D _Texture0;
		uniform float _ColorOffset;
		uniform float _GradientOffset;
		uniform float _GradientMax;
		uniform float _DissolveIntens;
		uniform float _BlendFalloff;
		uniform sampler2D _DissolveTexture;
		uniform float _Speed;
		uniform float _TilingTP;
		uniform float _ColorContrast;
		uniform float _MaskClipValue = 0.5;

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 vertexPos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 temp_cast_0 = (( 1.0 - _DissolveIntens )).xxxx;
			float3 temp_cast_1 = (_BlendFalloff).xxx;
			float3 temp_output_171_0 = pow( abs( i.worldNormal ) , temp_cast_1 );
			float3 temp_cast_2 = (_BlendFalloff).xxx;
			float3 temp_cast_3 = (_BlendFalloff).xxx;
			float3 temp_cast_4 = (_BlendFalloff).xxx;
			float3 temp_output_177_0 = ( ( temp_output_171_0 / ( ( temp_output_171_0.x + temp_output_171_0.y ) + temp_output_171_0.z ) ) * sign( i.worldNormal ) );
			float4 _Color0 = float4(0,0,0,0);
			float mulTime119 = _Time.y * _Speed;
			float4 appendResult57 = float4( vertexPos.y , vertexPos.z , 0 , 0 );
			float4 temp_output_110_0 = ( appendResult57 * _TilingTP );
			float4 appendResult58 = float4( vertexPos.x , vertexPos.z , 0 , 0 );
			float4 temp_output_111_0 = ( appendResult58 * _TilingTP );
			float4 appendResult59 = float4( vertexPos.x , vertexPos.y , 0 , 0 );
			float4 temp_output_112_0 = ( appendResult59 * _TilingTP );
			float3 layeredBlendVar200 = clamp( temp_output_177_0 , float3( 0,0,0 ) , float3( 1,1,1 ) );
			float3 temp_cast_11 = (_BlendFalloff).xxx;
			float3 temp_cast_12 = (_BlendFalloff).xxx;
			float3 temp_cast_13 = (_BlendFalloff).xxx;
			float3 temp_cast_14 = (_BlendFalloff).xxx;
			float3 layeredBlendVar202 = clamp( ( temp_output_177_0 * float3( -1,-1,-1 ) ) , float3( 0,0,0 ) , float3( 1,1,1 ) );
			float4 TriplanarTexture = clamp( ( ( lerp( lerp( lerp( _Color0 , tex2D( _DissolveTexture,(abs( temp_output_110_0.xy+mulTime119 * float2(-1,-5 )))) , layeredBlendVar200.x ) , tex2D( _DissolveTexture,(abs( temp_output_111_0.xy+mulTime119 * float2(0,0 )))) , layeredBlendVar200.y ) , tex2D( _DissolveTexture,(abs( temp_output_112_0.xy+mulTime119 * float2(5,-1 )))) , layeredBlendVar200.z ) ) + ( lerp( lerp( lerp( _Color0 , tex2D( _DissolveTexture,(abs( temp_output_110_0.xy+mulTime119 * float2(-1,5 )))) , layeredBlendVar202.x ) , tex2D( _DissolveTexture,(abs( temp_output_111_0.xy+mulTime119 * float2(0,0 )))) , layeredBlendVar202.y ) , tex2D( _DissolveTexture,(abs( temp_output_112_0.xy+mulTime119 * float2(-5,-1 )))) , layeredBlendVar202.z ) ) ) , float4( 0,0,0,0 ) , float4( 1,1,1,1 ) );
			float4 temp_output_248_0 = ( ( ( vertexPos.y + _GradientOffset ) * ( 1.0 / _GradientMax ) ) * clamp( ( temp_cast_0 + TriplanarTexture ) , float4( 0,0,0,0 ) , float4( 1,1,1,1 ) ) );
			float componentMask226 = pow( ( _ColorOffset * temp_output_248_0 ) , _ColorContrast );
			float2 appendResult225 = float2( componentMask226 , 0 );
			o.Albedo = tex2D( _Texture0,appendResult225).xyz;
			o.Alpha = 1;
			float4 temp_cast_22 = (( 1.0 - _DissolveIntens )).xxxx;
			float componentMask211 = ( 1.0 - temp_output_248_0 ).r;
			clip( componentMask211 - _MaskClipValue );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Lambert keepalpha 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			# include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float3 worldPos : TEXCOORD6;
				float4 tSpace0 : TEXCOORD1;
				float4 tSpace1 : TEXCOORD2;
				float4 tSpace2 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			fixed4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				float3 worldPos = IN.worldPos;
				fixed3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=7003
0;554;1553;464;2315.585;1223.374;1.9;True;False
Node;AmplifyShaderEditor.CommentaryNode;239;-6931.837,-1214.725;Float;False;3110.005;2072.006;Comment;42;66;170;172;171;174;175;176;179;59;57;113;178;120;58;173;110;177;112;119;111;71;72;78;134;63;76;75;73;62;60;81;61;201;83;182;186;82;202;200;93;208;265;
Node;AmplifyShaderEditor.WorldNormalVector;66;-6334.943,-1069.995;Float;True;0;FLOAT3;0,0,0;False;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;172;-5951.119,-1164.725;Float;False;Property;_BlendFalloff;Blend Falloff;5;0;1;0;0;FLOAT
Node;AmplifyShaderEditor.AbsOpNode;170;-5940.419,-1075.725;Float;False;0;FLOAT3;0.0;False;FLOAT3
Node;AmplifyShaderEditor.PowerNode;171;-5754.121,-1092.725;Float;False;0;FLOAT3;0.0;False;1;FLOAT;0.0;False;FLOAT3
Node;AmplifyShaderEditor.BreakToComponentsNode;174;-5606.121,-1016.726;Float;False;FLOAT3;0;FLOAT3;0.0;False;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;175;-5357.121,-1014.726;Float;False;0;FLOAT;0.0;False;1;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.PosVertexDataNode;265;-6866.686,-222.1729;Float;False;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.WireNode;179;-6021.521,-879.5246;Float;False;0;FLOAT3;0.0;False;FLOAT3
Node;AmplifyShaderEditor.SimpleAddOpNode;176;-5219.122,-984.7253;Float;False;0;FLOAT;0.0;False;1;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.AppendNode;59;-6544.713,-22.92454;Float;False;FLOAT4;0;0;0;0;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;FLOAT4
Node;AmplifyShaderEditor.RangedFloatNode;113;-6547.571,-495.4982;Float;False;Property;_TilingTP;TilingTP;4;0;0;0;0;FLOAT
Node;AmplifyShaderEditor.SignOpNode;178;-5122.402,-866.1999;Float;False;0;FLOAT3;0,0,0;False;FLOAT3
Node;AmplifyShaderEditor.RangedFloatNode;120;-6403.554,-659.8433;Float;False;Property;_Speed;Speed;4;0;0;0;0;FLOAT
Node;AmplifyShaderEditor.SimpleDivideOpNode;173;-5069.522,-1092.125;Float;False;0;FLOAT3;0.0;False;1;FLOAT;0,0,0;False;FLOAT3
Node;AmplifyShaderEditor.AppendNode;57;-6538.114,-384.5243;Float;False;FLOAT4;0;0;0;0;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;FLOAT4
Node;AmplifyShaderEditor.AppendNode;58;-6543.615,-205.5244;Float;False;FLOAT4;0;0;0;0;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;FLOAT4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;177;-4940.523,-978.4247;Float;False;0;FLOAT3;0.0,0,0;False;1;FLOAT3;0.0;False;FLOAT3
Node;AmplifyShaderEditor.SimpleTimeNode;119;-6176.555,-672.6435;Float;False;0;FLOAT;1.0;False;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;111;-6253,-238.3477;Float;False;0;FLOAT4;0.0;False;1;FLOAT;0.0,0,0,0;False;FLOAT4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;110;-6264.199,-417.5476;Float;False;0;FLOAT4;0.0;False;1;FLOAT;0.0,0,0,0;False;FLOAT4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;112;-6257.001,-17.94784;Float;False;0;FLOAT4;0.0;False;1;FLOAT;0,0,0,0;False;FLOAT4
Node;AmplifyShaderEditor.PannerNode;76;-5753.87,340.3812;Float;False;-1;5;0;FLOAT2;0,0;False;1;FLOAT;0.0;False;FLOAT2
Node;AmplifyShaderEditor.PannerNode;73;-5775.615,-294.3247;Float;False;5;-1;0;FLOAT2;0,0;False;1;FLOAT;0.0;False;FLOAT2
Node;AmplifyShaderEditor.PannerNode;75;-5758.888,651.9406;Float;False;-5;-1;0;FLOAT2;0,0;False;1;FLOAT;0.0;False;FLOAT2
Node;AmplifyShaderEditor.PannerNode;71;-5748.315,-706.8247;Float;False;-1;-5;0;FLOAT2;0,0;False;1;FLOAT;0.0;False;FLOAT2
Node;AmplifyShaderEditor.TexturePropertyNode;63;-5797.916,-140.1245;Float;True;Property;_DissolveTexture;DissolveTexture;10;0;None;False;white;Auto;SAMPLER2D
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;134;-4958.332,30.79743;Float;False;0;FLOAT3;0.0;False;1;FLOAT3;-1,-1,-1;False;FLOAT3
Node;AmplifyShaderEditor.PannerNode;78;-5763.874,495.5811;Float;False;0;0;0;FLOAT2;0,0;False;1;FLOAT;0.0;False;FLOAT2
Node;AmplifyShaderEditor.PannerNode;72;-5757.721,-519.5243;Float;False;0;0;0;FLOAT2;0,0;False;1;FLOAT;0.0;False;FLOAT2
Node;AmplifyShaderEditor.SamplerNode;60;-5292.149,-748.073;Float;True;Property;_TextureSample1;Texture Sample 1;7;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;83;-5260.475,627.2815;Float;True;Property;_TextureSample6;Texture Sample 6;7;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.ColorNode;201;-4848.63,-353.3245;Float;False;Constant;_Color0;Color 0;7;0;0,0,0,0;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;82;-5262.706,234.7328;Float;True;Property;_TextureSample5;Texture Sample 5;7;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;62;-5289.917,-355.5241;Float;True;Property;_TextureSample3;Texture Sample 3;7;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.ClampOpNode;182;-4767.821,-980.624;Float;False;0;FLOAT3;0.0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;1,1,1;False;FLOAT3
Node;AmplifyShaderEditor.SamplerNode;61;-5293.717,-551.2243;Float;True;Property;_TextureSample2;Texture Sample 2;7;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;81;-5264.275,431.5817;Float;True;Property;_TextureSample4;Texture Sample 4;7;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.ClampOpNode;186;-4778.788,-88.42396;Float;False;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;1,1,1;False;FLOAT3
Node;AmplifyShaderEditor.LayeredBlendNode;200;-4463.133,-666.624;Float;False;0;FLOAT3;0.0;False;1;COLOR;0.0;False;2;FLOAT4;0.0;False;3;FLOAT4;0.0;False;4;FLOAT4;0.0;False;5;FLOAT;0.0;False;COLOR
Node;AmplifyShaderEditor.LayeredBlendNode;202;-4451.832,-67.12548;Float;False;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;5;FLOAT;0.0;False;COLOR
Node;AmplifyShaderEditor.SimpleAddOpNode;93;-4187.311,-385.425;Float;False;0;COLOR;0.0,0,0,0;False;1;COLOR;0,0,0,0;False;COLOR
Node;AmplifyShaderEditor.RangedFloatNode;251;-2982.488,-745.1719;Float;False;Property;_DissolveIntens;DissolveIntens;9;0;0;0;0;FLOAT
Node;AmplifyShaderEditor.ClampOpNode;208;-4045.43,-391.4254;Float;False;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;COLOR
Node;AmplifyShaderEditor.RegisterLocalVarNode;240;-3778.976,-394.4716;Float;False;TriplanarTexture;-1;True;0;COLOR;0.0;False;COLOR
Node;AmplifyShaderEditor.OneMinusNode;252;-2745.385,-697.0722;Float;False;0;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.PosVertexDataNode;196;-2866.129,-1315.422;Float;False;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;207;-2878.234,-998.5259;Float;False;Property;_GradientMax;GradientMax;6;0;1;0;0;FLOAT
Node;AmplifyShaderEditor.GetLocalVarNode;241;-2987.877,-601.8723;Float;False;240;COLOR
Node;AmplifyShaderEditor.RangedFloatNode;238;-2886.58,-1128.769;Float;False;Property;_GradientOffset;GradientOffset;10;0;0;0;0;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;237;-2647.58,-1251.172;Float;False;0;FLOAT;0.0;False;1;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;249;-2532.688,-697.9727;Float;False;0;FLOAT;0,0,0,0;False;1;COLOR;0.0;False;COLOR
Node;AmplifyShaderEditor.SimpleDivideOpNode;246;-2630.979,-1050.873;Float;False;0;FLOAT;1.0;False;1;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.ClampOpNode;250;-2363.686,-778.6718;Float;False;0;COLOR;0.0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;COLOR
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;243;-2407.68,-1133.573;Float;False;0;FLOAT;0.0;False;1;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;248;-2119.078,-915.4728;Float;False;0;FLOAT;0.0;False;1;COLOR;0.0;False;COLOR
Node;AmplifyShaderEditor.RangedFloatNode;293;-1927.684,-1101.574;Float;False;Property;_ColorOffset;ColorOffset;10;0;0;0;0;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;275;-1756.486,-1184.975;Float;False;Property;_ColorContrast;ColorContrast;10;0;0;0;0;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;273;-1688.486,-1043.975;Float;False;0;FLOAT;0.0,0,0,0;False;1;COLOR;0.0;False;COLOR
Node;AmplifyShaderEditor.PowerNode;274;-1536.486,-1137.975;Float;False;0;FLOAT;0.0;False;1;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.ComponentMaskNode;226;-1416.581,-1004.97;Float;False;True;False;False;False;0;FLOAT;0,0,0,0;False;FLOAT
Node;AmplifyShaderEditor.TexturePropertyNode;261;-1334.591,-1334.173;Float;True;Property;_Texture0;Texture 0;12;0;None;False;white;Auto;SAMPLER2D
Node;AmplifyShaderEditor.AppendNode;225;-1197.88,-1014.271;Float;False;FLOAT2;0;0;0;0;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;FLOAT2
Node;AmplifyShaderEditor.OneMinusNode;264;-1031.092,-713.8738;Float;False;0;COLOR;0.0;False;COLOR
Node;AmplifyShaderEditor.SamplerNode;224;-962.0782,-1240.469;Float;True;Property;_TextureSample0;Texture Sample 0;7;0;Assets/Tools/AmplifyShaderEditor/Examples/Community/Dissolve Burn/burn-ramp.png;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.ComponentMaskNode;211;-819.5323,-699.7255;Float;True;True;False;False;False;0;COLOR;0,0,0,0;False;FLOAT
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;47.59978,-1139.1;Float;False;True;7;Float;ASEMaterialInspector;0;Lambert;Tim/Dither2;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;0;False;0;0;Custom;0.5;True;True;0;False;TransparentCutout;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;False;0;4;10;30;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;False;Cylindrical;Relative;0;;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;OBJECT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;13;OBJECT;0.0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False
WireConnection;170;0;66;0
WireConnection;171;0;170;0
WireConnection;171;1;172;0
WireConnection;174;0;171;0
WireConnection;175;0;174;0
WireConnection;175;1;174;1
WireConnection;179;0;66;0
WireConnection;176;0;175;0
WireConnection;176;1;174;2
WireConnection;59;0;265;1
WireConnection;59;1;265;2
WireConnection;178;0;179;0
WireConnection;173;0;171;0
WireConnection;173;1;176;0
WireConnection;57;0;265;2
WireConnection;57;1;265;3
WireConnection;58;0;265;1
WireConnection;58;1;265;3
WireConnection;177;0;173;0
WireConnection;177;1;178;0
WireConnection;119;0;120;0
WireConnection;111;0;58;0
WireConnection;111;1;113;0
WireConnection;110;0;57;0
WireConnection;110;1;113;0
WireConnection;112;0;59;0
WireConnection;112;1;113;0
WireConnection;76;0;110;0
WireConnection;76;1;119;0
WireConnection;73;0;112;0
WireConnection;73;1;119;0
WireConnection;75;0;112;0
WireConnection;75;1;119;0
WireConnection;71;0;110;0
WireConnection;71;1;119;0
WireConnection;134;0;177;0
WireConnection;78;0;111;0
WireConnection;78;1;119;0
WireConnection;72;0;111;0
WireConnection;72;1;119;0
WireConnection;60;0;63;0
WireConnection;60;1;71;0
WireConnection;83;0;63;0
WireConnection;83;1;75;0
WireConnection;82;0;63;0
WireConnection;82;1;76;0
WireConnection;62;0;63;0
WireConnection;62;1;73;0
WireConnection;182;0;177;0
WireConnection;61;0;63;0
WireConnection;61;1;72;0
WireConnection;81;0;63;0
WireConnection;81;1;78;0
WireConnection;186;0;134;0
WireConnection;200;0;182;0
WireConnection;200;1;201;0
WireConnection;200;2;60;0
WireConnection;200;3;61;0
WireConnection;200;4;62;0
WireConnection;202;0;186;0
WireConnection;202;1;201;0
WireConnection;202;2;82;0
WireConnection;202;3;81;0
WireConnection;202;4;83;0
WireConnection;93;0;200;0
WireConnection;93;1;202;0
WireConnection;208;0;93;0
WireConnection;240;0;208;0
WireConnection;252;0;251;0
WireConnection;237;0;196;2
WireConnection;237;1;238;0
WireConnection;249;0;252;0
WireConnection;249;1;241;0
WireConnection;246;1;207;0
WireConnection;250;0;249;0
WireConnection;243;0;237;0
WireConnection;243;1;246;0
WireConnection;248;0;243;0
WireConnection;248;1;250;0
WireConnection;273;0;293;0
WireConnection;273;1;248;0
WireConnection;274;0;273;0
WireConnection;274;1;275;0
WireConnection;226;0;274;0
WireConnection;225;0;226;0
WireConnection;264;0;248;0
WireConnection;224;0;261;0
WireConnection;224;1;225;0
WireConnection;211;0;264;0
WireConnection;0;0;224;0
WireConnection;0;10;211;0
ASEEND*/
//CHKSM=CD0562F6012CFE2D99F0CD290C9E72D7BE8E2AE3