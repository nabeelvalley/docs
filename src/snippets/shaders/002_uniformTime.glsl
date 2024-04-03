#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;// Canvas size (width,height)
uniform vec2 u_mouse;// mouse position in screen pixels
uniform float u_time;// Time in seconds since load

void main(){
    float variation=abs(sin(u_time));
    gl_FragColor=vec4(variation,0.,0.,1.);
}