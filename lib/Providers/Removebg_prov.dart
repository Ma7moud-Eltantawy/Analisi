
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;



class RemoveBG_prov with ChangeNotifier{
  String ?img;
  Future<void> Remove_bg(File imgfile)
  async {
    String filename=imgfile.path.split('/').last;
    var headers = {
      'Rm-Token': '631c90bbe41a06.58433150',
      'Cookie': '.AspNetCore.Session=CfDJ8CV%2FQXQgdOxJjhHAF8SxSfdlfcUl55W8qYxivnLXJHiC7uCrDCOMNDJjWqXMCcd%2F6nvJRMR3dlxpY4LevkwKaQ9o0BEW8YInxWjyrgM8f%2FjtWTUOalvpRk%2BEgmdr0OtYXuR95oHfyqNDy8bCyTzDuPfxwRutfCV1GcOFV2h%2BWb4U'
    };
    var request = http.MultipartRequest('POST', Uri.parse('https://api.removal.ai/3.0/remove'));
    request.files.add(await http.MultipartFile.fromPath('image_file', imgfile.path ,filename: filename));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var res = await http.Response.fromStream(response);
      var js= json.decode(res.body)['preview_demo'];
      img=js.toString();
    }
    else {
      print(response.reasonPhrase);
    }

  }

}