#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

// Skew the X and Y Coordinates
vec2 skew(in vec2 st){
    float x=1.1547*st.x;
    float y=st.y+.5*x;
    
    return vec2(x,y);
}

// Subdivide a cell on the line x = y
vec2 subdivide(in vec2 st){
    vec2 result=vec2(0.);
    
    if(st.x>st.y){
        result=1.-vec2(st.x,st.y-st.x);
    }else{
        result=1.-vec2(st.x-st.y,st.y);
    }
    
    return fract(result);
}

void main(){
    vec2 st=gl_FragCoord.xy/u_resolution;
    
    st*=5.;
    st=skew(st);
    st=fract(st);
    st=subdivide(st);
    
    vec3 color=vec3(.3,st.x,st.y);
    gl_FragColor=vec4(color,1.);
}