import 'package:http/http.dart';
import 'dart:convert';

import 'package:war_machines/schema/schema.dart';

class WarmachinesApi {
  WarmachinesApi(this._baseURL) : _client = Client();

  final Client _client;
  final String _baseURL;

  Future<Map<String, dynamic>> query(String query) async {
    Response response = await _client.get("$_baseURL?raw=true&query=$query");
    if (200 <= response.statusCode && response.statusCode <= 299) {
      return json.decode(response.body)["data"];
    }
    throw new Exception("Error fetching");
  }

  Future<AllNationsResponse> queryAllNations() async {
    Map<String, dynamic> response = await query("""
    {
      nations{
        name
        flag
  
        tanks {
            ndbId
            name
            photos
          }
        }
    }
    """);

    return AllNationsResponse.fromJson(response);
  }

  Future<TankByIdResponse> queryTankById(String id) async {
    Map<String, dynamic> response = await query("""
  {
    tank(id: "$id") {
      name
      description

      nation {
        name
        flag
      }

      period {
        name
        start
        end
      }

      photos
    }
  }
    """);

    return TankByIdResponse.fromJson(response);
  }
}
