#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

void main(){
    vec2 st=gl_FragCoord.xy/u_resolution.xy;
    
    vec2 center=vec2(.5);
    float r=.5;
    
    vec2 dist=st-center;
    
    float pct=1.-smoothstep(r-(r*.01),r+(r*.01),dot(dist,dist)*4.);
    
    vec3 color=vec3(pct);
    
    gl_FragColor=vec4(color,1.);
}

