// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// The interface that implementations of video_player must implement.
///
/// Platform implementations should extend this class rather than implement it as `video_player`
/// does not consider newly added methods to be breaking changes. Extending this class
/// (using `extends`) ensures that the subclass will get the default implementation, while
/// platform implementations that `implements` this interface will be broken by newly added
/// [VideoPlayerPlatform] methods.
abstract class VideoPlayerPlatform extends PlatformInterface {
  /// Constructs a VideoPlayerPlatform.
  VideoPlayerPlatform() : super(token: _token);

  static final Object _token = Object();

  static VideoPlayerPlatform _instance = _PlaceholderImplementation();

  /// The instance of [VideoPlayerPlatform] to use.
  ///
  /// Defaults to a placeholder that does not override any methods, and thus
  /// throws `UnimplementedError` in most cases.
  static VideoPlayerPlatform get instance => _instance;

  /// Platform-specific plugins should override this with their own
  /// platform-specific class that extends [VideoPlayerPlatform] when they
  /// register themselves.
  static set instance(VideoPlayerPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Initializes the platform interface and disposes all existing players.
  ///
  /// This method is called when the plugin is first initialized
  /// and on every full restart.
  Future<void> init() {
    throw UnimplementedError('init() has not been implemented.');
  }

  /// Clears one video.
  Future<void> dispose(int textureId) {
    throw UnimplementedError('dispose() has not been implemented.');
  }

  /// Creates an instance of a video player and returns its textureId.
  Future<void> setupMux(int textureId, MuxConfig config) {
    throw UnimplementedError('setupMux() has not been implemented.');
  }

  /// Creates an instance of a video player and returns its textureId.
  Future<int?> create(DataSource dataSource) {
    throw UnimplementedError('create() has not been implemented.');
  }

  /// Returns a Stream of [VideoEventType]s.
  Stream<VideoEvent> videoEventsFor(int textureId) {
    throw UnimplementedError('videoEventsFor() has not been implemented.');
  }

  /// Sets the looping attribute of the video.
  Future<void> setLooping(int textureId, bool looping) {
    throw UnimplementedError('setLooping() has not been implemented.');
  }

  /// Starts the video playback.
  Future<void> play(int textureId) {
    throw UnimplementedError('play() has not been implemented.');
  }

  /// Stops the video playback.
  Future<void> pause(int textureId) {
    throw UnimplementedError('pause() has not been implemented.');
  }

  /// Sets the volume to a range between 0.0 and 1.0.
  Future<void> setVolume(int textureId, double volume) {
    throw UnimplementedError('setVolume() has not been implemented.');
  }

  /// Sets the video position to a [Duration] from the start.
  Future<void> seekTo(int textureId, Duration position) {
    throw UnimplementedError('seekTo() has not been implemented.');
  }

  /// Sets the playback speed to a [speed] value indicating the playback rate.
  Future<void> setPlaybackSpeed(int textureId, double speed) {
    throw UnimplementedError('setPlaybackSpeed() has not been implemented.');
  }

  /// Gets the video position as [Duration] from the start.
  Future<Duration> getPosition(int textureId) {
    throw UnimplementedError('getPosition() has not been implemented.');
  }

  /// Returns a widget displaying the video with a given textureID.
  Widget buildView(int textureId) {
    throw UnimplementedError('buildView() has not been implemented.');
  }

  /// Sets the audio mode to mix with other sources
  Future<void> setMixWithOthers(bool mixWithOthers) {
    throw UnimplementedError('setMixWithOthers() has not been implemented.');
  }
}

class _PlaceholderImplementation extends VideoPlayerPlatform {}

/// Description of the data source used to create an instance of
/// the video player.
class DataSource {
  /// Constructs an instance of [DataSource].
  ///
  /// The [sourceType] is always required.
  ///
  /// The [uri] argument takes the form of `'https://example.com/video.mp4'` or
  /// `'file:///absolute/path/to/local/video.mp4`.
  ///
  /// The [formatHint] argument can be null.
  ///
  /// The [asset] argument takes the form of `'assets/video.mp4'`.
  ///
  /// The [package] argument must be non-null when the asset comes from a
  /// package and null otherwise.
  DataSource({
    required this.sourceType,
    this.uri,
    this.formatHint,
    this.asset,
    this.package,
    this.httpHeaders = const <String, String>{},
  });

  /// The way in which the video was originally loaded.
  ///
  /// This has nothing to do with the video's file type. It's just the place
  /// from which the video is fetched from.
  final DataSourceType sourceType;

  /// The URI to the video file.
  ///
  /// This will be in different formats depending on the [DataSourceType] of
  /// the original video.
  final String? uri;

  /// **Android only**. Will override the platform's generic file format
  /// detection with whatever is set here.
  final VideoFormat? formatHint;

  /// HTTP headers used for the request to the [uri].
  /// Only for [DataSourceType.network] videos.
  /// Always empty for other video types.
  Map<String, String> httpHeaders;

  /// The name of the asset. Only set for [DataSourceType.asset] videos.
  final String? asset;

