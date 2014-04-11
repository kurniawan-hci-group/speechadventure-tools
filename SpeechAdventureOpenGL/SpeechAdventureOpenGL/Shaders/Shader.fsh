//
//  Shader.fsh
//  SpeechAdventureOpenGL
//
//  Created by Zak Rubin on 12/19/12.
//  Copyright (c) 2012 Zak Rubin. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
