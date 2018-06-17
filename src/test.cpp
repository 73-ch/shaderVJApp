

#include "ofMain.h"


class testClass {
    ofFbo fbo;
    ofShader shader;
    
public:
    void begin() {
        fbo.begin();
        ofClear(0, 0, 0);
        shader.begin();
    }
    
    void end() {
        fbo.end();
        shader.end();
    }
    
    ofTexture getTexture() {
        return fbo.getTexture();
    }
};

//---------------------------------


void ofApp::draw() {
    auto a = new testClass();
    
    a.begin();
    
    ofSetColor(255);
    ofDrawRectangle(0,0, 100, 100);
    
    a.end();
    
    ofTexture tex = a.getTexture();
}