package shaders;

class ReflectionShader extends hxsl.Shader {

    static var SRC = {

        @:import h3d.shader.Base2d;
        
        @param var reflectionMap : Sampler2D;
        
        function fragment() {

            if (pixelColor.r == 1)
                pixelColor.a = 0;

        }
    }

    public function new(_reflectionMap) {
        super();
        reflectionMap = _reflectionMap;
    }

}