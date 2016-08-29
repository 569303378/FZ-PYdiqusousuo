//
//  UserDTO.h
//  搜索Demo
//
//  Created by 马文星 on 16/5/12.
//  Copyright © 2016年 Demos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDTO : NSObject

/*!
 *  昵称 要搜索的文字
 *  例如：传智播客
 */
@property (nonatomic, copy) NSString *name;

/*!
 *  昵称的拼音 获取的时候就应该转为拼音了
 *  例如：chuanzhipinyin
 */
@property (nonatomic, copy) NSString *namePinYin;


/*!
 *  昵称的拼音首字母
 *  例如：czbk
 */
@property (nonatomic, copy) NSString *nameFirstLetter;

@end
