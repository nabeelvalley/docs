#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

void main(){
    vec2 st=gl_FragCoord.xy/u_resolution.xy;
    
    vec2 center=vec2(.5);
    float dist=length(st-center);
    
    vec3 color=vec3(dist);
    
    gl_FragColor=vec4(color,1.);
}