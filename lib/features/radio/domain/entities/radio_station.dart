import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'radio_station.g.dart';

@JsonSerializable()
class RadioStation {
  @JsonKey(name: 'changeuuid')
  final String changeUuid;

  @JsonKey(name: 'stationuuid')
  final String stationUuid;

  @JsonKey(name: 'serveruuid')
  final String? serverUuid;

  final String name;
  final String url;

  @JsonKey(name: 'url_resolved')
  final String resolvedUrl;

  final String homepage;
  final String favicon;
  final String tags;
  final String country;

  @JsonKey(name: 'countrycode')
  final String countryCode;

  @JsonKey(name: 'iso_3166_2')
  final String? iso31662;

  final String state;
  final String language;

  @JsonKey(name: 'languagecodes')
  final String languageCodes;

  final int votes;

  @JsonKey(name: 'lastchangetime')
  final String? lastChangeTime;

  @JsonKey(name: 'lastchangetime_iso8601')
  final String? lastChangeTimeIso8601;

  final String codec;
  final int bitrate;
  final int hls;

  @JsonKey(name: 'lastcheckok')
  final int? lastCheckOk;

  @JsonKey(name: 'lastchecktime')
  final String? lastCheckTime;

  @JsonKey(name: 'lastchecktime_iso8601')
  final String? lastCheckTimeIso8601;

  @JsonKey(name: 'lastcheckoktime')
  final String? lastCheckOkTime;

  @JsonKey(name: 'lastcheckoktime_iso8601')
  final String? lastCheckOkTimeIso8601;

  @JsonKey(name: 'lastlocalchecktime')
  final String? lastLocalCheckTime;

  @JsonKey(name: 'lastlocalchecktime_iso8601')
  final String? lastLocalCheckTimeIso8601;

  @JsonKey(name: 'clicktimestamp')
  final String? clickTimestamp;

  @JsonKey(name: 'clicktimestamp_iso8601')
  final String? clickTimestampIso8601;

  final int clickcount;
  final int clicktrend;

  @JsonKey(name: 'ssl_error')
  final int sslError;

  @JsonKey(name: 'geo_lat')
  final double? geoLat;

  @JsonKey(name: 'geo_long')
  final double? geoLong;

  @JsonKey(name: 'has_extended_info')
  final bool hasExtendedInfo;

  RadioStation({
    required this.changeUuid,
    required this.stationUuid,
    required this.serverUuid,
    required this.name,
    required this.url,
    required this.resolvedUrl,
    required this.homepage,
    required this.favicon,
    required this.tags,
    required this.country,
    required this.countryCode,
    required this.iso31662,
    required this.state,
    required this.language,
    required this.languageCodes,
    required this.votes,
    required this.lastChangeTime,
    required this.lastChangeTimeIso8601,
    required this.codec,
    required this.bitrate,
    required this.hls,
    required this.lastCheckOk,
    required this.lastCheckTime,
    required this.lastCheckTimeIso8601,
    required this.lastCheckOkTime,
    required this.lastCheckOkTimeIso8601,
    required this.lastLocalCheckTime,
    required this.lastLocalCheckTimeIso8601,
    required this.clickTimestamp,
    required this.clickTimestampIso8601,
    required this.clickcount,
    required this.clicktrend,
    required this.sslError,
    required this.geoLat,
    required this.geoLong,
    required this.hasExtendedInfo,
  });

  factory RadioStation.fromJson(Map<String, dynamic> json) {
    try {
      return _$RadioStationFromJson(json);
    } catch (e) {
      debugPrint('Error deserializing json: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => _$RadioStationToJson(this);
}
