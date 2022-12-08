import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constant/color_constant.dart';
import '../constant/image_constant.dart';
import '../constant/static_string.dart';
import '../model/repository_model.dart';
import '../utils/custom_extension.dart';
import '../widgets/custom_text.dart';

class RepositoryCard extends StatefulWidget {
  final GithubRepositoryModel githubDemoModel;
  const RepositoryCard({super.key, required this.githubDemoModel});

  @override
  State<RepositoryCard> createState() => _RepositoryCardState();
}

class _RepositoryCardState extends State<RepositoryCard> {
  ValueNotifier topicListHover = ValueNotifier(true);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 20, left: 5, right: 5),
      decoration: _commonCardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRepositoryNameAndVisibility(),
          SizedBox(
              height: (widget.githubDemoModel.description.isNotEmpty) ? 10 : 0),
          _buildDescriptionText(),
          const SizedBox(height: 10),
          widget.githubDemoModel.topics.isNotEmpty
              ? _buildTopicList(context)
              : const SizedBox.shrink(),
          const SizedBox(height: 5),
          _buildLanguageCount(context),
          const SizedBox(height: 10),
          _buildUpdatedtimeAndIconandcountRow(context)
        ],
      ),
    );
  }

  // Repo name and visibility view...
  Widget _buildRepositoryNameAndVisibility() {
    return Wrap(
      children: [
        CustomText(
          txtTitle: widget.githubDemoModel.name,
          style: Theme.of(context).textTheme.headline6?.copyWith(
                color: Colors.blue,
              ),
        ),
        const SizedBox(
          width: 10,
        ),
        Container(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                )),
            child: CustomText(
              txtTitle: widget.githubDemoModel.visibility.capitalize(),
              style: Theme.of(context).textTheme.bodyText2?.copyWith(
                    color: Colors.grey,
                  ),
            )),
      ],
    );
  }
  

  // Repo description text...
  Widget _buildDescriptionText() {
    return widget.githubDemoModel.description.isNotEmpty
        ? CustomText(
            txtTitle: widget.githubDemoModel.description,
            style: Theme.of(context).textTheme.bodyText1,
          )
        : const SizedBox.shrink();
  }
  

  // updated time and iconcount view...
  Widget _buildUpdatedtimeAndIconandcountRow(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        children: [
          const Icon(
            Icons.star_outline_sharp,
            size: 18,
          ),
          const SizedBox(
            width: 3,
          ),
          CustomText(
            txtTitle: widget.githubDemoModel.watchers.toString(),
            style: Theme.of(context).textTheme.bodyText2,
          ),
          const SizedBox(width: 18),
          SvgPicture.asset(
            ImgName.issueIcon,
            height: 15,
            width: 15,
          ),
          const SizedBox(
            width: 3,
          ),
          CustomText(
            txtTitle: widget.githubDemoModel.openIssues.toString(),
            style: Theme.of(context).textTheme.bodyText2,
          ),
          const SizedBox(
            width: 18,
          ),
          SvgPicture.asset(
            ImgName.pullIcon,
            height: 15,
            width: 15,
          ),
          const SizedBox(
            width: 3,
          ),
          CustomText(
            txtTitle: widget.githubDemoModel.openIssuesCount.toString(),
            style: Theme.of(context).textTheme.bodyText2,
          ),
          const SizedBox(
            width: 18,
          ),
          CustomText(
            txtTitle:
                "${StaticString.updated} ${widget.githubDemoModel.updatedAt?.timeAgo()}",
            style: Theme.of(context).textTheme.bodyText2,
          )
        ],
      ),
    );
  }

  // TopicListView...
  Widget _buildTopicList(BuildContext context) {
    return widget.githubDemoModel.topics.isNotEmpty
        ? ValueListenableBuilder(
            valueListenable: topicListHover,
            builder: (BuildContext context, dynamic value, Widget? child) {
              return Wrap(
                children: List.generate(widget.githubDemoModel.topics.length,
                    (index) {
                  return InkWell(
                    onHover: (value) {
                      widget.githubDemoModel.isSelected = value;
                      topicListHover.notifyListeners();
                    },
                    child: Padding(
                      padding:
                          const EdgeInsets.only(right: 5, top: 3, bottom: 3),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.blue.withOpacity(0.1)),
                        child: CustomText(
                          txtTitle: widget.githubDemoModel.topics[index],
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              ?.copyWith(
                                  color: widget.githubDemoModel.isSelected
                                      ? Colors.white
                                      : Colors.blue),
                        ),
                      ),
                    ),
                  );
                }),
              );
            })
        : const SizedBox.shrink();
  }

//  language count and icon...
  Widget _buildLanguageCount(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        children: [
          widget.githubDemoModel.language.isEmpty
              ? const SizedBox.shrink()
              : CircleAvatar(
                  backgroundColor:
                      languageColor(widget.githubDemoModel.language),
                  radius: 6,
                ),
          SizedBox(
            width: widget.githubDemoModel.language.isEmpty ? 0 : 4,
          ),
          CustomText(
            txtTitle: widget.githubDemoModel.language,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          SizedBox(
            width: widget.githubDemoModel.language.isEmpty ? 0 : 15,
          ),
          (widget.githubDemoModel.license?.spdxId.isNotEmpty ?? false)
              ? const Icon(
                  Icons.balance_sharp,
                  size: 18,
                )
              : const SizedBox.shrink(),
          SizedBox(
              width:
                  (widget.githubDemoModel.license?.spdxId.isNotEmpty ?? false)
                      ? 4
                      : 0),
          CustomText(
            txtTitle: widget.githubDemoModel.license?.spdxId,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          SizedBox(
            width: (widget.githubDemoModel.license?.spdxId.isNotEmpty ?? false)
                ? 15
                : 0,
          ),
          SvgPicture.asset(
            ImgName.dataIcon,
            width: 15,
            height: 15,
            // color: ColorConstant.custGreyE3E2E2,
          ),
          const SizedBox(
            width: 3,
          ),
          CustomText(
            txtTitle: widget.githubDemoModel.forks.toString(),
            style: Theme.of(context).textTheme.bodyText2,
          ),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
    );
  }

  // diffrent color accroding language method...
  Color languageColor(String language) {
    switch (language) {
      case "TypeScript":
        return ColorConstant.custBlue4831D4;
      case "Python":
        return ColorConstant.custDarkTeal017781;
      case "JavaScript":
        return ColorConstant.custLightGreenCDCB1C;
      case "HTML":
        return Colors.grey;
      case "R":
        return Colors.greenAccent;
      case "Jupyter Notebook":
        return Colors.purpleAccent;
      case "CSS":
        return Colors.redAccent;
      default:
    }
    return Colors.white;
  }

  // Common box Decoration...
  final BoxDecoration _commonCardDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        blurRadius: 8,
        offset: const Offset(0, 5),
      ),
    ],
  );
}
