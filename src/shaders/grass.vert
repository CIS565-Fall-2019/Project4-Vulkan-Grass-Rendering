
#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(set = 1, binding = 0) uniform ModelBufferObject {
    mat4 model;
};

// TODO: Declare vertex shader inputs and outputs
//according to blades
layout(location = 0) in vec4 v0; //w is direction
layout(location = 1) in vec4 v1; //w is height
layout(location = 2) in vec4 v2; //w is width
layout(location = 3) in vec4 up; //w is stiffness

layout (location = 0) out vec4 tesc_v1;
layout (location = 1) out vec4 tesc_v2;
layout (location = 2) out vec4 tesc_up;
layout (location = 3) out vec4 tesc_front;
layout (location = 4) out vec4 tesc_widthdir;

out gl_PerVertex {
    vec4 gl_Position;
};

void main() {
	// TODO: Write gl_Position and any other shader outputs

	float angle = v0.w;
	float height = v1.w;
	float width = v2.w;
	float stiffness = up.w;

	//applying the object transformation to transform to world space
	tesc_v1 = model * vec4(v1.xyz, 1.0);
	tesc_v1.w = height;

	tesc_v2 = model * vec4(v2.xyz, 1.0);
	tesc_v2.w = width;

	//global up(for plane), no need to transform
	tesc_up = vec4(normalize(up.xyz), 0.0);
	//no need to store stiffness -- only used in compute shader

	//compute the front direction of blades by the angle stores in v0
	vec3 front_dir = vec3(cos(angle), 0.0, sin(angle));
	tesc_front = vec4(normalize(front_dir),0.0);

	//compute the widthdir of blade by cross up and front
	vec4 width_dir = vec4(normalize(cross(tesc_up.xyz,front_dir)), 0.0);
	tesc_widthdir = width_dir;

	//compute the pos of blade in world space
	gl_Position = model * vec4(v0.xyz, 1.0);
	
}
