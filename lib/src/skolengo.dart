import 'dart:convert';

import 'package:http/http.dart';
import 'package:japx/japx.dart';
import 'package:scolengo_api_dart/src/models/Agenda/agenda.dart';
import 'package:scolengo_api_dart/src/models/Agenda/lesson.dart';
import 'package:scolengo_api_dart/src/models/App/current_config.dart';
import 'package:scolengo_api_dart/src/models/App/user.dart';
import 'package:scolengo_api_dart/src/models/Assiduite/absence_file.dart';
import 'package:scolengo_api_dart/src/models/Assiduite/absence_reason.dart';
import 'package:scolengo_api_dart/src/models/Evaluation/evaluation.dart';
import 'package:scolengo_api_dart/src/models/Evaluation/evaluation_settings.dart';
import 'package:scolengo_api_dart/src/models/Evaluation/preiodic_reports_file.dart';
import 'package:scolengo_api_dart/src/models/Homework/homework_assignments.dart';
import 'package:scolengo_api_dart/src/models/Messagerie/communication.dart';
import 'package:scolengo_api_dart/src/models/Messagerie/participant.dart';
import 'package:scolengo_api_dart/src/models/Messagerie/participation.dart';
import 'package:scolengo_api_dart/src/models/Messagerie/user_mail_settings.dart';
import 'package:scolengo_api_dart/src/models/School/school.dart';
import 'package:scolengo_api_dart/src/models/School/school_info.dart';
import 'package:scolengo_api_dart/src/models/globals.dart';

class Skolengo {
  static const url = 'https://api.skolengo.com/api/v1/bff-sko-app';
  final String token;
  final Map<String, String> headers;
  Skolengo({
    required this.token,
    required this.headers,
  });
  Future<Map<String, dynamic>> _invokeApi(
    String path,
    String method, {
    Map<String, String>? headers,
    Map<String, String>? params,
    Object? body,
    int numTries = 0,
  }) async {
    if (numTries > 3) {
      throw Exception('Too many tries');
    }

    final paramString = params == null || params.isEmpty
        ? ''
        : '?${params.entries.map((e) => '${e.key}=${e.value}').reduce((value, element) => '$value&$element')}';
    final Uri uri = Uri.parse(url + path + paramString);
    headers ??= this.headers;
    Response response;
    switch (method) {
      case 'GET':
        response = await get(uri, headers: headers);
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
        response = await get(uri, headers: headers);
    }

    if (response.statusCode == 401) {
      //TODO refresh token
      throw UnimplementedError();
    }

    if (response.statusCode == 503) {
      //Retry in 500ms, this happens when Pronote resources are not ready.
      await Future.delayed(Duration(milliseconds: 500));
      return _invokeApi(path, method,
          headers: headers, params: params, body: body, numTries: numTries + 1);
    }

    if (response.statusCode >= 400) {
      throw Exception('Error ${response.statusCode} ${response.body}');
    }

    return Japx.decode(jsonDecode(response.body));
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

  //TODO test this
  Future<SkolengoResponse<List<Evaluation>>> getEvaluations(
      String studentId, String periodID) async {
    final results = await _invokeApi('/evaluation-services', 'GET', params: {
      'filter[student.id]': studentId,
      'filter[period.id]': periodID,
      'include':
          'subject,evaluations,evaluations.evaluationResult,evaluations.evaluationResult.subSkillsEvaluationResults,evaluations.evaluationResult.subSkillsEvaluationResults.subSkill,evaluations.subSkills,teachers'
    });
    return SkolengoResponse(
      data: results['data']
          .map<Evaluation>((e) => Evaluation.fromJson(e))
          .toList(),
      raw: results,
    );
  }

  //TODO test this
  Future<SkolengoResponse<Evaluation>> getEvaluation(
      String studentId, String evaluationId) async {
    final results =
        await _invokeApi('/evaluations/$evaluationId', 'GET', params: {
      'filter[student.id]': studentId,
      'include':
          'evaluationService,evaluationService.subject,evaluationService.teachers,subSubject,subSkills,evaluationResult,evaluationResult.subSkillsEvaluationResults,evaluationResult.subSkillsEvaluationResults.subSkill'
    });
    return SkolengoResponse(
      data: Evaluation.fromJson(results['data']),
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

//FIXME This is copilot generated code, it doesn't work
  Future<HomeworkAssignment> patchHomeworkAssignment(
      String studentId, String homeworkAssignmentId, status) async {
    final results = await _invokeApi(
        '/homework-assignments/$homeworkAssignmentId', 'PATCH',
        params: {
          'filter[student.id]': studentId,
          'data[attributes][status]': status,
        });
    return HomeworkAssignment.fromJson(results['data']);
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
}
