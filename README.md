# EIL_player_ios

EIL易居互动直播云平台播放ios SDK使用说明

EIL_nativeplayer_ios SDK是ios 平台上使用的软件开发工具包(SDK), 负责播放视频直播和点播内容。

一. 功能特点

• 音频编码：AAC

• 视频编码：H.264

• 播放流协议：RTMP, HLS, HTTP

• 显示：OpenGLES 2.0


二. 运行环境

    platform: iOS 6.0~10.2.x

    cpu: armv7, arm64, i386, x86_64, (armv7s is obselete)

    api: MediaPlayer.framework-like

    video-output: OpenGL ES 2.0

    audio-output: AudioQueue, AudioUnit

    hw-decoder: VideoToolbox (iOS 8+)

    alternative-backend: AVFoundation.Framework.AVPlayer, MediaPlayer.Framework.MPMoviePlayerControlelr (obselete since iOS 8)


三．快速集成

本章节提供一个快速集成推流SDK基础功能的示例。 具体可以参考app demo工程中的相应文件。

3.1 下载工程

3.1.1 github下载 从github下载SDK及demo工程

3.2 工程目录结构

• EJUMediaDemo: 示例工程，演示本SDK主要接口功能的使用  • prebuild: 集成SDK需要的所有库文件.

3.3 配置项目

引入目标库, 将prebuild目录下的库文件引入到目标工程中并添加依赖。 

3.4 简单播放示例

    //创建playey对象    
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    int videotoolbox = AppDelegateEntity.bSoftwareDecoder?0:1;
    [options setOptionIntValue:videotoolbox forKey:@"videotoolbox" ofCategory:kIJKFFOptionCategoryPlayer];  
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:self.url withOptions:options];
    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.player.view.frame = self.view.bounds;
    self.player.scalingMode = IJKMPMovieScalingModeAspectFit;
    self.player.shouldAutoplay = YES;
    self.player.maxCacheMsTime = 3000;
    self.view.autoresizesSubviews = YES;
    [self.view addSubview:self.player.view];
    [self.view addSubview:self.mediaControl];
    self.mediaControl.delegatePlayer = self.player;

    //准备播放
    - (void)viewWillAppear:(BOOL)animated
    {
      [super viewWillAppear:animated];
      [self installMovieNotificationObservers];
      [self.player prepareToPlay];
    }
    //播放
    - (IBAction)onClickPlay:(id)sender
    {
      [self.player play];
      [self.mediaControl refreshMediaControl];
    }
    //暂停
    - (IBAction)onClickPause:(id)sender
    {
      [self.player pause];
      [self.mediaControl refreshMediaControl];
    }
    //结束
    - (void)viewDidDisappear:(BOOL)animated
    {
       [super viewDidDisappear:animated];
       [self.player shutdown];
       [self removeMovieNotificationObservers];
     }

3.5 扩展功能

    //支持多种画面预览模式     
    - (IBAction)onClickScaling:(id)sender {
        IJKMPMovieScalingMode scalingMode = self.player.scalingMode;
        if (++scalingMode > IJKMPMovieScalingModeFill)
            scalingMode = IJKMPMovieScalingModeNone;
        [self.player setScalingMode:scalingMode];
    } 
    
    //静音
    - (void)onClickMute:(id)sender
    {
      [self.player setVolume:IJKMPMovieVolumeMute];
    }
    //增大音量
    - (IBAction)onClickHighAudio:(id)sender
    {
      [self.player setVolume:IJKMPMovieVolumeUp];
    }
    //减少音量
    - (IBAction)onClickLowAudio::(id)sender
    {
      [self.player setVolume:IJKMPMovieVolumeDown];
    }
    //获取版本
    - (IBAction)onClickVersion::(id)sender
    {
      NSString * version = [IJKFFMoviePlayerController getEJUPlayerVersion];
    }    
    //镜像
    - (void)onMirror:(id)sender
    {
       [self.player mirror:IJKMPMovieMirrorLeftToRight];
    }
    //旋转
    - (void)onRotation:(id)sender
    {
       [self.player rotate:IJKMPMovieRotationAngle90];
    }
     
		//设置是否创建日志文件，文件名debug.log
		[IJKFFMoviePlayerController setLogFileEnable:YES withLevel:k_IJK_LOG_INFO];
		
		//设置监听 当前提供了四个Notification监听
		/* Register observers for the various movie object notifications. */
			-(void)installMovieNotificationObservers
			{
				[[NSNotificationCenter defaultCenter] addObserver:self
								     selector:@selector(loadStateDidChange:)
									 name:IJKMPMoviePlayerLoadStateDidChangeNotification
								       object:_player];
				[[NSNotificationCenter defaultCenter] addObserver:self
								     selector:@selector(moviePlayBackDidFinish:)
									 name:IJKMPMoviePlayerPlaybackDidFinishNotification
								       object:_player];
				[[NSNotificationCenter defaultCenter] addObserver:self
								     selector:@selector(mediaIsPreparedToPlayDidChange:)
									 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
								       object:_player];
				[[NSNotificationCenter defaultCenter] addObserver:self
								     selector:@selector(moviePlayBackStateDidChange:)
									 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
								       object:_player];
			}

		/* Remove the movie notification observers from the movie object. */
		-(void)removeMovieNotificationObservers
		{
		    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerLoadStateDidChangeNotification object:_player];
		    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackDidFinishNotification object:_player];
		    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:_player];
		    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:_player];
		}
                		
  
四. API使用说明

   @protocol EJUMediaPlayback <NSObject>

   - (void)prepareToPlay;

   - (void)play;

   - (void)pause;

   - (void)stop;
 
   - (BOOL)isPlaying;
   
   - (void)shutdown;

   - (void)setVolume;
   
   - (void)mirror; 
   
   - (void)rotate;
   
   - (void)setScalingMode;
   
   @property(nonatomic, readonly)  UIView *view;
   
   @property(nonatomic)            NSTimeInterval currentPlaybackTime;
    
   @property(nonatomic, readonly)  NSTimeInterval duration;
    
   @property(nonatomic, readonly)  NSTimeInterval playableDuration;
    
   @property(nonatomic, readonly)  NSInteger bufferingProgress;
    
   @property(nonatomic) BOOL shouldAutoplay;
   
   
