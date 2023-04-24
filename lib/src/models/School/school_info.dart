import 'package:scolengo_api_dart/src/models/App/user.dart';
import 'package:scolengo_api_dart/src/models/School/attachment.dart';
import 'package:scolengo_api_dart/src/models/School/school.dart';
import 'package:scolengo_api_dart/src/models/globals.dart';

class SchoolInfo extends BaseResponse {
  String publicationDateTime;
  String title;
  String shortContent;
  String content;
  String? url;
  String? linkedInfoUrl;
  String? linkedWebSiteUrl;
  School school;
  User? author;
  dynamic illustration;
  dynamic attachments;
  SchoolInfo({
    required this.publicationDateTime,
    required this.title,
    required this.shortContent,
    required this.content,
    required this.url,
    required this.linkedInfoUrl,
    required this.linkedWebSiteUrl,
    required this.school,
    required this.illustration,
    required this.attachments,
    required super.id,
    this.author,
    required super.type,
  });

  static SchoolInfo fromJson(Map<String, dynamic> json) {
    print(json);
    return SchoolInfo(
      id: json['id'],
      type: json['type'],
      publicationDateTime: json['publicationDateTime'],
      title: json['title'],
      shortContent: json['shortContent'],
      content: json['content'],
      url: json['url'],
      linkedInfoUrl: json['linkedInfoUrl'],
      linkedWebSiteUrl: json['linkedWebSiteUrl'],
      school: School.fromJson(json['school']),
      author: json['author'] == null
          ? null
          : User.fromJson(json['author']['person']),
      illustration: json['illustration'] == null
          ? null
          : PublicAttachment.fromJson(json['illustration']),
      attachments: json['attachments'],
    );
  }
}
