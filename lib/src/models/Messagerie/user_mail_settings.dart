import 'package:scolengo_api/src/models/App/user.dart';
import 'package:scolengo_api/src/models/globals.dart';

class UsersMailSettings extends BaseResponse {
  num maxCharsInParticipationContent;
  num maxCharsInCommunicationSubject;
  List<Folder> folders;
  Signature signature;
  List<Contact> contacts;
  UsersMailSettings({
    required this.maxCharsInParticipationContent,
    required this.maxCharsInCommunicationSubject,
    required this.folders,
    required this.signature,
    required this.contacts,
    required super.id,
    required super.type,
  });
  static UsersMailSettings fromJson(Map<String, dynamic> json) {
    return UsersMailSettings(
      id: json['id'],
      type: json['type'],
      maxCharsInParticipationContent: json['maxCharsInParticipationContent'],
      maxCharsInCommunicationSubject: json['maxCharsInCommunicationSubject'],
      folders: json['folders']
          .map<Folder>((folder) => Folder.fromJson(folder))
          .toList(),
      signature: Signature.fromJson(json['signature']),
      contacts: json['contacts']
          .map<Contact>((contact) => Contact.fromJson(contact))
          .toList(),
    );
  }
}

// ignore: constant_identifier_names
enum FolderType { INBOX, SENT, DRAFTS, TRASH, PERSONAL, MODERATION }

class Folder extends BaseResponse {
  String name;
  FolderType folderType;
  int position;

  Folder({
    required this.name,
    required this.folderType,
    required this.position,
    required super.id,
    required super.type,
  });

  static Folder fromJson(Map<String, dynamic> json) {
    return Folder(
      id: json['id'],
      type: json['type'],
      name: json['name'],
      folderType: FolderType.values.firstWhere(
          (element) => element.toString() == 'FolderType.${json['type']}'),
      position: json['position'],
    );
  }
}

class Signature extends BaseResponse {
  String content;
  Signature({
    required this.content,
    required super.id,
    required super.type,
  });

  static Signature fromJson(Map<String, dynamic> json) {
    return Signature(
      id: json['id'],
      type: json['type'],
      content: json['content'],
    );
  }
}

class PersonContact extends Contact {
  String? name;
  List<LinkWithUser>? linksWithUser;
  User? person;
  PersonContact({
    required this.name,
    required this.linksWithUser,
    required this.person,
    required super.id,
    required super.type,
  });

  static PersonContact fromJson(Map<String, dynamic> json) {
    return PersonContact(
      id: json['id'],
      type: json['type'],
      name: json['name'],
      linksWithUser: json['linksWithUser']
          ?.map<LinkWithUser>((link) => LinkWithUser.fromJson(link))
          .toList(),
      person: json['person'] == null ? null : User.fromJson(json['person']),
    );
  }
}

abstract class Contact extends BaseResponse {
  Contact({required super.id, required super.type});

  static Contact fromJson(Map<String, dynamic> json) {
    if (json['type'] == 'personContact') {
      return PersonContact.fromJson(json);
    } else if (json['type'] == 'groupContact') {
      return GroupContact.fromJson(json);
    }
    throw UnimplementedError('Unsupported contact type: ${json['type']}');
  }
}

class GroupContact extends Contact {
  String? label;
  List<LinkWithUser>? linksWithUser;
  List<PersonContact>? personContacts;
  GroupContact({
    required this.label,
    required this.linksWithUser,
    this.personContacts,
    required super.id,
    required super.type,
  });

  static GroupContact fromJson(Map<String, dynamic> json) {
    return GroupContact(
      id: json['id'],
      type: json['type'],
      label: json['label'],
      linksWithUser: json['linksWithUser']
          ?.map<LinkWithUser>((link) => LinkWithUser.fromJson(link))
          .toList(),
      personContacts: json['personContacts']
          ?.map<PersonContact>((contact) => PersonContact.fromJson(contact))
          .toList(),
    );
  }
}

// ignore: constant_identifier_names
enum LinkType { FAMILY, GROUP, SCHOOL }

class LinkWithUser {
  LinkType type;
  String? description;
  String? groupId;
  List<dynamic>? additionalInfos;
  LinkWithUser({
    required this.type,
    this.description,
    this.groupId,
    this.additionalInfos,
  });

  static LinkWithUser fromJson(Map<String, dynamic> json) {
    return LinkWithUser(
      type: LinkType.values.firstWhere(
          (element) => element.toString() == 'LinkType.${json['type']}'),
      description: json['description'],
      groupId: json['groupId'],
      additionalInfos: json['additionalInfos'],
    );
  }
}
