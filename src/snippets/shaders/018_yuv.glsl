#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

mat3 yuv2rgb=mat3(1.,0.,1.13983,
    1.,-.39465,-.58060,
1.,2.03211,0.);

mat3 rgb2yuv=mat3(.2126,.7152,.0722,
    -.09991,-.33609,.43600,
.615,-.5586,-.05639);

void main(){
    vec2 st=gl_FragCoord.xy/u_resolution;
    
    // Remap our space since YUV goes from -1 to 1
    st-=.5;
    st*=2.;
    
    vec3 color=yuv2rgb*vec3(abs(sin(u_time)),st.x,st.y);
    
    gl_FragColor=vec4(color,1.);
}