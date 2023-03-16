import 'package:frappe_app/utils/enums.dart';

extension SaveDocActionE7n on SaveDocAction {
  String toMap() {
    switch (this) {
      case SaveDocAction.cancel:
        return "Cancel";
      case SaveDocAction.submit:
        return "Submit";
      case SaveDocAction.update:
        return "Update";
      case SaveDocAction.save:
      default:
        return "Save";
    }
  }
}
