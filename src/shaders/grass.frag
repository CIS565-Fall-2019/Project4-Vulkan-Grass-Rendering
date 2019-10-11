#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// TODO: Declare fragment shader inputs
// Understanding the pipeline: Inputs are from grass.tese
layout(location = 0) in vec4 pos;
layout(location = 1) in vec4 norm;
layout(location = 2) in float hInterp; // horizontal interpolation value
layout(location = 3) in float vInterp; // vertical

// Fragment shader output
layout(location = 0) out vec4 outColor;

void main() {
    // TODO: Compute fragment color

	// Side of blade should range from super - dark, other side dark - green, whole thing mix-yellow-red
	
	// Colors to be used
	vec4 darker = vec4(5.f / 255.f, 45.f / 255.f, 0.f / 255.f, 1.f);
	vec4 superDark = vec4(21.f / 255.f, 85.f / 255.f, 1.f / 255.f, 1.f);
	vec4 darkGreen = vec4(54.f / 255.f, 137.f / 255.f, 0.f / 255.f, 1.f);
	vec4 green = vec4(82.f / 255.f, 182.f / 255.f, 8.f / 255.f, 1.f);
	vec4 yellowGreen = vec4(200.f / 255.f, 232.f / 255.f, 20.f / 255.f, 1.f);
	vec4 red = vec4(199.f / 255.f, 167.f / 255.f, 9.f / 255.f, 1.f);//160.f / 255.f, 80.f / 255.f, 9.f / 255.f, 1.f);
	
	// Going to have the blades get lighter closer to the sides (side1 = middle)
	// But dark and rounded looking at the bottom
	vec4 side1 = mix(superDark, darkGreen, vInterp);
	float sq = sqrt(vInterp);
	vec4 side2 = mix(darker, green, sq);
	
	float curve = abs(hInterp * 2.f - 1.f);
	float mid = curve * curve;
	vec4 base = mix(side1, side2, mid); // The merge of the side colors - main blade component

	// Adding yellow and red tints to the top of each blade
	vec4 wYellow = mix(base, yellowGreen, vInterp * vInterp);
	float scale = max(vInterp * 3.f - 2.f, 0.f);
	vec4 wRed = mix(wYellow, red, scale * scale);

	// Lambertian Shading  //DOESNT WORK TOO WELL BEAUSE FLAT PLANE
	//vec3 camPos = -vec3(camera.view[3]);
	vec3 lightVec = normalize(vec3(9.f, 20.f, 12.f) - pos.xyz);
	float diffuseTerm = max(dot(lightVec, normalize(norm.xyz)), dot(lightVec, normalize(-norm.xyz)));
	diffuseTerm = clamp(diffuseTerm, 0.f, 1.f);

	// Have to adjust it because the normals on the triangle tops are off
	float lightIntensity = diffuseTerm * 0.8 + 0.2;
	lightIntensity = mix(lightIntensity, 1.f, vInterp * vInterp * 1.5);

    outColor = vec4(wRed.xyz * lightIntensity, wRed.w);
}
