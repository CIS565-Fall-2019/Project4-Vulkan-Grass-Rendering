#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(quads, equal_spacing, ccw) in;

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// Tessellation evaluation shader inputs and outputs

layout(location = 0) in vec4 iv0[];
layout(location = 1) in vec4 iv1[];
layout(location = 2) in vec4 iv2[];
layout(location = 3) in vec4 iup[];

layout(location = 0) out vec3 pos;
layout(location = 1) out vec3 nor;
layout(location = 2) out float h;

void main() {
    float u = gl_TessCoord.x;
    float v = gl_TessCoord.y;

	// Use u and v to parameterize along the grass blade and output positions for each vertex of the grass blade
	
	// Compute Normal
	vec3 lerpA = iv0[0].xyz + v * (iv1[0] - iv0[0]).xyz;
	vec3 lerpB = iv1[0].xyz + v * (iv2[0] - iv1[0]).xyz;
	vec3 lerpC = lerpA + v * (lerpB - lerpA);

	vec3 bitan = vec3(sin(iv0[0].w), 0.0, cos(iv0[0].w)); // vector along width of blade
	vec3 tan = normalize(lerpB - lerpA);
	nor = normalize(cross(tan, bitan));

	// Compute Position
	vec3 lerp1 = lerpC - iv2[0].w * bitan; // iv2.w is width of blade
	vec3 lerp2 = lerpC + iv2[0].w * bitan;

	float thresh = 0.2;
	float t = 0.5 + (u - 0.5) * (1 - (max(v - thresh, 0))/(1 - thresh)); // triangle tip shape

	pos = (1 - t) * lerp1 + t * lerp2;

	h = v;

	gl_Position = camera.proj * camera.view * vec4(pos, 1.0f);
}
