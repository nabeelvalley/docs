#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

float circle(vec2 st,float r){
    vec2 center=vec2(.5);
    float dist=distance(center,st);
    float pct=step(1.-r,1.-dist);
    return pct;
}

void main(){
    vec2 st=gl_FragCoord.xy/u_resolution;
    
    st*=3.;
    st=fract(st);
    
    float c=circle(st,.1);
    vec3 color=vec3(c);
    
    gl_FragColor=vec4(color,1.);
}