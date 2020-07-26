//
//  Shader.metal
//  MetalTest7
//
//  Created by 福山帆士 on 2020/07/26.
//  Copyright © 2020 福山帆士. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct ColorInOut
{
    float4 position [[position]];
};

vertex ColorInOut vertexShader(const device float4 *positions [ [buffer(0) ]],
                               uint            vid            [[ vertex_id] ])
{
    ColorInOut out;
    out.position = positions[vid];
    return out;
}

fragment float4 fragmentShader(ColorInOut in [[ stage_in]])
{
    return float4(1, 0, 0, 1);
}


