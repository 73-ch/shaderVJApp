//
//  shaderScene.cpp
//  shaderVJApp
//
//  Created by nami on 2017/09/11.
//
//

#include "vertexShaderScene.h"

void vertexShaderScene::setup() {
    vertex_num = 1000000;
    
    // vertexのpositionの設定
    vector<vec3> positions;
    positions.reserve(vertex_num);
//    for (int i = 0; i < vertex_num; i++) vbo.addVertex(vec3(0));
}

void vertexShaderScene::update() {
    struct stat stat_buf;
    stat("frag.glsl", &stat_buf);
    stat_buf.st_ctime;
}

void vertexShaderScene::draw() {
    fbo.begin();
    
    shader.begin();
    shader.setUniform1f("time", ofGetElapsedTimef());
    shader.setUniform1i("vertex_num", vertex_num);
    shader.setUniform4f("r_seed0", *r_seeds[0]);
    shader.setUniform4f("r_seed1", *r_seeds[1]);
    shader.setUniform4f("r_seed2", *r_seeds[2]);
    
    vbo.setMode(OF_PRIMITIVE_POINTS);
    vbo.draw();
    shader.end();
    
    fbo.end();
    
    
    //　一つのクラスにvertexとfragmentのryouhoujissousuru
}