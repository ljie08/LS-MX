//
//  XFNewsModel.h
//  MXSecond
//
//  Created by FreeSnow on 2018/7/13.
//  Copyright © 2018年 AppleFish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFNewsModel : NSObject
/*
 "befrom": "",
 "classid": "55",
 "classname": "壁纸",
 "firsttitle": "0",
 "id": "4797",
 "isgood": "0",
 "istop": "0",
 "isurl": "0",
 "keyboard": "",
 "morepic": [
 ],
 "newstime": "1509287644",
 "onclick": "525",
 "plnum": "0",
 "smalltext": " ss",
 "title": "(图文)",
 "titlepic": "http://zuqiunews.6ag.cn//d/file/2017-10-29/7907b4e4c17f41d4a45e988d2d68d4a0.png",
 "titleurl": "/bizhi/2017-10-29/4797.html"
 "category": 0,
 "description": "7月13日讯 拜仁官方消息称，球队中场比达尔在上赛季受伤后首次恢复跑步训练。
 ",
 "id": 157764,
 "image": "http://static.v.xingyunyd.com/news/2018/07/13/201807130844479518.jpg",
 "newsId": "b666861a7ba3ee16ef1b657074d87c11",
 "pubTime": 1531442690,
 "reply": 17,
 "title": "官方：拜仁中场比达尔伤后首次恢复跑步训练",
 "type": 1,
 "url": ""
 
 "category": 2,
 "comment": 7,
 "description": "",
 "first": false,
 "hash": "202adb7daca338e72f67c19a2c76a05c",
 "hasVideo": true,
 "image": "http://static.v.xingyunyd.com/news/2018/07/13/201807131120517258.jpg",
 "index": 1531452084000,
 "leagueId": 1,
 "leagueName": "NBA",
 "lottery": false,
 "newsId": "202adb7daca338e72f67c19a2c76a05c",
 "original": false,
 "playType": "1",
 "priority": 0,
 "pubTime": 1531452084,
 "read": 1107,
 "redirect": false,
 "source": "",
 "summary": "东部新王！生涯字母哥长篇高光集锦",
 "title": "东部新王！生涯字母哥长篇高光集锦",
 "top": false,
 "topicId": 0,
 "url": "https://gslb.miaopai.com/stream/AWH26tcYhJerPF7Iiw~q9ckfhyOEqq8Y~VDtzQ__.mp4?ssig=9034f34bc1db1cd51ac08602dd6226e5&amp;time_stamp=1531455602696&amp;cookie_id=&amp;vend=1&amp;os=3&amp;partner=1&amp;platform=2&amp;cookie_id=&amp;refer=miaopai&amp;scid=AWH26tcYhJerPF7Iiw%7Eq9ckfhyOEqq8Y%7EVDtzQ__",
 "videos": [
 {
 "thumb": "http://static.v.xingyunyd.com/news/2018/07/13/201807131120517258.jpg",
 "url": "https://gslb.miaopai.com/stream/AWH26tcYhJerPF7Iiw~q9ckfhyOEqq8Y~VDtzQ__.mp4?ssig=9034f34bc1db1cd51ac08602dd6226e5&amp;time_stamp=1531455602696&amp;cookie_id=&amp;vend=1&amp;os=3&amp;partner=1&amp;platform=2&amp;cookie_id=&amp;refer=miaopai&amp;scid=AWH26tcYhJerPF7Iiw%7Eq9ckfhyOEqq8Y%7EVDtzQ__"
 }
 ]
 }
 */
@property (nonatomic, strong) NSString *classname;/**< 壁纸 */
@property (nonatomic, strong) NSString *Id;/**< 壁纸 */
@property (nonatomic, strong) NSString *newstime;/**< 壁纸 */
@property (nonatomic, strong) NSString *smalltext;/**< 壁纸 */
@property (nonatomic, strong) NSString *title;/**< 壁纸 */
@property (nonatomic, strong) NSString *titlepic;/**< 壁纸 */
@property (nonatomic, strong) NSString *titleurl;/**< 壁纸 */
@property (nonatomic, strong) NSString *classid;/**< 壁纸 */
@property (nonatomic, strong) NSArray *morepic;/**< 壁纸 */
@property (nonatomic, strong) NSString *category;/**< 壁纸 */
@property (nonatomic, strong) NSString *newsId;/**< 壁纸 */
@property (nonatomic, strong) NSString *pubTime;/**< 壁纸 */
@property (nonatomic, strong) NSString *type;/**< 壁纸 */
@property (nonatomic, strong) NSString *url;/**< 壁纸 */
@property (nonatomic, strong) NSString *image;/**< 壁纸 */
@property (nonatomic, strong) NSString *Description;/**< 壁纸 */
@property (nonatomic, strong) NSArray *videos;/**< 壁纸 */

@end
