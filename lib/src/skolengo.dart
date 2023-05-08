// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' hide Client;
import 'package:japx/japx.dart';
import 'package:openid_client/openid_client.dart';
import 'package:scolengo_api/src/models/Agenda/agenda.dart';
import 'package:scolengo_api/src/models/Agenda/lesson.dart';
import 'package:scolengo_api/src/models/App/current_config.dart';
import 'package:scolengo_api/src/models/App/user.dart';
import 'package:scolengo_api/src/models/Assiduite/absence_file.dart';
import 'package:scolengo_api/src/models/Assiduite/absence_reason.dart';
import 'package:scolengo_api/src/models/Evaluation/evaluation.dart';
import 'package:scolengo_api/src/models/Evaluation/evaluation_settings.dart';
import 'package:scolengo_api/src/models/Evaluation/preiodic_reports_file.dart';
import 'package:scolengo_api/src/models/Homework/homework_assignments.dart';
import 'package:scolengo_api/src/models/Messagerie/communication.dart';
import 'package:scolengo_api/src/models/Messagerie/participant.dart';
import 'package:scolengo_api/src/models/Messagerie/participation.dart';
import 'package:scolengo_api/src/models/Messagerie/user_mail_settings.dart';
import 'package:scolengo_api/src/models/School/school.dart';
import 'package:scolengo_api/src/models/School/school_info.dart';
import 'package:scolengo_api/src/models/cache_provider.dart';
import 'package:scolengo_api/src/models/globals.dart';

class Skolengo {
  static const url = 'https://api.skolengo.com/api/v1/bff-sko-app';
  late final Map<String, String> headers;
  final Credential? credentials;
  final CacheProvider? cacheProvider;
  final bool debug;
  static final OID_CLIENT_ID = String.fromCharCodes(
    base64.decode(
        'U2tvQXBwLlByb2QuMGQzNDkyMTctOWE0ZS00MWVjLTlhZjktZGY5ZTY5ZTA5NDk0'),
  );
  static final OID_CLIENT_SECRET = String.fromCharCodes(
    base64.decode('N2NiNGQ5YTgtMjU4MC00MDQxLTlhZTgtZDU4MDM4NjkxODNm'),
  );

  factory Skolengo.unauthenticated() {
    return Skolengo(credentials: null, headers: {});
  }
  factory Skolengo.fromCredentials(
    Credential credentials,
    School school, {
    Map<String, String>? additionnalHeaders,
    CacheProvider? cacheProvider,
    bool debug = false,
  }) {
    final headers = <String, String>{};
    headers.addAll({
      'Authorization':
          'Bearer ${TokenResponse.fromJson(credentials.response!).accessToken}',
      'X-Skolengo-Date-Format': 'utc',
      'X-Skolengo-School-Id': school.id,
      'X-Skolengo-Ems-Code': school.emsCode!,
    });
    if (additionnalHeaders != null) {
      headers.addAll(additionnalHeaders);
    }
    return Skolengo(
      credentials: credentials,
      headers: headers,
      cacheProvider: cacheProvider,
      debug: debug,
    );
  }

  Skolengo({
    required this.headers,
    this.credentials,
    this.cacheProvider,
    this.debug = false,
  });

