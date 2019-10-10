#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(quads, equal_spacing, ccw) in;

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// TODO: Declare tessellation evaluation shader inputs and outputs

layout(location = 0) in vec4 inV0[];
layout(location = 1) in vec4 inV1[];
layout(location = 2) in vec4 inV2[];

layout(location = 0) out vec4 outPos;
layout(location = 1) out vec3 outNormal;
layout(location = 2) out vec2 outUV;


void main() {
    float u = gl_TessCoord.x;
    float v = gl_TessCoord.y;

	// TODO: Use u and v to parameterize along the grass blade and output positions for each vertex of the grass blade
	outUV = vec2(u,v);
	vec4 v0 = inV0[0];
	vec4 v1 = inV1[0];
	vec4 v2 = inV2[0];

	vec3 t1 = vec3(sin(v0.w), 0.0, cos(v0.w));
	vec3 a = v0.xyz + v * (v1.xyz - v0.xyz);
	vec3 b = v1.xyz + v * (v2.xyz - v1.xyz);
	vec3 c = a + v * (b - a);
	vec3 c0 = c - v2.w * t1;
	vec3 c1 = c + v2.w * t1;

	vec3 t0 = normalize(b - a);
	outNormal = normalize(cross(t0, t1));
	float t = u + 0.5 * v - u * v;
	vec3 temp = (1.f - t) * c0 + t * c1;
	outPos = camera.proj * camera.view * vec4(temp, 1.0);
	gl_Position = outPos;
}
