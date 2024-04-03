#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

void main(){
    vec2 st=gl_FragCoord.xy/u_resolution.xy;
    
    // get the polar coordinates
    vec2 pos=vec2(.5)-st;
    float r=length(pos)*2.;
    float a=atan(pos.y,pos.x);
    
    float f=sin(a*3.);
    
    vec3 color=vec3(1.-step(f,r));
    
    gl_FragColor=vec4(color,1.);
}