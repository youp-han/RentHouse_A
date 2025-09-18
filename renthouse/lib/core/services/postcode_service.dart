import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:daum_postcode_search/daum_postcode_search.dart' as daum;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webview_flutter/webview_flutter.dart' as webview_flutter;
import 'package:renthouse/core/utils/platform_utils.dart';
import 'package:renthouse/core/logging/app_logger.dart';

/// 주소 검색 결과 모델
class PostcodeResult {
  final String zipCode;    // 우편번호
  final String address1;   // 주소1 (도로명주소)
  final String address2;   // 상세주소 (입력할 항목)

  const PostcodeResult({
    required this.zipCode,
    required this.address1,
    this.address2 = '',
  });

  @override
  String toString() {
    return 'PostcodeResult(zipCode: $zipCode, address1: $address1, address2: $address2)';
  }
}

/// 플랫폼별 우편번호 검색 서비스
class PostcodeService {
  static const String _tag = 'PostcodeService';

  /// 우편번호 검색 화면 표시
  static Future<PostcodeResult?> searchAddress(BuildContext context) async {
    try {
      AppLogger.info('우편번호 검색 시작', tag: _tag);

      if (PlatformUtils.isDesktop) {
        return await _searchAddressDesktop(context);
      } else {
        return await _searchAddressMobile(context);
      }
    } catch (e, stackTrace) {
      AppLogger.error('우편번호 검색 중 오류 발생',
          tag: _tag, error: e, stackTrace: stackTrace);
      return null;
    }
  }

  /// 모바일/Android용 우편번호 검색
  static Future<PostcodeResult?> _searchAddressMobile(BuildContext context) async {
    try {
      final result = await showModalBottomSheet<dynamic>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (context) => Container(
          height: MediaQuery.of(context).size.height * 0.85,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
          ),
          child: Scaffold(
            appBar: AppBar(
              title: const Text('주소 검색'),
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
              toolbarHeight: 56, // 표준 높이로 고정
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: daum.DaumPostcodeSearch(
                onConsoleMessage: (controller, consoleMessage) {
                  AppLogger.debug('WebView 콘솔: ${consoleMessage.message}', tag: _tag);
                },
              ),
            ),
          ),
        ),
      );

      if (result != null) {
        AppLogger.info('주소 검색 성공: ${result.toString()}', tag: _tag);
        return PostcodeResult(
          zipCode: result.zonecode ?? '',
          address1: result.address ?? '',
          address2: '',
        );
      }

      AppLogger.info('주소 검색 취소됨', tag: _tag);
      return null;
    } catch (e, stackTrace) {
      AppLogger.error('모바일 우편번호 검색 오류',
          tag: _tag, error: e, stackTrace: stackTrace);
      return null;
    }
  }

  /// 데스크톱/Windows용 우편번호 검색
  static Future<PostcodeResult?> _searchAddressDesktop(BuildContext context) async {
    try {
      PostcodeResult? result;

      await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return Dialog(
            child: SizedBox(
              width: 600,
              height: 500,
              child: _SimplePostcodeWidget(
                onAddressSelected: (postcodeResult) {
                  result = postcodeResult;
                  Navigator.of(dialogContext).pop();
                },
                onClose: () {
                  Navigator.of(dialogContext).pop();
                },
              ),
            ),
          );
        },
      );

      if (result != null) {
        AppLogger.info('데스크톱 주소 검색 성공: ${result.toString()}', tag: _tag);
      } else {
        AppLogger.info('데스크톱 주소 검색 취소됨', tag: _tag);
      }

      return result;
    } catch (e, stackTrace) {
      AppLogger.error('데스크톱 우편번호 검색 오류',
          tag: _tag, error: e, stackTrace: stackTrace);
      return null;
    }
  }
}

/// Windows용 우편번호 검색 위젯 (flutter_inappwebview 사용)
class _DesktopPostcodeWidget extends StatefulWidget {
  final Function(PostcodeResult) onAddressSelected;
  final VoidCallback onClose;

