import 'package:flutter/material.dart';
import 'package:github_task/api/api_end_points.dart';
import 'package:github_task/api/api_middleware.dart';
import 'package:github_task/model/repo_commit_model.dart';
import 'package:github_task/model/repository_model.dart';
import 'package:kd_api_call/kd_api_call.dart';

class GithubProvider extends ChangeNotifier {
  List<GithubRepositoryModel> _githubDataList = [];
  List<RepoCommitModel> _repositorycommitList = [];
  List<GithubRepositoryModel> repositoryCloneList = [];

  // Getter method ...
  List<GithubRepositoryModel> get githubDataList => _githubDataList;
  List<RepoCommitModel> get repositorycommitList => _repositorycommitList;

  // Setter method ...
  set repositorycommitList(List<RepoCommitModel> value) {
    _repositorycommitList = value;
    notifyListeners();
  }

  set githubDataList(List<GithubRepositoryModel> value) {
    _githubDataList = value;
    notifyListeners();
  }

  // Github repo api call...
  Future<void> fetchGithubData() async {
    try {
      final String response = await ApiMiddleware.instance.callService(
        requestInfo: APIRequestInfo(
          requestType: HTTPRequestType.GET,
          url: "${ApiEndPoints.freecodeCamprepo}${ApiEndPoints.repo}",
        ),
      );

      githubDataList = githubRepositoryModelFromJson(response);
      repositoryCloneList = githubRepositoryModelFromJson(response);

      githubDataList.sort(
        (a, b) {
          DateTime aupdatedDate = a.updatedAt ?? DateTime.now();
          DateTime bupdatedDate = b.updatedAt ?? DateTime.now();
          return bupdatedDate.compareTo(aupdatedDate);
        },
      );
    } on AppException catch (e) {
      throw e.getMessage;
    } catch (e) {
      rethrow;
    }
  }

  void serchRepoData(String search) {
    githubDataList = repositoryCloneList.where((element) {
      if (element.name.trim().toLowerCase().contains(search.toLowerCase())) {
        return true;
      } else {
        return false;
      }
    }).toList();
    notifyListeners();
  }

  // repo commitDataList api call...
  Future<void> repositoryCommitData(String repoName) async {
    try {
      final String response = await ApiMiddleware.instance.callService(
        requestInfo: APIRequestInfo(
          requestType: HTTPRequestType.GET,
          url:
              "${ApiEndPoints.repo}/${ApiEndPoints.freeCode}$repoName/${ApiEndPoints.commits}",
        ),
      );
      repositorycommitList = repoCommitModelFromJson(response);
    } on AppException catch (e) {
      throw e.getMessage;
    } catch (e) {
      rethrow;
    }
  }
}
