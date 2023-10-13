import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gudsman_service/components/buttons/buttons.dart';
import 'package:gudsman_service/components/custom_appbar.dart';
import 'package:gudsman_service/utils/http_req.dart';

class NewOrganizationPage extends ConsumerStatefulWidget {
  const NewOrganizationPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NewOrganizationPageState();
}

class _NewOrganizationPageState extends ConsumerState<NewOrganizationPage> {
  Future<dynamic> fetchOrganizations() async {
    final response = await HttpReq.get(
      path: '/api/v1/organization?available-org=true',
      headers: {},
      authorized: true,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['organizations'];
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 60.0,
            ),
            const Text(
              'Create Gudsman Organization',
              style: TextStyle(
                fontSize: 20,
                // fontWeight: FontWeight.bold,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Automate your Organization / Company with Ease, We believe in making things easy for you, Thats Gudsman',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            const SizedBox(
              height: 30.0,
            ),
            FutureBuilder(
                future: fetchOrganizations(),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(child: Text('Error'));
                  }

                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      if (snapshot.data.length == 0) {
                        return const Center(
                          child: Text('No Organizations Available'),
                        );
                      }
                      return Column(
                        children: [
                          const Text('Available Organizations'),
                          const SizedBox(
                            height: 20,
                          ),
                          ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, index) {
                              return ListTile(
                                leading: const Icon(Icons.business),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                title: Text(
                                    snapshot.data[index]['organization_name']),
                              );
                            },
                            shrinkWrap: true,
                          ),
                        ],
                      );
                    }
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
            const SizedBox(
              height: 30.0,
            ),
            const Divider(),
            const Text('Organization Invites'),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomButton(
          text: 'New Organization',
          onClick: () {},
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
