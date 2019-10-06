#version 450
#extension GL_ARB_separate_shader_objects : enable


layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// TODO: Declare fragment shader inputs
//layout(location = 0) in vec4 in_pos;
layout(location = 0) in vec4 in_nor;
layout(location = 1) in vec4 in_lightDir;
layout(location = 2) in vec2 in_uv;

layout(location = 0) out vec4 outColor;

void main() {
    // TODO: Compute fragment color
	float over255 = 1.0 / 255.0;

	//vec3 green1 = vec3(52.0, 102.0, 0.0) * over255;
	vec3 green1 = vec3(52.0, 102.0, 0.0) * over255;
	vec3 green2 = vec3(76.0, 153.0, 0.0) * over255;
	//vec3 green3 = vec3(102.0, 204.0, 0.0) * over255;
	vec3 green3 = vec3(200.0, 203.0, 111.0) * over255;

	vec3 color = mix(mix(green1, green2, in_uv.y), mix(green2, green3, in_uv.y), in_uv.y);


	// lambertian shading
	//float diffuse = clamp(abs(dot(normalize(in_nor), normalize(in_lightDir))), 0.0, 1.0);
	//float diffuse = clamp(dot(normalize(in_nor), normalize(in_lightDir)), 0.0, 1.0);
	//diffuse = clamp(dot(normalize(in_nor), normalize(in_lightDir)), 0.0, 1.0);
	//float ambient = 0.2;
	//vec3 shadedColor = vec3(color * (diffuse + ambient));

    outColor = vec4(color, 1.0);
}
