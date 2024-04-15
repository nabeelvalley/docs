#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

void main(){
    vec2 st=gl_FragCoord.xy/u_resolution;
    
    float grid=5.;
    
    st*=grid;
    vec2 i_st=floor(st);
    vec2 f_st=fract(st);
    
    float min_dist=1.;
    for(int y=-1;y<=1;y++){
        for(int x=-1;x<=1;x++){
            vec2 neighbor=i_st+vec2(float(x),float(y));
            float dist=distance(st,neighbor);
            min_dist=min(min_dist,dist);
        }
    }
    
    vec3 color=vec3(min_dist);
    gl_FragColor=vec4(color,1.);
}