import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gudsman_service/utils/http_req.dart';

@immutable
class OrganizationModel {
  const OrganizationModel(
      {required this.id,
      required this.orgName,
      required this.regionSettings,
      required this.rawOrganizationData});

  final String id;
  final String orgName;
  final Map<String, dynamic> regionSettings;
  final Map<String, dynamic> rawOrganizationData;
  // final String id = rawOrganizationData['_id'];
}

class OrganizationNotifier
    extends StateNotifier<AsyncValue<OrganizationModel>> {
  OrganizationNotifier(
    ref,
  ) : super(const AsyncValue.loading()) {
    fetchOrganizationData();
  }

  Future<void> fetchOrganizationData() async {
    try {
      final response = await HttpReq.get(
          path: '/api/v1/organization', headers: {}, authorized: true);

      final Map<String, dynamic> responseBody = json.decode(response.body);
      state = AsyncData(OrganizationModel(
          id: responseBody['_id'],
          orgName: responseBody['name'],
          regionSettings: responseBody['region_settings'],
          rawOrganizationData: responseBody));
    } catch (e) {
      print(e);
    }
  }
}
