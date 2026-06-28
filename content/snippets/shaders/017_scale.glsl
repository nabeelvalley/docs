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

vec2 scale(vec2 st,vec2 scale){
    mat2 matrix=mat2(
        scale.x,0.,
    0.,scale.y);
    
    vec2 trans=vec2(.5);
    
    st-=trans;
    st*=matrix;
    st+=trans;
    
    return st;
}

void main(){
    vec2 st=gl_FragCoord.xy/u_resolution;
    
    vec2 s=vec2(abs(sin(u_time)));
    st=scale(st,s);
    
    float c=circle(st,.1);
    
    vec3 gradient=vec3(0.,st.x,st.y);
    vec3 color=gradient+vec3(c);
    
    gl_FragColor=vec4(color,1.);
}