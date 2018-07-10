// Copyright (c) 2018, the Zefyr project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/src/widgets/editable_paragraph.dart';
import 'package:zefyr/zefyr.dart';

import '../testing.dart';

void main() {
  group('$ZefyrEditor', () {
    testWidgets('allows merging theme data', (tester) async {
      var delta = new Delta()
        ..insert(
          'Website',
          NotusAttribute.link.fromString('https://github.com').toJson(),
        )
        ..insert('\n');
      var doc = new NotusDocument.fromDelta(delta);
      var theme = ZefyrThemeData(linkStyle: TextStyle(color: Colors.red));
      var editor =
          new EditorSandBox(tester: tester, document: doc, theme: theme);
      await editor.tapEditor();
      EditableParagraph p = tester.widget(find.byType(EditableParagraph).first);
      expect(p.text.children.first.style.color, Colors.red);
    });

    testWidgets('collapses selection when unfocused', (tester) async {
      final editor = new EditorSandBox(tester: tester);
      await editor.tapEditor();
      await editor.updateSelection(base: 0, extent: 3);
      expect(editor.findSelectionHandle(), findsNWidgets(2));
      await editor.tapHideKeyboardButton();
      expect(editor.findSelectionHandle(), findsNothing);
      expect(editor.selection, TextSelection.collapsed(offset: 3));
    });
  });
}