  Future<Map<String, dynamic>> _invokeApi(
    String path,
    String method, {
    Map<String, String>? headers,
    Map<String, String>? params,
    Object? body,
    int numTries = 0,
  }) async {
    final stopwatch = Stopwatch()..start();
    if (numTries > 3) {
      throw Exception('Too many tries');
    }

    final paramString = params == null || params.isEmpty
        ? ''
        : '?${params.entries.map((e) => '${e.key}=${e.value}').reduce((value, element) => '$value&$element')}';
    final Uri uri = Uri.parse(url + path + paramString);
    headers ??= this.headers;
    if (debug) {
      print('$method: $path');
      if (body != null) {
        print('\tBody: $body');
      }
      if (paramString != '') {
        print('\tParams: $paramString');
      }
      print('\tHeaders: $headers');
    }

    Response response;
    String responseBody;
    final shouldCache = method == 'GET' &&
        (await cacheProvider?.shouldUseCache(uri.toString()) ?? false);
    if (shouldCache) {
      responseBody = await cacheProvider!.get(uri.toString());
    } else {
      switch (method) {
        case 'GET':
          response = await get(uri, headers: headers);
          // Only cache GET requests, it doesn't make sense to cache other requests
          if (cacheProvider?.raw() ?? false) {
            cacheProvider?.set(uri.toString(), response.body);
          }
          break;
        case 'POST':
          response = await post(uri, headers: headers, body: body);
          break;
        case 'DELETE':
          response = await delete(uri, headers: headers, body: body);
          break;
        case 'PUT':
          response = await put(uri, headers: headers, body: body);
          break;
        case 'PATCH':
          response = await patch(uri, headers: headers, body: body);
          break;
        default:
          throw UnimplementedError('Method $method not implemented');
      }
      responseBody = response.body;
      if (response.statusCode == 401) {
        //Refresh token
        await credentials?.getTokenResponse(true);
        return _invokeApi(path, method,
            headers: headers,
            params: params,
            body: body,
            numTries: numTries + 1);
      }

      if (response.statusCode == 503) {
        //Retry in 500ms, this happens when Pronote resources are not ready.
        await Future.delayed(Duration(milliseconds: 500));
        return _invokeApi(path, method,
            headers: headers,
            params: params,
            body: body,
            numTries: numTries + 1);
      }

      if (response.statusCode >= 400) {
        throw Exception('Error ${response.statusCode} ${response.body}');
      }
      if (response.statusCode == 204) return {};
    }

    if (debug) {
      print('\tResponse size: ${(responseBody.length / 100).round() / 10}kb');
      print(
          '\t${shouldCache ? 'Cache r' : 'R'}equest done in ${stopwatch.elapsedMilliseconds}ms');
      stopwatch.reset();
    }

    final json = jsonDecode(responseBody);
    if (debug) {
      print('\tParsing done in ${stopwatch.elapsedMilliseconds}ms');
      stopwatch.reset();
    }
    if (shouldCache && !cacheProvider!.raw()) return json;

    final decoded = Japx.decode(json);
    if (debug) {
      print('\tJapx done in ${stopwatch.elapsedMilliseconds}ms');
      stopwatch.reset();
      final reencoded = jsonEncode(decoded);
      print(
          '\tSize after japx: ${(reencoded.length / 100).round() / 10}kb (${stopwatch.elapsedMilliseconds}ms to reencode)');
    }
    if (!(cacheProvider?.raw() ?? true)) {
      cacheProvider?.set(uri.toString(), jsonEncode(decoded));
    }
    return decoded;
  }

  Future<SkolengoResponse<CurrentConfig>> getAppCurrentConfig() async {
    final results = await _invokeApi('/sko-app-configs/current', 'GET');
    return SkolengoResponse(
      data: CurrentConfig.fromJson(results['data']),
      raw: results,
    );
  }

  Future<SkolengoResponse<List<School>>> searchSchool(String text,
      {int limit = 10, int offset = 0}) async {
    final results = await _invokeApi('/schools', 'GET', params: {
      'page[offset]': offset.toString(),
      'page[limit]': limit.toString(),
      'filter[text]': text,
    });
    return SkolengoResponse(
      data: results['data'].map<School>((e) => School.fromJson(e)).toList(),
      raw: results,
    );
  }

  Future<SkolengoResponse<List<School>>> searchSchoolGPS(num lat, num lon,
      {int limit = 10, int offset = 10}) async {
    final results = await _invokeApi('/schools', 'GET', params: {
      'page[offset]': offset.toString(),
      'page[limit]': limit.toString(),
      'filter[lat]': lat.toString(),
      'filter[lon]': lon.toString(),
    });
    return SkolengoResponse(
      data: results['data'].map<School>((e) => School.fromJson(e)).toList(),
      raw: results,
    );
  }

  Future<SkolengoResponse<User>> getUserInfo(String userId) async {
    final results = await _invokeApi('/users-info/$userId', 'GET',
        params: {'include': 'school,students,students.school'});
    return SkolengoResponse(
      data: User.fromJson(results['data']),
      raw: results,
    );
  }

