
// Waves Modifier
float Amplitude = 0.2;
float Frequency = 5.0;
vec2 nrm = _geometry.position.xz;
float len = length(nrm)+0.0001; // for robustness
nrm /= len;
float a = len + Amplitude*sin(Frequency * _geometry.position.y + u_time * 10.0);
_geometry.position.xz = nrm * a;

// https://github.com/pk-nb/scenekit-glshaders/blob/master/CustomShaders/geometry_ripple.shader
