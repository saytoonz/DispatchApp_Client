import 'package:dispatch_app_client/model/dispatch.dart';
import 'package:dispatch_app_client/provider/dispatchProvider.dart';
import 'package:dispatch_app_client/ui/pages/auth/signUpPage.dart';
import 'package:dispatch_app_client/ui/pages/dispatch/confirmDispatch.dart';
import 'package:dispatch_app_client/ui/pages/home/homePage.dart';
import 'package:dispatch_app_client/ui/widgets/appButtonWidget.dart';
import 'package:dispatch_app_client/ui/widgets/appInputWidget.dart';
import 'package:dispatch_app_client/ui/widgets/appLogo.dart';
import 'package:dispatch_app_client/ui/widgets/appTextWidget.dart';
import 'package:dispatch_app_client/utils/appStyles.dart';
import 'package:dispatch_app_client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipientPage extends StatefulWidget {
  static final String routeName = "recipient-page";

  @override
  _RecipientPageState createState() => _RecipientPageState();
}

class _RecipientPageState extends State<RecipientPage> {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _packageDescriptionController =
      new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  _saveRecipient() {
    bool isValid = _formKey.currentState.validate();
    if (!isValid) return;
    recieverName = _nameController.text;
    recieverPhone = _phoneController.text;
    currentDispatch = new Dispatch(
        id: currentDispatch.id,
        userId: currentDispatch.userId,
        trackingNo: currentDispatch.trackingNo,
        dispatchRiderId: currentDispatch.dispatchRiderId,
        dispatchDate: currentDispatch.dispatchDate,
        pickUpLocation: currentDispatch.pickUpLocation,
        dispatchDestination: currentDispatch.dispatchDestination,
        dispatchBaseFare: currentDispatch.dispatchBaseFare,
        dispatchTotalFare: currentDispatch.dispatchTotalFare,
        dispatchType: currentDispatch.dispatchType,
        dispatchStatus: currentDispatch.dispatchStatus,
        currentLocation: currentDispatch.currentLocation,
        estimatedDIspatchDuration: currentDispatch.estimatedDIspatchDuration,
        estimatedDistance: currentDispatch.estimatedDistance,
        dispatchReciever: _nameController.text.trim(),
        dispatchRecieverPhone: _phoneController.text.trim(),
        dispatchDescription: _packageDescriptionController.text);

    Navigator.of(context).pushNamed(ConfirmDispatch.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final appSzie = Constant.getAppSize(context);
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      'assets/images/recipient.png',
                      scale: 2,
                    ),
                    SizedBox(
                      height: appSzie.height * 0.04,
                    ),
                    Text.rich(
                      AppTextWidget.appTextSpan("enter ", "Reciver Details"),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: appSzie.height * 0.03,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: AppTextInputWIdget(
                        labelText: "Name",
                        prefixIcon: FontAwesomeIcons.user,
                        obscureText: false,
                        controller: _nameController,
                        validator: (value) {
                          return Constant.stringValidator(value, "Name");
                        },
                      ),
                    ),
                    Padding(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 5),
                        child: AppTextInputWIdget(
                          labelText: "Phone",
                          prefixIcon: FontAwesomeIcons.phone,
                          obscureText: false,
                          controller: _phoneController,
                          validator: (value) {
                            return Constant.stringValidator(value, "Phone");
                          },
                        )),
                    Padding(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 5),
                        child: AppTextInputMultilineWIdget(
                          labelText: "Package Description",
                          prefixIcon: FontAwesomeIcons.shopify,
                          obscureText: false,
                          controller: _packageDescriptionController,
                          validator: (value) {
                            return Constant.stringValidator(
                                value, "Package Description");
                          },
                        )),
                    SizedBox(
                      height: appSzie.height * 0.06,
                    ),
                    AppButtonWudget(
                      buttonText: "PROCEED",
                      function: _saveRecipient,
                    ),
                    SizedBox(
                      height: appSzie.height * 0.03,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 15.0,
              left: 10.0,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Constant.primaryColorDark,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
