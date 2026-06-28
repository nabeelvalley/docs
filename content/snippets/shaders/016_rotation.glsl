#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

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
    
    // translate to the origin center
    st-=trans;
    
    // rotate
    st*=matrix;
    
    // move back to origin
    st+=trans;
    
    return st;
}

void main(){
    vec2 st=gl_FragCoord.xy/u_resolution;
    
    st=rotate2d(st,sin(u_time));
    
    float c=rectangle(st,.1,.1);
    
    vec3 gradient=vec3(0.,st.x,st.y);
    vec3 color=gradient+vec3(c);
    
    gl_FragColor=vec4(color,1.);
}