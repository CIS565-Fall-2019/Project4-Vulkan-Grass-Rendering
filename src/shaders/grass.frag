#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// TODO: Declare fragment shader inputs
layout(location = 0) in vec4 pos;
layout(location = 1) in vec4 nor;
layout(location = 2) in vec2 uv;

layout(location = 0) out vec4 outColor;

void main() {
    // TODO: Compute fragment color
	float cosd = max(0.2, dot(nor.xyz, normalize(vec3(1,1,1))) );
    vec4 green = vec4(0.5, 1.0, 0.4, 1.0) * cosd;

	outColor = mix(0.8* green, green, uv.y*5 );


}
