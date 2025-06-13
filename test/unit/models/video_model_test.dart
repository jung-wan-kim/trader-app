import 'package:flutter_test/flutter_test.dart';
import 'package:trader_app/models/video_model.dart';

void main() {
  group('VideoModel Tests', () {
    late VideoModel testVideo;

    setUp(() {
      testVideo = VideoModel(
        id: 'test_001',
        videoUrl: 'https://example.com/videos/test.mp4',
        thumbnailUrl: 'https://example.com/thumbs/test.jpg',
        username: 'test_user',
        userAvatar: 'https://example.com/avatars/user.jpg',
        description: 'Test video description #trading #stocks',
        musicName: 'Original Sound - test_user',
        likes: 1500,
        comments: 45,
        shares: 12,
        isLiked: false,
      );
    });

    group('Constructor and Properties', () {
      test('should create video with all properties', () {
        expect(testVideo.id, equals('test_001'));
        expect(testVideo.videoUrl, equals('https://example.com/videos/test.mp4'));
        expect(testVideo.thumbnailUrl, equals('https://example.com/thumbs/test.jpg'));
        expect(testVideo.username, equals('test_user'));
        expect(testVideo.userAvatar, equals('https://example.com/avatars/user.jpg'));
        expect(testVideo.description, equals('Test video description #trading #stocks'));
        expect(testVideo.musicName, equals('Original Sound - test_user'));
        expect(testVideo.likes, equals(1500));
        expect(testVideo.comments, equals(45));
        expect(testVideo.shares, equals(12));
        expect(testVideo.isLiked, isFalse);
      });

      test('should handle default isLiked value', () {
        final video = VideoModel(
          id: '1',
          videoUrl: 'url',
          thumbnailUrl: 'thumb',
          username: 'user',
          userAvatar: 'avatar',
          description: 'desc',
          musicName: 'music',
          likes: 0,
          comments: 0,
          shares: 0,
        );

        expect(video.isLiked, isFalse);
      });

      test('should allow setting isLiked to true', () {
        final likedVideo = VideoModel(
          id: '1',
          videoUrl: 'url',
          thumbnailUrl: 'thumb',
          username: 'user',
          userAvatar: 'avatar',
          description: 'desc',
          musicName: 'music',
          likes: 100,
          comments: 10,
          shares: 5,
          isLiked: true,
        );

        expect(likedVideo.isLiked, isTrue);
      });
    });

    group('State Management', () {
      test('should allow modifying isLiked state', () {
        expect(testVideo.isLiked, isFalse);
        
        testVideo.isLiked = true;
        expect(testVideo.isLiked, isTrue);
        
        testVideo.isLiked = false;
        expect(testVideo.isLiked, isFalse);
      });

      test('should maintain separate states for different instances', () {
        final video1 = VideoModel(
          id: '1',
          videoUrl: 'url1',
          thumbnailUrl: 'thumb1',
          username: 'user1',
          userAvatar: 'avatar1',
          description: 'desc1',
          musicName: 'music1',
          likes: 100,
          comments: 10,
          shares: 5,
          isLiked: true,
        );

        final video2 = VideoModel(
          id: '2',
          videoUrl: 'url2',
          thumbnailUrl: 'thumb2',
          username: 'user2',
          userAvatar: 'avatar2',
          description: 'desc2',
          musicName: 'music2',
          likes: 200,
          comments: 20,
          shares: 10,
          isLiked: false,
        );

        expect(video1.isLiked, isTrue);
        expect(video2.isLiked, isFalse);
        
        video2.isLiked = true;
        expect(video1.isLiked, isTrue);
        expect(video2.isLiked, isTrue);
      });
    });

    group('Sample Data', () {
      test('should generate sample videos', () {
        final sampleVideos = VideoModel.getSampleVideos();
        
        expect(sampleVideos, isNotEmpty);
        expect(sampleVideos.length, equals(3));
      });

      test('should have valid sample video properties', () {
        final sampleVideos = VideoModel.getSampleVideos();
        
        for (final video in sampleVideos) {
          expect(video.id, isNotEmpty);
          expect(video.videoUrl, isNotEmpty);
          expect(video.thumbnailUrl, isNotEmpty);
          expect(video.username, isNotEmpty);
          expect(video.userAvatar, isNotEmpty);
          expect(video.description, isNotEmpty);
          expect(video.musicName, isNotEmpty);
          expect(video.likes, greaterThanOrEqualTo(0));
          expect(video.comments, greaterThanOrEqualTo(0));
          expect(video.shares, greaterThanOrEqualTo(0));
          expect(video.isLiked, isFalse);
        }
      });

      test('should have unique IDs for sample videos', () {
        final sampleVideos = VideoModel.getSampleVideos();
        final ids = sampleVideos.map((v) => v.id).toSet();
        
        expect(ids.length, equals(sampleVideos.length));
      });

      test('should have valid URLs for sample videos', () {
        final sampleVideos = VideoModel.getSampleVideos();
        
        for (final video in sampleVideos) {
          expect(Uri.tryParse(video.videoUrl), isNotNull);
          expect(Uri.tryParse(video.thumbnailUrl), isNotNull);
          expect(Uri.tryParse(video.userAvatar), isNotNull);
        }
      });
    });

    group('Business Logic', () {
      test('should handle videos with no engagement', () {
        final noEngagementVideo = VideoModel(
          id: 'no_engagement',
          videoUrl: 'url',
          thumbnailUrl: 'thumb',
          username: 'new_user',
          userAvatar: 'avatar',
          description: 'My first video!',
          musicName: 'Original Sound',
          likes: 0,
          comments: 0,
          shares: 0,
          isLiked: false,
        );

        expect(noEngagementVideo.likes, equals(0));
        expect(noEngagementVideo.comments, equals(0));
        expect(noEngagementVideo.shares, equals(0));
      });

      test('should handle videos with high engagement', () {
        final viralVideo = VideoModel(
          id: 'viral',
          videoUrl: 'url',
          thumbnailUrl: 'thumb',
          username: 'popular_user',
          userAvatar: 'avatar',
          description: 'This went viral!',
          musicName: 'Trending Sound',
          likes: 1000000,
          comments: 50000,
          shares: 10000,
          isLiked: true,
        );

        expect(viralVideo.likes, equals(1000000));
        expect(viralVideo.comments, equals(50000));
        expect(viralVideo.shares, equals(10000));
      });

      test('should handle empty descriptions', () {
        final noDescVideo = VideoModel(
          id: 'no_desc',
          videoUrl: 'url',
          thumbnailUrl: 'thumb',
          username: 'user',
          userAvatar: 'avatar',
          description: '',
          musicName: 'music',
          likes: 100,
          comments: 10,
          shares: 5,
        );

        expect(noDescVideo.description, isEmpty);
      });

      test('should handle long descriptions', () {
        final longDesc = 'A' * 500 + ' #hashtag';
        final longDescVideo = VideoModel(
          id: 'long_desc',
          videoUrl: 'url',
          thumbnailUrl: 'thumb',
          username: 'user',
          userAvatar: 'avatar',
          description: longDesc,
          musicName: 'music',
          likes: 100,
          comments: 10,
          shares: 5,
        );

        expect(longDescVideo.description.length, greaterThan(500));
        expect(longDescVideo.description, contains('#hashtag'));
      });
    });

    group('Edge Cases', () {
      test('should handle special characters in username', () {
        final specialUserVideo = VideoModel(
          id: 'special',
          videoUrl: 'url',
          thumbnailUrl: 'thumb',
          username: '용户_name_123!@#',
          userAvatar: 'avatar',
          description: 'desc',
          musicName: 'music',
          likes: 100,
          comments: 10,
          shares: 5,
        );

        expect(specialUserVideo.username, equals('용户_name_123!@#'));
      });

      test('should handle very large engagement numbers', () {
        final hugeNumbersVideo = VideoModel(
          id: 'huge',
          videoUrl: 'url',
          thumbnailUrl: 'thumb',
          username: 'mega_popular',
          userAvatar: 'avatar',
          description: 'desc',
          musicName: 'music',
          likes: 999999999,
          comments: 999999999,
          shares: 999999999,
        );

        expect(hugeNumbersVideo.likes, equals(999999999));
        expect(hugeNumbersVideo.comments, equals(999999999));
        expect(hugeNumbersVideo.shares, equals(999999999));
      });

      test('should handle music names with special formatting', () {
        final specialMusicVideo = VideoModel(
          id: 'music',
          videoUrl: 'url',
          thumbnailUrl: 'thumb',
          username: 'dj',
          userAvatar: 'avatar',
          description: 'desc',
          musicName: '🎵 Best Beat 2024 🎵 - DJ Master ft. Artist',
          likes: 100,
          comments: 10,
          shares: 5,
        );

        expect(specialMusicVideo.musicName, contains('🎵'));
        expect(specialMusicVideo.musicName, contains('DJ Master'));
      });

      test('should handle different URL protocols', () {
        final httpsVideo = VideoModel(
          id: '1',
          videoUrl: 'https://secure.example.com/video.mp4',
          thumbnailUrl: 'https://secure.example.com/thumb.jpg',
          username: 'user',
          userAvatar: 'https://secure.example.com/avatar.jpg',
          description: 'desc',
          musicName: 'music',
          likes: 100,
          comments: 10,
          shares: 5,
        );

        expect(httpsVideo.videoUrl, startsWith('https://'));
        expect(httpsVideo.thumbnailUrl, startsWith('https://'));
        expect(httpsVideo.userAvatar, startsWith('https://'));
      });
    });

    group('Sample Data Validation', () {
      test('should have correct video URLs in samples', () {
        final samples = VideoModel.getSampleVideos();
        
        expect(samples[0].videoUrl, contains('butterfly.mp4'));
        expect(samples[1].videoUrl, contains('bee.mp4'));
        expect(samples[2].videoUrl, contains('mov_bbb.mp4'));
      });

      test('should have Korean descriptions in samples', () {
        final samples = VideoModel.getSampleVideos();
        
        expect(samples[0].description, contains('나비'));
        expect(samples[1].description, contains('꿀벌'));
        expect(samples[2].description, contains('토끼'));
      });

      test('should have reasonable engagement numbers in samples', () {
        final samples = VideoModel.getSampleVideos();
        
        for (final video in samples) {
          expect(video.likes, greaterThan(0));
          expect(video.comments, greaterThan(0));
          expect(video.shares, greaterThan(0));
          expect(video.comments, lessThan(video.likes));
          expect(video.shares, lessThan(video.comments));
        }
      });
    });
  });
}