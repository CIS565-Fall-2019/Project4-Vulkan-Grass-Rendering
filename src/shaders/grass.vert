
#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(set = 1, binding = 0) uniform ModelBufferObject {
    mat4 model;
};

// TODO: Declare vertex shader inputs and outputs, used Vulkan-Tutorial.com

// Understanding from CreateGrassPipeline(): Inputs are from Blades (.getAttributeDescriptions())
layout(location = 0) in vec4 v0;
layout(location = 1) in vec4 v1;
layout(location = 2) in vec4 v2;
layout(location = 3) in vec4 up;

// Outputs are passed into grass.tesc - want the same as the inputs!
layout(location = 0) out vec4 oV0;
layout(location = 1) out vec4 oV1;
layout(location = 2) out vec4 oV2;
layout(location = 3) out vec4 oUp;

out gl_PerVertex {
    vec4 gl_Position;
};

void main() {
	// TODO: Write gl_Position and any other shader outputs
	gl_Position = vec4(v0.xyz, 1.f); // since v0.w = orientation

	// Pass the same values until reaching grass.tese
	oV0 = v0;
	oV1 = v1;
	oV2 = v2;
	oUp = up;
}
