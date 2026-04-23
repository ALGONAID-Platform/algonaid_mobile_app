import 'open_external_url_stub.dart'
    if (dart.library.html) 'open_external_url_web.dart'
    as platform;

void openExternalUrl(String url) {
  platform.openExternalUrl(url);
}
