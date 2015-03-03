//
//  GetData.m
//  DoubanFM
//
//  Created by Lorin on 14-10-14.
//  Copyright (c) 2014年 LorinRain. All rights reserved.
//

#import "GetData.h"
#import "ModelPro.h"
#import "ASIDownloadCache.h"
#import "DoubanFMData.h"

@implementation GetData

//-------------------------------系统方式异步请求-----------------
// 获取频道列表
-(void) getChannel
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: [NSURL URLWithString: @"http://www.douban.com/j/app/radio/channels"]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest: request delegate: self];
    
    if(connection) {
        _datas = [NSMutableData new];
    }
}

#pragma mark - NSURLConnection回调方法
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_datas appendData: data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"error:%@",[error localizedDescription]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // 最外层字典
    NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData: _datas options: NSJSONReadingAllowFragments error: nil];
    // 键值为channels的数组
    NSArray *channelArray = [NSArray array];
    channelArray = [rootDic objectForKey: @"channels"];
    
    // 取出频道列表
    _items = [[NSMutableArray alloc] init];
    for(NSDictionary *dic in channelArray) {
        ModelPro *item = [[ModelPro alloc] init];
        
        item.channelName = [dic objectForKey: @"name"];
        item.channelId = [dic objectForKey: @"channel_id"];
        
        [_items addObject: item];
    }
    
    // 请求完成后，将数据推出去
    [_delegate sendChannelData: _items];
    
    
    NSLog(@"请求完成");
    
}


//-------------------------------ASI异步请求-----------------
-(void) ASIGetChannel
{
    // 判断是否存在本地文件
    NSArray *pathss = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathh = [pathss objectAtIndex: 0];
    NSString *Json_pathh = [pathh stringByAppendingPathComponent: @"JsonFile.json"];
    NSData *localData = [NSData dataWithContentsOfFile: Json_pathh];
    
    if(localData == nil) {
        NSLog(@"没有本地文件");
        
        // 如果没有，就进行网络请求
        requestChannel = [[ASIFormDataRequest alloc] initWithURL: [NSURL URLWithString: @"http://www.douban.com/j/app/radio/channels"]];
        [requestChannel setRequestMethod: @"GET"];
        [requestChannel setTimeOutSeconds: 30];
        
        [requestChannel startAsynchronous];
        
    } else {
        
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData: localData options: NSJSONReadingAllowFragments error: nil];
        // 键值为channels的数组
        NSArray *channelArray = [NSArray array];
        channelArray = [rootDic objectForKey: @"channels"];
        
        
        // 取出频道列表
        _items = [[NSMutableArray alloc] init];
        for(NSDictionary *dic in channelArray) {
            ModelPro *item = [[ModelPro alloc] init];
            
            item.channelName = [dic objectForKey: @"name"];
            item.channelId = [dic objectForKey: @"channel_id"];
            
            [_items addObject: item];
        }
        
        // 请求完成后，将数据推出去
        [_delegate sendChannelData: _items];
        
        NSLog(@"来自文件");
        
        // 同步最新数据
        requestChannel = [[ASIFormDataRequest alloc] initWithURL: [NSURL URLWithString: @"http://www.douban.com/j/app/radio/channels"]];
        [requestChannel setRequestMethod: @"GET"];
        [requestChannel setTimeOutSeconds: 30];
        
        [requestChannel startAsynchronous];
        
    }
    
    //    requestChannel = [[ASIFormDataRequest alloc] initWithURL: [NSURL URLWithString: @"http://www.douban.com/j/app/radio/channels"]];
    //    [requestChannel setRequestMethod: @"GET"];
    //    [requestChannel setTimeOutSeconds: 30];
    //
    // 请求完成时调用
    [requestChannel setCompletionBlock:^() {
        NSData *data = requestChannel.responseData;
        
        // 得到的json写入文件
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [paths objectAtIndex: 0];
        NSString *Json_path = [path stringByAppendingPathComponent: @"JsonFile.json"];
        
        // 写入文件
        NSLog(@"json写入文件%@",[data writeToFile: Json_path atomically: YES] ? @"success" : @"failed");
        
        // 最外层字典
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingAllowFragments error: nil];
        // 键值为channels的数组
        NSArray *channelArray = [NSArray array];
        channelArray = [rootDic objectForKey: @"channels"];
        
        
        // 取出频道列表
        _items = [[NSMutableArray alloc] init];
        for(NSDictionary *dic in channelArray) {
            ModelPro *item = [[ModelPro alloc] init];
            
            item.channelName = [dic objectForKey: @"name"];
            item.channelId = [dic objectForKey: @"channel_id"];
            
            [_items addObject: item];
        }
        
        // 请求完成后，将数据推出去
        [_delegate sendChannelData: _items];
        
        //-------------判断数据来自网络还是缓存-------
        //        if(request.didUseCachedResponse) {
        //            NSLog(@"数据来自缓存");
        //        } else {
        //            NSLog(@"数据来自网络");
        //        }
        
    }];
    
    // 出错时调用
    [requestChannel setFailedBlock:^() {
        NSError *error = requestChannel.error;
        NSLog(@"请求频道出错!%@",error);
    }];
    
    // 发送异步请求
    //[requestChannel startAsynchronous];
    
    //-------------设置缓存-----------
    //    NSString *cachePath = [NSHomeDirectory() stringByAppendingPathComponent: @"Documents"];
    //    ASIDownloadCache *cache = [[ASIDownloadCache alloc] init];
    //    [cache setStoragePath: cachePath];
    //    cache.defaultCachePolicy = ASIOnlyLoadIfNotCachedCachePolicy;
    //
    //    // 持久缓存
    //    request.cacheStoragePolicy = ASICachePermanentlyCacheStoragePolicy;
    //    request.downloadCache = cache;
    
}

