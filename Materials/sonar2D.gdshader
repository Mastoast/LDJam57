shader_type canvas_item;
render_mode blend_mix, unshaded;

uniform float fade_radius : hint_range(0.5, 50.0) = 5.0;
uniform float max_intensity : hint_range(0.0, 3.0) = 2.0;
uniform vec2 player_position;
uniform sampler2D noise_tex : source_color;
uniform float noise_scale : hint_range(0.1, 5.0) = .5;
//uniform float pulse_speed : hint_range(0.0, 200.0) = 100.0;
uniform float max_distance : hint_range(0.0, 2000.0) = 1500.0;
uniform float pulse_time : hint_range(0.0, 15.0) = 2;
uniform float time : hint_range(-1.0, 100) = -1.0;

varying vec2 world_pos;

void vertex() {
    world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0, 1.0)).xy;
	float speed = max_distance / pulse_time; // replaces pulse_speed
	world_pos += normalize(player_position - world_pos) * time * speed;
}

void fragment() {
    float distance_to_player = distance(world_pos, player_position);
    float intensity = 1.0 - smoothstep(0.0, fade_radius * max_distance / distance_to_player * PI, distance_to_player);
    
    vec2 noise_uv = UV * noise_scale;
    float noise = texture(noise_tex, noise_uv).r;
    intensity *= mix(0.5, 1.5, noise);
    
    vec4 glow_color = texture(TEXTURE, UV);

    COLOR.rgb = glow_color.rgb * intensity * max_intensity;
    //EMISSION = COLOR;
    COLOR.a = glow_color.a * intensity;
}