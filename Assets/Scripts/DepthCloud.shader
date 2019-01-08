Shader "Custom/DepthCloud" {
	Properties{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0
	}
	SubShader{
		Tags{ "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows vertex:vert

		#pragma multi_compile_instancing
		#pragma instancing_options procedural:setup

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

	#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
		StructuredBuffer<float3> PositionBuffer;
	#endif

		void setup() {
	#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
			float3 verts = PositionBuffer[unity_InstanceID];
			float x = verts.x;
			float y = verts.y;
			float z = verts.z;
			unity_ObjectToWorld._14_24_34_44 = float4(x, y, z, 1);
	#endif
		}

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		void vert(inout appdata_full v) {
	#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
			float size = 0.1;

			float x = (fmod((float)unity_InstanceID, 128.0)) / 128.0;
			float y = ((float)unity_InstanceID / 128.0 *1.0) / 128.0;
			float4 uv = float4(x, y, 0, 0);
			float4 col = tex2Dlod(_MainTex, uv);
			float depth = col.r;

			if(depth > -0.1 && depth < 0.6)
			{
				size = 0.05;
			}

			float3 scale = float3(size, size, size);
			float3 verts = PositionBuffer[unity_InstanceID];
			float4x4 scaleMat = float4x4(
				scale.x, 0, 0, 0,
				0, scale.y, 0, 0,
				0, 0, scale.z, 0,
				0, 0, 0, 1
				);
			v.vertex.xyz = mul(v.vertex.xyz, scaleMat);

			if (depth > 0.6)
			{
				v.vertex.z += depth * -1.5;
			}
			else {
				v.vertex.z += depth * 1.1;
			}
			
	#endif
		}

		void surf(Input IN, inout SurfaceOutputStandard o) {
			fixed4 res = tex2D(_MainTex, IN.uv_MainTex)*_Color;
			float3 col = float3(0.1, 0.1, 0.1);
	#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
			float3 verts = PositionBuffer[unity_InstanceID];

			float x = (fmod((float)unity_InstanceID, 128.0))/128.0;
			float y = ((float)unity_InstanceID / 128.0 *1.0)/128.0;
			float4 uv = float4(x, y, 0, 0);
			col = tex2D(_MainTex, uv);
	#endif
			o.Albedo = col;
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = res.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
