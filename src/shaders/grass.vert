
#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(set = 1, binding = 0) uniform ModelBufferObject {
    mat4 model;
};

// Vertex shader inputs and outputs

layout(location = 0) in vec4 iv0;
layout(location = 1) in vec4 iv1;
layout(location = 2) in vec4 iv2;
layout(location = 3) in vec4 iup;

layout(location = 0) out vec4 ov0;
layout(location = 1) out vec4 ov1;
layout(location = 2) out vec4 ov2;
layout(location = 3) out vec4 oup;

out gl_PerVertex {
    vec4 gl_Position;
};

void main() {
	// TODO: Write gl_Position and any other shader outputs
	ov0 = iv0;
	ov1 = iv1;
	ov2 = iv2;
	oup = iup;
	
	vec4 outPos = iv0;
	outPos.w = 1.0f;
	gl_Position = outPos;
}
