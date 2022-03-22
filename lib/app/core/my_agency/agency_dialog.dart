import 'package:e_loan_mobile/app/controllers.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

class AgencyDialog extends StatefulWidget {
  const AgencyDialog({Key key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<AgencyDialog> {
  final AgencyController controller = Get.find();

  final int userId = Get.arguments as int;

  @override
  void initState() {
    controller.fillFieldsWithAgencyDetails();
    super.initState();
  }

  @override
  void dispose() {
    controller.myAgency = AgencyModel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AgencyController>(
      builder: (_) {
        return Center(
          child: KeyboardDismissOnTap(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: _buildContent(),
              ),
            ),
          ),
        );
      },
    );
  }

  Wrap _buildContent() {
    return Wrap(
      children: [
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    spreadRadius: 5,
                  )
                ],
              ),
              child: Stack(
                alignment: Alignment.topLeft,
                children: [
                  Positioned(
                    top: 8,
                    right: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Icon(
                        Icons.close,
                        size: 25,
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        primary: AppColors.orange,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24, right: 36, top: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFields(),
                        const VerticalSpacing(33),
                      ],
                    ),
                  )
                ],
              ),
            ),
            VerticalSpacing(60)
          ],
        )
      ],
    );
  }

  Column _buildFields() {
    const double _betweenTextFieldsSpacing = 20;
    return Column(
      children: <Widget>[
        const VerticalSpacing(_betweenTextFieldsSpacing),
        buildSection(
          iconData: Icons.room,
          sectionTitle: 'Agence',
          value: controller.myAgency.name,
        ),
        const VerticalSpacing(_betweenTextFieldsSpacing),
        buildSection(
          iconData: Icons.room,
          sectionTitle: 'Adresse',
          value: controller.myAgency.address,
        ),
        const VerticalSpacing(_betweenTextFieldsSpacing),
        buildSection(
          iconData: Icons.assignment_ind,
          sectionTitle: 'Votre contact',
          value: controller.myAgency.contactName.capitalize,
        ),
        const VerticalSpacing(_betweenTextFieldsSpacing),
        buildSection(
          iconData: Icons.phone,
          sectionTitle: 'Téléphone',
          value: controller.myAgency.phone,
        ),
        const VerticalSpacing(_betweenTextFieldsSpacing),
        buildSection(
          iconData: Icons.alternate_email,
          sectionTitle: 'Email',
          value: controller.myAgency.email,
        ),
      ],
    );
  }

  Widget buildSection({
    final IconData iconData,
    final String sectionTitle,
    final String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              iconData,
              color: AppColors.blue,
              size: 25,
            ),
            const HorizontalSpacing(5),
            Text(sectionTitle, style: AppStyles.boldBlue14)
          ],
        ),
        const VerticalSpacing(6),
        Padding(
          padding: const EdgeInsets.only(left: 28.0),
          child: Text(
            value,
            style: AppStyles.mediumDarkGrey13.copyWith(fontSize: 14),
          ),
        )
      ],
    );
  }
}