  Future<SkolengoResponse<List<SchoolInfo>>> getSchoolInfos() async {
    final results = await _invokeApi('/schools-info', 'GET', params: {
      'include':
          'illustration,school,author,author.person,author.technicalUser,attachments'
    });
    return SkolengoResponse(
      data: results['data']
          .map<SchoolInfo>((e) => SchoolInfo.fromJson(e))
          .toList(),
      raw: results,
    );
  }

  Future<SkolengoResponse<SchoolInfo>> getSchoolInfo(String infoID) async {
    final results = await _invokeApi('/schools-info/$infoID', 'GET', params: {
      'include':
          'illustration,school,author,author.person,author.technicalUser,attachments'
    });
    return SkolengoResponse(
      data: SchoolInfo.fromJson(results['data']),
      raw: results,
    );
  }

  Future<SkolengoResponse<EvaluationSettings>> getEvaluationSettings(
      String studentId) async {
    final results = await _invokeApi('/evaluations-settings', 'GET', params: {
      'filter[student.id]': studentId,
      'include': 'periods,skillsSetting,skillsSetting.skillAcquisitionColors',
    });
    return SkolengoResponse(
      data: EvaluationSettings.fromJson(results['data'][0]),
      raw: results,
    ); //TODO check if there can be multiple
  }

  Future<SkolengoResponse<List<EvaluationService>>> getEvaluationServices(
      String studentId, String periodID) async {
    final results = await _invokeApi('/evaluation-services', 'GET', params: {
      'filter[student.id]': studentId,
      'filter[period.id]': periodID,
      'include':
          'subject,evaluations,evaluations.evaluationResult,evaluations.evaluationResult.subSkillsEvaluationResults,evaluations.evaluationResult.subSkillsEvaluationResults.subSkill,evaluations.subSkills,teachers'
    });
    return SkolengoResponse(
      data: results['data']
          .map<EvaluationService>((e) => EvaluationService.fromJson(e))
          .toList(),
      raw: results,
    );
  }

//FIXME test this
  Future<SkolengoResponse<Evaluation?>> getEvaluation(
      String studentId, String evaluationId) async {
    final results =
        await _invokeApi('/evaluations/$evaluationId', 'GET', params: {
      'filter[student.id]': studentId,
      'include':
          'evaluationService,evaluationService.subject,evaluationService.teachers,subSubject,subSkills,evaluationResult,evaluationResult.subSkillsEvaluationResults,evaluationResult.subSkillsEvaluationResults.subSkill'
    });
    return SkolengoResponse(
      data: null,
      raw: results,
    );
  }

  //TODO test this
  Future<SkolengoResponse<List<PeriodicReportsFile>>> getPeriodicReportsFiles(
      String studentId) async {
    final results = await _invokeApi('/periodic-reports-files', 'GET',
        params: {'filter[student.id]': studentId, 'include': 'period'});
    return SkolengoResponse(
      data: results['data']
          .map<PeriodicReportsFile>((e) => PeriodicReportsFile.fromJson(e))
          .toList(),
      raw: results,
    );
  }

  Future<SkolengoResponse<List<Agenda>>> getAgendas(String studentId,
      {String? start,
      String? end,
      DateTime? startDate,
      DateTime? endDate}) async {
    start ??= startDate?.toIso8601String().substring(0, 10);
    end ??= endDate?.toIso8601String().substring(0, 10);

    if (start == null || end == null) {
      throw ArgumentError(
          'Start and end (or startDate and endDate) must be set');
    }

    final results = await _invokeApi('/agendas', 'GET', params: {
      'filter[student.id]': studentId,
      'filter[date][GE]': start,
      'filter[date][LE]': end,
      'include':
          'lessons,lessons.subject,lessons.teachers,homeworkAssignments,homeworkAssignments.subject',
    });
    return SkolengoResponse(
      data: results['data'].map<Agenda>((e) => Agenda.fromJson(e)).toList(),
      raw: results,
    );
  }