  const _DesktopPostcodeWidget({
    required this.onAddressSelected,
    required this.onClose,
  });

  @override
  State<_DesktopPostcodeWidget> createState() => _DesktopPostcodeWidgetState();
}

class _DesktopPostcodeWidgetState extends State<_DesktopPostcodeWidget> {
  InAppWebViewController? _webViewController;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 타이틀 바
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.location_on, color: Colors.white),
              const SizedBox(width: 8),
              const Text(
                '우편번호 검색',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: widget.onClose,
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ],
          ),
        ),
        // WebView 영역
        Expanded(
          child: _hasError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      const Text(
                        'WebView 초기화 실패',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _errorMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => setState(() {
                          _hasError = false;
                          _isLoading = true;
                        }),
                        child: const Text('다시 시도'),
                      ),
                    ],
                  ),
                )
              : Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        InAppWebView(
                          initialFile: "assets/html/daum_postcode.html",
                          initialSettings: InAppWebViewSettings(
                            javaScriptEnabled: true,
                            domStorageEnabled: true,
                            allowsInlineMediaPlayback: true,
                            mediaPlaybackRequiresUserGesture: false,
                            transparentBackground: true,
                          ),
                          onWebViewCreated: (controller) {
                            _webViewController = controller;
                            AppLogger.info('WebView 생성됨, JavaScript 핸들러 등록 중', tag: 'PostcodeService');

                            // JavaScript 핸들러 등록
                            controller.addJavaScriptHandler(
                              handlerName: 'addressSelected',
                              callback: (args) {
                                try {
                                  AppLogger.info('JavaScript 핸들러 호출됨 - args: $args', tag: 'PostcodeService');
                                  if (args.isNotEmpty) {
                                    final data = args[0] as Map<String, dynamic>;
                                    AppLogger.info('주소 데이터 수신: $data', tag: 'PostcodeService');
                                    final result = PostcodeResult(
                                      zipCode: data['zonecode'] ?? '',
                                      address1: data['roadAddress'] ?? data['address'] ?? '',
                                      address2: '',
                                    );
                                    AppLogger.info('PostcodeResult 생성: $result', tag: 'PostcodeService');
                                    widget.onAddressSelected(result);
                                  } else {
                                    AppLogger.warning('빈 args 수신됨', tag: 'PostcodeService');
                                  }
                                } catch (e) {
                                  AppLogger.error('주소 선택 처리 오류', tag: 'PostcodeService', error: e);
                                }
                              },
                            );

                            controller.addJavaScriptHandler(
                              handlerName: 'addressClosed',
                              callback: (args) {
                                AppLogger.info('주소 검색 취소됨 (JavaScript 핸들러)', tag: 'PostcodeService');
                                widget.onClose();
                              },
                            );
                          },
                          onLoadStart: (controller, url) {
                            setState(() {
                              _isLoading = true;
                              _hasError = false;
                            });
                          },
                          onLoadStop: (controller, url) {
                            setState(() {
                              _isLoading = false;
                            });
                          },
                          onReceivedError: (controller, request, error) {
                            setState(() {
                              _isLoading = false;
                              _hasError = true;
                              _errorMessage = error.description;
                            });
                            AppLogger.error('WebView 로드 오류: ${error.description}', tag: 'PostcodeService');
                          },
                          onConsoleMessage: (controller, consoleMessage) {
                            AppLogger.debug('WebView Console: ${consoleMessage.message}', tag: 'PostcodeService');
                          },
                        ),
                        if (_isLoading)
                          const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 16),
                                Text('우편번호 서비스를 로딩하는 중...'),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

/// 간단한 Windows WebView를 사용하는 우편번호 검색 위젯
class _SimplePostcodeWidget extends StatefulWidget {
  final Function(PostcodeResult) onAddressSelected;
  final VoidCallback onClose;

  const _SimplePostcodeWidget({
    required this.onAddressSelected,
    required this.onClose,
  });

  @override
  State<_SimplePostcodeWidget> createState() => _SimplePostcodeWidgetState();
}

