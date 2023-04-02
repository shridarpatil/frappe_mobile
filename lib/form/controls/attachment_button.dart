import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:frappe_app/config/palette.dart';
import 'package:frappe_app/form/controls/base_control.dart';
import 'package:frappe_app/form/controls/base_input.dart';
import 'package:frappe_app/model/doctype_response.dart';
import 'package:frappe_app/model/upload_file_response.dart';
import 'package:frappe_app/views/form_view/bottom_sheets/attachments/view_attachments_bottom_sheet_view.dart';
import 'package:uuid/uuid.dart';

class AttachmentButton extends StatefulWidget with Control, ControlInput {
  final Map? doc;
  final Key? key;
  final DoctypeField doctypeField;
  AttachmentButton({
    this.key,
    this.doc,
    required this.doctypeField,
  }) : super(key: key);

  @override
  State<AttachmentButton> createState() => _AttachmentButtonState();
}

class _AttachmentButtonState extends State<AttachmentButton> {
  UploadedFile? uploadedFile;
  TextEditingController attachmentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    attachmentController.text =
        widget.doc != null ? widget.doc![widget.doctypeField.fieldname] : "";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FormBuilderTextField(
        key: widget.key,
        readOnly: true,
        controller: attachmentController,
        name: widget.doctypeField.fieldname,
        decoration: Palette.formFieldDecoration(
          hintText: "Attach file",
          suffixIcon: attachmentController.text.trim().isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.cancel_outlined),
                  onPressed: () {
                    attachmentController.clear();
                  },
                )
              : Icon(Icons.attach_file),
        ),
        onTap: () async {
          uploadedFile = (await showModalBottomSheet(
            context: context,
            useRootNavigator: true,
            isScrollControlled: true,
            builder: (context) => ViewAttachmentsBottomSheetView(
              attachments: [],
              allowMultiple: false,
              doctype: widget.doctypeField.parent!,
              // TODO: Find way to do this better
              // TODO: Like make doctype-name and file-name same as a convention
              name: widget.doc!["name"] ?? Uuid().v4(),
            ),
          ))
              .first;

          if (uploadedFile != null) {
            setState(() {
              attachmentController.text = uploadedFile!.fileUrl;
            });
          }
        },
      ),
    );
  }
}