-(void) getSongs
{
    /*
     * 接口type描述
     类型 需要参数      含义
     b 	sid 	bye，不再播放 	短报告
     e 	sid 	end，当前歌曲播放完毕，但是歌曲队列中还有歌曲 	短报告
     n           new，没有歌曲播放，歌曲队列也没有任何歌曲，需要返回新播放列表 	长报告
     p           playing，歌曲正在播放，队列中还有歌曲，需要返回新的播放列表 	长报告
     s 	sid 	skip，歌曲正在播放，队列中还有歌曲，适用于用户点击下一首 	短报告
     r 	sid 	rate，歌曲正在播放，标记喜欢当前歌曲 	短报告
     u 	sid 	unrate，歌曲正在播放，标记取消喜欢当前歌曲
     */
    
    DoubanFMData *checkLogin = [[DoubanFMData alloc] init];
    
    NSString *urlString;
    NSURL *url;
    
    if([checkLogin isLogin]) {
        
        _userId = [checkLogin defaultUserInfo: @"userId"];
        _userToken = [checkLogin defaultUserInfo: @"userToken"];
        _userExpire = [checkLogin defaultUserInfo: @"userExpire"];
        
        urlString = [NSString stringWithFormat: @"http://www.douban.com/j/app/radio/people?app_name=radio_desktop_win&version=100&sid=%@&user_id=%@&token=%@&expire=%@&channel=%@&type=%@",_songSid, _userId, _userToken, _userExpire, _channelId, _songType];
        url = [NSURL URLWithString: urlString];
        
    } else {
        
        urlString = [NSString stringWithFormat: @"http://www.douban.com/j/app/radio/people?app_name=radio_desktop_win&version=100&sid=%@&channel=%@&type=%@",_songSid,_channelId,_songType];
        url = [NSURL URLWithString: urlString];
        
    }
    
    NSLog(@"url is :%@",url);
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL: url];
    [request setRequestMethod: @"GET"];
    [request setTimeOutSeconds: 30];
    
    // 请求完成时调用
    [request setCompletionBlock:^() {
        NSData *data = request.responseData;
        
        // 最外层字典
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingAllowFragments error: nil];
        // 键值为song的数组
        NSArray *songsArray = [NSArray array];
        songsArray = [rootDic objectForKey: @"song"];
        
        // 返回信息中的r值为请求成功或失败的标识，0为成功，1为失败
        NSNumber *error = [rootDic objectForKey: @"r"];
        int temp = [error intValue];
        
        if(temp == 0) {   // 成功则执行
            
            // 目前发现，已登录用户，但没有收藏歌曲的情况
            if([songsArray count] == 0) {
                [_delegate sendNoSongs];
            } else {
                // 取出频道列表
                _playList = [[NSMutableArray alloc] init];
                for(NSDictionary *dic in songsArray) {
                    ModelPro *item = [[ModelPro alloc] init];
                    
                    item.songPicture = [dic objectForKey: @"picture"];
                    item.songArtist = [dic objectForKey: @"artist"];
                    item.songURL = [dic objectForKey: @"url"];
                    item.songTitle = [dic objectForKey: @"title"];
                    item.songLength = [dic objectForKey: @"length"];
                    item.songSid = [dic objectForKey: @"sid"];
                    item.songLiked = [dic objectForKey: @"like"];
                    
                    [_playList addObject: item];
                }
                
                // 完成后，将歌曲推出
                [_delegate sendData: _playList];
            }
            
        } else {       // 请求失败则执行
            
            [_delegate sendError];
            NSLog(@"请求歌曲失败");
        }
        
        // 之前判断请求失败的方法，个人认为上面的判断更好用
        //        if([_playList count] == 0) {
        //            [_delegate sendError];
        //        } else {
        //
        //            // 请求完成后，将数据推出去
        //            [_delegate sendData: _playList];
        //        }
        
    }];
    
    // 出错时调用
    [request setFailedBlock:^() {
        [_delegate sendError];
        NSError *error = request.error;
        NSLog(@"请求歌曲出错!%@",error);
        return;
    }];
    
    // 发送异步请求
    [request startAsynchronous];
    
}

