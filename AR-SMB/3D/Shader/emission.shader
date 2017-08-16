
// these seem to affect the number of dark area and the size:
// smaller sizes: less and bigger
// bigger sizes: more and smaller
uniform float baseScaler1;
uniform float baseScaler2;

// these seem to affect the shape and softness
// smaller sizes: more compact/sharp/round
// bigger sizes: more jagged and soft
uniform float scalingValue1;
uniform float scalingValue2;

// this calculation comes from here: https://github.com/pk-nb/scenekit-glshaders/blob/master/CustomShaders/sm_surf.shader
// I dont know how it works, but it does produce really interesting results based on the input..
float factor = sin(_surface.diffuseTexcoord[0] * baseScaler1 + cos(u_time + _surface.diffuseTexcoord[1] * scalingValue1))
             + cos(_surface.diffuseTexcoord[1] * baseScaler2 + sin(u_time + _surface.diffuseTexcoord[0] * scalingValue2));

factor = (factor + 1.0) * 0.5;

_surface.emission = vec4(_surface.emission[0] * factor,
_surface.emission[1] * factor,
_surface.emission[2] * factor, _surface.emission[3]);
