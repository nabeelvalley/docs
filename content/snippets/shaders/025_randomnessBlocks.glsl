#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

#define TWO_PI 6.28318530718

float random(vec2 st){
    float a=dot(st.xy,vec2(74.61,20.53));
    return fract(sin(a)*83737.);
}

void main(){
    vec2 st=gl_FragCoord.xy/u_resolution;
    
    st*=10.;
    st=floor(st);
    
    vec3 color=vec3(random(st));
    gl_FragColor=vec4(color,1.);
}