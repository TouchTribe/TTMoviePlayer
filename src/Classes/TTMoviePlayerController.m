//
//  TTMoviePlayerController.m
//  MediaPlayerTest
//
//  Created by Guido van Loon on 6/26/13.
//  Copyright (c) 2013 TouchTribe. All rights reserved.
//

#import "TTMoviePlayerController.h"
#import "TTMoviePlayerControl.h"
#import "TTMoviePlayerView.h"
#import "TTMoviePlayerViewController.h"
#import "TTMoviePlayerDefaultLayout.h"

NSString * const kTracksKey         = @"tracks";
NSString * const kPlayableKey		= @"playable";

/* PlayerItem keys */
NSString * const kStatusKey         = @"status";
NSString * const kLoadedTimeKey     = @"loadedTimeRanges";

/* AVPlayer keys */
NSString * const kRateKey			= @"rate";
NSString * const kCurrentItemKey	= @"currentItem";

static void *TTMoviePlayerControllerRateObservationContext = &TTMoviePlayerControllerRateObservationContext;
static void *TTMoviePlayerControllerStatusObservationContext = &TTMoviePlayerControllerStatusObservationContext;
static void *TTMoviePlayerControllerLoadedObservationContext = &TTMoviePlayerControllerLoadedObservationContext;
static void *TTMoviePlayerControllerCurrentItemObservationContext = &TTMoviePlayerControllerCurrentItemObservationContext;

TTMoviePlayerRange TTMoviePlayerRangeMake(float position, float length) {
    TTMoviePlayerRange range;
    range.position = position;
    range.length = length;
    return range;
}

@implementation TTMoviePlayerController

@synthesize URL, view, layout, fullscreen, fillMode, scrubSpeed, autoplay;

- (id)init
{
    self = [super init];
    if (self) {
        view = [[TTMoviePlayerView alloc] init];
        view.fullscreen = false;
        view.controller = self;
        interfaceVisible = true;
        
        self.layout = [[TTMoviePlayerDefaultLayout alloc] init];
    }
    return self;
}

- (void)play
{
	/* If we are at the end of the movie, we must seek to the beginning first
     before starting playback. */
	if (YES == seekToZeroBeforePlay)
	{
		seekToZeroBeforePlay = NO;
		[player seekToTime:kCMTimeZero];
	}
    
	[player play];
	
    [self setPlayState:TTMoviePlayerPlayStatePlaying];
}

- (BOOL)isPlaying
{
    if (player)
        return restoreAfterScrubbingRate != 0.f || [player rate] != 0.f;
    else
        return self.autoplay;
}

- (void)setAutoplay:(BOOL)autoplay_
{
    autoplay = autoplay_;
    [self syncPlayState];
}

- (void)pause
{
	[player pause];
    [self setPlayState:TTMoviePlayerPlayStateStopped];
}

- (void)prevTrack
{
    [player seekToTime:kCMTimeZero];
    [self scheduleHideInterface];
}

- (void)nextTrack
{
}

- (void)setFillMode:(TTMoviePlayerFillMode)fillMode_
{
    fillMode = fillMode_;
    [view setVideoFillMode:(fillMode_ == TTMoviePlayerFillModeFullscreen ?  AVLayerVideoGravityResizeAspectFill : AVLayerVideoGravityResizeAspect)];
    for (UIView<TTMoviePlayerControl> *control in view.layout.controls) {
        if ([control respondsToSelector:@selector(setFillMode:)]) {
            [control setFillMode:fillMode];
        }
    }
}

- (void)setPlayState:(TTMoviePlayerPlayState) state
{
    if (state == TTMoviePlayerPlayStatePlaying) {
        [self scheduleHideInterface];
    } else {
        [self clearHideTimer];
    }
    for (UIView<TTMoviePlayerControl> *control in view.layout.controls) {
        if ([control respondsToSelector:@selector(setPlayState:)]) {
            [control setPlayState:state];
        }
    }
}

- (void)setEnabled:(BOOL)enabled
{
    for (UIView<TTMoviePlayerControl> *control in view.layout.controls) {
        if ([control respondsToSelector:@selector(setEnabled:)]) {
            [control setEnabled:enabled];
        }
    }
}

- (void)syncPlayState
{
    if (self.isPlaying) {
        [self setPlayState:TTMoviePlayerPlayStatePlaying];
    } else {
        [self setPlayState:TTMoviePlayerPlayStateStopped];
    }
}

- (void)setLayout:(TTMoviePlayerLayout *)layout_
{
    layout = layout_;
    layout.controller = self;
    view.layout = layout;
}

