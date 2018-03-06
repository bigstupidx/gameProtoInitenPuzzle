// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tim/Slice2"
{
	Properties
	{
		_MaskClipValue( "Mask Clip Value", Float ) = -0.01
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float3 worldPos;
			fixed ASEVFace : VFACE;
		};

		uniform float _MaskClipValue = -0.01;

		inline fixed4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return fixed4 ( s.Emission, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 _Color3 = float4(0.03921569,0.03921569,0.03921569,0);
			float3 ase_worldPos = i.worldPos;
			float mulTime14 = _Time.y * -0.2;
			float temp_output_9_0 = ( frac( ( ( ase_worldPos.y + mulTime14 ) * 2.0 ) ) - 0.5 );
			float mulTime23 = _Time.y * 0.1;
			float temp_output_22_0 = ( frac( ( ( ase_worldPos.x + mulTime23 ) * 2.0 ) ) - 0.3 );
			float mulTime32 = _Time.y * 0.3;
			float temp_output_31_0 = ( frac( ( ( ase_worldPos.z + mulTime32 ) * 4.0 ) ) - 0.7 );
			float4 switchResult92 = (((i.ASEVFace>0)?(( ( lerp( _Color3 , half4(0.5125351,0,1,0) , temp_output_9_0 ) + lerp( _Color3 , half4(1,0.5013927,0,0) , temp_output_22_0 ) ) + lerp( _Color3 , half4(0,1,0.5069637,0) , temp_output_31_0 ) )):(float4(0.1960784,0.1960784,0.1960784,0))));
			o.Emission = switchResult92.rgb;
			o.Alpha = 1;
			clip( ( ( temp_output_9_0 * temp_output_22_0 ) * temp_output_31_0 ) - _MaskClipValue );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=7003
718;602;1906;903;2583.519;1773.948;5.482718;True;True
Node;AmplifyShaderEditor.SimpleTimeNode;23;-53.77667,293.5866;Float;False;0;FLOAT;0.1;False;FLOAT
Node;AmplifyShaderEditor.WorldPosInputsNode;16;-61.49896,420.2224;Float;False;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleTimeNode;14;-116.2012,-128.5258;Float;False;0;FLOAT;-0.2;False;FLOAT
Node;AmplifyShaderEditor.WorldPosInputsNode;2;-121.9019,4.174469;Float;False;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;8;276.0981,178.5745;Float;False;Constant;_Float1;Float 1;-1;0;2;0;0;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;17;356.123,613.4864;Float;False;Constant;_Float1;Float 1;-1;0;2;0;0;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;18;294.6239,298.9866;Float;True;0;FLOAT;0.0;False;1;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;13;232.1991,-123.1257;Float;True;0;FLOAT;0.0;False;1;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.WorldPosInputsNode;25;0.2977448,957.1746;Float;False;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleTimeNode;32;15.79584,809.4599;Float;False;0;FLOAT;0.3;False;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;508.098,-49.62576;Float;True;0;FLOAT;0.0;False;1;FLOAT;0.5;False;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;27;416.2977,1149.174;Float;False;Constant;_Float4;Float 4;-1;0;4;0;0;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;26;352.2977,845.1745;Float;True;0;FLOAT;0.0;False;1;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;570.5228,372.4864;Float;True;0;FLOAT;0.0;False;1;FLOAT;0.5;False;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;21;885.3234,670.3871;Float;False;Constant;_Float3;Float 3;-1;0;0.3;0;0;FLOAT
Node;AmplifyShaderEditor.FractNode;20;817.9233,421.2863;Float;True;0;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.FractNode;6;827.3976,-47.92558;Float;True;0;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;10;890.1981,239.675;Float;False;Constant;_Thickness;Thickness;-1;0;0.5;0;0;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;640.2976,909.1744;Float;True;0;FLOAT;0.0;False;1;FLOAT;0.5;False;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;30;848.2979,1261.174;Float;False;Constant;_Float5;Float 5;-1;0;0.7;0;0;FLOAT
Node;AmplifyShaderEditor.SimpleSubtractOpNode;22;1245.511,437.6058;Float;True;0;FLOAT;0.0;False;1;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.ColorNode;91;281.91,-1132.196;Float;False;Constant;_Color3;Color 3;0;0;0.03921569,0.03921569,0.03921569,0;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.ColorNode;15;265.9422,-929.2004;Half;False;Constant;_Color0;Color 0;2;0;0.5125351,0,1,0;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleSubtractOpNode;9;1139.567,26.42758;Float;True;0;FLOAT;0.0;False;1;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.FractNode;29;880.2979,957.1746;Float;True;0;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.ColorNode;35;269.3523,-624.7692;Half;False;Constant;_Color1;Color 1;2;0;1,0.5013927,0,0;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.LerpOp;44;1717.99,-665.2582;Float;False;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0;False;COLOR
Node;AmplifyShaderEditor.ColorNode;36;288.1992,-295.5602;Half;False;Constant;_Color2;Color 2;2;0;0,1,0.5069637,0;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleSubtractOpNode;31;1225.387,838.3397;Float;True;0;FLOAT;0.0;False;1;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.LerpOp;39;1715.021,-958.2267;Float;False;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0;False;COLOR
Node;AmplifyShaderEditor.SimpleAddOpNode;85;2015.583,-777.7133;Float;False;0;COLOR;0,0,0,0;False;1;COLOR;0.0;False;COLOR
Node;AmplifyShaderEditor.LerpOp;46;1712.74,-270.7688;Float;False;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0;False;COLOR
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;1541.596,191.1848;Float;False;0;FLOAT;0.0;False;1;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.ColorNode;97;2401.422,-676.5416;Float;False;Constant;_Color4;Color 4;0;0;0.1960784,0.1960784,0.1960784,0;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;89;2180.558,-374.0281;Float;True;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;COLOR
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;1780.861,402.4869;Float;False;0;FLOAT;0.0;False;1;FLOAT;0.0;False;FLOAT
Node;AmplifyShaderEditor.SwitchByFaceNode;92;2759.318,-455.3714;Float;False;0;COLOR;0.0;False;1;COLOR;0,0,0,0;False;COLOR
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3050.617,-356.7619;Float;False;True;2;Float;ASEMaterialInspector;0;Unlit;Tim/Slice2;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;3;False;0;0;Masked;-0.01;True;True;0;False;TransparentCutout;AlphaTest;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;False;0;4;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;False;Cylindrical;Relative;0;;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;OBJECT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;13;OBJECT;0.0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False
WireConnection;18;0;16;1
WireConnection;18;1;23;0
WireConnection;13;0;2;2
WireConnection;13;1;14;0
WireConnection;7;0;13;0
WireConnection;7;1;8;0
WireConnection;26;0;25;3
WireConnection;26;1;32;0
WireConnection;19;0;18;0
WireConnection;19;1;17;0
WireConnection;20;0;19;0
WireConnection;6;0;7;0
WireConnection;28;0;26;0
WireConnection;28;1;27;0
WireConnection;22;0;20;0
WireConnection;22;1;21;0
WireConnection;9;0;6;0
WireConnection;9;1;10;0
WireConnection;29;0;28;0
WireConnection;44;0;91;0
WireConnection;44;1;35;0
WireConnection;44;2;22;0
WireConnection;31;0;29;0
WireConnection;31;1;30;0
WireConnection;39;0;91;0
WireConnection;39;1;15;0
WireConnection;39;2;9;0
WireConnection;85;0;39;0
WireConnection;85;1;44;0
WireConnection;46;0;91;0
WireConnection;46;1;36;0
WireConnection;46;2;31;0
WireConnection;83;0;9;0
WireConnection;83;1;22;0
WireConnection;89;0;85;0
WireConnection;89;1;46;0
WireConnection;84;0;83;0
WireConnection;84;1;31;0
WireConnection;92;0;89;0
WireConnection;92;1;97;0
WireConnection;0;2;92;0
WireConnection;0;10;84;0
ASEEND*/
//CHKSM=B6E1280C21BEC4F401B1B7293C701431489C225F