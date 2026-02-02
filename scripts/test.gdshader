shader_type canvas_item;

uniform float strength : hint_range(0.0, 2.0) = 1.0;
uniform float radius : hint_range(0.0, 1.5) = 0.75;
uniform vec4 vignette_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
    vec2 uv = UV * 2.0 - 1.0; // map UV from [0,1] to [-1,1]
    float dist = length(uv); // distance from center
    float vignette = smoothstep(radius, radius + strength * 0.5, dist); // fades in at edges

    COLOR = mix(vec4(0.0), vignette_color, vignette); // darkens edges only
}