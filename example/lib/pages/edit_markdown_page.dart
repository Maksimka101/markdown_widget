// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../markdown_custom/custom_node.dart';
import '../markdown_custom/db.dart';
import '../markdown_custom/latex.dart';
import '../markdown_custom/video.dart';
import '../platform_dector/platform_dector.dart';

import 'markdown_page.dart';

class EditMarkdownPage extends StatefulWidget {
  final String initialData;

  const EditMarkdownPage({Key? key, this.initialData = ''}) : super(key: key);

  @override
  _EditMarkdownPageState createState() => _EditMarkdownPageState();
}

class _EditMarkdownPageState extends State<EditMarkdownPage> {
  final String initialText =
      '[Welcome for pull request](https://github.com/asjqkkkk/markdown_widget)😄\n\n';
  String text = '';
  final bool isMobile =
      PlatformDetector.isMobile || PlatformDetector.isWebMobile;

  @override
  void initState() {
    text = widget.initialData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isMobile
          ? AppBar(
              title: Text('Edit Markdown'),
              backgroundColor: Colors.black,
            )
          : null,
      body: isMobile ? buildMobileBody() : buildWebBody(),
      floatingActionButton: isMobile
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                  return MarkdownPage(
                    markdownData: text,
                  );
                }));
              },
              child: Icon(
                Icons.remove_red_eye,
              ),
            )
          : FloatingActionButton(
              onPressed: () => Navigator.pop(context),
              child: Icon(
                Icons.arrow_back,
              ),
            ),
    );
  }

  Widget buildMobileBody() {
    return buildEditText();
  }

  Widget buildWebBody() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: <Widget>[
        Expanded(child: buildEditText()),
        Expanded(
          child: MarkdownWidget(
            data: initialText + text,
            config: isDark
                ? MarkdownConfig.darkConfig
                : MarkdownConfig.defaultConfig,
            markdownGeneratorConfig: MarkdownGeneratorConfig(
                generators: [
                  videoGeneratorWithTag,
                  latexGeneratorWithTag,
                  dbGeneratorWithTag,
                ],
                inlineSyntaxList: [DBSyntax()],
                textGenerator: (node, config, visitor) =>
                    CustomTextNode(node.textContent, config, visitor)),
          ),
        ),
      ],
    );
  }

  Widget buildEditText() {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        border: Border.all(
          color: Colors.black,
          width: 3,
        ),
      ),
      child: TextFormField(
        expands: true,
        maxLines: null,
        textInputAction: TextInputAction.newline,
        initialValue: text,
        onChanged: (text) {
          this.text = text;
          refresh();
        },
        style: TextStyle(textBaseline: TextBaseline.alphabetic),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10),
            border: InputBorder.none,
            hintText: 'Input Here...',
            hintStyle: TextStyle(color: Colors.grey)),
      ),
    );
  }

  void refresh() {
    if (mounted && !isMobile) setState(() {});
  }
}

launchURL(String? url) async {
  if (url == null) throw 'No url found!';
  Uri? uri = Uri.tryParse(url);
  if (uri == null) throw '$url unavailable';
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch $url';
  }
}