- (void)setURL:(NSURL*)URL_
{
	if (URL != URL_) {
        URL = URL_;
        /*
         Create an asset for inspection of a resource referenced by a given URL.
         Load the values for the asset keys "tracks", "playable".
         */
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:URL options:nil];
        
        NSArray *requestedKeys = [NSArray arrayWithObjects:kTracksKey, kPlayableKey, nil];
        
        /* Tells the asset to load the values of any of the specified keys that are not already loaded. */
        [asset loadValuesAsynchronouslyForKeys:requestedKeys completionHandler:
         ^{
             dispatch_async( dispatch_get_main_queue(),
                            ^{
                                /* IMPORTANT: Must dispatch to main queue in order to operate on the AVPlayer and AVPlayerItem. */
                                [self prepareToPlayAsset:asset withKeys:requestedKeys];
                            });
         }];
	}
}

/* Called when the player item has played to its end time. */
- (void)playerItemDidReachEnd:(NSNotification *)notification
{
	/* After the movie has played to its end time, seek back to time zero
     to play it again. */
	seekToZeroBeforePlay = YES;
}

/* ---------------------------------------------------------
 **  Get the duration for a AVPlayerItem.
 ** ------------------------------------------------------- */

- (CMTime)playerItemDuration
{
	AVPlayerItem *playerItem_ = [player currentItem];
	if (playerItem_.status == AVPlayerItemStatusReadyToPlay)
	{
        /*
         NOTE:
         Because of the dynamic nature of HTTP Live Streaming Media, the best practice
         for obtaining the duration of an AVPlayerItem object has changed in iOS 4.3.
         Prior to iOS 4.3, you would obtain the duration of a player item by fetching
         the value of the duration property of its associated AVAsset object. However,
         note that for HTTP Live Streaming Media the duration of a player item during
         any particular playback session may differ from the duration of its asset. For
         this reason a new key-value observable duration property has been defined on
         AVPlayerItem.
         
         See the AV Foundation Release Notes for iOS 4.3 for more information.
         */
        
		return([playerItem_ duration]);
	}

	return(kCMTimeInvalid);
}


/* Cancels the previously registered time observer. */
-(void)removePlayerTimeObserver
{
	if (timeObserver) {
		[player removeTimeObserver:timeObserver];
		timeObserver = nil;
	}
}

-(void)initTime
{
   __block TTMoviePlayerController *self_ = self;
	timeObserver = [player addPeriodicTimeObserverForInterval:CMTimeMake(1, 15)
                                                                queue:NULL /* If you pass NULL, the main queue is used. */
                                                           usingBlock:^(CMTime time)
                      {
                          [self_ syncTime];
                      }];
}

- (void)syncTime
{
    [self updateDuration:[self playerItemDuration]];
    [self updateTime:player.currentTime];
}


- (void)observeValueForKeyPath:(NSString*) path
                      ofObject:(id)object
                        change:(NSDictionary*)change
                       context:(void*)context
{
	/* AVPlayerItem "status" property value observer. */
	if (context == TTMoviePlayerControllerStatusObservationContext)
	{
		[self syncPlayState];
        
        AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        switch (status)
        {
                /* Indicates that the status of the player is not yet known because
                 it has not tried to load new media resources for playback */
            case AVPlayerStatusUnknown:
            {
                [self removePlayerTimeObserver];
                [self syncTime];
                [self setEnabled:false];
                break;
            }
            case AVPlayerStatusReadyToPlay:
            {
                /* Once the AVPlayerItem becomes ready to play, i.e.
                 [playerItem status] == AVPlayerItemStatusReadyToPlay,
                 its duration can be fetched from the item. */
                [self initTime];
                [self setEnabled:true];
                AVPlayerItem *playerItem_ = (AVPlayerItem *)object;
                [self updateDuration:playerItem_.duration];
                break;
            }
            case AVPlayerStatusFailed:
            {
                AVPlayerItem *playerItem_ = (AVPlayerItem *)object;
                [self assetFailedToPrepareForPlayback:playerItem_.error];
                break;
            }
        }
	} else if (context == TTMoviePlayerControllerRateObservationContext) {
        
        [self syncPlayState];

	} else if (context == TTMoviePlayerControllerCurrentItemObservationContext) {
        
        AVPlayerItem *newPlayerItem = [change objectForKey:NSKeyValueChangeNewKey];
        
        /* Is the new player item null? */
        if (newPlayerItem == (id)[NSNull null])
        {
            [self setEnabled:FALSE];
        }
        else /* Replacement of player currentItem has occurred */
        {
            /* Set the AVPlayer for which the player layer displays visual output. */
            view.player = player;
            [self setViewDisplayName];
            
            /* Specifies that the player should preserve the video’s aspect ratio and
             fit the video within the layer’s bounds. */
            [view setVideoFillMode:AVLayerVideoGravityResizeAspect];
            
            if (self.autoplay)
                [view.player play];
            
            [self syncPlayState];
        }
	} else if (context == TTMoviePlayerControllerLoadedObservationContext) {
        NSArray *ranges = [object loadedTimeRanges];
        NSValue *value = [ranges lastObject];
        CMTimeRange range = [value CMTimeRangeValue];
        
        [self updateBuffer:CMTimeAdd(range.start, range.duration)];
	} else {
		[super observeValueForKeyPath:path ofObject:object change:change context:context];
	}
}


