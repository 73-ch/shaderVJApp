//
//  shaderScene.cpp
//  shaderVJApp
//
//  Created by nami on 2017/09/14.
//
//

#include "shaderScene.h"

shaderScene::shaderScene(vec2* size) {
    //
    opacity = 0;
    shader_type = NONE;

    // vertex
    vertex_num = 10000000;
    
    vector<vec3> positions;
    positions.reserve(vertex_num);
    for (int i = 0; i < vertex_num; i++) vbo.addVertex(vec3(0));
    cam.setPosition(0, 0, 1000);
    cam.setNearClip(0.00001);
    cam.setFarClip(10000);
    
    // frangment
    screen_size = size;
    
    rect.set(vec2(0), *screen_size);
    
    fbo.allocate(screen_size->x, screen_size->y, GL_RGBA);
    
    // parameter
    for (int i = 0; i < seeds.size(); i++) {
        seeds[i] = vec4(ofRandom(1), ofRandom(1), ofRandom(1), ofRandom(1));
    }
    
    mode = OF_PRIMITIVE_POINTS;
}

void shaderScene::update() {
    if (shader_type == NONE) return;
    // reload shader if shader changeds
    stat(shader_path.c_str(), &stat_buf);
    if (stat_buf.st_mtime != last_file_time) {
        cout << "shader changed" << endl;
        cout << "current_file_time : " + ofToString(ctime(&stat_buf.st_mtime)) << endl;
        last_file_time = stat_buf.st_ctime;
        this->loadShader();
    };
    
}

void shaderScene::draw() {
    if (shader_type == NONE || opacity == 0) return;
    
//    glEnable(GL_POINT_SIZE);
//    glPointSize(2.0);
    
    glEnable(GL_VERTEX_PROGRAM_POINT_SIZE);
    
    ofPopMatrix();
    ofPopStyle();
    
    fbo.begin();
    ofClear(0,0,0,0);
    shader.begin();
    
    shader.setUniform1f("time", ofGetElapsedTimef());
    shader.setUniform4f("seed0", seeds[0]);
    shader.setUniform4f("seed1", seeds[1]);
    shader.setUniform4f("seed2", seeds[2]);
    shader.setUniform4f("seed3", seeds[3]);
    shader.setUniform3f("cam_pos", cam.getPosition());
    
    ofSetColor(255);
    
    if (shader_type == VERTEX) {
        shader.setUniform1i("vertex_num", vertex_num);
//        vbo.setMode(OF_PRIMITIVE_POINTS);
        vbo.setMode(ofPrimitiveMode(mode));
        cam.begin();
        vbo.draw();
        shader.end();
        cam.end();
    } else if (shader_type == FRAGMENT) {
        shader.setUniform2f("u_resolution", *screen_size);
        ofDrawRectangle(rect);
        shader.end();
    }
    
    fbo.end();
    ofPushStyle();
    ofPushMatrix();
    
    
//    ofSetColor(255, 255, 255, opacity);
//    fbo.draw(0, 0);
}

void shaderScene::setVertexNum(int v_num) {
    vbo.clearVertices();
    vertex_num = v_num;
    for (int i = 0; i < vertex_num; i++) vbo.addVertex(vec3(0));
    int c_num = vertex_num - v_num;
}

void shaderScene::loadShader() {
    if (shader_type == VERTEX) {
        shader.load(shader_path, "shader/default.frag");
    } else if (shader_type == FRAGMENT) {
        shader.load("shader/default.vert", shader_path);
    }
    stat(shader_path.c_str(), &stat_buf);
    last_file_time = stat_buf.st_mtime;
}

void shaderScene::changeShader(const string new_path, int type) {
    shader_type = shaderTypes(type);
    cout << "shader_type : " + ofToString(shader_type) << endl;
    shader_path = ofFilePath::getAbsolutePath(new_path, true);
    cout << "shader_path : " + ofToString(shader_path) << endl;
    loadShader();
}

void shaderScene::windowResized(int w, int h) {
    rect.set(vec2(0), *screen_size);
    fbo.allocate(screen_size->x, screen_size->y, GL_RGBA);
}
