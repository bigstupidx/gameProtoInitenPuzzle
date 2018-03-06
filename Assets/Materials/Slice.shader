// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tim/Slice"
{
	Properties
	{
		_MaskClipValue( "Mask Clip Value", Float ) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull Off
		CGINCLUDE
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
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
			fixed ASEVFace : VFACE;
			float3 worldPos;
			float3 worldNormal;
		};

		uniform float _MaskClipValue = 0;

		inline fixed4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return fixed4 ( s.Emission, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 switchResult92 = (((i.ASEVFace>0)?(half4(1,0.2156863,0.2156863,0)):(float4(0.473483,1,0.2156863,0))));
			o.Emission = ( switchResult92 * (0.5 + (dot( normalize( UnityWorldSpaceLightDir( i.worldPos ) ) , normalize( i.worldNormal ) ) - 0.0) * (1.0 - 0.5) / (1.0 - 0.0)) ).rgb;
			o.Alpha = 1;
			float3 vertexPos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float mulTime105 = _Time.y * 0.05;
			float cos104 = cos( mulTime105 );
			float sin104 = sin( mulTime105 );
			float2 rotator104 = mul(vertexPos.y - float2( 0.5,0.5 ), float2x2(cos104,-sin104,sin104,cos104)) + float2( 0.5,0.5 );
			float mulTime14 = _Time.y * -0.05;
			float2 temp_cast_1 = (mulTime14).xx;
			float2 temp_cast_2 = (0.8).xx;
			float mulTime101 = _Time.y * -0.05;
			float cos102 = cos( mulTime101 );
			float sin102 = sin( mulTime101 );
			float2 rotator102 = mul(vertexPos.x - float2( 0.5,0.5 ), float2x2(cos102,-sin102,sin102,cos102)) + float2( 0.5,0.5 );
			float mulTime23 = _Time.y * 0.0;
			float2 temp_cast_3 = (mulTime23).xx;
			float2 temp_cast_4 = (0.0).xx;
			float mulTime100 = _Time.y * 0.05;
			float cos98 = cos( mulTime100 );
			float sin98 = sin( mulTime100 );
			float2 rotator98 = mul(vertexPos.z - float2( 0.5,0.5 ), float2x2(cos98,-sin98,sin98,cos98)) + float2( 0.5,0.5 );
			float mulTime32 = _Time.y * 0.0;
			float2 temp_cast_5 = (mulTime32).xx;
			float2 temp_cast_6 = (0.8).xx;
			clip( ( ( ( frac( ( ( rotator104 + temp_cast_1 ) * 5.0 ) ) - temp_cast_2 ) * ( frac( ( ( rotator102 + temp_cast_3 ) * 1.0 ) ) - temp_cast_4 ) ) * ( frac( ( ( rotator98 + temp_cast_5 ) * 1.0 ) ) - temp_cast_6 ) ) - ( _MaskClipValue ).xx );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit keepalpha 

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
0;668;1641;350;410.0999;327.7026;2.5;True;False
Node;AmplifyShaderEditor.PosVertexDataNode;114;-453.0991,406.3972;Float;False;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.PosVertexDataNode;115;-492.9987,-33.70277;Float;False;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleTimeNode;105;-253.9974,148.6469;Float;False;0;FLOAT;0.05;False;FLOAT
Node;AmplifyShaderEditor.SimpleTimeNode;101;-188.5995,583.2795;Float;False;0;FLOAT;-0.05;False;FLOAT
Node;AmplifyShaderEditor.RotatorNode;102;20.49999,445.5793;Float;False;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;0.1;False;FLOAT2
Node;AmplifyShaderEditor.PosVertexDataNode;116;-464.1982,895.4974;Float;False;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RotatorNode;104;-48.99781,10.94685;Float;False;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;0.1;False;FLOAT2
Node;AmplifyShaderEditor.SimpleTimeNode;100;-63.99947,1074.829;Float;False;0;FLOAT;0.05;False;FLOAT
Node;AmplifyShaderEditor.SimpleTimeNode;23;-53.77667,293.5866;Float;False;0;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.SimpleTimeNode;14;-128.7012,-123.5258;Float;False;0;FLOAT;-0.05;False;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;18;294.6239,298.9866;Float;True;0;FLOAT2;0.0;False;1;FLOAT;0.0;False;FLOAT2
Node;AmplifyShaderEditor.SimpleAddOpNode;13;232.1991,-123.1257;Float;True;0;FLOAT2;0.0;False;1;FLOAT;0.0;False;FLOAT2
Node;AmplifyShaderEditor.RangedFloatNode;17;356.123,613.4864;Float;False;Constant;_Float1;Float 1;-1;0;1;0;0;FLOAT
Node;AmplifyShaderEditor.SimpleTimeNode;32;15.79584,809.4599;Float;False;0;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.RotatorNode;98;138.2,937.1289;Float;False;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;0.1;False;FLOAT2
Node;AmplifyShaderEditor.RangedFloatNode;8;276.0981,178.5745;Float;False;Constant;_Float1;Float 1;-1;0;5;0;0;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;27;416.2977,1149.174;Float;False;Constant;_Float4;Float 4;-1;0;1;0;0;FLOAT
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;106;1441.402,-258.5028;Float;False;0;FLOAT;0.0;False;FLOAT3
Node;AmplifyShaderEditor.WorldNormalVector;107;1476.902,-163.7028;Float;False;0;FLOAT3;0,0,0;False;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;517.5981,-61.02577;Float;True;0;FLOAT2;0.0;False;1;FLOAT;0.5,0;False;FLOAT2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;570.5228,372.4864;Float;True;0;FLOAT2;0.0;False;1;FLOAT;0.5,0;False;FLOAT2
Node;AmplifyShaderEditor.SimpleAddOpNode;26;352.2977,845.1745;Float;True;0;FLOAT2;0.0;False;1;FLOAT;0.0;False;FLOAT2
Node;AmplifyShaderEditor.FractNode;6;827.3976,-47.92558;Float;True;0;FLOAT2;0.0;False;FLOAT2
Node;AmplifyShaderEditor.NormalizeNode;111;1723.202,-126.3023;Float;False;0;FLOAT3;0,0,0,0;False;FLOAT3
Node;AmplifyShaderEditor.NormalizeNode;110;1753.202,-241.5023;Float;False;0;FLOAT3;0,0,0,0;False;FLOAT3
Node;AmplifyShaderEditor.RangedFloatNode;21;885.3234,670.3871;Float;False;Constant;_1;1;-1;0;0;0;0;FLOAT
Node;AmplifyShaderEditor.FractNode;20;817.9233,421.2863;Float;True;0;FLOAT2;0.0;False;FLOAT2
Node;AmplifyShaderEditor.RangedFloatNode;10;890.1981,239.675;Float;False;Constant;_Thickness;Thickness;-1;0;0.8;0;0;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;614.6979,904.3745;Float;True;0;FLOAT2;0.0;False;1;FLOAT;0.5,0;False;FLOAT2
Node;AmplifyShaderEditor.ColorNode;97;1135.82,-530.9415;Float;False;Constant;_Color4;Color 4;0;0;0.473483,1,0.2156863,0;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.DotProductOpNode;108;1957.702,-195.4025;Float;True;0;FLOAT3;0,0,0;False;1;FLOAT3;0.0;False;FLOAT
Node;AmplifyShaderEditor.ColorNode;15;1138.54,-709.2941;Half;False;Constant;_Color0;Color 0;2;0;1,0.2156863,0.2156863,0;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;30;848.2979,1261.174;Float;False;Constant;_Float5;Float 5;-1;0;0.8;0;0;FLOAT
Node;AmplifyShaderEditor.SimpleSubtractOpNode;9;1144.461,26.42758;Float;True;0;FLOAT2;0.0;False;1;FLOAT;0.0,0;False;FLOAT2
Node;AmplifyShaderEditor.SimpleSubtractOpNode;22;1143,402.6591;Float;True;0;FLOAT2;0.0;False;1;FLOAT;0.0,0;False;FLOAT2
Node;AmplifyShaderEditor.FractNode;29;880.2979,957.1746;Float;True;0;FLOAT2;0.0;False;FLOAT2
Node;AmplifyShaderEditor.TFHCRemap;113;2220.601,-148.8022;Float;False;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;3;FLOAT;0.5;False;4;FLOAT;1.0;False;FLOAT
Node;AmplifyShaderEditor.SwitchByFaceNode;92;1880.115,-533.7711;Float;False;0;COLOR;0.0;False;1;COLOR;0,0,0,0;False;COLOR
Node;AmplifyShaderEditor.SimpleSubtractOpNode;31;1182.887,840.8397;Float;True;0;FLOAT2;0.0;False;1;FLOAT;0.0,0;False;FLOAT2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;1541.596,191.1848;Float;False;0;FLOAT2;0.0;False;1;FLOAT2;0.0;False;FLOAT2
Node;AmplifyShaderEditor.WorldPosInputsNode;2;-275.3019,-29.12553;Float;False;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;109;2470.602,-410.0026;Float;False;0;COLOR;0,0,0,0;False;1;FLOAT;0,0,0,0;False;COLOR
Node;AmplifyShaderEditor.WorldPosInputsNode;25;-235.0025,850.5749;Float;False;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;1780.861,402.4869;Float;False;0;FLOAT2;0.0;False;1;FLOAT2;0.0;False;FLOAT2
Node;AmplifyShaderEditor.WorldPosInputsNode;16;-237.4989,411.4224;Float;False;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3050.617,-356.7619;Float;False;True;2;Float;ASEMaterialInspector;0;Unlit;Tim/Slice;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;3;False;0;0;Masked;0;True;True;0;False;TransparentCutout;AlphaTest;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;False;0;4;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;False;Cylindrical;Relative;0;;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;OBJECT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;13;OBJECT;0.0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False
WireConnection;102;0;114;1
WireConnection;102;2;101;0
WireConnection;104;0;115;2
WireConnection;104;2;105;0
WireConnection;18;0;102;0
WireConnection;18;1;23;0
WireConnection;13;0;104;0
WireConnection;13;1;14;0
WireConnection;98;0;116;3
WireConnection;98;2;100;0
WireConnection;7;0;13;0
WireConnection;7;1;8;0
WireConnection;19;0;18;0
WireConnection;19;1;17;0
WireConnection;26;0;98;0
WireConnection;26;1;32;0
WireConnection;6;0;7;0
WireConnection;111;0;107;0
WireConnection;110;0;106;0
WireConnection;20;0;19;0
WireConnection;28;0;26;0
WireConnection;28;1;27;0
WireConnection;108;0;110;0
WireConnection;108;1;111;0
WireConnection;9;0;6;0
WireConnection;9;1;10;0
WireConnection;22;0;20;0
WireConnection;22;1;21;0
WireConnection;29;0;28;0
WireConnection;113;0;108;0
WireConnection;92;0;15;0
WireConnection;92;1;97;0
WireConnection;31;0;29;0
WireConnection;31;1;30;0
WireConnection;83;0;9;0
WireConnection;83;1;22;0
WireConnection;109;0;92;0
WireConnection;109;1;113;0
WireConnection;84;0;83;0
WireConnection;84;1;31;0
WireConnection;0;2;109;0
WireConnection;0;10;84;0
ASEEND*/
//CHKSM=E1F4EA5ED6306C19C8C322F79BA66F19CAEFA6D1