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

vec2 truchetPattern(in vec2 st,in float index){
    index=fract(((index-.5)*2.));
    if(index>.75){
        st=vec2(1.)-st;
    }else if(index>.5){
        st=vec2(1.-st.x,st.y);
    }else if(index>.25){
        st=1.-vec2(1.-st.x,st.y);
    }
    return st;
}

void main(){
    vec2 st=gl_FragCoord.xy/u_resolution;
    
    st*=10.;
    vec2 i=floor(st);
    
    st=fract(st);
    
    vec2 tile=truchetPattern(st,random(i));
    
    // sharp triangles
    // float c=step(tile.x,tile.y);
    
    // lines
    float c=smoothstep(tile.x,tile.x,tile.y)-
    smoothstep(tile.x,tile.x+.4,tile.y);
    
    vec3 color=vec3(c);
    
    gl_FragColor=vec4(color,1.);
}