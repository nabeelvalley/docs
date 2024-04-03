#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

vec3 hsb2rgb(in vec3 c){
    vec3 rgb=clamp(abs(mod(c.x*6.+vec3(0.,4.,2.),6.)-3.)-1.,0.,1.);
    
    rgb=rgb*rgb*(3.-2.*rgb);
    return c.z*mix(vec3(1.),rgb,c.y);
}

void main(){
    vec2 st=gl_FragCoord.xy/u_resolution;
    
    float hue=st.x;
    float saturation=abs(sin(u_time));
    float brightness=st.y;
    
    vec3 color=hsb2rgb(vec3(hue,saturation,brightness));
    
    gl_FragColor=vec4(color,1.);
}

