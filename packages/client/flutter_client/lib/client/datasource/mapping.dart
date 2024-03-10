import 'package:cvworld/client/datasource/models/favorite.model.dart';
import 'package:cvworld/client/datasource/models/feedback.model.dart';
import 'package:cvworld/client/datasource/models/subscription-plan.model.dart';
import 'package:cvworld/client/datasource/models/subscription.model.dart';
import 'package:cvworld/client/datasource/models/template.model.dart';
import 'package:cvworld/client/datasource/models/transaction.model.dart';
import 'package:cvworld/client/datasource/models/user.model.dart';

///
///
///
/// Root to feedback mapping
class RootToFeedbackMapping {
  static final RootToFeedbackMapping _instance = RootToFeedbackMapping._();
  final Map<String, FeedbackModel> _mappingData = <String, FeedbackModel>{};

  RootToFeedbackMapping._();

  factory RootToFeedbackMapping.getInstance() {
    return _instance;
  }

  // Get model
  FeedbackModel get(String id) {
    if (_mappingData.containsKey(id)) {
      return _mappingData[id]!;
    } else {
      _mappingData[id] = FeedbackModel(nodeId: id);
      return _mappingData[id]!;
    }
  }

  // Dispose
  void dispose() {
    _mappingData.clear();
  }
}

///
///
///
/// User to favorite mapping
class UserToFavoriteMapping {
  static final UserToFavoriteMapping _instance = UserToFavoriteMapping._();
  final Map<String, FavoriteModel> _mappingData = <String, FavoriteModel>{};

  UserToFavoriteMapping._();

  factory UserToFavoriteMapping.getInstance() {
    return _instance;
  }

  // Get model
  FavoriteModel get(String id) {
    if (_mappingData.containsKey(id)) {
      return _mappingData[id]!;
    } else {
      _mappingData[id] = FavoriteModel(nodeId: id);
      return _mappingData[id]!;
    }
  }

  // Dispose
  void dispose() {
    _mappingData.clear();
  }
}

///
///
///
/// Root to user mapping
class RootToUserMapping {
  static final RootToUserMapping _instance = RootToUserMapping._();
  final Map<String, UserModel> _mappingData = <String, UserModel>{};

  RootToUserMapping._();

  factory RootToUserMapping.getInstance() {
    return _instance;
  }

  // Get model
  UserModel get(String id) {
    if (_mappingData.containsKey(id)) {
      return _mappingData[id]!;
    } else {
      _mappingData[id] = UserModel(nodeId: id);
      return _mappingData[id]!;
    }
  }

  // Dispose
  void dispose() {
    _mappingData.clear();
  }
}

///
///
/// User to subscription mapping
class UserToSubscriptionMapping {
  static final UserToSubscriptionMapping _instance = UserToSubscriptionMapping._();
  final Map<String, SubscriptionModel> _mappingData = <String, SubscriptionModel>{};

  UserToSubscriptionMapping._();

  factory UserToSubscriptionMapping.getInstance() {
    return _instance;
  }

  // Get model
  SubscriptionModel get(String id) {
    if (_mappingData.containsKey(id)) {
      return _mappingData[id]!;
    } else {
      _mappingData[id] = SubscriptionModel(nodeId: id);
      return _mappingData[id]!;
    }
  }

  // Dispose
  void dispose() {
    _mappingData.clear();
  }
}

///
///
/// Root to subscription plan mapping
class RootToSubscriptionPlanMapping {
  static final RootToSubscriptionPlanMapping _instance = RootToSubscriptionPlanMapping._();
  final Map<String, SubscriptionPlanModel> _mappingData = <String, SubscriptionPlanModel>{};

  RootToSubscriptionPlanMapping._();

  factory RootToSubscriptionPlanMapping.getInstance() {
    return _instance;
  }

  // Get model
  SubscriptionPlanModel get(String id) {
    if (_mappingData.containsKey(id)) {
      return _mappingData[id]!;
    } else {
      _mappingData[id] = SubscriptionPlanModel(nodeId: id);
      return _mappingData[id]!;
    }
  }

  // Dispose
  void dispose() {
    _mappingData.clear();
  }
}

///
///
/// Root to templates mapping
class RootToTemplatesMapping {
  static final RootToTemplatesMapping _instance = RootToTemplatesMapping._();
  final Map<String, TemplateModel> _mappingData = <String, TemplateModel>{};

  RootToTemplatesMapping._();

  factory RootToTemplatesMapping.getInstance() {
    return _instance;
  }

  // Get model
  TemplateModel get(String id) {
    if (_mappingData.containsKey(id)) {
      return _mappingData[id]!;
    } else {
      _mappingData[id] = TemplateModel(nodeId: id);
      return _mappingData[id]!;
    }
  }

  // Dispose
  void dispose() {
    _mappingData.clear();
  }
}

///
///
/// Root to transaction mapping
class RootToTransactionMapping {
  static final RootToTransactionMapping _instance = RootToTransactionMapping._();
  final Map<String, TransactionModel> _mappingData = <String, TransactionModel>{};

  RootToTransactionMapping._();

  factory RootToTransactionMapping.getInstance() {
    return _instance;
  }

  // Get model
  TransactionModel get(String id) {
    if (_mappingData.containsKey(id)) {
      return _mappingData[id]!;
    } else {
      _mappingData[id] = TransactionModel(nodeId: id);
      return _mappingData[id]!;
    }
  }

  // Dispose
  void dispose() {
    _mappingData.clear();
  }
}
