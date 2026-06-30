#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

void main(){
    vec2 st=gl_FragCoord.xy/u_resolution;
    
    vec2 cells[5];
    cells[0]=vec2(.33,.25);
    cells[1]=vec2(.75,.25);
    cells[2]=vec2(.25,.75);
    cells[3]=vec2(.75,.75);
    cells[4]=u_mouse/u_resolution;
    
    float min_dist=1.;
    for(int i=0;i<5;i++){
        float dist=distance(st,cells[i]);
        min_dist=min(min_dist,dist);
    }
    
    vec3 color=vec3(min_dist);
    gl_FragColor=vec4(color,1.);
}