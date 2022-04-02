package shaders;

class TestShader extends hxsl.Shader {
    static var SRC = {
        @:import h3d.shader.Base2d;
        
        @param var texture : Sampler2D;
        @param var speed : Float;
        @param var frequency : Float;
        @param var amplitude : Float;
        
        function fragment() {
            if (pixelColor.a == 1) {
                pixelColor = vec4(1, 0, 0, 1);
            }
        }
    }
}