uniform mat4 MVP;
attribute vec4 position;
attribute vec4 color;
varying vec4 vcolor;
void main()
{
    gl_PointSize = 6.0;
    gl_Position = MVP * position;
    vcolor=color;
}
