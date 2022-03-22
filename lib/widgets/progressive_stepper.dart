import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ProgressiveStepper extends StatelessWidget {
  const ProgressiveStepper({
    Key key,
    this.done = false,
    this.activeStep = false,
    this.stepNumber,
    this.stepLabel,
    this.isLastStep = false,
    this.onTap,
  }) : super(key: key);

  final bool done;
  final bool activeStep;
  final int stepNumber;
  final String stepLabel;
  final bool isLastStep;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                children: <Widget>[
                  const VerticalSpacing(2),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: done
                          ? AppColors.green
                          : activeStep
                              ? AppColors.orange
                              : AppColors.lightBlue,
                      shape: BoxShape.circle,
                    ),
                    child: done
                        ? const Icon(
                            Icons.check,
                            size: 10,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  const VerticalSpacing(1),
                  if (!isLastStep)
                    Container(
                      width: 1,
                      height: 8,
                      color: AppColors.blue,
                    ),
                ],
              ),
              const HorizontalSpacing(8),
              Text(
                'Etape $stepNumber.',
                style: activeStep || done
                    ? AppStyles.regularBlue12
                    : AppStyles.inactiveRegularBlue12,
              ),
              const HorizontalSpacing(15),
              GestureDetector(
                onTap: onTap,
                child: Text(
                  stepLabel,
                  style: activeStep || done
                      ? AppStyles.boldBlue12
                      : AppStyles.inactiveBoldBlue12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
