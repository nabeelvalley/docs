#ifdef GL_ES
precision mediump float;
#endif

#define TWO_PI 6.28318530718

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
    
    vec2 toCenter=vec2(.5)-st;
    float angle=atan(toCenter.y,toCenter.x);
    float radius=length(toCenter)*2.;
    
    float hue=(angle/TWO_PI)+.5;
    float saturation=radius;
    
    vec3 color=hsb2rgb(vec3(hue,saturation,1.));
    
    gl_FragColor=vec4(color,1.);
}

