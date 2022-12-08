import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../cards/repository_card.dart';
import '../constant/static_string.dart';
import '../provider/repository_provider.dart';
import '../screens/repository_commit.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/no_content_label.dart';

class FreeCodeRepositoryScreen extends StatefulWidget {
  const FreeCodeRepositoryScreen({super.key});

  @override
  State<FreeCodeRepositoryScreen> createState() =>
      _FreeCodeRepositoryScreenState();
}

class _FreeCodeRepositoryScreenState extends State<FreeCodeRepositoryScreen> {
  // Loading indicator...
  final LoadingIndicatorNotifier _loadingIndicatorNotifier =
      LoadingIndicatorNotifier();

  // Controller...
  final TextEditingController _searchController = TextEditingController();

  GithubProvider get githubprovider =>
      Provider.of<GithubProvider>(context, listen: false);

  @override
  void initState() {
    fetchRepositoryDataList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: _buildBody(),
    );
  }

  // Appbar...
  AppBar _buildAppbar() {
    return AppBar(
      title: const Text(StaticString.freeCodeCampReository),
      centerTitle: false,
    );
  }

  // Body...
  Widget _buildBody() {
    return LoadingIndicator(
      loadingStatusNotifier: _loadingIndicatorNotifier,
      child: Consumer<GithubProvider>(
        builder: (context, github, child) => Column(
          children: [
            _buildSerchTextformField(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await githubprovider.fetchGithubData();
                },
                child: Scrollbar(
                  child: SingleChildScrollView(
                      padding: const EdgeInsets.only(
                        left: 15,
                        right: 15,
                      ),
                      physics: const ClampingScrollPhysics(),
                      child: github.githubDataList.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.only(top: 180),
                              child: NoContentLabel(
                                title: StaticString.nodataFound,
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                vertical: 20,
                              ),
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: github.githubDataList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () {
                                    moveToRepoCommitScreen(
                                        github.githubDataList[index].name);
                                  },
                                  child: RepositoryCard(
                                    githubDemoModel:
                                        github.githubDataList[index],
                                  ),
                                );
                              },
                            )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Search textFormField...
  Widget _buildSerchTextformField() {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(
        top: 20,
        left: 15,
        right: 15,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: TextFormField(
          controller: _searchController,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(10.0),
            focusColor: Colors.grey,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.grey)),
            hintText: StaticString.search,
          ),
          onChanged: (value) {
            _searchController.text = value;
            _searchController.selection = TextSelection.fromPosition(
                TextPosition(offset: _searchController.text.length));
            githubprovider.serchRepoData(_searchController.text);
          },
        ),
      ),
    );
  }

  // Move to repocommit screen...
  void moveToRepoCommitScreen(String repositoryName) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => RepositoryCommit(
          repoName: repositoryName,
        ),
      ),
    );
  }

  // Github fetchData...
  Future<void> fetchRepositoryDataList() async {
    try {
      _loadingIndicatorNotifier.show(
        loadingIndicatorType: LoadingIndicatorType.spinner,
      );
      await githubprovider.fetchGithubData();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      _loadingIndicatorNotifier.hide();
    }
  }
}