- (void)prepareToPlayAsset:(AVURLAsset *)asset withKeys:(NSArray *)requestedKeys
{
    /* Make sure that the value of each key has loaded successfully. */
	for (NSString *thisKey in requestedKeys)
	{
		NSError *error = nil;
		AVKeyValueStatus keyStatus = [asset statusOfValueForKey:thisKey error:&error];
		if (keyStatus == AVKeyValueStatusFailed)
		{
			[self assetFailedToPrepareForPlayback:error];
			return;
		}
		/* If you are also implementing -[AVAsset cancelLoading], add your code here to bail out properly in the case of cancellation. */
	}
    
    /* Use the AVAsset playable property to detect whether the asset can be played. */
    if (false)
    {
        /* Generate an error describing the failure. */
		NSString *localizedDescription = NSLocalizedString(@"Item cannot be played", @"Item cannot be played description");
		NSString *localizedFailureReason = NSLocalizedString(@"The assets tracks were loaded, but could not be made playable.", @"Item cannot be played failure reason");
		NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
								   localizedDescription, NSLocalizedDescriptionKey,
								   localizedFailureReason, NSLocalizedFailureReasonErrorKey,
								   nil];
		NSError *assetCannotBePlayedError = [NSError errorWithDomain:@"StitchedStreamPlayer" code:0 userInfo:errorDict];
        
        /* Display the error to the user. */
        [self assetFailedToPrepareForPlayback:assetCannotBePlayedError];
        
        return;
    }
	
	/* At this point we're ready to set up for playback of the asset. */
    
    if (playerItem) {
        [self unregisterPlayerItemObservers:playerItem];
    }
    playerItem = [AVPlayerItem playerItemWithAsset:asset];
    [self registerPlayerItemObservers:playerItem];
	
    seekToZeroBeforePlay = NO;
	
    if (!player) {
        player = [AVPlayer playerWithPlayerItem:playerItem];
        [self registerPlayerObservers:player];
    }
    
    if (player.currentItem != playerItem) {
        [player replaceCurrentItemWithPlayerItem:playerItem];
        [self syncPlayState];
    }
    
    [self updateTime:CMTimeMake(0,1)];
}


-(void)assetFailedToPrepareForPlayback:(NSError *)error
{
    [self removePlayerTimeObserver];
    [self syncTime];
    [self setEnabled:FALSE];
    
    /* Display the error. */
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
														message:[error localizedFailureReason]
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
	[alertView show];
}

- (void)updateTime:(CMTime)time
{
    if (CMTIME_IS_INVALID(time)) {
        return;
    }
    double value = CMTimeGetSeconds(time);
    if (isfinite(value)) {
        for (UIView<TTMoviePlayerControl> *control in view.layout.controls) {
            if ([control respondsToSelector:@selector(updateTime:)]) {
                [control updateTime:value];
            }
        }
    }
}

- (void)updateDuration:(CMTime)duration
{
    if (CMTIME_IS_INVALID(duration)) {
        return;
    }
    double value = CMTimeGetSeconds(duration);
    if (isfinite(value)) {
        for (UIView<TTMoviePlayerControl> *control in view.layout.controls) {
            if ([control respondsToSelector:@selector(updateDuration:)]) {
                [control updateDuration:value];
            }
        }
    }
}

- (void)updateBuffer:(CMTime)buffer
{
    if (CMTIME_IS_INVALID(buffer)) {
        return;
    }
    double value = CMTimeGetSeconds(buffer);
    if (isfinite(value)) {
        for (UIView<TTMoviePlayerControl> *control in view.layout.controls) {
            if ([control respondsToSelector:@selector(updateBuffer:)]) {
                [control updateBuffer:value];
            }
        }
    }
}

-(void)setViewDisplayName
{
    self.title = [URL lastPathComponent];
    
    /* Or if the item has a AVMetadataCommonKeyTitle metadata, use that instead. */
	for (AVMetadataItem* item in ([[[player currentItem] asset] commonMetadata]))
	{
		NSString* commonKey = [item commonKey];
		
		if ([commonKey isEqualToString:AVMetadataCommonKeyTitle])
		{
			self.title = [item stringValue];
		}
	}
}


