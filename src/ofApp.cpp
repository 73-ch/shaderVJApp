#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    ofBackground(0);
//    ofEnableAlphaBlending();
//    ofEnableBlendMode(OF_BLENDMODE_ADD);
    ofSetVerticalSync(false);
    glEnable(GL_BLEND);
//    glBlendFuncSeparate(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA,GL_SRC_ALPHA,GL_ONE);
    glBlendFunc(GL_ONE_MINUS_DST_COLOR, GL_ONE);
    
    // main_scene
    window_size = vec2(ofGetWidth(), ofGetHeight());
    main_scene.allocate(window_size.x, window_size.y, GL_RGBA);
    
    // generate scene
    for (int i = 0; i < SCENE_NUM; i++) {
        scenes.push_back(*new shaderScene(&window_size));
    }
    
    cout << "scenes size : " + ofToString(scenes.size()) << endl;
    
    
    // setup osc
    receiver.setup(RPORT);
    reg = R"(/[^/]*)";
    sender.setup("localhost", SPORT);
    
}

//--------------------------------------------------------------
void ofApp::update(){
//    cout << receiver.hasWaitingMessages() << endl;
    
    while( receiver.hasWaitingMessages() ) {
        //get next osc message
        ofxOscMessage m;
        receiver.getNextMessage(m);
        
        //dump osc messages
        dumpOSC(m);
    }
    for (int i = 0; i < scenes.size(); i++) {
        scenes[i].update();
    }
}

//--------------------------------------------------------------
void ofApp::draw(){
    main_scene.begin();
    glBlendFunc(GL_ONE_MINUS_DST_COLOR, GL_ONE);
    ofClear(0);
    for (int i = 0; i < scenes.size(); i++) {
//        ofPopStyle();
        scenes[i].draw();
//        ofPushStyle();
    }
    
    for (int i = 0; i < scenes.size(); i++) {
        ofPopStyle();
        ofSetColor(255, 255, 255, scenes[i].opacity);
        scenes[i].fbo.draw(0, window_size.y, window_size.x, -window_size.y);
        ofPushStyle();
    }
    
    main_scene.end();
    
//    ofPopMatrix();
//    ofPopStyle();
//    post_effect.begin();
    ofClear(0);
    glBlendFunc(GL_ONE_MINUS_DST_COLOR, GL_ONE);
    main_scene.draw(0, 0);
//    post_effect.end();
//    ofPushStyle();
//    ofPushMatrix();
//    ofDrawBitmapStringHighlight(ofToString(ofGetFrameRate()), 5, 20);
    if (ofGetFrameNum() % 70 == 0) {
        ofxOscMessage m;
        m.setAddress("/fps");
        m.addFloatArg(ofGetFrameRate());
        sender.sendMessage(m, false);
    }
}

void ofApp::dumpOSC(ofxOscMessage m) {
    string msg_string;
    msg_string = m.getAddress();
    
    vector<string> b_result = search(msg_string, reg);
    
    auto result = b_result.data();
    int target = ofToInt(result[0]);
    string first = result[1];
    
    if (first == "path") {
        cout << "path changed" << endl;
        cout << "target : " + ofToString(target) << endl;
        scenes[target].changeShader("shader/" + m.getArgAsString(0), m.getArgAsInt32(1));
    } else if (first == "opacity") {
        scenes[target].opacity = m.getArgAsInt(0);
    } else if (first == "seed") {
        scenes[target].seeds[floor(ofToInt(result[2]) / 4)][ofToInt(result[2]) % 4] = m.getArgAsFloat(0);
//        cout << "seeds : " + ofToString(floor(ofToInt(result[2]))) << endl;
//        cout << "seed_ch : " + ofToString(ofToInt(result[2]) % 4) << endl;
    } else if (first == "cam") {
        if (result[2] == "position") {
            scenes[target].cam.setPosition(m.getArgAsFloat(0), m.getArgAsFloat(1), m.getArgAsFloat(2));
        } else if (result[2] == "lookat") {
            scenes[target].cam.lookAt(vec3(m.getArgAsFloat(0), m.getArgAsFloat(1), m.getArgAsFloat(2)));
        } else if (result[2] == "orientation") {
            scenes[target].cam.setOrientation(vec3(m.getArgAsFloat(0), m.getArgAsFloat(1), m.getArgAsFloat(2)));
        } else if (result[2] == "farclip") {
            scenes[target].cam.setFarClip(m.getArgAsFloat(0));
        }
    } else if (first == "vertex_num") {
        scenes[target].setVertexNum(m.getArgAsInt(0));
    }
    
    for (int i=0; i<m.getNumArgs(); i++ ) {
        msg_string += " ";
        if(m.getArgType(i) == OFXOSC_TYPE_INT32)
            msg_string += ofToString( m.getArgAsInt32(i));
        else if(m.getArgType(i) == OFXOSC_TYPE_FLOAT)
            msg_string += ofToString( m.getArgAsFloat(i));
        else if(m.getArgType(i) == OFXOSC_TYPE_STRING)
            msg_string += m.getArgAsString(i);
    }
    
    
//    cout << "end" << endl;
//    
//    cout << msg_string << endl;
    
    vec4 test;
    test[0] = 1;
}

//--------------------------------------------------------------
void ofApp::keyPressed(int key){

}

//--------------------------------------------------------------
void ofApp::keyReleased(int key){

}

//--------------------------------------------------------------
void ofApp::mouseMoved(int x, int y ){

}

//--------------------------------------------------------------
void ofApp::mouseDragged(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mousePressed(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseReleased(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseEntered(int x, int y){

}

//--------------------------------------------------------------
void ofApp::mouseExited(int x, int y){

}

//--------------------------------------------------------------
void ofApp::windowResized(int w, int h){
    window_size = vec2(w, h);
    for (int i = 0; i < scenes.size(); i++) {
        scenes[i].windowResized(w,h);
    }
    main_scene.allocate(w, h, GL_RGBA);
}

//--------------------------------------------------------------
void ofApp::gotMessage(ofMessage msg){

}

//--------------------------------------------------------------
void ofApp::dragEvent(ofDragInfo dragInfo){ 

}
