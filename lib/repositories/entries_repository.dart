import 'dart:convert';
import 'package:kbin_mobile/models/entry_collection_model.dart';
import 'package:http/http.dart' as http;
import 'package:kbin_mobile/models/entry_item_model.dart';
import 'package:kbin_mobile/repositories/api_provider.dart';


class EntriesRepository {
  Future<List<EntryCollectionItem>> fetchEntries() async {
    Uri url = Uri.http(ApiProvider().getDomain(), 'api/entries.jsonld');

    var response = await http.get(url);

    if (response.statusCode == 200) {
     Map data = jsonDecode(response.body);

     List<dynamic> entries = data["hydra:member"];

     return entries.map((json) => EntryCollectionItem.fromJson(json)).toList();
    }

    throw Exception("Something went wrong, ${response.statusCode}");
  }

  Future<EntryItem> fetchEntry(int id) async {
    Uri url = Uri.https(ApiProvider().getDomain(), 'api/entries/$id.jsonld');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> entry = jsonDecode(response.body);

      return EntryItem.fromJson(entry);
    }

    throw Exception("Something went wrong, ${response.statusCode}");
  }
}
