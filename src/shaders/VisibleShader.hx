package shaders;

class VisibleShader extends hxsl.Shader {

    static var SRC = {

        @:import h3d.shader.Base2d;
        
        @param var lightMap : Sampler2D;
        
        function fragment() {

            if (pixelColor.r == 1)
                pixelColor.a = 0;

        }
    }

    public function new(_lightMap) {
        super();
        lightMap = _lightMap;
    }

}