  /// The package that the asset was loaded from. Only set for
  /// [DataSourceType.asset] videos.
  final String? package;
}

/// The way in which the video was originally loaded.
///
/// This has nothing to do with the video's file type. It's just the place
/// from which the video is fetched from.
enum DataSourceType {
  /// The video was included in the app's asset files.
  asset,

  /// The video was downloaded from the internet.
  network,

  /// The video was loaded off of the local filesystem.
  file,

  /// The video is available via contentUri. Android only.
  contentUri,
}

/// The file format of the given video.
enum VideoFormat {
  /// Dynamic Adaptive Streaming over HTTP, also known as MPEG-DASH.
  dash,

  /// HTTP Live Streaming.
  hls,

  /// Smooth Streaming.
  ss,

  /// Any format other than the other ones defined in this enum.
  other,
}

/// Event emitted from the platform implementation.
@immutable
class VideoEvent {
  /// Creates an instance of [VideoEvent].
  ///
  /// The [eventType] argument is required.
  ///
  /// Depending on the [eventType], the [duration], [size],
  /// [rotationCorrection], and [buffered] arguments can be null.
  // TODO(stuartmorgan): Temporarily suppress warnings about not using const
  // in all of the other video player packages, fix this, and then update
  // the other packages to use const.
  // ignore: prefer_const_constructors_in_immutables
  VideoEvent({
    required this.eventType,
    this.duration,
    this.size,
    this.rotationCorrection,
    this.buffered,
  });

  /// The type of the event.
  final VideoEventType eventType;

  /// Duration of the video.
  ///
  /// Only used if [eventType] is [VideoEventType.initialized].
  final Duration? duration;

  /// Size of the video.
  ///
  /// Only used if [eventType] is [VideoEventType.initialized].
  final Size? size;

  /// Degrees to rotate the video (clockwise) so it is displayed correctly.
  ///
  /// Only used if [eventType] is [VideoEventType.initialized].
  final int? rotationCorrection;

  /// Buffered parts of the video.
  ///
  /// Only used if [eventType] is [VideoEventType.bufferingUpdate].
  final List<DurationRange>? buffered;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is VideoEvent &&
            runtimeType == other.runtimeType &&
            eventType == other.eventType &&
            duration == other.duration &&
            size == other.size &&
            rotationCorrection == other.rotationCorrection &&
            listEquals(buffered, other.buffered);
  }

  @override
  int get hashCode => Object.hash(
        eventType,
        duration,
        size,
        rotationCorrection,
        buffered,
      );
}

/// Type of the event.
///
/// Emitted by the platform implementation when the video is initialized or
/// completed or to communicate buffering events.
enum VideoEventType {
  /// The video has been initialized.
  initialized,

  /// The playback has ended.
  completed,

  /// Updated information on the buffering state.
  bufferingUpdate,

  /// The video started to buffer.
  bufferingStart,

  /// The video stopped to buffer.
  bufferingEnd,

  /// An unknown event has been received.
  unknown,
}

/// Describes a discrete segment of time within a video using a [start] and
/// [end] [Duration].
@immutable
class DurationRange {
  /// Trusts that the given [start] and [end] are actually in order. They should
  /// both be non-null.
  // TODO(stuartmorgan): Temporarily suppress warnings about not using const
  // in all of the other video player packages, fix this, and then update
  // the other packages to use const.
  // ignore: prefer_const_constructors_in_immutables
  DurationRange(this.start, this.end);

  /// The beginning of the segment described relative to the beginning of the
  /// entire video. Should be shorter than or equal to [end].
  ///
  /// For example, if the entire video is 4 minutes long and the range is from
  /// 1:00-2:00, this should be a `Duration` of one minute.
  final Duration start;

  /// The end of the segment described as a duration relative to the beginning of
  /// the entire video. This is expected to be non-null and longer than or equal
  /// to [start].
  ///
  /// For example, if the entire video is 4 minutes long and the range is from
  /// 1:00-2:00, this should be a `Duration` of two minutes.
  final Duration end;

  /// Assumes that [duration] is the total length of the video that this
  /// DurationRange is a segment form. It returns the percentage that [start] is
  /// through the entire video.
  ///
  /// For example, assume that the entire video is 4 minutes long. If [start] has
  /// a duration of one minute, this will return `0.25` since the DurationRange
  /// starts 25% of the way through the video's total length.
  double startFraction(Duration duration) {
    return start.inMilliseconds / duration.inMilliseconds;
  }

  /// Assumes that [duration] is the total length of the video that this
  /// DurationRange is a segment form. It returns the percentage that [start] is
  /// through the entire video.
  ///
  /// For example, assume that the entire video is 4 minutes long. If [end] has a
  /// duration of two minutes, this will return `0.5` since the DurationRange
  /// ends 50% of the way through the video's total length.
  double endFraction(Duration duration) {
    return end.inMilliseconds / duration.inMilliseconds;
  }

