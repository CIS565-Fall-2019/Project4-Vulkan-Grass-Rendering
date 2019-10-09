#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// TODO: Declare fragment shader inputs
layout(location = 0) in vec4 position;
layout(location = 1) in vec3 normal;
layout(location = 2) in vec2 uv;


layout(location = 0) out vec4 outColor;

void main() {
    // TODO: Compute fragment color
	//bright green for tip
	vec3 bot = vec3(0.1, 0.2, 0);
	vec3 tip = vec3(0.3, 0.6, 0);
	//interpolate color
	vec3 col = mix(bot, tip, uv.y);

	//add light effect -- helped by Yan Dong
	vec3 light = normalize(vec3(-1, 1, -1));
	float lambert = dot(normal, light);
	//too dark
	//lambert = clamp(lambert, 0, 1);
	//boost up a little bit by adding an ambient
	lambert = clamp(lambert, 0 ,1) + 0.6;


	//without light effect
	//outColor = vec4(col, 1.0);
	//with light effect
	outColor = vec4(lambert * col, 1.0);
}