class _SimplePostcodeWidgetState extends State<_SimplePostcodeWidget> {
  InAppWebViewController? _webViewController;
  InAppLocalhostServer? _localhostServer;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _startServer();
  }

  @override
  void dispose() {
    _localhostServer?.close();
    super.dispose();
  }

  Future<void> _startServer() async {
    try {
      _localhostServer = InAppLocalhostServer(
        port: 8080,
        documentRoot: 'assets/html',
      );
      await _localhostServer!.start();
      AppLogger.info('로컬호스트 서버 시작됨: http://localhost:8080', tag: 'PostcodeService');
    } catch (e) {
      AppLogger.error('로컬호스트 서버 시작 실패', tag: 'PostcodeService', error: e);
      setState(() {
        _hasError = true;
        _errorMessage = '로컬 서버 시작 실패: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 타이틀 바
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.location_on, color: Colors.white),
              const SizedBox(width: 8),
              const Text(
                '우편번호 검색 (Simple WebView)',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: widget.onClose,
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ],
          ),
        ),
        // WebView 영역
        Expanded(
          child: _hasError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      const Text(
                        'WebView 초기화 실패',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _errorMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => setState(() {
                          _hasError = false;
                          _isLoading = true;
                        }),
                        child: const Text('다시 시도'),
                      ),
                    ],
                  ),
                )
              : Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        InAppWebView(
                          initialUrlRequest: URLRequest(
                            url: WebUri('http://localhost:8080/daum_postcode_simple.html'),
                          ),
                          initialSettings: InAppWebViewSettings(
                            javaScriptEnabled: true,
                            domStorageEnabled: true,
                            allowsInlineMediaPlayback: true,
                            mediaPlaybackRequiresUserGesture: false,
                            transparentBackground: true,
                            supportMultipleWindows: true,
                            javaScriptCanOpenWindowsAutomatically: true,
                            userAgent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
                          ),
                          onWebViewCreated: (controller) async {
                            _webViewController = controller;
                            AppLogger.info('Simple WebView 생성됨 (localhost 서버 사용)', tag: 'PostcodeService');

                            // JavaScript 핸들러 등록
                            controller.addJavaScriptHandler(
                              handlerName: 'addressSelected',
                              callback: (args) {
                                try {
                                  AppLogger.info('✅ Simple WebView 주소 선택 성공: $args', tag: 'PostcodeService');
                                  if (args.isNotEmpty) {
                                    final data = args[0] as Map<String, dynamic>;
                                    final result = PostcodeResult(
                                      zipCode: data['zonecode'] ?? '',
                                      address1: data['roadAddress'] ?? data['address'] ?? '',
                                      address2: '',
                                    );
                                    AppLogger.info('PostcodeResult 생성: $result', tag: 'PostcodeService');
                                    widget.onAddressSelected(result);
                                  }
                                } catch (e) {
                                  AppLogger.error('주소 선택 처리 오류', tag: 'PostcodeService', error: e);
                                }
                              },
                            );

                            // 창 닫기 핸들러 등록
                            controller.addJavaScriptHandler(
                              handlerName: 'closeWindow',
                              callback: (args) {
                                AppLogger.info('WebView 창 닫기 요청됨', tag: 'PostcodeService');
                                widget.onClose();
                              },
                            );
                          },
                          onCloseWindow: (controller) {
                            AppLogger.info('WebView onCloseWindow 호출됨', tag: 'PostcodeService');
                            widget.onClose();
                          },
                          onCreateWindow: (controller, createWindowAction) async {
                            AppLogger.info('WebView onCreateWindow 호출됨', tag: 'PostcodeService');
                            return true;
                          },
                          onLoadStart: (controller, url) {
                            setState(() {
                              _isLoading = true;
                              _hasError = false;
                            });
                          },
                          onLoadStop: (controller, url) {
                            setState(() {
                              _isLoading = false;
                            });
                          },
                          onReceivedError: (controller, request, error) {
                            setState(() {
                              _isLoading = false;
                              _hasError = true;
                              _errorMessage = error.description;
                            });
                            AppLogger.error('Simple WebView 로드 오류: ${error.description}', tag: 'PostcodeService');
                          },
                          onConsoleMessage: (controller, consoleMessage) {
                            AppLogger.debug('Simple WebView Console: ${consoleMessage.message}', tag: 'PostcodeService');
                          },
                        ),
                        if (_isLoading)
                          const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 16),
                                Text('우편번호 서비스를 로딩하는 중...'),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