  @override
  String toString() =>
      '${objectRuntimeType(this, 'DurationRange')}(start: $start, end: $end)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DurationRange &&
          runtimeType == other.runtimeType &&
          start == other.start &&
          end == other.end;

  @override
  int get hashCode => Object.hash(start, end);
}

/// [VideoPlayerOptions] can be optionally used to set additional player settings
@immutable
class VideoPlayerOptions {
  /// set additional optional player settings
  // TODO(stuartmorgan): Temporarily suppress warnings about not using const
  // in all of the other video player packages, fix this, and then update
  // the other packages to use const.
  // ignore: prefer_const_constructors_in_immutables
  VideoPlayerOptions({
    this.mixWithOthers = false,
    this.allowBackgroundPlayback = false,
  });

  /// Set this to true to keep playing video in background, when app goes in background.
  /// The default value is false.
  final bool allowBackgroundPlayback;

  /// Set this to true to mix the video players audio with other audio sources.
  /// The default value is false
  ///
  /// Note: This option will be silently ignored in the web platform (there is
  /// currently no way to implement this feature in this platform).
  final bool mixWithOthers;
}

/// Configuration parameters to send to Mux.
class MuxConfig {
  /// constructor
  const MuxConfig({
    required this.envKey,
    required this.playerName,
    this.viewerUserId,
    this.pageType,
    this.experimentName,
    this.subPropertyId,
    this.playerVersion,
    this.playerInitTime,
    this.videoId,
    this.videoTitle,
    this.videoSeries,
    this.videoVariantName,
    this.videoVariantId,
    this.videoLanguageCode,
    this.videoContentType,
    this.videoDuration,
    this.videoStreamType,
    this.videoProducer,
    this.videoEncodingVariant,
    this.videoCdn,
    this.customData1,
    this.customData2,
  });

  /// Your env key from the Mux dashboard. Note this was previously named property_key
  final String envKey;

  /// If you have different configurations or types of players around your
  /// site or application you can use player_name to compare them. This is not the
  /// player software (e.g. Video.js), which is tracked automatically by the SDK.
  final String playerName;

  /// An ID representing the viewer who is watching the stream.
  /// Use this to look up video views for an individual viewer.
  final String? viewerUserId;

  /// Provide the context of the page for more specific analysis.
  /// Values include `watchpage`, `iframe`, or leave empty.
  final MuxPageType? pageType;

  /// You can use this field to separate views into different experiments,
  /// if you would like to filter by this dimension later. This should be a string value,
  /// but your account is limited to a total of 10 unique experiment names,
  /// so be sure that this value is not generated dynamically or randomly.
  final String? experimentName;

  /// A sub property is an optional way to group data within a property.
  /// For example, sub properties may be used by a video platform to group data by its own
  /// customers, or a media company might use them to distinguish between its many websites.
  final String? subPropertyId;

  /// As you make changes to your player you can compare how new versions of your player
  /// perform by updating this value. This is not the player software version
  /// (e.g. Video.js 5.0.0), which is tracked automatically by the SDK.
  final String? playerVersion;

  /// If you are explicitly loading your player in page (perhaps as a response to a user interaction),
  /// include the timestamp (milliseconds since Jan 1 1970) when you initialize the player
  /// in order to accurately track page load time and player startup time.
  final DateTime? playerInitTime;

  /// Your internal ID for the video
  final String? videoId;

  /// example: 'Awesome Show: Pilot'
  final String? videoTitle;

  /// example: 'Season 1'
  final String? videoSeries;

  /// An optional detail that allows you to monitor issues with the files of specific versions of the content,
  /// for example different audio translations or versions with hard-coded/burned-in subtitles.
  final String? videoVariantName;

  /// Your internal ID for a video variant
  final String? videoVariantId;

  /// The audio language of the video, assuming it's unchangeable after playing.
  final String? videoLanguageCode;

  /// 'short', 'movie', 'episode', 'clip', 'trailer', or 'event'
  final String? videoContentType;

  /// The length of the video in milliseconds
  final Duration? videoDuration;

  /// 'live' or 'onDemand'
  final MuxVideoStreamType? videoStreamType;

  /// The producer of the video title
  final String? videoProducer;

  /// An optional detail that allows you to compare different encoding settings.
  final String? videoEncodingVariant;

  /// An optional detail that allows you to compare different CDNs (assuming the CDN selection is made at page load time).
  final String? videoCdn;
  
  /// An optional data strongly related to the customers of Mux. #1 Custom Data.
  final String? customData1;

  /// An optional data strongly related to the customers of Mux. #1 Custom Data.
  final String? customData2;
}

/// Type of stream to Mux Analytics
enum MuxVideoStreamType {
  /// It's a live stream
  livestream,

  /// It's an on-demand video
  onDemand,
}

/// Type of page to Mux Analytics
enum MuxPageType {
  /// A web page that is dedicated to playing a specific video (for example youtube.com/watch/ID or hulu.com/watch/ID)
  watchpage,

  /// An iframe specifically used to embed a player on different sites/pages
  iframe,
}
