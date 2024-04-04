#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

#define PI 3.14159265358979323846

float rectangle(vec2 st,float x,float y){
    float b=step(.5-y*.5,st.y);
    float l=step(.5-x*.5,st.x);
    
    float t=step(.5-y*.5,1.-st.y);
    float r=step(.5-x*.5,1.-st.x);
    
    float pct=b*l*t*r;
    return pct;
}

vec2 rotate2d(vec2 st,in float theta){
    mat2 matrix=mat2(cos(theta),-sin(theta),
    sin(theta),cos(theta));
    
    vec2 trans=vec2(.5);
    
    st-=trans;
    st*=matrix;
    st+=trans;
    
    return st;
}

void main(){
    vec2 st=gl_FragCoord.xy/u_resolution;
    
    st=rotate2d(st,PI*.25);
    
    st*=3.;
    st=fract(st);
    
    float c=rectangle(st,.5,.5);
    
    vec3 color=vec3(0.,1.,1.)*vec3(c);
    gl_FragColor=vec4(color,1.);
}