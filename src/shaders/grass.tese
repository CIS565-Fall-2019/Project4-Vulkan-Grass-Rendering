#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(quads, equal_spacing, ccw) in;

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
	vec3 pos;
} camera;

// TODO: Declare tessellation evaluation shader inputs and outputs
layout(location = 0) patch in vec4 se_v0;
layout(location = 1) patch in vec4 se_v1;
layout(location = 2) patch in vec4 se_v2;
layout(location = 3) patch in vec4 se_up;

layout(location = 0) out vec3 fs_nor;

void main() {
    float u = gl_TessCoord.x;
    float v = gl_TessCoord.y;

	// TODO: Use u and v to parameterize along the grass blade and 
	//output positions for each vertex of the grass blade
	//For quads, we use standard bilinear interpolation to determine the position
	vec3 v0 = gl_in[0].gl_Position.xyz;
	//vec3 v0 = se_v0.xyz;
	vec3 v1 = se_v1.xyz;
	vec3 v2 = se_v2.xyz;

	//De-caltesjaul
	vec3 a = v0 + v * (v1 - v0);
	vec3 b = v1 + v * (v2 - v1);
	vec3 c = a + v * (b - a);
	
	float ori = se_v0.w;//orientation
	float wid = se_v2.w;//width

	float dirx = cos(ori);
	float dirz = sin(ori);
	vec3 t1 = vec3(dirx, 0, dirz);
	vec3 c0 = c - wid * t1;
	vec3 c1 = c + wid * t1;

	vec3 t0 = normalize(b-a);
	fs_nor = normalize(cross(t0, t1));
	
	//float t = u + 0.5f * v - u * v;//tri
	float t = u - u * v; 
	//float thres = 0.1;
	//float t = 0.5 + (u - 0.5) * (1.0 - max(u - thres, 0.0) / (1.0 - thres));
	//float t = u;//quad
	vec3 p = (1.0 - t) * c0 + t * c1;
	
	gl_Position = camera.proj * camera.view * vec4(p,1);
}
