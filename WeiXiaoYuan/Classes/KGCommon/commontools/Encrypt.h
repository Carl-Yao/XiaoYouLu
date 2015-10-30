//
//  Encrypt.h
//  crc32校验
//
//  Created by cheng lixing on 11-12-26.
//  Copyright 2011年 kugou. All rights reserved.
//

#import <Foundation/Foundation.h>


 unsigned int CalcCRC32(const void* buffer, int length);
 unsigned int Encode3(char* buffer, int length);
 bool Decode3(char* buffer, int length, unsigned int crc32);

