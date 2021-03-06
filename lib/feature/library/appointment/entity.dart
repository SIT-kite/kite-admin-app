import 'package:json_annotation/json_annotation.dart';

part 'entity.g.dart';

@JsonSerializable(createToJson: false)
class PeriodStatusRecord {
  /// 场次id
  int period;

  /// 总数
  int count;

  /// 已申请人数
  int applied;

  /// 场次描述
  String text;

  /// 是否已预约
  bool appointed;

  PeriodStatusRecord(this.period, this.count, this.applied, this.text, this.appointed);

  factory PeriodStatusRecord.fromJson(Map<String, dynamic> json) => _$PeriodStatusRecordFromJson(json);

  @override
  String toString() {
    return 'PeriodStatusRecord{period: $period, count: $count, applied: $applied, text: $text, appointed: $appointed}';
  }
}

@JsonSerializable(createToJson: false)
class ApplicationRecord {
  int id;
  int period;
  String user;
  String name;
  int index;
  @JsonKey(defaultValue: '')
  String text;
  int status;

  ApplicationRecord(this.id, this.period, this.user, this.name, this.index, this.text, this.status);
  factory ApplicationRecord.fromJson(Map<String, dynamic> json) => _$ApplicationRecordFromJson(json);

  @override
  String toString() {
    return 'ApplicationRecord{id: $id, period: $period, user: $user, name: $name, index: $index, text: $text, status: $status}';
  }
}

@JsonSerializable(createToJson: false)
class ApplyResponse {
  int id;
  String text;
  int index;

  ApplyResponse(this.id, this.text, this.index);
  factory ApplyResponse.fromJson(Map<String, dynamic> json) => _$ApplyResponseFromJson(json);

  @override
  String toString() {
    return 'ApplyResponse{id: $id, text: $text, index: $index}';
  }
}

@JsonSerializable(createToJson: false)
class CurrentPeriodResponse {
  DateTime? after;
  DateTime? before;
  int? period;
  int? next;

  CurrentPeriodResponse(this.after, this.before, this.period);

  factory CurrentPeriodResponse.fromJson(Map<String, dynamic> json) => _$CurrentPeriodResponseFromJson(json);

  @override
  String toString() {
    return 'CurrentPeriodResponse{after: $after, before: $before, period: $period, next: $next}';
  }
}

@JsonSerializable(createToJson: false)
class QrCodeResponse {
  ApplicationRecord application;
  DateTime timestamp;
  String sign;

  QrCodeResponse(this.application, this.timestamp, this.sign);

  factory QrCodeResponse.fromJson(Map<String, dynamic> json) => _$QrCodeResponseFromJson(json);
}
