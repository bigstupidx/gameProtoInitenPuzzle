// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tim/Parallax2"
{
	Properties
	{
		[HideInInspector] __dirty( "", Int ) = 1
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Speed("Speed", Float) = 0
		_Texture0("Texture 0", 2D) = "white" {}
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
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
			float2 texcoord_0;
			float3 viewDir;
			float3 worldNormal;
			INTERNAL_DATA
			float3 worldPos;
		};

		uniform sampler2D _TextureSample0;
		uniform float _Speed;
		uniform sampler2D _Texture0;
		uniform float4 _Texture0_ST;


		inline float2 POM( sampler2D heightMap, float2 uvs, float2 dx, float2 dy, float3 normalWorld, float3 viewWorld, float3 viewDirTan, int minSamples, int maxSamples, float parallax, float refPlane, float2 tilling, float2 curv )
		{
			float3 result = 0;
			int stepIndex = 0;
			int numSteps = ( int )lerp( maxSamples, minSamples, dot( normalWorld, viewWorld ) );
			float layerHeight = 1.0 / numSteps;
			float2 plane = parallax * ( viewDirTan.xy / viewDirTan.z );
			uvs += refPlane * plane;
			float2 deltaTex = -plane * layerHeight;
			float2 prevTexOffset = 0;
			float prevRayZ = 1.0f;
			float prevHeight = 0.0f;
			float2 currTexOffset = deltaTex;
			float currRayZ = 1.0f - layerHeight;
			float currHeight = 0.0f;
			float intersection = 0;
			float2 finalTexOffset = 0;
			while ( stepIndex < numSteps + 1 )
			{
				currHeight = tex2Dgrad( heightMap, uvs + currTexOffset, dx, dy ).r;
				if ( currHeight > currRayZ )
				{
					stepIndex = numSteps + 1;
				}
				else
				{
					stepIndex++;
					prevTexOffset = currTexOffset;
					prevRayZ = currRayZ;
					prevHeight = currHeight;
					currTexOffset += deltaTex;
					currRayZ -= layerHeight;
				}
			}
			int sectionSteps = 8;
			int sectionIndex = 0;
			float newZ = 0;
			float newHeight = 0;
			while ( sectionIndex < sectionSteps )
			{
				intersection = ( prevHeight - prevRayZ ) / ( prevHeight - currHeight + currRayZ - prevRayZ );
				finalTexOffset = prevTexOffset + intersection * deltaTex;
				newZ = prevRayZ - intersection * layerHeight;
				newHeight = tex2Dgrad( heightMap, uvs + finalTexOffset, dx, dy ).r;
				if ( newHeight > newZ )
				{
					currTexOffset = finalTexOffset;
					currHeight = newHeight;
					currRayZ = newZ;
					deltaTex = intersection * deltaTex;
					layerHeight = intersection * layerHeight;
				}
				else
				{
					prevTexOffset = finalTexOffset;
					prevHeight = newHeight;
					prevRayZ = newZ;
					deltaTex = ( 1 - intersection ) * deltaTex;
					layerHeight = ( 1 - intersection ) * layerHeight;
				}
				sectionIndex++;
			}
			return uvs + finalTexOffset;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			o.texcoord_0.xy = v.texcoord.xy * float2( 3,3 ) + float2( 0,0 );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Normal = float3(0,0,1);
			float mulTime33 = _Time.y * _Speed;
			float3 ase_worldNormal = i.worldNormal;
			float3 worldViewDir = normalize( UnityWorldSpaceViewDir( i.worldPos ) );
			float2 OffsetPOM1 = POM( _Texture0, i.texcoord_0, ddx(i.texcoord_0), ddx(i.texcoord_0), ase_worldNormal, worldViewDir, i.viewDir, 32, 64, 0.2, 0, _Texture0_ST.xy, float2(0,0) );
			float3 desaturateVar29 = lerp( (float4( 0.5,0.5,0.5,0.5 ) + (tex2D( _Texture0,OffsetPOM1) - float4( 0,0,0,0 )) * (float4( 1,1,1,1 ) - float4( 0.5,0.5,0.5,0.5 )) / (float4( 1,1,1,1 ) - float4( 0,0,0,0 ))).xyz,dot((float4( 0.5,0.5,0.5,0.5 ) + (tex2D( _Texture0,OffsetPOM1) - float4( 0,0,0,0 )) * (float4( 1,1,1,1 ) - float4( 0.5,0.5,0.5,0.5 )) / (float4( 1,1,1,1 ) - float4( 0,0,0,0 ))).xyz,float3(0.299,0.587,0.114)),0.0);
			o.Albedo = ( tex2D( _TextureSample0,(abs( ( OffsetPOM1 * 1.0 )+mulTime33 * float2(0.1,0 )))) * float4( desaturateVar29 , 0.0 ) ).xyz;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha vertex:vertexDataFunc 

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
238;541;1785;903;966.9127;253.6563;1;True;True
Node;AmplifyShaderEditor.TexturePropertyNode;13;-1041.505,77.78259;Float;True;Property;_Texture0;Texture 0;3;0;None;False;white;Auto;SAMPLER2D
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-1051.705,-218.4173;Float;False;0;-1;2;0;FLOAT2;3,3;False;1;FLOAT2;0,0;False;FLOAT2;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.ParallaxOcclusionMappingNode;1;-772.8054,-107.1173;Float;False;0;32;64;8;0.2;0;False;1,1;False;0,0;0;FLOAT2;0,0;False;1;SAMPLER2D;;False;2;FLOAT;0.02;False;3;FLOAT3;0,0,0;False;4;FLOAT;0.0;False;5;FLOAT2;0,0;False;FLOAT2
Node;AmplifyShaderEditor.RangedFloatNode;16;-674.2883,117.9781;Float;False;Constant;_Float1;Float 1;2;0;1;0;0;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;32;-560.9127,-188.6563;Float;False;Property;_Speed;Speed;2;0;0;0;0;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-411.1373,-9.82819;Float;False;0;FLOAT2;0,0;False;1;FLOAT;0,0;False;FLOAT2
Node;AmplifyShaderEditor.SamplerNode;28;-408.9456,166.5596;Float;True;Property;_TextureSample1;Texture Sample 1;2;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleTimeNode;33;-403.9127,-154.6563;Float;False;0;FLOAT;1.0;False;FLOAT
Node;AmplifyShaderEditor.TFHCRemap;30;-84.14548,238.5595;Float;False;0;FLOAT4;0.0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;1,1,1,1;False;3;FLOAT4;0.5,0.5,0.5,0.5;False;4;FLOAT4;1,1,1,1;False;FLOAT4
Node;AmplifyShaderEditor.PannerNode;14;-191.0368,-187.5625;Float;False;0.1;0;0;FLOAT2;0,0;False;1;FLOAT;0.0;False;FLOAT2
Node;AmplifyShaderEditor.SamplerNode;5;50.19995,-72.00002;Float;True;Property;_TextureSample0;Texture Sample 0;1;0;Assets/Tools/AmplifyShaderEditor/Examples/Community/Dissolve Burn/burn-ramp.png;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.DesaturateOpNode;29;109.4544,187.3594;Float;False;0;FLOAT3;0,0,0;False;1;FLOAT;0.0;False;FLOAT3
Node;AmplifyShaderEditor.RangedFloatNode;31;-356.1455,414.5597;Float;False;Constant;_Float0;Float 0;2;0;0.5;0;0;FLOAT
Node;AmplifyShaderEditor.WorldNormalVector;17;-487.1425,-457.7403;Float;False;0;FLOAT3;0,0,0;False;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.NormalizeNode;19;-173.5444,-404.3406;Float;False;0;FLOAT3;0.0,0,0,0;False;FLOAT3
Node;AmplifyShaderEditor.DotProductOpNode;21;25.45557,-373.3406;Float;False;0;FLOAT3;0.0;False;1;FLOAT3;0,0,0;False;FLOAT
Node;AmplifyShaderEditor.ClampOpNode;22;194.4556,-316.3406;Float;False;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;375.0553,43.35953;Float;False;0;FLOAT4;0.0;False;1;FLOAT3;0,0,0,0;False;FLOAT4
Node;AmplifyShaderEditor.NormalizeNode;20;-172.5444,-331.3406;Float;False;0;FLOAT3;0.0,0,0,0;False;FLOAT3
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;18;-485.2444,-305.7406;Float;False;0;FLOAT;0.0;False;FLOAT3
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;581.6002,-85.70002;Float;False;True;2;Float;ASEMaterialInspector;0;Standard;Tim/Parallax2;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;False;0;4;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;False;Cylindrical;Relative;0;;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;OBJECT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;13;OBJECT;0.0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False
WireConnection;1;0;2;0
WireConnection;1;1;13;0
WireConnection;15;0;1;0
WireConnection;15;1;16;0
WireConnection;28;0;13;0
WireConnection;28;1;1;0
WireConnection;33;0;32;0
WireConnection;30;0;28;0
WireConnection;14;0;15;0
WireConnection;14;1;33;0
WireConnection;5;1;14;0
WireConnection;29;0;30;0
WireConnection;19;0;17;0
WireConnection;21;0;19;0
WireConnection;21;1;20;0
WireConnection;22;0;21;0
WireConnection;26;0;5;0
WireConnection;26;1;29;0
WireConnection;20;0;18;0
WireConnection;0;0;26;0
ASEEND*/
//CHKSM=9C888669A055FA42DE575818EB67EAA089D9542C