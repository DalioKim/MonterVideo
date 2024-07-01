//
//  Shaders.metal
//  MonterVideo
//
//  Created by 김동현 on 2024/06/30.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn{
    float3 position [[ attribute(0) ]];
    float4 color [[ attribute(1) ]];
};

struct RasterizerData{
    float4 position [[ position ]];
    float4 color;
};

struct ModelConstants{
    float4x4 modelMatrix;
};

vertex RasterizerData basic_vertex_function(const VertexIn vIn [[ stage_in ]],
                                            constant ModelConstants &modelConstants [[ buffer(1) ]]){
    RasterizerData rd;
    rd.position = float4(vIn.position, 1);
    rd.position.x += modelConstants.modelMatrix[3][0];
    rd.color = vIn.color;
    
    return rd;
}

fragment half4 basic_fragment_function(RasterizerData rd [[ stage_in ]]){
    float4 color = rd.color;
    
    return half4(color.r, color.g, color.b, color.a);
}
