//
//  shaderScene.hpp
//  shaderVJApp
//
//  Created by nami on 2017/09/11.
//
//

#pragma once

#include "settings.h"
#include <sys/stat.h>

class vertexShaderScene : public shaderScene {
    
public:
    void setup();
    void update();
    void draw();
    
private:
    int vertex_num;
    ofVboMesh vbo;
};