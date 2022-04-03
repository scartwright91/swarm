package shaders;

class WhiteShader extends hxsl.Shader {

    static var SRC = {

        @:import h3d.shader.Base2d;
        
        function fragment() {
            if (pixelColor.a == 1)
                pixelColor = vec4(1, 1, 1, 1);
        }
    }

    public function new() {
        super();
    }

}