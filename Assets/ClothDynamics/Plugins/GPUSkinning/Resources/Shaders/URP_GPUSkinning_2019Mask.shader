Shader "ClothDynamics/URP_GPUSkinning_2019 Mask"
{
    Properties
    {
        [MainColor] _BaseColor("Albedo Color", Color) = (0.5,0.5,0.5,1)
        [MainTexture] _BaseMap("Albedo", 2D) = "white" {}
        _BumpMap("Normal Map", 2D) = "bump" {}
        _BumpScale("Scale", Range(1,2)) = 1.0
        _Smoothness("Roughness", Range(0.0, 1.0)) = 0.5
        [Gamma] _Metallic("Metallic", Range(0.0, 1.0)) = 0.0
        _MetallicGlossMap("MetallicTexture", 2D) = "white" {}
        _SpecColor("Specular", Color) = (0.2, 0.2, 0.2)

        [ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
        [ToggleOff] _EnvironmentReflections("Environment Reflections", Float) = 1.0
        _OcclusionMap("Occlusion", 2D) = "white" {}
        _OcclusionStrength("Strength", Range(0.0, 1.0)) = 1.0
        _EmissionColor("Color", Color) = (0,0,0)
        _EmissionMap("Emission", 2D) = "black" {}

        _MaskTex("MaskTex", 2D) = "white" {}
        _MaskThreshold("MaskThreshold", Range(-1,1)) = 0.001
    }


        SubShader
    {

       Tags{"RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" "IgnoreProjector" = "True"}
        LOD 300
        Cull Off //back

        HLSLINCLUDE
        #pragma target 3.0

        #if defined(SHADER_API_D3D11) || defined(SHADER_API_GLCORE) || defined(SHADER_API_GLES3) || defined(SHADER_API_METAL) || defined(SHADER_API_VULKAN) || defined(SHADER_API_PS4) || defined(SHADER_API_XBOXONE)
 
        #pragma multi_compile_local _ USE_BUFFERS
        #pragma multi_compile_local _ USE_BLEND_SHAPES
        #pragma multi_compile_local _ USE_NORMALS
        #pragma multi_compile_local _ USE_TANGENTS

        #include "BlendShapes_2019.cginc"

        struct SVertOut
        {
            float3 pos;
            float3 norm;
            float4 tang;
        };
        StructuredBuffer<SVertOut> _VertIn;

        void MySkinningFunction_float(uint vertexId, out float3 vertex, out float3 normal, out float4 tangent)
        {
            SVertOut vin = _VertIn[vertexId];
            vertex = vin.pos;
            normal = vin.norm;
            tangent = vin.tang;
#ifdef USE_BLEND_SHAPES
            VertexAnim(vertexId, vertex, normal, tangent);
#endif
        }

        void MySkinningFunction_float(uint vertexId, out float3 vertex, out float3 normal)
        {
            SVertOut vin = _VertIn[vertexId];
            vertex = vin.pos;
            normal = vin.norm;
#ifdef USE_BLEND_SHAPES
            VertexAnim(vertexId, vertex, normal);
#endif
        }

        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

        TEXTURE2D(_MaskTex);
        SAMPLER(sampler_MaskTex);

        float _MaskThreshold;

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }

        void Unity_Comparison_Less_float(float A, float B, out float Out)
        {
            Out = A < B ? 1 : 0;
        }

        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }


        float MaskFunc(float alpha, float4 ScreenPosition)
        {
            float4 _ScreenPosition_d32aa41e8f5347329937a1341266e354_Out_0 = ScreenPosition;

            float _Split_54118cb0aba04bc18324254f0175bc39_A_4 = _ScreenPosition_d32aa41e8f5347329937a1341266e354_Out_0[3];


            float4 _ScreenPosition_20e0900ed4c14eaab365529d2a6f0108_Out_0 = float4(ScreenPosition.xy / ScreenPosition.w, 0, 0);

            float4 _SampleTexture2D_25713a1e4f284034b2e4c4670f2841be_RGBA_0 = SAMPLE_TEXTURE2D(_MaskTex, sampler_MaskTex, _ScreenPosition_20e0900ed4c14eaab365529d2a6f0108_Out_0.xy);
            float _SampleTexture2D_25713a1e4f284034b2e4c4670f2841be_R_4 = _SampleTexture2D_25713a1e4f284034b2e4c4670f2841be_RGBA_0.r;
            float _SampleTexture2D_25713a1e4f284034b2e4c4670f2841be_G_5 = _SampleTexture2D_25713a1e4f284034b2e4c4670f2841be_RGBA_0.g;
            float _SampleTexture2D_25713a1e4f284034b2e4c4670f2841be_B_6 = _SampleTexture2D_25713a1e4f284034b2e4c4670f2841be_RGBA_0.b;
            float _SampleTexture2D_25713a1e4f284034b2e4c4670f2841be_A_7 = _SampleTexture2D_25713a1e4f284034b2e4c4670f2841be_RGBA_0.a;

            float _Property_628e1e20300744abab1a4d034fe70791_Out_0 = _MaskThreshold;

            float _Add_a23d7e3a48c54ed69c8991ee74ab6430_Out_2;
            Unity_Add_float(_SampleTexture2D_25713a1e4f284034b2e4c4670f2841be_B_6, _Property_628e1e20300744abab1a4d034fe70791_Out_0, _Add_a23d7e3a48c54ed69c8991ee74ab6430_Out_2);

            float _Comparison_bd0cd8949f024b169a330dd046c32afc_Out_2;
            Unity_Comparison_Less_float(_Split_54118cb0aba04bc18324254f0175bc39_A_4, _Add_a23d7e3a48c54ed69c8991ee74ab6430_Out_2, _Comparison_bd0cd8949f024b169a330dd046c32afc_Out_2);

            float _Branch_075044c5b79d4d6ba25e30db3b5823b0_Out_3;
            Unity_Branch_float(_Comparison_bd0cd8949f024b169a330dd046c32afc_Out_2, 1, _SampleTexture2D_25713a1e4f284034b2e4c4670f2841be_R_4, _Branch_075044c5b79d4d6ba25e30db3b5823b0_Out_3);

            float _Multiply_c4a88ad9b1a74e4fa063436499dece96_Out_2;
            Unity_Multiply_float(alpha, _Branch_075044c5b79d4d6ba25e30db3b5823b0_Out_3, _Multiply_c4a88ad9b1a74e4fa063436499dece96_Out_2);

            return _Multiply_c4a88ad9b1a74e4fa063436499dece96_Out_2;
            //surface.AlphaClipThreshold = _AlphaCutoff;
        }


        #endif

        ENDHLSL

        Pass
        {

            Name "ForwardLit"
            Tags{"LightMode" = "UniversalForward"}

            Name "Base"
            Blend One Zero
            ZWrite On
            ZTest LEqual
            Offset 0,0
            ColorMask RGBA

             HLSLPROGRAM
        // Required to compile gles 2.0 with standard SRP library
        // All shaders must be compiled with HLSLcc and currently only gles is not using HLSLcc by default
        #pragma prefer_hlslcc gles
        #pragma exclude_renderers d3d11_9x

        // -------------------------------------
        // Material Keywords
        #pragma shader_feature _ALPHATEST_ON
        #pragma shader_feature _ALPHAPREMULTIPLY_ON
        #pragma shader_feature _EMISSION
        #pragma shader_feature _METALLICSPECGLOSSMAP
        #pragma shader_feature _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A

        #pragma shader_feature _SPECULARHIGHLIGHTS_OFF
        #pragma shader_feature _ENVIRONMENTREFLECTIONS_OFF
        #pragma shader_feature _SPECULAR_SETUP
        #pragma shader_feature _RECEIVE_SHADOWS_OFF

        // -------------------------------------
        // Universal Pipeline keywords
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
        #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
        #pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile _ _SHADOWS_SOFT
        #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE

        // -------------------------------------
        // Unity defined keywords
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile_fog

        //--------------------------------------
        // GPU Instancing
        #pragma multi_compile_instancing

        #pragma vertex vert
        #pragma fragment frag

        #include "Packages/com.unity.render-pipelines.universal/Shaders/LitInput.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Shaders/LitForwardPass.hlsl"


        struct mySurfaceData
        {
            half3 albedo;
            half3 specular;
            half  metallic;
            half  roughness;
            half3 normalTS;
            half3 emission;
            half  occlusion;
            half  alpha;
        };


        struct myInputData
        {
            float3  positionWS;
            half3   normalWS;
            half3   viewDirectionWS;
            float4  shadowCoord;
            half    fogCoord;
            half3   vertexLighting;
            half3   bakedGI;
        };

        struct myAttributes
        {
            float4 positionOS   : POSITION;
            float3 normalOS     : NORMAL;
            float4 tangentOS    : TANGENT;
            float2 texcoord     : TEXCOORD0;
            float2 lightmapUV   : TEXCOORD1;
            UNITY_VERTEX_INPUT_INSTANCE_ID
            uint vertexID : SV_VERTEXID;
        };

        struct myVaryings
        {
            float2 uv                       : TEXCOORD0;
            DECLARE_LIGHTMAP_OR_SH(lightmapUV, vertexSH, 1);

        #ifdef _ADDITIONAL_LIGHTS
            float3 positionWS               : TEXCOORD2;
        #endif


            float4 normalWS                 : TEXCOORD3;    // xyz: normal, w: viewDir.x
            float4 tangentWS                : TEXCOORD4;    // xyz: tangent, w: viewDir.y
            float4 bitangentWS              : TEXCOORD5;    // xyz: bitangent, w: viewDir.z
            half4 fogFactorAndVertexLight   : TEXCOORD6; // x: fogFactor, yzw: vertex light

        #ifdef _MAIN_LIGHT_SHADOWS
            float4 shadowCoord              : TEXCOORD7;
        #endif
        float3 viewDirWS                : TEXCOORD8;
        float4 ScreenPosition           : TEXCOORD9;
            float4 positionCS               : SV_POSITION;
            UNITY_VERTEX_INPUT_INSTANCE_ID
            UNITY_VERTEX_OUTPUT_STEREO
        };



        myVaryings vert(myAttributes input)
        {
            #if defined(SHADER_API_D3D11) || defined(SHADER_API_GLCORE) || defined(SHADER_API_GLES3) || defined(SHADER_API_METAL) || defined(SHADER_API_VULKAN) || defined(SHADER_API_PS4) || defined(SHADER_API_XBOXONE)
                #ifdef USE_BUFFERS
                MySkinningFunction_float(input.vertexID, input.positionOS.xyz, input.normalOS.xyz, input.tangentOS);
                #endif
            #endif

            myVaryings output = (myVaryings)0;

            UNITY_SETUP_INSTANCE_ID(input);
            UNITY_TRANSFER_INSTANCE_ID(input, output);
            UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);


            VertexPositionInputs vertexInput = GetVertexPositionInputs(input.positionOS.xyz);
            VertexNormalInputs normalInput = GetVertexNormalInputs(input.normalOS, input.tangentOS);
            half3 viewDirWS = GetCameraPositionWS() - vertexInput.positionWS;
            half3 vertexLight = VertexLighting(vertexInput.positionWS, normalInput.normalWS);
            half fogFactor = ComputeFogFactor(vertexInput.positionCS.z);

            output.uv = TRANSFORM_TEX(input.texcoord, _BaseMap);


            output.normalWS = half4(normalInput.normalWS, viewDirWS.x);
            output.tangentWS = half4(normalInput.tangentWS, viewDirWS.y);
            output.bitangentWS = half4(normalInput.bitangentWS, viewDirWS.z);
            output.viewDirWS = viewDirWS;

            OUTPUT_LIGHTMAP_UV(input.lightmapUV, unity_LightmapST, output.lightmapUV);
            OUTPUT_SH(output.normalWS.xyz, output.vertexSH);
            output.fogFactorAndVertexLight = half4(fogFactor, vertexLight);
#ifdef _ADDITIONAL_LIGHTS
                output.positionWS = vertexInput.positionWS;
#endif

#ifdef _MAIN_LIGHT_SHADOWS
                output.shadowCoord = GetShadowCoord(vertexInput);
#endif
            output.positionCS = vertexInput.positionCS;

            output.ScreenPosition = ComputeScreenPos(vertexInput.positionCS);

                return output;
            }

            void myInitializeInputData(myVaryings input, half3 normalTS, out myInputData inputData)
            {
                inputData = (myInputData)0;

                #ifdef _ADDITIONAL_LIGHTS
                    inputData.positionWS = input.positionWS;
                #endif


                    half3 viewDirWS = half3(input.normalWS.w, input.tangentWS.w, input.bitangentWS.w);
                    inputData.normalWS = TransformTangentToWorld(normalTS,
                    half3x3(input.tangentWS.xyz, input.bitangentWS.xyz, input.normalWS.xyz));

                    inputData.normalWS = NormalizeNormalPerPixel(inputData.normalWS);
                    viewDirWS = SafeNormalize(viewDirWS);

                    inputData.viewDirectionWS = viewDirWS;
                #if defined(_MAIN_LIGHT_SHADOWS) && !defined(_RECEIVE_SHADOWS_OFF)
                    inputData.shadowCoord = input.shadowCoord;
                #else
                    inputData.shadowCoord = float4(0, 0, 0, 0);
                #endif
                    inputData.fogCoord = input.fogFactorAndVertexLight.x;
                    inputData.vertexLighting = input.fogFactorAndVertexLight.yzw;
                    inputData.bakedGI = SAMPLE_GI(input.lightmapUV, input.vertexSH, inputData.normalWS);
            }


            half3 mySampleNormal(float2 uv, TEXTURE2D_PARAM(bumpMap, sampler_bumpMap), half scale = 1.0h)
            {
                half4 n = SAMPLE_TEXTURE2D(bumpMap, sampler_bumpMap, uv);
                return UnpackNormalScale(n, scale);
            }

            half mySampleOcclusion(float2 uv)
            {
            #if defined(SHADER_API_GLES)
                return SAMPLE_TEXTURE2D(_OcclusionMap, sampler_OcclusionMap, uv).g;
            #else
                half occ = SAMPLE_TEXTURE2D(_OcclusionMap, sampler_OcclusionMap, uv).g;
                return LerpWhiteTo(occ, _OcclusionStrength);
            #endif
                return 1.0;

            }

            half3 mySampleEmission(float2 uv, half3 emissionColor, TEXTURE2D_PARAM(emissionMap, sampler_emissionMap))
            {
                return SAMPLE_TEXTURE2D(emissionMap, sampler_emissionMap, uv).rgb * emissionColor;
            }

            half4 mySampleMetallicSpecGloss(float2 uv , half metallicScale , half roughnessScale)
            {
                half4 specGloss;
                specGloss = SAMPLE_TEXTURE2D(_MetallicGlossMap, sampler_MetallicGlossMap, uv);
                specGloss.x *= metallicScale;
                specGloss.y *= roughnessScale;
                return specGloss;
            }

            void myInitializeStandardLitSurfaceData(float2 uv, out mySurfaceData outSurfaceData)
            {
                half4 albedoAlpha = SampleAlbedoAlpha(uv, TEXTURE2D_ARGS(_BaseMap, sampler_BaseMap));
                outSurfaceData.alpha = Alpha(albedoAlpha.a, _BaseColor, _Cutoff);

                half2 metallicRoughness = mySampleMetallicSpecGloss(uv , _Metallic , _Smoothness).xy;
                outSurfaceData.albedo = albedoAlpha.rgb * _BaseColor.rgb;

                outSurfaceData.metallic = metallicRoughness.x;
                outSurfaceData.specular = half3(0.0h, 0.0h, 0.0h);

                outSurfaceData.roughness = metallicRoughness.y;
                outSurfaceData.normalTS = mySampleNormal(uv, TEXTURE2D_ARGS(_BumpMap, sampler_BumpMap), _BumpScale);
                outSurfaceData.occlusion = mySampleOcclusion(uv);
                outSurfaceData.emission = mySampleEmission(uv, _EmissionColor.rgb, TEXTURE2D_ARGS(_EmissionMap, sampler_EmissionMap));
            }

            half4 frag(myVaryings input) : SV_Target
            {
                UNITY_SETUP_INSTANCE_ID(input);
                UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input);

                mySurfaceData surfaceData;
                myInitializeStandardLitSurfaceData(input.uv, surfaceData);

                float AlphaClipThreshold = 0.5;

                myInputData InputData;
                myInitializeInputData(input, surfaceData.normalTS, InputData);

                surfaceData.alpha = MaskFunc(surfaceData.alpha, input.ScreenPosition);

                half4 color = UniversalFragmentPBR(InputData, surfaceData.albedo, surfaceData.metallic, surfaceData.specular,
                surfaceData.roughness, surfaceData.occlusion, surfaceData.emission, surfaceData.alpha);
                color.rgb = MixFog(color.rgb, InputData.fogCoord);

        //#if _AlphaClip
                clip(surfaceData.alpha - AlphaClipThreshold);
        //#endif

        #ifdef LOD_FADE_CROSSFADE
                LODDitheringTransition(input.clipPos.xyz, unity_LODFade.x);
        #endif
                return color;

            }

            ENDHLSL
        }


        Pass
        {

            Name "ShadowCaster"
            Tags{"LightMode" = "ShadowCaster"}

            ZWrite On
            ZTest LEqual

            HLSLPROGRAM

            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x


                //--------------------------------------
                // GPU Instancing
                #pragma multi_compile_instancing

                #pragma vertex ShadowPassVertex
                #pragma fragment ShadowPassFragment


                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"


                struct GraphVertexInput
                {
                    float4 vertex : POSITION;
                    float3 normal : NORMAL;
                    UNITY_VERTEX_INPUT_INSTANCE_ID
                    uint vertexID : SV_VERTEXID;
                };


                struct VertexOutput
                {
                    float4 clipPos      : SV_POSITION;
                    float4 ScreenPosition : TEXCOORD0;
                    UNITY_VERTEX_INPUT_INSTANCE_ID
                    UNITY_VERTEX_OUTPUT_STEREO
                };

                float3 _LightDirection;

                VertexOutput ShadowPassVertex(GraphVertexInput v)
                {
#if defined(SHADER_API_D3D11) || defined(SHADER_API_GLCORE) || defined(SHADER_API_GLES3) || defined(SHADER_API_METAL) || defined(SHADER_API_VULKAN) || defined(SHADER_API_PS4) || defined(SHADER_API_XBOXONE)
#ifdef USE_BUFFERS
                    MySkinningFunction_float(v.vertexID, v.vertex.xyz, v.normal.xyz);
#endif
#endif
                    VertexOutput o;
                    UNITY_SETUP_INSTANCE_ID(v);
                    UNITY_TRANSFER_INSTANCE_ID(v, o);
                    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                    float3 defaultVertexValue = v.vertex.xyz;
                    float3 vertexValue = defaultVertexValue;
                    v.vertex.xyz = vertexValue;

                    v.normal = /*ase_vert_out:Vertex Normal;Float3;3;-1;_Normal*/ v.normal /*end*/;

                    float3 positionWS = TransformObjectToWorld(v.vertex.xyz);
                    float3 normalWS = TransformObjectToWorldDir(v.normal);

                    float invNdotL = 1.0 - saturate(dot(_LightDirection, normalWS));
                    float scale = invNdotL * _ShadowBias.y;


                    positionWS = _LightDirection * _ShadowBias.xxx + positionWS;
                    positionWS = normalWS * scale.xxx + positionWS;
                    float4 clipPos = TransformWorldToHClip(positionWS);
                    o.ScreenPosition = ComputeScreenPos(clipPos);

                #if UNITY_REVERSED_Z
                    clipPos.z = min(clipPos.z, clipPos.w * UNITY_NEAR_CLIP_VALUE);
                #else
                    clipPos.z = max(clipPos.z, clipPos.w * UNITY_NEAR_CLIP_VALUE);
                #endif
                    o.clipPos = clipPos;


                    return o;
                }

                half4 ShadowPassFragment(VertexOutput IN /*ase_frag_input*/) : SV_TARGET
                {
                    UNITY_SETUP_INSTANCE_ID(IN);
                    UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);



                    float Alpha = 1;
                    Alpha = MaskFunc(Alpha, IN.ScreenPosition);

                    float AlphaClipThreshold = 0.5;

            // #if _AlphaClip
                    clip(Alpha - AlphaClipThreshold);
           // #endif

            #ifdef LOD_FADE_CROSSFADE
                    LODDitheringTransition(IN.clipPos.xyz, unity_LODFade.x);
            #endif
                    return 0;
                }

                ENDHLSL
            }


            Pass
            {

                Name "DepthOnly"
                Tags{"LightMode" = "DepthOnly"}

                ZWrite On
                ColorMask 0

                HLSLPROGRAM
                #pragma prefer_hlslcc gles
                #pragma exclude_renderers d3d11_9x

                    //--------------------------------------
                    // GPU Instancing
                    #pragma multi_compile_instancing

                    #pragma vertex vert
                    #pragma fragment frag


                    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
                    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
                    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

                    struct GraphVertexInput
                    {
                        float4 vertex : POSITION;
                        float3 normal : NORMAL;
                        UNITY_VERTEX_INPUT_INSTANCE_ID
                        uint vertexID : SV_VERTEXID;
                    };

                    struct VertexOutput
                    {
                        float4 clipPos      : SV_POSITION;
                        float4 ScreenPosition : TEXCOORD0;
                        UNITY_VERTEX_INPUT_INSTANCE_ID
                        UNITY_VERTEX_OUTPUT_STEREO
                    };


                    VertexOutput vert(GraphVertexInput v)
                    {
#if defined(SHADER_API_D3D11) || defined(SHADER_API_GLCORE) || defined(SHADER_API_GLES3) || defined(SHADER_API_METAL) || defined(SHADER_API_VULKAN) || defined(SHADER_API_PS4) || defined(SHADER_API_XBOXONE)
#ifdef USE_BUFFERS
                        MySkinningFunction_float(v.vertexID, v.vertex.xyz, v.normal.xyz);
#endif
#endif

                        VertexOutput o = (VertexOutput)0;
                        UNITY_SETUP_INSTANCE_ID(v);
                        UNITY_TRANSFER_INSTANCE_ID(v, o);
                        UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);


                        float3 defaultVertexValue = v.vertex.xyz;

                        float3 vertexValue = defaultVertexValue;
                        v.vertex.xyz = vertexValue;

                        v.normal = v.normal;
                        o.clipPos = TransformObjectToHClip(v.vertex.xyz);
                        o.ScreenPosition = ComputeScreenPos(o.clipPos);

                        return o;
                    }

                    half4 frag(VertexOutput IN /*ase_frag_input*/) : SV_TARGET
                    {
                        UNITY_SETUP_INSTANCE_ID(IN);

                        float Alpha = 1;
                        Alpha = MaskFunc(Alpha, IN.ScreenPosition);

                        float AlphaClipThreshold = 0.5;

                 //#if _AlphaClip
                        clip(-1 - AlphaClipThreshold);
                //#endif
                #ifdef LOD_FADE_CROSSFADE
                        LODDitheringTransition(IN.clipPos.xyz, unity_LODFade.x);
                #endif
                        return 0;
                    }
                    ENDHLSL
                }


                Pass
                {

                    Name "Meta"
                    Tags{"LightMode" = "Meta"}

                    Cull Off

                    HLSLPROGRAM
                    #pragma prefer_hlslcc gles
                    #pragma exclude_renderers d3d11_9x

                    #pragma vertex vert
                    #pragma fragment frag


                    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
                    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
                    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

                    #pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
                    #pragma shader_feature EDITOR_VISUALIZATION


                    struct GraphVertexInput
                    {
                        float4 vertex : POSITION;
                        float3 normal : NORMAL;
                        float4 texcoord1 : TEXCOORD1;
                        float4 texcoord2 : TEXCOORD2;
                        UNITY_VERTEX_INPUT_INSTANCE_ID
                        uint vertexID : SV_VERTEXID;
                    };

                    struct VertexOutput
                    {
                        float4 clipPos      : SV_POSITION;
                        float4 ScreenPosition      : TEXCOORD0;
                        UNITY_VERTEX_INPUT_INSTANCE_ID
                        UNITY_VERTEX_OUTPUT_STEREO
                    };

                    VertexOutput vert(GraphVertexInput v)
                    {
#if defined(SHADER_API_D3D11) || defined(SHADER_API_GLCORE) || defined(SHADER_API_GLES3) || defined(SHADER_API_METAL) || defined(SHADER_API_VULKAN) || defined(SHADER_API_PS4) || defined(SHADER_API_XBOXONE)
#ifdef USE_BUFFERS
                        MySkinningFunction_float(v.vertexID, v.vertex.xyz, v.normal.xyz);
#endif
#endif
                        VertexOutput o = (VertexOutput)0;
                        UNITY_SETUP_INSTANCE_ID(v);
                        UNITY_TRANSFER_INSTANCE_ID(v, o);
                        UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

                        float3 defaultVertexValue = v.vertex.xyz;
                        float3 vertexValue = defaultVertexValue;
                        v.vertex.xyz = vertexValue;
                        v.normal = v.normal;
                        o.clipPos = MetaVertexPosition(v.vertex, v.texcoord1.xy, v.texcoord1.xy, unity_LightmapST, unity_DynamicLightmapST);
                        o.ScreenPosition = ComputeScreenPos(o.clipPos);
                        return o;
                    }

                    half4 frag(VertexOutput IN) : SV_TARGET
                    {
                        UNITY_SETUP_INSTANCE_ID(IN);

                        float3 Albedo = float3(0.5, 0.5, 0.5);
                        float3 Emission = 0;
                        float Alpha = 1;
                        Alpha = MaskFunc(Alpha, IN.ScreenPosition);

                        float AlphaClipThreshold = 0.5;

                 //#if _AlphaClip
                        clip(Alpha - AlphaClipThreshold);
                //#endif
                        MetaInput metaInput = (MetaInput)0;
                        metaInput.Albedo = Albedo;
                        metaInput.Emission = Emission;
                        return MetaFragment(metaInput);
                    }
                    ENDHLSL
                }

    }
        FallBack "Hidden/InternalErrorShader"
}
