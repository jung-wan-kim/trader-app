import 'package:flutter_test/flutter_test.dart';
import 'package:trader_app/models/video_model.dart';
import '../../helpers/test_helper.dart';

void main() {
  group('VideoModel Tests', () {
    late VideoModel mockVideo;

    setUp(() {
      mockVideo = TestHelper.createMockVideoModel();
    });

    group('Constructor', () {
      test('should create instance with all required fields', () {
        expect(mockVideo.id, 'video-1');
        expect(mockVideo.videoUrl, 'https://example.com/video.mp4');
        expect(mockVideo.thumbnailUrl, 'https://example.com/thumbnail.jpg');
        expect(mockVideo.username, 'test_user');
        expect(mockVideo.userAvatar, 'https://example.com/avatar.jpg');
        expect(mockVideo.description, 'Test video description');
        expect(mockVideo.musicName, 'Test Music - Artist');
        expect(mockVideo.likes, 1000);
        expect(mockVideo.comments, 50);
        expect(mockVideo.shares, 25);
        expect(mockVideo.isLiked, isFalse);
      });

      test('should set default value for isLiked', () {
        final video = VideoModel(
          id: 'test',
          videoUrl: 'https://example.com/video.mp4',
          thumbnailUrl: 'https://example.com/thumb.jpg',
          username: 'test_user',
          userAvatar: 'https://example.com/avatar.jpg',
          description: 'Test description',
          musicName: 'Test Music',
          likes: 100,
          comments: 10,
          shares: 5,
          // isLiked not specified, should default to false
        );

        expect(video.isLiked, isFalse);
      });

      test('should handle isLiked parameter correctly', () {
        final likedVideo = TestHelper.createMockVideoModel(isLiked: true);
        expect(likedVideo.isLiked, isTrue);

        final notLikedVideo = TestHelper.createMockVideoModel(isLiked: false);
        expect(notLikedVideo.isLiked, isFalse);
      });

      test('should handle zero and negative values', () {
        final video = VideoModel(
          id: 'zero-stats',
          videoUrl: 'https://example.com/video.mp4',
          thumbnailUrl: 'https://example.com/thumb.jpg',
          username: 'new_user',
          userAvatar: 'https://example.com/avatar.jpg',
          description: 'New video',
          musicName: 'Original Sound',
          likes: 0,
          comments: 0,
          shares: 0,
          isLiked: false,
        );

        expect(video.likes, 0);
        expect(video.comments, 0);
        expect(video.shares, 0);
      });
    });

    group('State Mutation', () {
      test('isLiked should be mutable', () {
        final video = TestHelper.createMockVideoModel(isLiked: false);
        expect(video.isLiked, isFalse);

        video.isLiked = true;
        expect(video.isLiked, isTrue);

        video.isLiked = false;
        expect(video.isLiked, isFalse);
      });

      test('should handle like state toggling', () {
        final video = TestHelper.createMockVideoModel();
        final originalLikedState = video.isLiked;

        // Toggle like state
        video.isLiked = !video.isLiked;
        expect(video.isLiked, !originalLikedState);

        // Toggle back
        video.isLiked = !video.isLiked;
        expect(video.isLiked, originalLikedState);
      });
    });

    group('Sample Data Generation', () {
      test('getSampleVideos should return non-empty list', () {
        final sampleVideos = VideoModel.getSampleVideos();
        expect(sampleVideos, isNotEmpty);
      });

      test('getSampleVideos should return exactly 3 videos', () {
        final sampleVideos = VideoModel.getSampleVideos();
        expect(sampleVideos, hasLength(3));
      });

      test('getSampleVideos should return valid VideoModel instances', () {
        final sampleVideos = VideoModel.getSampleVideos();
        
        for (VideoModel video in sampleVideos) {
          expect(video, isA<VideoModel>());
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
        }
      });

      test('getSampleVideos should have unique IDs', () {
        final sampleVideos = VideoModel.getSampleVideos();
        final ids = sampleVideos.map((video) => video.id).toList();
        final uniqueIds = ids.toSet();
        
        expect(uniqueIds.length, equals(ids.length));
      });

      test('getSampleVideos should have realistic data', () {
        final sampleVideos = VideoModel.getSampleVideos();
        
        // Check first video
        final firstVideo = sampleVideos[0];
        expect(firstVideo.id, '1');
        expect(firstVideo.username, 'nature_lover');
        expect(firstVideo.description, contains('나비'));
        expect(firstVideo.likes, 12500);
        expect(firstVideo.comments, 234);
        expect(firstVideo.shares, 56);

        // Check second video
        final secondVideo = sampleVideos[1];
        expect(secondVideo.id, '2');
        expect(secondVideo.username, 'bee_keeper');
        expect(secondVideo.description, contains('꿀벌'));

        // Check third video
        final thirdVideo = sampleVideos[2];
        expect(thirdVideo.id, '3');
        expect(thirdVideo.username, 'animation_world');
        expect(thirdVideo.description, contains('토끼'));
      });

      test('getSampleVideos should have valid URLs', () {
        final sampleVideos = VideoModel.getSampleVideos();
        
        for (VideoModel video in sampleVideos) {
          expect(video.videoUrl, startsWith('http'));
          expect(video.thumbnailUrl, startsWith('http'));
          expect(video.userAvatar, startsWith('http'));
        }
      });

      test('getSampleVideos should have reasonable engagement metrics', () {
        final sampleVideos = VideoModel.getSampleVideos();
        
        for (VideoModel video in sampleVideos) {
          // Likes should be more than comments
          expect(video.likes, greaterThan(video.comments));
          
          // Comments should be more than shares (typically)
          expect(video.comments, greaterThan(video.shares));
          
          // All metrics should be positive
          expect(video.likes, greaterThan(0));
          expect(video.comments, greaterThan(0));
          expect(video.shares, greaterThan(0));
        }
      });
    });

    group('URL Validation', () {
      test('should handle various video URL formats', () {
        final validUrls = [
          'https://example.com/video.mp4',
          'http://example.com/video.mov',
          'https://cdn.example.com/videos/sample.avi',
          'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
        ];

        for (String url in validUrls) {
          final video = VideoModel(
            id: 'test',
            videoUrl: url,
            thumbnailUrl: 'https://example.com/thumb.jpg',
            username: 'test_user',
            userAvatar: 'https://example.com/avatar.jpg',
            description: 'Test',
            musicName: 'Test Music',
            likes: 100,
            comments: 10,
            shares: 5,
          );

          expect(video.videoUrl, url);
        }
      });

      test('should handle various thumbnail URL formats', () {
        final validThumbnails = [
          'https://example.com/thumb.jpg',
          'https://picsum.photos/360/640?random=1',
          'https://cdn.example.com/thumbs/video1.png',
        ];

        for (String thumbnailUrl in validThumbnails) {
          final video = VideoModel(
            id: 'test',
            videoUrl: 'https://example.com/video.mp4',
            thumbnailUrl: thumbnailUrl,
            username: 'test_user',
            userAvatar: 'https://example.com/avatar.jpg',
            description: 'Test',
            musicName: 'Test Music',
            likes: 100,
            comments: 10,
            shares: 5,
          );

          expect(video.thumbnailUrl, thumbnailUrl);
        }
      });

      test('should handle various avatar URL formats', () {
        final validAvatars = [
          'https://example.com/avatar.jpg',
          'https://picsum.photos/100/100?random=1',
          'https://ui-avatars.com/api/?name=User',
        ];

        for (String avatarUrl in validAvatars) {
          final video = VideoModel(
            id: 'test',
            videoUrl: 'https://example.com/video.mp4',
            thumbnailUrl: 'https://example.com/thumb.jpg',
            username: 'test_user',
            userAvatar: avatarUrl,
            description: 'Test',
            musicName: 'Test Music',
            likes: 100,
            comments: 10,
            shares: 5,
          );

          expect(video.userAvatar, avatarUrl);
        }
      });
    });

    group('Content Validation', () {
      test('should handle various username formats', () {
        final validUsernames = [
          'test_user',
          'nature_lover',
          'user123',
          'UserName',
          'user.name',
          'user-name',
        ];

        for (String username in validUsernames) {
          final video = TestHelper.createMockVideoModel(username: username);
          expect(video.username, username);
        }
      });

      test('should handle various description lengths and formats', () {
        final descriptions = [
          'Short desc',
          '아름다운 나비의 날갯짓 🦋',
          'A very long description that contains multiple sentences and explains what is happening in the video in great detail.',
          'Description with emojis 🎵🎬🎭',
          'Description with hashtags #nature #beautiful #video',
          '', // Empty description
        ];

        for (String description in descriptions) {
          final video = VideoModel(
            id: 'test',
            videoUrl: 'https://example.com/video.mp4',
            thumbnailUrl: 'https://example.com/thumb.jpg',
            username: 'test_user',
            userAvatar: 'https://example.com/avatar.jpg',
            description: description,
            musicName: 'Test Music',
            likes: 100,
            comments: 10,
            shares: 5,
          );

          expect(video.description, description);
        }
      });

      test('should handle various music name formats', () {
        final musicNames = [
          'Original Sound - user_name',
          'Test Music - Artist',
          'Buzzing Beats - DJ Honey',
          'Adventure Time - Cartoon Network',
          'Classical Music',
          'No Music',
        ];

        for (String musicName in musicNames) {
          final video = VideoModel(
            id: 'test',
            videoUrl: 'https://example.com/video.mp4',
            thumbnailUrl: 'https://example.com/thumb.jpg',
            username: 'test_user',
            userAvatar: 'https://example.com/avatar.jpg',
            description: 'Test',
            musicName: musicName,
            likes: 100,
            comments: 10,
            shares: 5,
          );

          expect(video.musicName, musicName);
        }
      });
    });

    group('Engagement Metrics', () {
      test('should handle large engagement numbers', () {
        final video = VideoModel(
          id: 'viral-video',
          videoUrl: 'https://example.com/viral.mp4',
          thumbnailUrl: 'https://example.com/thumb.jpg',
          username: 'viral_user',
          userAvatar: 'https://example.com/avatar.jpg',
          description: 'Viral video',
          musicName: 'Trending Song',
          likes: 1000000, // 1 million likes
          comments: 50000, // 50k comments
          shares: 25000, // 25k shares
        );

        expect(video.likes, 1000000);
        expect(video.comments, 50000);
        expect(video.shares, 25000);
      });

      test('should handle zero engagement', () {
        final video = VideoModel(
          id: 'new-video',
          videoUrl: 'https://example.com/new.mp4',
          thumbnailUrl: 'https://example.com/thumb.jpg',
          username: 'new_user',
          userAvatar: 'https://example.com/avatar.jpg',
          description: 'Brand new video',
          musicName: 'Original Sound',
          likes: 0,
          comments: 0,
          shares: 0,
        );

        expect(video.likes, 0);
        expect(video.comments, 0);
        expect(video.shares, 0);
      });

      test('should maintain engagement ratio consistency', () {
        final sampleVideos = VideoModel.getSampleVideos();
        
        for (VideoModel video in sampleVideos) {
          // Typically likes > comments > shares
          expect(video.likes, greaterThanOrEqualTo(video.comments));
          // Comments don't always have to be greater than shares, but should be reasonable
          expect(video.comments, greaterThanOrEqualTo(0));
          expect(video.shares, greaterThanOrEqualTo(0));
        }
      });
    });

    group('Edge Cases', () {
      test('should handle special characters in content', () {
        final video = VideoModel(
          id: 'special-chars',
          videoUrl: 'https://example.com/video.mp4',
          thumbnailUrl: 'https://example.com/thumb.jpg',
          username: 'user_with_émojis',
          userAvatar: 'https://example.com/avatar.jpg',
          description: 'Special chars: éñ中文🎵@#\$%^&*()',
          musicName: 'Müsic Ñame - Àrtist',
          likes: 100,
          comments: 10,
          shares: 5,
        );

        expect(video.username, contains('émojis'));
        expect(video.description, contains('中文'));
        expect(video.musicName, contains('Müsic'));
      });

      test('should handle very long content', () {
        final longDescription = 'A' * 1000; // 1000 character description
        final longMusicName = 'Very Long Music Name ' * 10; // Very long music name

        final video = VideoModel(
          id: 'long-content',
          videoUrl: 'https://example.com/video.mp4',
          thumbnailUrl: 'https://example.com/thumb.jpg',
          username: 'test_user',
          userAvatar: 'https://example.com/avatar.jpg',
          description: longDescription,
          musicName: longMusicName,
          likes: 100,
          comments: 10,
          shares: 5,
        );

        expect(video.description.length, 1000);
        expect(video.musicName.length, greaterThan(100));
      });

      test('should handle negative engagement numbers', () {
        // While negative engagement doesn't make business sense,
        // the model should technically handle it
        final video = VideoModel(
          id: 'negative-stats',
          videoUrl: 'https://example.com/video.mp4',
          thumbnailUrl: 'https://example.com/thumb.jpg',
          username: 'test_user',
          userAvatar: 'https://example.com/avatar.jpg',
          description: 'Test',
          musicName: 'Test Music',
          likes: -10,
          comments: -5,
          shares: -2,
        );

        expect(video.likes, -10);
        expect(video.comments, -5);
        expect(video.shares, -2);
      });
    });

    group('Memory and Performance', () {
      test('should handle creation of many video instances', () {
        final videos = <VideoModel>[];
        
        for (int i = 0; i < 1000; i++) {
          videos.add(VideoModel(
            id: 'video-$i',
            videoUrl: 'https://example.com/video$i.mp4',
            thumbnailUrl: 'https://example.com/thumb$i.jpg',
            username: 'user$i',
            userAvatar: 'https://example.com/avatar$i.jpg',
            description: 'Description for video $i',
            musicName: 'Music $i',
            likes: i * 10,
            comments: i * 2,
            shares: i,
          ));
        }

        expect(videos, hasLength(1000));
        expect(videos.first.id, 'video-0');
        expect(videos.last.id, 'video-999');
      });

      test('should have consistent behavior across multiple calls', () {
        final sampleVideos1 = VideoModel.getSampleVideos();
        final sampleVideos2 = VideoModel.getSampleVideos();

        expect(sampleVideos1.length, equals(sampleVideos2.length));
        
        for (int i = 0; i < sampleVideos1.length; i++) {
          expect(sampleVideos1[i].id, equals(sampleVideos2[i].id));
          expect(sampleVideos1[i].username, equals(sampleVideos2[i].username));
          expect(sampleVideos1[i].likes, equals(sampleVideos2[i].likes));
        }
      });
    });

    group('Business Logic Scenarios', () {
      test('should support like functionality workflow', () {
        final video = TestHelper.createMockVideoModel(
          likes: 1000,
          isLiked: false,
        );

        // User likes the video
        video.isLiked = true;
        expect(video.isLiked, isTrue);
        // Note: In a real app, likes count would be incremented by the backend

        // User unlikes the video
        video.isLiked = false;
        expect(video.isLiked, isFalse);
      });

      test('should represent different types of content', () {
        final videos = VideoModel.getSampleVideos();
        
        // Should have different usernames (different creators)
        final usernames = videos.map((v) => v.username).toSet();
        expect(usernames.length, equals(videos.length));
        
        // Should have different engagement levels
        final likeCounts = videos.map((v) => v.likes).toList();
        expect(likeCounts.toSet().length, greaterThan(1));
      });

      test('should handle viral vs regular content', () {
        final regularVideo = VideoModel(
          id: 'regular',
          videoUrl: 'https://example.com/regular.mp4',
          thumbnailUrl: 'https://example.com/thumb.jpg',
          username: 'regular_user',
          userAvatar: 'https://example.com/avatar.jpg',
          description: 'Regular content',
          musicName: 'Original Sound',
          likes: 50,
          comments: 5,
          shares: 2,
        );

        final viralVideo = VideoModel(
          id: 'viral',
          videoUrl: 'https://example.com/viral.mp4',
          thumbnailUrl: 'https://example.com/thumb.jpg',
          username: 'viral_creator',
          userAvatar: 'https://example.com/avatar.jpg',
          description: 'Viral content that everyone loves!',
          musicName: 'Trending Song',
          likes: 500000,
          comments: 25000,
          shares: 10000,
        );

        expect(viralVideo.likes, greaterThan(regularVideo.likes * 1000));
        expect(viralVideo.comments, greaterThan(regularVideo.comments * 1000));
        expect(viralVideo.shares, greaterThan(regularVideo.shares * 1000));
      });
    });
  });
}