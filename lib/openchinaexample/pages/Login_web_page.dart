import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ft_study/openchinaexample/constants/constants.dart';
import 'package:flutter_ft_study/openchinaexample/utils/data_utils.dart';
import 'package:flutter_ft_study/openchinaexample/utils/net_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginWPage extends StatefulWidget {
  const LoginWPage({super.key});

  @override
  State<LoginWPage> createState() => _LoginWPageState();
}

class _LoginWPageState extends State<LoginWPage> {
  late final WebViewController _controller;
  bool isLoading = true;

  static String get _loginUrl =>
      AppUrls.OAUTH2_AUTHORIZE +
      "?response_type=code&client_id=" +
      AppInfos.CLIENT_ID +
      "&redirect_uri=" +
      AppInfos.REDIRECT_URI;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onUrlChange: (UrlChange change) {
            if (change.url != null) {
              print('LoginWPage: url: ${change.url}');

              if (change.url?.contains('code=') ?? false) {
                String code = change.url?.split('code=')[1] ?? '';
                print('LoginWPage: code: $code');
                Map<String, dynamic> params = {
                  'client_id': AppInfos.CLIENT_ID,
                  'client_secret': AppInfos.CLIENT_SECRET,
                  'grant_type': 'authorization_code',
                  'redirect_uri': AppInfos.REDIRECT_URI,
                  'code': code,
                  'data_type': 'json',
                };
                print('LoginWPage: params: $params');
                NetUtils.get(AppUrls.OAUTH2_TOKEN, params).then((data) {
                  print('LoginWPage: data: $data');
                  if (data.isNotEmpty) {
                    print('LoginWPage: data: $data');
                    Map<String, dynamic> dataMap = json.decode(data);
                    if(dataMap != null && dataMap.isNotEmpty) {
                      print('LoginWPage: dataMap: $dataMap');
                      //保存token等信息
                      DataUtils.saveLoginInfo(dataMap);
                      //返回上一页,并返回Refresh，更新token信息界面
                      Navigator.pop(context,"Refresh");
                    }
                    print('LoginWPage: dataMap: $dataMap');
                  }
                });
              }
            }

          },
          onPageFinished: (_) {
            if (mounted) setState(() => isLoading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse(_loginUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.login),
            const Text(
              '登录',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isLoading) const SizedBox(width: 10),
            if (isLoading) const CupertinoActivityIndicator(),
          ],
        ),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