/* The user is dragging the movie controller thumb to scrub through the movie. */
- (void)beginScrubbing
{
	restoreAfterScrubbingRate = player.rate;
	player.rate = 0.f;
    lastScrubTime = [NSDate timeIntervalSinceReferenceDate];
	
	/* Remove previous timer. */
    [self clearHideTimer];
	[self removePlayerTimeObserver];
}

/* Set the player current time to match the scrubber position. */
- (void)scrub:(double)time
{
    scrubPosition = time;
    for (UIView<TTMoviePlayerControl> *control in view.layout.controls) {
        if ([control respondsToSelector:@selector(updateTime:)]) {
            [control updateTime:time];
        }
    }
    NSTimeInterval timestamp = [NSDate timeIntervalSinceReferenceDate];
    if (timestamp - lastScrubTime > 0.25) {
        [player seekToTime:CMTimeMakeWithSeconds(scrubPosition, NSEC_PER_SEC)];
        lastScrubTime = timestamp;
    }
}

/* The user has released the movie thumb control to stop scrubbing through the movie. */
- (void)endScrubbing
{
    [player seekToTime:CMTimeMakeWithSeconds(scrubPosition, NSEC_PER_SEC)];
	if (!timeObserver) {
        [self initTime];
	}
	if (restoreAfterScrubbingRate)
	{
		player.rate = restoreAfterScrubbingRate;
		restoreAfterScrubbingRate = 0.f;
	}
    [self scheduleHideInterface];
}

- (BOOL)isScrubbing
{
	return restoreAfterScrubbingRate != 0.f;
}

- (void)showInterfaceAnimated:(BOOL)animated
{
    if (!interfaceVisible) {
        interfaceVisible = true;
        [layout showInterfaceAnimated:animated];
        [self scheduleHideInterface];
    }
}

- (void)hideInterfaceAnimated:(BOOL)animated
{
    if (interfaceVisible) {
        interfaceVisible = false;
        [layout hideInterfaceAnimated:animated];
        [self clearHideTimer];
    }
}

- (BOOL)interfaceVisible
{
    return interfaceVisible;
}

- (void)scheduleHideInterface
{
    if (self.isPlaying) {
        [self clearHideTimer];
        timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(shouldHideInterface) userInfo:nil repeats:FALSE];
    }
}

- (void)clearHideTimer
{
    if (timer != nil) {
        [timer invalidate];
        timer = nil;
    }
}

- (void)shouldHideInterface
{
    [self hideInterfaceAnimated:true];
}

- (void)setFullscreen:(BOOL)fullscreen_
{
    if (fullscreen_ != fullscreen) {
        fullscreen = fullscreen_;
        [self clearHideTimer];
        layout.fullscreen = fullscreen;
        view.fullscreen = fullscreen;
    }
}

- (void)setScrubSpeed:(TTMoviePlayerScrubSpeed)scrubSpeed_;
{
    scrubSpeed = scrubSpeed_;
    for (UIView<TTMoviePlayerControl> *control in view.layout.controls) {
        if ([control respondsToSelector:@selector(setScrubSpeed:)]) {
            [control setScrubSpeed:scrubSpeed];
        }
    }
}

- (void)registerPlayerObservers:(AVPlayer *)player_
{
    [player_ addObserver:self
             forKeyPath:kCurrentItemKey
                options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                context:TTMoviePlayerControllerCurrentItemObservationContext];
    [player_ addObserver:self
             forKeyPath:kRateKey
                options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                context:TTMoviePlayerControllerRateObservationContext];
}

- (void)unregisterPlayerObservers:(AVPlayer *)player_
{
	[player_ removeObserver:self forKeyPath:kCurrentItemKey];
	[player_ removeObserver:self forKeyPath:kRateKey];
}

- (void)registerPlayerItemObservers:(AVPlayerItem *)playerItem_
{
    [playerItem_ addObserver:self
                 forKeyPath:kStatusKey
                    options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                    context:TTMoviePlayerControllerStatusObservationContext];
    [playerItem_ addObserver:self
                 forKeyPath:kLoadedTimeKey
                    options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                    context:TTMoviePlayerControllerLoadedObservationContext];
	
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:playerItem_];
}

- (void)unregisterPlayerItemObservers:(AVPlayerItem *)playerItem_
{
    [playerItem_ removeObserver:self forKeyPath:kStatusKey];
    [playerItem_ removeObserver:self forKeyPath:kLoadedTimeKey];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVPlayerItemDidPlayToEndTimeNotification
                                                  object:playerItem_];
    
}

- (void)dealloc
{
	[self removePlayerTimeObserver];
    [self unregisterPlayerObservers:player];
    [self unregisterPlayerItemObservers:playerItem];
	[player pause];

	player = nil;
}


@end
