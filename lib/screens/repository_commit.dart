import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../constant/image_constant.dart';
import '../constant/static_string.dart';
import '../provider/repository_provider.dart';
import '../utils/custom_extension.dart';
import '../widgets/custom_text.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/no_content_label.dart';

class RepositoryCommit extends StatefulWidget {
  final String repoName;

  const RepositoryCommit({super.key, required this.repoName});

  @override
  State<RepositoryCommit> createState() => _RepositoryCommitState();
}

class _RepositoryCommitState extends State<RepositoryCommit> {
  // Variables...
  final LoadingIndicatorNotifier _loadingIndicatorNotifier =
      LoadingIndicatorNotifier();

  // Providers...
  GithubProvider get githubprovider =>
      Provider.of<GithubProvider>(context, listen: false);

  @override
  void initState() {
    fetchRepositoryCommitList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppbar(),
      body: _buildBody(),
    );
  }

  // Appbar...
  AppBar _buildAppbar() => AppBar(
        title: const Text(StaticString.commit),
        centerTitle: false,
      );

  // Body...
  Widget _buildBody() {
    return LoadingIndicator(
      loadingStatusNotifier: _loadingIndicatorNotifier,
      child: Consumer<GithubProvider>(
          builder: (context, repositoryCommitData, child) {
        return repositoryCommitData.repositorycommitList.isEmpty
            ? NoContentLabel(
                title: StaticString.nodataFound,
                onPress: () async {
                  await fetchRepositoryCommitList();
                },
              )
            : RefreshIndicator(
                onRefresh: () async {
                  await githubprovider.repositoryCommitData(widget.repoName);
                },
                child: Scrollbar(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    shrinkWrap: true,
                    itemCount: repositoryCommitData.repositorycommitList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildrepositoryCommitInfoList(
                          repositoryCommitData, index, context);
                    },
                  ),
                ),
              );
      }),
    );
  }

  // Repository info list...
  Widget _buildrepositoryCommitInfoList(
      GithubProvider repositoryCommitData, int index, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntrinsicHeight(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    const VerticalDivider(
                      color: Colors.grey,
                    ),
                    Container(
                      color: Colors.white,
                      child: SvgPicture.asset(
                        ImgName.viewerOutputIcon,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: CustomText(
                    txtTitle:
                        "${StaticString.commitedOn} ${repositoryCommitData.repositorycommitList[index].commit?.committer?.date?.monthYear}",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              ],
            ),
          ),
        ),
        _buildRepoCommitCard(repositoryCommitData, index, context),
      ],
    );
  }

  // Repo commit info card...
  Widget _buildRepoCommitCard(
      GithubProvider repositoryCommitData, int index, BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            txtTitle: repositoryCommitData
                .repositorycommitList[index].commit?.message,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          const SizedBox(height: 10),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(repositoryCommitData
                          .repositorycommitList[index].avatarImageUrl.isNotEmpty
                      ? repositoryCommitData
                          .repositorycommitList[index].avatarImageUrl
                      : ImgName.deafaultAvtarImage),
                ),
                const SizedBox(
                  width: 10,
                ),
                CustomText(
                  txtTitle: repositoryCommitData
                      .repositorycommitList[index].author?.login,
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(
                  width: 10,
                ),
                CustomText(
                  txtTitle:
                      "${StaticString.committed} ${repositoryCommitData.repositorycommitList[index].commit?.committer?.date?.timeAgo()}",
                  style: Theme.of(context).textTheme.bodyText1,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // Repository commitlist api call...
  Future<void> fetchRepositoryCommitList() async {
    try {
      _loadingIndicatorNotifier.show(
        loadingIndicatorType: LoadingIndicatorType.spinner,
      );
      await githubprovider.repositoryCommitData(widget.repoName);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      _loadingIndicatorNotifier.hide();
    }
  }
}
