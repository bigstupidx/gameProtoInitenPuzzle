// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tim/Spike"
{
	Properties
	{
		[HideInInspector] __dirty( "", Int ) = 1
		_TopTexture0("Top Texture 0", 2D) = "white" {}
		_SpeedY("SpeedY", Float) = 10
		_SpeedZ("SpeedZ", Float) = 10
		_SpeedX("SpeedX", Float) = 10
		_IntensityY("IntensityY", Float) = 0
		_IntensityZ("IntensityZ", Float) = 0
		_IntensityX("IntensityX", Float) = 0
		_OffsetZ("OffsetZ", Float) = 0
		_NoiseIntensity("NoiseIntensity", Float) = 0
		_Tiling("Tiling", Float) = 0
		_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 4
		_TessMin( "Tess Min Distance", Float ) = 10
		_TessMax( "Tess Max Distance", Float ) = 25
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
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
			INTERNAL_DATA
		};

		struct appdata
		{
			float4 vertex : POSITION;
			float4 tangent : TANGENT;
			float3 normal : NORMAL;
			float4 texcoord : TEXCOORD0;
			float4 texcoord1 : TEXCOORD1;
			float4 texcoord2 : TEXCOORD2;
			float4 texcoord3 : TEXCOORD3;
			fixed4 color : COLOR;
			UNITY_VERTEX_INPUT_INSTANCE_ID
		};

		uniform float _SpeedZ;
		uniform float _OffsetZ;
		uniform float _SpeedX;
		uniform float _SpeedY;
		uniform float _IntensityZ;
		uniform float _IntensityX;
		uniform float _IntensityY;
		uniform sampler2D _TopTexture0;
		uniform float _Tiling;
		uniform float _NoiseIntensity;
		uniform float _TessValue;
		uniform float _TessMin;
		uniform float _TessMax;


		inline float4 TriplanarSampling( sampler2D topTexMap, sampler2D midTexMap, sampler2D botTexMap, float3 worldPos, float3 worldNormal, float falloff, float tilling, float vertex )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= projNormal.x + projNormal.y + projNormal.z;
			float3 nsign = sign( worldNormal );
			half4 xNorm; half4 yNorm; half4 zNorm;
			if(vertex == 1){
			xNorm = ( tex2Dlod( topTexMap, float4((tilling * worldPos.zy * float2( nsign.x, 1.0 )).xy,0,0) ) );
			yNorm = ( tex2Dlod( topTexMap, float4((tilling * worldPos.zx).xy,0,0) ) );
			zNorm = ( tex2Dlod( topTexMap, float4((tilling * worldPos.xy * float2( -nsign.z, 1.0 )).xy,0,0) ) );
			} else {
			xNorm = ( tex2D( topTexMap, tilling * worldPos.zy * float2( nsign.x, 1.0 ) ) );
			yNorm = ( tex2D( topTexMap, tilling * worldPos.zx ) );
			zNorm = ( tex2D( topTexMap, tilling * worldPos.xy * float2( -nsign.z, 1.0 ) ) );
			}
			return xNorm* projNormal.x + yNorm* projNormal.y + zNorm* projNormal.z;
		}


		float4 tessFunction( appdata v0, appdata v1, appdata v2 )
		{
			return UnityDistanceBasedTess( v0.vertex, v1.vertex, v2.vertex, _TessMin, _TessMax, _TessValue );
		}

		void vertexDataFunc( inout appdata v )
		{
			float mulTime45 = _Time.y * _SpeedZ;
			float temp_output_48_0 = ( ( sin( ( mulTime45 + _OffsetZ ) ) + 1.0 ) / 2.0 );
			float mulTime35 = _Time.y * _SpeedX;
			float temp_output_38_0 = ( ( cos( mulTime35 ) + 1.0 ) / 2.0 );
			float mulTime28 = _Time.y * _SpeedY;
			float temp_output_25_0 = ( ( sin( mulTime28 ) + 1.0 ) / 2.0 );
			float3 ase_worldPos = mul(unity_ObjectToWorld, v.vertex);
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			float4 triplanar89 = TriplanarSampling( _TopTexture0, _TopTexture0, _TopTexture0, ase_worldPos, ase_worldNormal, 1.0, _Tiling, 1 );
			v.vertex.xyz += ( float4( ( ( ( v.vertex.z * ( temp_output_48_0 * _IntensityZ ) ) * float3(0,0,1) ) + ( ( ( v.vertex.x * ( temp_output_38_0 * _IntensityX ) ) * float3(1,0,0) ) + ( ( v.vertex.y * ( temp_output_25_0 * _IntensityY ) ) * float3(0,1,0) ) ) ) , 0.0 ) * ( triplanar89 * _NoiseIntensity ) ).xyz;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float mulTime45 = _Time.y * _SpeedZ;
			float temp_output_48_0 = ( ( sin( ( mulTime45 + _OffsetZ ) ) + 1.0 ) / 2.0 );
			float temp_output_75_0 = clamp( temp_output_48_0 , 0.0 , 0.8 );
			float mulTime35 = _Time.y * _SpeedX;
			float temp_output_38_0 = ( ( cos( mulTime35 ) + 1.0 ) / 2.0 );
			float temp_output_76_0 = clamp( temp_output_38_0 , 0.0 , 0.8 );
			float mulTime28 = _Time.y * _SpeedY;
			float temp_output_25_0 = ( ( sin( mulTime28 ) + 1.0 ) / 2.0 );
			float temp_output_77_0 = clamp( temp_output_25_0 , 0.0 , 0.8 );
			float4 appendResult80 = float4( temp_output_75_0 , temp_output_76_0 , temp_output_77_0 , 1 );
			float3 desaturateVar86 = lerp( appendResult80.rgb,dot(appendResult80.rgb,float3(0.299,0.587,0.114)),max( max( temp_output_75_0 , temp_output_76_0 ) , temp_output_77_0 ));
			o.Albedo = desaturateVar86;
			float temp_output_96_0 = 1.0;
			o.Metallic = temp_output_96_0;
			o.Smoothness = temp_output_96_0;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha vertex:vertexDataFunc tessellate:tessFunction nolightmap 

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
				Input customInputData;
				vertexDataFunc( v );
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
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
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
0;339;1641;679;347.7029;1238.581;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;34;-663.8511,72.9519;Float;False;Property;_SpeedX;SpeedX;0;0;10;0;0;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;30;-822.9443,592.8213;Float;False;Property;_SpeedY;SpeedY;0;0;10;0;0;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;44;-981.6188,-364.5544;Float;False;Property;_SpeedZ;SpeedZ;0;0;10;0;0;FLOAT
Node;AmplifyShaderEditor.SimpleTimeNode;28;-703.946,467.3214;Float;False;0;FLOAT;50.0;False;FLOAT
Node;AmplifyShaderEditor.SimpleTimeNode;35;-544.8528,-52.54797;Float;False;0;FLOAT;50.0;False;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;57;-763.6169,-331.0705;Float;False;Property;_OffsetZ;OffsetZ;6;0;0;0;0;FLOAT
Node;AmplifyShaderEditor.SimpleTimeNode;45;-851.2058,-479.8521;Float;False;0;FLOAT;50.0;False;FLOAT
Node;AmplifyShaderEditor.CosOpNode;53;-322.3763,-45.55121;Float;False;0;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.SinOpNode;29;-493.5457,469.6212;Float;False;0;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;55;-571.8171,-449.4152;Float;False;0;FLOAT;0.0;False;1;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;24;-321.1451,482.6213;Float;False;0;FLOAT;0.0;False;1;FLOAT;1.0;False;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;37;-162.0519,-37.24808;Float;False;0;FLOAT;0.0;False;1;FLOAT;1.0;False;FLOAT
Node;AmplifyShaderEditor.SinOpNode;46;-384.9248,-471.4312;Float;False;0;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.SimpleDivideOpNode;25;-174.2451,446.2217;Float;False;0;FLOAT;0.0;False;1;FLOAT;2.0;False;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;31;-208.0234,592.3792;Float;False;Property;_IntensityY;IntensityY;1;0;0;0;0;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;33;91.04849,115.0518;Float;False;Property;_IntensityX;IntensityX;1;0;0;0;0;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;47;-211.5242,-458.431;Float;False;0;FLOAT;0.0;False;1;FLOAT;1.0;False;FLOAT
Node;AmplifyShaderEditor.SimpleDivideOpNode;38;-34.95193,-129.1476;Float;False;0;FLOAT;0.0;False;1;FLOAT;2.0;False;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;43;-104.9174,-344.5948;Float;False;Property;_IntensityZ;IntensityZ;1;0;0;0;0;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-4.799024,473.7;Float;False;0;FLOAT;0.0;False;1;FLOAT;1.0;False;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;154.2941,-46.16937;Float;False;0;FLOAT;0.0;False;1;FLOAT;1.0;False;FLOAT
Node;AmplifyShaderEditor.PosVertexDataNode;1;-1275.928,311.3958;Float;True;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleDivideOpNode;48;-65.62421,-462.3306;Float;False;0;FLOAT;0.0;False;1;FLOAT;2.0;False;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;336.3942,-153.1693;Float;False;0;FLOAT;0.0;False;1;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;177.301,366.7001;Float;False;0;FLOAT;0.0,0,0,0;False;1;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;83.8218,-419.8523;Float;False;0;FLOAT;0.0;False;1;FLOAT;1.0;False;FLOAT
Node;AmplifyShaderEditor.Vector3Node;10;178.4004,516.1;Float;False;Constant;_Vector0;Vector 0;0;0;0,1,0;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.Vector3Node;40;337.4936,-3.769409;Float;False;Constant;_Vector1;Vector 1;0;0;1,0,0;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.Vector3Node;50;338.332,-397.3396;Float;False;Constant;_Vector2;Vector 2;0;0;0,0,1;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.ClampOpNode;76;258.6298,-882.3848;Float;False;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.8;False;FLOAT
Node;AmplifyShaderEditor.ClampOpNode;75;257.1301,-1004.385;Float;False;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.8;False;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;394.4004,452.1;Float;False;0;FLOAT;0.0;False;1;FLOAT3;0.0;False;FLOAT3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;373.858,-542.2924;Float;False;0;FLOAT;0.0;False;1;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;536.0894,-92.13533;Float;False;0;FLOAT;0.0;False;1;FLOAT3;0.0;False;FLOAT3
Node;AmplifyShaderEditor.RangedFloatNode;98;614.5964,562.2185;Float;False;Property;_Tiling;Tiling;9;0;0;0;0;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;92;979.3969,493.4172;Float;False;Property;_NoiseIntensity;NoiseIntensity;8;0;0;0;0;FLOAT
Node;AmplifyShaderEditor.ClampOpNode;77;259.4301,-753.585;Float;False;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.8;False;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;673.0213,-513.9523;Float;False;0;FLOAT;0.0;False;1;FLOAT3;0.0;False;FLOAT3
Node;AmplifyShaderEditor.SimpleMaxOp;94;657.4957,-974.4823;Float;False;0;FLOAT;0.0;False;1;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.TriplanarNode;89;728.7972,304.8175;Float;True;Spherical;World;False;Top Texture 0;_TopTexture0;white;-1;None;Mid Texture 0;_MidTexture0;white;-1;None;Bot Texture 0;_BotTexture0;white;-1;None;Triplanar Sampler;0;SAMPLER2D;;False;1;SAMPLER2D;;False;2;SAMPLER2D;;False;3;FLOAT;1.0;False;4;FLOAT;1.0;False;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;18;717.3572,167.5934;Float;False;0;FLOAT3;0,0,0;False;1;FLOAT3;0.0;False;FLOAT3
Node;AmplifyShaderEditor.SimpleMaxOp;95;822.7956,-868.0822;Float;False;0;FLOAT;0.0;False;1;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;91;1164.397,392.4172;Float;False;0;FLOAT4;0.0;False;1;FLOAT;0,0,0,0;False;FLOAT4
Node;AmplifyShaderEditor.AppendNode;80;663.2029,-1198.198;Float;False;COLOR;0;0;0;1;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;COLOR
Node;AmplifyShaderEditor.SimpleAddOpNode;54;961.8451,168.5209;Float;False;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;FLOAT3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;88;1326.297,175.2173;Float;False;0;FLOAT3;0.0,0,0,0;False;1;FLOAT4;0.0,0,0;False;FLOAT4
Node;AmplifyShaderEditor.RangedFloatNode;96;1539.096,-717.9822;Float;False;Constant;_Float1;Float 1;9;0;1;0;0;FLOAT
Node;AmplifyShaderEditor.DesaturateOpNode;86;1336.497,-1148.682;Float;False;0;FLOAT3;0,0,0;False;1;FLOAT;0.0;False;FLOAT3
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1796.082,-829.085;Float;False;True;6;Float;ASEMaterialInspector;0;Standard;Tim/Spike;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;True;0;4;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;False;Cylindrical;Relative;0;;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;OBJECT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;13;OBJECT;0.0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False
WireConnection;28;0;30;0
WireConnection;35;0;34;0
WireConnection;45;0;44;0
WireConnection;53;0;35;0
WireConnection;29;0;28;0
WireConnection;55;0;45;0
WireConnection;55;1;57;0
WireConnection;24;0;29;0
WireConnection;37;0;53;0
WireConnection;46;0;55;0
WireConnection;25;0;24;0
WireConnection;47;0;46;0
WireConnection;38;0;37;0
WireConnection;9;0;25;0
WireConnection;9;1;31;0
WireConnection;39;0;38;0
WireConnection;39;1;33;0
WireConnection;48;0;47;0
WireConnection;41;0;1;1
WireConnection;41;1;39;0
WireConnection;7;0;1;2
WireConnection;7;1;9;0
WireConnection;49;0;48;0
WireConnection;49;1;43;0
WireConnection;76;0;38;0
WireConnection;75;0;48;0
WireConnection;11;0;7;0
WireConnection;11;1;10;0
WireConnection;51;0;1;3
WireConnection;51;1;49;0
WireConnection;42;0;41;0
WireConnection;42;1;40;0
WireConnection;77;0;25;0
WireConnection;52;0;51;0
WireConnection;52;1;50;0
WireConnection;94;0;75;0
WireConnection;94;1;76;0
WireConnection;89;3;98;0
WireConnection;18;0;42;0
WireConnection;18;1;11;0
WireConnection;95;0;94;0
WireConnection;95;1;77;0
WireConnection;91;0;89;0
WireConnection;91;1;92;0
WireConnection;80;0;75;0
WireConnection;80;1;76;0
WireConnection;80;2;77;0
WireConnection;54;0;52;0
WireConnection;54;1;18;0
WireConnection;88;0;54;0
WireConnection;88;1;91;0
WireConnection;86;0;80;0
WireConnection;86;1;95;0
WireConnection;0;0;86;0
WireConnection;0;3;96;0
WireConnection;0;4;96;0
WireConnection;0;11;88;0
ASEEND*/
//CHKSM=91936DCE58AF9DBEA0D97C77D8A2FD69D22FE5D7