import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

List<String> mergeLists(var list1, var list2) {
  List<String> merged = [];
  for (String i in list1) {
    merged.add(i);
  }
  for (String i in list2) {
    if (!(list1.contains(i))) {
      merged.add(i);
    }
  }
  return merged;
}

Map<String, dynamic> mergeMaps(Map<String, dynamic> map1, Map<String, dynamic> map2) {
  Map<String, dynamic> merged = {};
  var mergedKeys = mergeLists(map1.keys, map2.keys);
  for (String i in mergedKeys) {
    bool in1 = map1.containsKey(i);
    bool in2 = map2.containsKey(i);
    if (in1) {
      if (in2) {
        merged[i] = mergeLists(map1[i], map2[i]);
      } else {
        merged[i] = map1[i];
      }
    } else {
      if (in2) {
        merged[i] = map2[i];
      } else {
        merged[i] = [];
      }
    }
  }
  return merged;
}

Future<String> localPath() async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> localFile(String directory, String filename) async {
  final path = await localPath();
  File file =  File('$path/$directory/' + filename);
  bool exists = await file.exists();
  if (!exists) {
    file.create(recursive: true);
  }
  return file;
}

Future<File> writeText(String directory, String filename, String text, bool append) async {
  final file = await localFile(directory, filename);
  if (append) {
    String current = await readText(directory, filename);
    return file.writeAsString(current + text);
  } else {
    return file.writeAsString(text);
  }
}

Future<String> readText(String directory, String filename) async {
  try {
    final file = await localFile(directory, filename);
    String text = await file.readAsString();
    return text;
  } catch (e) {
    return "";
  }
}

Future<String> makeGetRequest(String url, String apikey) async {
  try {
    http.Response res = await http.get(Uri.encodeFull(url), headers: {"authorization": "token $apikey"});
    return res.body;
  } on SocketException {
    return "";
  }
}

Future<String> makePostRequest(String url, String json, String apikey) async {
  try {
    http.Response res = await http.post(Uri.encodeFull(url), headers: {"Content-type": "application/json", "authorization": "token $apikey"}, body: json);
    return res.body;
  } on SocketException {
    return "";
  }
}

Future<String> makePutRequest(String url, String json, String apikey) async {
  try {
    http.Response res = await http.put(Uri.encodeFull(url), headers: {"Content-type": "application/json", "authorization": "token $apikey"}, body: json);
    return res.body;
  } on SocketException {
    return "";
  }
}