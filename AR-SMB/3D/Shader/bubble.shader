float normalScaling = 1.5;
float timeScale = 3.0;

_geometry.position += vec4(_geometry.normal, 0.0) * sin(u_time * timeScale) * normalScaling;

// goes in/out/up/down... can be used to animate wand up/down with a shader.. instead of scnaction.. stuff
// https://github.com/pk-nb/scenekit-glshaders/tree/master/CustomShaders
