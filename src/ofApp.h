#pragma once

#include "settings.h"
#include "ofxOsc.h"
#include <regex>

#include "shaderScene.h"


class ofApp : public ofBaseApp{

	public:
		void setup();
		void update();
		void draw();

        void dumpOSC(ofxOscMessage m);
		void keyPressed(int key);
		void keyReleased(int key);
		void mouseMoved(int x, int y );
		void mouseDragged(int x, int y, int button);
		void mousePressed(int x, int y, int button);
		void mouseReleased(int x, int y, int button);
		void mouseEntered(int x, int y);
		void mouseExited(int x, int y);
		void windowResized(int w, int h);
		void dragEvent(ofDragInfo dragInfo);
		void gotMessage(ofMessage msg);
		
    ofShader shader;
    vector <shaderScene> scenes;
//    array <shaderScene, SCENE_NUM> scenes;
    
    
    vec2 window_size;
    
    vec4 seed_vec;
    array <float, 6> seeds;
    
    ofFbo main_scene;
    
    // post effect
    ofShader post_effect;
    
    
    //osc
    ofxOscReceiver receiver;
    ofxOscSender sender;
    
    //
    std::regex reg;
    
    vector<string> search(string const &text, std::regex const &re) {
        vector<string> result;
        
        sregex_iterator iter(text.cbegin(), text.cend(), re) ;
        sregex_iterator end;
        
        for (; iter != end; ++iter) {
            auto s = iter->str();
            s.erase(s.begin());
            result.push_back(s);
        }
        
        return result ;
    }

};
