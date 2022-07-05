import 'dart:io';
import 'package:hospitalmanagementsystem/models/patient.dart';
import 'package:fhir_at_rest/r4.dart';
import 'package:http/http.dart' as http;
//ignore_for_file: always_specify_types
import 'package:fhir/r4.dart';
import 'package:yaml/yaml.dart';
import 'dart:convert';

class RemoteService {
  Future<Object> pushPatient() async {
    var client = http.Client();
    var uri = Uri.parse("https://fhir.simplifier.net/Course");
    final response = http.get(uri, headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader:
          "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoibWFyd2Fua2hhbGVkbW9zdGFmYSIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL25hbWVpZGVudGlmaWVyIjoiMTgzMWY1NDgtMjg4MC00ZjlmLTk2ZWQtZTk5MmUzODQ4ZGU5IiwianRpIjoiZDI2MzU3NzUtOTQwNS00OTQ5LWJmOTYtYTUzYjIyYzk0MTEzIiwiZXhwIjoxNjU2ODQzMTI4LCJpc3MiOiJhcGkuc2ltcGxpZmllci5uZXQiLCJhdWQiOiJhcGkuc2ltcGxpZmllci5uZXQifQ.eGdql6Te7yl61jiR0iK4l_0yXaoc3mceMvj3WmvaJ0g"
    });

    final Patient _patient = Patient();
    return client;
  }
}

Future<void> addPatient() async {
  final Patient patient = Patient(
    id: Id(123),
    resourceType: R4ResourceType.Patient,
    name: <HumanName>[
      HumanName(use: HumanNameUse.official, text: "marwan", family: "khaled"),
    ],
    birthDate: Date(DateTime(2022, 01, 05)),
    telecom: <ContactPoint>[
      ContactPoint(
          value: "1010304619",
          use: ContactPointUse.mobile,
          system: ContactPointSystem.phone),
      ContactPoint(system: ContactPointSystem.email, value: "mirocc4@gmail.com")
    ],
    address: <Address>[Address(city: "Giza")],
  );
  print(patient.toYaml());
  var doc = loadYaml(patient.toYaml());
  var x = json.encode(doc);

  var client = http.Client();
  var uri = Uri.parse("https://test.fhir.org/r4/Patient");
  final response = await http.get(
    uri,
  );

  final re = await client.post(uri, body: x);
  final request = FhirRequest.create(
      base: Uri.parse('https://test.fhir.org/r4/Patient'),
      resource: patient,
      client: client);
  print(
      "******************************************************************************");
  print(re);
}
