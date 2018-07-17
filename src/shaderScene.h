//
//  shaderScene.hpp
//  shaderVJApp
//
//  Created by nami on 2017/09/14.
//
//

#include "settings.h"
#include <sys/stat.h>

class shaderScene {
    
public:
    
    shaderScene(vec2* size);
    void update();
    void draw();
    void setVertexNum(int v_num);
    void loadShader();
    void changeShader(const string new_path, int type);
    void windowResized(int w, int h);
    
    string shader_path;
    ofFbo fbo;

    array <vec4, 4> seeds;
    int opacity;
    
    ofCamera cam;
    
private:
    struct stat stat_buf;
    ofShader shader;
    enum shaderTypes {
        NONE = 0,
        VERTEX = 1,
        FRAGMENT = 2,
    };

    shaderTypes shader_type;
    time_t last_file_time;
    
    // vertex
    int vertex_num;
    ofVboMesh vbo;
    ofPrimitiveMode mode;
    
    // fragment
    ofRectangle rect;
    vec2* screen_size;
};
