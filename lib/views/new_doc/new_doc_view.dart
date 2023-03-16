// @dart=2.9

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frappe_app/model/common.dart';
import 'package:frappe_app/utils/form_helper.dart';
import 'package:frappe_app/utils/frappe_alert.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/utils/loading_indicator.dart';
import 'package:frappe_app/views/base_view.dart';
import 'package:frappe_app/views/new_doc/new_doc_viewmodel.dart';
import 'package:frappe_app/widgets/header_app_bar.dart';
import 'package:provider/provider.dart';

import '../../model/doctype_response.dart';
import '../../utils/enums.dart';
import '../../widgets/custom_form.dart';

class NewDoc extends StatefulWidget {
  final DoctypeResponse meta;

  const NewDoc({
    @required this.meta,
  });

  @override
  _NewDocState createState() => _NewDocState();
}

final formHelper = FormHelper();

class _NewDocState extends State<NewDoc> {
  @override
  Widget build(BuildContext context) {
    Provider.of<ConnectivityStatus>(
      context,
    );

    return BaseView<NewDocViewModel>(
      onModelReady: (model) {
        model.meta = widget.meta;
        model.init();
      },
      builder: (context, model, child) => Builder(
        builder: (context) {
          return Scaffold(
            appBar: buildAppBar(
              title: "New ${widget.meta.docs[0].name}",
            ),
            body: CustomForm(
              doc: model.newDoc,
              formHelper: formHelper,
              meta: widget.meta.docs[0],
              fields: model.newDocFields,
              onSave: () async {
                if (formHelper.saveAndValidate()) {
                  var formValue = formHelper.getFormValue();

                  try {
                    await model.saveDoc(
                      formValue: formValue,
                      meta: widget.meta,
                      context: context,
                    );
                  } catch (e) {
                    LoadingIndicator.stopLoading();

                    var _e = e as ErrorResponse;

                    if (_e.statusCode == HttpStatus.serviceUnavailable) {
                      noInternetAlert(
                        context,
                      );
                    } else {
                      FrappeAlert.errorAlert(
                        title: _e.statusMessage,
                        context: context,
                      );
                    }
                  }
                }
              },
            ),
          );
        },
      ),
    );
  }
}
