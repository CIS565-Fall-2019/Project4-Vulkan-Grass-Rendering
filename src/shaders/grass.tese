#version 450
#extension GL_ARB_separate_shader_objects : enable

/*
	We use the tessellation evaluation shader to compute the 
	actual shape of the blades using the formula provided in the paper

*/
layout(quads, equal_spacing, ccw) in;

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// TODO: Declare tessellation evaluation shader inputs and outputs
//inputs are from tessellation.control shader
layout(location = 0) patch in vec4 tese_v1;
layout(location = 1) patch in vec4 tese_v2;
layout(location = 2) patch in vec4 tese_up;
layout(location = 3) patch in vec4 tese_front;
layout (location = 4) patch in vec4 tese_widthdir;
//layout(location = 0) in vec4 tese_v1;
//layout(location = 1) in vec4 tese_v2;
//layout(location = 2) in vec4 tese_up;
//layout(location = 3) in vec4 tese_forward;

//output to fragment shader for shading
layout(location = 0) out vec4 position;
layout(location = 1) out vec3 normal;
layout(location = 2) out vec2 uv;

void main() {
    float u = gl_TessCoord.x;
    float v = gl_TessCoord.y;
	
	//grab the scalar from tese_v1 and tese_v2
	float height = tese_v1.w;
	float width = tese_v2.w;

	// TODO: Use u and v to parameterize along the grass blade and output positions for each vertex of the grass blade
	//get 3 control points
	vec3 v0 = gl_in[0].gl_Position.xyz;
	vec3 v1 = tese_v1.xyz;
	vec3 v2 = tese_v2.xyz;

	vec3 a = v0 + v * (v1 - v0);
	vec3 b = v1 + v * (v2 - v1);
	vec3 c = a + v * (b - a);
	//calculate tangent
	vec3 t0 = normalize(b - a);
	//vec3 width_dir = cross(t0, tese_forward.xyz);
	vec3 t1 = vec3(tese_widthdir.xyz);
	vec3 width_offset = t1 * width * 0.5;
	vec3 c0 = c - width_offset;
	vec3 c1 = c + width_offset;
	//compute the normal of blade
	normal = normalize(cross(t0, t1));

	//interpolate on the width dir of blade to get basic shape
	//triangle shape
	//float t = u + 0.5 * v - u * v;
	//quadratic
	//float t = u - u * v * v;
	//quad
	//float t = u;
	//triangle tip
	float threshold = 0.5;
	float t = 0.5 + (u - 0.5) * (1 - max(v - threshold, 0) / (1 - threshold));

	position.xyz = (1.0 - t) * c0 + t * c1;
	//transform from world space to screen space
	position = camera.proj * camera.view * vec4(position.xyz, 1.0);

	//pass the uv to frag to interpolate color
	uv = vec2(u,v);

	gl_Position = position;
}
