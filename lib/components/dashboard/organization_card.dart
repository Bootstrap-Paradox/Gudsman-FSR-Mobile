import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gudsman_service/components/buttons/buttons.dart';
import 'package:gudsman_service/utils/http_req.dart';

import 'package:http/http.dart' as http;

class OrganizationCard extends ConsumerStatefulWidget {
  const OrganizationCard({super.key, required this.orgName});
  final String orgName;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OrganizationCardState();
}

class _OrganizationCardState extends ConsumerState<OrganizationCard> {
  bool toSwtich = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        // height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 16.0,
            ),
          ],
        ),
        child: Column(children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.business,
                  color: Colors.grey.shade700,
                ),
              ),
              IntrinsicWidth(
                child: SizedBox(
                  width: 230,
                  child: Text(
                    widget.orgName,
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          TextButton.icon(
              onPressed: () {
                setState(() {
                  toSwtich = !toSwtich;
                });
              },
              style: ButtonStyle(
                iconColor: MaterialStatePropertyAll(Colors.blue.shade800),
              ),
              icon: const Icon(Icons.repeat),
              label: Text(
                'Switch',
                style: TextStyle(color: Colors.blue.shade800),
              )),
          if (toSwtich) const OrganizationSwitchList(),
        ]),
      ),
    );
  }
}

class OrganizationSwitchList extends ConsumerStatefulWidget {
  const OrganizationSwitchList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OrganizationSwitchListState();
}

class _OrganizationSwitchListState
    extends ConsumerState<OrganizationSwitchList> {
  Future<dynamic> fetchOrganizations() async {
    http.Response response = await HttpReq.get(
        path: '/api/v1/organization?available-org=true',
        headers: {},
        authorized: true);

    Map<String, dynamic> responseBody = json.decode(response.body);
    print(responseBody['organizations']);
    return responseBody['organizations'];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchOrganizations(),
        builder: (BuildContext build, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(snapshot.data[index]['organization_name']),
                    );
                  });
            }
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
