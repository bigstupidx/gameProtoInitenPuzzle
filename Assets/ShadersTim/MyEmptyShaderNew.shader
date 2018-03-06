// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tim/Spirale"
{
	Properties
	{
		[HideInInspector] __dirty( "", Int ) = 1
		_ColorC("Color C", Color) = (0,1,1,0)
		_ColorD("Color D", Color) = (0,0.4902508,1,0)
		_Depth("Depth", Float) = 0.1
		_ColorB("Color B", Color) = (1,0.5013927,0,0)
		_ColorA("Color A", Color) = (0.9972146,0,0,0)
		_OffsetSpeed("OffsetSpeed", Float) = 0
		_OffsetIntensity("OffsetIntensity", Float) = 0
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 texcoord_0;
		};

		uniform float4 _ColorA;
		uniform float4 _ColorB;
		uniform float _OffsetSpeed;
		uniform float _OffsetIntensity;
		uniform float4 _ColorC;
		uniform float4 _ColorD;
		uniform float _Depth;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float mulTime59 = _Time.y * _OffsetSpeed;
			float2 appendResult60 = float2( cos( mulTime59 ) , sin( mulTime59 ) );
			o.texcoord_0.xy = v.texcoord.xy * float2( 1,1 ) + ( appendResult60 * _OffsetIntensity );
		}

		inline fixed4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return fixed4 ( s.Emission, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 temp_output_4_0 = (float2( -1,-1 ) + (i.texcoord_0 - float2( 0,0 )) * (float2( 1,1 ) - float2( -1,-1 )) / (float2( 1,1 ) - float2( 0,0 )));
			float2 componentMask12 = temp_output_4_0.xy;
			float2 appendResult14 = float2( length( temp_output_4_0 ) , ( ( atan2( componentMask12.y , componentMask12.x ) / 6.28318548202515 ) + 0.5 ) );
			float componentMask16 = appendResult14.x;
			float mulTime49 = _Time.y * 10.0;
			float temp_output_50_0 = ( componentMask16 + ( sin( mulTime49 ) * 0.0 ) );
			float mulTime32 = _Time.y * 10.0;
			float componentMask19 = appendResult14.y;
			o.Emission = lerp( lerp( _ColorA , _ColorB , temp_output_50_0 ) , lerp( _ColorC , _ColorD , temp_output_50_0 ) , sin( ( mulTime32 + ( ( ( _Depth / componentMask16 ) + ( componentMask19 * 0.2 ) ) * 10.0 * UNITY_PI ) ) ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=7003
0;668;1553;350;2345.948;203.9512;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;68;-2028.948,-160.9512;Float;False;Property;_OffsetSpeed;OffsetSpeed;5;0;0;0;0;FLOAT
Node;AmplifyShaderEditor.SimpleTimeNode;59;-1820.45,-170.151;Float;False;0;FLOAT;10.0;False;FLOAT
Node;AmplifyShaderEditor.SinOpNode;57;-1573.348,-120.5514;Float;False;0;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.CosOpNode;55;-1575.348,-200.5514;Float;False;0;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;69;-1454.948,-21.95122;Float;False;Property;_OffsetIntensity;OffsetIntensity;6;0;0;0;0;FLOAT
Node;AmplifyShaderEditor.AppendNode;60;-1425.45,-168.151;Float;False;FLOAT2;0;0;0;0;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;FLOAT2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;-1232.45,-146.151;Float;False;0;FLOAT2;0.0;False;1;FLOAT;0,0;False;FLOAT2
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-1064.9,-161.6;Float;False;0;-1;2;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;FLOAT2;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.CommentaryNode;15;-571.2994,-194.7;Float;False;1576.699;623.7;Radial coordinates;8;12;8;7;13;9;5;11;14;
Node;AmplifyShaderEditor.TFHCRemap;4;-788.8004,-149.8;Float;False;0;FLOAT2;0.0;False;1;FLOAT2;0,0;False;2;FLOAT2;1,1;False;3;FLOAT2;-1,-1;False;4;FLOAT2;1,1;False;FLOAT2
Node;AmplifyShaderEditor.ComponentMaskNode;12;-521.2994,19.50002;Float;True;True;True;True;True;0;FLOAT2;0,0,0,0;False;FLOAT2
Node;AmplifyShaderEditor.BreakToComponentsNode;8;-258.7999,75.70001;Float;True;FLOAT2;0;FLOAT2;0.0;False;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.ATan2OpNode;7;-8.799927,73.70001;Float;True;0;FLOAT;0.0;False;1;FLOAT;0.0,0;False;FLOAT
Node;AmplifyShaderEditor.TauNode;13;80,295.7;Float;False;FLOAT
Node;AmplifyShaderEditor.SimpleDivideOpNode;9;212.2001,152.8;Float;True;0;FLOAT;0.0;False;1;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;11;452.5002,176.0001;Float;True;0;FLOAT;0.0;False;1;FLOAT;0.5;False;FLOAT
Node;AmplifyShaderEditor.LengthOpNode;5;452.1001,-144.7;Float;True;0;FLOAT2;0,0,0,0;False;FLOAT
Node;AmplifyShaderEditor.AppendNode;14;756.4001,42.2;Float;True;FLOAT2;0;0;0;0;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;FLOAT2
Node;AmplifyShaderEditor.ComponentMaskNode;16;1104.3,-55.90002;Float;True;True;False;False;False;0;FLOAT2;0,0,0,0;False;FLOAT
Node;AmplifyShaderEditor.ComponentMaskNode;19;1109.1,137.6999;Float;True;False;True;False;False;0;FLOAT2;0,0;False;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;62;1095.351,-387.8512;Float;False;Property;_Depth;Depth;0;0;0.1;0;0;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;23;1233.299,454.3999;Float;False;Constant;_Float0;Float 0;0;0;0.2;0;0;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;1464.699,312.6998;Float;False;0;FLOAT;0.0;False;1;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.SimpleTimeNode;49;1370.852,-648.8514;Float;False;0;FLOAT;10.0;False;FLOAT
Node;AmplifyShaderEditor.SimpleDivideOpNode;37;1561.35,-178.2501;Float;False;0;FLOAT;0.0;False;1;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;36;1747.049,-270.5502;Float;False;Constant;_Float2;Float 2;0;0;10;0;0;FLOAT
Node;AmplifyShaderEditor.PiNode;21;1725,-156.4001;Float;False;0;FLOAT;10.0;False;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;20;1717.3,19.49998;Float;True;0;FLOAT;0.0;False;1;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.SinOpNode;48;1575.552,-670.8514;Float;False;0;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;1977.8,-83.40007;Float;False;0;FLOAT;0.0;False;1;FLOAT;13.0;False;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;1750.351,-683.0516;Float;False;0;FLOAT;0.0;False;1;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.SimpleTimeNode;32;1966.298,-256.7001;Float;False;0;FLOAT;10.0;False;FLOAT
Node;AmplifyShaderEditor.ColorNode;45;2074.649,-931.9503;Float;False;Property;_ColorB;Color B;0;0;1,0.5013927,0,0;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.ColorNode;47;2173.851,-429.8503;Float;False;Property;_ColorD;Color D;0;0;0,0.4902508,1,0;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.ColorNode;40;2169.751,-617.0506;Float;False;Property;_ColorC;Color C;0;0;0,1,1,0;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;24;2197.698,-128.0001;Float;False;0;FLOAT;0.0;False;1;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;50;1953.85,-681.6514;Float;False;0;FLOAT;0.0;False;1;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.ColorNode;39;2069.953,-1117.851;Float;False;Property;_ColorA;Color A;0;0;0.9972146,0,0,0;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.LerpOp;46;2521.553,-481.95;Float;False;0;COLOR;0,0,0,0;False;1;COLOR;0.0;False;2;FLOAT;0.0;False;COLOR
Node;AmplifyShaderEditor.LerpOp;42;2526.548,-832.9509;Float;False;0;COLOR;0.0;False;1;COLOR;0.0,0,0,0;False;2;FLOAT;0.0;False;COLOR
Node;AmplifyShaderEditor.SinOpNode;17;2392.299,-127.4;Float;False;0;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.LerpOp;41;2776.85,-468.1504;Float;False;0;COLOR;0.0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0;False;COLOR
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3252.7,-381.9001;Float;False;True;2;Float;ASEMaterialInspector;0;Unlit;Tim/Spirale;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;False;0;4;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;False;Cylindrical;Relative;0;;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;OBJECT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;13;OBJECT;0.0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False
WireConnection;59;0;68;0
WireConnection;57;0;59;0
WireConnection;55;0;59;0
WireConnection;60;0;55;0
WireConnection;60;1;57;0
WireConnection;61;0;60;0
WireConnection;61;1;69;0
WireConnection;1;1;61;0
WireConnection;4;0;1;0
WireConnection;12;0;4;0
WireConnection;8;0;12;0
WireConnection;7;0;8;1
WireConnection;7;1;8;0
WireConnection;9;0;7;0
WireConnection;9;1;13;0
WireConnection;11;0;9;0
WireConnection;5;0;4;0
WireConnection;14;0;5;0
WireConnection;14;1;11;0
WireConnection;16;0;14;0
WireConnection;19;0;14;0
WireConnection;22;0;19;0
WireConnection;22;1;23;0
WireConnection;37;0;62;0
WireConnection;37;1;16;0
WireConnection;20;0;37;0
WireConnection;20;1;22;0
WireConnection;48;0;49;0
WireConnection;18;0;20;0
WireConnection;18;1;21;0
WireConnection;51;0;48;0
WireConnection;32;0;36;0
WireConnection;24;0;32;0
WireConnection;24;1;18;0
WireConnection;50;0;16;0
WireConnection;50;1;51;0
WireConnection;46;0;40;0
WireConnection;46;1;47;0
WireConnection;46;2;50;0
WireConnection;42;0;39;0
WireConnection;42;1;45;0
WireConnection;42;2;50;0
WireConnection;17;0;24;0
WireConnection;41;0;42;0
WireConnection;41;1;46;0
WireConnection;41;2;17;0
WireConnection;0;2;41;0
ASEEND*/
//CHKSM=288DF012049331F261F5AF6D2B9F830AAB428445