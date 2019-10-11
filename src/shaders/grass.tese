#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(quads, equal_spacing, ccw) in;

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// TODO: Declare tessellation evaluation shader inputs and outputs
layout(location = 0) in vec4[] v0;
layout(location = 1) in vec4[] v1;
layout(location = 2) in vec4[] v2;
layout(location = 3) in vec4[] up;

layout(location = 0) out vec2 uvs;

void main() {
    float u = gl_TessCoord.x;
    float v = gl_TessCoord.y;

	// TODO: Use u and v to parameterize along the grass blade and output positions for each vertex of the grass blade
	vec3 pos0 = v0[0].xyz;
	vec3 pos1 = v1[0].xyz;
	vec3 pos2 = v2[0].xyz;

	float orientation = v0[0].w;
	vec3 t1 = normalize(vec3(cos(orientation), 0, sin(orientation)));

	vec3 a = pos0 + v * (pos1 - pos0);
	vec3 b = pos1 + v * (pos2 - pos1);
	vec3 c = a + v * (b - a);
	vec3 c0 = c - v2[0].w * t1;
	vec3 c1 = c + v2[0].w * t1;
	vec3 t0 = normalize(b - a);
	vec3 n = normalize(cross(t0, t1));
	float t = u - (u * v * v);
	gl_Position = camera.proj * camera.view * vec4((1 - t) * c0 + t * c1, 1);
	uvs = vec2(u, v);
}