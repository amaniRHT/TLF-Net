import 'package:e_loan_mobile/config/config.dart';
import 'package:flutter/material.dart';

typedef DeleteTag<T> = void Function(T index);

typedef TagTitle<String> = Widget Function(String tag);

class FlutterTagView extends StatefulWidget {
  const FlutterTagView({
    @required this.tags,
    this.minTagViewHeight = 0,
    this.maxTagViewHeight = 150,
    this.tagBackgroundColor = AppColors.bgGrey,
    this.selectedTagBackgroundColor = Colors.transparent,
    this.deletableTag = true,
    this.onDeleteTag,
    this.tagTitle,
  }) : assert(
          tags != null,
          "Tags can't be empty\n"
          'Provide the list of tags',
        );

  final List<dynamic> tags;

  final Color tagBackgroundColor;

  final Color selectedTagBackgroundColor;

  final bool deletableTag;

  final double maxTagViewHeight;

  final double minTagViewHeight;

  final DeleteTag<int> onDeleteTag;

  final TagTitle<String> tagTitle;

  @override
  _FlutterTagViewState createState() => _FlutterTagViewState();
}

class _FlutterTagViewState extends State<FlutterTagView> {
  int selectedTagIndex = -1;

  @override
  Widget build(BuildContext context) {
    return getTagView();
  }

  Widget getTagView() {
    return ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: widget.minTagViewHeight,
          //maxHeight: widget.maxTagViewHeight,
        ),
        child: Wrap(
          spacing: 8.0,
          children: buildTags(),
        ));
  }

  List<Widget> buildTags() {
    final List<Widget> tags = <Widget>[];

    for (int i = 0; i < widget.tags.length; i++) {
      if (widget.tags[i].value.isNotEmpty) {
        tags.add(createTag(i, widget.tags[i].value));
      }
    }

    return tags;
  }

  Widget createTag(int index, String tagTitle) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        setState(() {
          selectedTagIndex = index;
        });
      },
      child: Chip(
        elevation: 5,
        shadowColor: Colors.black87,
        backgroundColor: widget.tagBackgroundColor,
        label: widget.tagTitle == null
            ? Text(
                tagTitle,
                style: AppStyles.semiBoldBlue11,
              )
            : widget.tagTitle(tagTitle),
        deleteIcon: const Icon(
          Icons.close,
          color: AppColors.orange,
          size: 15,
        ),
        onDeleted: widget.deletableTag
            ? () {
                if (widget.deletableTag) deleteTag(index);
              }
            : null,
      ),
    );
  }

  void deleteTag(int index) {
    if (widget.onDeleteTag != null)
      widget.onDeleteTag(index);
    else {
      setState(() {
        widget.tags.removeAt(index);
      });
    }
  }
}
