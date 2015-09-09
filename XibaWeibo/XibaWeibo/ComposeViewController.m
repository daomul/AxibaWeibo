//
//  ComposeViewController.m
//  XibaWeibo
//
//  Created by K3CLOUDBOS on 15/8/9.
//  Copyright (c) 2015年 axiba. All rights reserved.
//

#import "ComposeViewController.h"
#import "XBAccountTool.h"
#import "XBTextView.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"

#import "XBComposeToolBar.h"
#import "XBComposePhotosView.h"
#import "XBEmotionKeyboard.h"
#import "XBEmotionTextView.h"

@interface ComposeViewController ()<XBComposeToolBarDelegate,UITextViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>


/** 输入控件 */
@property(nonatomic,strong)XBEmotionTextView *textView;
/** 键盘顶部的工具条 */
@property (nonatomic, weak) XBComposeToolBar *toolbar;
/** 相册（存放拍照或者相册中选择的图片） */
@property (nonatomic, weak) XBComposePhotosView *photosView;

/**  整个表情键盘*/
@property (nonatomic, strong) XBEmotionKeyboard *emotionKeyboard;
/** 是否正在切换键盘 */
@property (nonatomic, assign) BOOL switchingKeybaord;

@property(nonatomic,assign) CGFloat keyBoadrHeight;

@end

@implementation ComposeViewController

#pragma mark -- lazy load

-(XBEmotionKeyboard *)emotionKeyboard
{
    if (!_emotionKeyboard)
    {
        self.emotionKeyboard = [[XBEmotionKeyboard alloc]init];
        
        // 键盘的宽度
        self.emotionKeyboard.width = self.view.width;
        self.emotionKeyboard.height = _keyBoadrHeight;
        //self.emotionKeyboard.backgroundColor = [UIColor redColor];
        
        // 如果键盘宽度不为0，那么系统就会强制让键盘的宽度等于屏幕的宽度：320
        //        if (self.emotionKeyboard.width > 0) {
        //            self.emotionKeyboard.width = [UIScreen mainScreen].bounds.size.width;
        //        }
    }
    return _emotionKeyboard;
}

#pragma mark --life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航控制器
    [self setupNav];
    
    //输入控件
    [self setupTextView];
    
    //添加工具条
    [self setupToolBar];
    
    //添加相册
    [self setupPhotosView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 成为第一响应者（能输入文本的控件一旦成为第一响应者，就会叫出相应的键盘）
    [self.textView becomeFirstResponder];
}


#pragma mark -- UITextViewDelegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
#pragma mark -- XBComposeToolBarDelegate

-(void)composeToolBar:(XBComposeToolBar *)toolBar didClickButton:(XBComposeToolbarButtonType)buttonType
{
    switch (buttonType) {
        case XBComposeToolbarButtonTypeCamera: // 拍照
            [self openCamera];
            break;
            
        case XBComposeToolbarButtonTypePicture: // 相册
            [self openAlbum];
            break;
            
        case XBComposeToolbarButtonTypeMention: // @
            
            break;
            
        case XBComposeToolbarButtonTypeTrend: // #
            
            break;
            
        case XBComposeToolbarButtonTypeEmotion: // 表情\键盘
            [self switchKeyboard];
            break;
    }
}

#pragma mark -- UIImagePickerControllerDelegate

/**
 * 从UIImagePickerController选择完图片后就调用（拍照完毕或者选择相册图片完毕）
 */
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // info中就包含了选择的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // 添加图片到photosView中(选一张就加一张进去)
    [self.photosView addPhoto:image];
}

#pragma mark -- 通知

//监听文字是否已经输入
-(void)textDidChanged
{
    self.navigationItem.rightBarButtonItem.enabled = self.textView.hasText;
}

