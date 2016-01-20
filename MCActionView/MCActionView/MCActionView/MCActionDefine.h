//
//  MCActionDefine.h
//  qikeyun
//
//  Created by 马超 on 16/1/19.
//  Copyright © 2016年 Jerome. All rights reserved.
//

#ifndef MCActionDefine_h
#define MCActionDefine_h

#define MCcWeakify(o)        __weak   typeof(self) mcwo = o;
#define MCcStrongify(o)      __strong typeof(self) o = mcwo;
#define MCcHexColor(color)   [UIColor MC_colorWithHex:color]
#define MCc_SPLIT_WIDTH      (1/[UIScreen mainScreen].scale)

#endif /* MCActionDefine_h */