-(void) getPicture
{
    NSURL *url = [NSURL URLWithString: _songPic];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL: url];
    [request setRequestMethod: @"GET"];
    [request setTimeOutSeconds: 10];
    
    // 请求完成时调用
    [request setCompletionBlock:^() {
        NSData *data = request.responseData;
        
        [_delegate sendPictureData: data];
        
    }];
    
    // 出错时调用
    [request setFailedBlock:^() {
        NSError *error = request.error;
        NSLog(@"请求图片出错!%@",error);
    }];
    
    // 发送异步请求
    [request startAsynchronous];
}

-(void) login
{
    NSString *urlString = [NSString stringWithFormat: @"http://www.douban.com/j/app/login?app_name=radio_desktop_win&version=100&email=%@&password=%@",_userName,_passWord];
    NSURL *url = [NSURL URLWithString: urlString];
    NSLog(@"url is :%@",url);
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL: url];
    [request setRequestMethod: @"GET"];
    [request setTimeOutSeconds: 20];
    
    // 请求完成时调用
    [request setCompletionBlock:^() {
        NSData *data = request.responseData;
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: nil];
        
        NSNumber *err = [dic objectForKey: @"r"];
        if([err intValue] == 0) {  // 0表示登录成功
            
            ModelPro *item = [[ModelPro alloc] init];
            
            item.userId = [dic objectForKey: @"user_id"];
            item.userToken = [dic objectForKey: @"token"];
            item.userExpire = [dic objectForKey: @"expire"];
            item.userName = [dic objectForKey: @"user_name"];
            item.userEmail = [dic objectForKey: @"email"];
            
            // 登录成功，推出信息
            [_delegate sendLoginStatu: YES];  // 登录成功，推出成功
            NSLog(@"登录成功");
            [_delegate senLoginInfo: item];
            
        } else {
            
            [_delegate sendLoginStatu: NO];
            NSString *errInfo = [dic objectForKey: @"err"];
            NSLog(@"登录出错:%@",errInfo);
            return;
        }
        
    }];
    
    // 出错时调用
    [request setFailedBlock:^() {
        [_delegate sendLoginStatu: NO];
        NSError *error = request.error;
        NSLog(@"请求登录数据出错!%@",error);
        return;
    }];
    
    // 发送异步请求
    [request startAsynchronous];
    
}

-(void) likeSong
{
    DoubanFMData *checkLogin = [[DoubanFMData alloc] init];
    
    _userId = [checkLogin defaultUserInfo: @"userId"];
    _userToken = [checkLogin defaultUserInfo: @"userToken"];
    _userExpire = [checkLogin defaultUserInfo: @"userExpire"];
    
    NSString *urlString = [NSString stringWithFormat: @"http://www.douban.com/j/app/radio/people?app_name=radio_desktop_win&version=100&sid=%@&user_id=%@&token=%@&expire=%@&channel=%@&type=%@",_songSid, _userId, _userToken, _userExpire, _channelId, _songType];
    NSURL *url = [NSURL URLWithString: urlString];
    
    NSLog(@"url is :%@",url);
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL: url];
    [request setRequestMethod: @"GET"];
    [request setTimeOutSeconds: 5];
    
    [request setCompletionBlock:^() {
        NSData *data = request.responseData;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: nil];
        
        NSNumber *erro = [dic objectForKey: @"r"];
        if([erro intValue] == 0) {  // 成功
            NSLog(@"加红心成功");
        } else {
            NSString *hehe = [dic objectForKey: @"err"];
            NSLog(@"加红心失败%@",hehe);
        }
        
    }];
    
    [request setFailedBlock:^() {
        NSLog(@"请求加红心数据失败");
    }];
    
    [request startAsynchronous];
    
}

// 取消请求
- (void)cancelRequest
{
    [requestChannel cancel];
    
    NSLog(@"stop stop stop stop");
}






/*
 
 * 红心频道：channel值为-3
 
 * 红心歌曲每次请求到的为两首
 
 * 登录后的接口为:http://www.douban.com/j/app/radio/people?app_name=radio_desktop_win&version=100&user_id=%@&token=%@&expire=%@&sid=%@&channel=%@&type=%@
 
 * 另外，豆瓣fm的网页接口为：http://douban.fm/j/mine/playlist?type=n&channel=1004693&from=mainsite
 */



@end