//键盘的frame发生改变，顺便把通知参数传过来，可以获取通知的上下文
-(void)keyboardWillChangeFrame:(NSNotification *)notification
{
    /**
     notification.userInfo = @{
     // 键盘弹出\隐藏后的frame
     UIKeyboardFrameEndUserInfoKey = NSRect: {{0, 352}, {320, 216}},
     // 键盘弹出\隐藏所耗费的时间
     UIKeyboardAnimationDurationUserInfoKey = 0.25,
     // 键盘弹出\隐藏动画的执行节奏（先快后慢，匀速）
     UIKeyboardAnimationCurveUserInfoKey = 7
     }
     */
    
    // 如果正在切换键盘，就不要执行后面的代码
    if (self.switchingKeybaord) return;
    
    NSDictionary *notiUserInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [notiUserInfo [UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    CGRect keyBoardF = [notiUserInfo [UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _keyBoadrHeight = keyBoardF.size.height;
    
    [UIView animateWithDuration:duration animations:^{
        if (keyBoardF.origin.y >self.view.height)
        {
            self.toolbar.y = self.view.height - self.toolbar.height;
        }
        else
        {
            self.toolbar.y = keyBoardF.origin.y - self.toolbar.height;
        }
    }];
}




#pragma mark -- private methods

/**
 *  表情被选中了
 */
- (void)emotionDidSelect:(NSNotification *)notification
{
    XBEmotion *emotion = notification.userInfo[XBSelectEmotionKey];
    [self.textView insertEmotion:emotion];
}
/**
 * 添加导航栏
 */
-(void)setupNav
{
    //1 设置两个BarItem
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(send)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    //2 取到用户的名称
    NSString *userName = [XBAccountTool account].UserName;
    NSString *titleName = @"发微博";
    if (userName)
    {
        //2.1 构造一个标签嵌入titleView 中
        UILabel *titleView = [[UILabel alloc]init];
        titleView.width = 200;
        titleView.height = 100;
        titleView.textAlignment = NSTextAlignmentCenter;
        titleView.numberOfLines = 0;
        
        //2.2 创建带属性的字符串，传入到titleView 中
        NSString *str = [NSString stringWithFormat:@"%@\n%@",titleName,userName];
        NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc]initWithString:str];
        
        [mutStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:[str rangeOfString:userName]];
        [mutStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:[str rangeOfString:titleName]];
        
        titleView.attributedText = mutStr;
        self.navigationItem.titleView = titleView;
    }
    else
    {
        self.navigationItem.title = titleName;
    }
}

/**
 * 添加文本控件
 */
-(void)setupTextView
{
    XBEmotionTextView *textView = [[XBEmotionTextView alloc]init];
    textView.frame = self.view.bounds;
    textView.font = [UIFont systemFontOfSize:15];
    textView.placeholder = @"分享新鲜事...";
    textView.alwaysBounceVertical = YES; //垂直方向上拖拽
    textView.delegate = self;
    
    [self.view addSubview:textView];
    self.textView = textView;
    
    //监听通知：如果已经输入了文字，就应该放开发送按钮
    [XBNotificationCenter addObserver:self selector:@selector(textDidChanged) name:UITextViewTextDidChangeNotification object:textView];
    
    // 键盘通知
    // 键盘的frame发生改变时发出的通知（位置和尺寸）
    //    UIKeyboardWillChangeFrameNotification
    //    UIKeyboardDidChangeFrameNotification
    // 键盘显示时发出的通知
    //    UIKeyboardWillShowNotification
    //    UIKeyboardDidShowNotification
    // 键盘隐藏时发出的通知
    //    UIKeyboardWillHideNotification
    //    UIKeyboardDidHideNotification
    [XBNotificationCenter addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];

    // 表情选中的通知
    [XBNotificationCenter addObserver:self selector:@selector(emotionDidSelect:) name:XBEmotionDidSelectNotification object:nil];
}

/**
 *  添加工具条
 */
-(void)setupToolBar
{
    XBComposeToolBar *toolBar = [[XBComposeToolBar alloc]init];
    toolBar.width = self.view.width;
    toolBar.height = 45;
    toolBar.y = self.view.height - toolBar.height;
    toolBar.delegate = self;
    
    [self.view addSubview:toolBar];
    self.toolbar = toolBar;
}

/**
 * 添加相册
 */
-(void)setupPhotosView
{
    XBComposePhotosView *photosV = [[XBComposePhotosView alloc]init];
    photosV.x = 10;
    photosV.y = 100;
    photosV.width = self.view.width;
    photosV.height = self.view.height;
    
    [self.textView addSubview:photosV];
    self.photosView = photosV;
}

/**
 * 打开照相机
 */
- (void)openCamera
{
    [self openImagePickerController:UIImagePickerControllerSourceTypeCamera];
}

/**
 * 打开系统相册
 */
- (void)openAlbum
{
    // 如果想自己写一个图片选择控制器，得利用AssetsLibrary.framework，利用这个框架可以获得手机上的所有相册图片
    // UIImagePickerControllerSourceTypePhotoLibrary > UIImagePickerControllerSourceTypeSavedPhotosAlbum
    [self openImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)openImagePickerController:(UIImagePickerControllerSourceType)type
{
     //先判断系统相册是否可用
    if (![UIImagePickerController isSourceTypeAvailable:type]) return;
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = type;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}

/**
 *  切换键盘
 */
- (void)switchKeyboard
{
    // self.textView.inputView == nil : 使用的是系统自带的键盘
    if (self.textView.inputView == nil) { // 切换为自定义的表情键盘
        self.textView.inputView = self.emotionKeyboard;
        
        // 显示键盘按钮
        self.toolbar.showKeyboardButton = YES;
    } else { // 切换为系统自带的键盘
        self.textView.inputView = nil;
        
        // 显示表情按钮
        self.toolbar.showKeyboardButton = NO;
    }
    
    // 开始切换键盘
    self.switchingKeybaord = YES;
    
    // 退出键盘
    [self.textView endEditing:YES];
    
    // 结束切换键盘
    self.switchingKeybaord = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 弹出键盘
        [self.textView becomeFirstResponder];
        
    });
}

#pragma mark -- resoponse
-(void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)send
{
    if (self.photosView.photos.count)
    {
        [self sendWeiboWithPhotos];
    }
    else
    {
        [self sendWeiboWithOutPhotos];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)sendWeiboWithPhotos
{
    // URL: https://upload.api.weibo.com/2/statuses/upload.json
    // 参数:
    /**	status true string 要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。*/
    /**	access_token true string*/
    /**	pic true binary 微博的配图。*/
    
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [XBAccountTool account].access_token;
    params[@"status"] = self.textView.text;
    
    // 3.发送请求
    [mgr POST:@"https://upload.api.weibo.com/2/statuses/upload.json" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // 拼接文件数据
        UIImage *image = [self.photosView.photos firstObject];
        NSData *data = UIImageJPEGRepresentation(image, 0.0);
        [formData appendPartWithFileData:data name:@"pic" fileName:@"test.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        [MBProgressHUD showSuccess:@"发送成功"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"发送失败"];
    }];}

-(void)sendWeiboWithOutPhotos
{
    // URL: https://api.weibo.com/2/statuses/update.json
    // 参数:
    /**	status true string 要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。*/
    /**	pic false binary 微博的配图。*/
    /**	access_token true string*/
    
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [XBAccountTool account].access_token;
    params[@"status"] = self.textView.text;
    
    // 3.发送请求
    [mgr POST:@"https://api.weibo.com/2/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD showSuccess:@"发送成功"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"发送失败"];
    }];
}

@end