  Future<SkolengoResponse<Lesson>> getLesson(
      String studentId, String lessonId) async {
    final results = await _invokeApi('/lessons/$lessonId', 'GET', params: {
      'filter[student.id]': studentId,
      'include':
          'teachers,contents,contents.attachments,subject,toDoForTheLesson,toDoForTheLesson.subject,toDoAfterTheLesson,toDoAfterTheLesson.subject',
    });
    return SkolengoResponse(
      data: Lesson.fromJson(results['data']),
      raw: results,
    );
  }

  Future<SkolengoResponse<List<HomeworkAssignment>>> getHomeworkAssignments(
      String studentId, String startDate, String endDate) async {
    final results = await _invokeApi('/homework-assignments', 'GET', params: {
      'filter[student.id]': studentId,
      'filter[dueDate][GE]': startDate,
      'filter[dueDate][LE]': endDate,
      'include': 'subject,teacher,attachments,teacher.person',
    });
    return SkolengoResponse(
      data: results['data']
          .map<HomeworkAssignment>((e) => HomeworkAssignment.fromJson(e))
          .toList(),
      raw: results,
    );
  }

  Future<SkolengoResponse<HomeworkAssignment>> getHomeworkAssignment(
      String studentId, String homeworkAssignmentId) async {
    final results = await _invokeApi(
        '/homework-assignments/$homeworkAssignmentId', 'GET',
        params: {
          'filter[student.id]': studentId,
          'include':
              'subject,teacher,pedagogicContent,individualCorrectedWork,individualCorrectedWork.attachments,individualCorrectedWork.audio,commonCorrectedWork,commonCorrectedWork.attachments,commonCorrectedWork.audio,commonCorrectedWork.pedagogicContent,attachments,audio,teacher.person',
        });
    return SkolengoResponse(
      data: HomeworkAssignment.fromJson(results['data']),
      raw: results,
    );
  }

  Future<SkolengoResponse<HomeworkAssignment>> patchHomeworkAssignment(
      String studentId, String homeworkAssignmentId, bool done) async {
    final results =
        await _invokeApi('/homework-assignments/$homeworkAssignmentId', 'PATCH',
            body: jsonEncode({
              'data': {
                'type': 'homework',
                'id': homeworkAssignmentId,
                'attributes': {
                  'done': done,
                }
              }
            }),
            params: {
          'filter[student.id]': studentId,
          'include':
              'subject,teacher,pedagogicContent,individualCorrectedWork,individualCorrectedWork.attachments,individualCorrectedWork.audio,commonCorrectedWork,commonCorrectedWork.attachments,commonCorrectedWork.audio,commonCorrectedWork.pedagogicContent,attachments,audio,teacher.person',
        });
    return SkolengoResponse(
      data: HomeworkAssignment.fromJson(results['data']),
      raw: results,
    );
  }

  Future<SkolengoResponse<UsersMailSettings>> getUsersMailSettings(
      String userId) async {
    final results =
        await _invokeApi('/users-mail-settings/$userId', 'GET', params: {
      'include':
          'signature,folders,folders.parent,contacts,contacts.person,contacts.personContacts'
    });
    return SkolengoResponse(
      data: UsersMailSettings.fromJson(results['data']),
      raw: results,
    );
  }

  Future<SkolengoResponse<List<Communication>>> getCommunicationsFromFolder(
      String folderId,
      {int limit = 10,
      int offset = 0}) async {
    final results = await _invokeApi('/communications', 'GET', params: {
      'filter[folders.id]': folderId,
      'page[limit]': limit.toString(),
      'page[offset]': offset.toString(),
      'include':
          'lastParticipation,lastParticipation.sender,lastParticipation.sender.person,lastParticipation.sender.technicalUser',
    });
    return SkolengoResponse(
      data: results['data']
          .map<Communication>((e) => Communication.fromJson(e))
          .toList(),
      raw: results,
    );
  }

  Future<SkolengoResponse<List<Participation>>> getCommunicationParticipations(
      String communicationId) async {
    final results = await _invokeApi(
        '/communications/$communicationId/participations', 'GET', params: {
      'include': 'sender,sender.person,sender.technicalUser,attachments'
    });
    return SkolengoResponse(
      data: results['data']
          .map<Participation>((e) => Participation.fromJson(e))
          .toList(),
      raw: results,
    );
  }

