#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// Declare fragment shader inputs
layout (location = 0) in vec3 N;
layout (location = 1) in vec2 uv;

layout(location = 0) out vec4 outColor;

void main() {
    // Compute fragment color
    vec3 tipColor = vec3(0.3, 0.5, 0.1);
    vec3 baseColor = vec3(0.2, 0.2, 0.1);
    vec3 mixColor = mix(baseColor, tipColor, uv.y);
    vec3 lightDir = normalize(vec3(1.0, 1.0, 1.0));
    vec3 lambert = mixColor * (clamp(dot(lightDir, N), 0.2, 0.8) + 0.35);

    outColor = vec4(lambert, 1);
}
