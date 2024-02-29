import 'package:cvworld/client/datasource/http/http.manager.dart';
import 'package:cvworld/client/datasource/mapping.dart';
import 'package:cvworld/client/datasource/mutation.dart';
import 'package:cvworld/client/datasource/schema.dart';
import 'package:cvworld/client/utils.dart';

class TemplatePageController {
  ///
  ///
  /// Get all templates
  Stream<ModelStore<List<Template>>> getTemplates() {
    RootToTemplatesMapping mapper = RootToTemplatesMapping.getInstance();
    String? userId = ApplicationToken.getInstance().getUserId;
    return mapper.get(Constants.rootNodeId).getTemplates(userId ?? '');
  }

  ///
  ///
  /// Search
  void search(String query) {
    RootToTemplatesMapping mapper = RootToTemplatesMapping.getInstance();
    return mapper.get(Constants.rootNodeId).search(query);
  }

  ///
  ///
  /// Add to like
  void addToLike(Template template) {
    ApplicationMutation.getInstance().dispatch(ApplicationMutationData(ApplicationMutationIdentifier.ADD_FAVORITE, template));
  }

  ///
  ///
  /// Remove from like
  void removeFromLike(Template template) {
    ApplicationMutation.getInstance().dispatch(ApplicationMutationData(ApplicationMutationIdentifier.REMOVE_FAVORITE, template));
  }

  ///
  ///
  /// Add to default
  void addToDefault(Template template) {
    ApplicationMutation.getInstance().dispatch(ApplicationMutationData(ApplicationMutationIdentifier.ADD_DEFAULT_TEMPLATE, template));
  }

  ///
  ///
  /// Remove from default
  void removeFromDefault(Template template) {
    ApplicationMutation.getInstance().dispatch(ApplicationMutationData(ApplicationMutationIdentifier.REMOVE_DEFAULT_TEMPLATE, template));
  }
}
