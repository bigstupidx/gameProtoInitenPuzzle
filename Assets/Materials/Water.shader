// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tim/Water"
{
	Properties
	{
		[HideInInspector] __dirty( "", Int ) = 1
		[HideInInspector]_Normal2("Normal2", 2D) = "bump" {}
		_WaterNormal("Water Normal", 2D) = "bump" {}
		_NormalScale("Normal Scale", Float) = 0
		_EdgeColor("Edge Color", Color) = (0,0,0,0)
		_DeepColor("Deep Color", Color) = (1,1,1,0)
		_FresnelScale("Fresnel Scale", Float) = 0
		_FresnelPower("Fresnel Power", Float) = 0
		_WaterFalloff("Water Falloff", Float) = 0
		_Distortion("Distortion", Float) = 0.5
		_WaterSpeed("Water Speed", Float) = 0
		_Smoothness("Smoothness", Float) = 0
		_Specular("Specular", Color) = (0,0,0,0)
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Transparent+0" }
		Cull Back
		GrabPass{ "WaterGrab" }
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma surface surf StandardSpecular keepalpha  vertex:vertexDataFunc 
		struct Input
		{
			float2 texcoord_0;
			float4 screenPos;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform sampler2D _Normal2;
		uniform half _WaterSpeed;
		uniform half _NormalScale;
		uniform sampler2D _WaterNormal;
		uniform half4 _DeepColor;
		uniform half4 _EdgeColor;
		uniform sampler2D _CameraDepthTexture;
		uniform half _WaterFalloff;
		uniform half _FresnelScale;
		uniform half _FresnelPower;
		uniform sampler2D WaterGrab;
		uniform half _Distortion;
		uniform half4 _Specular;
		uniform half _Smoothness;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			o.texcoord_0.xy = v.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
		}

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float mulTime190 = _Time.y * _WaterSpeed;
			o.Normal = BlendNormals( UnpackNormal( tex2D( _Normal2,(abs( i.texcoord_0+mulTime190 * float2(-0.03,0 )))) ) , UnpackScaleNormal( tex2D( _WaterNormal,(abs( i.texcoord_0+mulTime190 * float2(0.04,0.04 )))) ,_NormalScale ) );
			float eyeDepth1 = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD(i.screenPos))));
			float3 worldViewDir = normalize( UnityWorldSpaceViewDir( i.worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelFinalVal163 = (0.0 + _FresnelScale*pow( 1.0 - dot( ase_worldNormal, worldViewDir ) , _FresnelPower));
			float2 appendResult67 = float2( i.screenPos.x , i.screenPos.y );
			o.Albedo = lerp( lerp( _DeepColor , _EdgeColor , clamp( ( ( 1.0 - saturate( pow( abs( ( eyeDepth1 - i.screenPos.w ) ) , _WaterFalloff ) ) ) + fresnelFinalVal163 ) , 0.0 , 1.0 ) ) , tex2D( WaterGrab, ( half3( ( appendResult67 / i.screenPos.w ) ,  0.0 ) + ( BlendNormals( UnpackNormal( tex2D( _Normal2,(abs( i.texcoord_0+mulTime190 * float2(-0.03,0 )))) ) , UnpackScaleNormal( tex2D( _WaterNormal,(abs( i.texcoord_0+mulTime190 * float2(0.04,0.04 )))) ,_NormalScale ) ) * _Distortion ) ).xy ) , (0.0 + (clamp( ( ( 1.0 - saturate( pow( abs( ( eyeDepth1 - i.screenPos.w ) ) , _WaterFalloff ) ) ) + fresnelFinalVal163 ) , 0.0 , 1.0 ) - 0.0) * (0.25 - 0.0) / (1.0 - 0.0)) ).rgb;
			o.Specular = _Specular.rgb;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=7003
0;668;1641;350;-699.7891;880.5814;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;152;-2332.356,-429.4976;Float;False;828.5967;315.5001;Screen depth difference to get intersection and fading effect with terrain and obejcts;4;2;1;3;89;
Node;AmplifyShaderEditor.ScreenPosInputsNode;2;-2272.756,-332.3975;Float;False;1;False;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.ScreenDepthNode;1;-2065.354,-366.6975;Float;False;0;0;FLOAT4;0,0,0,0;False;FLOAT
Node;AmplifyShaderEditor.CommentaryNode;151;-1432.806,-1328.282;Float;False;1281.603;457.1994;Blend panning normals to fake noving ripples;8;19;24;21;22;17;48;23;190;
Node;AmplifyShaderEditor.RangedFloatNode;191;-1657.411,-1055.583;Float;False;Property;_WaterSpeed;Water Speed;10;0;0;0;0;FLOAT
Node;AmplifyShaderEditor.SimpleTimeNode;190;-1360.412,-1066.583;Float;False;0;FLOAT;1.0;False;FLOAT
Node;AmplifyShaderEditor.SimpleSubtractOpNode;3;-1871.657,-337.2974;Float;True;0;FLOAT;0.0;False;1;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.TextureCoordinatesNode;21;-1382.806,-1250.983;Float;False;0;-1;2;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;FLOAT2;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.AbsOpNode;89;-1649.759,-328.7809;Float;False;0;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;48;-1099.209,-1049.184;Float;False;Property;_NormalScale;Normal Scale;2;0;0;0;0;FLOAT
Node;AmplifyShaderEditor.PannerNode;19;-1107.808,-1165.783;Float;False;0.04;0.04;0;FLOAT2;0,0;False;1;FLOAT;0.0;False;FLOAT2
Node;AmplifyShaderEditor.PannerNode;22;-1110.108,-1278.282;Float;False;-0.03;0;0;FLOAT2;0,0;False;1;FLOAT;0.0;False;FLOAT2
Node;AmplifyShaderEditor.RangedFloatNode;10;-1467.699,-205.8;Float;False;Property;_WaterFalloff;Water Falloff;6;0;0;0;0;FLOAT
Node;AmplifyShaderEditor.CommentaryNode;150;22.29543,-1513.982;Float;False;985.6011;418.6005;Get screen color for refraction and disturbe it with normals;8;68;97;149;98;67;65;66;96;
Node;AmplifyShaderEditor.SamplerNode;23;-772.8073,-1289.983;Float;True;Property;_Normal2;Normal2;-1;1;[HideInInspector];None;True;0;True;bump;Auto;True;Instance;-1;Auto;Texture2D;0;SAMPLER2D;0,0;False;1;FLOAT2;1.0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;17;-766.2067,-1075.083;Float;True;Property;_WaterNormal;Water Normal;1;0;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;0;SAMPLER2D;0,0;False;1;FLOAT2;1.0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.PowerNode;87;-1264.405,-319.5832;Float;False;0;FLOAT;0.0;False;1;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;175;-1827.098,218.7973;Float;False;Property;_FresnelScale;Fresnel Scale;5;0;0;0;0;FLOAT
Node;AmplifyShaderEditor.BlendNormalsNode;24;-394.2035,-1139.983;Float;False;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;FLOAT3
Node;AmplifyShaderEditor.ScreenPosInputsNode;66;64.69594,-1462.082;Float;False;1;False;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SaturateNode;94;-1005.804,-276.5838;Float;False;0;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.WorldNormalVector;169;-1699.506,-27.18373;Float;False;0;FLOAT3;0,0,0;False;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;173;-1847.597,322.9967;Float;False;Property;_FresnelPower;Fresnel Power;6;0;0;0;0;FLOAT
Node;AmplifyShaderEditor.WireNode;149;50.59401,-1243.381;Float;False;0;FLOAT3;0.0,0,0;False;FLOAT3
Node;AmplifyShaderEditor.FresnelNode;163;-1402.029,102.2821;Float;False;0;FLOAT3;0,0,0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;3;FLOAT;2.0;False;FLOAT
Node;AmplifyShaderEditor.OneMinusNode;189;-825.8102,-176.6837;Float;False;0;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.AppendNode;67;259.6953,-1450.683;Float;False;FLOAT2;0;0;0;0;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;FLOAT2
Node;AmplifyShaderEditor.RangedFloatNode;97;257.5962,-1213.482;Float;False;Property;_Distortion;Distortion;9;0;0.5;0;0;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;435.6973,-1290.082;Float;False;0;FLOAT3;0.0,0,0;False;1;FLOAT;0,0,0;False;FLOAT3
Node;AmplifyShaderEditor.SimpleAddOpNode;165;-546.9038,-123.086;Float;False;0;FLOAT;0.0;False;1;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.SimpleDivideOpNode;68;433.3965,-1397.982;Float;False;0;FLOAT2;0.0,0;False;1;FLOAT;0,0;False;FLOAT2
Node;AmplifyShaderEditor.SimpleAddOpNode;96;588.7963,-1356.982;Float;False;0;FLOAT2;0.0,0;False;1;FLOAT3;0,0;False;FLOAT3
Node;AmplifyShaderEditor.ColorNode;12;-762.2004,-708.6008;Float;False;Property;_EdgeColor;Edge Color;3;0;0,0,0,0;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.ClampOpNode;184;-298.3079,-375.7837;Float;False;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;FLOAT
Node;AmplifyShaderEditor.ColorNode;11;-757.8995,-529.6004;Float;False;Property;_DeepColor;Deep Color;4;0;1,1,1,0;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.ScreenColorNode;65;752.2974,-1359.782;Float;False;Global;WaterGrab;WaterGrab;-1;0;Object;-1;0;FLOAT2;0,0;False;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.TFHCRemap;188;341.9898,-579.1835;Float;False;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;3;FLOAT;0.0;False;4;FLOAT;0.25;False;FLOAT
Node;AmplifyShaderEditor.LerpOp;13;40.40007,-686.8998;Float;False;0;COLOR;0,0,0,0;False;1;COLOR;0.0;False;2;FLOAT;0.0;False;COLOR
Node;AmplifyShaderEditor.RangedFloatNode;103;-870.7366,472.356;Float;False;Constant;_Occlusion;Occlusion;-1;0;0;0;0;FLOAT
Node;AmplifyShaderEditor.ColorNode;186;1237.091,-866.9835;Float;False;Property;_Specular;Specular;10;0;0,0,0,0;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.LerpOp;93;1556.697,-1106.686;Float;False;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0;False;COLOR
Node;AmplifyShaderEditor.RangedFloatNode;26;-1120.035,485.2545;Float;False;Property;_WaterSmoothness;Water Smoothness;8;0;0;0;0;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;104;-1104.036,397.7589;Float;False;Property;_WaterSpecular;Water Specular;7;0;0;0;0;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;185;1251.59,-682.6839;Float;False;Property;_Smoothness;Smoothness;10;0;0;0;0;FLOAT
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1806.169,-943.6585;Half;False;True;2;Half;ASEMaterialInspector;0;StandardSpecular;Tim/Water;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;3;False;0;0;Translucent;0.5;True;False;0;False;Opaque;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;False;0;4;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;False;Cylindrical;Relative;0;;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;OBJECT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;13;OBJECT;0.0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False
WireConnection;1;0;2;0
WireConnection;190;0;191;0
WireConnection;3;0;1;0
WireConnection;3;1;2;4
WireConnection;89;0;3;0
WireConnection;19;0;21;0
WireConnection;19;1;190;0
WireConnection;22;0;21;0
WireConnection;22;1;190;0
WireConnection;23;1;22;0
WireConnection;17;1;19;0
WireConnection;17;5;48;0
WireConnection;87;0;89;0
WireConnection;87;1;10;0
WireConnection;24;0;23;0
WireConnection;24;1;17;0
WireConnection;94;0;87;0
WireConnection;149;0;24;0
WireConnection;163;0;169;0
WireConnection;163;2;175;0
WireConnection;163;3;173;0
WireConnection;189;0;94;0
WireConnection;67;0;66;1
WireConnection;67;1;66;2
WireConnection;98;0;149;0
WireConnection;98;1;97;0
WireConnection;165;0;189;0
WireConnection;165;1;163;0
WireConnection;68;0;67;0
WireConnection;68;1;66;4
WireConnection;96;0;68;0
WireConnection;96;1;98;0
WireConnection;184;0;165;0
WireConnection;65;0;96;0
WireConnection;188;0;184;0
WireConnection;13;0;11;0
WireConnection;13;1;12;0
WireConnection;13;2;184;0
WireConnection;93;0;13;0
WireConnection;93;1;65;0
WireConnection;93;2;188;0
WireConnection;0;0;93;0
WireConnection;0;1;24;0
WireConnection;0;3;186;0
WireConnection;0;4;185;0
ASEEND*/
//CHKSM=578B1B2AC4449278182E1E1C8BD4EE421B23B2E5