  Future<SkolengoResponse<List<Participant>>> getCommunicationParticipants(
      String communicationId,
      {fromGroup = true}) async {
    final results = await _invokeApi(
        '/communications/$communicationId/participants', 'GET',
        params: {
          'include': 'person,technicalUser',
          'filter[fromGroup]': fromGroup.toString(),
        });
    return SkolengoResponse(
      data: results['data']
          .map<Participant>((e) => Participant.fromJson(e))
          .toList(),
      raw: results,
    );
  }

  Future<SkolengoResponse<void>> patchCommunicationFolders(
      String communicationId, List<Folder> folders, String userId) async {
    final results = await _invokeApi(
        '/communications/$communicationId/relationships/folders', 'PATCH',
        body: jsonEncode({
          'data': folders
              .map((e) => {
                    'id': e.id,
                  })
              .toList(),
        }),
        params: {
          'filter[user.id]': userId,
        });
    return SkolengoResponse(
      data: null,
      raw: results,
    );
  }

  Future<SkolengoResponse<Communication>> postCommunication(String subject,
      String firstParticipationContent, List<Contact> toRecipients,
      {List<Contact>? ccRecipients, List<Contact>? bccRecipients}) async {
    final results = await _invokeApi('/communications', 'POST',
        body: jsonEncode(Japx.encode({
          'type': 'communication',
          'subject': subject,
          'firstParticipationContent': firstParticipationContent,
          'toRecipients': toRecipients.map((e) => e.toMap()).toList(),
          if (ccRecipients != null)
            'ccRecipients': ccRecipients.map((e) => e.toMap()).toList(),
          if (bccRecipients != null)
            'bccRecipients': bccRecipients.map((e) => e.toMap()).toList(),
        })));
    return SkolengoResponse(
      data: Communication.fromJson(results['data']),
      raw: results,
    );
  }

  Future<SkolengoResponse<Participation>> postCommunicationParticipation(
      String communicationId, String content) async {
    final results = await _invokeApi(
      '/participations',
      'POST',
      body: jsonEncode(
        Japx.encode(
          {
            'type': 'participation',
            'content': content,
            'communication': {
              'type': 'communication',
              'id': communicationId,
            },
          },
        ),
      ),
    );
    return SkolengoResponse(
      data: Participation.fromJson(results['data']),
      raw: results,
    );
  }

  Future<SkolengoResponse<List<AbsenceFile>>> getAbsenceFiles(
      String studentId) async {
    final results = await _invokeApi('/absence-files', 'GET', params: {
      'filter[student.id]': studentId,
      'include':
          'currentState,currentState.absenceReason,currentState.absenceRecurrence'
    });
    return SkolengoResponse(
      data: results['data']
          .map<AbsenceFile>((e) => AbsenceFile.fromJson(e))
          .toList(),
      raw: results,
    );
  }

  //TODO test this
  Future<SkolengoResponse<AbsenceFile>> getAbsenceFile(String folderId) async {
    final results =
        await _invokeApi('/absence-files/$folderId', 'GET', params: {
      'include':
          'currentState,currentState.absenceReason,currentState.absenceRecurrence,history,history.creator'
    });
    return SkolengoResponse(
      data: AbsenceFile.fromJson(results['data']),
      raw: results,
    );
  }

  //TODO test this
  Future<SkolengoResponse<List<AbsenceReason>>> getAbsenceReasons() async {
    final results = await _invokeApi('/absence-reasons', 'GET');
    return SkolengoResponse(
      data: results['data']
          .map<AbsenceReason>((e) => AbsenceReason.fromJson(e))
          .toList(),
      raw: results,
    );
  }

  Future<Client> getOIDClient(School school) async {
    final skolengoIssuer =
        await Issuer.discover(Uri.parse(school.emsOIDCWellKnownUrl!));
    return Client(
      skolengoIssuer,
      OID_CLIENT_ID,
      clientSecret: OID_CLIENT_SECRET,
    );
  }
}
