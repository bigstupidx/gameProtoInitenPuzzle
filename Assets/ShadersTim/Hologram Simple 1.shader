// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tim/Hollogram"
{
	Properties
	{
		[HideInInspector] __dirty( "", Int ) = 1
		_Hologramcolor("Hologram color", Color) = (0.3973832,0.7720588,0.7410512,0)
		_Speed("Speed", Range( 0 , 100)) = 26
		_ScanLines("Scan Lines", Range( 0 , 10)) = 3
		_Opacity("Opacity", Range( 0 , 1)) = 0.5
		_RimNormalMap("Rim Normal Map", 2D) = "bump" {}
		_RimPower("Rim Power", Range( 0 , 10)) = 5
		_Intensity("Intensity", Range( 1 , 10)) = 1
		_Normal("Normal", Float) = 0
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
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
			float3 worldPos;
			float2 texcoord_0;
			float3 viewDir;
			INTERNAL_DATA
		};

		uniform float4 _Hologramcolor;
		uniform float _ScanLines;
		uniform float _Speed;
		uniform float _Normal;
		uniform sampler2D _RimNormalMap;
		uniform float _RimPower;
		uniform float _Intensity;
		uniform float _Opacity;


		float3 mod289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			o.texcoord_0.xy = v.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Normal = float3(0,0,1);
			float4 HologramColor = _Hologramcolor;
			float3 ase_worldPos = i.worldPos;
			float Speed = _Speed;
			float componentMask105 = ( 1.0 - ( Speed * _Time ) ).x;
			float temp_output_13_0 = sin( ( ( ( _ScanLines * ase_worldPos.y ) + componentMask105 ) * UNITY_PI ) );
			float2 temp_cast_0 = (( ( ase_worldPos.z / 100.0 ) * _Time.x )).xx;
			float simplePerlin2D137 = snoise( temp_cast_0 );
			float myVarName3 = ( simplePerlin2D137 * temp_output_13_0 );
			float4 temp_cast_1 = (myVarName3).xxxx;
			float4 ScanLines = ( lerp( float4(1,1,1,0) , float4(0,0,0,0) , clamp( (0.0 + (temp_output_13_0 - -1.0) * (1.0 - 0.0) / (1.0 - -1.0)) , 0.0 , 1.0 ) ) - temp_cast_1 );
			float temp_output_60_0 = pow( ( 1.0 - saturate( dot( UnpackScaleNormal( tex2D( _RimNormalMap,( ( ( Speed / 1000.0 ) * _Time ) + float4( i.texcoord_0, 0.0 , 0.0 ) ).xy) ,_Normal ) , float4( normalize( i.viewDir ) , 0.0 ) ) ) ) , ( 10.0 - _RimPower ) );
			float Rim = temp_output_60_0;
			float4 temp_cast_5 = (Rim).xxxx;
			o.Emission = ( ( HologramColor * ( ScanLines + temp_cast_5 ) ) * _Intensity ).rgb;
			o.Alpha = _Opacity;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha vertex:vertexDataFunc 

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
				fixed3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				fixed3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
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
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				fixed3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = IN.tSpace0.xyz * worldViewDir.x + IN.tSpace1.xyz * worldViewDir.y + IN.tSpace2.xyz * worldViewDir.z;
				surfIN.worldPos = worldPos;
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
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
0;554;1553;464;3367.042;206.4916;1.3;True;False
Node;AmplifyShaderEditor.CommentaryNode;168;-1574.711,-440.4086;Float;False;614.0698;167.2261;Comment;2;6;156;Speed
Node;AmplifyShaderEditor.RangedFloatNode;6;-1524.711,-388.1825;Float;False;Property;_Speed;Speed;1;0;26;0;100;FLOAT
Node;AmplifyShaderEditor.CommentaryNode;170;-3022.319,557.4162;Float;False;2377.06;920.5361;Comment;26;26;157;27;10;8;2;106;105;107;3;144;11;143;150;13;145;137;14;18;15;149;17;16;146;155;30;Scan Lines
Node;AmplifyShaderEditor.RegisterLocalVarNode;156;-1194.641,-390.4085;Float;False;Speed;-1;True;0;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.GetLocalVarNode;157;-2968.046,1172.153;Float;False;156;FLOAT
Node;AmplifyShaderEditor.TimeNode;26;-2972.319,1275.953;Float;False;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.CommentaryNode;169;-3021.51,-122.5578;Float;False;2344.672;617.4507;Comment;19;58;57;119;55;63;62;64;68;60;65;59;66;163;158;162;167;166;165;171;Rim
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-2744.281,1238.129;Float;False;0;FLOAT;0.0;False;1;FLOAT4;0.0;False;FLOAT4
Node;AmplifyShaderEditor.GetLocalVarNode;162;-2971.51,-72.55784;Float;False;156;FLOAT
Node;AmplifyShaderEditor.WorldPosInputsNode;2;-2729.112,1052.375;Float;False;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;10;-2758.619,959.0287;Float;False;Property;_ScanLines;Scan Lines;2;0;3;0;10;FLOAT
Node;AmplifyShaderEditor.OneMinusNode;8;-2586.184,1208.643;Float;False;0;FLOAT4;0.0;False;FLOAT4
Node;AmplifyShaderEditor.ComponentMaskNode;105;-2409.501,1212.099;Float;False;True;False;False;False;0;FLOAT4;0,0,0,0;False;FLOAT
Node;AmplifyShaderEditor.SimpleDivideOpNode;167;-2719.792,-42.13026;Float;False;0;FLOAT;0.0;False;1;FLOAT;1000.0;False;FLOAT
Node;AmplifyShaderEditor.TimeNode;165;-2967.947,36.28125;Float;False;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;106;-2375.744,1095.72;Float;False;0;FLOAT;0.0;False;1;FLOAT;6.06;False;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;3;-2183.083,1076.942;Float;False;0;FLOAT;0.0;False;1;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;166;-2588.954,11.35542;Float;False;0;FLOAT;0.0;False;1;FLOAT4;0.0;False;FLOAT4
Node;AmplifyShaderEditor.TextureCoordinatesNode;158;-2762.859,253.5992;Float;False;0;-1;2;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;FLOAT2;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.WorldPosInputsNode;144;-2584.736,607.4162;Float;False;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.PiNode;107;-2168.25,1207.71;Float;False;0;FLOAT;1.0;False;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;171;-2415.653,175.408;Float;False;Property;_Normal;Normal;7;0;0;0;0;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;163;-2418.413,25.78291;Float;False;0;FLOAT4;0.0;False;1;FLOAT2;0.0,0,0,0;False;FLOAT4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-1977.072,1080.393;Float;False;0;FLOAT;0.0;False;1;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.SimpleDivideOpNode;150;-2337.172,659.5646;Float;False;0;FLOAT;0.0;False;1;FLOAT;100.0;False;FLOAT
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;58;-2207.716,196.8163;Float;False;Tangent;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.TimeNode;143;-2672.225,752.2511;Float;False;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;119;-2227.099,-27.17607;Float;True;Property;_RimNormalMap;Rim Normal Map;4;0;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;2.0;False;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SinOpNode;13;-1822.559,1164.644;Float;False;0;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.NormalizeNode;57;-2053.684,223.904;Float;False;0;FLOAT3;0,0,0;False;FLOAT3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;145;-2242.656,805.4703;Float;False;0;FLOAT;0.0;False;1;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.TFHCRemap;14;-1613.893,1125.062;Float;False;0;FLOAT;0.0;False;1;FLOAT;-1.0;False;2;FLOAT;1.0;False;3;FLOAT;0.0;False;4;FLOAT;1.0;False;FLOAT
Node;AmplifyShaderEditor.DotProductOpNode;55;-1874.59,100.9621;Float;False;0;FLOAT4;0,0,0;False;1;FLOAT3;0.0,0,0,0;False;FLOAT
Node;AmplifyShaderEditor.NoiseGeneratorNode;137;-2038.733,765.1151;Float;False;Simplex2D;0;FLOAT2;100,100;False;FLOAT
Node;AmplifyShaderEditor.ColorNode;18;-1609.194,931.3765;Float;False;Constant;_Color1;Color 1;2;0;0,0,0,0;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;149;-1785.627,879.263;Float;False;0;FLOAT;0.0;False;1;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.ColorNode;17;-1607.295,756.6489;Float;False;Constant;_Color0;Color 0;2;0;1,1,1,0;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SaturateNode;63;-1686.319,157.5161;Float;False;0;FLOAT;1.23;False;FLOAT
Node;AmplifyShaderEditor.ClampOpNode;15;-1419.946,1115.02;Float;False;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;62;-2157.147,356.4128;Float;False;Property;_RimPower;Rim Power;5;0;5;0;10;FLOAT
Node;AmplifyShaderEditor.OneMinusNode;64;-1517.314,199.8154;Float;False;0;FLOAT;0;False;FLOAT
Node;AmplifyShaderEditor.RegisterLocalVarNode;146;-1631.003,662.647;Float;False;myVarName3;-1;True;0;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.LerpOp;16;-1227.778,943.9414;Float;False;0;COLOR;0.0;False;1;COLOR;0.0,0,0,0;False;2;FLOAT;0.0;False;COLOR
Node;AmplifyShaderEditor.SimpleSubtractOpNode;68;-1741.309,285.1235;Float;False;0;FLOAT;10.0;False;1;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.PowerNode;60;-1324.516,223.2159;Float;False;0;FLOAT;0.0;False;1;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.SimpleSubtractOpNode;155;-1042.575,876.3499;Float;False;0;COLOR;0.0;False;1;FLOAT;0.0,0,0,0;False;COLOR
Node;AmplifyShaderEditor.CommentaryNode;35;-2281.517,-488.6837;Float;False;590.8936;257.7873;Comment;2;32;28;Hologram Color
Node;AmplifyShaderEditor.GetLocalVarNode;114;-783.5459,-416.9459;Float;False;30;COLOR
Node;AmplifyShaderEditor.RegisterLocalVarNode;65;-910.8385,239.3701;Float;False;Rim;-1;True;0;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.ColorNode;28;-2231.517,-438.6837;Float;False;Property;_Hologramcolor;Hologram color;0;0;0.3973832,0.7720588,0.7410512,0;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RegisterLocalVarNode;30;-879.2598,893.1253;Float;False;ScanLines;-1;True;0;COLOR;0,0,0,0;False;COLOR
Node;AmplifyShaderEditor.GetLocalVarNode;33;-776.9076,-324.7064;Float;False;65;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;71;-520.487,-338.0593;Float;False;0;COLOR;0.0;False;1;FLOAT;0,0,0,0;False;COLOR
Node;AmplifyShaderEditor.RegisterLocalVarNode;32;-1963.584,-399.5394;Float;False;HologramColor;-1;True;0;COLOR;0.0;False;COLOR
Node;AmplifyShaderEditor.GetLocalVarNode;127;-557.7931,-444.785;Float;False;32;COLOR
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;126;-302.4253,-399.4778;Float;False;0;COLOR;0.0,0,0,0;False;1;COLOR;0.0;False;COLOR
Node;AmplifyShaderEditor.RangedFloatNode;132;-542.2174,-228.0388;Float;False;Property;_Intensity;Intensity;6;0;1;1;10;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;49;-317.1664,-56.16708;Float;False;Property;_Opacity;Opacity;3;0;0.5;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-1082.116,238.4155;Float;False;0;FLOAT;0;False;1;COLOR;0.0;False;COLOR
Node;AmplifyShaderEditor.GetLocalVarNode;66;-1367.539,379.8929;Float;False;32;COLOR
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;133;-142.8775,-291.8895;Float;False;0;COLOR;0.0;False;1;FLOAT;0.0,0,0,0;False;COLOR
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;89.8217,-401.0934;Float;False;True;2;Float;ASEMaterialInspector;0;Standard;Tim/Hollogram;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Transparent;0.5;True;True;0;False;Transparent;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;False;0;4;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;False;Cylindrical;Relative;0;;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;OBJECT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;13;OBJECT;0.0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False
WireConnection;156;0;6;0
WireConnection;27;0;157;0
WireConnection;27;1;26;0
WireConnection;8;0;27;0
WireConnection;105;0;8;0
WireConnection;167;0;162;0
WireConnection;106;0;10;0
WireConnection;106;1;2;2
WireConnection;3;0;106;0
WireConnection;3;1;105;0
WireConnection;166;0;167;0
WireConnection;166;1;165;0
WireConnection;163;0;166;0
WireConnection;163;1;158;0
WireConnection;11;0;3;0
WireConnection;11;1;107;0
WireConnection;150;0;144;3
WireConnection;119;1;163;0
WireConnection;119;5;171;0
WireConnection;13;0;11;0
WireConnection;57;0;58;0
WireConnection;145;0;150;0
WireConnection;145;1;143;1
WireConnection;14;0;13;0
WireConnection;55;0;119;0
WireConnection;55;1;57;0
WireConnection;137;0;145;0
WireConnection;149;0;137;0
WireConnection;149;1;13;0
WireConnection;63;0;55;0
WireConnection;15;0;14;0
WireConnection;64;0;63;0
WireConnection;146;0;149;0
WireConnection;16;0;17;0
WireConnection;16;1;18;0
WireConnection;16;2;15;0
WireConnection;68;1;62;0
WireConnection;60;0;64;0
WireConnection;60;1;68;0
WireConnection;155;0;16;0
WireConnection;155;1;146;0
WireConnection;65;0;60;0
WireConnection;30;0;155;0
WireConnection;71;0;114;0
WireConnection;71;1;33;0
WireConnection;32;0;28;0
WireConnection;126;0;127;0
WireConnection;126;1;71;0
WireConnection;59;0;60;0
WireConnection;59;1;66;0
WireConnection;133;0;126;0
WireConnection;133;1;132;0
WireConnection;0;2;133;0
WireConnection;0;9;49;0
ASEEND*/
//CHKSM=0A1C6066B0C1B188734ECE4A9C018DBC90A394E1