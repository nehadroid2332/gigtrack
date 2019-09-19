import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class NumberTextInputFormatter extends TextInputFormatter {
  int _whichNumber;
  NumberTextInputFormatter(this._whichNumber);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = StringBuffer();
    switch (_whichNumber) {
      case 1:
        {
          if (newTextLength >= 1 ) {

            if (newValue.selection.end >= 1) selectionIndex++;
          }
          if (newTextLength >= 4 ) {
            newText.write(
                newValue.text.substring(0, usedSubstringIndex = 3) + '-');
            if (newValue.selection.end >= 3) selectionIndex += 2;
          }
          if (newTextLength >= 7 ) {
            newText.write(
                newValue.text.substring(3, usedSubstringIndex = 6) + '-');
            if (newValue.selection.end >= 6) selectionIndex++;
          }
          if (newTextLength >= 11 ) {
            newText.write(
                newValue.text.substring(6, usedSubstringIndex = 10) + ' ');
            if (newValue.selection.end >= 10) selectionIndex++;
          }
          break;
        }
      case 91:
        {
          if (newTextLength >= 5) {
            newText.write(
                newValue.text.substring(0, usedSubstringIndex = 5) + ' ');
            if (newValue.selection.end >= 6) selectionIndex++;
          }
          break;
        }
    }
    // Dump the rest.
    if (newTextLength >= usedSubstringIndex)
      newText.write(newValue.text.substring(usedSubstringIndex));
    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}