/// webview_flutter를 사용하는 우편번호 검색 위젯
class _WebviewFlutterPostcodeWidget extends StatefulWidget {
  final Function(PostcodeResult) onAddressSelected;
  final VoidCallback onClose;

  const _WebviewFlutterPostcodeWidget({
    required this.onAddressSelected,
    required this.onClose,
  });

  @override
  State<_WebviewFlutterPostcodeWidget> createState() => _WebviewFlutterPostcodeWidgetState();
}

class _WebviewFlutterPostcodeWidgetState extends State<_WebviewFlutterPostcodeWidget> {
  late final webview_flutter.WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    try {
      _controller = webview_flutter.WebViewController()
        ..setJavaScriptMode(webview_flutter.JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          webview_flutter.NavigationDelegate(
            onProgress: (int progress) {
              // 로딩 진행률
            },
            onPageStarted: (String url) {
              setState(() {
                _isLoading = true;
                _hasError = false;
              });
            },
            onPageFinished: (String url) {
              setState(() {
                _isLoading = false;
              });
            },
            onWebResourceError: (webview_flutter.WebResourceError error) {
              setState(() {
                _isLoading = false;
                _hasError = true;
                _errorMessage = error.description;
              });
              AppLogger.error('WebView 리소스 오류: ${error.description}', tag: 'PostcodeService');
            },
          ),
        )
        ..addJavaScriptChannel(
          'FlutterChannel',
          onMessageReceived: (webview_flutter.JavaScriptMessage message) {
            try {
              AppLogger.info('webview_flutter 메시지 수신: ${message.message}', tag: 'PostcodeService');
              final data = jsonDecode(message.message) as Map<String, dynamic>;

              if (data['action'] == 'addressSelected') {
                final addressData = data['data'] as Map<String, dynamic>;
                final result = PostcodeResult(
                  zipCode: addressData['zonecode'] ?? '',
                  address1: addressData['roadAddress'] ?? addressData['address'] ?? '',
                  address2: '',
                );
                AppLogger.info('webview_flutter PostcodeResult 생성: $result', tag: 'PostcodeService');
                widget.onAddressSelected(result);
              } else if (data['action'] == 'close') {
                AppLogger.info('webview_flutter 주소 검색 취소됨', tag: 'PostcodeService');
                widget.onClose();
              }
            } catch (e) {
              AppLogger.error('webview_flutter 메시지 처리 오류', tag: 'PostcodeService', error: e);
            }
          },
        );

      // assets HTML 파일 로드
      _controller.loadFlutterAsset('assets/html/daum_postcode_webview.html');

      AppLogger.info('webview_flutter WebView 초기화 완료', tag: 'PostcodeService');
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = e.toString();
      });
      AppLogger.error('webview_flutter WebView 초기화 오류', tag: 'PostcodeService', error: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 타이틀 바
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.location_on, color: Colors.white),
              const SizedBox(width: 8),
              const Text(
                '우편번호 검색 (webview_flutter)',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: widget.onClose,
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ],
          ),
        ),
        // WebView 영역
        Expanded(
          child: _hasError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      const Text(
                        'WebView 초기화 실패',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _errorMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => _initializeWebView(),
                        child: const Text('다시 시도'),
                      ),
                    ],
                  ),
                )
              : Stack(
                  children: [
                    webview_flutter.WebViewWidget(controller: _controller),
                    if (_isLoading)
                      const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('우편번호 서비스를 로딩하는 중...'),
                          ],
                        ),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}

